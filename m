Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24667EF80
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjA0UZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjA0UZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:25:22 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237F42BEDB
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 12:25:21 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b10so5663712pjo.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 12:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uJe6a029aMe3U1mBIX27gKXNT1Xkqqrq1mwntN0JHEQ=;
        b=FSRvGIOiUPcH8GZ8AoNaJbLkHoUBzCl0ahYHcKjsAVRU7MPFqYJwC/6XzATvQuOHNz
         zH30Ezaj0UgPGL3V6QwiGVa46uxisyXDMTTIDzVplpCWko+J1wZPzzID6pLQ4G8pftrm
         NigmlH8gKuvZksUjgwyk8bt1EUH2qJHm5pUBxeCosYtf01Sp8s/Z3snUZxx7rHiyv67a
         USvYchAvTmHqRaIhoQhxPaq/OPckSp1Sl0fYI1OeLauRhql/tLZMP5uMmPFoX5+MbeTp
         tGfTZv27FcyETKdN/ym1d+OErsh8+hY92C5jF1vcLSa3nVfYx4MxIU9W488g4l5zsW6L
         hJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJe6a029aMe3U1mBIX27gKXNT1Xkqqrq1mwntN0JHEQ=;
        b=PcMvv0vhmyQuR24orpbl+H12s6yilGeqplRIsjI059nulYm+jM7VmtEnLj7TnPPGob
         6tP5iUtC3y6kE2/3A8VgsaH/pYcrmpBfkMjHUPyJ/ZR57c/SqyQ1eoGK1JbEVtJTqKIB
         KGBLfskMpBLjW74sbFtaPg8z/PlcMYZ3ObldI5UbefJwaYDBN52kiyY6Cmn8b0njqUJU
         yIdZ8inAQ9KtFUBa4sSbi5QQ2mXH9t5Y4RfjXIBmevjgvfaLWsm/Hxg+vnJPMUTWzbK0
         NdJ6OGmo0DZ1S4DEGz/M+2k1Aa2Ap9opQYcBZ+miyLy/si5xU32QLDST8tAMeQxay4SN
         FV3A==
X-Gm-Message-State: AO0yUKVrGy4wOtv0/uANF8Mgyeeq3bjb4ln6u9YK+AzEUM0lmnWm6/f0
        q9VaTieyGAL8pb4EnshH2XjJrGcMO+OBniXpSNg=
X-Google-Smtp-Source: AK7set/9uEcs/0K2Hl2UXRg4jVt4RuoaOYuxJnSLwEZ29/MCL9mAE/uUO2MJAyh8qA6S5ZijUrc4mA==
X-Received: by 2002:a17:90a:6949:b0:219:f970:5119 with SMTP id j9-20020a17090a694900b00219f9705119mr115299pjm.1.1674851120337;
        Fri, 27 Jan 2023 12:25:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c22-20020a637256000000b0048988ed9e4bsm2701875pgn.19.2023.01.27.12.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 12:25:19 -0800 (PST)
Date:   Fri, 27 Jan 2023 20:25:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v2 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Message-ID: <Y9QzLHNxS4K81SfU@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-6-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-6-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Write to MSR_ARCH_LBR_DEPTH has side-effect, all LBR entries are reset
> to 0. Kernel PMU driver can leverage this effect to do fask reset to
> LBR record MSRs. KVM allows guest to achieve it when Arch LBR records
> MSRs are passed through to the guest.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++
>  arch/x86/kvm/vmx/pmu_intel.c    | 58 +++++++++++++++++++++++++++++++--
>  2 files changed, 58 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 70af7240a1d5..2dba2fdd9cdc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -571,6 +571,9 @@ struct kvm_pmu {
>  	 * redundant check before cleanup if guest don't use vPMU at all.
>  	 */
>  	u8 event_count;
> +
> +	/* Guest arch lbr depth supported by KVM. */
> +	u64 kvm_arch_lbr_depth;

There is zero reason to store this separately.  KVM already records the allowed
depth in kvm_vcpu.lbr_desc.records.nr.

>  };
>  
>  struct kvm_pmu_ops;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 905673228932..0c78cb4b72be 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -178,6 +178,10 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>  	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
>  		return true;
>  
> +	if (index == MSR_ARCH_LBR_DEPTH)
> +		return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&

Like the previous patch, since intel_pmu_lbr_is_enabled() effectively serves as
a generic kvm_cpu_cap_has(LBRS) check, this can be distilled to:

	if (cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
		if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL)
			return true;
	} else {
		if (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
			return true;
	}

> +		       guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> +
>  	if ((index >= records->from && index < records->from + records->nr) ||
>  	    (index >= records->to && index < records->to + records->nr))
>  		return true;
> @@ -345,6 +349,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>  	u32 msr = msr_info->index;
>  
>  	switch (msr) {
> @@ -369,6 +374,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_PEBS_DATA_CFG:
>  		msr_info->data = pmu->pebs_data_cfg;
>  		return 0;
> +	case MSR_ARCH_LBR_DEPTH:
> +		msr_info->data = lbr_desc->records.nr;
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -395,6 +403,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>  	u32 msr = msr_info->index;
>  	u64 data = msr_info->data;
>  	u64 reserved_bits, diff;
> @@ -456,6 +465,24 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 0;
>  		}
>  		break;
> +	case MSR_ARCH_LBR_DEPTH:
> +		if (!pmu->kvm_arch_lbr_depth && !msr_info->host_initiated)

Don't invent a new check, just prevent KVM from reaching this path via the
existing intel_pmu_lbr_is_enabled().

> +			return 1;
> +		/*
> +		 * When guest/host depth are different, the handling would be tricky,
> +		 * so only max depth is supported for both host and guest.
> +		 */

This semi-arbitrary restriction is fine because Intel's architecture allows KVM
to enumerate support for a single depth, but somewhere in the changelog and/or
code that actually needs to be state.  This blurb

  In the first generation of Arch LBR, max entry size is 32,
  host configures the max size and guest always honors the setting.

makes it sound like KVM is relying on the guest to do the right thing, and this
code looks like KVM is making up it's own behavior.

> +		if (data != pmu->kvm_arch_lbr_depth)
> +			return 1;
> +
> +		lbr_desc->records.nr = data;
> +		/*
> +		 * Writing depth MSR from guest could either setting the
> +		 * MSR or resetting the LBR records with the side-effect.
> +		 */
> +		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))

Another check, really?  KVM shouldn't reach this point if KVM doesn't support
Arch LBRs.  And if that isn't guarantee (honestly forgot what this series actually
proposed at this point), then that's a bug, full stop.

> +			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);

IIUC, this is subtly broken.  Piecing together all of the undocumented bits, my
understanding is that arch LBRs piggyback KVM's existing LBR support, i.e. use a
"virtual" perf event.  And like traditional LBR support, the host can steal control
of the LBRs in IRQ context by disabling the perf event via IPI.  And since writes
to MSR_ARCH_LBR_DEPTH purge LBR records, this needs to be treated as if it were a
write to an LBR record, i.e. belongs in the IRQs disabled section of
intel_pmu_handle_lbr_msrs_access().

If for some magical reason it's safe to access arch LBR MSRs without disabling IRQs
and confirming perf event ownership, I want to see a very detailed changelog
explaining exactly how that magic works.

> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -506,6 +533,32 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>  	}
>  }
>  
> +static bool cpuid_enable_lbr(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_cpuid_entry2 *entry;
> +	int depth_bit;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return !static_cpu_has(X86_FEATURE_ARCH_LBR) &&
> +			cpuid_model_is_consistent(vcpu);
> +
> +	pmu->kvm_arch_lbr_depth = 0;
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		return false;
> +
> +	entry = kvm_find_cpuid_entry(vcpu, 0x1C);
> +	if (!entry)
> +		return false;
> +
> +	depth_bit = fls(cpuid_eax(0x1C) & 0xff);

This is unnecessarily fragile.  Get the LBR depth from perf, don't read CPUID and
assume perf will always configured the max depth.,

This enabling also belongs at the tail end of the series, i.e. KVM shouldn't let
userspace enable LBRs until all the support pieces are in place.

> +	if ((entry->eax & 0xff) != (1 << (depth_bit - 1)))
> +		return false;
> +
> +	pmu->kvm_arch_lbr_depth = depth_bit * 8;
> +	return true;
> +}
> +
>  static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -589,9 +642,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	bitmap_set(pmu->all_valid_pmc_idx,
>  		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>  
> -	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
> -	if (cpuid_model_is_consistent(vcpu) &&
> -	    (perf_capabilities & PMU_CAP_LBR_FMT))
> +	if (cpuid_enable_lbr(vcpu))
>  		x86_perf_get_lbr(&lbr_desc->records);
>  	else
>  		lbr_desc->records.nr = 0;
> @@ -599,6 +650,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	if (lbr_desc->records.nr)
>  		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
>  
> +	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
>  	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
>  		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
>  			pmu->pebs_enable_mask = counter_mask;
> -- 
> 2.27.0
> 
