Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772CB51DABE
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442312AbiEFOnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442317AbiEFOnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:43:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DE66AA59;
        Fri,  6 May 2022 07:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847968; x=1683383968;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=dc0ScoJLj393kAPY8/Jx0KCwpkzpkOJXGCluEWLxAp0=;
  b=HbZ6XM16SruZ/m4XT21aOcJM0GaYfHCQYTQSDFAAT7yJfFAqhCxS/7yX
   HjnbYcnbyKMpU7DAqniuyW9aVn8PeZD1Apbif2gZhKikj8ZTRPo/ZEZtp
   OnP03fCKaW9qNlgYePaYRtZ3a+ynC7WjfBcPGu6OSbz4wb1vS+eZEO3zb
   h9XROs8fE7wEDSsgOhsPyZ2q6D+EoYpRJU8Cg1YnSVs1Sb6v0cj6CxBmM
   tmIZiPSdBQ42SIV/9hpEOrWT4S7HyFh3BBinxwWy7/EhOlunUH2r9pvZs
   9okUSRW74oxt1WYIQlHvA0RiWJx2d0WnKQ11aMfqn/mxvCw2wLyRZe5Xd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="329027525"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="329027525"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632953483"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 06 May 2022 07:39:26 -0700
Received: from [10.252.212.236] (kliang2-MOBL.ccr.corp.intel.com [10.252.212.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 894185808EF;
        Fri,  6 May 2022 07:39:25 -0700 (PDT)
Message-ID: <67391ba6-c7c4-d164-1a12-cd35f942d9a0@linux.intel.com>
Date:   Fri, 6 May 2022 10:39:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 06/16] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-7-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220506033305.5135-7-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/2022 11:32 PM, Yang Weijiang wrote:
> From: Like Xu <like.xu@linux.intel.com>
> 
> The number of Arch LBR entries available is determined by the value
> in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> supported. In the first generation of Arch LBR, max entry size is 32,
> host configures the max size and guest always honors the setting.
> 
> Write to MSR_ARCH_LBR_DEPTH has side-effect, all LBR entries are reset
> to 0. Kernel PMU driver can leverage this effect to do fask reset to
> LBR record MSRs. KVM allows guest to achieve it when Arch LBR records
> MSRs are passed through to the guest.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 ++
>   arch/x86/kvm/vmx/pmu_intel.c    | 50 ++++++++++++++++++++++++++++++++-
>   2 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4ff36610af6a..753e3ecac1a1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -534,6 +534,9 @@ struct kvm_pmu {
>   	 * redundant check before cleanup if guest don't use vPMU at all.
>   	 */
>   	u8 event_count;
> +
> +	/* Guest arch lbr depth supported by KVM. */
> +	u64 kvm_arch_lbr_depth;
>   };
>   
>   struct kvm_pmu_ops;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index b82b6709d7a8..e2b5fc1f4f1a 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -192,6 +192,12 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>   	if (!intel_pmu_lbr_is_enabled(vcpu))
>   		return ret;
>   
> +	if (index == MSR_ARCH_LBR_DEPTH) {
> +		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> +		return ret;
> +	}
> +
>   	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
>   		(index >= records->from && index < records->from + records->nr) ||
>   		(index >= records->to && index < records->to + records->nr);
> @@ -205,7 +211,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>   static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	int ret;
> +	int ret = 0;
>

I don't think you need this change anymore, since the MSR_ARCH_LBR_DEPTH 
has been moved to the other place.

After the above is removed, the patch looks good to me.

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan

>   	switch (msr) {
>   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> @@ -342,10 +348,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>   	return true;
>   }
>   
> +/*
> + * Check if the requested depth value the same as that of host.
> + * When guest/host depth are different, the handling would be tricky,
> + * so now only max depth is supported for both host and guest.
> + */
> +static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return false;
> +
> +	return (depth == pmu->kvm_arch_lbr_depth);
> +}
> +
>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	struct kvm_pmc *pmc;
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>   	u32 msr = msr_info->index;
>   
>   	switch (msr) {
> @@ -361,6 +383,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>   		msr_info->data = 0;
>   		return 0;
> +	case MSR_ARCH_LBR_DEPTH:
> +		msr_info->data = lbr_desc->records.nr;
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -387,6 +412,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	struct kvm_pmc *pmc;
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>   	u32 msr = msr_info->index;
>   	u64 data = msr_info->data;
>   	u64 reserved_bits;
> @@ -421,6 +447,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 0;
>   		}
>   		break;
> +	case MSR_ARCH_LBR_DEPTH:
> +		if (!arch_lbr_depth_is_valid(vcpu, data))
> +			return 1;
> +		lbr_desc->records.nr = data;
> +		/*
> +		 * Writing depth MSR from guest could either setting the
> +		 * MSR or resetting the LBR records with the side-effect.
> +		 */
> +		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -555,6 +591,18 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   	if (lbr_desc->records.nr)
>   		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return;
> +
> +	entry = kvm_find_cpuid_entry(vcpu, 28, 0);
> +	if (entry) {
> +		/*
> +		 * The depth mask in CPUID is fixed to host supported
> +		 * value when userspace sets guest CPUID.
> +		 */
> +		pmu->kvm_arch_lbr_depth = fls(entry->eax & 0xff) * 8;
> +	}
>   }
>   
>   static void intel_pmu_init(struct kvm_vcpu *vcpu)
