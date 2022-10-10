Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262415F9E9C
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiJJMTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiJJMT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:19:28 -0400
Received: from out0-132.mail.aliyun.com (out0-132.mail.aliyun.com [140.205.0.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336AC275D4;
        Mon, 10 Oct 2022 05:19:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047194;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PYG70rb_1665404363;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PYG70rb_1665404363)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 20:19:23 +0800
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
Subject: [PATCH v4 5/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
Date:   Mon, 10 Oct 2022 20:19:16 +0800
Message-Id: <5f297c566f7d7ff2ea6da3c66d050f69ce1b8ede.1665214747.git.houwenlong.hwl@antgroup.com>
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

The spte pointing to the children SP is dropped, so the whole gfn range
covered by the children SP should be flushed. Although, Hyper-V may
treat a 1-page flush the same if the address points to a huge page, it
still would be better to use the correct size of huge page.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1564cb2d4297..6757c921f412 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2366,7 +2366,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			return;
 
 		drop_parent_pte(child, sptep);
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
+		kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
 	}
 }
 
-- 
2.31.1

