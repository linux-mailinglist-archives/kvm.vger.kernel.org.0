Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BE1695825
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjBNFIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBNFIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:21 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A666EBD;
        Mon, 13 Feb 2023 21:08:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 7so9541154pga.1;
        Mon, 13 Feb 2023 21:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JDYzf0k4o+EyOME6U/CECpzyoWhEHRNTAdlaHz5bVmw=;
        b=ep+kb+TRZWROKJV7isuQrquob8WvjUhNX9o1+5JvwpfsCk4Qb5coBZd5FxTN0nUkk/
         I37Qr/xi78RdwlKyvb+VCA0P5I8KnPquoWspeae2RILM0uwx9qp7hgy3faQTNdIdsfjm
         QAkhuOJYlcmBIhGSlOxA9OFEEa1DzIO48P1Z7fuMJN+4n0xlZ/JWyaxGdopN7F0Z/Xfp
         Ybujwq4e3DoHWAahPlkgPVI7zynFiK6J9klFC4RQPjyqJ5NV/WdcK6lkwS6XX0GpaVR6
         6VRFbQbwvsB4jPmJCUDRKBcee3hnqg9devfXmLXYFwA5KkzQQBKo22jRc5KNorOSlzck
         zbfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JDYzf0k4o+EyOME6U/CECpzyoWhEHRNTAdlaHz5bVmw=;
        b=i52gdcV6E7IEA99BP9OfkjZWE9UuucnVa55QcvVdVosgOc9PSwEuGoIIKo39mADfZb
         dyfaCk+gS40D6EXBgF5vlRKXe+BHCoY2REB+KXO2MwtIEvvoI7/ecf/Feq2QjmWirdR9
         pdUHtLKgHsXVOXfdKITyXw2ejMWr6Co75+zcI6yvqDarpLzBLOhvEFUO3+o9I1ukZzys
         gHI7H8F0310kmvY5kfMSed/Sy6TTiDx0nwIP7aPkF5KpT8KHroRwhfIDRE4NlNSCZXpo
         5Igv2G916muTvWq0OShIHabEfaEXCQuDyZP57BYxKsJPDLJ9pBiSIcCNVM+yLjr1kO5R
         WXlg==
X-Gm-Message-State: AO0yUKVSEhtWD3D+FYZEbHOIQt4ZgYPVrVVBwjLk3TMKnjptmipBbvLU
        e1moSW5OzpE2nGKUE8Nxcsk=
X-Google-Smtp-Source: AK7set/W5SBNElhdngj6SFyS9dzNfuvnSw9nw0JQaOcLheAdJGzVWQZj7qrgeQqzYm+ZsbmG26Vl+Q==
X-Received: by 2002:a62:64cb:0:b0:5a8:380d:7822 with SMTP id y194-20020a6264cb000000b005a8380d7822mr806607pfb.23.1676351299801;
        Mon, 13 Feb 2023 21:08:19 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:19 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/12] KVM: VMX: Refactor intel_pmu_set_msr() to align with other set_msr() helpers
Date:   Tue, 14 Feb 2023 13:07:47 +0800
Message-Id: <20230214050757.9623-3-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Invert the flows in intel_pmu_set_msr()'s case statements so that they
follow the kernel's preferred style of:

	if (<not valid>)
		return <error>

	<commit change>
	return <success>

which is also the style used by every other set_msr() helper (except
AMD's PMU variant, which doesn't use a switch statement).

Opportunstically move the "val == current" checks below the validity
checks.  Except for the one-off case for MSR_P6_EVNTSEL2, the reserved
bit checks are extremely cheap, and the guest is unlikely to frequently
write the current value, i.e. avoiding the reserved bit checks doesn't
add much (any?) value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 81 +++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..6a2f8b4ed061 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -402,44 +402,43 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
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
@@ -447,15 +446,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -463,33 +461,38 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
-- 
2.39.1

