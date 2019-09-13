Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22D8B1750
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfIMCqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:58611 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfIMCqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159531"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 10/11] KVM: x86/mmu: Explicitly track only a single invalid mmu generation
Date:   Thu, 12 Sep 2019 19:46:11 -0700
Message-Id: <20190913024612.28392-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Toggle mmu_valid_gen between '0' and '1' instead of blindly incrementing
the generation.  Because slots_lock is held for the entire duration of
zapping obsolete pages, it's impossible for there to be multiple invalid
generations associated with shadow pages at any given time.

Toggling between the two generations (valid vs. invalid) allows changing
mmu_valid_gen from an unsigned long to a u8, which reduces the size of
struct kvm_mmu_page from 160 to 152 bytes on 64-bit KVM, i.e. reduces
KVM's memory footprint by 8 bytes per shadow page.

Set sp->mmu_valid_gen before it is added to active_mmu_pages.
Functionally this has no effect as kvm_mmu_alloc_page() has a single
caller that sets sp->mmu_valid_gen soon thereafter, but visually it is
jarring to see a shadow page being added to the list without its
mmu_valid_gen first being set.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu.c              | 14 ++++++++++++--
 arch/x86/kvm/mmutrace.h         | 16 ++++++++--------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e4fa75351fd..8912b04d4ae1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -320,6 +320,7 @@ struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
 	bool unsync;
+	u8 mmu_valid_gen;
 
 	/*
 	 * The following two entries are used to key the shadow page in the
@@ -334,7 +335,6 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
-	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
@@ -856,7 +856,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
-	unsigned long mmu_valid_gen;
+	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bce19918ca5a..a7b14750cde9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2101,6 +2101,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	 * depends on valid pages being added to the head of the list.  See
 	 * comments in kvm_zap_obsolete_pages().
 	 */
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
@@ -2537,7 +2538,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
@@ -5737,9 +5737,19 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  */
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
+	lockdep_assert_held(&kvm->slots_lock);
+
 	spin_lock(&kvm->mmu_lock);
 	trace_kvm_mmu_zap_all_fast(kvm);
-	kvm->arch.mmu_valid_gen++;
+
+	/*
+	 * Toggle mmu_valid_gen between '0' and '1'.  Because slots_lock is
+	 * held for the entire duration of zapping obsolete pages, it's
+	 * impossible for there to be multiple invalid generations associated
+	 * with *valid* shadow pages at any given time, i.e. there is exactly
+	 * one valid generation and (at most) one invalid generation.
+	 */
+	kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 1a063ba76281..7ca8831c7d1a 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -8,11 +8,11 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvmmmu
 
-#define KVM_MMU_PAGE_FIELDS			\
-	__field(unsigned long, mmu_valid_gen)	\
-	__field(__u64, gfn)			\
-	__field(__u32, role)			\
-	__field(__u32, root_count)		\
+#define KVM_MMU_PAGE_FIELDS		\
+	__field(__u8, mmu_valid_gen)	\
+	__field(__u64, gfn)		\
+	__field(__u32, role)		\
+	__field(__u32, root_count)	\
 	__field(bool, unsync)
 
 #define KVM_MMU_PAGE_ASSIGN(sp)				\
@@ -31,7 +31,7 @@
 								        \
 	role.word = __entry->role;					\
 									\
-	trace_seq_printf(p, "sp gen %lx gfn %llx l%u %u-byte q%u%s %s%s"\
+	trace_seq_printf(p, "sp gen %u gfn %llx l%u %u-byte q%u%s %s%s"	\
 			 " %snxe %sad root %u %s%c",			\
 			 __entry->mmu_valid_gen,			\
 			 __entry->gfn, role.level,			\
@@ -288,7 +288,7 @@ TRACE_EVENT(
 	TP_ARGS(kvm),
 
 	TP_STRUCT__entry(
-		__field(unsigned long, mmu_valid_gen)
+		__field(__u8, mmu_valid_gen)
 		__field(unsigned int, mmu_used_pages)
 	),
 
@@ -297,7 +297,7 @@ TRACE_EVENT(
 		__entry->mmu_used_pages = kvm->arch.n_used_mmu_pages;
 	),
 
-	TP_printk("kvm-mmu-valid-gen %lx used_pages %x",
+	TP_printk("kvm-mmu-valid-gen %u used_pages %x",
 		  __entry->mmu_valid_gen, __entry->mmu_used_pages
 	)
 );
-- 
2.22.0

