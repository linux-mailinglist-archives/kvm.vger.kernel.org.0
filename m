Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6B5E78C5
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiIWKw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiIWKwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:52:33 -0400
Received: from out0-158.mail.aliyun.com (out0-158.mail.aliyun.com [140.205.0.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E860F2F396;
        Fri, 23 Sep 2022 03:52:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PMYh3Zu_1663930348;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PMYh3Zu_1663930348)
          by smtp.aliyun-inc.com;
          Fri, 23 Sep 2022 18:52:28 +0800
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
Subject: [PATCH v3 5/6] KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
Date:   Fri, 23 Sep 2022 18:52:21 +0800
Message-Id: <b48f7b7d375f8903cc606450ce49e252b90945db.1663929851.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1663929851.git.houwenlong.hwl@antgroup.com>
References: <cover.1663929851.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a spte is dropped, the start gfn of tlb flushing should
be the gfn of spte not the base gfn of SP which contains the
spte. Also introduce a helper function to do range-based
flushing when a spte is dropped, which would help prevent
future buggy use of kvm_flush_remote_tlbs_with_address() in
such case.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 20 ++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec5b3b9880de..b64aa8379ba6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -260,6 +260,17 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
+static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
+
+/* Flush the range of guest memory mapped by the given SPTE. */
+static void kvm_flush_remote_tlbs_sptep(struct kvm *kvm, u64 *sptep)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(sptep));
+
+	kvm_flush_remote_tlbs_gfn(kvm, gfn, sp->role.level);
+}
+
 /* Flush all memory mapped by the given direct SP. */
 static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -1155,8 +1166,7 @@ static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 	drop_spte(kvm, sptep);
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
+		kvm_flush_remote_tlbs_sptep(kvm, sptep);
 }
 
 /*
@@ -1607,8 +1617,7 @@ static void __rmap_add(struct kvm *kvm,
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_zap_all_rmap_sptes(kvm, rmap_head);
-		kvm_flush_remote_tlbs_with_address(
-				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+		kvm_flush_remote_tlbs_gfn(kvm, gfn, sp->role.level);
 	}
 }
 
@@ -6403,8 +6412,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
-				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-					KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm_flush_remote_tlbs_sptep(kvm, sptep);
 			else
 				need_tlb_flush = 1;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4e9f992474cb..14268bfb0c8e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -937,8 +937,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 
 			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
-				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
-					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
 
 			if (!rmap_can_add(vcpu))
 				break;
-- 
2.31.1

