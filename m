Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3484A45320D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhKPMYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbhKPMYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:24:39 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E3FC061746;
        Tue, 16 Nov 2021 04:21:42 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t21so17227244plr.6;
        Tue, 16 Nov 2021 04:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FErY3LGewnY6+TGF0EyO560jrhVYm9Tzy44GCNEa3Fc=;
        b=USchBcFCVTBgOftgykvUz1ZnyI6xgWfM8ZZM8v2sCfW+J5XdlzW3cvDMmGaW3cHd9g
         ku6Oeu3LYAlUtEohzOxWoRvQ8Ikq9ul+pY0zxuRKXWaLlCG+IGFkIzPbtr3jUvCDJXjk
         Gl8Tl29LkflMWOnUCSnywOFQWq5XtMlpak05HSuRcql99No24bIbmJzKcPTkhamfUVYd
         kHNsk9adHWb/6JR1YIeZs5x/Ev4nk85gge1v5/lRPD939ZgA8LpSyUDt6xuM1iAyZk7H
         u00K3ICLVo4XEqdVX88dH4fEWZfnqPUCdXd2Czlm3WhYYSQrqda2yyIjveNSxhVQIFd7
         w/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FErY3LGewnY6+TGF0EyO560jrhVYm9Tzy44GCNEa3Fc=;
        b=b/P/E9Bxr4Z0303nH3SAOLUbktfvQDeI9NzPfdQ2WNqDJ2UE+tU3KNHNtiqXeqPUdk
         bXJwOWiW7N18CWrSjbXe3cOOL2UIF1s8TYbE4NEUwz5PkbC6pwAg/dTt1njdIx3pVeib
         fYoR7MNlyEC2MiXz+Mq2Q7d/lYlkh6xHFr50leag+wAxsZG1SGZJNTMSpv0uSwq5xj/8
         6BCpcg39jdfRrcMKhMpjZsKEBSV3LLvXCSKUPz+GvRsXX/u8OqaMVez+4xes+4JAO51R
         4mekJmFkpVYcRUV67QxALrXyusUfH3jb/AFWh9vKlP/bqeezzTR3xpmc/7iqhHRP21dY
         SH3g==
X-Gm-Message-State: AOAM533u+EgWq9dTQNGmp0Drx7eI4SvPVbgPH8Ru11S/RRY0TYOtkk6I
        eAevhH5JGwqVWzLRNlmLRaaUb4WuZqY=
X-Google-Smtp-Source: ABdhPJyf1wf6zjwq8ZicuWkWEpd4PNCV0MSpRC5N16PFXXzg6gaOdAgs+9knP3RnSk4N65nfdIUENQ==
X-Received: by 2002:a17:90b:1bd1:: with SMTP id oa17mr8205970pjb.246.1637065302154;
        Tue, 16 Nov 2021 04:21:42 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i67sm18557613pfg.189.2021.11.16.04.21.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 04:21:40 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: x86/pmu: Refactoring kvm_perf_overflow{_intr}()
Date:   Tue, 16 Nov 2021 20:20:30 +0800
Message-Id: <20211116122030.4698-5-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116122030.4698-1-likexu@tencent.com>
References: <20211116122030.4698-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Depending on whether intr should be triggered or not, KVM registers
two different event overflow callbacks in the perf_event context.

The code skeleton of these two functions is very similar, so
need_overflow_intr() is introduced to increase the potential code reuse.

There is a trade-off between extra cycles in the irq context and a
smaller instructions footprint against the u-architecture branch predictor.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 64 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3c45467b4275..ef4bba8be7f7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -55,43 +55,50 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 	kvm_pmu_deliver_pmi(vcpu);
 }
 
-static void kvm_perf_overflow(struct perf_event *perf_event,
-			      struct perf_sample_data *data,
-			      struct pt_regs *regs)
+static inline bool need_overflow_intr(struct kvm_pmc *pmc)
 {
-	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
-		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
-	}
+	if (pmc_is_gp(pmc))
+		return (pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT);
+	else
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x8;
 }
 
-static void kvm_perf_overflow_intr(struct perf_event *perf_event,
-				   struct perf_sample_data *data,
-				   struct pt_regs *regs)
+static inline void kvm_pmu_counter_overflow(struct kvm_pmc *pmc, bool intr)
 {
-	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
-		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
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
+	if (!intr)
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
+	if (!kvm_is_in_guest())
+		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
+	else
+		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
+}
+
+static void kvm_perf_overflow(struct perf_event *perf_event,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
+		kvm_pmu_counter_overflow(pmc, need_overflow_intr(pmc));
 }
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
@@ -126,7 +133,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 intr ? kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
-- 
2.33.1

