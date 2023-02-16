Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23A1699ECF
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 22:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBPVNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 16:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBPVNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 16:13:36 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8119648E22
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 13:13:35 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m10-20020a170902f64a00b0019a68e484e1so1650181plg.14
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 13:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676582015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PlVa9splVyzqnhqvt9h5jnOme1Iy46ppwguKl1FDCZE=;
        b=OnVZY9iopErbk020fpsboEJ6EJqdhlF2gqW2pyiMU408pfLN5kgSRtPX1huRH8JGt6
         jmlF2LjjbYL7bMy8pu9KD+3rEvKqx7jlmYolKtJyON6Qzh6+vrmYsnT/8mIpMXFXkLO5
         cYlyNJEpssTohMMbGIhv3d6ViLZhKNAZOBuKiippf0KBsdjEKVIQgecRWQeq6hkn++wx
         K34kazsMKvmdk7T2+nHBAm1UpcKlnM0iKe+X7h80IqIPULUTN/JUfF7/WbGdlzS9bnOL
         bgtnm2Xej/MC0STdM+ynWazKlp3zsNQtyKc4aCzkuhnp/DqKwr6BMqtlQN76wUx945Kc
         wEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676582015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlVa9splVyzqnhqvt9h5jnOme1Iy46ppwguKl1FDCZE=;
        b=l4wcqbvOJmVDt5UWk9CuMEzT31lMWw8YaW1Q09Pf79RRzPfjHoNKef8txd2B+/uylx
         pvu3tCrxkjEGIMpSIlZvXkR4ryTFmB8PCx3ocfywHaJOScmZRQWpZDx/1eLZX12HZmw0
         SEXLg0l0l3RKy+C1+VFhpSbbYSXPXZxP87IeMDvW9ZAYzHF7safEwc/6MvSd19aAQ/hJ
         g718721X+6dtjnOSLD49qAQJWIgVpvW9FnFJxQD0FTdT1NMllUwTb5BpoMaE3gdaJf8n
         ZdAfOMnKV3RrdVa1g7u7XR/u96bIRVVHGvIpp3XfBKq21FIwr4kJOIExAcQWrMElH9q5
         qawA==
X-Gm-Message-State: AO0yUKUMpUsKPieNXH4cxr9mRpPHl8eZZ5ZVWrGtW+YDl1biYqJuH+PB
        fZ9HF3bRux/k7lGGFXTnktY7DhupXAE=
X-Google-Smtp-Source: AK7set8qgZdMtz5e6sInPdvDe+pDwMVY+dD+RTxqlRiFeKQsrT4/7459onPcwRYN/PVnhZ7cp5I/W+EaoLY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d709:b0:19a:f556:e379 with SMTP id
 w9-20020a170902d70900b0019af556e379mr585159ply.15.1676582015033; Thu, 16 Feb
 2023 13:13:35 -0800 (PST)
Date:   Thu, 16 Feb 2023 13:13:33 -0800
In-Reply-To: <20230214050757.9623-3-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-3-likexu@tencent.com>
Message-ID: <Y+6cfen/CpO3/dLO@google.com>
Subject: Re: [PATCH v4 02/12] KVM: VMX: Refactor intel_pmu_set_msr() to align
 with other set_msr() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Like Xu wrote:
> From: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 81 +++++++++++++++++++-----------------
>  1 file changed, 42 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e8a3be0b9df9..6a2f8b4ed061 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -402,44 +402,43 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)

Gah, I forgot to post a patch that gives intel_pmu_get_msr() the same treatment.
I'll replace this patch with the combined version below when applying, or will
post it separately if a v5 is needed.

From: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Jan 2023 17:08:03 -0800
Subject: [PATCH] KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with
 other helpers

Invert the flows in intel_pmu_{g,s}et_msr()'s case statements so that
they follow the kernel's preferred style of:

        if (<not valid>)
                return <error>

        <commit change>
        return <success>

which is also the style used by every other {g,s}et_msr() helper (except
AMD's PMU variant, which doesn't use a switch statement).

Modify the "set" paths with costly side effects, i.e. that reprogram
counters, to skip only the side effects, i.e. to perform reserved bits
checks even if the value is unchanged.  None of the reserved bits checks
are expensive, so there's no strong justification for skipping them, and
guarding only the side effect makes it slightly more obvious what is being
skipped and why.

No functional change intended (assuming no reserved bit bugs).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 109 ++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..432662f71207 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -351,45 +351,47 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		msr_info->data = pmu->fixed_ctr_ctrl;
-		return 0;
+		break;
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 		msr_info->data = pmu->global_status;
-		return 0;
+		break;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		msr_info->data = pmu->global_ctrl;
-		return 0;
+		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
-		return 0;
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
-		return 0;
+		break;
 	case MSR_IA32_DS_AREA:
 		msr_info->data = pmu->ds_area;
-		return 0;
+		break;
 	case MSR_PEBS_DATA_CFG:
 		msr_info->data = pmu->pebs_data_cfg;
-		return 0;
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
 			u64 val = pmc_read_counter(pmc);
 			msr_info->data =
 				val & pmu->counter_bitmask[KVM_PMC_GP];
-			return 0;
+			break;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			u64 val = pmc_read_counter(pmc);
 			msr_info->data =
 				val & pmu->counter_bitmask[KVM_PMC_FIXED];
-			return 0;
+			break;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
-			return 0;
-		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, true))
-			return 0;
+			break;
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, true)) {
+			break;
+		}
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -402,44 +404,43 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-		if (pmu->fixed_ctr_ctrl == data)
-			return 0;
-		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
+		if (data & pmu->fixed_ctr_ctrl_mask)
+			return 1;
+
+		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
-			return 0;
-		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (msr_info->host_initiated) {
-			pmu->global_status = data;
-			return 0;
-		}
-		break; /* RO MSR */
+		if (!msr_info->host_initiated)
+			return 1; /* RO MSR */
+
+		pmu->global_status = data;
+		break;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
-		if (pmu->global_ctrl == data)
-			return 0;
-		if (kvm_valid_perf_global_ctrl(pmu, data)) {
+		if (!kvm_valid_perf_global_ctrl(pmu, data))
+			return 1;
+
+		if (pmu->global_ctrl != data) {
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
 			reprogram_counters(pmu, diff);
-			return 0;
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		if (!(data & pmu->global_ovf_ctrl_mask)) {
-			if (!msr_info->host_initiated)
-				pmu->global_status &= ~data;
-			return 0;
-		}
+		if (data & pmu->global_ovf_ctrl_mask)
+			return 1;
+
+		if (!msr_info->host_initiated)
+			pmu->global_status &= ~data;
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		if (pmu->pebs_enable == data)
-			return 0;
-		if (!(data & pmu->pebs_enable_mask)) {
+		if (data & pmu->pebs_enable_mask)
+			return 1;
+
+		if (pmu->pebs_enable != data) {
 			diff = pmu->pebs_enable ^ data;
 			pmu->pebs_enable = data;
 			reprogram_counters(pmu, diff);
-			return 0;
 		}
 		break;
 	case MSR_IA32_DS_AREA:
@@ -447,15 +448,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
+
 		pmu->ds_area = data;
-		return 0;
+		break;
 	case MSR_PEBS_DATA_CFG:
-		if (pmu->pebs_data_cfg == data)
-			return 0;
-		if (!(data & pmu->pebs_data_cfg_mask)) {
-			pmu->pebs_data_cfg = data;
-			return 0;
-		}
+		if (data & pmu->pebs_data_cfg_mask)
+			return 1;
+
+		pmu->pebs_data_cfg = data;
 		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -463,33 +463,38 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((msr & MSR_PMC_FULL_WIDTH_BIT) &&
 			    (data & ~pmu->counter_bitmask[KVM_PMC_GP]))
 				return 1;
+
 			if (!msr_info->host_initiated &&
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			pmc_update_sample_period(pmc);
-			return 0;
+			break;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
 			pmc_update_sample_period(pmc);
-			return 0;
+			break;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
-			if (data == pmc->eventsel)
-				return 0;
 			reserved_bits = pmu->reserved_bits;
 			if ((pmc->idx == 2) &&
 			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
-			if (!(data & reserved_bits)) {
+			if (data & reserved_bits)
+				return 1;
+
+			if (data != pmc->eventsel) {
 				pmc->eventsel = data;
 				kvm_pmu_request_counter_reprogam(pmc);
-				return 0;
 			}
-		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-			return 0;
+			break;
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false)) {
+			break;
+		}
+		/* Not a known PMU MSR. */
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)

base-commit: 62ef199250cd46fb66fe98267137b7f64e0b41b4
-- 
