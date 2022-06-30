Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF00B561D44
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbiF3ONv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiF3ONT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EB32CC8E
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F216B6219B
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1899CC341CB;
        Thu, 30 Jun 2022 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597496;
        bh=czGrMKVmcAgfqMuBOqGAxm/Bl1F3qGCKOPa4Z2x4jgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEhtAorXncZaZBdv8J+ZmsKppz0vF4m6YFziJGxh6rfOC+rHG2q0EjK7RF30UFvBj
         B3yzmL/mGT9+qpGunIsAJneAFDY3rMhPZQJXPfu4fGvmT0bgtylmuWGmeQOEjt6zmc
         Vx+QyIRwVbCHGCWHuBsnhUDIsA2LtdQX8Lm31m0jKOg7riKYQf8MsnbeEd/oQRfrTh
         QMnlmfimZB3N0Nx3POZyfvCqqD1FOBj6vEdUUCMB4PkjQtTeKSp9WRNzTGXV/GEy7x
         d/0TRxrpONVxPToUcJtzINi0CzeJA5EpL3fpseck+WvsnadRyUishnhnw2zf1o28un
         zP0GXkhB6bwLg==
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
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 05/24] KVM: arm64: Make hyp stage-1 refcnt correct on the whole range
Date:   Thu, 30 Jun 2022 14:57:28 +0100
Message-Id: <20220630135747.26983-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

We currently fixup the hypervisor stage-1 refcount only for specific
portions of the hyp stage-1 VA space. In order to allow unmapping pages
outside of these ranges, let's fixup the refcount for the entire hyp VA
space.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 62 +++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 579eb4f73476..8f2726d7e201 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -185,12 +185,11 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
-static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
-					 kvm_pte_t *ptep,
-					 enum kvm_pgtable_walk_flags flag,
-					 void * const arg)
+static int fix_host_ownership_walker(u64 addr, u64 end, u32 level,
+				     kvm_pte_t *ptep,
+				     enum kvm_pgtable_walk_flags flag,
+				     void * const arg)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
 	kvm_pte_t pte = *ptep;
@@ -199,15 +198,6 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	/*
-	 * Fix-up the refcount for the page-table pages as the early allocator
-	 * was unable to access the hyp_vmemmap and so the buddy allocator has
-	 * initialised the refcount to '1'.
-	 */
-	mm_ops->get_page(ptep);
-	if (flag != KVM_PGTABLE_WALK_LEAF)
-		return 0;
-
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -236,12 +226,30 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	return host_stage2_idmap_locked(phys, PAGE_SIZE, prot);
 }
 
-static int finalize_host_mappings(void)
+static int fix_hyp_pgtable_refcnt_walker(u64 addr, u64 end, u32 level,
+					 kvm_pte_t *ptep,
+					 enum kvm_pgtable_walk_flags flag,
+					 void * const arg)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	kvm_pte_t pte = *ptep;
+
+	/*
+	 * Fix-up the refcount for the page-table pages as the early allocator
+	 * was unable to access the hyp_vmemmap and so the buddy allocator has
+	 * initialised the refcount to '1'.
+	 */
+	if (kvm_pte_valid(pte))
+		mm_ops->get_page(ptep);
+
+	return 0;
+}
+
+static int fix_host_ownership(void)
 {
 	struct kvm_pgtable_walker walker = {
-		.cb	= finalize_host_mappings_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
-		.arg	= pkvm_pgtable.mm_ops,
+		.cb	= fix_host_ownership_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 	int i, ret;
 
@@ -257,6 +265,18 @@ static int finalize_host_mappings(void)
 	return 0;
 }
 
+static int fix_hyp_pgtable_refcnt(void)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= fix_hyp_pgtable_refcnt_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pkvm_pgtable.mm_ops,
+	};
+
+	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits),
+				&walker);
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
@@ -286,7 +306,11 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-	ret = finalize_host_mappings();
+	ret = fix_host_ownership();
+	if (ret)
+		goto out;
+
+	ret = fix_hyp_pgtable_refcnt();
 	if (ret)
 		goto out;
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

