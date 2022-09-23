Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D40E5E78C7
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiIWKw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiIWKwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:52:34 -0400
Received: from out0-151.mail.aliyun.com (out0-151.mail.aliyun.com [140.205.0.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB3EE6DC1;
        Fri, 23 Sep 2022 03:52:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047190;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.PMZ5Kv7_1663930349;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PMZ5Kv7_1663930349)
          by smtp.aliyun-inc.com;
          Fri, 23 Sep 2022 18:52:29 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] KVM: x86/mmu: Cleanup range-based flushing for given page
Date:   Fri, 23 Sep 2022 18:52:22 +0800
Message-Id: <b9c1c10fc815f175025cbe0612cb1711571259e2.1663929851.git.houwenlong.hwl@antgroup.com>
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

Use the new kvm_flush_remote_tlbs_gfn() helper to cleanup
the call sites of range-based flushing for given page,
which makes the code clear.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c     | 5 ++---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b64aa8379ba6..3980c49a1992 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -817,7 +817,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
 	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_gfn(kvm, gfn, PG_LEVEL_4K);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2842,8 +2842,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
-				KVM_PAGES_PER_HPAGE(level));
+		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2d223c5167f8..567691440ab0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -673,8 +673,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	if (ret)
 		return ret;
 
-	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
-					   KVM_PAGES_PER_HPAGE(iter->level));
+	kvm_flush_remote_tlbs_gfn(kvm, iter->gfn, iter->level);
 
 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
-- 
2.31.1

