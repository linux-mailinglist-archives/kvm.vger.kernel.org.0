Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10966AC2E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfGPPs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:48:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:23500 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbfGPPs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:48:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 08:48:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="172578432"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga006.jf.intel.com with ESMTP; 16 Jul 2019 08:48:55 -0700
Date:   Tue, 16 Jul 2019 08:48:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        brijesh.singh@amd.com, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: Rename need_emulation_on_page_fault() to
 handle_no_insn_on_page_fault()
Message-ID: <20190716154855.GA1987@linux.intel.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-3-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715203043.100483-3-liran.alon@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 11:30:43PM +0300, Liran Alon wrote:
> I think this name is more appropriate to what the x86_ops method does.
> In addition, modify VMX callback to return true as #PF handler can
> proceed to emulation in this case. This didn't result in a bug
> only because the callback is called when DecodeAssist is supported
> which is currently supported only on SVM.
> 
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/mmu.c              | 2 +-
>  arch/x86/kvm/svm.c              | 4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 6 +++---
>  4 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 450d69a1e6fa..536fd56f777d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1201,7 +1201,8 @@ struct kvm_x86_ops {
>  				   uint16_t *vmcs_version);
>  	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>  
> -	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> +	/* Returns true if #PF handler can proceed to emulation */
> +	bool (*handle_no_insn_on_page_fault)(struct kvm_vcpu *vcpu);

The problem with this name is that it requires a comment to explain the
boolean return value.  The VMX implementation particular would be
inscrutuable.

"no insn" is also a misnomer, as the AMD quirk has an insn, it's the
insn_len that's missing.

What about something like force_emulation_on_zero_len_insn()?

>  };
>  
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 1e9ba81accba..889de3ccf655 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5423,7 +5423,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
>  	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
>  	 */
>  	if (unlikely(insn && !insn_len)) {
> -		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
> +		if (!kvm_x86_ops->handle_no_insn_on_page_fault(vcpu))
>  			return 1;
>  	}
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 79023a41f7a7..ab89bb0de8df 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7118,7 +7118,7 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  	return -ENODEV;
>  }
>  
> -static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> +static bool svm_handle_no_insn_on_page_fault(struct kvm_vcpu *vcpu)
>  {
>  	bool is_user, smap;
>  
> @@ -7291,7 +7291,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.nested_enable_evmcs = nested_enable_evmcs,
>  	.nested_get_evmcs_version = nested_get_evmcs_version,
>  
> -	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> +	.handle_no_insn_on_page_fault = svm_handle_no_insn_on_page_fault,
>  };
>  
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f64bcbb03906..088fc6d943e9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7419,9 +7419,9 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> +static bool vmx_handle_no_insn_on_page_fault(struct kvm_vcpu *vcpu)
>  {
> -	return 0;
> +	return true;

Any functional change here should be done in a different patch.

Given that we should never reach this point on VMX, a WARN and triple
fault request seems in order.

	WARN_ON_ONCE(1);

	kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
	return false;

>  }
>  
>  static __init int hardware_setup(void)
> @@ -7726,7 +7726,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.set_nested_state = NULL,
>  	.get_vmcs12_pages = NULL,
>  	.nested_enable_evmcs = NULL,
> -	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> +	.handle_no_insn_on_page_fault = vmx_handle_no_insn_on_page_fault,
>  };
>  
>  static void vmx_cleanup_l1d_flush(void)
> -- 
> 2.20.1
> 
