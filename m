Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7F11978BE
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgC3KT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43780 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729313AbgC3KTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CC29E3074B6A;
        Mon, 30 Mar 2020 13:12:53 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AAB85305B7A1;
        Mon, 30 Mar 2020 13:12:53 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 33/81] KVM: x86: page track: add track_create_slot() callback
Date:   Mon, 30 Mar 2020 13:12:20 +0300
Message-Id: <20200330101308.21702-34-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is used to add page access notifications as soon as a slot appears.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_page_track.h | 13 ++++++++++++-
 arch/x86/kvm/mmu/page_track.c         | 16 +++++++++++++++-
 arch/x86/kvm/x86.c                    |  2 +-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index e91f5a16e741..dc528c6f2eb0 100644
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
@@ -53,7 +64,7 @@ void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
 				 struct kvm_memory_slot *dont);
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index dc891d6a2553..f36e74430ad2 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -32,9 +32,12 @@ void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
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
@@ -45,6 +48,17 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 			goto track_free;
 	}
 
+	head = &kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return 0;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
+		if (n->track_create_slot)
+			n->track_create_slot(kvm, slot, npages, n);
+	srcu_read_unlock(&head->track_srcu, idx);
+
 	return 0;
 
 track_free:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d35ea19417ca..17e8a9d4e138 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9946,7 +9946,7 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		}
 	}
 
-	if (kvm_page_track_create_memslot(slot, npages))
+	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
 	return 0;
