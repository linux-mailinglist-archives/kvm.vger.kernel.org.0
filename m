Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657AA16AB9D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 17:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBXQdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 11:33:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727299AbgBXQdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 11:33:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582561979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yujg2WJh022n2Av/aDpvy071zDfgljr6qFBy0yuGLSA=;
        b=XYX4W8rQzK7wSb+7X5jW91nbzZeAuD+MmptA34zM9CUX5pEmoaRVHPmsqha7umRhYCwWVG
        8/krmkEub8FqSVg6gz1TPfkKQPf9+yZ0lZJwzjBla8pi7+R8Sf4DiI16fzmA0lFPD6QaGj
        GkWWCn2HcjEHi70moAjF2SM9X5nLBPA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-AQtsqKWEOMKSYbS_EFI12w-1; Mon, 24 Feb 2020 11:32:58 -0500
X-MC-Unique: AQtsqKWEOMKSYbS_EFI12w-1
Received: by mail-wr1-f69.google.com with SMTP id 90so5839720wrq.6
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 08:32:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yujg2WJh022n2Av/aDpvy071zDfgljr6qFBy0yuGLSA=;
        b=t7r8WrB43gEIY8ctgPb08ruk4GJ7gBYYv7dgj3F6aTFD3P54ndwKRGS0+NGOEtcbFw
         EBegAJYvO0Io51UE+EfWZJc2/V4DUyytpx8uKjZ5wc9WXKZNRYhOcs4A95pQFOPCwX8j
         MwG1buHLiYoskfT+e5Q+ILnKSGu4kM05sYZXEU1q8dTA/LDsm8WHOz0pqLNiQYLuhiAf
         ScHmrBjxf2nFku2oZG3u6+TStGJPSuT+CB4b6oYho8MNuwpyA2Fr7WEUX2Z/xiQM8QNK
         JqOvrIOQaVKQXjp0PySH5I80B1yHg33ozSpWu8GsxmsbZuSwiqVy//h1n+1ci013qss5
         lWsQ==
X-Gm-Message-State: APjAAAV2VsdYlbhzCUT9P5TG8bsFitkVjpz2eG8uYyXvwGghTUhzEw3k
        a/Sxkk822iSCd5h4WggV2q/GxF4h60AVDgf/p/s/VdAGmmNSCu5Fh2wgjTGk7POsC4KoGgC1rH0
        k4ukkZc+XLrN0
X-Received: by 2002:a5d:4a0f:: with SMTP id m15mr68213206wrq.415.1582561976231;
        Mon, 24 Feb 2020 08:32:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzvFGwibVSDrP8AcTkfG6GGaZZ4iMGyxYIdKVa/WlNn8lcezeJjH/hEy3BhblH/SWMiHGYhvg==
X-Received: by 2002:a5d:4a0f:: with SMTP id m15mr68213174wrq.415.1582561975843;
        Mon, 24 Feb 2020 08:32:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y6sm19124263wrl.17.2020.02.24.08.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:32:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/61] KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking
In-Reply-To: <20200201185218.24473-39-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-39-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 17:32:54 +0100
Message-ID: <87h7zgndxl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Calculate the CPUID masks for KVM_GET_SUPPORTED_CPUID at load time using
> what is effectively a KVM-adjusted copy of boot_cpu_data, or more
> precisely, the x86_capability array in boot_cpu_data.
>
> In terms of KVM support, the vast majority of CPUID feature bits are
> constant, and *all* feature support is known at KVM load time.  Rather
> than apply boot_cpu_data, which is effectively read-only after init,
> at runtime, copy it into a KVM-specific array and use *that* to mask
> CPUID registers.
>
> In additional to consolidating the masking, kvm_cpu_caps can be adjusted
> by SVM/VMX at load time and thus eliminate all feature bit manipulation
> in ->set_supported_cpuid().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 229 +++++++++++++++++++++++--------------------
>  arch/x86/kvm/cpuid.h |  19 ++++
>  arch/x86/kvm/x86.c   |   2 +
>  3 files changed, 142 insertions(+), 108 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 20a7af320291..c2a4c9df49a9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -24,6 +24,13 @@
>  #include "trace.h"
>  #include "pmu.h"
>  
> +/*
> + * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
> + * aligned to sizeof(unsigned long) because it's not accessed via bitops.
> + */
> +u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
> +EXPORT_SYMBOL_GPL(kvm_cpu_caps);
> +
>  static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  {
>  	int feature_bit = 0;
> @@ -259,7 +266,119 @@ static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
>  {
>  	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
>  
> -	*reg &= boot_cpu_data.x86_capability[leaf];
> +	BUILD_BUG_ON(leaf > ARRAY_SIZE(kvm_cpu_caps));

Should this be '>=' ?

> +	*reg &= kvm_cpu_caps[leaf];
> +}
> +
> +static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
> +{
> +	reverse_cpuid_check(leaf);
> +	kvm_cpu_caps[leaf] &= mask;
> +}
> +
> +void kvm_set_cpu_caps(void)
> +{
> +	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
> +#ifdef CONFIG_X86_64
> +	unsigned f_gbpages = F(GBPAGES);
> +	unsigned f_lm = F(LM);
> +#else
> +	unsigned f_gbpages = 0;
> +	unsigned f_lm = 0;
> +#endif

Three too many bare 'unsinged's :-)

> +
> +	BUILD_BUG_ON(sizeof(kvm_cpu_caps) >
> +		     sizeof(boot_cpu_data.x86_capability));
> +
> +	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
> +	       sizeof(kvm_cpu_caps));
> +
> +	kvm_cpu_cap_mask(CPUID_1_EDX,
> +		F(FPU) | F(VME) | F(DE) | F(PSE) |
> +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
> +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> +		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
> +		0 /* Reserved, DS, ACPI */ | F(MMX) |
> +		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
> +		0 /* HTT, TM, Reserved, PBE */
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> +		F(FPU) | F(VME) | F(DE) | F(PSE) |
> +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> +		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> +		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> +		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
> +		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_1_ECX,
> +		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
> +		 * but *not* advertised to guests via CPUID ! */
> +		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
> +		0 /* DS-CPL, VMX, SMX, EST */ |
> +		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
> +		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
> +		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> +		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
> +		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> +		F(F16C) | F(RDRAND)
> +	);

I would suggest we order things by CPUID_NUM here, i.e.

CPUID_1_ECX
CPUID_1_EDX
CPUID_7_1_EAX
CPUID_7_0_EBX
CPUID_7_ECX
CPUID_7_EDX
CPUID_D_1_EAX
...

> +
> +	kvm_cpu_cap_mask(CPUID_7_0_EBX,
> +		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> +		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
> +		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
> +		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> +		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_7_ECX,
> +		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
> +		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> +		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> +		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
> +	);
> +	/* Set LA57 based on hardware capability. */
> +	if (cpuid_ecx(7) & F(LA57))
> +		kvm_cpu_cap_set(X86_FEATURE_LA57);
> +
> +	kvm_cpu_cap_mask(CPUID_7_EDX,
> +		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> +		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> +		F(MD_CLEAR)
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> +		F(AVX512_BF16)
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_D_1_EAX,
> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> +		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
> +		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> +		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
> +		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
> +		F(TOPOEXT) | F(PERFCTR_CORE)
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
> +		F(CLZERO) | F(XSAVEERPTR) |
> +		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> +		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
> +	);
> +
> +	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
> +		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
> +		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
> +		F(PMM) | F(PMM_EN)
> +	);
>  }
>  
>  struct kvm_cpuid_array {
> @@ -339,48 +458,13 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  
>  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  {
> -	unsigned f_la57;
> -
> -	/* cpuid 7.0.ebx */
> -	const u32 kvm_cpuid_7_0_ebx_x86_features =
> -		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> -		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
> -		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
> -		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> -		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/;
> -
> -	/* cpuid 7.0.ecx*/
> -	const u32 kvm_cpuid_7_0_ecx_x86_features =
> -		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
> -		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> -		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> -		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
> -
> -	/* cpuid 7.0.edx*/
> -	const u32 kvm_cpuid_7_0_edx_x86_features =
> -		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> -		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR);
> -
> -	/* cpuid 7.1.eax */
> -	const u32 kvm_cpuid_7_1_eax_x86_features =
> -		F(AVX512_BF16);
> -
>  	switch (entry->index) {
>  	case 0:
>  		entry->eax = min(entry->eax, 1u);
> -		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_7_0_EBX);
>  		/* TSC_ADJUST is emulated */
>  		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
> -
> -		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
> -		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
>  		cpuid_entry_mask(entry, CPUID_7_ECX);
> -		/* Set LA57 based on hardware capability. */
> -		entry->ecx |= f_la57;
> -
> -		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_7_EDX);
>  		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
>  			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
> @@ -395,7 +479,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
>  		break;
>  	case 1:
> -		entry->eax &= kvm_cpuid_7_1_eax_x86_features;
> +		cpuid_entry_mask(entry, CPUID_7_1_EAX);
>  		entry->ebx = 0;
>  		entry->ecx = 0;
>  		entry->edx = 0;
> @@ -414,72 +498,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  {
>  	struct kvm_cpuid_entry2 *entry;
>  	int r, i, max_idx;
> -	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
> -#ifdef CONFIG_X86_64
> -	unsigned f_gbpages = F(GBPAGES);
> -	unsigned f_lm = F(LM);
> -#else
> -	unsigned f_gbpages = 0;
> -	unsigned f_lm = 0;
> -#endif
>  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  
> -	/* cpuid 1.edx */
> -	const u32 kvm_cpuid_1_edx_x86_features =
> -		F(FPU) | F(VME) | F(DE) | F(PSE) |
> -		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> -		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
> -		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> -		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
> -		0 /* Reserved, DS, ACPI */ | F(MMX) |
> -		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
> -		0 /* HTT, TM, Reserved, PBE */;
> -	/* cpuid 0x80000001.edx */
> -	const u32 kvm_cpuid_8000_0001_edx_x86_features =
> -		F(FPU) | F(VME) | F(DE) | F(PSE) |
> -		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> -		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> -		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> -		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> -		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> -		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
> -		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
> -	/* cpuid 1.ecx */
> -	const u32 kvm_cpuid_1_ecx_x86_features =
> -		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
> -		 * but *not* advertised to guests via CPUID ! */
> -		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
> -		0 /* DS-CPL, VMX, SMX, EST */ |
> -		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
> -		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
> -		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> -		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
> -		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> -		F(F16C) | F(RDRAND);
> -	/* cpuid 0x80000001.ecx */
> -	const u32 kvm_cpuid_8000_0001_ecx_x86_features =
> -		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
> -		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> -		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
> -		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
> -		F(TOPOEXT) | F(PERFCTR_CORE);
> -
> -	/* cpuid 0x80000008.ebx */
> -	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
> -		F(CLZERO) | F(XSAVEERPTR) |
> -		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> -		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
> -
> -	/* cpuid 0xC0000001.edx */
> -	const u32 kvm_cpuid_C000_0001_edx_x86_features =
> -		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
> -		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
> -		F(PMM) | F(PMM_EN);
> -
> -	/* cpuid 0xD.1.eax */
> -	const u32 kvm_cpuid_D_1_eax_x86_features =
> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES);
> -
>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
>  
> @@ -495,9 +515,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = min(entry->eax, 0x1fU);
>  		break;
>  	case 1:
> -		entry->edx &= kvm_cpuid_1_edx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_1_EDX);
> -		entry->ecx &= kvm_cpuid_1_ecx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_1_ECX);
>  		/* we support x2apic emulation even if host does not support
>  		 * it since we emulate x2apic in software */
> @@ -607,7 +625,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		if (!entry)
>  			goto out;
>  
> -		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
>  		cpuid_entry_mask(entry, CPUID_D_1_EAX);
>  
>  		if (!kvm_x86_ops->xsaves_supported())
> @@ -691,9 +708,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = min(entry->eax, 0x8000001f);
>  		break;
>  	case 0x80000001:
> -		entry->edx &= kvm_cpuid_8000_0001_edx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
> -		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
>  		break;
>  	case 0x80000007: /* Advanced power management */
> @@ -712,7 +727,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			g_phys_as = phys_as;
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
> -		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_8000_0008_EBX);
>  		/*
>  		 * AMD has separate bits for each SPEC_CTRL bit.
> @@ -755,7 +769,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = min(entry->eax, 0xC0000004);
>  		break;
>  	case 0xC0000001:
> -		entry->edx &= kvm_cpuid_C000_0001_edx_x86_features;
>  		cpuid_entry_mask(entry, CPUID_C000_0001_EDX);
>  		break;
>  	case 3: /* Processor serial number */
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 41ff94a7d3e0..c64283582d96 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -6,6 +6,9 @@
>  #include <asm/cpu.h>
>  #include <asm/processor.h>
>  
> +extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
> +void kvm_set_cpu_caps(void);
> +
>  int kvm_update_cpuid(struct kvm_vcpu *vcpu);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  					      u32 function, u32 index);
> @@ -255,4 +258,20 @@ static inline bool cpuid_fault_enabled(struct kvm_vcpu *vcpu)
>  		  MSR_MISC_FEATURES_ENABLES_CPUID_FAULT;
>  }
>  
> +static __always_inline void kvm_cpu_cap_clear(unsigned x86_feature)
> +{
> +	unsigned x86_leaf = x86_feature / 32;
> +
> +	reverse_cpuid_check(x86_leaf);
> +	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
> +}
> +
> +static __always_inline void kvm_cpu_cap_set(unsigned x86_feature)
> +{
> +	unsigned x86_leaf = x86_feature / 32;
> +
> +	reverse_cpuid_check(x86_leaf);
> +	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
> +}
> +
>  #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f90c56c0c64a..c5ed199d6cd9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9591,6 +9591,8 @@ int kvm_arch_hardware_setup(void)
>  {
>  	int r;
>  
> +	kvm_set_cpu_caps();
> +
>  	r = kvm_x86_ops->hardware_setup();
>  	if (r != 0)
>  		return r;

Apart from the BUILD_BUG_ON() condition in cpuid_entry_mask()

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

