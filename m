Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62EE462DBA
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239195AbhK3HqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbhK3HqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 02:46:01 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B221BC061714;
        Mon, 29 Nov 2021 23:42:42 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s137so18899069pgs.5;
        Mon, 29 Nov 2021 23:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzxmwMQ1+XpebIcj0dAIJF5e91X774jV/0PiDyig/tg=;
        b=eGuOk5LwZTS4WxwE6yO7tuIIm3QJ4fRAn2EQs1dmdCxVaeiKgiouYYjDjrongZ+yx/
         fLSVkl1BaYjNb9wFgnOkTc1MFjl+9G9X2ozXRgTIrh0fwKjFIfqxmdRTUGDDxmpatbMJ
         mswz5KvxyVlIlzC5ndtebDCTHWA2CIiW5kJO+uxZF/XTtAI+/yhgp2Kwtc9hJOwYZSvY
         fjTW3UzMUY/7beldPufNaPBnHQv6NErx3cEpFVTMLfxkmIoFnaftVvQgxdam3u3Yqfy2
         fcgDLx2TneCj8DNYj3MIR01Pif2efJi5csXWnsoffgBPBsPhyUiTBWsG8yEEsU6xDtjS
         KIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzxmwMQ1+XpebIcj0dAIJF5e91X774jV/0PiDyig/tg=;
        b=oHXRTfp9ao4dJIu2lI0WMKC59107gidGYfd60UspLWxb4yBlaF3fN2C2wxUbJ8BtMb
         l7e1w5za6tpa/lvvjzDwblWp7d/V4y40zmlJR/w+l8GKfYrVM24neX2jDF3sD1o1u69G
         NQC+4CwOR0Z/5/5/n/qLNrC6W/8usknCYdcsh3pkI0vyJcEBUZkppryC+ExrGiW1nMSb
         OIVzLDM6wDQvRwbTh7gFNdwWBxdv1yM6mEh8xzSQTw91edy8X6dsaCcTfxt+GTAZalJO
         N2AswH0TGfzx+iCt8Re/1rJHCrCL4i5pNfY9ceQL12qZY0amjkEBvWlgh1RJQ+E3TYWm
         3YJg==
X-Gm-Message-State: AOAM531DbuV7maczh63+Y7a8xZFEveQt0bd6/vpfrS5OxH086NNyPojD
        1WQdQvNGpsy5rUJbOG7UmX5MMpT1dR8=
X-Google-Smtp-Source: ABdhPJzdGRN8Yq7ZWzA+pyX/vaZOSo2Ki/dSXZlXF84BzQLecbyqdyFS32B/iBnk7RY3zyUmu6SKMA==
X-Received: by 2002:a62:1544:0:b0:49f:f74e:8327 with SMTP id 65-20020a621544000000b0049ff74e8327mr43063648pfv.55.1638258162265;
        Mon, 29 Nov 2021 23:42:42 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h13sm19066010pfv.84.2021.11.29.23.42.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 23:42:42 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v2 4/6] KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()
Date:   Tue, 30 Nov 2021 15:42:19 +0800
Message-Id: <20211130074221.93635-5-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130074221.93635-1-likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
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

The __kvm_perf_overflow() can be called in non-nmi contexts
and a flag is needed to distinguish the caller context and thus
avoid a check on kvm_is_in_guest(), otherwise we might get
warnings from suspicious RCU or check_preemption_disabled().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 58 ++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e41ad1ead721..6c2b2331ffeb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -495,6 +495,7 @@ struct kvm_pmc {
 	 */
 	u64 current_config;
 	bool is_paused;
+	bool intr;
 };
 
 struct kvm_pmu {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b7a1ae28ab87..a20207ee4014 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -55,43 +55,41 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 	kvm_pmu_deliver_pmi(vcpu);
 }
 
-static void kvm_perf_overflow(struct perf_event *perf_event,
-			      struct perf_sample_data *data,
-			      struct pt_regs *regs)
+static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
-	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
-		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
-	}
+	/* Ignore counters that have been reprogrammed already. */
+	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
+		return;
+
+	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+
+	if (!pmc->intr)
+		return;
+
+	/*
+	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
+	 * can be ejected on a guest mode re-entry. Otherwise we can't
+	 * be sure that vcpu wasn't executing hlt instruction at the
+	 * time of vmexit and is not going to re-enter guest mode until
+	 * woken up. So we should wake it, but this is impossible from
+	 * NMI context. Do it from irq work instead.
+	 */
+	if (in_pmi && !kvm_is_in_guest())
+		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
+	else
+		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
 }
 
-static void kvm_perf_overflow_intr(struct perf_event *perf_event,
-				   struct perf_sample_data *data,
-				   struct pt_regs *regs)
+static void kvm_perf_overflow(struct perf_event *perf_event,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
 {
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
-		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
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
+	__kvm_perf_overflow(pmc, true);
 }
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
@@ -126,7 +124,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 intr ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
@@ -138,6 +135,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->is_paused = false;
+	pmc->intr = intr;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
-- 
2.33.1

