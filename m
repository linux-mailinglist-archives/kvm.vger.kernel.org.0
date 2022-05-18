Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D5952BBF0
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbiERNZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbiERNZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E609C1BB98D;
        Wed, 18 May 2022 06:25:33 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x143so2112768pfc.11;
        Wed, 18 May 2022 06:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iGkM7zUZyNWulbks1XJcMQ2LSpgiie/fhoc/MtFlX9o=;
        b=cF/XiRy74wYu5lz/Dni+EhUhHJBswgr9RMmobHZfZEKjlBesOH04xehd+2BBm/J9TU
         n2sHNRnAc0KL/jo0zWnPS3HX2VuRvtIWZhnHg92iKmCKhj0tfzZZpz0fxw4+aXLIFf1W
         Vh9GKcfwxRNhfhItZTLpse+sWSMQhqmVUHTQsgip4rswdWAwLXJCCiWkwdjaPeUfAf+O
         TgLv6i19EWAZTuELYajfyXEMCqVGBXdYw8FinKGs6QESlAKIvV7F8t24a+Jk5G0UA8Yy
         S/xW8sgLecBdrf23fx5PcY/fbD8WUX6T+0klo0wvDJu2XQHiTigc0mlOtZdcglbOBCHy
         c1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGkM7zUZyNWulbks1XJcMQ2LSpgiie/fhoc/MtFlX9o=;
        b=Cro/ofcF9ajEn3Ry9hl0jRhXmh00xKFrRAPhHgI492epzK36bPzcyOfOOAi3Bqa//U
         ZH4rOCSa9mKin48FLPey+JQo3U9k7GwjOMmX57IJszPjI/4vod+TukjGHNxpugNzcfBx
         mIbCkRRlKd70e+UhLsGvSvlFSNt1Jwx04vIM75goUQZM+557tdNIZtjC7wP1uMrI/SzN
         0fZzBgKtrmJNrWHwq88GlDEgbFWq9smOCkCm1KJOzFRPv5sDU9ekAt0G2r8DHlvLIlvy
         9zPxQfz47ohPXOgz4XIDF/R7ZlCXzrEt+amDRoPGpbF6LMnyJm4bn/Qn5zLn7HsHsyRK
         gJzg==
X-Gm-Message-State: AOAM531j+peO2zZc8gEU0HBKs8vdA+VIdLyhHJiAljig6NIZQIDkYEu7
        SbFC8m4R73flJRKadPq1Cug=
X-Google-Smtp-Source: ABdhPJzSXdtQtLfVYHMbN9XtxWkaFDm7YQhKqYNRpw01GYLVHrDYpluSBpy2zPFzFPU6yfFKFZtVgA==
X-Received: by 2002:a63:2023:0:b0:3f5:e1e7:74e3 with SMTP id g35-20020a632023000000b003f5e1e774e3mr4890315pgg.377.1652880333318;
        Wed, 18 May 2022 06:25:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:33 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 06/11] KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
Date:   Wed, 18 May 2022 21:25:07 +0800
Message-Id: <20220518132512.37864-7-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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

Since afrer reprogram_fixed_counter() is called, it's bound to assign
the requested fixed_ctr_ctrl to pmu->fixed_ctr_ctrl, this assignment step
can be moved forward (the stale value for diff is saved extra early),
thus simplifying the passing of parameters.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 13 ++++++-------
 arch/x86/kvm/pmu.h           |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++--------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cbffa060976e..131fbab612ca 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -319,8 +319,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
+void reprogram_fixed_counter(struct kvm_pmc *pmc)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
+	u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
 	unsigned en_field = ctrl & 0x3;
 	bool pmi = ctrl & 0x8;
 
@@ -350,12 +353,8 @@ void reprogram_counter(struct kvm_pmc *pmc)
 {
 	if (pmc_is_gp(pmc))
 		reprogram_gp_counter(pmc);
-	else {
-		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
-
-		reprogram_fixed_counter(pmc, ctrl, idx);
-	}
+	else
+		reprogram_fixed_counter(pmc);
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 56204f5a545d..8d7912978249 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -173,7 +173,7 @@ static inline void kvm_init_pmu_capability(void)
 }
 
 void reprogram_gp_counter(struct kvm_pmc *pmc);
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
+void reprogram_fixed_counter(struct kvm_pmc *pmc);
 void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2bfca470d5fd..5e10a1ef435d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -37,23 +37,23 @@ static int fixed_pmc_events[] = {1, 0, 7};
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
+	struct kvm_pmc *pmc;
+	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
 	int i;
 
+	pmu->fixed_ctr_ctrl = data;
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		u8 new_ctrl = fixed_ctrl_field(data, i);
-		u8 old_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, i);
-		struct kvm_pmc *pmc;
-
-		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
+		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
 
 		if (old_ctrl == new_ctrl)
 			continue;
 
-		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		reprogram_fixed_counter(pmc, new_ctrl, i);
-	}
+		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
-	pmu->fixed_ctr_ctrl = data;
+		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
+		reprogram_fixed_counter(pmc);
+	}
 }
 
 static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
-- 
2.36.1

