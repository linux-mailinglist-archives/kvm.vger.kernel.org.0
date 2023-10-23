Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCE27D4356
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjJWXka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjJWXkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:40:18 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BDA10E2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5b87150242cso2379968a12.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104414; x=1698709214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qUH4I8dRZYZdtSJK7SIMlGfWi/fWxXkAkYB7xZkkAPk=;
        b=cMMBVzmoNR/o7Mx04hDAFX2YXFvVUgT7Ud+6RkV1oR4ISwoZ+veNYZE2zG0ZN5GLgK
         Urc/PX4Ixlvm8ZsPDkKOQm2OdJAq0Bi7RG7xY3YR01BfHxsLpW0I4e/Ifp3GBwxfNQYV
         iebilztHcdacpJppIpI0ew6D/A3vmNI47CqA6/xgA0QwwqSQ4XwyJHzirRS0nhyGJzWf
         R6jM75esKzX8HoWsklfbYOlLeHjosAUSFLrUjASAiko9LxtEvt+KWa0EAL4VuRtJGCcM
         ZFQtmahaA5KOZqr3ftCk/UgfEpZsvQUbg2nIN76BMunaKgMxO0/NhxcRUI2+8l0+HtBi
         ss9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104414; x=1698709214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qUH4I8dRZYZdtSJK7SIMlGfWi/fWxXkAkYB7xZkkAPk=;
        b=OA4xauZAwQ4XJF/ezu3bmQuUBgdu8W0GTrk+vk8lKUgLHOfYzNjnDfyNustZjGdFox
         yqJBsmOVTFH2ixQZBGUN50JizBXQ4QcbdNjuhQy6XT3Wdy7Ts70le36YSPwSbW7g+70R
         JgeJugmC7X0AJN9K+AY2bBalY1wiJQfVtiX8ilkvTIatI700ThciLY+CVdxS+682Zphf
         llYhX9odwL+sOnd6mGJV4r4SdLJCdhDLCRtIQ033jUgdT3x8RJ2P5Xs476tpgQKR4mQk
         5OtRCKvOolYm8hVlIijVyLByErlgBAjtAWJlVmtKnEHeIcLsjDXDy7UfVNa5JUhEe2AX
         N68g==
X-Gm-Message-State: AOJu0Yy0oxhIOHwU+r9u1ywRRc3tAnJDND8K8qM/TVloYDVqeQsF7G6y
        bX5A55FWEnttCDpPQs8WTBuAZWPwBrU=
X-Google-Smtp-Source: AGHT+IHlq1CeC/WoWgz0CTXW5UjYJPfHpY7mtMCpxFg/1pdX7v89esWBp2sWfD+drMribdJgxh3H58FXWh8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:518b:0:b0:56b:6acd:d5f8 with SMTP id
 h11-20020a65518b000000b0056b6acdd5f8mr187066pgq.7.1698104414521; Mon, 23 Oct
 2023 16:40:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 16:40:00 -0700
In-Reply-To: <20231023234000.2499267-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023234000.2499267-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023234000.2499267-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: x86/pmu: Track emulated counter events instead of
 previous counter
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly track emulated counter events instead of using the common
counter value that's shared with the hardware counter owned by perf.
Bumping the common counter requires snapshotting the pre-increment value
in order to detect overflow from emulation, and the snapshot approach is
inherently flawed.

Snapshotting the previous counter at every increment assumes that there is
at most one emulated counter event per emulated instruction (or rather,
between checks for KVM_REQ_PMU).  That's mostly holds true today because
KVM only emulates (branch) instructions retired, but the approach will
fall apart if KVM ever supports event types that don't have a 1:1
relationship with instructions.

And KVM already has a relevant bug, as handle_invalid_guest_state()
emulates multiple instructions without checking KVM_REQ_PMU, i.e. could
miss an overflow event due to clobbering pmc->prev_counter.  Not checking
KVM_REQ_PMU is problematic in both cases, but at least with the emulated
counter approach, the resulting behavior is delayed overflow detection,
as opposed to completely lost detection.

Cc: Mingwei Zhang <mizhang@google.com>
Cc: Roman Kagan <rkagan@amazon.de>
Cc: Jim Mattson <jmattson@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 17 +++++++++++++++-
 arch/x86/kvm/pmu.c              | 36 +++++++++++++++++++++++----------
 arch/x86/kvm/pmu.h              |  3 ++-
 3 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..d8bc9ba88cfc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -500,8 +500,23 @@ struct kvm_pmc {
 	u8 idx;
 	bool is_paused;
 	bool intr;
+	/*
+	 * Base value of the PMC counter, relative to the *consumed* count in
+	 * the associated perf_event.  This value includes counter updates from
+	 * the perf_event and emulated_count since the last time the counter
+	 * was reprogrammed, but it is *not* the current value as seen by the
+	 * guest or userspace.
+	 *
+	 * The count is relative to the associated perf_event so that KVM
+	 * doesn't need to reprogram the perf_event every time the guest writes
+	 * to the counter.
+	 */
 	u64 counter;
-	u64 prev_counter;
+	/*
+	 * PMC events triggered by KVM emulation that haven't been fully
+	 * processed, i.e. haven't undergone overflow detection.
+	 */
+	u64 emulated_counter;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3725d001239d..f02cee222e9a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -127,9 +127,9 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 
 	/*
-	 * Ignore overflow events for counters that are scheduled to be
-	 * reprogrammed, e.g. if a PMI for the previous event races with KVM's
-	 * handling of a related guest WRMSR.
+	 * Ignore asynchronous overflow events for counters that are scheduled
+	 * to be reprogrammed, e.g. if a PMI for the previous event races with
+	 * KVM's handling of a related guest WRMSR.
 	 */
 	if (test_and_set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi))
 		return;
@@ -226,13 +226,19 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
 {
-	u64 counter = pmc->counter;
+	/*
+	 * Accumulate emulated events, even if the PMC was already paused, e.g.
+	 * if KVM emulated an event after a WRMSR, but before reprogramming, or
+	 * if KVM couldn't create a perf event.
+	 */
+	u64 counter = pmc->counter + pmc->emulated_counter;
 
-	if (!pmc->perf_event || pmc->is_paused)
-		return;
+	pmc->emulated_counter = 0;
 
 	/* update counter, reset event value to avoid redundant accumulation */
-	counter += perf_event_pause(pmc->perf_event, true);
+	if (pmc->perf_event && !pmc->is_paused)
+		counter += perf_event_pause(pmc->perf_event, true);
+
 	pmc->counter = counter & pmc_bitmask(pmc);
 	pmc->is_paused = true;
 }
@@ -289,6 +295,14 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
 
 void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 {
+	/*
+	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
+	 * read-modify-write.  Adjust the counter value so that it's value is
+	 * relative to the current perf_event (if there is one), as reading the
+	 * current count is faster than pausing and repgrogramming the event in
+	 * order to reset it to '0'.
+	 */
+	pmc->emulated_counter = 0;
 	pmc->counter += val - pmc_read_counter(pmc);
 	pmc->counter &= pmc_bitmask(pmc);
 	pmc_update_sample_period(pmc);
@@ -426,6 +440,7 @@ static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 static void reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 prev_counter = pmc->counter;
 	u64 eventsel = pmc->eventsel;
 	u64 new_config = eventsel;
 	u8 fixed_ctr_ctrl;
@@ -435,7 +450,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	if (!pmc_event_is_allowed(pmc))
 		goto reprogram_complete;
 
-	if (pmc->counter < pmc->prev_counter)
+	if (pmc->counter < prev_counter)
 		__kvm_perf_overflow(pmc, false);
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -475,7 +490,6 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 reprogram_complete:
 	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
-	pmc->prev_counter = 0;
 }
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
@@ -701,6 +715,7 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 
 		pmc_stop_counter(pmc);
 		pmc->counter = 0;
+		pmc->emulated_counter = 0;
 
 		if (pmc_is_gp(pmc))
 			pmc->eventsel = 0;
@@ -772,8 +787,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	pmc->prev_counter = pmc->counter;
-	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
+	pmc->emulated_counter++;
 	kvm_pmu_request_counter_reprogram(pmc);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cae85e550f60..7caeb3d8d4fd 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -66,7 +66,8 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
 
-	counter = pmc->counter;
+	counter = pmc->counter + pmc->emulated_counter;
+
 	if (pmc->perf_event && !pmc->is_paused)
 		counter += perf_event_read_value(pmc->perf_event,
 						 &enabled, &running);
-- 
2.42.0.758.gaed0368e0e-goog

