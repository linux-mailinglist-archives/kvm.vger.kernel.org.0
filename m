Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E15F229CB9
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgGVQCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:22 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38024 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729066AbgGVQBi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:38 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3A0B5305D7F7;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 325E43011F3C;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 11/34] KVM: x86: mmu: allow zapping shadow pages for specific EPT views
Date:   Wed, 22 Jul 2020 19:00:58 +0300
Message-Id: <20200722160121.9601-12-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

Add a view mask for kvm_mmu_zap_all() in order to allow zapping
shadow pages for specific EPT views. This is required when an
introspected VM is unhooked. In that case, shadow pages that
belong to non-default views will be zapped.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 4 +++-
 arch/x86/kvm/x86.c              | 4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2fbb26b54cf1..519b8210b8ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1392,7 +1392,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				   struct kvm_memory_slot *slot,
 				   gfn_t gfn_offset, unsigned long mask);
-void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_zap_all(struct kvm *kvm, u16 view_mask);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cca12982b795..22c83192bba1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6166,7 +6166,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+void kvm_mmu_zap_all(struct kvm *kvm, u16 view_mask)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -6175,6 +6175,8 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
+		if (!test_bit(sp->view, (unsigned long *)&view_mask))
+			continue;
 		if (sp->role.invalid && sp->root_count)
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e2c56a37bdb..78aacac839bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10406,7 +10406,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_mmu_zap_all(kvm);
+	u16 ept_views_to_keep = 0;
+
+	kvm_mmu_zap_all(kvm, ~ept_views_to_keep);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
