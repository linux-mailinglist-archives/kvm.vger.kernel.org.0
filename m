Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E20625849
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiKKK12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiKKK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:12 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718E2129;
        Fri, 11 Nov 2022 02:27:08 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so4347223pjd.4;
        Fri, 11 Nov 2022 02:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fw4sOvoR84ZfYmrPFudlSRO8vcVAsXtD50u1XCvbbYs=;
        b=IEjH+/rf/ViIuR0iNyDdq7FSgDMqbAJ6zYcRWQeYTJqOvkl/jmGq1fFt2YWm2ZZR38
         t01cRnCY+HxsmPgBzgLAp4ztHYoA20Fyn+0h3FOxSHz81WprOdrLUgUlcN5jqew7VI1E
         yyVlCY9VEZBnLYTPUl1e65mIxqI/o8LSAgrd0jaF2TZdUW04Tr7KqmhF5EVQ0NAiCBlJ
         dC/HJNQ9ikWvJIxUtviTvIPYv6PcArSXnS2FCf1kt40mxCXOByAe4nmv3Ft/UM/hZp/1
         m+zxvgYPSsQK+4yK2MPMvV6XuJL926XWjWY5wr8nHRx+v+gZFZVny1v1xXF3UOj2Dvho
         PEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fw4sOvoR84ZfYmrPFudlSRO8vcVAsXtD50u1XCvbbYs=;
        b=Y719hlSbRWC+o5VqIO+s2LJFpS7OHJTABubNnFD4wbqr9FtL37JVU1D1JnPtDYqNA7
         20xVQEEMEXA+UZ9lczakw3b7A6mUF74il0T+Cd6b0O1vkLeT7J/BGOOA79ZhEUurqB7I
         r0eAsVRZXaHmC+mQoPFECBaTfL0gJaC864Hz+lzW//mPEqgsuhfgyLUXLitD9Sq//o3m
         kwvBfqGjSzXBai39e888HZ2Aagb/xip/YjTqIIEXv0l6ZFDibDxlfXVwnB0RowQ9qPTD
         fLsoQbwiabPEK72VFUQChzF9b/SWyRHhkL6NiYpZLfM8w65rAfMNoE1BfxEEAbiWUa/3
         0e8A==
X-Gm-Message-State: ANoB5pm9yJ6v3rxLKtAUF2XwxIJsGUwlv97wnExwz9rWSIERkMydBDJs
        edn5uHV5uJKFp/auh0roEeJ3ZV02etk+Vu+h
X-Google-Smtp-Source: AA0mqf7FoXhde3HlFvc5OEAGQtRIbVGfB9oWpzQlhiIkXerI8kmVA4MvoWETzE5t08LGHKTvm6KJ+g==
X-Received: by 2002:a17:902:ef87:b0:188:6429:d7bd with SMTP id iz7-20020a170902ef8700b001886429d7bdmr1935438plb.30.1668162427990;
        Fri, 11 Nov 2022 02:27:07 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/8] KVM: VMX: Refactor intel_pmu_set_msr() to align with other set_msr() helpers
Date:   Fri, 11 Nov 2022 18:26:39 +0800
Message-Id: <20221111102645.82001-3-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
References: <20221111102645.82001-1-likexu@tencent.com>
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
index f81cf54a245f..2f7cd388859c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -397,44 +397,43 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
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
@@ -442,15 +441,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -458,33 +456,38 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.38.1

