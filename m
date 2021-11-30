Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92403462DB6
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbhK3HqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbhK3HqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 02:46:04 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7159C061714;
        Mon, 29 Nov 2021 23:42:45 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 133so730968pgc.12;
        Mon, 29 Nov 2021 23:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vayFNaDVZE3ZpmipANEaG4wpIWUVVgu6ZcSxACk3VoM=;
        b=YgIwgC+6WL8eCjCKoFb5ydJbiH8Tqze/sR3txrbvIJBHBZHf300LPgRASkQ/hAt3yY
         TtdfRctazrBtFmS9dxkku+V/f6Fo3wlFloEOuprnG4j2XGX22KKlNWGNT7wUl42Fi1m5
         JsscAndsRpiPD2nGwkmD1iXhOfJ7JAlh5fCB54vJQoQxzgelO/dZP+6s2mjYdyzfPJvq
         wxxfc3oERDibzlYCgIyExyr1Do7bwJsm8YAsG90dD4Wxg0Re+D4jpGjKVcvQMMrjzbvE
         7BgMznpooysUAtAN1nKn5NDeKjFYeyYKmrGsrWJNR1ay53L6N8rXhiLTjdZ5K7jQFZvC
         wLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vayFNaDVZE3ZpmipANEaG4wpIWUVVgu6ZcSxACk3VoM=;
        b=7bTwsU9ufyM68xlElppPW0IimLBsyVUbp62R9V6Su+4RH6bnnS5mC4q24XFwea8W54
         R+qZm2uNiHMNSBHdM2mcSlmU1pwhP1X0d50ZRFGgxuzbxg1Tl1SwCP4WhHeTUgxUGVSf
         AzhGeo1efBK9Q5KGiXidzS8DWVNlCQlZaP0kzVN0j6O3FbuQH89Du7rh8NXChgMBxYsc
         dBER2kfV0UKFxf6rLoRNvC2GER5l3+X1/jNQ/CmjMazF0JE7RnTESZh5pzNtpl1XCcZF
         Mtbbhkok8qUH/vefJi7jAaOI5iC702uWv21Xvtoef42gle6jA6I8YEZmzU7H3fcyW4EL
         uHXg==
X-Gm-Message-State: AOAM533bKaUYDzzxd63h0Ymidhhu30vBE2fIKZxfTF/OXZmo0LKg+gpd
        A/zreO5nMVzYqSEE1ERsz0o=
X-Google-Smtp-Source: ABdhPJwllg1gfnFgER/MJxRVVKDvt4R7xZJCOO23stSFAWc7Wh/VnMchJoFQNe/ldAWB3BAwlMXUOw==
X-Received: by 2002:a63:2444:: with SMTP id k65mr24835324pgk.606.1638258165460;
        Mon, 29 Nov 2021 23:42:45 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h13sm19066010pfv.84.2021.11.29.23.42.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 23:42:45 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 5/6] KVM: x86: Update vPMCs when retiring instructions
Date:   Tue, 30 Nov 2021 15:42:20 +0800
Message-Id: <20211130074221.93635-6-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130074221.93635-1-likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When KVM retires a guest instruction through emulation, increment any
vPMCs that are configured to monitor "instructions retired," and
update the sample period of those counters so that they will overflow
at the right time.

Signed-off-by: Eric Hankland <ehankland@google.com>
[jmattson:
  - Split the code to increment "branch instructions retired" into a
    separate commit.
  - Added 'static' to kvm_pmu_incr_counter() definition.
  - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
    PERF_EVENT_STATE_ACTIVE.
]
Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Signed-off-by: Jim Mattson <jmattson@google.com>
[likexu:
  - Drop checks for pmc->perf_event or event state or event type
  - Increase a counter once its umask bits and the first 8 select bits are matched
  - Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
  - Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
  - Add counter enable and CPL check for kvm_pmu_trigger_event();
]
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h |  1 +
 arch/x86/kvm/x86.c |  3 +++
 3 files changed, 64 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a20207ee4014..8abdadb7e22a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -482,6 +482,66 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_reset(vcpu);
 }
 
+static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 prev_count;
+
+	prev_count = pmc->counter;
+	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
+
+	reprogram_counter(pmu, pmc->idx);
+	if (pmc->counter < prev_count)
+		__kvm_perf_overflow(pmc, false);
+}
+
+static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
+	unsigned int perf_hw_id)
+{
+	u64 old_eventsel = pmc->eventsel;
+	unsigned int config;
+
+	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
+	config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
+	pmc->eventsel = old_eventsel;
+	return config == perf_hw_id;
+}
+
+static inline bool cpl_is_matched(struct kvm_pmc *pmc)
+{
+	bool select_os, select_user;
+	u64 config = pmc->current_config;
+
+	if (pmc_is_gp(pmc)) {
+		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
+		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
+	} else {
+		select_os = config & 0x1;
+		select_user = config & 0x2;
+	}
+
+	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
+}
+
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
+
+		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+			continue;
+
+		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
+		if (eventsel_match_perf_hw_id(pmc, perf_hw_id) && cpl_is_matched(pmc))
+			kvm_pmu_incr_counter(pmc);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c91d9725aafd..7a7b8d5b775e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -157,6 +157,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a05a26471f19..83371be00771 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7978,6 +7978,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (unlikely(!r))
 		return 0;
 
+	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
+
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
 	 * not been saved yet.
@@ -8240,6 +8242,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
+			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-- 
2.33.1

