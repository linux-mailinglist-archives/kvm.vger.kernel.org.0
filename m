Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F137D4359
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjJWXke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjJWXkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:40:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7125010D4
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8486b5e780so4714212276.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104412; x=1698709212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OISog/o/YxfGLkUORpMvb/M1MSKf5KJE5wnNSowczuI=;
        b=wLXVmR9UP/bjufj9VE+LKQaDenAFjAQxbqE1P3oYxr3WlAFfhMZ8PadwSS32blTuOT
         HflzfbuPUK6FudK3LQWK9bH2PGepgLbk+EQFjzInzWZVgrYQebPVIomaKLwBvP2pJ37X
         ldKgt69Y/wAvI0y/rEt22TYnLTN1PNRHQQVIVpjAu+BuI+ANZyOSGu/OSsV8zVqu4Y2i
         99UIBrBCiOcqZ/hFVnA7JyyFOdaszzo+wiKlgbKvDNME9MW1A58+xKVGv6Vfrc58IbCx
         zDdT4XymXvR4LtkHxfGTjrNs9pnKqhXa90YdXfi7kDuCGJ1mOXx3V7ZgiOiLSyNySAB3
         j4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104412; x=1698709212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OISog/o/YxfGLkUORpMvb/M1MSKf5KJE5wnNSowczuI=;
        b=ndm4Av0Lhc4Uf74eN2tesSI8VWiNYcFKXa2kVmhOhJ6LrdFrc/mFQryAlF4+6PyQRk
         K6VY+mUXtVoZvfYEAqinP/wTBq1A+58njfoJnhNI596k03gLi02/Mrx4v+x2V7qMm4zz
         SSnMt1MnM0YCVmKsS95/hrCoIIZxU3R7hKwZgyMBhnhxk8j++FAcwuOw6rH12HAOCBOq
         j7p10stb8b6Qh0ZaNbhzif9CKnjlW/e6Q+5bnLqtKBK9Br1MjZ5GPoPdi2ZmWNZ33y5m
         dyeTPbDTDEVgGdGo+g1KUfJrcXvbgoJ+kuTQTFrWr/uMUxVuhvhrh9qtWqGgsSZIbRJx
         UySw==
X-Gm-Message-State: AOJu0YwUabcgGvD40CgUa0CXhi3UCmS4wXm2a1Z+/k5USm6RY3pLt9pc
        xUyxs0nx4zpn9msWVD75gaiIj2xz6hM=
X-Google-Smtp-Source: AGHT+IGdvIZLByyBNIUhCTP9Wm8mWMSf/+Xbp5sifAxXAMGbFzJRLll9+DfM5lV5yha3lmakbmYIlQgF+wc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:da8d:0:b0:d9b:454d:352d with SMTP id
 n135-20020a25da8d000000b00d9b454d352dmr217208ybf.9.1698104412611; Mon, 23 Oct
 2023 16:40:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 16:39:59 -0700
In-Reply-To: <20231023234000.2499267-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023234000.2499267-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023234000.2499267-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: x86/pmu: Update sample period in pmc_write_counter()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update a PMC's sample period in pmc_write_counter() to deduplicate code
across all callers of pmc_write_counter().  Opportunistically move
pmc_write_counter() into pmc.c now that it's doing more work.  WRMSR isn't
such a hot path that an extra CALL+RET pair will be problematic, and the
order of function definitions needs to be changed anyways, i.e. now is a
convenient time to eat the churn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h           | 25 +------------------------
 arch/x86/kvm/svm/pmu.c       |  1 -
 arch/x86/kvm/vmx/pmu_intel.c |  2 --
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c06090196b00..3725d001239d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -161,6 +161,15 @@ static u64 pmc_get_pebs_precise_level(struct kvm_pmc *pmc)
 	return 1;
 }
 
+static u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
+{
+	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
+
+	if (!sample_period)
+		sample_period = pmc_bitmask(pmc) + 1;
+	return sample_period;
+}
+
 static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool exclude_user, bool exclude_kernel,
 				 bool intr)
@@ -268,6 +277,24 @@ static void pmc_stop_counter(struct kvm_pmc *pmc)
 	}
 }
 
+static void pmc_update_sample_period(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event || pmc->is_paused ||
+	    !is_sampling_event(pmc->perf_event))
+		return;
+
+	perf_event_period(pmc->perf_event,
+			  get_sample_period(pmc, pmc->counter));
+}
+
+void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
+{
+	pmc->counter += val - pmc_read_counter(pmc);
+	pmc->counter &= pmc_bitmask(pmc);
+	pmc_update_sample_period(pmc);
+}
+EXPORT_SYMBOL_GPL(pmc_write_counter);
+
 static int filter_cmp(const void *pa, const void *pb, u64 mask)
 {
 	u64 a = *(u64 *)pa & mask;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index db9a12c0a2ef..cae85e550f60 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -74,11 +74,7 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	return counter & pmc_bitmask(pmc);
 }
 
-static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
-{
-	pmc->counter += val - pmc_read_counter(pmc);
-	pmc->counter &= pmc_bitmask(pmc);
-}
+void pmc_write_counter(struct kvm_pmc *pmc, u64 val);
 
 static inline bool pmc_is_gp(struct kvm_pmc *pmc)
 {
@@ -128,25 +124,6 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 	return NULL;
 }
 
-static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
-{
-	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
-
-	if (!sample_period)
-		sample_period = pmc_bitmask(pmc) + 1;
-	return sample_period;
-}
-
-static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
-{
-	if (!pmc->perf_event || pmc->is_paused ||
-	    !is_sampling_event(pmc->perf_event))
-		return;
-
-	perf_event_period(pmc->perf_event,
-			  get_sample_period(pmc, pmc->counter));
-}
-
 static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 3fd47de14b38..b6a7ad4d6914 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -161,7 +161,6 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc_write_counter(pmc, data);
-		pmc_update_sample_period(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 90c1f7f07e53..a6216c874729 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -437,11 +437,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc_write_counter(pmc, data);
-			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc_write_counter(pmc, data);
-			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			reserved_bits = pmu->reserved_bits;
-- 
2.42.0.758.gaed0368e0e-goog

