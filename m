Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66EC5F9E9A
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiJJMTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiJJMT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:19:26 -0400
Received: from out0-148.mail.aliyun.com (out0-148.mail.aliyun.com [140.205.0.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CC34D4D2;
        Mon, 10 Oct 2022 05:19:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047190;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PYFqMCc_1665404359;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PYFqMCc_1665404359)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 20:19:20 +0800
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
Subject: [PATCH v4 2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
Date:   Mon, 10 Oct 2022 20:19:13 +0800
Message-Id: <0ce24d7078fa5f1f8d64b0c59826c50f32f8065e.1665214747.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
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

When the spte of hupe page is dropped in kvm_set_pte_rmapp(), the whole
gfn range covered by the spte should be flushed. However,
rmap_walk_init_level() doesn't align down the gfn for new level like tdp
iterator does, then the gfn used in kvm_set_pte_rmapp() is not the base
gfn of huge page. And the size of gfn range is wrong too for huge page.
Use the base gfn of huge page and the size of huge page for flushing
tlbs for huge page. Also introduce a helper function to flush the given
page (huge or not) of guest memory, which would help prevent future
buggy use of kvm_flush_remote_tlbs_with_address() in such case.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c          |  4 +++-
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7de3579d5a27..4874c603ed1c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1430,7 +1430,9 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	}
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		gfn_t base = gfn_round_for_level(gfn, level);
+
+		kvm_flush_remote_tlbs_gfn(kvm, base, level);
 		return false;
 	}
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 17488d70f7da..249bfcd502b4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -168,8 +168,18 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
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

