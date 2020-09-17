Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B0726E0DE
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgIQQiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:38:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:7509 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbgIQQhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:37:40 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 12:37:39 EDT
IronPort-SDR: IH7fwMyBW16jk7KacROESBqmaq2y1CkVd3tG+FMEHV4HhN6syD+a2/lWBgXyaBfmfR3yiNePvY
 mbPmiMQ3yZLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="160660856"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="160660856"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:29:45 -0700
IronPort-SDR: gn/KSpAbMBSgBwaK1L10/ocDUzlNBiPJXg9sQ+idOEzYsmEgRqss7+LiDVfLtilmKC+yXSq0q2
 COZXnykra9sg==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="452376324"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:29:45 -0700
Date:   Thu, 17 Sep 2020 09:29:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 2/2] KVM: nSVM: implement ondemand allocation of the
 nested state
Message-ID: <20200917162942.GE13522@sjchrist-ice>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
 <20200917101048.739691-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917101048.739691-3-mlevitsk@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 01:10:48PM +0300, Maxim Levitsky wrote:
> This way we don't waste memory on VMs which don't use
> nesting virtualization even if it is available to them.
> 
> If allocation of nested state fails (which should happen,
> only when host is about to OOM anyway), use new KVM_REQ_OUT_OF_MEMORY
> request to shut down the guest
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    | 54 ++++++++++++++++++++++-----------------
>  arch/x86/kvm/svm/svm.h    |  7 +++++
>  3 files changed, 79 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 09417f5197410..fe119da2ef836 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -467,6 +467,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  
>  	vmcb12 = map.hva;
>  
> +	if (WARN_ON(!svm->nested.initialized))
> +		return 1;
> +
>  	if (!nested_vmcb_checks(svm, vmcb12)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
> @@ -684,6 +687,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	return 0;
>  }
>  
> +int svm_allocate_nested(struct vcpu_svm *svm)
> +{
> +	struct page *hsave_page;
> +
> +	if (svm->nested.initialized)
> +		return 0;
> +
> +	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!hsave_page)
> +		goto error;

goto is unnecessary, just do

		return -ENOMEM;

> +
> +	svm->nested.hsave = page_address(hsave_page);
> +
> +	svm->nested.msrpm = svm_vcpu_init_msrpm();
> +	if (!svm->nested.msrpm)
> +		goto err_free_hsave;
> +
> +	svm->nested.initialized = true;
> +	return 0;
> +err_free_hsave:
> +	__free_page(hsave_page);
> +error:
> +	return 1;

As above, -ENOMEM would be preferable.

> +}
> +
> +void svm_free_nested(struct vcpu_svm *svm)
> +{
> +	if (!svm->nested.initialized)
> +		return;
> +
> +	svm_vcpu_free_msrpm(svm->nested.msrpm);
> +	svm->nested.msrpm = NULL;
> +
> +	__free_page(virt_to_page(svm->nested.hsave));
> +	svm->nested.hsave = NULL;
> +
> +	svm->nested.initialized = false;
> +}
> +
>  /*
>   * Forcibly leave nested mode in order to be able to reset the VCPU later on.
>   */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3da5b2f1b4a19..57ea4407dcf09 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -266,6 +266,7 @@ static int get_max_npt_level(void)
>  void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	u64 old_efer = vcpu->arch.efer;
>  	vcpu->arch.efer = efer;
>  
>  	if (!npt_enabled) {
> @@ -276,9 +277,26 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  			efer &= ~EFER_LME;
>  	}
>  
> -	if (!(efer & EFER_SVME)) {
> -		svm_leave_nested(svm);
> -		svm_set_gif(svm, true);
> +	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
> +		if (!(efer & EFER_SVME)) {
> +			svm_leave_nested(svm);
> +			svm_set_gif(svm, true);
> +
> +			/*
> +			 * Free the nested state unless we are in SMM, in which
> +			 * case the exit from SVM mode is only for duration of the SMI
> +			 * handler
> +			 */
> +			if (!is_smm(&svm->vcpu))
> +				svm_free_nested(svm);
> +
> +		} else {
> +			if (svm_allocate_nested(svm)) {
> +				vcpu->arch.efer = old_efer;
> +				kvm_make_request(KVM_REQ_OUT_OF_MEMORY, vcpu);

I really dislike KVM_REQ_OUT_OF_MEMORY.  It's redundant with -ENOMEM and
creates a huge discrepancy with respect to existing code, e.g. nVMX returns
-ENOMEM in a similar situation.

The deferred error handling creates other issues, e.g. vcpu->arch.efer is
unwound but the guest's RIP is not.

One thought for handling this without opening a can of worms would be to do:

	r = kvm_x86_ops.set_efer(vcpu, efer);
	if (r) {
		WARN_ON(r > 0);
		return r;
	}

I.e. go with the original approach, but only for returning errors that will
go all the way out to userspace.

> +				return;
> +			}
> +		}
>  	}
>  
>  	svm->vmcb->save.efer = efer | EFER_SVME;
