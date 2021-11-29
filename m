Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A06D4624A0
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhK2WXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhK2WVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:21:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08958C08EAE7
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D44DCE140B
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBA2C53FD1;
        Mon, 29 Nov 2021 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216132;
        bh=Df8PadvHjOAqr8B6CfNfQ511OzaDacc78f6/QUTpGHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJRnyB5Na7g06iVpC+drouPpHCnoaOOzZ1lPAz3dVShLvCfHCf/T/UKNSf29W+uUQ
         pAnu4jkBS9Ztz2S8AqKW2mRRK2y1OjSSZKzSX3jejDB8dEUQqBCIGnw5hNs7aQZusq
         gb5mQJKMFH4Z6dLVm19ADFucCoMvOd0vRWt0Qzgv20yLL1qrbRvjOh8gdHPtJEh1n8
         ZSNw1o3pLroa1AFJh1minHo8ztiS+fxX5iCJ5KQkxQA4H0H8GLpYryEeq+Uvj5/i15
         pt3zDpWm7VbO9D1Nl7hebiPz6uURpKS1Borw1qP0MExomZiWdlZIQZEARqc3LxWBR5
         4vST3E01r6nVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqo-008gvR-DG; Mon, 29 Nov 2021 20:02:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 04/69] KVM: arm64: Rework kvm_pgtable initialisation
Date:   Mon, 29 Nov 2021 20:00:45 +0000
Message-Id: <20211129200150.351436-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ganapatrao reported that the kvm_pgtable->mmu pointer is more or
less hardcoded to the main S2 mmu structure, while the nested
code needs it to point to other instances (as we have one instance
per nested context).

Rework the initialisation of the kvm_pgtable structure so that
this assumtion doesn't hold true anymore. This requires some
minor changes to the order in which things are initialised
(the mmu->arch pointer being the critical one).

Reported-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 9 ++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++--
 arch/arm64/kvm/hyp/pgtable.c          | 6 +++---
 arch/arm64/kvm/mmu.c                  | 4 ++--
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 027783829584..8b808e70c2b2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -270,8 +270,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 /**
  * __kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
- * @arch:	Arch-specific KVM structure representing the guest virtual
- *		machine.
+ * @mmu:	S2 MMU context for this S2 translation
  * @mm_ops:	Memory management callbacks.
  * @flags:	Stage-2 configuration flags.
  * @force_pte_cb: Function that returns true if page level mappings must
@@ -279,13 +278,13 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
  *
  * Return: 0 on success, negative error code on failure.
  */
-int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb);
 
-#define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
-	__kvm_pgtable_stage2_init(pgt, arch, mm_ops, 0, NULL)
+#define kvm_pgtable_stage2_init(pgt, mmu, mm_ops) \
+	__kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL)
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c1a90dd022b8..7d7b7037dc68 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -103,19 +103,19 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 
 	prepare_host_vtcr();
 	hyp_spin_lock_init(&host_kvm.lock);
+	mmu->arch = &host_kvm.arch;
 
 	ret = prepare_s2_pool(pgt_pool_base);
 	if (ret)
 		return ret;
 
-	ret = __kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
+	ret = __kvm_pgtable_stage2_init(&host_kvm.pgt, mmu,
 					&host_kvm.mm_ops, KVM_HOST_S2_FLAGS,
 					host_stage2_force_pte_cb);
 	if (ret)
 		return ret;
 
 	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
-	mmu->arch = &host_kvm.arch;
 	mmu->pgt = &host_kvm.pgt;
 	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
 	WRITE_ONCE(mmu->vmid.vmid, 0);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..8cdbc43fa651 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1116,13 +1116,13 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 }
 
 
-int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb)
 {
 	size_t pgd_sz;
-	u64 vtcr = arch->vtcr;
+	u64 vtcr = mmu->arch->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
@@ -1135,7 +1135,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
-	pgt->mmu		= &arch->mmu;
+	pgt->mmu		= mmu;
 	pgt->flags		= flags;
 	pgt->force_pte_cb	= force_pte_cb;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 326cdfec74a1..9eec548fccd1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -516,7 +516,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	if (!pgt)
 		return -ENOMEM;
 
-	err = kvm_pgtable_stage2_init(pgt, &kvm->arch, &kvm_s2_mm_ops);
+	mmu->arch = &kvm->arch;
+	err = kvm_pgtable_stage2_init(pgt, mmu, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
@@ -529,7 +530,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
-	mmu->arch = &kvm->arch;
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
-- 
2.30.2

