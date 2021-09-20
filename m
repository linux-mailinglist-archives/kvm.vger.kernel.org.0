Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF406412855
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 23:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbhITVpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 17:45:00 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:45684 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241029AbhITVmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 17:42:01 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mSR1M-0006V6-J7; Mon, 20 Sep 2021 23:40:16 +0200
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
Subject: [PATCH v5 13/13] KVM: Optimize overlapping memslots check
Date:   Mon, 20 Sep 2021 23:39:01 +0200
Message-Id: <4f8718fc8da57ab799e95ef7c2060f8be0f2391f.1632171479.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632171478.git.maciej.szmigiero@oracle.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
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
 virt/kvm/kvm_main.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5fea467d6fec..78dad8c6376f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1667,6 +1667,30 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	return kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
 }
 
+static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
+				      struct kvm_memory_slot *nslot)
+{
+	int idx = slots->node_idx;
+	gfn_t nend = nslot->base_gfn + nslot->npages;
+	struct rb_node *node;
+
+	kvm_for_each_memslot_in_gfn_range(node, slots, nslot->base_gfn, nend) {
+		struct kvm_memory_slot *cslot;
+		gfn_t cend;
+
+		cslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		cend = cslot->base_gfn + cslot->npages;
+		if (cslot->id == nslot->id)
+			continue;
+
+		/* kvm_for_each_in_gfn_no_more() guarantees that cslot->base_gfn < nend */
+		if (cend > nslot->base_gfn)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1752,16 +1776,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
-		int bkt;
-
 		/* Check for overlaps */
-		kvm_for_each_memslot(tmp, bkt, __kvm_memslots(kvm, as_id)) {
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
