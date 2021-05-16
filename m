Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFB838214A
	for <lists+kvm@lfdr.de>; Sun, 16 May 2021 23:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhEPVrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 17:47:07 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:54500 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhEPVq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 May 2021 17:46:56 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1liOZe-000824-SO; Sun, 16 May 2021 23:45:22 +0200
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
Subject: [PATCH v3 8/8] KVM: Optimize overlapping memslots check
Date:   Sun, 16 May 2021 23:44:34 +0200
Message-Id: <61d53c8121b5b906bbed363e493ac75aebbda693.1621191552.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621191549.git.maciej.szmigiero@oracle.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Do a quick lookup for possibly overlapping gfns when creating or moving
a memslot instead of performing a linear scan of the whole memslot set.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 65 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 189504b27ca6..11814730cbcb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1474,6 +1474,59 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	return kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
 }
 
+static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
+				      struct kvm_memory_slot *nslot)
+{
+	int idxactive = kvm_memslots_idx(slots);
+	struct rb_node *node;
+
+	/*
+	 * Find the slot with the lowest gfn that can possibly intersect with
+	 * the new slot, so we'll ideally have slot start <= nslot start
+	 */
+	node = kvm_memslots_gfn_upper_bound(slots, nslot->base_gfn);
+	if (node) {
+		struct rb_node *pnode;
+
+		/*
+		 * A NULL previous node means that the very first slot
+		 * already has a higher start gfn.
+		 * In this case slot start > nslot start.
+		 */
+		pnode = rb_prev(node);
+		if (pnode)
+			node = pnode;
+	} else {
+		/* a NULL node below means no existing slots */
+		node = rb_last(&slots->gfn_tree);
+	}
+
+	for ( ; node; node = rb_next(node)) {
+		struct kvm_memory_slot *cslot;
+
+		cslot = container_of(node, struct kvm_memory_slot,
+				     gfn_node[idxactive]);
+
+		/*
+		 * if this slot starts beyond or at the end of the new slot
+		 * so does every next one
+		 */
+		if (cslot->base_gfn >= nslot->base_gfn + nslot->npages)
+			break;
+
+		if (cslot->id == nslot->id)
+			continue;
+
+		if (cslot->base_gfn >= nslot->base_gfn)
+			return true;
+
+		if (cslot->base_gfn + cslot->npages > nslot->base_gfn)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1559,16 +1612,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
-		int ctr;
-
 		/* Check for overlaps */
-		kvm_for_each_memslot(tmp, ctr, __kvm_memslots(kvm, as_id)) {
-			if (tmp->id == id)
-				continue;
-			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
-			      (new.base_gfn >= tmp->base_gfn + tmp->npages)))
-				return -EEXIST;
-		}
+		if (kvm_check_memslot_overlap(__kvm_memslots(kvm, as_id),
+					      &new))
+			return -EEXIST;
 	}
 
 	/* Allocate/free page dirty bitmap as needed */
