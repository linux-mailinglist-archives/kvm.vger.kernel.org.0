Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C32A4CA2FD
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbiCBLPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbiCBLOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:43 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F76960CDA;
        Wed,  2 Mar 2022 03:13:57 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id k1so1666034pfu.2;
        Wed, 02 Mar 2022 03:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/eugBTlVHHjiLiWyNxaX8yniotcp8FYciUbkKrPu6Ko=;
        b=DHBPLXwNcNAR4Jzj56gtHWY2AB98daHiMl/bPXsjqbIRBjq/4RCGLDRXPXe09V49zJ
         BDDmUbs0mp2t57/KdP1E7p+5/IXG8bdFz+TiDFL4EImx/Qpj8JKaaAi61vMHwhUH0Ijy
         R/MvagH7QcHptwkyFWIph8/ENVIDNVzLs1sVBUFbIp9hRQKa+DkFY4B+e6EQW6S2GdVB
         Mpdcfje/w9J7d/NtntAmmeHFBFwXNB+I9o4TbYO/r+JmS8VqH4yuTbqIsU/JH+KWa8iZ
         HOR0dsk0ViJX/1+GvXuJzJPIComDWjunE5MU7ffL+lBrwxHVSStq2z0QHiSHjIdXDSPO
         +cVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/eugBTlVHHjiLiWyNxaX8yniotcp8FYciUbkKrPu6Ko=;
        b=SylHNxSFTct156j0EA3WxQiBuCPO/Y7N9obO1GdVPTaV26IHZgakdu5nDlCpiKr2N1
         71tbYHNqeIJqSuOlP1WHo9bN+LoSqLVPwRspyXA6KETZpLVdiG3HbsRRs9qE5/BP7FFF
         l47fEik59tux0BESsAo517TO3YE/mXx4Qtk6fhLrYQ2AsxtC9qVYtofH5XpZkMcIC1ne
         XM9P6xTkmLqqDpV2r0BKzh3A0dj2akOn3rp6AOxYLnHVq7g27PlrcB/RpiY8wRmyda7I
         HqePlOem+oFlW1zfQiuyiEf7EyvFP9QzibnBCSeQALY5JjkGdXpVeCbaMmfr+mvjn3rR
         5lhQ==
X-Gm-Message-State: AOAM530DEuYuOxNNc2S/ltqRndiU5bZg1S6LeGk+wvkKAzRol7G85zPQ
        pHGR+igrJfPos6QTVj8xb9b9ikm5B0dAsccM
X-Google-Smtp-Source: ABdhPJyAaYLakEPCTHYvtOh/PtOnSQecqsnC8XvAwKEy/zUNdhCoQ8pPhI/LAUrgCvf/ipOXk2yYVQ==
X-Received: by 2002:a62:fb0f:0:b0:4f2:6d3f:5ffb with SMTP id x15-20020a62fb0f000000b004f26d3f5ffbmr31971466pfm.55.1646219636974;
        Wed, 02 Mar 2022 03:13:56 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:56 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 05/12] KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
Date:   Wed,  2 Mar 2022 19:13:27 +0800
Message-Id: <20220302111334.12689-6-likexu@tencent.com>
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
index 7b8a5f973a63..282e6e859c46 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -260,8 +260,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
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
 
@@ -291,12 +294,8 @@ void reprogram_counter(struct kvm_pmc *pmc)
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
index 4db50c290c62..70a982c3cdad 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -141,7 +141,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 }
 
 void reprogram_gp_counter(struct kvm_pmc *pmc);
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
+void reprogram_fixed_counter(struct kvm_pmc *pmc);
 void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2eefde7e4b1a..3ddbfdd16cd0 100644
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
2.35.1

