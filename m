Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CD71237ED
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 21:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfLQUmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 15:42:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:63047 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfLQUko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 15:40:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 12:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="389952596"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:42 -0800
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
Subject: [PATCH v4 08/19] KVM: Refactor error handling for setting memory region
Date:   Tue, 17 Dec 2019 12:40:30 -0800
Message-Id: <20191217204041.10815-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace a big pile o' gotos with returns to make it more obvious what
error code is being returned, and to prepare for refactoring the
functional, i.e. post-checks, portion of __kvm_set_memory_region().

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b2261a9e139..9c488c653257 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1008,34 +1008,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	r = check_memory_region_flags(mem);
 	if (r)
-		goto out;
+		return r;
 
-	r = -EINVAL;
 	as_id = mem->slot >> 16;
 	id = (u16)mem->slot;
 
 	/* General sanity checks */
 	if (mem->memory_size & (PAGE_SIZE - 1))
-		goto out;
+		return -EINVAL;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
-		goto out;
+		return -EINVAL;
 	/* We can read the guest memory with __xxx_user() later on. */
 	if ((id < KVM_USER_MEM_SLOTS) &&
 	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
 	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
-		goto out;
+		return -EINVAL;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
-		goto out;
+		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
-		goto out;
+		return -EINVAL;
 
 	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;
 
 	if (npages > KVM_MEM_MAX_NR_PAGES)
-		goto out;
+		return -EINVAL;
 
 	new = old = *slot;
 
@@ -1052,20 +1051,18 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			if ((new.userspace_addr != old.userspace_addr) ||
 			    (npages != old.npages) ||
 			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
-				goto out;
+				return -EINVAL;
 
 			if (base_gfn != old.base_gfn)
 				change = KVM_MR_MOVE;
 			else if (new.flags != old.flags)
 				change = KVM_MR_FLAGS_ONLY;
-			else { /* Nothing to change. */
-				r = 0;
-				goto out;
-			}
+			else /* Nothing to change. */
+				return 0;
 		}
 	} else {
 		if (!old.npages)
-			goto out;
+			return -EINVAL;
 
 		change = KVM_MR_DELETE;
 		new.base_gfn = 0;
@@ -1074,29 +1071,29 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
 		/* Check for overlaps */
-		r = -EEXIST;
 		kvm_for_each_memslot(slot, __kvm_memslots(kvm, as_id)) {
 			if (slot->id == id)
 				continue;
 			if (!((base_gfn + npages <= slot->base_gfn) ||
 			      (base_gfn >= slot->base_gfn + slot->npages)))
-				goto out;
+				return -EEXIST;
 		}
 	}
 
-	r = -ENOMEM;
-
 	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
 	else if (!new.dirty_bitmap) {
-		if (kvm_create_dirty_bitmap(&new) < 0)
-			goto out;
+		r = kvm_create_dirty_bitmap(&new);
+		if (r)
+			return r;
 	}
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-	if (!slots)
+	if (!slots) {
+		r = -ENOMEM;
 		goto out_bitmap;
+	}
 	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
 
 	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
@@ -1147,7 +1144,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 out_bitmap:
 	if (new.dirty_bitmap && !old.dirty_bitmap)
 		kvm_destroy_dirty_bitmap(&new);
-out:
 	return r;
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
-- 
2.24.1

