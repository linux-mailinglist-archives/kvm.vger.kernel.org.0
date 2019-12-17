Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF31237AA
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 21:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfLQUlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 15:41:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:63055 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbfLQUkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 15:40:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 12:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="389952615"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v4 14/19] KVM: Clean up local variable usage in __kvm_set_memory_region()
Date:   Tue, 17 Dec 2019 12:40:36 -0800
Message-Id: <20191217204041.10815-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up __kvm_set_memory_region() to achieve several goals:

  - Remove local variables that serve no real purpose
  - Improve the readability of the code
  - Better show the relationship between the 'old' and 'new' memslot
  - Prepare for dynamically sizing memslots.

Note, using 'tmp' to hold the initial memslot is not strictly necessary
at this juncture, e.g. 'old' could be directly copied from
id_to_memslot(), but keep the pointer usage as id_to_memslot() will be
able to return a NULL pointer once memslots are dynamically sized.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 47 +++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2fa40c3e7961..b3e732078ab2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1074,13 +1074,11 @@ static int kvm_delete_memslot(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	int r;
-	gfn_t base_gfn;
-	unsigned long npages;
-	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
-	int as_id, id;
+	struct kvm_memory_slot *tmp;
 	enum kvm_mr_change change;
+	int as_id, id;
+	int r;
 
 	r = check_memory_region_flags(mem);
 	if (r)
@@ -1105,52 +1103,55 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
 
-	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
-	npages = mem->memory_size >> PAGE_SHIFT;
-
-	if (npages > KVM_MEM_MAX_NR_PAGES)
-		return -EINVAL;
-
 	/*
 	 * Make a full copy of the old memslot, the pointer will become stale
 	 * when the memslots are re-sorted by update_memslots().
 	 */
-	old = *slot;
+	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
+	old = *tmp;
+	tmp = NULL;
+
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
-	new = old;
-
 	new.id = id;
-	new.base_gfn = base_gfn;
-	new.npages = npages;
+	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
+	new.npages = mem->memory_size >> PAGE_SHIFT;
 	new.flags = mem->flags;
 	new.userspace_addr = mem->userspace_addr;
 
+	if (new.npages > KVM_MEM_MAX_NR_PAGES)
+		return -EINVAL;
+
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
+		new.dirty_bitmap = NULL;
+		memset(&new.arch, 0, sizeof(new.arch));
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
-		    (npages != old.npages) ||
+		    (new.npages != old.npages) ||
 		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (base_gfn != old.base_gfn)
+		if (new.base_gfn != old.base_gfn)
 			change = KVM_MR_MOVE;
 		else if (new.flags != old.flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
+
+		/* Copy dirty_bitmap and arch from the current memslot. */
+		new.dirty_bitmap = old.dirty_bitmap;
+		memcpy(&new.arch, &old.arch, sizeof(new.arch));
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
 		/* Check for overlaps */
-		kvm_for_each_memslot(slot, __kvm_memslots(kvm, as_id)) {
-			if (slot->id == id)
+		kvm_for_each_memslot(tmp, __kvm_memslots(kvm, as_id)) {
+			if (tmp->id == id)
 				continue;
-			if (!((base_gfn + npages <= slot->base_gfn) ||
-			      (base_gfn >= slot->base_gfn + slot->npages)))
+			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
+			      (new.base_gfn >= tmp->base_gfn + tmp->npages)))
 				return -EEXIST;
 		}
 	}
-- 
2.24.1

