Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1B852D457
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiESNnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiESNnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DB03EF11
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E20DAB82477
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F58AC36AE7;
        Thu, 19 May 2022 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967812;
        bh=cD3YOWLvpjjONoZobEcrvEksstSpx5sYWks15ko02iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjKxxp/2Zj5zWKQ+JdaVyYCqSxMyqjVvgIshZjNllODWAAkcQd6NR9s3vw1HVGqbU
         Wmfm7WFXdgYcJsu/zTE1XveGSZqVc8Uqf6RotIBWakrcCn3UQwsKv3y0+ea0vA5t2T
         o9gP5X1dha4nMuDUItKvxFZOBf6rIfjXaVDw3rm1UcTYoq29iPL1FsoMYbRvy6BWlH
         r/JT+bFDyGeCuvV2AfSJrHO9mJihFCwVnG4oM3D1aBSPIWPV6qTdJa896s8nQscJyC
         31kvgvXPFWdPwmEB00lWmAa81Ui6WAfAQXdITBWyaTZZeEDuELlXl4glJUfZTKghVp
         MmheluJ5L695A==
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
Subject: [PATCH 17/89] KVM: arm64: Make hyp stage-1 refcnt correct on the whole range
Date:   Thu, 19 May 2022 14:40:52 +0100
Message-Id: <20220519134204.5379-18-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 62 +++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e9e146e50254..b306da2b5dae 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -167,12 +167,11 @@ static void hpool_put_page(void *addr)
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
@@ -181,15 +180,6 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
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
 
@@ -218,12 +208,30 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
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
 
@@ -239,6 +247,18 @@ static int finalize_host_mappings(void)
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
@@ -268,7 +288,11 @@ void __noreturn __pkvm_init_finalise(void)
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
2.36.1.124.g0e6072fb45-goog

