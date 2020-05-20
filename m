Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13F31DBCB1
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgETSWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 14:22:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:26022 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgETSWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 14:22:03 -0400
IronPort-SDR: k+XpoKoyxS21PqszC+TqRT1jkDUQCHiqxqN5qY5qYJwHAs/pmWZuj3Td1HDkJzkJjuL+ohxKmo
 YsR6/O64aFMw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 11:22:02 -0700
IronPort-SDR: yjb45754xoVgNIo15aUWz/vwmBtp4gTrIfXSSs1wy6BSvyf2WIW38nF4XRRokl4vtW+O3wUzZy
 sipOY35ZrhGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="268356630"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2020 11:22:02 -0700
Date:   Wed, 20 May 2020 11:22:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 21/24] KVM: x86: always update CR3 in VMCB
Message-ID: <20200520182202.GB18102@linux.intel.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-22-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520172145.23284-22-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 01:21:42PM -0400, Paolo Bonzini wrote:
> vmx_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02 as
> an optimization, but this is only correct before the nested vmentry.
> If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
> already been put in guest mode, the value of CR3 will not be updated.
> Remove the optimization, which almost never triggers anyway.
> 
> This also applies to SVM, where the code was added in commit 689f3bf21628
> ("KVM: x86: unify callbacks to load paging root", 2020-03-16) just to keep the
> two vendor-specific modules closer.
> 
> Fixes: 04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
> Fixes: 689f3bf21628 ("KVM: x86: unify callbacks to load paging root")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 55712dd86baf..7daf6a50e774 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3085,10 +3085,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
>  			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  		}
>  
> -		/* Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter. */
> -		if (is_guest_mode(vcpu))
> -			update_guest_cr3 = false;
> -		else if (!enable_unrestricted_guest && !is_paging(vcpu))
> +		if (!enable_unrestricted_guest && !is_paging(vcpu))
>  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
>  		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))

As an alternative fix, what about marking VCPU_EXREG_CR3 dirty in
__set_sregs()?  E.g.

		/*
		 * Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter, but
		 * it can be explicitly dirtied by KVM_SET_SREGS.
		 */
		if (is_guest_mode(vcpu) &&
		    !test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_dirty))

There's already a dependency on __set_sregs() doing
kvm_register_mark_available() before kvm_mmu_reset_context(), i.e. the
code is already a bit kludgy.  The dirty check would make the kludge less
subtle and provide explicit documentation.

>  			guest_cr3 = vcpu->arch.cr3;

The comment that's just below the context is now stale, e.g. replace
vmcs01.GUEST_CR3 with vmcs.GUEST_CR3.

> -- 
> 2.18.2
> 
> 
