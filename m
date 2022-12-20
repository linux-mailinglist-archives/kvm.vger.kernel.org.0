Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F79652474
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiLTQM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiLTQMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:53 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2728A1AA36
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id h88-20020a17090a29e100b00223f501b046so518859pjd.0
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UPy48fTthDWtLINXvVV7/FEo7aRlhJObuyM17jnPAiA=;
        b=YQgVws86knk5mgkeJF6prSwdZpTuxT+SYvcJKU9S8qzEWfZyDR8484SMouyZ6CAZNZ
         Is7IQm17jzEYD0im+BxZaaud/b2dV8pigMmLODp7QaEFV8ue92bsIryUVQg8i7Te1Fy3
         vibwWHq3MZw06VarRoZqmyXkPxcHMLUPhn6946PF9AlJ/KwecYy3tqfOpe3S8pkhygeY
         yyHC0+IamXx4T606Ub+0GjuOj+jCwNJfSwANMu/IFjFSbLD9JzpJvv8C0AKMSm9nY3eZ
         8+YR+hU2AyozqPKN/PkRo0eCW9056WPz9XZVoB1mOa8PAj3oHxEQ0jDRHC872eUQ4qSF
         AMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPy48fTthDWtLINXvVV7/FEo7aRlhJObuyM17jnPAiA=;
        b=uTEkdA6QHcRvngfJFwAhEJ+fwi8mK9+SzF61v3C7QEDsECmstcwot7bciDzpthVp4i
         fZhAeKrAHOCcd30DtSl6lvbPCeWsvfE5TqETivSWieimQtPIWKX06j8VfS0RGiH8vteH
         OVGctPqbas2KeZdi7zT745GJhZs8pr0zncAcv73s2ZtANGRYO6iioC/sX7hFcC9s7QQ7
         uf1KG+LEfuQZq1RsGtYlWTpW2T/m8MOkLl3DBkuFt0hPAFVsKkDzZxHgrJx2OIkyuTsc
         Pymu3UH/KKqFbfP1RpXAwk7d7w4x+x/frbv0LmqIAbn9DB0xAHvy2f0lB4wSkGM5wgTV
         kCtA==
X-Gm-Message-State: AFqh2krjwFftACDjKACqWq/XLt0/BgW5596I9fy7N24R8gOSEoakNcrG
        UB2b2dqrUcTF2c9ugwlev7mADqoZmuc0U+7nEt0ZesLWwgMAPSI4gs/MDd+wB4LhqPOhfC+9dxB
        ZNZnsb/1UBdSB2aI2PgQZ3pWKi08YmLZFZv6YWWOhG/hh8YLq8BRamIcAAK+bBdI+oAQr
X-Google-Smtp-Source: AMrXdXvAx9sX8x6SYspaGFkAXDIx7nf9vzlWDuKObUvRCzhG0gU6E7XinS3szzVI5GLiaMGjIRbLxZTaxuXFhcmC
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:110c:b0:191:221a:7891 with SMTP
 id n12-20020a170903110c00b00191221a7891mr386667plh.164.1671552771579; Tue, 20
 Dec 2022 08:12:51 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:33 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-5-aaronlewis@google.com>
Subject: [PATCH v8 4/7] kvm: x86/pmu: Introduce masked events to the pmu event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

When building a list of filter events, it can sometimes be a challenge
to fit all the events needed to adequately restrict the guest into the
limited space available in the pmu event filter.  This stems from the
fact that the pmu event filter requires each event (i.e. event select +
unit mask) be listed, when the intention might be to restrict the
event select all together, regardless of it's unit mask.  Instead of
increasing the number of filter events in the pmu event filter, add a
new encoding that is able to do a more generalized match on the unit mask.

Introduce masked events as another encoding the pmu event filter
understands.  Masked events has the fields: mask, match, and exclude.
When filtering based on these events, the mask is applied to the guest's
unit mask to see if it matches the match value (i.e. umask & mask ==
match).  The exclude bit can then be used to exclude events from that
match.  E.g. for a given event select, if it's easier to say which unit
mask values shouldn't be filtered, a masked event can be set up to match
all possible unit mask values, then another masked event can be set up to
match the unit mask values that shouldn't be filtered.

Userspace can query to see if this feature exists by looking for the
capability, KVM_CAP_PMU_EVENT_MASKED_EVENTS.

This feature is enabled by setting the flags field in the pmu event
filter to KVM_PMU_EVENT_FLAG_MASKED_EVENTS.

Events can be encoded by using KVM_PMU_ENCODE_MASKED_ENTRY().

It is an error to have a bit set outside the valid bits for a masked
event, and calls to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in
such cases, including the high bits of the event select (35:32) if
called on Intel.

With these updates the filter matching code has been updated to match on
a common event.  Masked events were flexible enough to handle both event
types, so they were used as the common event.  This changes how guest
events get filtered because regardless of the type of event used in the
uAPI, they will be converted to masked events.  Because of this there
could be a slight performance hit because instead of matching the filter
event with a lookup on event select + unit mask, it does a lookup on event
select then walks the unit masks to find the match.  This shouldn't be a
big problem because I would expect the set of common event selects to be
small, and if they aren't the set can likely be reduced by using masked
events to generalize the unit mask.  Using one type of event when
filtering guest events allows for a common code path to be used.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst  |  77 +++++++++++--
 arch/x86/include/asm/kvm_host.h |  14 ++-
 arch/x86/include/uapi/asm/kvm.h |  29 +++++
 arch/x86/kvm/pmu.c              | 197 +++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c              |   1 +
 include/uapi/linux/kvm.h        |   1 +
 6 files changed, 281 insertions(+), 38 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 778c6460d1de..9f6256b56e0e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4997,6 +4997,15 @@ using this ioctl.
 :Parameters: struct kvm_pmu_event_filter (in)
 :Returns: 0 on success, -1 on error
 
+Errors:
+
+  ======     ============================================================
+  EFAULT     args[0] cannot be accessed
+  EINVAL     args[0] contains invalid data in the filter or filter events
+  E2BIG      nevents is too large
+  EBUSY      not enough memory to allocate the filter
+  ======     ============================================================
+
 ::
 
   struct kvm_pmu_event_filter {
@@ -5008,14 +5017,68 @@ using this ioctl.
 	__u64 events[0];
   };
 
-This ioctl restricts the set of PMU events that the guest can program.
-The argument holds a list of events which will be allowed or denied.
-The eventsel+umask of each event the guest attempts to program is compared
-against the events field to determine whether the guest should have access.
-The events field only controls general purpose counters; fixed purpose
-counters are controlled by the fixed_counter_bitmap.
+This ioctl restricts the set of PMU events the guest can program by limiting
+which event select and unit mask combinations are permitted.
+
+The argument holds a list of filter events which will be allowed or denied.
+
+Filter events only control general purpose counters; fixed purpose counters
+are controlled by the fixed_counter_bitmap.
+
+Valid values for 'flags'::
+
+``0``
+
+To use this mode, clear the 'flags' field.
+
+In this mode each event will contain an event select + unit mask.
+
+When the guest attempts to program the PMU the guest's event select +
+unit mask is compared against the filter events to determine whether the
+guest should have access.
+
+``KVM_PMU_EVENT_FLAG_MASKED_EVENTS``
+:Capability: KVM_CAP_PMU_EVENT_MASKED_EVENTS
+
+In this mode each filter event will contain an event select, mask, match, and
+exclude value.  To encode a masked event use::
+
+  KVM_PMU_ENCODE_MASKED_ENTRY()
+
+An encoded event will follow this layout::
+
+  Bits   Description
+  ----   -----------
+  7:0    event select (low bits)
+  15:8   umask match
+  31:16  unused
+  35:32  event select (high bits)
+  36:54  unused
+  55     exclude bit
+  63:56  umask mask
+
+When the guest attempts to program the PMU, these steps are followed in
+determining if the guest should have access:
+ 1. Match the event select from the guest against the filter events.
+ 2. If a match is found, match the guest's unit mask to the mask and match
+    values of the included filter events.
+    I.e. (unit mask & mask) == match && !exclude.
+ 3. If a match is found, match the guest's unit mask to the mask and match
+    values of the excluded filter events.
+    I.e. (unit mask & mask) == match && exclude.
+ 4.
+   a. If an included match is found and an excluded match is not found, filter
+      the event.
+   b. For everything else, do not filter the event.
+ 5.
+   a. If the event is filtered and it's an allow list, allow the guest to
+      program the event.
+   b. If the event is filtered and it's a deny list, do not allow the guest to
+      program the event.
 
-No flags are defined yet, the field must be zero.
+When setting a new pmu event filter, -EINVAL will be returned if any of the
+unused fields are set or if any of the high bits (35:32) in the event
+select are set when called on Intel.
 
 Valid values for 'action'::
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa4eb8cfcd7e..112b70a7e403 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1132,6 +1132,18 @@ struct kvm_x86_msr_filter {
 	struct msr_bitmap_range ranges[16];
 };
 
+struct kvm_x86_pmu_event_filter {
+	__u32 action;
+	__u32 nevents;
+	__u32 fixed_counter_bitmap;
+	__u32 flags;
+	__u32 nr_includes;
+	__u32 nr_excludes;
+	__u64 *includes;
+	__u64 *excludes;
+	__u64 events[];
+};
+
 enum kvm_apicv_inhibit {
 
 	/********************************************************************/
@@ -1337,7 +1349,7 @@ struct kvm_arch {
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
 
-	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
+	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct task_struct *nx_huge_page_recovery_thread;
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e48deab8901d..f142f3ebf4e4 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -525,6 +525,35 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+
+/*
+ * Masked event layout.
+ * Bits   Description
+ * ----   -----------
+ * 7:0    event select (low bits)
+ * 15:8   umask match
+ * 31:16  unused
+ * 35:32  event select (high bits)
+ * 36:54  unused
+ * 55     exclude bit
+ * 63:56  umask mask
+ */
+
+#define KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, exclude) \
+	(((event_select) & 0xFFULL) | (((event_select) & 0XF00ULL) << 24) | \
+	(((mask) & 0xFFULL) << 56) | \
+	(((match) & 0xFFULL) << 8) | \
+	((__u64)(!!(exclude)) << 55))
+
+#define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
+	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b09a43b66dbe..6558bd36a200 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -253,30 +253,99 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
-static int cmp_u64(const void *pa, const void *pb)
+static int filter_cmp(const void *pa, const void *pb, u64 mask)
 {
-	u64 a = *(u64 *)pa;
-	u64 b = *(u64 *)pb;
+	u64 a = *(u64 *)pa & mask;
+	u64 b = *(u64 *)pb & mask;
 
 	return (a > b) - (a < b);
 }
 
-static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
+
+static int filter_sort_cmp(const void *pa, const void *pb)
+{
+	return filter_cmp(pa, pb, (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
+				   KVM_PMU_MASKED_ENTRY_EXCLUDE));
+}
+
+/*
+ * For the event filter, searching is done on the 'includes' list and
+ * 'excludes' list separately rather than on the 'events' list (which
+ * has both).  As a result the exclude bit can be ignored.
+ */
+static int filter_event_cmp(const void *pa, const void *pb)
+{
+	return filter_cmp(pa, pb, (KVM_PMU_MASKED_ENTRY_EVENT_SELECT));
+}
+
+static int find_filter_index(u64 *events, u64 nevents, u64 key)
+{
+	u64 *fe = bsearch(&key, events, nevents, sizeof(events[0]),
+			  filter_event_cmp);
+
+	if (!fe)
+		return -1;
+
+	return fe - events;
+}
+
+static bool is_filter_entry_match(u64 filter_event, u64 umask)
+{
+	u64 mask = filter_event >> (KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT - 8);
+	u64 match = filter_event & KVM_PMU_MASKED_ENTRY_UMASK_MATCH;
+
+	BUILD_BUG_ON((KVM_PMU_ENCODE_MASKED_ENTRY(0, 0xff, 0, false) >>
+		     (KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT - 8)) !=
+		     ARCH_PERFMON_EVENTSEL_UMASK);
+
+	return (umask & mask) == match;
+}
+
+static bool filter_contains_match(u64 *events, u64 nevents, u64 eventsel)
 {
-	return bsearch(&key, filter->events, filter->nevents,
-		       sizeof(filter->events[0]), cmp_u64);
+	u64 event_select = eventsel & kvm_pmu_ops.EVENTSEL_EVENT;
+	u64 umask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
+	int i, index;
+
+	index = find_filter_index(events, nevents, event_select);
+	if (index < 0)
+		return false;
+
+	/*
+	 * Entries are sorted by the event select.  Walk the list in both
+	 * directions to process all entries with the targeted event select.
+	 */
+	for (i = index; i < nevents; i++) {
+		if (filter_event_cmp(&events[i], &event_select))
+			break;
+
+		if (is_filter_entry_match(events[i], umask))
+			return true;
+	}
+
+	for (i = index - 1; i >= 0; i--) {
+		if (filter_event_cmp(&events[i], &event_select))
+			break;
+
+		if (is_filter_entry_match(events[i], umask))
+			return true;
+	}
+
+	return false;
 }
 
-static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
+static bool is_gp_event_allowed(struct kvm_x86_pmu_event_filter *f,
+				u64 eventsel)
 {
-	if (find_filter_entry(filter, eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
-						  ARCH_PERFMON_EVENTSEL_UMASK)))
-		return filter->action == KVM_PMU_EVENT_ALLOW;
+	if (filter_contains_match(f->includes, f->nr_includes, eventsel) &&
+	    !filter_contains_match(f->excludes, f->nr_excludes, eventsel))
+		return f->action == KVM_PMU_EVENT_ALLOW;
 
-	return filter->action == KVM_PMU_EVENT_DENY;
+	return f->action == KVM_PMU_EVENT_DENY;
 }
 
-static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
+static bool is_fixed_event_allowed(struct kvm_x86_pmu_event_filter *filter,
+				   int idx)
 {
 	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
 
@@ -292,7 +361,7 @@ static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
 
 static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmu_event_filter *filter;
+	struct kvm_x86_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
 
 	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
@@ -602,60 +671,128 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
-static void remove_impossible_events(struct kvm_pmu_event_filter *filter)
+static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
+{
+	u64 mask = kvm_pmu_ops.EVENTSEL_EVENT |
+		   KVM_PMU_MASKED_ENTRY_UMASK_MASK |
+		   KVM_PMU_MASKED_ENTRY_UMASK_MATCH |
+		   KVM_PMU_MASKED_ENTRY_EXCLUDE;
+	int i;
+
+	for (i = 0; i < filter->nevents; i++) {
+		if (filter->events[i] & ~mask)
+			return false;
+	}
+
+	return true;
+}
+
+static void convert_to_masked_filter(struct kvm_x86_pmu_event_filter *filter)
 {
 	int i, j;
 
 	for (i = 0, j = 0; i < filter->nevents; i++) {
+		/*
+		 * Skip events that are impossible to match against a guest
+		 * event.  When filtering, only the event select + unit mask
+		 * of the guest event is used.  To maintain backwards
+		 * compatibility, impossible filters can't be rejected :-(
+		 */
 		if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
 					  ARCH_PERFMON_EVENTSEL_UMASK))
 			continue;
-
-		filter->events[j++] = filter->events[i];
+		/*
+		 * Convert userspace events to a common in-kernel event so
+		 * only one code path is needed to support both events.  For
+		 * the in-kernel events use masked events because they are
+		 * flexible enough to handle both cases.  To convert to masked
+		 * events all that's needed is to add an "all ones" umask_mask,
+		 * (unmasked filter events don't support EXCLUDE).
+		 */
+		filter->events[j++] = filter->events[i] |
+				      (0xFFULL << KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT);
 	}
 
 	filter->nevents = j;
 }
 
+static int prepare_filter_lists(struct kvm_x86_pmu_event_filter *filter)
+{
+	int i;
+
+	if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
+		convert_to_masked_filter(filter);
+	else if (!is_masked_filter_valid(filter))
+		return -EINVAL;
+
+	/*
+	 * Sort entries by event select and includes vs. excludes so that all
+	 * entries for a given event select can be processed efficiently during
+	 * filtering.  The EXCLUDE flag uses a more significant bit than the
+	 * event select, and so the sorted list is also effectively split into
+	 * includes and excludes sub-lists.
+	 */
+	sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
+	     filter_sort_cmp, NULL);
+
+	i = filter->nevents;
+	/* Find the first EXCLUDE event (only supported for masked events). */
+	if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
+		for (i = 0; i < filter->nevents; i++) {
+			if (filter->events[i] & KVM_PMU_MASKED_ENTRY_EXCLUDE)
+				break;
+		}
+	}
+
+	filter->nr_includes = i;
+	filter->nr_excludes = filter->nevents - filter->nr_includes;
+	filter->includes = filter->events;
+	filter->excludes = filter->events + filter->nr_includes;
+
+	return 0;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
-	struct kvm_pmu_event_filter tmp, *filter;
+	struct kvm_pmu_event_filter __user *user_filter = argp;
+	struct kvm_x86_pmu_event_filter *filter;
+	struct kvm_pmu_event_filter tmp;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 	size_t size;
 	int r;
 
-	if (copy_from_user(&tmp, argp, sizeof(tmp)))
+	if (copy_from_user(&tmp, user_filter, sizeof(tmp)))
 		return -EFAULT;
 
 	if (tmp.action != KVM_PMU_EVENT_ALLOW &&
 	    tmp.action != KVM_PMU_EVENT_DENY)
 		return -EINVAL;
 
-	if (tmp.flags != 0)
+	if (tmp.flags & ~KVM_PMU_EVENT_FLAGS_VALID_MASK)
 		return -EINVAL;
 
 	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
 		return -E2BIG;
 
 	size = struct_size(filter, events, tmp.nevents);
-	filter = kmalloc(size, GFP_KERNEL_ACCOUNT);
+	filter = kzalloc(size, GFP_KERNEL_ACCOUNT);
 	if (!filter)
 		return -ENOMEM;
 
+	filter->action = tmp.action;
+	filter->nevents = tmp.nevents;
+	filter->fixed_counter_bitmap = tmp.fixed_counter_bitmap;
+	filter->flags = tmp.flags;
+
 	r = -EFAULT;
-	if (copy_from_user(filter, argp, size))
+	if (copy_from_user(filter->events, user_filter->events,
+			   sizeof(filter->events[0]) * filter->nevents))
 		goto cleanup;
 
-	/* Restore the verified state to guard against TOCTOU attacks. */
-	*filter = tmp;
-
-	remove_impossible_events(filter);
-
-	/*
-	 * Sort the in-kernel list so that we can search it with bsearch.
-	 */
-	sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+	r = prepare_filter_lists(filter);
+	if (r)
+		goto cleanup;
 
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 312aea1854ae..d2023076f363 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4401,6 +4401,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
  	case KVM_CAP_SPLIT_IRQCHIP:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_PMU_EVENT_FILTER:
+	case KVM_CAP_PMU_EVENT_MASKED_EVENTS:
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 20522d4ba1e0..0b16b9ed3b23 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.39.0.314.g84b9a713c41-goog

