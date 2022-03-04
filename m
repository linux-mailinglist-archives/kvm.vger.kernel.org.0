Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40864CD0B1
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiCDJGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbiCDJGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:13 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653031A2739;
        Fri,  4 Mar 2022 01:05:08 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q11so7157572pln.11;
        Fri, 04 Mar 2022 01:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AL/92bJXe6y9OylFQvrobB71ZTf/Jf+RWzxmr7lt/X8=;
        b=ikj3vNNWG3dvg6nc6o3s2Xk6KkjMxBcQq9yXN9gxRLIWnrFIhFwJ0Ft11sMQ2x20S0
         6n3xNA88bFGeUA2bZrZTx8Lh+fGyd0ao5y/MziEGPcQHC4yUXR6xFd1FKX/lryt6icgA
         Ok9oB0g9sW7PqDv4RidtVa4GZx5N8OsTTbiPA3zdILmubsYxV3bYPnGpun+L8XftdNy+
         eubbDyCYJvGRcZqm9M7yyA5+wucQvOJ9IebFU+gZzqLavZvk+FSxEZUkd9gVnLIFyfpk
         TlhUP2PJ0nb+9jsywaUwjg5e0h0ciluji2Ec0+MSouC5TIppSKRCbKNwaHdVGjkahjre
         nUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AL/92bJXe6y9OylFQvrobB71ZTf/Jf+RWzxmr7lt/X8=;
        b=pSgqJ/1nylw/W4CcJcBgtWHaaHBWqqSZf413JZMlKsnE7TK6/Y2jTf6b/Lakxp0Sio
         qM/1x9C2vreh12UVJilqBmAtAkVw8OHFwH6j0hxPuU0ofzRhFCvK20SpvtImt0ulPSF7
         XOHjPRj91Jhg1FVSoy2ToR3V2GJRr6/zWgZSVjVjYiepmUf2BqcprMTEA60z+dXgdyIR
         agnwHq4IbAFOsoVkQTPwa1SB+IwKs1iWQk6oPQHTuQr5zXNDc11mIZ0Rsh+n1Ns6odk9
         gKirDI8UCkWSpvxa2qzIYf96TUhqlnpsoLT7QGr2FhnYyi1Wdug8wGd8YUZOy9JXPL9T
         kNJQ==
X-Gm-Message-State: AOAM531E21P0eBpML0mAqTudzkNfACGOmCuLLMeA2S22fGHu3V31uib9
        CO7dcl9vkvVZlVp99j/Zpu2b9NCY6hmTuqm0
X-Google-Smtp-Source: ABdhPJz53bLwQzOOixtiHRuzQflvlf1ajrLAHu+w8nnwjWUDwypKjaWt38/qU4REGnPUWPa6gLHzsA==
X-Received: by 2002:a17:902:ed82:b0:151:9b29:5123 with SMTP id e2-20020a170902ed8200b001519b295123mr11434537plj.138.1646384708274;
        Fri, 04 Mar 2022 01:05:08 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:08 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 08/17] KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
Date:   Fri,  4 Mar 2022 17:04:18 +0800
Message-Id: <20220304090427.90888-9-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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

When a guest counter is configured as a PEBS counter through
IA32_PEBS_ENABLE, a guest PEBS event will be reprogrammed by
configuring a non-zero precision level in the perf_event_attr.

The guest PEBS overflow PMI bit would be set in the guest
GLOBAL_STATUS MSR when PEBS facility generates a PEBS
overflow PMI based on guest IA32_DS_AREA MSR.

Even with the same counter index and the same event code and
mask, guest PEBS events will not be reused for non-PEBS events.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/pmu.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b1a02993782b..51a218f53fed 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -60,15 +60,22 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	bool skip_pmi = false;
 
 	/* Ignore counters that have been reprogrammed already. */
 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 		return;
 
-	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
+		/* Indicate PEBS overflow PMI to guest. */
+		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+					      (unsigned long *)&pmu->global_status);
+	} else {
+		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	}
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
-	if (!pmc->intr)
+	if (!pmc->intr || skip_pmi)
 		return;
 
 	/*
@@ -99,6 +106,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -110,6 +118,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
 	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
 		return;
@@ -127,6 +136,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		attr.sample_period = 0;
 		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
+	if (pebs) {
+		/*
+		 * The non-zero precision level of guest event makes the ordinary
+		 * guest event becomes a guest PEBS event and triggers the host
+		 * PEBS PMI handler to determine whether the PEBS overflow PMI
+		 * comes from the host counters or the guest.
+		 *
+		 * For most PEBS hardware events, the difference in the software
+		 * precision levels of guest and host PEBS events will not affect
+		 * the accuracy of the PEBS profiling result, because the "event IP"
+		 * in the PEBS record is calibrated on the guest side.
+		 *
+		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
+		 * could possibly care here is unsupported and needs changes.
+		 */
+		attr.precise_ip = 1;
+	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_perf_overflow, pmc);
@@ -140,7 +166,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->is_paused = false;
-	pmc->intr = intr;
+	pmc->intr = intr || pebs;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
@@ -166,6 +192,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
+	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
+	    pmc->perf_event->attr.precise_ip)
+		return false;
+
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
 	perf_event_enable(pmc->perf_event);
 	pmc->is_paused = false;
-- 
2.35.1

