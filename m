Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD759F635
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 11:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiHXJ3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 05:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbiHXJ3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 05:29:30 -0400
Received: from out0-139.mail.aliyun.com (out0-139.mail.aliyun.com [140.205.0.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1884D84EC1;
        Wed, 24 Aug 2022 02:29:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047198;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.P-jvWt-_1661333365;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P-jvWt-_1661333365)
          by smtp.aliyun-inc.com;
          Wed, 24 Aug 2022 17:29:25 +0800
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
Subject: [PATCH v2 2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
Date:   Wed, 24 Aug 2022 17:29:19 +0800
Message-Id: <4b6f39b9617ee9be9fcddeaa0afd754f21cf2e24.1661331396.git.houwenlong.hwl@antgroup.com>
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

When the spte of hupe page is dropped in kvm_set_pte_rmapp(),
the whole gfn range covered by the spte should be flushed.
However, rmap_walk_init_level() doesn't align down the gfn
for new level like tdp iterator does, then the gfn used in
kvm_set_pte_rmapp() is not the base gfn of huge page. And
the size of gfn range is wrong too for huge page. Use the
base gfn of huge page and the size of huge page for
flushing tlbs for huge page.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a3578abd8bbc..3bcff56df109 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1438,7 +1438,8 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	}
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_with_address(kvm, gfn & -KVM_PAGES_PER_HPAGE(level),
+						   KVM_PAGES_PER_HPAGE(level));
 		return false;
 	}
 
-- 
2.31.1

