Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF825151203
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 22:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgBCVnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 16:43:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:38302 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgBCVnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 16:43:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 13:43:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278868982"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 13:43:01 -0800
Date:   Mon, 3 Feb 2020 13:43:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 5/6] kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
Message-ID: <20200203214300.GI19638@linux.intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-6-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203151608.28053-6-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 11:16:07PM +0800, Xiaoyao Li wrote:
> Emulate MSR_IA32_CORE_CAPABILITIES in software and unconditionally
> advertise its support to userspace. Like MSR_IA32_ARCH_CAPABILITIES, it
> is a feature-enumerating MSR and can be fully emulated regardless of
> hardware support. Existence of CORE_CAPABILITIES is enumerated via
> CPUID.(EAX=7H,ECX=0):EDX[30].
> 
> Note, support for individual features enumerated via CORE_CAPABILITIES,
> e.g., split lock detection, will be added in future patches.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            |  5 +++--
>  arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++++
>  3 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 329d01c689b7..dc231240102f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -591,6 +591,7 @@ struct kvm_vcpu_arch {
>  	u64 ia32_xss;
>  	u64 microcode_version;
>  	u64 arch_capabilities;
> +	u64 core_capabilities;
>  
>  	/*
>  	 * Paging state of the vcpu
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..7282d04f3a6b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -409,10 +409,11 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>  		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  			entry->edx |= F(SPEC_CTRL_SSBD);
>  		/*
> -		 * We emulate ARCH_CAPABILITIES in software even
> -		 * if the host doesn't support it.
> +		 * ARCH_CAPABILITIES and CORE_CAPABILITIES are emulated in
> +		 * software regardless of host support.
>  		 */
>  		entry->edx |= F(ARCH_CAPABILITIES);
> +		entry->edx |= F(CORE_CAPABILITIES);
>  		break;
>  	case 1:
>  		entry->eax &= kvm_cpuid_7_1_eax_x86_features;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 821b7404c0fd..a97a8f5dd1df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1222,6 +1222,7 @@ static const u32 emulated_msrs_all[] = {
>  	MSR_IA32_TSC_ADJUST,
>  	MSR_IA32_TSCDEADLINE,
>  	MSR_IA32_ARCH_CAPABILITIES,
> +	MSR_IA32_CORE_CAPS,
>  	MSR_IA32_MISC_ENABLE,
>  	MSR_IA32_MCG_STATUS,
>  	MSR_IA32_MCG_CTL,
> @@ -1288,6 +1289,7 @@ static const u32 msr_based_features_all[] = {
>  	MSR_F10H_DECFG,
>  	MSR_IA32_UCODE_REV,
>  	MSR_IA32_ARCH_CAPABILITIES,
> +	MSR_IA32_CORE_CAPS,
>  };
>  
>  static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
> @@ -1341,12 +1343,20 @@ static u64 kvm_get_arch_capabilities(void)
>  	return data;
>  }
>  
> +static u64 kvm_get_core_capabilities(void)
> +{
> +	return 0;
> +}
> +
>  static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>  {
>  	switch (msr->index) {
>  	case MSR_IA32_ARCH_CAPABILITIES:
>  		msr->data = kvm_get_arch_capabilities();
>  		break;
> +	case MSR_IA32_CORE_CAPS:
> +		msr->data = kvm_get_core_capabilities();
> +		break;
>  	case MSR_IA32_UCODE_REV:
>  		rdmsrl_safe(msr->index, &msr->data);
>  		break;
> @@ -2716,6 +2726,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		vcpu->arch.arch_capabilities = data;
>  		break;
> +	case MSR_IA32_CORE_CAPS:
> +		if (!msr_info->host_initiated)

Shouldn't @data be checked against kvm_get_core_capabilities()?

> +			return 1;
> +		vcpu->arch.core_capabilities = data;
> +		break;
>  	case MSR_EFER:
>  		return set_efer(vcpu, msr_info);
>  	case MSR_K7_HWCR:
> @@ -3044,6 +3059,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		msr_info->data = vcpu->arch.arch_capabilities;
>  		break;
> +	case MSR_IA32_CORE_CAPS:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_CORE_CAPABILITIES))
> +			return 1;
> +		msr_info->data = vcpu->arch.core_capabilities;
> +		break;
>  	case MSR_IA32_POWER_CTL:
>  		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
>  		break;
> @@ -9288,6 +9309,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  		goto free_guest_fpu;
>  
>  	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
> +	vcpu->arch.core_capabilities = kvm_get_core_capabilities();
>  	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>  	kvm_vcpu_mtrr_init(vcpu);
>  	vcpu_load(vcpu);
> -- 
> 2.23.0
> 
