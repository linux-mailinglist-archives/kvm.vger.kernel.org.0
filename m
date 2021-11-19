Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC19456A6C
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 07:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhKSGwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 01:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhKSGwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 01:52:20 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE4CC061574;
        Thu, 18 Nov 2021 22:49:18 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q12so7820272pgh.5;
        Thu, 18 Nov 2021 22:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZjQKmCWi7B+NrihnvF8SmL+lBcJx6mkBfv3Us362+9Q=;
        b=SoVcdnsXuGxQtkVxUOh8kRHg2BnsvnyxyM+U9xMcL63Ch95kxCZlvuNy4w65yFqSii
         myouJepethPhm41j6xS819BM3r8mvl62h9tzxj7AgqS8oJPWJFbhRpqce4U6ypZPXD74
         PrsLm26ThCmbN1Fu8ReKCi4XzwC/4R4LAtBRRRlXGxkKp1fiVWVcsx3Ldp9+L5hmA/lI
         o4vlxM0JVdLxfAA+VtcRqD2kQzpyLqTKM1iHI2KTqqw+DQnvY9cKshfZB37f91lnT8VD
         VgEqbJWpKx4tJxw/TfHVvYEV/p3j24kWvvVaZkj6DXmsHopZEkMfIQEFpjXi/Nlp2HH4
         CRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZjQKmCWi7B+NrihnvF8SmL+lBcJx6mkBfv3Us362+9Q=;
        b=7ZIsmmP6DxSH2ciogyXyyARXBEgOFfuGezx8+pua3jVFH/zfaDib6Ter4w2clmkJwr
         CM0vZMfe9H9VssBbU3UOV/1bvZWpPWZRwMeQU/C1fH0m+OWnxjLTMc5KSD/iJDurAJF/
         nJ6DhkuUnd/15fr+a/v0f1zq54UcIko8U6MxLWZ2gJlNPR1/w3JnLlFBG3bXkVrTLLjT
         F5wGSpPC8k3q8YySkqjSZ8IQbaON3YxNqrKtlwPaaBXBlI6vWAMS9cBT+dmh/lRVl/vN
         6Mm0ZPIimInBoVGpXpI4DPiD37pYMeNY/3jntzPeg9OPQag1ftge//3alXhtNvMc/rPn
         f/XA==
X-Gm-Message-State: AOAM530UOxhXEJR2SJX+wd9/rdA4E/tob2Z7usDxB/kFt9GHg0UIbusH
        WuPY2HMZQhcc4u6ze4LLQT92SOAir4s=
X-Google-Smtp-Source: ABdhPJydDK8ISILmBNFGDqmubg/PfNYehNlYZIAMaeQJKNdaClnepaaOTYobsGKPn6H8LTbvbN0JWA==
X-Received: by 2002:a05:6a00:1248:b0:4a2:5cba:89cb with SMTP id u8-20020a056a00124800b004a25cba89cbmr57870098pfi.12.1637304557610;
        Thu, 18 Nov 2021 22:49:17 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mr2sm1286928pjb.25.2021.11.18.22.49.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 22:49:17 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
Date:   Fri, 19 Nov 2021 14:48:56 +0800
Message-Id: <20211119064856.77948-5-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119064856.77948-1-likexu@tencent.com>
References: <20211119064856.77948-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Depending on whether intr should be triggered or not, KVM registers
two different event overflow callbacks in the perf_event context.

The code skeleton of these two functions is very similar, so
the pmc->intr can be stored into pmc from pmc_reprogram_counter()
which provides smaller instructions footprint against the
u-architecture branch predictor.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 48 ++++++++++++++-------------------
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fcb345bc107..9fa63499e77e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -496,6 +496,7 @@ struct kvm_pmc {
 	 */
 	u64 current_config;
 	bool is_paused;
+	bool intr;
 };
 
 struct kvm_pmu {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b7a1ae28ab87..9b52f18f56e0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -62,36 +62,28 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
-		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
-	}
-}
+	/* Ignore counters that have been reprogrammed already. */
+	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
+		return;
 
-static void kvm_perf_overflow_intr(struct perf_event *perf_event,
-				   struct perf_sample_data *data,
-				   struct pt_regs *regs)
-{
-	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
-	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
-		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+	if (!pmc->intr)
+		return;
 
-		/*
-		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
-		 * can be ejected on a guest mode re-entry. Otherwise we can't
-		 * be sure that vcpu wasn't executing hlt instruction at the
-		 * time of vmexit and is not going to re-enter guest mode until
-		 * woken up. So we should wake it, but this is impossible from
-		 * NMI context. Do it from irq work instead.
-		 */
-		if (!kvm_is_in_guest())
-			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
-		else
-			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
-	}
+	/*
+	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
+	 * can be ejected on a guest mode re-entry. Otherwise we can't
+	 * be sure that vcpu wasn't executing hlt instruction at the
+	 * time of vmexit and is not going to re-enter guest mode until
+	 * woken up. So we should wake it, but this is impossible from
+	 * NMI context. Do it from irq work instead.
+	 */
+	if (!kvm_is_in_guest())
+		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
+	else
+		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
 }
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
@@ -126,7 +118,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 intr ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
@@ -138,6 +129,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->is_paused = false;
+	pmc->intr = intr;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
-- 
2.33.1

