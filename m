Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB985030DF
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiDOWCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356185AbiDOWBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93858FD3B
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 7-20020a250c07000000b0064137917a4eso7655633ybm.12
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+g21tjl52haZEGL9PeLa8ZsXfugpwy0IPvVVK6CWGsg=;
        b=ZLsICKC3SmkNR+5tKzOjUbnQi/MrOWshrvj8ba9gD9ErKmF7bM9Ls3/73nj7AN223f
         2SqgDq0mAv2Q+0NseF2Q6yJ9vAST2pHisfGt1aJ03ZR+yeXY4WCtFCLFnkoU0PMNx7bv
         GtmK0jCaxnoFBzIF482k+LXDT3QNYJ5NswQc3tSxLDzrxHjhk7kCcz/EML91XtB0TNBK
         Xm9rTMKrDR8cvHZo0rs4YCcBNImFSd/Zp6dYdWGcwa6fTHERGWIJByQqZFmWaHjjCdY8
         3CDcSDTVe1yeF5TkHlWZQLhTDhaOUlu2ycQ37ChtdjS0d0bGJEyFflrGc5HuZQxrxKqT
         /V6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+g21tjl52haZEGL9PeLa8ZsXfugpwy0IPvVVK6CWGsg=;
        b=69tysHXBjhEpOyrAVy/kDTuidGmBpoel8itLXH8pS8AIptVMFqA4GO+hGiS+TcgVuF
         /DiupU7MLXGwTigb4FjQECqyFQ+r0ndbTm1lBrH6pFbK3+VugI4umisdwxg06u4+K8EH
         8m2kWKsHZY/yef8TpHgoyxHVS8Jkyb87i3Jut4xzstBqFdY6CY2DXrVyYyZUSbRyCULU
         aNvnmUDn38MQCLoNAy8pCdmgTDqI+28YUvQNFz3J4GixPDM3j1+tYqtwJdHS6W45F92u
         JW7mDEu1A7wZhTCvJhhFvWrZWey6gFfIUCJk7FZ0ubJjkqoG8kzLlnsmM3kuorr39Qty
         u2HA==
X-Gm-Message-State: AOAM532BbTEkGC25M/LKkNRKF9hOWscJQn3Aby6u8JncD4tKotXrTzEr
        Bfo5cVH5QFnLKlRadyCVcqZmDtPHb6w=
X-Google-Smtp-Source: ABdhPJxd3FM6U0CPN7En0pTvibRCFHGaVeXWp61fOLSmlPBx3PvTF9e7RZlcLR5fnOduP4TGiTN80GlSguU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0d:e743:0:b0:2eb:3106:9b32 with SMTP id
 q64-20020a0de743000000b002eb31069b32mr940693ywe.512.1650059962733; Fri, 15
 Apr 2022 14:59:22 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:59 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-16-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 15/17] KVM: arm64: Allow parallel calls to kvm_pgtable_stage2_map()
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

The map walker is now appraised of how to walk the tables in parallel
with another table walker. Take a parameter indicating whether or not a
walk is done in parallel so as to relax the atomicity/locking
requirements on ptes.

Defer actually using parallel walks to a later change.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 4 +++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/kvm/hyp/pgtable.c          | 4 ++--
 arch/arm64/kvm/mmu.c                  | 6 +++---
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52e55e00f0ca..9830eea19de4 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -328,6 +328,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * @prot:	Permissions and attributes for the mapping.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
+ * @shared:	true if multiple software walkers could be traversing the tables
+ *		in parallel
  *
  * The offset of @addr within a page is ignored, @size is rounded-up to
  * the next page boundary and @phys is rounded-down to the previous page
@@ -349,7 +351,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc);
+			   void *mc, bool shared);
 
 /**
  * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 42a5f35cd819..53b172036c2a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -251,7 +251,7 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
 	return kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
-				      prot, &host_s2_pool);
+				      prot, &host_s2_pool, false);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a9a48edba63b..20ff198ebef7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1119,7 +1119,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc)
+			   void *mc, bool shared)
 {
 	int ret;
 	struct stage2_map_data map_data = {
@@ -1144,7 +1144,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, shared);
 	dsb(ishst);
 	return ret;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6ecf37009c21..63cf18cdb978 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -832,7 +832,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 		write_lock(&kvm->mmu_lock);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
-					     &cache);
+					     &cache, false);
 		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
@@ -1326,7 +1326,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     mmu_caches);
+					     mmu_caches, true);
 	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
@@ -1526,7 +1526,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
 			       PAGE_SIZE, __pfn_to_phys(pfn),
-			       KVM_PGTABLE_PROT_R, NULL);
+			       KVM_PGTABLE_PROT_R, NULL, false);
 
 	return false;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

