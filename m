Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6628D5A830C
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiHaQVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiHaQVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9EC9A6B4
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:40 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-340862314d9so191718817b3.3
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=4FRWZocVNAMJ/c7SBG1VG2R4/LyBbouWcPAVuPHwy5I=;
        b=N7BNQn6aL8GdLkuRa79Tu30YUO3/5WVKs+TlBeDY88H18OnLjW0wiGL/hU/ZdkK6M6
         ECBhdkgCLa2EHy6wt2zG7lvdQLt1WVRuPJVXZcOV+hOZEX6lMNGC/9Uemo5hrs97Zi1o
         cJOEApJnBI9Er4JCQVARlIT+1HjL+a6/anrswx7wZx8GACuTT+NuXXSm8k8gcsoOi2BB
         k//MZjqreTcKvDCqr4T5Y9XWao1upF/tozeClA602qJmAe351eQzXI1ILFZki1jBs5pt
         veVwUcXBhKl9VwuLWqn/lnyiRDwoZwFZT1nlwAS6iKJ8RzQ1C4R7fdkMfV9x9/v0FVa0
         JxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=4FRWZocVNAMJ/c7SBG1VG2R4/LyBbouWcPAVuPHwy5I=;
        b=brz0dFXLkt7dQnoLE7xOHzRDS5Yk7F1ChY6IFbh5HsgCW9tPcubkTuEzH4d+vF9VGU
         gYC1dsaiBosl6Pj/I4RO+tj+pEo3sShR44EOtbMHGwT6aY86dVjLfja+pX/UsoyTCH4P
         /I22ZGHONEaWxnLXCf3H+M73xHhYuzrD9mAIn6rZn+Wd0UneqxoYKSzpZIn2+2vxJQxA
         GAWvtGp8HN8hXac5wcNUZQ3gUDCi5fhyf2p7a3CIe2MqC9N7GryVce70HOnRqVWa0zxh
         kULl9Z08E69BuXIKmMde4qOEgw5cHLtn4BXqLF0SfTGYd1GSDmZ463dvkLaJ61Kz3rPt
         aavQ==
X-Gm-Message-State: ACgBeo2wqI1FYznTAy05z0sc5VzqnHQFmygW8qsv96H/mth7qcXnZ3oV
        uYNFMWIpBFPPrizwOK/iHkh0+j06iQ7tIJdlUGU52lG3xHIV/Qwu8bi0aDFy7eGv6oxlLxEU7H3
        LqP33dD745nuDJAEoieFF/xySZGJx9e1e45d47aCgjUS1WBeP0Q8QIaLS9Z9NTVFnY9nd
X-Google-Smtp-Source: AA6agR7+rrDx9hBolceVLQUX4eA8JwPr3/VvmFRBvSabpBbMsSR4FBkRtfU2LR+5vW1CDVRl7cIVydqYZnDHBaPW
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a5b:410:0:b0:68b:7386:d467 with SMTP id
 m16-20020a5b0410000000b0068b7386d467mr15088782ybp.560.1661962900039; Wed, 31
 Aug 2022 09:21:40 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:20 +0000
In-Reply-To: <20220831162124.947028-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-4-aaronlewis@google.com>
Subject: [PATCH v4 3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create an internal representation for filter events to abstract the
events userspace uses from the events the kernel uses.  That will allow
the kernel to use a common event and a common code path between the
different types of filter events used in userspace once masked events
are introduced.

No functional changes intended

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 118 ++++++++++++++++++++++++++++++++-------------
 arch/x86/kvm/pmu.h |  16 ++++++
 2 files changed, 100 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e7d94e6b7f28..50a36cc5bfd0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -239,6 +239,19 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
+static inline u16 get_event_select(u64 eventsel)
+{
+	u64 e = eventsel &
+		static_call(kvm_x86_pmu_get_eventsel_event_mask)();
+
+	return (e & ARCH_PERFMON_EVENTSEL_EVENT) | ((e >> 24) & 0xF00ULL);
+}
+
+static inline u8 get_unit_mask(u64 eventsel)
+{
+	return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
+}
+
 static int cmp_u64(const void *pa, const void *pb)
 {
 	u64 a = *(u64 *)pa;
@@ -247,53 +260,63 @@ static int cmp_u64(const void *pa, const void *pb)
 	return (a > b) - (a < b);
 }
 
-static inline u64 get_event_select(u64 eventsel)
+static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
+{
+	return bsearch(&key, filter->events, filter->nevents,
+			  sizeof(filter->events[0]), cmp_u64);
+}
+
+static bool filter_contains_match(struct kvm_pmu_event_filter *filter,
+				  u64 eventsel)
+{
+	u16 event_select = get_event_select(eventsel);
+	u8 unit_mask = get_unit_mask(eventsel);
+	u64 key;
+
+	key = KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask);
+	if (find_filter_entry(filter, key))
+		return true;
+	return false;
+}
+
+static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
 {
-	return eventsel & static_call(kvm_x86_pmu_get_eventsel_event_mask)();
+	if (filter_contains_match(filter, eventsel))
+		return filter->action == KVM_PMU_EVENT_ALLOW;
+
+	return filter->action == KVM_PMU_EVENT_DENY;
 }
 
-static inline u64 get_raw_event(u64 eventsel)
+static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
 {
-	u64 event_select = get_event_select(eventsel);
-	u64 unit_mask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
+	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
 
-	return event_select | unit_mask;
+	if (filter->action == KVM_PMU_EVENT_DENY &&
+	    test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
+		return false;
+	if (filter->action == KVM_PMU_EVENT_ALLOW &&
+	    !test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
+		return false;
+
+	return true;
 }
 
 static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
-	bool allow_event = true;
-	__u64 key;
-	int idx;
 
 	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
 		return false;
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
-		goto out;
+		return true;
 
-	if (pmc_is_gp(pmc)) {
-		key = get_raw_event(pmc->eventsel);
-		if (bsearch(&key, filter->events, filter->nevents,
-			    sizeof(__u64), cmp_u64))
-			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
-		else
-			allow_event = filter->action == KVM_PMU_EVENT_DENY;
-	} else {
-		idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-		if (filter->action == KVM_PMU_EVENT_DENY &&
-		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			allow_event = false;
-		if (filter->action == KVM_PMU_EVENT_ALLOW &&
-		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			allow_event = false;
-	}
+	if (pmc_is_gp(pmc))
+		return is_gp_event_allowed(filter, pmc->eventsel);
 
-out:
-	return allow_event;
+	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
 void reprogram_counter(struct kvm_pmc *pmc)
@@ -609,6 +632,38 @@ static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)
 	filter->nevents = j;
 }
 
+static inline u64 encode_filter_entry(u64 event)
+{
+	u16 event_select = get_event_select(event);
+	u8 unit_mask = get_unit_mask(event);
+
+	return KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask);
+}
+
+static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
+{
+	int i;
+
+	for (i = 0; i < filter->nevents; i++) {
+		u64 e = filter->events[i];
+
+		filter->events[i] = encode_filter_entry(e);
+	}
+}
+
+static void prepare_filter_events(struct kvm_pmu_event_filter *filter)
+{
+	remove_invalid_raw_events(filter);
+
+	convert_to_filter_events(filter);
+
+	/*
+	 * Sort the in-kernel list so that we can search it with bsearch.
+	 */
+	sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
+	     cmp_u64, NULL);
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
@@ -640,12 +695,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
-	remove_invalid_raw_events(filter);
-
-	/*
-	 * Sort the in-kernel list so that we can search it with bsearch.
-	 */
-	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+	prepare_filter_events(filter);
 
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4e22f9f55400..df4f81e5c685 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -205,4 +205,20 @@ bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
+
+struct kvm_pmu_filter_entry {
+	union {
+		u64 raw;
+		struct {
+			u64 event_select:12;
+			u64 unit_mask:8;
+			u64 rsvd:44;
+		};
+	};
+};
+
+#define KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask) \
+	(((event_select) & 0xFFFULL) | \
+	(((unit_mask) & 0xFFULL) << 12))
+
 #endif /* __KVM_X86_PMU_H */
-- 
2.37.2.672.g94769d06f0-goog

