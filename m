Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD54F6DA6FF
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 03:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbjDGBfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 21:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbjDGBfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 21:35:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD436EB7
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 18:35:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o2-20020a17090ac08200b00244b34f5e3aso160367pjs.2
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 18:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680831308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9+58jKVdigi+Tne/Y0QC6raeydAklSYvu/dDGhyA9LI=;
        b=QtXcg8XgBdeJFclfdJA1Gf40qCN5Njp44/cYv+xnps8qZm4RxwJvBPd/ZXB2O1kZxt
         fI37KySC7rXT/vtJcCJ0YPSh3zLPDBHF5+0u9VVGq/JQ6VxWVwLTZMbKkSnB4Jj7ewKp
         eXeY4mdzSjSUR3e1I2UFxyuH7KkGVzF+rTqbz0Q1GtBpuqoSv3hUivl3Es0uArsVPn5k
         u/7dCWKGMyrqBo5Y9Fdtah13J8Tw6wL1XeVcx0v6mSlnhc0bLh8hOQ/gJWv0SwIh7b4D
         xkPJw+eVloe+TNpyvtLqmrxzg1DmhvRTYHcMCXS9p6DFl9TAqBKSXcLqrl1tOM8BC954
         9ArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680831308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+58jKVdigi+Tne/Y0QC6raeydAklSYvu/dDGhyA9LI=;
        b=IwHvgtaBIh8kgaYoXBQ25LZRal8kI7q/xAooMnAuuPI95/GuTMfVeVkjKEi3ewOAJO
         MUNcPCFM7jCRrrK53BAbg/2kdMrfBp5Pn/oG8lHZq8/YM6YA5uEoEHecuzygG9JSXaRH
         F5+nH7EXX627cSu09dorLpvUai6j+tdvkj8pEb0p4I2pSg7xJS3CWuardiKitVpASk6f
         ABLAhHaMGX9KH9IvDi833EAPfaPCel8gX73E6aLUjwvj8J3tVhS8azrEqiSqbPrIXzpy
         GXAcMrNrF4cqfWA98TbJ9vXqlGmGjV5FzhJvl8i+KRZ5qM7k0pvFxJq7C6S/XZ+eSJfr
         0dKA==
X-Gm-Message-State: AAQBX9feAsAwkG2E2B5PIkCoAS152UPp63ztrNfttVScdTUBrXED2iOw
        qLSXUUAv4AKB3lycBoTD4ZcPuOX2VLo=
X-Google-Smtp-Source: AKy350YitFXUGejlZMQ1ZQu+HerKqIsxaFWX9LLZuveNu/jF/S05iNAyk6whtRNa7H43eYqaPnUMeQaLWi0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b316:b0:23d:bd2:ab35 with SMTP id
 d22-20020a17090ab31600b0023d0bd2ab35mr163222pjr.3.1680831308682; Thu, 06 Apr
 2023 18:35:08 -0700 (PDT)
Date:   Thu, 6 Apr 2023 18:35:06 -0700
In-Reply-To: <20230214050757.9623-12-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-12-likexu@tencent.com>
Message-ID: <ZC9zSjZ7A47v7VCD@google.com>
Subject: Re: [PATCH v4 11/12] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Like Xu wrote:
> +	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> +		if (!msr_info->host_initiated)
> +			return 0; /* Writes are ignored */

Where is the "writes ignored" behavior documented?  I can't find anything in the
APM that defines write behavior. 

>  
>  		pmu->global_status = data;
>  		return 0;
>  	case MSR_CORE_PERF_GLOBAL_CTRL:
>  		if (!kvm_valid_perf_global_ctrl(pmu, data))
>  			return 1;
> -
> +		fallthrough;

This _definitely_ needs a comment.  Hmm, and I would prefer to reverse these, i.e.

	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
		data &= ~pmu->global_ctrl_mask;
		fallthrough;
	case MSR_CORE_PERF_GLOBAL_CTRL:
		if (!kvm_valid_perf_global_ctrl(pmu, data))
			return 1;

It's a bit arbitrary, but either Intel or AMD is going to end up with extra code,
and IMO skipping a validity check is more alarming than skipping clearing of
reserved bits, i.e. will look like a bug to future readers.

> +	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> +		data &= ~pmu->global_ctrl_mask;
>  		if (pmu->global_ctrl != data) {
>  			diff = pmu->global_ctrl ^ data;
>  			pmu->global_ctrl = data;
> @@ -616,7 +625,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>  		if (data & pmu->global_ovf_ctrl_mask)
>  			return 1;
> -
> +		fallthrough;

Here too.  Argh, the APM doesn't actually define what happens on reserved bits,
it just says "WO".  I vote to be conservative and ignore writes to reserved bits.
And then we can have one comment for the whole block, e.g.

	/*
	 * Note, AMD ignores writes to read-only PMU MSRs/bits, whereas Intel
	 * generates #GP on attempts to write reserved bits or RO MSRs.
	 */
	switch (msr) {
	case MSR_CORE_PERF_GLOBAL_STATUS:
		if (!msr_info->host_initiated)
			return 1; /* RO MSR */
		fallthrough;
	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
		if (!msr_info->host_initiated)
			break;

		pmu->global_status = data;
		break;
	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
		data &= ~pmu->global_ctrl_mask;
		fallthrough;
	case MSR_CORE_PERF_GLOBAL_CTRL:
		if (!kvm_valid_perf_global_ctrl(pmu, data))
			return 1;

		if (pmu->global_ctrl != data) {
			diff = pmu->global_ctrl ^ data;
			pmu->global_ctrl = data;
			reprogram_counters(pmu, diff);
		}
		break;
	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
		fallthrough;
	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
		if (data & pmu->global_ovf_ctrl_mask)
			return 1;

		if (!msr_info->host_initiated)
			pmu->global_status &= ~data;
		break;
	default:
		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
	}

	return 0;	

> @@ -164,20 +181,34 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_cpuid_entry2 *entry;
> +	union cpuid_0x80000022_ebx ebx;
>  
> -	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> +	pmu->version = 1;
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
> +		pmu->version = 2;
> +		entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);

No need for the intermediate "entry".
> +		ebx.full = entry->ebx;

Oof, at first glance this looks like a potential null-pointer deref bug.  I
believe we can do

		/*
		 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
		 * CPUID entry is guaranteed to be non-NULL.
		 */
		BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index != 0x80000022);
		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;

> +		pmu->nr_arch_gp_counters = min_t(unsigned int,
> +						 ebx.split.num_core_pmc,
> +						 kvm_pmu_cap.num_counters_gp);
> +	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
>  		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;

This needs to be sanitized, no?  E.g. if KVM only has access to 4 counters, but
userspace sets X86_FEATURE_PERFCTR_CORE anyways.  Hrm, unless I'm missing something,
that's a pre-existing bug.

If I'm right, can you add a patch to cap nr_arch_gp_counters at
kvm_pmu_cap.num_counters_gp in the common flow, i.e. after this if-else block?
Then there is no change needed in this patch, e.g. we'll naturally end up with:

	union cpuid_0x80000022_ebx ebx;

	pmu->version = 1;
	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
		pmu->version = 2;
		/*                                                              
                 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest   
                 * CPUID entry is guaranteed to be non-NULL.                    
                 */                                                             
                BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
                             x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
		pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
	} else {
		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
	}

	pmu->nr_arch_gp_counters = min_t(unsigned int,
					 pmu->nr_arch_gp_counters,
				       	 kvm_pmu_cap.num_counters_gp);
