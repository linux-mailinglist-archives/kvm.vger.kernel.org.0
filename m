Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4192C3C82
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgKYJmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:01 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57212 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728006AbgKYJl7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:59 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 358D6305D50E;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 15F8C3072784;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 28/81] KVM: x86: page track: add track_create_slot() callback
Date:   Wed, 25 Nov 2020 11:35:07 +0200
Message-Id: <20201125093600.2766-29-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is used to add page access notifications as soon as a slot appears
or when a slot is moved.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_page_track.h | 13 ++++++++++++-
 arch/x86/kvm/mmu/page_track.c         | 17 ++++++++++++++++-
 arch/x86/kvm/x86.c                    |  7 ++++---
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 9a261e463eb3..00a66c4d4d3c 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -36,6 +36,17 @@ struct kvm_page_track_notifier_node {
 	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			    const u8 *new, int bytes,
 			    struct kvm_page_track_notifier_node *node);
+	/*
+	 * It is called when memory slot is being created
+	 *
+	 * @kvm: the kvm where memory slot being moved or removed
+	 * @slot: the memory slot being moved or removed
+	 * @npages: the number of pages
+	 * @node: this node
+	 */
+	void (*track_create_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  unsigned long npages,
+				  struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when memory slot is being moved or removed
 	 * users can drop write-protection for the pages in that memory slot
@@ -52,7 +63,7 @@ void kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index d7a591a85af8..27a8d1a02e84 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -28,9 +28,12 @@ void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 	}
 }
 
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  unsigned long npages)
 {
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
 	int  i;
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
@@ -41,6 +44,18 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 			goto track_free;
 	}
 
+	head = &kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return 0;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
+		if (n->track_create_slot)
+			n->track_create_slot(kvm, slot, npages, n);
+	srcu_read_unlock(&head->track_srcu, idx);
+
 	return 0;
 
 track_free:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2f13a275448..4d19da016c12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10524,7 +10524,8 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
-static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
+static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
@@ -10576,7 +10577,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		}
 	}
 
-	if (kvm_page_track_create_memslot(slot, npages))
+	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
 	return 0;
@@ -10616,7 +10617,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(memslot,
+		return kvm_alloc_memslot_metadata(kvm, memslot,
 						  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
