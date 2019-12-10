Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E42119698
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 22:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfLJV1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 16:27:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:7237 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfLJV1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 16:27:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 13:27:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="264657141"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Dec 2019 13:27:48 -0800
Date:   Tue, 10 Dec 2019 13:27:48 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 6/7] KVM: X86: Load guest fpu state when accessing
 MSRs managed by XSAVES
Message-ID: <20191210212748.GN15758@linux.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-7-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101085222.27997-7-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 04:52:21PM +0800, Yang Weijiang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> A handful of CET MSRs are not context switched through "traditional"
> methods, e.g. VMCS or manual switching, but rather are passed through
> to the guest and are saved and restored by XSAVES/XRSTORS, i.e. the
> guest's FPU state.
> 
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES so that the MSR helper, e.g. vmx_{get,set}_msr(),
> can simply do {RD,WR}MSR to access the guest's value.
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed
> to access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 540490d5385f..6275a75d5802 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -104,6 +104,8 @@ static void enter_smm(struct kvm_vcpu *vcpu);
>  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
>  static void store_regs(struct kvm_vcpu *vcpu);
>  static int sync_regs(struct kvm_vcpu *vcpu);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
>  
>  struct kvm_x86_ops *kvm_x86_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_x86_ops);
> @@ -3000,6 +3002,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>  
> +static bool is_xsaves_msr(u32 index)
> +{
> +	return index == MSR_IA32_U_CET ||
> +	       (index >= MSR_IA32_PL0_SSP && index <= MSR_IA32_PL3_SSP);
> +}
> +
>  /*
>   * Read or write a bunch of msrs. All parameters are kernel addresses.
>   *
> @@ -3010,11 +3018,22 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>  		    int (*do_msr)(struct kvm_vcpu *vcpu,
>  				  unsigned index, u64 *data))
>  {
> +	bool fpu_loaded = false;
>  	int i;
> +	const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> +	bool cet_xss = kvm_supported_xss() & cet_bits;
>  
> -	for (i = 0; i < msrs->nmsrs; ++i)
> +	for (i = 0; i < msrs->nmsrs; ++i) {
> +		if (!fpu_loaded && cet_xss &&
> +		    is_xsaves_msr(entries[i].index)) {
> +			kvm_load_guest_fpu(vcpu);

This needs to also check for a non-NULL @vcpu.  KVM_GET_MSR can be called
on the VM to invoke do_get_msr_feature().

> +			fpu_loaded = true;
> +		}
>  		if (do_msr(vcpu, entries[i].index, &entries[i].data))
>  			break;
> +	}
> +	if (fpu_loaded)
> +		kvm_put_guest_fpu(vcpu);
>  
>  	return i;
>  }
> -- 
> 2.17.2
> 
