Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BF43DC124
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhG3WhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhG3WhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B799EC06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:15 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f9-20020a1709028609b0290128bcba6be7so8699917plo.18
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dMwap4hObUgoDwGKFMQjZvRZTCSpSBJpDZ6SHzoUej4=;
        b=px4bUOZfcOhRJsEm/Sr8g4k95JNeIzM6JiOzIBpBY6IM6kuDZGh92zuj7W+WNPQuyL
         7VNqO3x8d2aBGs+rWxrd4v8KgYIEM9pxJeEM//MAaQgrV3jGrwYhYKeevY5tiIavyOYu
         cS3RgbFZG/ZMyct9IdRjJEVUE1U7rlFxzy3TFqAmuUZP5aXmxh0S0nycIamkztVy+dz/
         6XSBD2Z7hpr5rb/mvZEY12vh9SJApojYBRNEM6F6Tp1JId/lWyOHPzy1XXQneGqcP3SB
         nvVxFBkRp2IFOZ9v+078asAjbU3oMK7qtoN3lOpYXy2aUVQHStTZyABRll1ywSySLPUG
         pdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dMwap4hObUgoDwGKFMQjZvRZTCSpSBJpDZ6SHzoUej4=;
        b=LiiwUKeeZRC+nDt/hTc64pWD+NPR17INW6FwfkEui9jgR8WNdBNzbyMhc6v1332G1P
         vDKm89A5BRrBsKEMqWBZfr37Qw27aMaBhvVb+n+iDCtd5Ns6P7qIGf5GFd8p7tN4ZjxJ
         wkjjJEfQAsg+qIPe7HMeUofa7Lmvg5ljOdmrjZ0AQBoowOAbdYNs1B9pLx421D+I0Nk+
         TQqDbZLh/k1J/XyiEwBmpcxdJKaoyLFc2Zvx/WlxRUQjxwbxZs3Gd7Cgeoc98xVyTLUN
         K9i06Ui+vqCnnJh+O1ZP9JNgboWyw7GBEWYzQASdnDtQyFhtmy5oHa3v0IEfH2mOwaFZ
         m5JA==
X-Gm-Message-State: AOAM5305Q/cvwtpCxy6L57XfF4cxGbr4OHbyJQTLCFNnzkCzKCLdHSrh
        RfXZWOgYCSga5fKYCKBjXsb1gtEU6YQ+DUaFjcAco04VVbUIeA3CW9pezJYt2yXo6djYR3/TK7J
        GWvlF6i+fkQb93O6W4lw3AzLaTC4oKRLKe0tj117+WEJJusUaRNPaIegcW/S44gE=
X-Google-Smtp-Source: ABdhPJxBfbsygN5WdnwHHjaO9B0TAkPrvBKH8QFlHhGFSBhwXNnLD7yI53Ixn1v9pk+s3wtGmjh2mhXJRQXdhA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1394:b029:3ac:c1a3:f988 with
 SMTP id t20-20020a056a001394b02903acc1a3f988mr5137051pfg.37.1627684635120;
 Fri, 30 Jul 2021 15:37:15 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:02 +0000
In-Reply-To: <20210730223707.4083785-1-dmatlack@google.com>
Message-Id: <20210730223707.4083785-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210730223707.4083785-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 1/6] KVM: Cache the least recently used slot index per vCPU
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memslot for a given gfn is looked up multiple times during page
fault handling. Avoid binary searching for it multiple times by caching
the least recently used slot. There is an existing VM-wide LRU slot but
that does not work well for cases where vCPUs are accessing memory in
different slots (see performance data below).

Another benefit of caching the least recently use slot (versus looking
up the slot once and passing around a pointer) is speeding up memslot
lookups *across* faults and during spte prefetching.

To measure the performance of this change I ran dirty_log_perf_test with
64 vCPUs and 64 memslots and measured "Populate memory time" and
"Iteration 2 dirty memory time".  Tests were ran with eptad=N to force
dirty logging to use fast_page_fault so its performance could be
measured.

Config     | Metric                        | Before | After
---------- | ----------------------------- | ------ | ------
tdp_mmu=Y  | Populate memory time          | 6.76s  | 5.47s
tdp_mmu=Y  | Iteration 2 dirty memory time | 2.83s  | 0.31s
tdp_mmu=N  | Populate memory time          | 20.4s  | 18.7s
tdp_mmu=N  | Iteration 2 dirty memory time | 2.65s  | 0.30s

The "Iteration 2 dirty memory time" results are especially compelling
because they are equivalent to running the same test with a single
memslot. In other words, fast_page_fault performance no longer scales
with the number of memslots.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 61 ++++++++++++++++++++++++++++++----------
 virt/kvm/kvm_main.c      | 21 +++++++++++++-
 2 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d6b4ad407b8..320090d5a124 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -354,6 +354,13 @@ struct kvm_vcpu {
 	struct kvm_vcpu_stat stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
 	struct kvm_dirty_ring dirty_ring;
+
+	/*
+	 * The index of the least recently used memslot by this vCPU. It's ok
+	 * if this becomes stale due to memslot changes since we always check
+	 * it is a valid slot.
+	 */
+	int lru_slot_index;
 };
 
 /* must be called with irqs disabled */
@@ -1189,27 +1196,38 @@ int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
+static inline struct kvm_memory_slot *get_slot(struct kvm_memslots *slots, int slot_index)
+{
+	if (slot_index < 0 || slot_index >= slots->used_slots)
+		return NULL;
+
+	return &slots->memslots[slot_index];
+}
+
+static inline bool slot_contains_gfn(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
+{
+	struct kvm_memory_slot *memslot = get_slot(slots, slot_index);
+
+	if (!memslot)
+		return false;
+
+	return gfn >= memslot->base_gfn && gfn < memslot->base_gfn + memslot->npages;
+}
+
 /*
- * search_memslots() and __gfn_to_memslot() are here because they are
- * used in non-modular code in arch/powerpc/kvm/book3s_hv_rm_mmu.c.
- * gfn_to_memslot() itself isn't here as an inline because that would
- * bloat other code too much.
- *
  * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
-static inline struct kvm_memory_slot *
-search_memslots(struct kvm_memslots *slots, gfn_t gfn)
+static inline int __search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 {
 	int start = 0, end = slots->used_slots;
 	int slot = atomic_read(&slots->lru_slot);
 	struct kvm_memory_slot *memslots = slots->memslots;
 
 	if (unlikely(!slots->used_slots))
-		return NULL;
+		return -1;
 
-	if (gfn >= memslots[slot].base_gfn &&
-	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
-		return &memslots[slot];
+	if (slot_contains_gfn(slots, slot, gfn))
+		return slot;
 
 	while (start < end) {
 		slot = start + (end - start) / 2;
@@ -1220,13 +1238,26 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 			start = slot + 1;
 	}
 
-	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
+	if (slot_contains_gfn(slots, start, gfn)) {
 		atomic_set(&slots->lru_slot, start);
-		return &memslots[start];
+		return start;
 	}
 
-	return NULL;
+	return -1;
+}
+
+/*
+ * search_memslots() and __gfn_to_memslot() are here because they are
+ * used in non-modular code in arch/powerpc/kvm/book3s_hv_rm_mmu.c.
+ * gfn_to_memslot() itself isn't here as an inline because that would
+ * bloat other code too much.
+ */
+static inline struct kvm_memory_slot *
+search_memslots(struct kvm_memslots *slots, gfn_t gfn)
+{
+	int slot_index = __search_memslots(slots, gfn);
+
+	return get_slot(slots, slot_index);
 }
 
 static inline struct kvm_memory_slot *
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a96cbe24c688..9307594bda0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -415,6 +415,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->preempted = false;
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
+	vcpu->lru_slot_index = 0;
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -2024,7 +2025,25 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
+	struct kvm_memslots *slots = kvm_vcpu_memslots(vcpu);
+	int slot_index = vcpu->lru_slot_index;
+	struct kvm_memory_slot *slot;
+
+	if (!slot_contains_gfn(slots, slot_index, gfn))
+		slot_index = __search_memslots(slots, gfn);
+
+	slot = get_slot(slots, slot_index);
+
+	/*
+	 * Purposely avoid updating vcpu->lru_slot_index if the gfn is not
+	 * backed by memslot as that will guarantee a cache miss on the next
+	 * try. By leaving vcpu->lru_slot_index untouched we have a chance of
+	 * a hit on the next lookup.
+	 */
+	if (slot)
+		vcpu->lru_slot_index = slot_index;
+
+	return slot;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
-- 
2.32.0.554.ge1b32706d8-goog

