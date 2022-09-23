Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A425E78BF
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiIWKwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiIWKw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:52:29 -0400
Received: from out0-141.mail.aliyun.com (out0-141.mail.aliyun.com [140.205.0.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA458FD4E;
        Fri, 23 Sep 2022 03:52:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PMZ5Ku-_1663930343;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PMZ5Ku-_1663930343)
          by smtp.aliyun-inc.com;
          Fri, 23 Sep 2022 18:52:24 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
Date:   Fri, 23 Sep 2022 18:52:17 +0800
Message-Id: <4c4c0943f431e760a51ec0d45e3979c38820749f.1663929851.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1663929851.git.houwenlong.hwl@antgroup.com>
References: <cover.1663929851.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The spte pointing to the children SP is dropped, so the
whole gfn range covered by the children SP should be flushed.
Although, Hyper-V may treat a 1-page flush the same if the
address points to a huge page, it still would be better
to use the correct size of huge page. Also introduce
a helper function to do range-based flushing when a direct
SP is dropped, which would help prevent future buggy use
of kvm_flush_remote_tlbs_with_address() in such case.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c          |  9 ++++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..ae9f84b0fc64 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -260,6 +260,13 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
+/* Flush all memory mapped by the given direct SP. */
+static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	WARN_ON_ONCE(!sp->role.direct);
+	kvm_flush_remote_tlbs_gfn(kvm, sp->gfn, sp->role.level + 1);
+}
+
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 			   unsigned int access)
 {
@@ -2341,7 +2348,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			return;
 
 		drop_parent_pte(child, sptep);
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
+		kvm_flush_remote_tlbs_direct_sp(vcpu->kvm, child);
 	}
 }
 
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
-- 
2.31.1

