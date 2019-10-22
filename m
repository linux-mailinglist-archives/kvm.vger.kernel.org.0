Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8337DF9B2
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfJVAgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:36:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:35286 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbfJVAfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:35:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:35:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="348897223"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 21 Oct 2019 17:35:39 -0700
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
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/15] KVM: Move memslot deletion to helper function
Date:   Mon, 21 Oct 2019 17:35:31 -0700
Message-Id: <20191022003537.13013-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022003537.13013-1-sean.j.christopherson@intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move memslot deletion into its own routine so that the success path for
other memslot updates does not need to use kvm_free_memslot(), i.e. can
explicitly destroy the dirty bitmap when necessary.  This paves the way
for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
NULL for @dont.

Add a comment above the code to make a copy of the existing memslot
prior to deletion, it is not at all obvious that the pointer will become
stale due sorting and/or installation of new memslots.

Note, kvm_arch_commit_memory_region() allows an architecture to free
resources when moving a memslot or changing its flags, i.e. implement
logic similar to the dirty bitmap is handling, if such functionality is
needed in the future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 73 +++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b534865754b6..38bb446cef85 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -968,6 +968,27 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_delete_memslot(struct kvm *kvm,
+			      const struct kvm_userspace_memory_region *mem,
+			      struct kvm_memory_slot *old, int as_id)
+{
+	struct kvm_memory_slot new;
+	int r;
+
+	if (!old->npages)
+		return -EINVAL;
+
+	memset(&new, 0, sizeof(new));
+	new.id = old->id;
+
+	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
+	if (r)
+		return r;
+
+	kvm_free_memslot(kvm, old, NULL);
+	return 0;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1017,7 +1038,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (npages > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
-	new = old = *slot;
+	/*
+	 * Make a full copy of the old memslot, the pointer will become stale
+	 * when the memslots are re-sorted by update_memslots().
+	 */
+	old = *slot;
+	if (!mem->memory_size)
+		return kvm_delete_memslot(kvm, mem, &old, as_id);
+
+	new = old;
 
 	new.id = id;
 	new.base_gfn = base_gfn;
@@ -1025,29 +1054,20 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.flags = mem->flags;
 	new.userspace_addr = mem->userspace_addr;
 
-	if (npages) {
-		if (!old.npages)
-			change = KVM_MR_CREATE;
-		else { /* Modify an existing slot. */
-			if ((new.userspace_addr != old.userspace_addr) ||
-			    (npages != old.npages) ||
-			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
-				return -EINVAL;
-
-			if (base_gfn != old.base_gfn)
-				change = KVM_MR_MOVE;
-			else if (new.flags != old.flags)
-				change = KVM_MR_FLAGS_ONLY;
-			else /* Nothing to change. */
-				return 0;
-		}
-	} else {
-		if (!old.npages)
+	if (!old.npages) {
+		change = KVM_MR_CREATE;
+	} else { /* Modify an existing slot. */
+		if ((new.userspace_addr != old.userspace_addr) ||
+		    (npages != old.npages) ||
+		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		change = KVM_MR_DELETE;
-		new.base_gfn = 0;
-		new.flags = 0;
+		if (base_gfn != old.base_gfn)
+			change = KVM_MR_MOVE;
+		else if (new.flags != old.flags)
+			change = KVM_MR_FLAGS_ONLY;
+		else /* Nothing to change. */
+			return 0;
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
@@ -1070,17 +1090,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return r;
 	}
 
-	/* actual memory is freed via old in kvm_free_memslot below */
-	if (change == KVM_MR_DELETE) {
-		new.dirty_bitmap = NULL;
-		memset(&new.arch, 0, sizeof(new.arch));
-	}
-
 	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
 	if (r)
 		goto out_bitmap;
 
-	kvm_free_memslot(kvm, &old, &new);
+	if (old.dirty_bitmap && !new.dirty_bitmap)
+		kvm_destroy_dirty_bitmap(&old);
 	return 0;
 
 out_bitmap:
-- 
2.22.0

