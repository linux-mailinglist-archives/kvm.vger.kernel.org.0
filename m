Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353F346A640
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349134AbhLFUAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 15:00:13 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50244 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349088AbhLFT76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:59:58 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK5m-0000uY-OO; Mon, 06 Dec 2021 20:56:06 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 16/29] KVM: Don't make a full copy of the old memslot in __kvm_set_memory_region()
Date:   Mon,  6 Dec 2021 20:54:22 +0100
Message-Id: <5dce0946b41bba8c83f6e3424c6955c56bcc9f86.1638817640.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Stop making a full copy of the old memslot in __kvm_set_memory_region()
now that metadata updates are handled by kvm_set_memslot(), i.e. now that
the old memslot's dirty bitmap doesn't need to be referenced after the
memslot and its pointer is modified/invalidated by kvm_set_memslot().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1689f598fe9e..1f37c4ce5f97 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1732,8 +1732,8 @@ static int kvm_set_memslot(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	struct kvm_memory_slot old, new;
-	struct kvm_memory_slot *tmp;
+	struct kvm_memory_slot *old, *tmp;
+	struct kvm_memory_slot new;
 	enum kvm_mr_change change;
 	int as_id, id;
 	int r;
@@ -1763,25 +1763,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	/*
-	 * Make a full copy of the old memslot, the pointer will become stale
-	 * when the memslots are re-sorted by update_memslots(), and the old
-	 * memslot needs to be referenced after calling update_memslots(), e.g.
-	 * to free its resources and for arch specific behavior.
+	 * Note, the old memslot (and the pointer itself!) may be invalidated
+	 * and/or destroyed by kvm_set_memslot().
 	 */
-	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-	if (tmp) {
-		old = *tmp;
-		tmp = NULL;
-	} else {
-		memset(&old, 0, sizeof(old));
-		old.id = id;
-	}
+	old = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
 	if (!mem->memory_size) {
-		if (!old.npages)
+		if (!old || !old->npages)
 			return -EINVAL;
 
-		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old.npages))
+		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
 			return -EIO;
 
 		memset(&new, 0, sizeof(new));
@@ -1801,7 +1792,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (new.npages > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
-	if (!old.npages) {
+	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
 
 		/*
@@ -1811,14 +1802,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		if ((new.userspace_addr != old.userspace_addr) ||
-		    (new.npages != old.npages) ||
-		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+		if ((new.userspace_addr != old->userspace_addr) ||
+		    (new.npages != old->npages) ||
+		    ((new.flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (new.base_gfn != old.base_gfn)
+		if (new.base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
-		else if (new.flags != old.flags)
+		else if (new.flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
