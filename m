Return-Path: <kvm+bounces-14445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAFC8A29C9
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66A20283234
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5645178C92;
	Fri, 12 Apr 2024 08:43:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D0B78C80;
	Fri, 12 Apr 2024 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911430; cv=none; b=XvnPUAZ3dMXTG0uoh/A+FYP4e0YfHnjJ3t/q36hIL/FFpAyXympqnox3QUcu7Zel1bsn+9y4iRHkXtqtGukkVRdJl3oo2s7C0psps2vyaA4SxcKVqxcTUb09bnwcbg7NK27YJZMe3rxa8IGvNsf8pjCS7aGDAoGeH/FVtnnqaPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911430; c=relaxed/simple;
	bh=LLnf3FCrpeO9ZW7AtRz1cbbKEGnuUeyuou6VvunSoW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IPyQDys81eFnWlR09QJyeGsNNtWJNUpgFRevPaUKW6fYU+j862Gqq3UkKej/sWYGbLX5w/BlALWE1o+27k9gJ0EHB9tZv3fHgsOaWKVzs9A1lqENFq77IvmgsO0ESyiNliWTIXWi2KTDX0Umcit352lbK0kG+5iEz7WP78U0Lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B3B4339;
	Fri, 12 Apr 2024 01:44:18 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B375F3F6C4;
	Fri, 12 Apr 2024 01:43:46 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 13/43] arm64: RME: RTT handling
Date: Fri, 12 Apr 2024 09:42:39 +0100
Message-Id: <20240412084309.1733783-14-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM owns the stage 2 page tables for a realm, and KVM must request
that the RMM creates/destroys entries as necessary. The physical pages
to store the page tables are delegated to the realm as required, and can
be undelegated when no longer used.

Creating new RTTs is the easy part, tearing down is a little more
tricky. The result of realm_rtt_destroy() can be used to effectively
walk the tree and destroy the entries (undelegating pages that were
given to the realm).

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |  19 ++++
 arch/arm64/kvm/mmu.c             |   6 +-
 arch/arm64/kvm/rme.c             | 171 +++++++++++++++++++++++++++++++
 3 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index fba85e9ce3ae..4ab5cb5e91b3 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -76,5 +76,24 @@ u32 kvm_realm_ipa_limit(void);
 int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int kvm_init_realm_vm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
+void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
+
+#define RME_RTT_BLOCK_LEVEL	2
+#define RME_RTT_MAX_LEVEL	3
+
+#define RME_PAGE_SHIFT		12
+#define RME_PAGE_SIZE		BIT(RME_PAGE_SHIFT)
+/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
+#define RME_RTT_LEVEL_SHIFT(l)	\
+	((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)
+#define RME_L2_BLOCK_SIZE	BIT(RME_RTT_LEVEL_SHIFT(2))
+
+static inline unsigned long rme_rtt_level_mapsize(int level)
+{
+	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
+		return RME_PAGE_SIZE;
+
+	return (1UL << RME_RTT_LEVEL_SHIFT(level));
+}
 
 #endif
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index af4564f3add5..46f0c4e80ace 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1012,17 +1012,17 @@ void stage2_unmap_vm(struct kvm *kvm)
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	struct kvm_pgtable *pgt = NULL;
+	struct kvm_pgtable *pgt;
 
 	write_lock(&kvm->mmu_lock);
+	pgt = mmu->pgt;
 	if (kvm_is_realm(kvm) &&
 	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
 	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
-		/* TODO: teardown rtts */
 		write_unlock(&kvm->mmu_lock);
+		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
 		return;
 	}
-	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 9652ec6ab2fd..09b59bcad8b6 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -47,6 +47,53 @@ static int rmi_check_version(void)
 	return 0;
 }
 
+static phys_addr_t __alloc_delegated_page(struct realm *realm,
+					  struct kvm_mmu_memory_cache *mc,
+					  gfp_t flags)
+{
+	phys_addr_t phys = PHYS_ADDR_MAX;
+	void *virt;
+
+	if (realm->spare_page != PHYS_ADDR_MAX) {
+		swap(realm->spare_page, phys);
+		goto out;
+	}
+
+	if (mc)
+		virt = kvm_mmu_memory_cache_alloc(mc);
+	else
+		virt = (void *)__get_free_page(flags);
+
+	if (!virt)
+		goto out;
+
+	phys = virt_to_phys(virt);
+
+	if (rmi_granule_delegate(phys)) {
+		free_page((unsigned long)virt);
+
+		phys = PHYS_ADDR_MAX;
+	}
+
+out:
+	return phys;
+}
+
+static void free_delegated_page(struct realm *realm, phys_addr_t phys)
+{
+	if (realm->spare_page == PHYS_ADDR_MAX) {
+		realm->spare_page = phys;
+		return;
+	}
+
+	if (WARN_ON(rmi_granule_undelegate(phys))) {
+		/* Undelegate failed: leak the page */
+		return;
+	}
+
+	free_page((unsigned long)phys_to_virt(phys));
+}
+
 u32 kvm_realm_ipa_limit(void)
 {
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
@@ -124,6 +171,130 @@ static int realm_create_rd(struct kvm *kvm)
 	return r;
 }
 
+static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
+			     int level, phys_addr_t *rtt_granule,
+			     unsigned long *next_addr)
+{
+	unsigned long out_rtt;
+	unsigned long out_top;
+	int ret;
+
+	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
+			      &out_rtt, &out_top);
+
+	if (rtt_granule)
+		*rtt_granule = out_rtt;
+	if (next_addr)
+		*next_addr = out_top;
+
+	return ret;
+}
+
+static int realm_tear_down_rtt_level(struct realm *realm, int level,
+				     unsigned long start, unsigned long end)
+{
+	ssize_t map_size;
+	unsigned long addr, next_addr;
+
+	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
+		return -EINVAL;
+
+	map_size = rme_rtt_level_mapsize(level - 1);
+
+	for (addr = start; addr < end; addr = next_addr) {
+		phys_addr_t rtt_granule;
+		int ret;
+		unsigned long align_addr = ALIGN(addr, map_size);
+
+		next_addr = ALIGN(addr + 1, map_size);
+
+		if (next_addr <= end && align_addr == addr) {
+			ret = realm_rtt_destroy(realm, addr, level,
+						&rtt_granule, &next_addr);
+		} else {
+			/* Recurse a level deeper */
+			ret = realm_tear_down_rtt_level(realm,
+							level + 1,
+							addr,
+							min(next_addr, end));
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
+				free_page((unsigned long)phys_to_virt(rtt_granule));
+			break;
+		case RMI_ERROR_RTT:
+			if (next_addr > addr) {
+				/* unassigned or destroyed */
+				break;
+			}
+			if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
+				return -EBUSY;
+			if (WARN_ON(level == RME_RTT_MAX_LEVEL)) {
+				// Live entry
+				return -EBUSY;
+			}
+			/* Recurse a level deeper */
+			next_addr = ALIGN(addr + 1, map_size);
+			ret = realm_tear_down_rtt_level(realm,
+							level + 1,
+							addr,
+							next_addr);
+			if (ret)
+				return ret;
+			/* Try again at this level */
+			next_addr = addr;
+			break;
+		default:
+			WARN_ON(1);
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
+static int realm_tear_down_rtt_range(struct realm *realm,
+				     unsigned long start, unsigned long end)
+{
+	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
+					 start, end);
+}
+
+static void ensure_spare_page(struct realm *realm)
+{
+	phys_addr_t tmp_rtt;
+
+	/*
+	 * Make sure we have a spare delegated page for tearing down the
+	 * block mappings. We do this by allocating then freeing a page.
+	 * We must use Atomic allocations as we are called with kvm->mmu_lock
+	 * held.
+	 */
+	tmp_rtt = __alloc_delegated_page(realm, NULL, GFP_ATOMIC);
+
+	/*
+	 * If the allocation failed, continue as we may not have a block level
+	 * mapping so it may not be fatal, otherwise free it to assign it
+	 * to the spare page.
+	 */
+	if (tmp_rtt != PHYS_ADDR_MAX)
+		free_delegated_page(realm, tmp_rtt);
+}
+
+void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	ensure_spare_page(realm);
+
+	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
+}
+
 /* Protects access to rme_vmid_bitmap */
 static DEFINE_SPINLOCK(rme_vmid_lock);
 static unsigned long *rme_vmid_bitmap;
-- 
2.34.1


