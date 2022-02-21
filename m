Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A06A4BDF93
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356937AbiBULxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356935AbiBULw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:52:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A641EEEF;
        Mon, 21 Feb 2022 03:52:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so2993115pjb.0;
        Mon, 21 Feb 2022 03:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EaGkMeIuW5BjaVqOufsfJOzlJHAqBDnT17fO9wpvlYE=;
        b=ZMRefgSPlD1TLSlMbMZGWTMOxOgqaA4F6qxBSNIMwJAQU8xxIBN5S7PRHuzcZcAuAA
         fsz4Qeot5x6T0/1eh0v+YAQduQdj97DQXbikMWU0tH5kBvClxU9V8RoZrAqwoiNfZSQ5
         rKf81Zv1CsntAXnrFrzaEXHFKPs7lgMgZJ9YsCzeScwL8QR2fKHBEgnycwWZRnTau9Bv
         Npglls5rW6j4j6TZwxLuBXX2+iLAtzQxGm5431R5sFkEW6rqCLdtipmC1orN39ifGnAh
         V8UWZw/vlYWW4SSwXtEAj2d35dwgkWO62ysc25CECtczKoGSsWQAJnAduCJuVmoNx9RW
         kdkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EaGkMeIuW5BjaVqOufsfJOzlJHAqBDnT17fO9wpvlYE=;
        b=CQBELjedXKsvsrStPMjsqEPhjCIoN0ZoxxoKeKcBI9a5Puih2sjnfBhiX5hoaYfm06
         Rnvm6CXVQiUw0MHOUAqx5x6gLIyTaUnPSSWmCD5Quhubb0ygIJbLYoIPoHSSfdkJAKow
         TOlsl58zr5/o+m6/Ju249mA9Qw4gi0ycA0cOnSKxdlCEiXtgIMRt40r1dhljSowT0Wbb
         JgYdMLPOig5ewEzpiX+DtJfwLFJFGAikPlEcsohUya3McgUJo3+30zaR8UwZSgQ2f7gT
         ZHYrWPIGNi6YLNYT10/isLvqaO9L4kbpyJKiqghTvOXwmhbfU/nSJCJfSqROePHgvufq
         HvNw==
X-Gm-Message-State: AOAM530/yN2eML1brhJbWab+apDfXGz8fIIrCME9yjDvOxEe41wrioE3
        q8C5i4VSW7EwCh3GzrHQCBw=
X-Google-Smtp-Source: ABdhPJwhDKSNzUxsVJl9VvBm99nUlrfK1zeoHYxTBnlaX9sSAwG1v9k1C00JCXMVzSSGwxDxSQ5o2g==
X-Received: by 2002:a17:902:f686:b0:14e:e441:b76b with SMTP id l6-20020a170902f68600b0014ee441b76bmr18630263plg.146.1645444346869;
        Mon, 21 Feb 2022 03:52:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 05/11] KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
Date:   Mon, 21 Feb 2022 19:51:55 +0800
Message-Id: <20220221115201.22208-6-likexu@tencent.com>
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
index 482a78956dd0..7c90d5d196a4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -258,8 +258,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
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
 
@@ -289,12 +292,8 @@ void reprogram_counter(struct kvm_pmc *pmc)
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
index 1ed7d23d6738..cc4a092f0d67 100644
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
2.35.0

