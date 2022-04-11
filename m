Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF44FB79B
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344479AbiDKJiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344471AbiDKJiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:09 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6531AF27;
        Mon, 11 Apr 2022 02:35:56 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y8so8948267pfw.0;
        Mon, 11 Apr 2022 02:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1KF6+6/OPXYFT8NZlyT7/xmed8GjZlNYgDHQ02cnYrw=;
        b=Yd0/CPNVSEIOVRYtL6PIZTbaC1FlO0jKhjRBRDaCp8Y1DIhHUFNEZ7RigfrCudggLY
         zOZh436FlV3A5HuJcVcT2MB+SpOV0gm+EFnP6w/zFTpAPOVBNb5dTfGxDw73pzN79Gfv
         28oa5W9WBm6cTv//9tdy6ylHtO4jfeyegYh4foD95UMlyU6rVdI1AQpNYiz/E70yx7hp
         lb6bJ9Zp69QsvVlbbh0obXFIO3o5TxO7lFfGSDTicvOj7R5vTUcEBLCNUAmwxm8Pq2Wd
         NI34zfedffJZN+5exw3ymptFQ45YMvH6fSLyHh7BCPDuBlISdvw+8VPLSmXD2EPBRKnT
         RPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1KF6+6/OPXYFT8NZlyT7/xmed8GjZlNYgDHQ02cnYrw=;
        b=Jah3ackhTShjuMWWUVB9K1pAWTjrUX9ckTe6A8y02sz83Dqv8eEzmacHZOfs584UiN
         B4XHkG5vRSZwM45o9hn8/KwQ14BO7D8+rNfoeimf3Ju9fAa59rKORoYF9IGrdZuPuV7n
         ZWSwBd5wfdKexTeSSCB7H6gY9kf4ueP7DHxK0sOKAFnnlX/tJy9v4D1jmLySi5NZQWAG
         5Dr+kASyRFihgEb+iGACvXA1sU8hmBmOP+5bqapNXQAC6u+0oFVe7Rw25uYHD5yxnJJ3
         ZnftU1YmMk8merPTFqGYgdY0skf9SlgE4Cd3vMtcfZzyF3cinfCWGQpfyoB2RtAw5JSu
         XPtw==
X-Gm-Message-State: AOAM532tdMir/Ugqj7f17qZj9ncUG4U3B6X9FCDiiHWFtoEkvyjw7pac
        iAQCASKfy1ItzlfWULO1cXk=
X-Google-Smtp-Source: ABdhPJyvZ69alcJ1qVtVZsyqrpWWhGwIisnUme4+VeTanfmmb6G5yU8i4xiobWbQBkfKYpwT5zdM0w==
X-Received: by 2002:a05:6a00:1acb:b0:4fb:358f:fe87 with SMTP id f11-20020a056a001acb00b004fb358ffe87mr32002184pfv.75.1649669755677;
        Mon, 11 Apr 2022 02:35:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:35:55 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 04/11] KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
Date:   Mon, 11 Apr 2022 17:35:30 +0800
Message-Id: <20220411093537.11558-5-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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
index adbf07695e1f..51035bd29511 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -312,18 +312,13 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
+void reprogram_counter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, pmc_idx);
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
@@ -342,8 +337,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
-
-		reprogram_counter(pmu, bit);
+		reprogram_counter(pmc);
 	}
 
 	/*
@@ -527,13 +521,12 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
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
index 2a53b6c9495c..dbcac971babb 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -137,7 +137,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
+void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9db662399487..2feff54e2e45 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -56,16 +56,32 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	pmu->fixed_ctr_ctrl = data;
 }
 
+static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	if (pmc_idx < INTEL_PMC_IDX_FIXED) {
+		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
+				  MSR_P6_EVNTSEL0);
+	} else {
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
2.35.1

