Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2731558F1F
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 05:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiFXDhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 23:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiFXDhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 23:37:12 -0400
Received: from out0-139.mail.aliyun.com (out0-139.mail.aliyun.com [140.205.0.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BD153A71;
        Thu, 23 Jun 2022 20:37:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047194;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---.OBfZx2H_1656041824;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OBfZx2H_1656041824)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 11:37:04 +0800
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
Subject: [PATCH 2/5] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
Date:   Fri, 24 Jun 2022 11:36:58 +0800
Message-Id: <a92b4b56116f0f71ffceab2b4ff3c03f47fd468f.1656039275.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
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

When the spte of hupe page is dropped in kvm_set_pte_rmapp(),
the whole gfn range covered by the spte should be flushed.
However, rmap_walk_init_level() doesn't align down the gfn
for new level like tdp iterator does, then the gfn used in
kvm_set_pte_rmapp() is not the base gfn of huge page. And
the size of gfn range is wrong too for huge page. Since
the base gfn of huge page is more meaningful during the
rmap walking, so align down the gfn for new level and use
the correct size of huge page for tlb flushing in
kvm_set_pte_rmapp().

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b8a1f5b46b9d..37bfc88ea212 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1427,7 +1427,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	}
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, KVM_PAGES_PER_HPAGE(level));
 		return false;
 	}
 
@@ -1455,7 +1455,7 @@ static void
 rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
 {
 	iterator->level = level;
-	iterator->gfn = iterator->start_gfn;
+	iterator->gfn = iterator->start_gfn & -KVM_PAGES_PER_HPAGE(level);
 	iterator->rmap = gfn_to_rmap(iterator->gfn, level, iterator->slot);
 	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
 }
-- 
2.31.1

