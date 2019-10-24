Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FBAE4021
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbfJXXIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:08:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:23481 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbfJXXHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:07:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="202445850"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
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
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 07/15] KVM: Refactor error handling for setting memory region
Date:   Thu, 24 Oct 2019 16:07:36 -0700
Message-Id: <20191024230744.14543-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace a big pile o' gotos with returns to make it more obvious what
error code is being returned, and to prepare for refactoring the
functional, i.e. post-checks, portion of __kvm_set_memory_region().

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a43902d9036d..e2f47d60f696 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -942,34 +942,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
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
 
@@ -986,20 +985,18 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
@@ -1008,29 +1005,29 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
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
@@ -1081,7 +1078,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 out_bitmap:
 	if (new.dirty_bitmap && !old.dirty_bitmap)
 		kvm_destroy_dirty_bitmap(&new);
-out:
 	return r;
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
-- 
2.22.0

