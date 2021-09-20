Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3856A412840
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244847AbhITVnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 17:43:24 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:45450 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235349AbhITVlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 17:41:23 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mSR0g-0006Q5-2P; Mon, 20 Sep 2021 23:39:34 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/13] KVM: Integrate gfn_to_memslot_approx() into search_memslots()
Date:   Mon, 20 Sep 2021 23:38:53 +0200
Message-Id: <d0d2c6fda0a21962eefcf28b37a603caa4be1819.1632171479.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632171478.git.maciej.szmigiero@oracle.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

s390 arch has gfn_to_memslot_approx() which is almost identical to
search_memslots(), differing only in that in case the gfn falls in a hole
one of the memslots bordering the hole is returned.

Add this lookup mode as an option to search_memslots() so we don't have two
almost identical functions for looking up a memslot by its gfn.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 39 ++-------------------------------------
 include/linux/kvm_host.h | 25 ++++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  2 +-
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3fd0f4afe742..540fa948baa5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1941,41 +1941,6 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 /* for consistency */
 #define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
 
-/*
- * Similar to gfn_to_memslot, but returns the index of a memslot also when the
- * address falls in a hole. In that case the index of one of the memslots
- * bordering the hole is returned.
- */
-static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
-{
-	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->last_used_slot);
-	struct kvm_memory_slot *memslots = slots->memslots;
-
-	if (gfn >= memslots[slot].base_gfn &&
-	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
-		return slot;
-
-	while (start < end) {
-		slot = start + (end - start) / 2;
-
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
-		else
-			start = slot + 1;
-	}
-
-	if (start >= slots->used_slots)
-		return slots->used_slots - 1;
-
-	if (gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->last_used_slot, start);
-	}
-
-	return start;
-}
-
 static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 			      u8 *res, unsigned long bufsize)
 {
@@ -2002,8 +1967,8 @@ static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
 					      unsigned long cur_gfn)
 {
-	int slotidx = gfn_to_memslot_approx(slots, cur_gfn);
-	struct kvm_memory_slot *ms = slots->memslots + slotidx;
+	struct kvm_memory_slot *ms = __gfn_to_memslot_approx(slots, cur_gfn, true);
+	int slotidx = ms - slots->memslots;
 	unsigned long ofs = cur_gfn - ms->base_gfn;
 
 	if (ms->base_gfn + ms->npages <= cur_gfn) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c6963f6f1eb8..8fd9644f40b2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1231,10 +1231,14 @@ try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
  * Returns a pointer to the memslot that contains gfn and records the index of
  * the slot in index. Otherwise returns NULL.
  *
+ * With "approx" set returns the memslot also when the address falls
+ * in a hole. In that case one of the memslots bordering the hole is
+ * returned.
+ *
  * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
 static inline struct kvm_memory_slot *
-search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
+search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index, bool approx)
 {
 	int start = 0, end = slots->used_slots;
 	struct kvm_memory_slot *memslots = slots->memslots;
@@ -1252,11 +1256,20 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
 			start = slot + 1;
 	}
 
+	if (approx && start >= slots->used_slots) {
+		*index = slots->used_slots - 1;
+		return &memslots[slots->used_slots - 1];
+	}
+
 	slot = try_get_memslot(slots, start, gfn);
 	if (slot) {
 		*index = start;
 		return slot;
 	}
+	if (approx) {
+		*index = start;
+		return &memslots[start];
+	}
 
 	return NULL;
 }
@@ -1267,7 +1280,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
  * itself isn't here as an inline because that would bloat other code too much.
  */
 static inline struct kvm_memory_slot *
-__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
+__gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
 	struct kvm_memory_slot *slot;
 	int slot_index = atomic_read(&slots->last_used_slot);
@@ -1276,7 +1289,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 	if (slot)
 		return slot;
 
-	slot = search_memslots(slots, gfn, &slot_index);
+	slot = search_memslots(slots, gfn, &slot_index, approx);
 	if (slot) {
 		atomic_set(&slots->last_used_slot, slot_index);
 		return slot;
@@ -1285,6 +1298,12 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 	return NULL;
 }
 
+static inline struct kvm_memory_slot *
+__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
+{
+	return __gfn_to_memslot_approx(slots, gfn, false);
+}
+
 static inline unsigned long
 __gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c3c71a9e85c9..14043a6edb88 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2062,7 +2062,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 	 * search_memslots() instead of __gfn_to_memslot() to avoid
 	 * thrashing the VM-wide last_used_index in kvm_memslots.
 	 */
-	slot = search_memslots(slots, gfn, &slot_index);
+	slot = search_memslots(slots, gfn, &slot_index, false);
 	if (slot) {
 		vcpu->last_used_slot = slot_index;
 		return slot;
