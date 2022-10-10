Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D725F9EA6
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiJJMVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbiJJMUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:20:24 -0400
Received: from out0-139.mail.aliyun.com (out0-139.mail.aliyun.com [140.205.0.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FB114092;
        Mon, 10 Oct 2022 05:20:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.PYG70rl_1665404364;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PYG70rl_1665404364)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 20:19:24 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/6] KVM: x86/mmu: Cleanup range-based flushing for given page
Date:   Mon, 10 Oct 2022 20:19:17 +0800
Message-Id: <593ee1a876ece0e819191c0b23f56b940d6686db.1665214747.git.houwenlong.hwl@antgroup.com>
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

Use the new kvm_flush_remote_tlbs_gfn() helper to cleanup the call sites
of range-based flushing for given page, which makes the code clear.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c     | 5 ++---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6757c921f412..f8feb2f41293 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -810,7 +810,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
 	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_gfn(kvm, gfn, PG_LEVEL_4K);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2849,8 +2849,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
-				KVM_PAGES_PER_HPAGE(level));
+		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 88e67dc5ca3f..724202fc7fde 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -684,8 +684,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	if (ret)
 		return ret;
 
-	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
-					   KVM_PAGES_PER_HPAGE(iter->level));
+	kvm_flush_remote_tlbs_gfn(kvm, iter->gfn, iter->level);
 
 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
-- 
2.31.1

