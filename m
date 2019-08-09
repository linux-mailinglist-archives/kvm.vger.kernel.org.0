Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F9287FB1
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437297AbfHIQUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:44 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53310 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407421AbfHIQT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:57 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8A7F3305D3DD;
        Fri,  9 Aug 2019 19:00:59 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4461E305B7A3;
        Fri,  9 Aug 2019 19:00:59 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: [RFC PATCH v6 21/92] kvm: page track: add track_create_slot() callback
Date:   Fri,  9 Aug 2019 18:59:36 +0300
Message-Id: <20190809160047.8319-22-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is used to add page access notifications as soon as a slot appears.

CC: Xiao Guangrong <guangrong.xiao@gmail.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_page_track.h |  5 ++++-
 arch/x86/kvm/page_track.c             | 18 ++++++++++++++++--
 arch/x86/kvm/x86.c                    |  2 +-
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 172f9749dbb2..18a94d180485 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -34,6 +34,9 @@ struct kvm_page_track_notifier_node {
 	 */
 	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			    int bytes, struct kvm_page_track_notifier_node *node);
+	void (*track_create_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  unsigned long npages,
+				  struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when memory slot is being moved or removed
 	 * users can drop write-protection for the pages in that memory slot
@@ -51,7 +54,7 @@ void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
 				 struct kvm_memory_slot *dont);
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/page_track.c b/arch/x86/kvm/page_track.c
index 3052a59a3065..db5b906876bb 100644
--- a/arch/x86/kvm/page_track.c
+++ b/arch/x86/kvm/page_track.c
@@ -34,10 +34,13 @@ void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
 		}
 }
 
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  unsigned long npages)
 {
-	int  i;
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+	int i;
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
 		slot->arch.gfn_track[i] =
@@ -47,6 +50,17 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
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
index 30cf0d162aa8..f66db9473ea3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9350,7 +9350,7 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		}
 	}
 
-	if (kvm_page_track_create_memslot(slot, npages))
+	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
 	return 0;
