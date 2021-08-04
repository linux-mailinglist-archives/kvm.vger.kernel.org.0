Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434AF3E0A5C
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhHDW3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbhHDW3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:29:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5EAC06179B
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 15:29:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s6-20020a170902b186b029012cbebe7236so664526plr.11
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 15:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Bk8U0jio7mRFkeeUxntTqJSeYflds2FmZc2qdnrxh4k=;
        b=YXlps6w72QwFtNeJLBv93P4DfNsv9Q9pnaWra6vSLL/drHhBIkkLAAWjcencTwuvlG
         Poz1uip/vMzZOiQTtaDss+T8BnCB5V3fhs2IghnuUp/C1tglhFAudoUdw0F3HB4Pa7Re
         in5uHLn1vWkYDztu+Tx7vzahBy566ckgJscXx9J5qiVhj01rPAXH4vyUVj01Cpk8U83W
         +Jja4n3sQOqEG03tTsaklETM5+7AwwPFwJJy2doIWfQrrbzYDyyEGQv9lfpp4AmzjL2I
         /bu21jtXOeVe/7NHRMb33wvCOQgXR++2cYcdZLK2GMauemh7XrzbKNAfKcMI21xXJqjp
         EKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Bk8U0jio7mRFkeeUxntTqJSeYflds2FmZc2qdnrxh4k=;
        b=dKuItzYBXCBB9UqqOnFQYpj7gmdAt0I6gWvXkZwGcFjkk/v8808u9P318SLB1N34eX
         zhktywa3gCsOwm6DUe2eMEeOUImiswZpjKw7yiqyi4RuWPofnwKh5rtSxwAXKVYg+k1M
         RSErPq0Qgmuw7wlYRWiUXUChq4K0wv3S7J80C9DS66l0fK1r6WDo9xckeMm7JYGdp3mg
         ED/P+oHRU9KE/rq0XZU/f4u2inkqnZONZjq1uQhjRp7OzRRjRr9xTCV2/H1lTKVCdwh2
         xwEqxnfupL2fYSWeBJXsQ0W5gnVkY1U8JGEMq3LkUOnjD/uHz1JCSQ+7TH6HTnElDa4y
         l4zA==
X-Gm-Message-State: AOAM531075iusmDc/Czeyrl1waN1hPT8s3AyjuwPDWAv2XhSv/KOFfh0
        4jPLJ3Qxpxz7HgF6HmCdG5GdSziZZiVjUw==
X-Google-Smtp-Source: ABdhPJwgX+p1R8mxhSnM/ta2kGDRLl8Cv0dDa3hjAiS6zXXIOTPMUayiB8hoXUZi58fvlU/HKBx9r17Df2XHjQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:794e:0:b029:3c5:a678:efff with SMTP
 id u75-20020a62794e0000b02903c5a678efffmr1894496pfc.11.1628116142566; Wed, 04
 Aug 2021 15:29:02 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:39 +0000
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Message-Id: <20210804222844.1419481-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210804222844.1419481-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 2/7] KVM: Move last_used_slot logic out of search_memslots
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

Make search_memslots unconditionally search all memslots and move the
last_used_slot logic up one level to __gfn_to_memslot. This is in
preparation for introducing a per-vCPU last_used_slot.

As part of this change convert existing callers of search_memslots to
__gfn_to_memslot to avoid making any functional changes.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/powerpc/kvm/book3s_64_vio.c    |  2 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c |  2 +-
 include/linux/kvm_host.h            | 64 +++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 8da93fdfa59e..6365087f3160 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -346,7 +346,7 @@ static long kvmppc_tce_to_ua(struct kvm *kvm, unsigned long tce,
 	unsigned long gfn = tce >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
 
-	memslot = search_memslots(kvm_memslots(kvm), gfn);
+	memslot = __gfn_to_memslot(kvm_memslots(kvm), gfn);
 	if (!memslot)
 		return -EINVAL;
 
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index dc6591548f0c..f38dfe195ef2 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -80,7 +80,7 @@ static long kvmppc_rm_tce_to_ua(struct kvm *kvm,
 	unsigned long gfn = tce >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
 
-	memslot = search_memslots(kvm_memslots_raw(kvm), gfn);
+	memslot = __gfn_to_memslot(kvm_memslots_raw(kvm), gfn);
 	if (!memslot)
 		return -EINVAL;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 61ff8130a75d..7f28731346f8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1190,29 +1190,43 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
 /*
- * search_memslots() and __gfn_to_memslot() are here because they are
- * used in non-modular code in arch/powerpc/kvm/book3s_hv_rm_mmu.c.
- * gfn_to_memslot() itself isn't here as an inline because that would
- * bloat other code too much.
+ * Returns a pointer to the memslot at slot_index if it contains gfn.
+ * Otherwise returns NULL.
+ */
+static inline struct kvm_memory_slot *
+try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+
+	if (slot_index < 0 || slot_index >= slots->used_slots)
+		return NULL;
+
+	slot = &slots->memslots[slot_index];
+
+	if (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
+		return slot;
+	else
+		return NULL;
+}
+
+/*
+ * Returns a pointer to the memslot that contains gfn and records the index of
+ * the slot in index. Otherwise returns NULL.
  *
  * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
 static inline struct kvm_memory_slot *
-search_memslots(struct kvm_memslots *slots, gfn_t gfn)
+search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
 {
 	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->last_used_slot);
 	struct kvm_memory_slot *memslots = slots->memslots;
+	struct kvm_memory_slot *slot;
 
 	if (unlikely(!slots->used_slots))
 		return NULL;
 
-	if (gfn >= memslots[slot].base_gfn &&
-	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
-		return &memslots[slot];
-
 	while (start < end) {
-		slot = start + (end - start) / 2;
+		int slot = start + (end - start) / 2;
 
 		if (gfn >= memslots[slot].base_gfn)
 			end = slot;
@@ -1220,19 +1234,37 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 			start = slot + 1;
 	}
 
-	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->last_used_slot, start);
-		return &memslots[start];
+	slot = try_get_memslot(slots, start, gfn);
+	if (slot) {
+		*index = start;
+		return slot;
 	}
 
 	return NULL;
 }
 
+/*
+ * __gfn_to_memslot() and its descendants are here because it is called from
+ * non-modular code in arch/powerpc/kvm/book3s_64_vio{,_hv}.c. gfn_to_memslot()
+ * itself isn't here as an inline because that would bloat other code too much.
+ */
 static inline struct kvm_memory_slot *
 __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 {
-	return search_memslots(slots, gfn);
+	struct kvm_memory_slot *slot;
+	int slot_index = atomic_read(&slots->last_used_slot);
+
+	slot = try_get_memslot(slots, slot_index, gfn);
+	if (slot)
+		return slot;
+
+	slot = search_memslots(slots, gfn, &slot_index);
+	if (slot) {
+		atomic_set(&slots->last_used_slot, slot_index);
+		return slot;
+	}
+
+	return NULL;
 }
 
 static inline unsigned long
-- 
2.32.0.554.ge1b32706d8-goog

