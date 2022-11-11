Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73A2625843
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiKKK1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiKKK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:12 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE7BA7;
        Fri, 11 Nov 2022 02:27:10 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id b62so4120258pgc.0;
        Fri, 11 Nov 2022 02:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbN3qr5bzEZl5U34w1vkWcXf/4eP6mzBa1StTcgxd5s=;
        b=GXe7AiJJFKxQS3u6FzrDrnU3J1Vehxc2NNxyNGV2V40949Ti4Og8jdm1TZkHlTCG8v
         m4OkUX7jJUJoswKtxlgqK7nbh9qfhEd8rs/X/tSYp4YbOZLBLHzekedjxAeJTS2TW5aX
         tcY3qH1HKmBPE8AfuG/aI/HLW7+qjd1Y03Q6WkGOssqPkBChPqM2qcyWX/8ywDiJDpjN
         bIyEB7c1XOp+bNVm4IDG2DJ++XCoyPIM3EhzgWBnn0lv1cdYDT3jDzTPXLy47Wdi9vzV
         LXY+ENoG5CepfUyufH/nrOh9kHrY5H3m0VKOH3halI7MwsOmKPMpZtDsq9Z2zD0Hveni
         JW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbN3qr5bzEZl5U34w1vkWcXf/4eP6mzBa1StTcgxd5s=;
        b=lTMl0Ml0YPO6v9m1zAW+oNFBS/Zpx87/sZdCaf6GIhTY6sIvSPDm4353LgSctJIJZI
         3W3m+zNbM3dkY4kZWqDIjgAa5u3sGFHI3LFUG0wGS0IrWW+3c0ShqFZUaH8WKmMRYUDT
         MrOYGkEuUzG28SWo1StdJWxaoxkdWe9s+FsNBUw13p/OmnScbVgLMxlRD9jpIqiyQSYH
         j5LluqGNX2EkMJXju80Cwxcez1aqvp0zH++O6wX7YniC3qX1qfocz0Ytk6lfoY+RLBHF
         FItsK3YzT0cPI8QY8UPq4PcYQH2S49AWsfdXf9WhT+5V0frmY2vxpK6x+5VW4cpOY1ew
         yVnA==
X-Gm-Message-State: ANoB5pnZI2EIzMxA7A6kBTChXvKx9nbWTP4u+9Jd/aTdc32qnEQ0Q6Sy
        W8JWR9f0UxDLhkspkg8BJFkT/DMq2vmDtjGo
X-Google-Smtp-Source: AA0mqf4Wev/6JT3zidyiQry1Egvyuf5bCahCyiZQxPKQ+EV88WMNQ24mz8j8Z4xdMC7TRsifLpGPCQ==
X-Received: by 2002:a63:d103:0:b0:460:ea43:93c6 with SMTP id k3-20020a63d103000000b00460ea4393c6mr1088171pgg.173.1668162429586;
        Fri, 11 Nov 2022 02:27:09 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:09 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/8] KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
Date:   Fri, 11 Nov 2022 18:26:40 +0800
Message-Id: <20221111102645.82001-4-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

A valid pmc is always tested before using pmu->reprogram_pmi. Eliminate
this part of the redundancy by setting the counter's bitmask directly,
and in addition, trigger KVM_REQ_PMU only once to save more cpu cycles.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 11 +++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 ------------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 2b5376ba66ea..be552c8217a0 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -189,6 +189,17 @@ static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
+{
+	int bit;
+
+	if (diff) {
+		for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
+			__set_bit(bit, pmu->reprogram_pmi);
+		kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
+	}
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2f7cd388859c..db704eea2d7c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,18 +68,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
-{
-	int bit;
-	struct kvm_pmc *pmc;
-
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
-		pmc = intel_pmc_idx_to_pmc(pmu, bit);
-		if (pmc)
-			kvm_pmu_request_counter_reprogam(pmc);
-	}
-}
-
 static bool intel_hw_event_available(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-- 
2.38.1

