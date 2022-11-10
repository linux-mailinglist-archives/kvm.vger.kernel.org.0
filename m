Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75A624A17
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKJTDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKJTD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:03:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9449BAC
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6E0B61E15
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE41C4347C;
        Thu, 10 Nov 2022 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107003;
        bh=9TBP204s3AuL2lcP8EwsI57qh0ZtpeTXBnevcBmQatM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5/vy05a4bwynKbAygAfvIAwO1r4fufs3f3xfQ8KRJmQJu7anNY++RUItnZyga4/C
         sKpxRAHvptSb01LpZOqILf28A5lTCor6yo5MVDKyVLsU/FeAYoG7CbbFSDhGu/qVio
         nfF+SYZ6NGjUpUVqaogI6hikaxpGlcjmuzDtk0A6htN7PFqw6ZJ178DTiobz4F4s+B
         bonEDC7x3XmbpiwXblbuX/R8dCOY/myLSVEYGW7MtxOL7kpa+x19vph7QJg7i15gTr
         yY8+7jgoBjsdLSfI/Vp4f9tYn3AZg4PXuRgxawm7k0s+tgVydzT2de5HmYbfqHPKuG
         7uzzJC8G77wEw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 04/26] KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
Date:   Thu, 10 Nov 2022 19:02:37 +0000
Message-Id: <20221110190259.26861-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

In order to allow unmapping arbitrary memory pages from the hypervisor
stage-1 page-table, fix-up the initial refcount for pages that have been
mapped before the 'vmemmap' array was up and running so that it
accurately accounts for all existing hypervisor mappings.

This is achieved by traversing the entire hypervisor stage-1 page-table
during initialisation of EL2 and updating the corresponding
'struct hyp_page' for each valid mapping.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
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
2.38.1.431.g37b22c650d-goog

