Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1274B649F46
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiLLNAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiLLM7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968F012A89;
        Mon, 12 Dec 2022 04:59:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d7so11973943pll.9;
        Mon, 12 Dec 2022 04:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7atUrLJtNTGOgIKhNavIVJ+xQL4raMerkyaaS0gzJtA=;
        b=Pg3STCDimi35mpNhwD8sMpw6ZNnAuJ+8npxiRMF3tIO6ggOJ7bYOdcb4pUEm9h54Ir
         77a0BRJJqkX7/vDDZW6ZIxRSvz0uH1T6D2mjYqW3+oipDrnanyqg3Bpvwpv6kzlOnpbD
         2feS1Bj8G5OtWiH2y/XLCdowECNskdzsXiNpsjnqErAZkanVG9cqiTbGyYBe5newLdoV
         LwD58udI9Zx+vdQIFdRrOwXwVB6zubbokEru9npczrq8lRsmyPMjHcWH4QKJItG2jQkd
         6Vp21QK4HYPu73aEEuvofZz0W/hfzmPH3AlZFUFxBborLBQVN7g+bPRkYbdJY/S++/Ae
         mtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7atUrLJtNTGOgIKhNavIVJ+xQL4raMerkyaaS0gzJtA=;
        b=VSVEsvvUu2RZNhKkHzjQ7T/cubzPnk47UHB4Gy6jEyOvAyYrxvUxjacobbHru/q2Hq
         xqItdHXL1qy0wLg82KcqfCgADDb3ujpY6JHPcAWc/sRk9HSVVy5oopXXVYCUAVV2mQnS
         yFrde7I23oVaYoFdbb5cZElBQFbfejPbODL3pIU/jcL5OuhBcHQRjzrDxzKppOcZJ5jx
         hK9Octi/5hmhwVly+LyfkqERccv8Ypcz0F3mTd1R1sAeXg7zxTXDEoIWjNdXCR/GlCwY
         qDhOXP9zUqdkzdscOA/VNp4sbvYGEcJFZR+uhO3HnpRp2w/rWPTYiZ4a/dry7moNaIPt
         MhTA==
X-Gm-Message-State: ANoB5pmeqIZEwFc26YC6WUoQQKiLP4CpJpaCBAJXydOtx2dws0tj1PEA
        cgqIsC6gj3LdwziVc7yau2QV+ADZ44emoadS
X-Google-Smtp-Source: AA0mqf4KCOWlgyWT+WvddG2AlGtXsFBx0Cg1wzWs1/N5aSdxymgWIAEKNtIwmH1WadJQw1w0nSDVvQ==
X-Received: by 2002:a17:902:a70b:b0:187:2501:72fb with SMTP id w11-20020a170902a70b00b00187250172fbmr16553823plq.46.1670849970963;
        Mon, 12 Dec 2022 04:59:30 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RFC 7/8] KVM: x86/pmu: Use flex *event arrays to implement grouped events
Date:   Mon, 12 Dec 2022 20:58:43 +0800
Message-Id: <20221212125844.41157-8-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The current vPMU would expect that a pmc tends to represent a hardware
event and use pmc->counter to track the event value.

But from the perspective of the counter designer，a hardware counter
can choose to sacrifice the maximum bit width of the counter and instead
reflect the values of multiple hardware events on different fields of
the same counter.

For example, a 32-bit counter can be divided into four 8-bit wide hardware
counters, and these hardware events are kept incrementing independently
in their own bitfields. Software can read the counter values once to get
the latest values of multiple hardware events, thus saving the number of
software accesses to the hardware interface and in virtualization,
particularly reducing the number of vm-exits.

The most natural way to emulate this all-in-one hardware counter in KVM
is to use a 1-to-N mapping relationship, i.e., a pmc can be associated with
multiple perf_events, and these events are created in a group manner, which
are scheduled in the host perf as a group to obtain hardware resources and
present them to the guest.

In implementation, when the guest accesses this all-in-one counter,
its pmc->max_nr_events changes according to the hardware definition,
triggering the kvm's group event creation path, which is centrally
created and then enabled in order, which eliminates the code differences
of separate enablement. The grouped events are also released as a group.

Which hardware events correspond to each pmc and how to divide the
available bitfields is predefined by the hardware vendor, and KVM
does not freely combine them. A many-to-one pmc is no different from
a one-to-one pmc in many cases. The first pmc->perf_event is always
the source of the pmc->counter value, which implies that most functions
that manipulate the state of pmc->perf_event do not need to be modified.

Note, the specific rules for splicing multiple perf_event->count values
into a single value are defined by the hardware event, which does not
and should not appear in this generic change.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++-
 arch/x86/kvm/pmu.c              | 44 ++++++++++++++++++++++++++-------
 arch/x86/kvm/pmu.h              | 15 ++++++++---
 arch/x86/kvm/svm/pmu.c          |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    |  2 ++
 5 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 413f2e104543..73740aa891d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -494,12 +494,12 @@ enum pmc_type {
 struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
+	u8 max_nr_events;
 	bool is_paused;
 	bool intr;
 	u64 counter;
 	u64 prev_counter;
 	u64 eventsel;
-	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
 	 * only for creating or reusing perf_event,
@@ -507,6 +507,10 @@ struct kvm_pmc {
 	 * ctrl value for fixed counters.
 	 */
 	u64 current_config;
+	union {
+		struct perf_event *perf_event;
+		DECLARE_FLEX_ARRAY(struct perf_event *, perf_events);
+	};
 };
 
 /* More counters may conflict with other existing Architectural MSRs */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f6c8180241d7..ae53a8298dec 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -160,7 +160,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool intr)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	struct perf_event *event;
+	struct perf_event *event, *group_leader;
 	struct perf_event_attr attr = {
 		.type = type,
 		.size = sizeof(attr),
@@ -172,6 +172,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		.config = config,
 	};
 	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+	unsigned int i;
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
@@ -204,18 +205,39 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 			attr.precise_ip = 3;
 	}
 
-	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
-						 kvm_perf_overflow, pmc);
-	if (IS_ERR(event)) {
-		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
-			    PTR_ERR(event), pmc->idx);
-		return PTR_ERR(event);
+	/*
+	 * To create grouped events, the first created perf_event doesn't
+	 * know it will be the group_leader and may move to an unexpected
+	 * enabling path, thus delay all enablement until after creation,
+	 * not affecting non-grouped events to save one perf interface call.
+	 */
+	if (pmc->max_nr_events > 1)
+		attr.disabled = 1;
+
+	for (i = 0; i < pmc->max_nr_events; i++) {
+		group_leader = i ? pmc->perf_event : NULL;
+		event = perf_event_create_kernel_counter(&attr, -1, current, group_leader,
+							 kvm_perf_overflow, pmc);
+		if (IS_ERR(event)) {
+			pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
+					     PTR_ERR(event), pmc->idx);
+			return PTR_ERR(event);
+		}
+
+		pmc->perf_events[i] = event;
+		pmc_to_pmu(pmc)->event_count++;
 	}
 
-	pmc->perf_event = event;
-	pmc_to_pmu(pmc)->event_count++;
 	pmc->is_paused = false;
 	pmc->intr = intr || pebs;
+
+	if (!attr.disabled)
+		return 0;
+
+	/* Enable grouped events in order. */
+	for (i = 0; i < pmc->max_nr_events; i++)
+		perf_event_enable(pmc->perf_events[i]);
+
 	return 0;
 }
 
@@ -223,6 +245,10 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
 {
 	u64 counter = pmc->counter;
 
+	/* The perf_event_pause() is not suitable for grouped events. */
+	if (pmc->max_nr_events > 1)
+		pmc_stop_counter(pmc);
+
 	if (!pmc->perf_event || pmc->is_paused)
 		return;
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b9e29a199ab8..e4b738b7c208 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -64,12 +64,19 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 
 static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
-	if (pmc->perf_event) {
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
-		pmc->current_config = 0;
+	unsigned int i;
+
+	for (i = 0; i < pmc->max_nr_events; i++) {
+		if (!pmc->perf_events[i])
+			continue;
+
+		perf_event_release_kernel(pmc->perf_events[i]);
+		pmc->perf_events[i] = NULL;
 		pmc_to_pmu(pmc)->event_count--;
 	}
+
+	pmc->current_config = 0;
+	pmc->max_nr_events = 1;
 }
 
 static inline void pmc_stop_counter(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 0e313fbae055..09e81200f657 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -200,6 +200,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
+		pmu->gp_counters[i].max_nr_events = 1;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b69d337d51d9..8e1f679d4d9d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -642,6 +642,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
+		pmu->gp_counters[i].max_nr_events = 1;
 	}
 
 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
@@ -649,6 +650,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].max_nr_events = 1;
 	}
 
 	lbr_desc->records.nr = 0;
-- 
2.38.2

