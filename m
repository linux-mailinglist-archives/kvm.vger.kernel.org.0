Return-Path: <kvm+bounces-66121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3302FCC72B1
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BD8B313A149
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A57342C92;
	Wed, 17 Dec 2025 10:12:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CE333A9EB;
	Wed, 17 Dec 2025 10:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966358; cv=none; b=N9zCA0DM72pt7VAyRhCGtsioihGkBNDoRLoinihY+6JyZVXB71GqneFtdxXZTYgND4fQz7axzSNBnzpoRSCecX7D7at6QhoBWeTHVWi3DVIKXonGqlGcJHQIKdeHnaWAXy+5u9QT5SoFXNITD1pEZRWQrkVhECecDUbFSzEh30g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966358; c=relaxed/simple;
	bh=qytgtZ3uXlc+FLMUK1/sD6T4+4VjaosLlRJz77QIL1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BShfr9/eeQkvC2nL5QrSiWSprUXMAieyiV7ea6QdxXcBBxgrda6JFjvg6PTVZ8KXDJT7v184nERESS4W4fWLISetGx+30xrc/+0uMrkaUhnL1WDyIBpHJ3NAT7HdlsPnG2jI3jkLCiimZNYZdl0IAB7J8/CddH0RjHjE79X01mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=fail smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B4E1684;
	Wed, 17 Dec 2025 02:12:28 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F8783F73B;
	Wed, 17 Dec 2025 02:12:31 -0800 (PST)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 10/46] arm64: RMI: RTT tear down
Date: Wed, 17 Dec 2025 10:10:47 +0000
Message-ID: <20251217101125.91098-11-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
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
Changes since v11:
 * Moved some code from earlier in the series to this one so that it's
   added when it's first used.
Changes since v10:
 * RME->RMI rename.
 * Some code to handle freeing stage 2 PGD moved into this patch where
   it belongs.
Changes since v9:
 * Add a comment clarifying that root level RTTs are not destroyed until
   after the RD is destroyed.
Changes since v8:
 * Introduce free_rtt() wrapper which calls free_delegated_granule()
   followed by kvm_account_pgtable_pages(). This makes it clear where an
   RTT is being freed rather than just a delegated granule.
Changes since v6:
 * Move rme_rtt_level_mapsize() and supporting defines from kvm_rme.h
   into rme.c as they are only used in that file.
Changes since v5:
 * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
   a property of the RMM specification not the RME architecture.
Changes since v2:
 * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
   later patch when they are actually used.
 * Some simplifications now rmi_xxx() functions allow NULL as an output
   parameter.
 * Improved comments and code layout.
---
 arch/arm64/include/asm/kvm_rmi.h |   7 ++
 arch/arm64/kvm/mmu.c             |  15 ++-
 arch/arm64/kvm/rmi.c             | 151 +++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 7f06aa5b0550..cb7350f8a01a 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -70,5 +70,12 @@ u32 kvm_realm_ipa_limit(void);
 
 int kvm_init_realm_vm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
+void kvm_realm_destroy_rtts(struct kvm *kvm);
+
+static inline bool kvm_realm_is_private_address(struct realm *realm,
+						unsigned long addr)
+{
+	return !(addr & BIT(realm->ia_bits - 1));
+}
 
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ed86a10f08e0..68e6cefe1135 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1098,10 +1098,23 @@ void stage2_unmap_vm(struct kvm *kvm)
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	struct kvm_pgtable *pgt = NULL;
+	struct kvm_pgtable *pgt;
 
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
+	if (kvm_is_realm(kvm) &&
+	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
+	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
+		write_unlock(&kvm->mmu_lock);
+		kvm_realm_destroy_rtts(kvm);
+
+		/*
+		 * The PGD pages can be reclaimed only after the realm (RD) is
+		 * destroyed. We call this again from kvm_destroy_realm() after
+		 * the RD is destroyed.
+		 */
+		return;
+	}
 	if (pgt) {
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index c2b13fecfd11..e57e8b7eafa9 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -17,6 +17,22 @@ static unsigned long rmm_feat_reg0;
 #define RMM_PAGE_SHIFT		12
 #define RMM_PAGE_SIZE		BIT(RMM_PAGE_SHIFT)
 
+#define RMM_RTT_BLOCK_LEVEL	2
+#define RMM_RTT_MAX_LEVEL	3
+
+/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
+#define RMM_RTT_LEVEL_SHIFT(l)	\
+	((RMM_PAGE_SHIFT - 3) * (4 - (l)) + 3)
+#define RMM_L2_BLOCK_SIZE	BIT(RMM_RTT_LEVEL_SHIFT(2))
+
+static inline unsigned long rmi_rtt_level_mapsize(int level)
+{
+	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
+		return RMM_PAGE_SIZE;
+
+	return (1UL << RMM_RTT_LEVEL_SHIFT(level));
+}
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
@@ -61,6 +77,15 @@ u32 kvm_realm_ipa_limit(void)
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+static int get_start_level(struct realm *realm)
+{
+	/*
+	 * Open coded version of 4 - stage2_pgtable_levels(ia_bits) but using
+	 * the RMM's page size rather than the host's.
+	 */
+	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
+}
+
 static int free_delegated_granule(phys_addr_t phys)
 {
 	if (WARN_ON(rmi_granule_undelegate(phys))) {
@@ -73,6 +98,131 @@ static int free_delegated_granule(phys_addr_t phys)
 	return 0;
 }
 
+static void free_rtt(phys_addr_t phys)
+{
+	if (free_delegated_granule(phys))
+		return;
+
+	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
+}
+
+static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
+			     int level, phys_addr_t *rtt_granule,
+			     unsigned long *next_addr)
+{
+	unsigned long out_rtt;
+	int ret;
+
+	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
+			      &out_rtt, next_addr);
+
+	*rtt_granule = out_rtt;
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
+	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
+		return -EINVAL;
+
+	map_size = rmi_rtt_level_mapsize(level - 1);
+
+	for (addr = start; addr < end; addr = next_addr) {
+		phys_addr_t rtt_granule;
+		int ret;
+		unsigned long align_addr = ALIGN(addr, map_size);
+
+		next_addr = ALIGN(addr + 1, map_size);
+
+		if (next_addr > end || align_addr != addr) {
+			/*
+			 * The target range is smaller than what this level
+			 * covers, recurse deeper.
+			 */
+			ret = realm_tear_down_rtt_level(realm,
+							level + 1,
+							addr,
+							min(next_addr, end));
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		ret = realm_rtt_destroy(realm, addr, level,
+					&rtt_granule, &next_addr);
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			free_rtt(rtt_granule);
+			break;
+		case RMI_ERROR_RTT:
+			if (next_addr > addr) {
+				/* Missing RTT, skip */
+				break;
+			}
+			/*
+			 * We tear down the RTT range for the full IPA
+			 * space, after everything is unmapped. Also we
+			 * descend down only if we cannot tear down a
+			 * top level RTT. Thus RMM must be able to walk
+			 * to the requested level. e.g., a block mapping
+			 * exists at L1 or L2.
+			 */
+			if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
+				return -EBUSY;
+			if (WARN_ON(level == RMM_RTT_MAX_LEVEL))
+				return -EBUSY;
+
+			/*
+			 * The table has active entries in it, recurse deeper
+			 * and tear down the RTTs.
+			 */
+			next_addr = ALIGN(addr + 1, map_size);
+			ret = realm_tear_down_rtt_level(realm,
+							level + 1,
+							addr,
+							next_addr);
+			if (ret)
+				return ret;
+			/*
+			 * Now that the child RTTs are destroyed,
+			 * retry at this level.
+			 */
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
+	/*
+	 * Root level RTTs can only be destroyed after the RD is destroyed. So
+	 * tear down everything below the root level
+	 */
+	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
+					 start, end);
+}
+
+void kvm_realm_destroy_rtts(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned int ia_bits = realm->ia_bits;
+
+	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
+}
+
 void kvm_destroy_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
@@ -83,6 +233,7 @@ void kvm_destroy_realm(struct kvm *kvm)
 	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
 			       BIT(realm->ia_bits - 1), true);
 	write_unlock(&kvm->mmu_lock);
+	kvm_realm_destroy_rtts(kvm);
 
 	if (realm->params) {
 		free_page((unsigned long)realm->params);
-- 
2.43.0


