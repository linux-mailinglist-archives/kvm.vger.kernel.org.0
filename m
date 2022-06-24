Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57327558F24
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 05:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiFXDhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 23:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiFXDhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 23:37:16 -0400
Received: from out0-130.mail.aliyun.com (out0-130.mail.aliyun.com [140.205.0.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA61653A73;
        Thu, 23 Jun 2022 20:37:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047201;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---.OBgNiz3_1656041826;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OBgNiz3_1656041826)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 11:37:07 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
Date:   Fri, 24 Jun 2022 11:37:00 +0800
Message-Id: <1dc86beeb58c54ac027d9c67d7e1ad9252b4b2a4.1656039275.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a spte is dropped, the start gfn of tlb flushing should
be the gfn of spte not the base gfn of SP which contains the
spte.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 8 +++++---
 arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37bfc88ea212..577b85860891 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1145,7 +1145,8 @@ static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 	drop_spte(kvm, sptep);
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+		kvm_flush_remote_tlbs_with_address(kvm,
+			kvm_mmu_page_get_gfn(sp, sptep - sp->spt),
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
@@ -1596,7 +1597,7 @@ static void __rmap_add(struct kvm *kvm,
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 		kvm_flush_remote_tlbs_with_address(
-				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm, gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
@@ -6397,7 +6398,8 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 			pte_list_remove(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
-				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+				kvm_flush_remote_tlbs_with_address(kvm,
+					kvm_mmu_page_get_gfn(sp, sptep - sp->spt),
 					KVM_PAGES_PER_HPAGE(sp->role.level));
 			else
 				need_tlb_flush = 1;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 2448fa8d8438..fa78ee0caffd 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -938,7 +938,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
 				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
-					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+					kvm_mmu_page_get_gfn(sp, sptep - sp->spt),
+					KVM_PAGES_PER_HPAGE(sp->role.level));
 
 			if (!rmap_can_add(vcpu))
 				break;
-- 
2.31.1

