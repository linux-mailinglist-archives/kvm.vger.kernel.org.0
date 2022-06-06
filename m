Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB753ED42
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiFFRxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiFFRxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:53:43 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9B51455A1
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 10:53:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l7-20020a170903244700b001675991fb6aso3813780pls.6
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 10:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GRjeGm7wq7WaOEXMIg+oSOlcTXMumAeTDB0o6bhsqtk=;
        b=dG6EsfR6uYPndy3bzV/8sMdHRau52kbF2cuA9ftnASA+uV3OQ0SW7MIZLg8FSd8B9o
         Fz/lm0J31Nv1rkgBa0DHIk6FEmQPKPIk4V0YGrNrFSdAk5NCvik3rNoBf8Be9IWpgRjg
         84jvWbnx49xT+iRNOU669lEPRxKfCWPsXBU3Ewos7joDXGUcuT07VpewRFORPmUnmfru
         ZwPXSDpWbXgUbDeO0F0qzcPdGHLDnFZdfE9wS/jKVFdIi3VAExKolnNj9Zo4gq6FvqTm
         i3c1qYDKIx2ncbhaXeKrcj1tkf7wKyJzYqtcYyPvkoC5R2tJUcdsXIY82DgIC7HE5q4e
         XTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GRjeGm7wq7WaOEXMIg+oSOlcTXMumAeTDB0o6bhsqtk=;
        b=0iXl0goVluvwXkRZ8sc60INj2GJ+aoGRCXpvGDAvBZjigErVZNbHIx83O4/Ycz8m4W
         WyqZ8l1u2Wy9WAoG0fdEV+4iHVgZUxltDOQ8mz56+9ASyNBifbn16zoRGgZQxLLyg9Ln
         tp7duTPOD/IqBWu1XzbP8yhbyCZGZAauD6Vqlq/KEm2DcHw1eLDlZ2wIJm9CDxxA6ZM3
         JkVBcgrr21TgEAygjo5lh4l9bCSffbPUqbU82VHjTVZT4rGqc5InuZxY3mDfAs4jAQwn
         qMnN3D+ozjGJmYFs4UWLPFt2yt96DOuXJxVdsd4aqEynqIo7QGUzlCZPa6klLZaUvjET
         sr8g==
X-Gm-Message-State: AOAM532KYhzsF8Sak7x0HCRUmjurztF2HZJdQlrHDh1xF0bk/ur1CSoh
        HrEJDtv+yIjsAFzc9WVw/NJhvzWCa1SX6yPRYss3ToTyylbe1u5PQUOWg/L/FIluhL4ObEPMRRx
        b3lU92paAByapLiN3D+j0nr5SFfRNSXayZqKzcdc84B3K67xrVjaSSsBR8s5ZFP8mblNT
X-Google-Smtp-Source: ABdhPJwoKTgnAV7hVBmPiKhQYwFzzZpa+b9V4qlZP6/8tuHnbcdUtMOXJ8mp+3s1wMPZZvAyCRinxrOYUawfD3pQ
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1907:b0:4f7:945:14cf with SMTP
 id y7-20020a056a00190700b004f7094514cfmr25556306pfi.47.1654538020978; Mon, 06
 Jun 2022 10:53:40 -0700 (PDT)
Date:   Mon,  6 Jun 2022 17:52:46 +0000
In-Reply-To: <20220606175248.1884041-1-aaronlewis@google.com>
Message-Id: <20220606175248.1884041-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 1/4] kvm: x86/pmu: Introduce masked events to the pmu event filter
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

When building an event list for the pmu event filter, fitting all the
events in the limited space can be a challenge.  It becomes
particularly challenging when trying to include various unit mask
combinations for a particular event the guest is allow to or not allow
to program.  Instead of increasing the size of the list to allow for
these, add a new encoding in the pmu event filter's events field. These
encoded events can then be used to test against the event the guest is
attempting to program to determine if the guest should have access to
it.

The encoded values are: mask, match, and invert.  When filtering events
the mask is applied to the guest's unit mask to see if it matches the
match value (ie: unit_mask & mask == match).  If it does and the pmu
event filter is an allow list the event is allowed, and denied if it's
a deny list.  Additionally, the result is reversed if the invert flag
is set in the encoded event.

This feature is enabled by setting the flags field to
KVM_PMU_EVENT_FLAG_MASKED_EVENTS.

Events can be encoded by using KVM_PMU_EVENT_ENCODE_MASKED_EVENT().

It is an error to have a bit set outside valid encoded bits, and calls
to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in such cases,
including bits that are set in the high nybble[1] for AMD if called on
Intel.

[1] bits 35:32 in the event and bits 11:8 in the eventsel.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst         |  46 +++++++--
 arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 +
 arch/x86/include/uapi/asm/kvm.h        |   8 ++
 arch/x86/kvm/pmu.c                     | 128 ++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     |   1 +
 arch/x86/kvm/svm/pmu.c                 |  12 +++
 arch/x86/kvm/vmx/pmu_intel.c           |  12 +++
 7 files changed, 190 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..4e904772da5b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5017,7 +5017,13 @@ using this ioctl.
 :Architectures: x86
 :Type: vm ioctl
 :Parameters: struct kvm_pmu_event_filter (in)
-:Returns: 0 on success, -1 on error
+:Returns: 0 on success,
+    -EFAULT args[0] cannot be accessed.
+    -EINVAL args[0] contains invalid data in the filter or events field.
+                    Note: event validation is only done for modes where
+                    the flags field is non-zero.
+    -E2BIG nevents is too large.
+    -ENOMEM not enough memory to allocate the filter.
 
 ::
 
@@ -5030,14 +5036,42 @@ using this ioctl.
 	__u64 events[0];
   };
 
-This ioctl restricts the set of PMU events that the guest can program.
-The argument holds a list of events which will be allowed or denied.
-The eventsel+umask of each event the guest attempts to program is compared
-against the events field to determine whether the guest should have access.
+This ioctl restricts the set of PMU events the guest can program.  The
+argument holds a list of events which will be allowed or denied.
+
 The events field only controls general purpose counters; fixed purpose
 counters are controlled by the fixed_counter_bitmap.
 
-No flags are defined yet, the field must be zero.
+Valid values for 'flags'::
+
+``0``
+
+This is the default behavior for the pmu event filter, and used when the
+flags field is clear.  In this mode the eventsel+umask for the event the
+guest is attempting to program is compared against each event in the events
+field to determine whether the guest should have access to it.
+
+``KVM_PMU_EVENT_FLAG_MASKED_EVENTS``
+
+In this mode each event in the events field will be encoded with mask, match,
+and invert values in addition to an eventsel.  These encoded events will be
+matched against the event the guest is attempting to program to determine
+whether the guest should have access to it.  When matching an encoded event
+with a guest event these steps are followed:
+ 1. Match the encoded eventsel to the guest eventsel.
+ 2. If that matches, match the mask and match values from the encoded event to
+    the guest's unit mask (ie: unit_mask & mask == match).
+ 3. If that matches, the guest is allow to program the event if its an allow
+    list or the guest is not allow to program the event if its a deny list.
+ 4. If the invert value is set in the encoded event, reverse the meaning of #3
+    (ie: deny if its an allow list, allow if it's a deny list).
+
+To encode an event in the pmu_event_filter use
+KVM_PMU_EVENT_ENCODE_MASKED_EVENT().
+
+If a bit is set in an encoded event that is not apart of the bits used for
+eventsel, mask, match or invert a call to KVM_SET_PMU_EVENT_FILTER will
+return -EINVAL.
 
 Valid values for 'action'::
 
diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index fdfd8e06fee6..016713b583bf 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -24,6 +24,7 @@ KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
 KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP(get_event_mask)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..2964f3f15fb5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -522,6 +522,14 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS (1u << 0)
+
+#define KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert) \
+		(((select) & 0xfful) | (((select) & 0xf00ul) << 24) | \
+		(((mask) & 0xfful) << 24) | \
+		(((match) & 0xfful) << 8) | \
+		(((invert) & 0x1ul) << 23))
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3f868fed9114..69edc71b5ef8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -197,14 +197,99 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
-static int cmp_u64(const void *pa, const void *pb)
+static inline u64 get_event(u64 eventsel)
 {
-	u64 a = *(u64 *)pa;
-	u64 b = *(u64 *)pb;
+	return eventsel & AMD64_EVENTSEL_EVENT;
+}
 
+static inline u8 get_unit_mask(u64 eventsel)
+{
+	return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
+}
+
+static inline u8 get_counter_mask(u64 eventsel)
+{
+	return (eventsel & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
+}
+
+static inline bool get_invert_comparison(u64 eventsel)
+{
+	return !!(eventsel & ARCH_PERFMON_EVENTSEL_INV);
+}
+
+static inline int cmp_safe64(u64 a, u64 b)
+{
 	return (a > b) - (a < b);
 }
 
+static int cmp_eventsel_event(const void *pa, const void *pb)
+{
+	return cmp_safe64(*(u64 *)pa & AMD64_EVENTSEL_EVENT,
+			  *(u64 *)pb & AMD64_EVENTSEL_EVENT);
+}
+
+static int cmp_u64(const void *pa, const void *pb)
+{
+	return cmp_safe64(*(u64 *)pa,
+			  *(u64 *)pb);
+}
+
+static bool is_match(u64 masked_event, u64 eventsel)
+{
+	u8 mask = get_counter_mask(masked_event);
+	u8 match = get_unit_mask(masked_event);
+	u8 unit_mask = get_unit_mask(eventsel);
+
+	return (unit_mask & mask) == match;
+}
+
+static bool is_event_allowed(u64 masked_event, u32 action)
+{
+	if (get_invert_comparison(masked_event))
+		return action != KVM_PMU_EVENT_ALLOW;
+
+	return action == KVM_PMU_EVENT_ALLOW;
+}
+
+static bool filter_masked_event(struct kvm_pmu_event_filter *filter,
+				u64 eventsel)
+{
+	u64 key = get_event(eventsel);
+	u64 *event, *evt;
+
+	event = bsearch(&key, filter->events, filter->nevents, sizeof(u64),
+			cmp_eventsel_event);
+
+	if (event) {
+		/* Walk the masked events backward looking for a match. */
+		for (evt = event; evt >= filter->events &&
+		     get_event(*evt) == get_event(eventsel); evt--)
+			if (is_match(*evt, eventsel))
+				return is_event_allowed(*evt, filter->action);
+
+		/* Walk the masked events forward looking for a match. */
+		for (evt = event + 1;
+		     evt < (filter->events + filter->nevents) &&
+		     get_event(*evt) == get_event(eventsel); evt++)
+			if (is_match(*evt, eventsel))
+				return is_event_allowed(*evt, filter->action);
+	}
+
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
+static bool filter_default_event(struct kvm_pmu_event_filter *filter,
+				 u64 eventsel)
+{
+	u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
+
+	if (bsearch(&key, filter->events, filter->nevents,
+		    sizeof(u64), cmp_u64))
+		return filter->action == KVM_PMU_EVENT_ALLOW;
+
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	u64 config;
@@ -226,14 +311,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (filter) {
-		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
-
-		if (bsearch(&key, filter->events, filter->nevents,
-			    sizeof(__u64), cmp_u64))
-			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
-		else
-			allow_event = filter->action == KVM_PMU_EVENT_DENY;
+		allow_event = (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) ?
+			filter_masked_event(filter, eventsel) :
+			filter_default_event(filter, eventsel);
 	}
+
 	if (!allow_event)
 		return;
 
@@ -572,8 +654,22 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+static int has_invalid_event(struct kvm_pmu_event_filter *filter)
+{
+	u64 event_mask;
+	int i;
+
+	event_mask = static_call(kvm_x86_pmu_get_event_mask)(filter->flags);
+	for (i = 0; i < filter->nevents; i++)
+		if (filter->events[i] & ~event_mask)
+			return true;
+
+	return false;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
+	int (*cmp)(const void *a, const void *b) = cmp_u64;
 	struct kvm_pmu_event_filter tmp, *filter;
 	size_t size;
 	int r;
@@ -585,7 +681,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	    tmp.action != KVM_PMU_EVENT_DENY)
 		return -EINVAL;
 
-	if (tmp.flags != 0)
+	if (tmp.flags & ~KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 		return -EINVAL;
 
 	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
@@ -603,10 +699,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
+	r = -EINVAL;
+	/* To maintain backwards compatibility don't validate flags == 0. */
+	if (filter->flags != 0 && has_invalid_event(filter))
+		goto cleanup;
+
+	if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+		cmp = cmp_eventsel_event;
+
 	/*
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */
-	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+	sort(&filter->events, filter->nevents, sizeof(u64), cmp, NULL);
 
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index e745f443b6a8..f13fcc692d04 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -37,6 +37,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+	u64 (*get_event_mask)(u32 flag);
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 136039fc6d01..41b7bd51fd11 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -342,6 +342,17 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+static u64 amd_pmu_get_event_mask(u32 flag)
+{
+	if (flag == KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+		return AMD64_EVENTSEL_EVENT |
+		       ARCH_PERFMON_EVENTSEL_UMASK |
+		       ARCH_PERFMON_EVENTSEL_INV |
+		       ARCH_PERFMON_EVENTSEL_CMASK;
+	return AMD64_EVENTSEL_EVENT |
+	       ARCH_PERFMON_EVENTSEL_UMASK;
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.pmc_is_enabled = amd_pmc_is_enabled,
@@ -355,4 +366,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.get_event_mask = amd_pmu_get_event_mask,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 37e9eb32e3d9..27c44105760d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -719,6 +719,17 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+static u64 intel_pmu_get_event_mask(u32 flag)
+{
+	if (flag == KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+		return ARCH_PERFMON_EVENTSEL_EVENT |
+		       ARCH_PERFMON_EVENTSEL_UMASK |
+		       ARCH_PERFMON_EVENTSEL_INV |
+		       ARCH_PERFMON_EVENTSEL_CMASK;
+	return ARCH_PERFMON_EVENTSEL_EVENT |
+	       ARCH_PERFMON_EVENTSEL_UMASK;
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.pmc_is_enabled = intel_pmc_is_enabled,
@@ -734,4 +745,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.get_event_mask = intel_pmu_get_event_mask,
 };
-- 
2.36.1.255.ge46751e96f-goog

