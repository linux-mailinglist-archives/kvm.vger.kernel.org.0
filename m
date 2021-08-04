Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671CC3E0A5E
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhHDW3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbhHDW3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:29:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9154FC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 15:29:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q6-20020a17090aa006b02901779796d79eso5723570pjp.1
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 15:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9wiCmoE9RCNpFzjVibQ+jhZe1y0mw87FfiQJ+4m3Tkw=;
        b=M0cSDOPRaTlSHBDnZ+prpDA5SuJB1wnLHaUVYMN9WOtJYmGTmLEAR7cymQuX1odCH2
         41CCLpJIBAL6bczlxmWxqm0XPvUqZbQbMA2CVmp/+Yppll930YQuV+ZoZBzBBMRMGJTl
         EjBbsROiHYowBd8wmSeKxaSMUGLxvaymAHh+dduK/Cs9/49PHbYVZQhTyA5c7BRgM+Uw
         ne6L63irMH9rgTcJWn7ghu/e9WfxI9/yy723er5eXMS7PEyp56GkRpXOJr3LsfWSutXm
         ElDF13t2EKizIzeWbsjd48V+kd1jzQJWdpAQ1NSl14Y9y8txg9U9qqdJ4qIXadkRNDiu
         UkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9wiCmoE9RCNpFzjVibQ+jhZe1y0mw87FfiQJ+4m3Tkw=;
        b=VM9f30JDl4lAN7e3FqfwfLyEe3exLQ2VtqyQxrRL9dzCFNZ3rgneohQa1bFRkh9RJb
         Hr7arUxjEUMlWqePBl6j2jhCkyD/R6XH1y0KW4b82kziEcYjPh5DGoZbNgn4xszOOfVB
         PlJlv8N20a/0i2IgBvHB1H5sgaPr2PiYKr2kx4jh0NYJYucOdJZ5q1rnvBgc5zE/6SJZ
         UN7eSXysu4nlWpr8SnFN2tNDXFF4h1aYoq8U/lzXITun4eAiBugSiy5SKB1qNP/i2vtE
         P7ahdRVypd03JLsbnDYk9sBwATFXVjlqgA11wmOuMSQwuaPuyNJ0XolX0wG41cVDOePW
         YHGA==
X-Gm-Message-State: AOAM530pToG12+xHJZ72iGJmMeslseTxlL/M+mIxA7nJt29BPyHRYwgm
        Kl1IxWsW/xne/sEc3ESNAjzU1NmPEaeGWw==
X-Google-Smtp-Source: ABdhPJyjJCZTrQ+lFVwH/WVeYCivhHyRRDakaivxPuSK/KDbXrZY8UvJM0zcZP7nDtssWPm3nsyEJJVt3ijECA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:e40d:0:b029:3ab:42cd:d156 with SMTP
 id r13-20020a62e40d0000b02903ab42cdd156mr1498338pfh.81.1628116144093; Wed, 04
 Aug 2021 15:29:04 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:40 +0000
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Message-Id: <20210804222844.1419481-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210804222844.1419481-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 3/7] KVM: Cache the last used slot index per vCPU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memslot for a given gfn is looked up multiple times during page
fault handling. Avoid binary searching for it multiple times by caching
the most recently used slot. There is an existing VM-wide last_used_slot
but that does not work well for cases where vCPUs are accessing memory
in different slots (see performance data below).

Another benefit of caching the most recently use slot (versus looking
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
 include/linux/kvm_host.h | 13 +++++++++++++
 virt/kvm/kvm_main.c      | 22 +++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f28731346f8..5eb2da09cf7f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -354,6 +354,13 @@ struct kvm_vcpu {
 	struct kvm_vcpu_stat stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
 	struct kvm_dirty_ring dirty_ring;
+
+	/*
+	 * The index of the most recently used memslot by this vCPU. It's ok
+	 * if this becomes stale due to memslot changes since we always check
+	 * it is a valid slot.
+	 */
+	int last_used_slot;
 };
 
 /* must be called with irqs disabled */
@@ -1201,6 +1208,12 @@ try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
 	if (slot_index < 0 || slot_index >= slots->used_slots)
 		return NULL;
 
+	/*
+	 * slot_index can come from vcpu->last_used_slot which is not kept
+	 * in sync with userspace-controllable memslot deletion. So use nospec
+	 * to prevent the CPU from speculating past the end of memslots[].
+	 */
+	slot_index = array_index_nospec(slot_index, slots->used_slots);
 	slot = &slots->memslots[slot_index];
 
 	if (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9d3c9f71b4e1..9ae8b96905c7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -415,6 +415,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->preempted = false;
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
+	vcpu->last_used_slot = 0;
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -2024,7 +2025,26 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
+	struct kvm_memslots *slots = kvm_vcpu_memslots(vcpu);
+	struct kvm_memory_slot *slot;
+	int slot_index;
+
+	slot = try_get_memslot(slots, vcpu->last_used_slot, gfn);
+	if (slot)
+		return slot;
+
+	/*
+	 * Fall back to searching all memslots. We purposely use
+	 * search_memslots() instead of __gfn_to_memslot() to avoid
+	 * thrashing the VM-wide last_used_index in kvm_memslots.
+	 */
+	slot = search_memslots(slots, gfn, &slot_index);
+	if (slot) {
+		vcpu->last_used_slot = slot_index;
+		return slot;
+	}
+
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
-- 
2.32.0.554.ge1b32706d8-goog

