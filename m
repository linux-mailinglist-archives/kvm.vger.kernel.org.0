Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C907952D4C8
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbiESNq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238928AbiESNo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:44:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5E6D4128
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3F08CE2440
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FBC34117;
        Thu, 19 May 2022 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967860;
        bh=9Zu+1PM964G8VB/qecrYRRnyKHnt3EWZgmbLdhsUNTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CV0ZGuRQXsTvx7y4SinA0e6Ox7OFe71U5wvIU+soixC4yNptm76juK7kEUF1h9SxX
         oYpeant1QNqop7yI6rv39FS2nZqWWzDrARyBU65hR9ArrGfPkeSIh8NpwE97ooMo+a
         z0IIs2FNE7b2inyibH/xINq5w+o/hiaC6wnOd/Kp/lgVcGC4kGvxLkZfHnH4VyTNwb
         eXLX4TlMeo9wsJtqFHIjr4uZ4AXEiEqU5Xaf2t4BAKkKw4bXDEZFw8t23CAmRmbMIY
         FLRtGPgTpZhgPyd9e7j2mfy8bbyTtEkUZybVZlZt8c2lRCTp4qPkRmx5SwTueyrIV2
         l8vZJZC129frg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 29/89] KVM: arm64: Check for PTE validity when checking for executable/cacheable
Date:   Thu, 19 May 2022 14:41:04 +0100
Message-Id: <20220519134204.5379-30-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Don't blindly assume that the PTE is valid when checking whether
it describes an executable or cacheable mapping.

This makes sure that we don't issue CMOs for invalid mappings.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1d300313009d..a6676fd14cf9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -700,12 +700,12 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
 	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
+	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
 }
 
 static bool stage2_pte_executable(kvm_pte_t pte)
 {
-	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
 static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
@@ -750,8 +750,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	/* Perform CMOs before installation of the guest stage-2 PTE */
 	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
-
+					       granule);
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
@@ -1148,7 +1147,7 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
+	if (!stage2_pte_cacheable(pgt, pte))
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
-- 
2.36.1.124.g0e6072fb45-goog

