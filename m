Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBD35030C7
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349834AbiDOWBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355435AbiDOWBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:45 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2A738D83
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:15 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id m11-20020a056e020deb00b002cbde7e7dcfso4186132ilj.2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JyIVyQg6UGD612cbxcwyNwFE+I6JblVf7Z7F7spTUWo=;
        b=LMqmd6P7Ue7Y9IYx3CzgSFOTxT7tT239JnYQyS2EtWQ3fN4qbQ0VflsOtSv+zaS5bk
         +bvfK/SmAwgiQklAVqKG84UBqOcNnfZBYDShTxLbmp4TCyU+thTgl31lI4p91fxWMOn/
         dd2QO+9mQAqSvAt90OOkgKcjFxVpl7VjcraP/FuiseUcuGPj+F+x30DmaWdzLXajn575
         2MLUXCslyvGHkc1BlYeAgCkKGGLpODBbWpAJnCW0QHKTJCA67zs859BL+KVaEhsWfoh0
         j+lM1SBjp+89lbo+kBMwvVR9gQck0ZWmyt7cTKZrx3+vLXytC9/xjlO4AIrc/U0c/XjQ
         nkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JyIVyQg6UGD612cbxcwyNwFE+I6JblVf7Z7F7spTUWo=;
        b=CDESC0YGl6rgLDKQpiQtyD1OfIOdlk1nvvj5XcyfYCaIoc9KrmklFBwDrsrT1K7MAI
         Z+GWSPsvBxGfcChzto3tHVr/k7S8+RpvuevipjeW49JV3zWFei3L7uO/kCRf7QQB5kZJ
         Xp+gk1FoMmPuIIV6MM6XjDg2Wczw7dm9Qv6/jgDkaUacV9lnj7KGeyIQolFQURv8AVUD
         hKUqEcn5WPlYZDOByigdlJF5CxjTH8fQRXgCznhrq1ewPQKdbwNNAva13jLZcpD1yUcz
         7fDoEUUVRw/rqch78nT/v29CFThAfnnYrIKlR/t/ZnFzufKm5CXUH5npEyTbKpudCV56
         rBpg==
X-Gm-Message-State: AOAM5338tvMCKv8cIouuCCdoY/0vCIcyRlYiYURa6NijNDXSB7fJPvjK
        KQJ+cPNELE+eRf6InNmD43zex2lWTdI=
X-Google-Smtp-Source: ABdhPJwW/MzIxEmQ87y7GaINMs+YHxfeosd37KaEM3yVPDMpYVf1oEXa8efMhhfJEE88ApB9wQ629pQLxlQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:27cc:b0:5f0:876e:126b with SMTP id
 l12-20020a05660227cc00b005f0876e126bmr328774ios.129.1650059954862; Fri, 15
 Apr 2022 14:59:14 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:51 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-8-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 07/17] KVM: arm64: Enlighten perm relax path about
 parallel walks
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To date the permission relax path of the stage-2 fault handler hasn't
had to worry about the paging structures changing under its nose, as map
operations acquire the write lock. That's about to change, which means a
permission relaxation walker could traverse in parallel with a map
operation.

If at any point during traversal the permission relax walker finds a
locked pte, bail immediately. Either the instruction will succeed or the
vCPU will fault once more and (hopefully) walk the tables successfully.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 059ebb921125..ff6f14755d0c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1168,6 +1168,11 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct stage2_attr_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
+	if (stage2_pte_is_locked(pte)) {
+		WARN_ON(!shared);
+		return -EAGAIN;
+	}
+
 	if (!kvm_pte_valid(pte))
 		return 0;
 
@@ -1190,7 +1195,9 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
 			mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
 						  kvm_granule_size(level));
-		WRITE_ONCE(*ptep, pte);
+
+		if (!kvm_try_set_pte(ptep, data->pte, pte, shared))
+			return -EAGAIN;
 	}
 
 	return 0;
@@ -1199,7 +1206,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
 				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
-				    u32 *level)
+				    u32 *level, bool shared)
 {
 	int ret;
 	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
@@ -1214,7 +1221,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 		.flags		= KVM_PGTABLE_WALK_LEAF,
 	};
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, shared);
 	if (ret)
 		return ret;
 
@@ -1230,14 +1237,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL);
+					NULL, NULL, false);
 }
 
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL);
+				 &pte, NULL, false);
 	dsb(ishst);
 	return pte;
 }
@@ -1246,7 +1253,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
-				 &pte, NULL);
+				 &pte, NULL, false);
 	/*
 	 * "But where's the TLBI?!", you scream.
 	 * "Over in the core code", I sigh.
@@ -1259,7 +1266,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, false);
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
@@ -1282,7 +1289,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, true);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
 	return ret;
-- 
2.36.0.rc0.470.gd361397f0d-goog

