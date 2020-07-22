Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96509229C8E
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgGVQBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:44 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37956 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730308AbgGVQBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0EF0A305D64F;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id ED4A3305FFB5;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 28/34] KVM: x86: page_track: add support for suppress #VE bit
Date:   Wed, 22 Jul 2020 19:01:15 +0300
Message-Id: <20200722160121.9601-29-alazar@bitdefender.com>
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

Setting SPTEs from rmaps is not enough because rmaps contain only
present SPTEs. If there is no mapping created for the GFN, SPTEs must
be configured when they are created. Use the page tracking mechanism in
order to configure the SVE bit when a PF occurs. This is similar to how
access rights are configured using the page tracking mechanism.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_page_track.h |  1 +
 arch/x86/kvm/mmu.h                    |  2 ++
 arch/x86/kvm/mmu/mmu.c                | 38 +++++++++++++++++++++++++++
 arch/x86/kvm/mmu/page_track.c         |  7 +++++
 4 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 96d2ab7da4a7..108161f63a44 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -7,6 +7,7 @@ enum kvm_page_track_mode {
 	KVM_PAGE_TRACK_PREWRITE,
 	KVM_PAGE_TRACK_WRITE,
 	KVM_PAGE_TRACK_PREEXEC,
+	KVM_PAGE_TRACK_SVE,
 	KVM_PAGE_TRACK_MAX,
 };
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 02fa0d30407f..160e66ae9852 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -234,5 +234,7 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
+bool kvm_mmu_set_ept_page_sve(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, u16 index, bool suppress);
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 28ab4a1ba25a..7254f5679828 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1890,6 +1890,41 @@ bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
 	return exec_protected;
 }
 
+static bool spte_suppress_ve(u64 *sptep, bool suppress)
+{
+	u64 spte = *sptep;
+
+	if (suppress)
+		spte |= VMX_EPT_SUPPRESS_VE_BIT;
+	else
+		spte &= ~VMX_EPT_SUPPRESS_VE_BIT;
+
+	return mmu_spte_update(sptep, spte);
+}
+
+bool kvm_mmu_set_ept_page_sve(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, u16 index, bool suppress)
+{
+	struct kvm_rmap_head *rmap_head;
+	struct rmap_iterator iter;
+	struct kvm_mmu_page *sp;
+	bool flush = false;
+	u64 *sptep;
+	int i;
+
+	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; i++) {
+		rmap_head = __gfn_to_rmap(gfn, i, slot);
+		for_each_rmap_spte(rmap_head, &iter, sptep) {
+			sp = page_header(__pa(sptep));
+			if (index == 0 || (index > 0 && index == sp->view))
+				flush |= spte_suppress_ve(sptep, suppress);
+		}
+	}
+
+	return flush;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_page_sve);
+
 static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
@@ -3171,6 +3206,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
+	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_SVE))
+		spte &= ~VMX_EPT_SUPPRESS_VE_BIT;
+
 	if (pte_access & ACC_WRITE_MASK) {
 		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index bf26b21cfeb8..153c5285361f 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -125,6 +125,9 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	} else if (mode == KVM_PAGE_TRACK_PREEXEC) {
 		if (kvm_mmu_slot_gfn_exec_protect(kvm, slot, gfn, view))
 			kvm_flush_remote_tlbs(kvm);
+	} else if (mode == KVM_PAGE_TRACK_SVE) {
+		if (kvm_mmu_set_ept_page_sve(kvm, slot, gfn, view, false))
+			kvm_flush_remote_tlbs(kvm);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
@@ -151,6 +154,10 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 
 	update_gfn_track(slot, gfn, mode, -1, view);
 
+	if (mode == KVM_PAGE_TRACK_SVE)
+		if (kvm_mmu_set_ept_page_sve(kvm, slot, gfn, view, true))
+			kvm_flush_remote_tlbs(kvm);
+
 	/*
 	 * allow large page mapping for the tracked page
 	 * after the tracker is gone.
