Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162FC4CA2F2
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiCBLOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241273AbiCBLOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:42 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1022A60AAE;
        Wed,  2 Mar 2022 03:13:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id bx5so1470233pjb.3;
        Wed, 02 Mar 2022 03:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PIGENgRol9EvI3plNWUpNr20sleh4j6Pq/GVp4nZ57k=;
        b=NHpb4nKYF0gByECOpvE/68w+N3+77T8HNhJLN/j6j3E5tdJ3ggWlF6+T5w4UNuqfwC
         pS6wHK/JF8QlxN0mQkg+snQmsS+Z9nKeOoZUEgwbjBS3QUMXIRss+CnLb4douJrgnGUI
         qdBwTYa1gT7fdbdNuzCytIXm8ObBKj2tHPmLZarmdFa39Gm24FWk2nKt95E3/97m1hgN
         jdoH19Ra4xgjNZAyZHO6iMj3JqMp23KJPfbvTgH9UENi2QbXjnJFzv43+Isr+C4jsqkW
         3qJfqL7UilK0ePMt1LBwIMBe+JHOnyUh/YPFcSdAUIScW48BKI76LmWzq1xHqIz3HeL5
         sdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PIGENgRol9EvI3plNWUpNr20sleh4j6Pq/GVp4nZ57k=;
        b=z0dGgyC6QZCCyQVgM4vPZ/zDOiFTCw7ihrZ3IHx/Rm/j8a+53hPimMUbO0aT3MuDjN
         7Ey5ebEpzdd7saQUnQdtngSGJpqh/HcFVZPeNCAdISEV1JJr6i1aMrjRvadPIcJ2uV5M
         kyBHJUVQrZ1vzDYuhFLPlm14qvyGaABUb7RIr+Iw2MgI5P8LQU92/Kmh0y0FQU9VufKx
         /Wd0xfmcxgoAeNtzsBGa0UpozErcqOabJdXyjRtbvEh6KUXzUMnoY1ov70h7+ubfqugo
         3veLwjbz25XxY34KUiMy4qunhu6nJlJem7kDNltskJFpRlDLDFNhebSbhw/YTufH4/Gx
         EQcA==
X-Gm-Message-State: AOAM531etqr+E5VLHcGSKDOW+FCbDry9HX0pDkIH5A3rxy6x5KuxG46Q
        mxpTG4DSpYap5siicTOaPU0=
X-Google-Smtp-Source: ABdhPJwxMqinUtepWKpOcEDa9PGMOzkzYXsJjLJLKgwBnO+HzZRlYbNWJCggwwS870CbXofRixdbCg==
X-Received: by 2002:a17:90a:1188:b0:1bd:36d0:d7b2 with SMTP id e8-20020a17090a118800b001bd36d0d7b2mr17086336pja.223.1646219634473;
        Wed, 02 Mar 2022 03:13:54 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:54 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 04/12] KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
Date:   Wed,  2 Mar 2022 19:13:26 +0800
Message-Id: <20220302111334.12689-5-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
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

Because inside reprogram_gp_counter() it is bound to assign the requested
eventel to pmc->eventsel, this assignment step can be moved forward, thus
simplifying the passing of parameters to "struct kvm_pmc *pmc" only.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 7 +++----
 arch/x86/kvm/pmu.h           | 2 +-
 arch/x86/kvm/svm/pmu.c       | 3 ++-
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0ce33a2798cd..7b8a5f973a63 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -215,16 +215,15 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
+	u64 eventsel = pmc->eventsel;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
-	pmc->eventsel = eventsel;
-
 	pmc_pause_counter(pmc);
 
 	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
@@ -291,7 +290,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 void reprogram_counter(struct kvm_pmc *pmc)
 {
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmc);
 	else {
 		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
 		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b529c54dc309..4db50c290c62 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,7 +140,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
+void reprogram_gp_counter(struct kvm_pmc *pmc);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmc *pmc);
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index d4de52409335..7ff9ccaca0a4 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -265,7 +265,8 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data == pmc->eventsel)
 			return 0;
 		if (!(data & pmu->reserved_bits)) {
-			reprogram_gp_counter(pmc, data);
+			pmc->eventsel = data;
+			reprogram_gp_counter(pmc);
 			return 0;
 		}
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 20f2b5f5102b..2eefde7e4b1a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -448,7 +448,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data == pmc->eventsel)
 				return 0;
 			if (!(data & pmu->reserved_bits)) {
-				reprogram_gp_counter(pmc, data);
+				pmc->eventsel = data;
+				reprogram_gp_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.35.1

