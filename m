Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63C759F63E
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 11:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiHXJ3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 05:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbiHXJ3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 05:29:34 -0400
Received: from out0-158.mail.aliyun.com (out0-158.mail.aliyun.com [140.205.0.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D284EC5;
        Wed, 24 Aug 2022 02:29:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047211;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.P-if8DK_1661333368;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P-if8DK_1661333368)
          by smtp.aliyun-inc.com;
          Wed, 24 Aug 2022 17:29:29 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] KVM: x86/mmu: Introduce helper function to do range-based flushing for given page
Date:   Wed, 24 Aug 2022 17:29:22 +0800
Message-Id: <e88c9599a20d5440c097feb2a7b6912a2c0519f3.1661331396.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flushing tlb for one page (huge or not) is the main use case, so
introduce a helper function for this common operation to make
the code clear.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c          | 16 ++++++----------
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++----
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e0b9432b9491..92ca76e11d96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -268,16 +268,14 @@ static void kvm_flush_remote_tlbs_sptep(struct kvm *kvm, u64 *sptep)
 	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
 	gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(sptep));

-	kvm_flush_remote_tlbs_with_address(kvm, gfn,
-					   KVM_PAGES_PER_HPAGE(sp->role.level));
+	kvm_flush_remote_tlbs_gfn(kvm, gfn, sp->role.level);
 }

 /* Flush all memory mapped by the given direct SP. */
 static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON_ONCE(!sp->role.direct);
-	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-					   KVM_PAGES_PER_HPAGE(sp->role.level + 1));
+	kvm_flush_remote_tlbs_gfn(kvm, sp->gfn, sp->role.level + 1);
 }

 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
@@ -1449,8 +1447,8 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	}

 	if (need_flush && kvm_available_flush_tlb_with_range()) {
-		kvm_flush_remote_tlbs_with_address(kvm, gfn & -KVM_PAGES_PER_HPAGE(level),
-						   KVM_PAGES_PER_HPAGE(level));
+		kvm_flush_remote_tlbs_gfn(kvm, gfn & -KVM_PAGES_PER_HPAGE(level),
+					  level);
 		return false;
 	}

@@ -1618,8 +1616,7 @@ static void __rmap_add(struct kvm *kvm,

 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_zap_all_rmap_sptes(kvm, rmap_head);
-		kvm_flush_remote_tlbs_with_address(
-				kvm, gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+		kvm_flush_remote_tlbs_gfn(kvm, gfn, sp->role.level);
 	}
 }

@@ -2844,8 +2841,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}

 	if (flush)
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
-				KVM_PAGES_PER_HPAGE(level));
+		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);

 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..6651c154f2e0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -163,8 +163,18 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
+
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
+
+/* Flush the given page (huge or not) of guest memory. */
+static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
+{
+	u64 pages = KVM_PAGES_PER_HPAGE(level);
+
+	kvm_flush_remote_tlbs_with_address(kvm, gfn, pages);
+}
+
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);

 extern int nx_huge_pages;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 08b7932122ec..567691440ab0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -673,8 +673,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	if (ret)
 		return ret;

-	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
-					   KVM_PAGES_PER_HPAGE(iter->level));
+	kvm_flush_remote_tlbs_gfn(kvm, iter->gfn, iter->level);

 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
@@ -1071,8 +1070,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter->gfn,
-						   KVM_PAGES_PER_HPAGE(iter->level));
+		kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);

 	/*
 	 * If the page fault was caused by a write but the page is write
--
2.31.1

