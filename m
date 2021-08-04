Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BB3E0A5B
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhHDW3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhHDW3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:29:15 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88217C061799
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 15:29:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u4-20020a170902e804b029012c4b467095so3098400plg.9
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 15:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3uX4Kc47NNXUrNGy46vgaPihGQ8FyrZG6iR6ebNDsDc=;
        b=ReYzSeusGAn2PGFuAd8+CY84Ne5ZKe1HuCKfqe2N21jzOZz7AP1UTUqbGH464t7ftS
         ilGLQzK7dz7uTBF0477YBUiqc8bwu7rX36Xh869kleujI1LzyuErASOI9HCcHdCQo003
         KuYIpVtd8y73MVrpyGyUWToDlez+pSdkJfWCANSxlvQtV3OMM/Ty4emjWYrGOaToc6aX
         nXun6fIIHA97qvSIt5JNHzk4wKJpZcmvU9xCaZSXkMQWaZolKHEqL2O1BCJ6a3TvQYBI
         ktsMNfINv1LQa+1rN67V+lSnSkUocWf7ptOmmQHjCwgQ5DOS3qHMPZjtY55tQgM2FwkE
         rDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3uX4Kc47NNXUrNGy46vgaPihGQ8FyrZG6iR6ebNDsDc=;
        b=pnd4YJbsyYlNy/t3dzppBLEeHcN8sViHXj0GJt/O7oE7FvhllGAhSnHZVTwra/glz4
         8AdNumDJ1FrS9icx4cF+UP4ihp3q9AY1BWBfU8t2bTamiv1gVH2Zg5TeTFNNsrX05YpZ
         XnEAaxvDQz7KcejVa7hXo6iG8x3v5ZN5Niy+5dRVUvyJNUD2E4u+mtDxNlOohf363iJv
         Tqa9x2ZS1uryCnPbBHC5pkmfxKIZsV8EqQU9A7gbrPkWz418BBH1AM1vZwmq4B5wLigk
         kU1YBkXPCwQ3JQKdzZd63i4npT+IaQSbYK/0YcYsTJY8fRO1jREqBJjFSTwD95RAPjtv
         al0Q==
X-Gm-Message-State: AOAM530Z2LLBdBT8IcthMp7xmdrpdYMSxmlCrJ6usuM8NzcRNAwjU+U/
        qxwHSeIRqbH/IJGZBC5Vsew0w4sacKTzAQ==
X-Google-Smtp-Source: ABdhPJxxrAzDm5P7D5+dpEIMKXpRrs/rU9Pj7rZ1PDGD50MCzlCks7ijppohsZicnKnsd+2o2YR6JqCSCyYeIg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:65c7:0:b029:3c3:4eff:1b26 with SMTP
 id z190-20020a6265c70000b02903c34eff1b26mr1558855pfb.48.1628116141026; Wed,
 04 Aug 2021 15:29:01 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:38 +0000
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Message-Id: <20210804222844.1419481-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210804222844.1419481-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 1/7] KVM: Rename lru_slot to last_used_slot
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

lru_slot is used to keep track of the index of the most-recently used
memslot. The correct acronym would be "mru" but that is not a common
acronym. So call it last_used_slot which is a bit more obvious.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 include/linux/kvm_host.h | 6 +++---
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4527ac7b5961..02574d7b3612 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1953,7 +1953,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
 {
 	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->lru_slot);
+	int slot = atomic_read(&slots->last_used_slot);
 	struct kvm_memory_slot *memslots = slots->memslots;
 
 	if (gfn >= memslots[slot].base_gfn &&
@@ -1974,7 +1974,7 @@ static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
 
 	if (gfn >= memslots[start].base_gfn &&
 	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->lru_slot, start);
+		atomic_set(&slots->last_used_slot, start);
 	}
 
 	return start;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d6b4ad407b8..61ff8130a75d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -522,7 +522,7 @@ struct kvm_memslots {
 	u64 generation;
 	/* The mapping table from slot id to the index in memslots[]. */
 	short id_to_index[KVM_MEM_SLOTS_NUM];
-	atomic_t lru_slot;
+	atomic_t last_used_slot;
 	int used_slots;
 	struct kvm_memory_slot memslots[];
 };
@@ -1201,7 +1201,7 @@ static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 {
 	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->lru_slot);
+	int slot = atomic_read(&slots->last_used_slot);
 	struct kvm_memory_slot *memslots = slots->memslots;
 
 	if (unlikely(!slots->used_slots))
@@ -1222,7 +1222,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 
 	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
 	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->lru_slot, start);
+		atomic_set(&slots->last_used_slot, start);
 		return &memslots[start];
 	}
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a96cbe24c688..9d3c9f71b4e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1223,8 +1223,8 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 
 	slots->used_slots--;
 
-	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
-		atomic_set(&slots->lru_slot, 0);
+	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
+		atomic_set(&slots->last_used_slot, 0);
 
 	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
 		mslots[i] = mslots[i + 1];
-- 
2.32.0.554.ge1b32706d8-goog

