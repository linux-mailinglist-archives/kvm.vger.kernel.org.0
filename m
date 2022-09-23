Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A5B5E78CA
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiIWKwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiIWKwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:52:32 -0400
Received: from out0-130.mail.aliyun.com (out0-130.mail.aliyun.com [140.205.0.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E27E6DD6;
        Fri, 23 Sep 2022 03:52:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047190;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PMYh3Zc_1663930347;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PMYh3Zc_1663930347)
          by smtp.aliyun-inc.com;
          Fri, 23 Sep 2022 18:52:27 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ben Gardon <bgardon@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
Date:   Fri, 23 Sep 2022 18:52:20 +0800
Message-Id: <7d25a2922da46350aa5981773896b844fa89402d.1663929851.git.houwenlong.hwl@antgroup.com>
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

Since the children SP is zapped, the gfn range of tlb flushing should be
the range covered by children SP not parent SP. Replace sp->gfn which is
the base gfn of parent SP with iter->gfn and use the correct size of
gfn range for children SP to reduce tlb flushing range.

Fixes: bb95dfb9e2df ("KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debca..2d223c5167f8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1071,8 +1071,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-						   KVM_PAGES_PER_HPAGE(iter->level + 1));
+		kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.31.1

