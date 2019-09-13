Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA35B1718
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 03:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfIMByF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 21:54:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:31929 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfIMByF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 21:54:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 18:54:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,499,1559545200"; 
   d="scan'208";a="186304831"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 12 Sep 2019 18:54:03 -0700
Date:   Thu, 12 Sep 2019 18:54:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: Re: [PATCH] KVM: x86: Handle unexpected MMIO accesses using master
 abort semantics
Message-ID: <20190913015403.GB6588@linux.intel.com>
References: <20190912235603.18954-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912235603.18954-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 04:56:03PM -0700, Sean Christopherson wrote:
> Use master abort semantics, i.e. reads return all ones and writes are
> dropped, to handle unexpected MMIO accesses when reading guest memory
> instead of returning X86EMUL_IO_NEEDED, which in turn gets interpreted
> as a guest page fault.
> 
> Emulation of certain instructions, notably VMX instructions, involves
> reading or writing guest memory without going through the emulator.
> These emulation flows are not equipped to handle MMIO accesses as no
> sane and properly functioning guest kernel will target MMIO with such
> instructions, and so simply inject a page fault in response to
> X86EMUL_IO_NEEDED.
> 
> While not 100% correct, using master abort semantics is at least
> sometimes correct, e.g. non-existent MMIO accesses do actually master
> abort, whereas injecting a page fault is always wrong, i.e. the issue
> lies in the physical address domain, not in the virtual to physical
> translation.
> 
> Apply the logic to kvm_write_guest_virt_system() in addition to
> replacing existing #PF logic in kvm_read_guest_virt(), as VMPTRST uses
> the former, i.e. can also leak a host stack address.
> 
> Reported-by: Fuqian Huang <huangfq.daxian@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd786d0b6..d1d7e9fac17a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5234,16 +5234,24 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>  			       struct x86_exception *exception)
>  {
>  	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	int r;
> +
> +	r = kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
> +				       exception);
>  
>  	/*
> -	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> -	 * is returned, but our callers are not ready for that and they blindly
> -	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
> -	 * uninitialized kernel stack memory into cr2 and error code.
> +	 * FIXME: this should technically call out to userspace to handle the
> +	 * MMIO access, but our callers are not ready for that, so emulate
> +	 * master abort behavior instead, i.e. writes are dropped.

Dagnabbit, fixed this to make it 'reads return all ones' and forgot to
commit..  v2 on its way.

>  	 */
> -	memset(exception, 0, sizeof(*exception));
> -	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
> -					  exception);
> +	if (r == X86EMUL_IO_NEEDED) {
> +		memset(val, 0xff, bytes);
> +		return 0;
> +	}
> +	if (r == X86EMUL_PROPAGATE_FAULT)
> +		return -EFAULT;
> +	WARN_ON_ONCE(r);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
>  
> @@ -5317,11 +5325,25 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
>  int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>  				unsigned int bytes, struct x86_exception *exception)
>  {
> +	int r;
> +
>  	/* kvm_write_guest_virt_system can pull in tons of pages. */
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
> -	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> -					   PFERR_WRITE_MASK, exception);
> +	r = kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> +					PFERR_WRITE_MASK, exception);
> +
> +	/*
> +	 * FIXME: this should technically call out to userspace to handle the
> +	 * MMIO access, but our callers are not ready for that, so emulate
> +	 * master abort behavior instead, i.e. writes are dropped.
> +	 */
> +	if (r == X86EMUL_IO_NEEDED)
> +		return 0;
> +	if (r == X86EMUL_PROPAGATE_FAULT)
> +		return -EFAULT;
> +	WARN_ON_ONCE(r);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
>  
> -- 
> 2.22.0
> 
