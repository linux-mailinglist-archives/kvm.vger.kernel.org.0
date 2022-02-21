Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F74BE57B
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356922AbiBULwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:52:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356873AbiBULwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:52:45 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67201C90D;
        Mon, 21 Feb 2022 03:52:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so5465924pjb.3;
        Mon, 21 Feb 2022 03:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v+hL+FmCP5BA+6xKkzWlAfr/GV1nq1HZEPnxSmW/LTI=;
        b=gmGgtiVxWX/EkMag4f9zT2P7F/DsLFPX2vaMfjpE+Gv7GpkSDqGRK01DmwVP1m2+EQ
         0C1Z5hwT+owi8Zs908fq6YITt0xn6rJIxcEVisUgQR/jmDth1MW3E/b7IWZJbcUhQaNE
         aIpqlGGXU4D1wMoz4M/q8DT39seTKyltLoBlpj8R7FlRTN7uwrxBLhy+gRBpE+GZzS+x
         sXbYhHip1euXi3U4iqqaPEAopHZ7SGCzecoGyP/yluqDXV8kD6lqZn+hETUlmSXqoZvC
         /K+NAlemTodI6xbGwMAb4sL7QUcTNJztUVpbLpqlYflGklgr9BixGxyuWUgPNqt8rmfH
         tbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+hL+FmCP5BA+6xKkzWlAfr/GV1nq1HZEPnxSmW/LTI=;
        b=AUqjXmJYsQRy9eUA/+aMqvnYrVEILBebxTdSWyJlgeQ52kpKJ4JCADwTNCUEJRuZS7
         Xo3uBzC7cZ/mhRt72xMVR0FC7AT40kctPqe3tsRE0GdkQ9WmUcopfI2gQSVY5TQ85Nal
         uEsFiBeT9OPYyVO6dN8BAjYlm7pQpdtIFCp5w555Yh/ura7c8slZX5Y/CAP9IbH5X7Bn
         5zAVsJZkMkAQrVsC8p1UXnCf+iKgkO4dKP5cQUm4rPS0Q++6VHJSMRkui/Sz+sNatah0
         2RU4cTHqf6ZALVEERKv9PhRy/aQ3CYb+vVxank50uEjYXw1sRkwChuRjL7sqs/lwO3g5
         ilag==
X-Gm-Message-State: AOAM532Kso4+aNYXto850MCXbUV/FBx+5WIgQWB70tRsmBFJrwKQ+DYI
        WoJ6lQZS0vDMrCRORlI2//A=
X-Google-Smtp-Source: ABdhPJxLkG/V9yhrtPhvIi5culng1mP7SdyiXjax+Eu8P/1xRPvDUCkMdKnYM2gWEcfL3YyYU1Nthw==
X-Received: by 2002:a17:902:d88a:b0:14f:1aca:d956 with SMTP id b10-20020a170902d88a00b0014f1acad956mr18213211plz.100.1645444341219;
        Mon, 21 Feb 2022 03:52:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:21 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 03/11] KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
Date:   Mon, 21 Feb 2022 19:51:53 +0800
Message-Id: <20220221115201.22208-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Passing the reference "struct kvm_pmc *pmc" when creating
pmc->perf_event is sufficient. This change helps to simplify the
calling convention by replacing reprogram_{gp, fixed}_counter()
with reprogram_counter() seamlessly.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 17 +++++------------
 arch/x86/kvm/pmu.h           |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 32 ++++++++++++++++++--------------
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 78527b118f72..125bdfdbaa7a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -286,18 +286,13 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
+void reprogram_counter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
-
-	if (!pmc)
-		return;
-
 	if (pmc_is_gp(pmc))
 		reprogram_gp_counter(pmc, pmc->eventsel);
 	else {
-		int idx = pmc_idx - INTEL_PMC_IDX_FIXED;
-		u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
+		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
+		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
 
 		reprogram_fixed_counter(pmc, ctrl, idx);
 	}
@@ -316,8 +311,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
-
-		reprogram_counter(pmu, bit);
+		reprogram_counter(pmc);
 	}
 
 	/*
@@ -503,13 +497,12 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 prev_count;
 
 	prev_count = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
 
-	reprogram_counter(pmu, pmc->idx);
+	reprogram_counter(pmc);
 	if (pmc->counter < prev_count)
 		__kvm_perf_overflow(pmc, false);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..b529c54dc309 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -142,7 +142,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
+void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..049ce5519fb5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -56,16 +56,32 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	pmu->fixed_ctr_ctrl = data;
 }
 
+static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	if (pmc_idx < INTEL_PMC_IDX_FIXED)
+		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
+				  MSR_P6_EVNTSEL0);
+	else {
+		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
+
+		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
+	}
+}
+
 /* function is called when global control register has been updated. */
 static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 {
 	int bit;
 	u64 diff = pmu->global_ctrl ^ data;
+	struct kvm_pmc *pmc;
 
 	pmu->global_ctrl = data;
 
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
-		reprogram_counter(pmu, bit);
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
+		pmc = intel_pmc_idx_to_pmc(pmu, bit);
+		if (pmc)
+			reprogram_counter(pmc);
+	}
 }
 
 static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
@@ -101,18 +117,6 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
-static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
-{
-	if (pmc_idx < INTEL_PMC_IDX_FIXED)
-		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
-				  MSR_P6_EVNTSEL0);
-	else {
-		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
-
-		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
-	}
-}
-
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-- 
2.35.0

