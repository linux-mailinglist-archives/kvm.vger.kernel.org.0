Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F64B0412
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 20:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbfIKSu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 14:50:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:39426 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfIKSup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 14:50:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 11:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="196980903"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 11:50:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] KVM: Dynamically size memslot array based on number of used slots
Date:   Wed, 11 Sep 2019 11:50:38 -0700
Message-Id: <20190911185038.24341-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190911185038.24341-1-sean.j.christopherson@intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the memslot logic doesn't assume memslots are always non-NULL,
dynamically size the array of memslots instead of unconditionally
allocating memory for the maximum number of memslots.

Note, because a to-be-deleted memslot must first be invalidated, the
array size cannot be immediately reduced when deleting a memslot.
However, consecutive deletions will realize the memory savings, i.e.
a second deletion will trim the entry.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/linux/kvm_host.h |  5 ++++-
 virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 40ea5df50faa..8feb61bfbd1a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -433,11 +433,14 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  */
 struct kvm_memslots {
 	u64 generation;
-	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 	/* The mapping table from slot id to the index in memslots[]. */
 	short id_to_index[KVM_MEM_SLOTS_NUM];
 	atomic_t lru_slot;
 	int used_slots;
+	struct kvm_memory_slot memslots[];
+	/*
+	 * WARNING: 'memslots' is dynamically-sized.  It *MUST* be at the end.
+	 */
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e2571a9ccfc4..f952a0bec67a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -535,7 +535,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 		return NULL;
 
 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[i] = slots->memslots[i].id = -1;
+		slots->id_to_index[i] = -1;
 
 	return slots;
 }
@@ -933,6 +933,32 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	return old_memslots;
 }
 
+/*
+ * Note, at a minimum, the current number of used slots must be allocated, even
+ * when deleting a memslot, as we need a complete duplicate of the memslots for
+ * use when invalidating a memslot prior to deleting/moving the memslot.
+ */
+static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
+					     enum kvm_mr_change change)
+{
+	struct kvm_memslots *slots;
+	size_t old_size, new_size;
+
+	old_size = sizeof(struct kvm_memslots) +
+		   (sizeof(struct kvm_memory_slot) * old->used_slots);
+
+	if (change == KVM_MR_CREATE)
+		new_size = old_size + sizeof(struct kvm_memory_slot);
+	else
+		new_size = old_size;
+
+	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
+	if (likely(slots))
+		memcpy(slots, old, old_size);
+
+	return slots;
+}
+
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
 			   const struct kvm_memory_slot *old,
@@ -943,10 +969,9 @@ static int kvm_set_memslot(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int r;
 
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
+	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
 	if (!slots)
 		return -ENOMEM;
-	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
 
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		/*
-- 
2.22.0

