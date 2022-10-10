Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3697D5F9E9E
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiJJMTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiJJMTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:19:40 -0400
Received: from out0-139.mail.aliyun.com (out0-139.mail.aliyun.com [140.205.0.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015644C005;
        Mon, 10 Oct 2022 05:19:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PYDhJqt_1665404360;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PYDhJqt_1665404360)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 20:19:21 +0800
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
Subject: [PATCH v4 3/6] KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
Date:   Mon, 10 Oct 2022 20:19:14 +0800
Message-Id: <528ab9c784a486e9ce05f61462ad9260796a8732.1665214747.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
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

Since the children SP is zapped, the gfn range of tlb flushing should be
the range covered by children SP not parent SP. Replace sp->gfn which is
the base gfn of parent SP with iter->gfn and use the correct size of gfn
range for children SP to reduce tlb flushing range.

Fixes: bb95dfb9e2df ("KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 672f0432d777..88e67dc5ca3f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1082,8 +1082,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
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

