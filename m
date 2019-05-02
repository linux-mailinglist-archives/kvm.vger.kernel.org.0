Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225A111C1C
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 17:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfEBPDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 11:03:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:5377 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBPDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 11:03:19 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 08:03:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,422,1549958400"; 
   d="scan'208";a="169964558"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga001.fm.intel.com with ESMTP; 02 May 2019 08:03:16 -0700
Date:   Thu, 2 May 2019 08:03:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jintack Lim <jintack@cs.columbia.edu>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in
 vmcs02
Message-ID: <20190502150315.GB26138@linux.intel.com>
References: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Cc Jim

On Wed, May 01, 2019 at 10:09:19PM -0400, Jintack Lim wrote:
> Even when neither L0 nor L1 configured to trap MSR_FS_BASE writes from
> its own VMs, the current KVM L0 always traps MSR_FS_BASE writes from L2.
> Let's check if both L0 and L1 disabled trap for MSR_FS_BASE for its VMs
> respectively, and let L2 write to MSR_FS_BASE without trap if that's the
> case.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/x86/kvm/vmx/nested.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0c601d0..ab85aea 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -537,6 +537,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	 */
>  	bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
>  	bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
> +	bool fs_base = !msr_write_intercepted_l01(vcpu, MSR_FS_BASE);

This isn't sufficient as we only fall into this code if L2 is in x2APIC
mode or has accessed the speculation MSRs.  The quick fix is to check if
we want to pass through MSR_FS_BASE, but if we're going to open up the
floodgates then we should pass through as many MSRs as possible, e.g.
GS_BASE, KERNEL_GS_BASE, TSC, SYSENTER_*, etc..., and do so using a
generic mechanism.

That being said, I think there are other reasons why KVM doesn't pass
through MSRs to L2.  Unfortunately, I'm struggling to recall what those
reasons are.

Jim, I'm pretty sure you've looked at this code a lot, do you happen to
know off hand?  Is it purely a performance thing to avoid merging bitmaps
on every nested entry, is there a subtle bug/security hole, or is it
simply that no one has ever gotten around to writing the code?

>  
>  	/* Nothing to do if the MSR bitmap is not in use.  */
>  	if (!cpu_has_vmx_msr_bitmap() ||
> @@ -592,6 +593,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> +	if (fs_base)
> +		nested_vmx_disable_intercept_for_msr(
> +					msr_bitmap_l1, msr_bitmap_l0,
> +					MSR_FS_BASE,
> +					MSR_TYPE_W);

This should be MSR_TYPE_RW.

> +
>  	if (spec_ctrl)
>  		nested_vmx_disable_intercept_for_msr(
>  					msr_bitmap_l1, msr_bitmap_l0,
> -- 
> 1.9.1
> 
> 
