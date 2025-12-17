Return-Path: <kvm+bounces-66128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 82376CC8BCA
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 17:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4779307316F
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681D334D4F0;
	Wed, 17 Dec 2025 10:13:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D32134D3AF;
	Wed, 17 Dec 2025 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966392; cv=none; b=pRaYV4bSqdoT+ICKWfqIOhNwzhPEWV3pKNQYg8cInCjT4wp9ZtKG+8bOkoY1B2/170KgojeezqmvqZRMEjslfqKvO2rXYyN661JtohDco+Hk6owVOyFqv9wwmaizYojKXKbvAA5wXMCFQ59q/hTU9oW4Rbt2Bcmb/JDV8p45mWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966392; c=relaxed/simple;
	bh=KHGlz5OkGXSl9iT9RDZZa3MbaNRJsik50yE/shqxc4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zta5Ix0HBIoN/r/H+gfpgYxP64IJcr+8fdSuolYwOThfmaedIPv//bUPeufA83UdWaJHFrX7MCJmF8vgFPe+QJtIa7u7YzaTCksdkfljV3B/SbZCJf1Vx5pMdVLtbOMvpouwWa9LgpU+uhAn9/sEeyHipycGs3OWFb5XXIoY5ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 636E6168F;
	Wed, 17 Dec 2025 02:13:02 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32AC13F73B;
	Wed, 17 Dec 2025 02:13:05 -0800 (PST)
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
Subject: [PATCH v12 17/46] arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
Date: Wed, 17 Dec 2025 10:10:54 +0000
Message-ID: <20251217101125.91098-18-steven.price@arm.com>
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

The guest can request that a region of it's protected address space is
switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
RSI_IPA_STATE_SET. This causes a guest exit with the
RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
protected region to unprotected (or back), exiting to the VMM to make
the necessary changes to the guest_memfd and memslot mappings. On the
next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
calls.

The VMM may wish to reject the RIPAS change requested by the guest. For
now it can only do with by no longer scheduling the VCPU as we don't
currently have a usecase for returning that rejection to the guest, but
by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
open for adding a new ioctl in the future for this purpose.

There's a FIXME for the case where the RMM rejects a RIPAS change when
(a portion of) the region. The current RMM API makes this difficult to
handle efficiently, but it should be fixed in a later version of the
spec.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v11:
 * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
   adding functions before they are used.
 * Drop the CAP for setting RIPAS and adapt to changes from previous
   patches.
Changes since v10:
 * Add comment explaining the assignment of rec->run->exit.ripas_base in
   kvm_complete_ripas_change().
Changes since v8:
 * Make use of ripas_change() from a previous patch to implement
   realm_set_ipa_state().
 * Update exit.ripas_base after a RIPAS change so that, if instead of
   entering the guest we exit to user space, we don't attempt to repeat
   the RIPAS change (triggering an error from the RMM).
Changes since v7:
 * Rework the loop in realm_set_ipa_state() to make it clear when the
   'next' output value of rmi_rtt_set_ripas() is used.
New patch for v7: The code was previously split awkwardly between two
other patches.
---
 arch/arm64/include/asm/kvm_rmi.h |   6 +
 arch/arm64/kvm/mmu.c             |   8 +-
 arch/arm64/kvm/rmi.c             | 459 +++++++++++++++++++++++++++++++
 3 files changed, 470 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index faf0af563210..8a862fc1a99d 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -99,6 +99,12 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
 int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
 int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 
+void kvm_realm_unmap_range(struct kvm *kvm,
+			   unsigned long ipa,
+			   unsigned long size,
+			   bool unmap_private,
+			   bool may_block);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 68e6cefe1135..cac3d7b73b3d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
  * @may_block: Whether or not we are permitted to block
+ * @only_shared: If true then protected mappings should not be unmapped
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
  * be called while holding mmu_lock (unless for freeing the stage2 pgd before
@@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * with things behind our backs.
  */
 static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
-				 bool may_block)
+				 bool may_block, bool only_shared)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
@@ -340,7 +341,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			    u64 size, bool may_block)
 {
-	__unmap_stage2_range(mmu, start, size, may_block);
+	__unmap_stage2_range(mmu, start, size, may_block, false);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -2230,7 +2231,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+			     range->may_block,
+			     !(range->attr_filter & KVM_FILTER_PRIVATE));
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 215eb4f4fc47..fe15b400091c 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -91,6 +91,59 @@ static int get_start_level(struct realm *realm)
 	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
 }
 
+static int find_map_level(struct realm *realm,
+			  unsigned long start,
+			  unsigned long end)
+{
+	int level = RMM_RTT_MAX_LEVEL;
+
+	while (level > get_start_level(realm)) {
+		unsigned long map_size = rmi_rtt_level_mapsize(level - 1);
+
+		if (!IS_ALIGNED(start, map_size) ||
+		    (start + map_size) > end)
+			break;
+
+		level--;
+	}
+
+	return level;
+}
+
+static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
+{
+	phys_addr_t phys;
+	void *virt;
+
+	if (mc) {
+		virt = kvm_mmu_memory_cache_alloc(mc);
+	} else {
+		virt = (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
+					       __GFP_ACCOUNT);
+	}
+
+	if (!virt)
+		return PHYS_ADDR_MAX;
+
+	phys = virt_to_phys(virt);
+	if (rmi_granule_delegate(phys)) {
+		free_page((unsigned long)virt);
+		return PHYS_ADDR_MAX;
+	}
+
+	return phys;
+}
+
+static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
+{
+	phys_addr_t phys = alloc_delegated_granule(mc);
+
+	if (phys != PHYS_ADDR_MAX)
+		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
+
+	return phys;
+}
+
 static int free_delegated_granule(phys_addr_t phys)
 {
 	if (WARN_ON(rmi_granule_undelegate(phys))) {
@@ -111,6 +164,32 @@ static void free_rtt(phys_addr_t phys)
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
 }
 
+static int realm_rtt_create(struct realm *realm,
+			    unsigned long addr,
+			    int level,
+			    phys_addr_t phys)
+{
+	addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
+	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
+}
+
+static int realm_rtt_fold(struct realm *realm,
+			  unsigned long addr,
+			  int level,
+			  phys_addr_t *rtt_granule)
+{
+	unsigned long out_rtt;
+	int ret;
+
+	addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
+	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
+
+	if (rtt_granule)
+		*rtt_granule = out_rtt;
+
+	return ret;
+}
+
 static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
 			     int level, phys_addr_t *rtt_granule,
 			     unsigned long *next_addr)
@@ -126,6 +205,38 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
 	return ret;
 }
 
+static int realm_create_rtt_levels(struct realm *realm,
+				   unsigned long ipa,
+				   int level,
+				   int max_level,
+				   struct kvm_mmu_memory_cache *mc)
+{
+	while (level++ < max_level) {
+		phys_addr_t rtt = alloc_rtt(mc);
+		int ret;
+
+		if (rtt == PHYS_ADDR_MAX)
+			return -ENOMEM;
+
+		ret = realm_rtt_create(realm, ipa, level, rtt);
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
+		    RMI_RETURN_INDEX(ret) == level - 1) {
+			/* The RTT already exists, continue */
+			free_rtt(rtt);
+			continue;
+		}
+
+		if (ret) {
+			WARN(1, "Failed to create RTT at level %d: %d\n",
+			     level, ret);
+			free_rtt(rtt);
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
 static int realm_tear_down_rtt_level(struct realm *realm, int level,
 				     unsigned long start, unsigned long end)
 {
@@ -220,6 +331,62 @@ static int realm_tear_down_rtt_range(struct realm *realm,
 					 start, end);
 }
 
+/*
+ * Returns 0 on successful fold, a negative value on error, a positive value if
+ * we were not able to fold all tables at this level.
+ */
+static int realm_fold_rtt_level(struct realm *realm, int level,
+				unsigned long start, unsigned long end)
+{
+	int not_folded = 0;
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
+		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			free_rtt(rtt_granule);
+			break;
+		case RMI_ERROR_RTT:
+			if (level == RMM_RTT_MAX_LEVEL ||
+			    RMI_RETURN_INDEX(ret) < level) {
+				not_folded++;
+				break;
+			}
+			/* Recurse a level deeper */
+			ret = realm_fold_rtt_level(realm,
+						   level + 1,
+						   addr,
+						   next_addr);
+			if (ret < 0) {
+				return ret;
+			} else if (ret == 0) {
+				/* Try again at this level */
+				next_addr = addr;
+			}
+			break;
+		default:
+			WARN_ON(1);
+			return -ENXIO;
+		}
+	}
+
+	return not_folded;
+}
+
 void kvm_realm_destroy_rtts(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
@@ -228,12 +395,301 @@ void kvm_realm_destroy_rtts(struct kvm *kvm)
 	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
 }
 
+static int realm_destroy_private_granule(struct realm *realm,
+					 unsigned long ipa,
+					 unsigned long *next_addr)
+{
+	unsigned long rd = virt_to_phys(realm->rd);
+	unsigned long phy_addr;
+	phys_addr_t rtt;
+	int ret;
+
+retry:
+	ret = rmi_data_destroy(rd, ipa, &phy_addr, next_addr);
+	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+		if (*next_addr > ipa)
+			return 0; /* UNASSIGNED */
+		rtt = alloc_rtt(NULL);
+		if (WARN_ON(rtt == PHYS_ADDR_MAX))
+			return -ENOMEM;
+		/*
+		 * ASSIGNED - ipa is mapped as a block, so split. The index
+		 * from the return code should be 2 otherwise it appears
+		 * there's a huge page bigger than KVM currently supports
+		 */
+		WARN_ON(RMI_RETURN_INDEX(ret) != 2);
+		ret = realm_rtt_create(realm, ipa, 3, rtt);
+		if (WARN_ON(ret)) {
+			free_rtt(rtt);
+			return -ENXIO;
+		}
+		goto retry;
+	} else if (WARN_ON(ret)) {
+		return -ENXIO;
+	}
+
+	ret = rmi_granule_undelegate(phy_addr);
+	if (WARN_ON(ret))
+		return -ENXIO;
+
+	return 0;
+}
+
+static void realm_unmap_shared_range(struct kvm *kvm,
+				     int level,
+				     unsigned long start,
+				     unsigned long end,
+				     bool may_block)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned long rd = virt_to_phys(realm->rd);
+	ssize_t map_size = rmi_rtt_level_mapsize(level);
+	unsigned long next_addr, addr;
+	unsigned long shared_bit = BIT(realm->ia_bits - 1);
+
+	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
+		return;
+
+	start |= shared_bit;
+	end |= shared_bit;
+
+	for (addr = start; addr < end; addr = next_addr) {
+		unsigned long align_addr = ALIGN(addr, map_size);
+		int ret;
+
+		next_addr = ALIGN(addr + 1, map_size);
+
+		if (align_addr != addr || next_addr > end) {
+			/* Need to recurse deeper */
+			if (addr < align_addr)
+				next_addr = align_addr;
+			realm_unmap_shared_range(kvm, level + 1, addr,
+						 min(next_addr, end),
+						 may_block);
+			continue;
+		}
+
+		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			break;
+		case RMI_ERROR_RTT:
+			if (next_addr == addr) {
+				/*
+				 * There's a mapping here, but it's not a block
+				 * mapping, so reset next_addr to the next block
+				 * boundary and recurse to clear out the pages
+				 * one level deeper.
+				 */
+				next_addr = ALIGN(addr + 1, map_size);
+				realm_unmap_shared_range(kvm, level + 1, addr,
+							 next_addr,
+							 may_block);
+			}
+			break;
+		default:
+			WARN_ON(1);
+			return;
+		}
+
+		if (may_block)
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+	}
+
+	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
+			     start, end);
+}
+
+static int realm_unmap_private_page(struct realm *realm,
+				    unsigned long ipa,
+				    unsigned long *next_addr)
+{
+	unsigned long end = ALIGN(ipa + 1, PAGE_SIZE);
+	unsigned long addr;
+	int ret;
+
+	for (addr = ipa; addr < end; addr = *next_addr) {
+		ret = realm_destroy_private_granule(realm, addr, next_addr);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void realm_unmap_private_range(struct kvm *kvm,
+				      unsigned long start,
+				      unsigned long end,
+				      bool may_block)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned long next_addr, addr;
+	int ret;
+
+	for (addr = start; addr < end; addr = next_addr) {
+		ret = realm_unmap_private_page(realm, addr, &next_addr);
+
+		if (ret)
+			break;
+
+		if (may_block)
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+	}
+
+	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
+			     start, end);
+}
+
+void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
+			   unsigned long size, bool unmap_private,
+			   bool may_block)
+{
+	unsigned long end = start + size;
+	struct realm *realm = &kvm->arch.realm;
+
+	end = min(BIT(realm->ia_bits - 1), end);
+
+	if (!kvm_realm_is_created(kvm))
+		return;
+
+	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
+				 start, end, may_block);
+	if (unmap_private)
+		realm_unmap_private_range(kvm, start, end, may_block);
+}
+
+enum ripas_action {
+	RIPAS_INIT,
+	RIPAS_SET,
+};
+
+static int ripas_change(struct kvm *kvm,
+			struct kvm_vcpu *vcpu,
+			unsigned long ipa,
+			unsigned long end,
+			enum ripas_action action,
+			unsigned long *top_ipa)
+{
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+	phys_addr_t rec_phys;
+	struct kvm_mmu_memory_cache *memcache = NULL;
+	int ret = 0;
+
+	if (vcpu) {
+		rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
+		memcache = &vcpu->arch.mmu_page_cache;
+
+		WARN_ON(action != RIPAS_SET);
+	} else {
+		WARN_ON(action != RIPAS_INIT);
+	}
+
+	while (ipa < end) {
+		unsigned long next = ~0;
+
+		switch (action) {
+		case RIPAS_INIT:
+			ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
+			break;
+		case RIPAS_SET:
+			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
+						&next);
+			break;
+		}
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			ipa = next;
+			break;
+		case RMI_ERROR_RTT: {
+			int err_level = RMI_RETURN_INDEX(ret);
+			int level = find_map_level(realm, ipa, end);
+
+			if (err_level >= level) {
+				/* FIXME: Ugly hack to skip regions which are
+				 * already RIPAS_RAM
+				 */
+				ipa += PAGE_SIZE;
+				break;
+				return -EINVAL;
+			}
+
+			ret = realm_create_rtt_levels(realm, ipa, err_level,
+						      level, memcache);
+			if (ret)
+				return ret;
+			/* Retry with the RTT levels in place */
+			break;
+		}
+		default:
+			WARN_ON(1);
+			return -ENXIO;
+		}
+	}
+
+	if (top_ipa)
+		*top_ipa = ipa;
+
+	return 0;
+}
+
+static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
+			       unsigned long start,
+			       unsigned long end,
+			       unsigned long ripas,
+			       unsigned long *top_ipa)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int ret = ripas_change(kvm, vcpu, start, end, RIPAS_SET, top_ipa);
+
+	if (ripas == RMI_EMPTY && *top_ipa != start)
+		realm_unmap_private_range(kvm, start, *top_ipa, false);
+
+	return ret;
+}
+
 static int realm_ensure_created(struct kvm *kvm)
 {
 	/* Provided in later patch */
 	return -ENXIO;
 }
 
+static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.ripas_base;
+	unsigned long top = rec->run->exit.ripas_top;
+	unsigned long ripas = rec->run->exit.ripas_value;
+	unsigned long top_ipa;
+	int ret;
+
+	do {
+		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		write_lock(&kvm->mmu_lock);
+		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
+		write_unlock(&kvm->mmu_lock);
+
+		if (WARN_RATELIMIT(ret && ret != -ENOMEM,
+				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
+				   base, top, ripas))
+			break;
+
+		base = top_ipa;
+	} while (base < top);
+
+	/*
+	 * If this function is called again before the REC_ENTER call then
+	 * avoid calling realm_set_ipa_state() again by changing to the value
+	 * of ripas_base for the part that has already been covered. The RMM
+	 * ignores the contains of the rec_exit structure so this doesn't
+	 * affect the RMM.
+	 */
+	rec->run->exit.ripas_base = base;
+}
+
 /*
  * kvm_rec_pre_enter - Complete operations before entering a REC
  *
@@ -259,6 +715,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
 		for (int i = 0; i < REC_RUN_GPRS; i++)
 			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
 		break;
+	case RMI_EXIT_RIPAS_CHANGE:
+		kvm_complete_ripas_change(vcpu);
+		break;
 	}
 
 	return 1;
-- 
2.43.0


