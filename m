Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4841E5BEC36
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiITRqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiITRq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:46:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCA161DB7
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:16 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id w1-20020a63d741000000b0042c254a4ccdso2027181pgi.15
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=EaA8Fc7N5dB/C4oEm/Nmn+GWZpgy4SP7/lSYzAJxUBo=;
        b=Hlq60qOb3jqa/GM7T5dzpxsdzDT8Ik+gNna9mkX2J+OoIkF79pJ113e++2kLu0NOIP
         Amgkkg7UMMyxYuSdbjo34wvxSRAb+yHhoqrXxrDP4EzofwHUulx3oOEy+IosGtcEU5R4
         zamWh5qw3RsVI8GHr0/VKqg1CbcbFbaxdxqOddCWiJGC/lF5F6/xYqD2nFP+pXTt9IXi
         XDupNQvwNes666btgSKbTT7GYdbX4t1XJ4xwvWjQ3x4tmzQMm0K7uNsfaz5SjlqckUrY
         xzd9LlsQmm0AgixLARCFlJHdZzu9Y0jf3WG6Sg7psgS2oUi1a1pIq/4qyBdBE6nTflX8
         9NCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=EaA8Fc7N5dB/C4oEm/Nmn+GWZpgy4SP7/lSYzAJxUBo=;
        b=LBXc5aSoxzHnW0WR723kXpdNNzYutFzzkvtmpIhINEjsJEBQrm9/zs+89vSVtHYHyJ
         Ci6Q3O8513PLlZjrWNX6pmRvHaINEpEXiURhU/otcN0ryppKeqmwQWMjEBM5KtMD69/z
         ziH4SHLOn/FX3ow3184O8yTaLVXxdhK+TZzE1MVtfW5aLNrICiJ2j2+xk6ZovwyHm3IT
         iUaJncWZpuAlxXsrzKeqUchY3e2NAlSZLGviozxJYIXjnIh5BBg9/yRfDZvqw8fJwtbc
         dJ3UGr7dNdEtvbs890fRnDUVzKQvLNdOvNmT9NOnAGqDSd9RkytqGSMLttCdF/Evokks
         3fUw==
X-Gm-Message-State: ACrzQf3QkTUdDHRB+hH5b7uXdLTnS7O8sNuJfClbF8XSMEyO2i3s4v2g
        7r6cujLsFq/5yioFUz+TU2AB7LPX2BimWzsgtlyaN8M5xMoti6d4fl5VaOpRvLzacsLbzEFpvPa
        mcpwPHpOIXjyJ1HCkiAZ4S1+VrzeQVJprSh3VaSUjEh1mUCNGQ4GijcudFKHSrMyCjG0w
X-Google-Smtp-Source: AMsMyM52E493mBM6RLfSaQmPLv5gdPFR35Dgg9WWu57cO0Cnp/7xoKDjjYeeq0lWRKurpmF3zV9RXI+wDV1Xdm3s
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:1249:b0:178:639a:1ab1 with SMTP
 id u9-20020a170903124900b00178639a1ab1mr786014plh.64.1663695975772; Tue, 20
 Sep 2022 10:46:15 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:45:59 +0000
In-Reply-To: <20220920174603.302510-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920174603.302510-4-aaronlewis@google.com>
Subject: [PATCH v5 3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Create an internal representation for filter events to abstract the
events userspace uses from the events the kernel uses.  That will allow
the kernel to use a common event and a common code path between the
different types of filter events used in userspace once masked events
are introduced.

No functional changes intended

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/pmu.c | 116 ++++++++++++++++++++++++++++++++-------------
 arch/x86/kvm/pmu.h |  16 +++++++
 2 files changed, 98 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e7d94e6b7f28..7ce8bfafea91 100644
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
@@ -247,53 +260,61 @@ static int cmp_u64(const void *pa, const void *pb)
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
 {
-	return eventsel & static_call(kvm_x86_pmu_get_eventsel_event_mask)();
+	u16 event_select = get_event_select(eventsel);
+	u8 unit_mask = get_unit_mask(eventsel);
+	u64 key;
+
+	key = KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask);
+	return find_filter_entry(filter, key);
 }
 
-static inline u64 get_raw_event(u64 eventsel)
+static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
 {
-	u64 event_select = get_event_select(eventsel);
-	u64 unit_mask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
+	if (filter_contains_match(filter, eventsel))
+		return filter->action == KVM_PMU_EVENT_ALLOW;
 
-	return event_select | unit_mask;
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
+static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
+{
+	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
+
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
@@ -609,6 +630,38 @@ static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)
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
@@ -640,12 +693,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
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
2.37.3.968.ga6b4b080e4-goog

