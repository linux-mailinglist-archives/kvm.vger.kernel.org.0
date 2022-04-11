Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB294FB7A2
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344493AbiDKJic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344483AbiDKJiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762641E3E1;
        Mon, 11 Apr 2022 02:36:02 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q3so2114789plg.3;
        Mon, 11 Apr 2022 02:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bLdla3mU+aqH075Brk+pTSjv+gdpbghXMwmT61qZGec=;
        b=a8V3QSX7KylwA86e1IeeZsIC5+382mMuEu5Qg+mj4pXZezFHij8jCt+AcISsyRn5Qw
         NkMUuOsPsHKrWtU4JyKYTEMTZClSYgcymUdvwT80JxUVJ0KnuFgd492FLvLtO1sNo5lC
         gVRvb3Xj+EheLssVzFuvJXfW0rXIVM2wki1WBmvjNxy67lZr6fzfOW40ztn7r567bgAN
         T9fzOj3/5iC3r9AJSeSdBM7rN+2u58oPqZHdwkX8fmx6XjF3ucuxrWwpJ80jhYoK1OYG
         3zAA7sKrjuWGK0JBMvNHgAr0Br8Mp3FkumNZX5HmYCzFp6fccAcRuSJkO7P62Li4J2jM
         zQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bLdla3mU+aqH075Brk+pTSjv+gdpbghXMwmT61qZGec=;
        b=KN6QnKEBCLj8p6xWBQTf6B77TD+hqvNZ4IROWaPUbZDof8r1+D0iy9vBMZ3Px9pFfF
         jl/VE9GYd9I/2aftbwvsfTsG7SoZs9tQUhC0J5a4kdYzUfBMwlbGSlarHetp2+PZbBUP
         GE0rP72MN4ckeKiBjvgkMg1uZiNktRb9UhkE0hWVtMlkK/zkZe+KEkenZnzI++VMUb7u
         J4dFxjMl7/4XcMZCpn7G92q4XpqBYHPEN2+3jLCCaLN/sgtaJBrpgcFAWLqB3zbGEjQ4
         u66Cz0TiNPgnP9ov/upaHJVaSzZ3HL+hQDFsdDRBN2XaAOV120I5TB8aMk4DNiDD0f5r
         9VqQ==
X-Gm-Message-State: AOAM533Qhzdgj/adluruOi5GJefSVdWDP8ZYBfIEvgkxGC2dkzoVP19e
        HmkYGSfiujssbs/zF/0QXNM=
X-Google-Smtp-Source: ABdhPJxzVkVRV9Sjdgbkcno5P8vS+JFa7EqJxXRVKIUyjaMPKwP+nK2SHlNOoqOi8ChSncGt4F+z/A==
X-Received: by 2002:a17:90a:b00f:b0:1c9:9205:433 with SMTP id x15-20020a17090ab00f00b001c992050433mr35260183pjq.116.1649669761806;
        Mon, 11 Apr 2022 02:36:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:36:01 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 06/11] KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
Date:   Mon, 11 Apr 2022 17:35:32 +0800
Message-Id: <20220411093537.11558-7-likexu@tencent.com>
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
index 419f44847520..23c7f3cfcc6b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -284,8 +284,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
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
 
@@ -315,12 +318,8 @@ void reprogram_counter(struct kvm_pmc *pmc)
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
index 5ec34b940fa1..9ea01fe02802 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -136,7 +136,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 }
 
 void reprogram_gp_counter(struct kvm_pmc *pmc);
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
+void reprogram_fixed_counter(struct kvm_pmc *pmc);
 void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3bf8a22ea2e5..ce71ad29643c 100644
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

