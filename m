Return-Path: <kvm+bounces-55159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 365FFB2E03A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CA771C831D3
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0315633A016;
	Wed, 20 Aug 2025 14:58:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F06322A1B;
	Wed, 20 Aug 2025 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701929; cv=none; b=S8EvlQlONbuWgASIgdTK0Udp/WfH15aE3xucIYQggT/gUbFHZCsJ2uRAF5bK4mFanRrmHixf65c5NewyL017+S6OHJyyIJQAuOgFBuR/47/FPFpUURapCO9m3dEF4Lkbzroud4Nr+MEXwAaGKwJKlisrxg7bvmeb77JbS1kzGnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701929; c=relaxed/simple;
	bh=kkn60vbxgKNeFyif4iky81KtJxaH9y4f8GHGaZyau5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hikLeQM07+w9gCXLBVMg+yr+JR7gfYVWi5SSqE5T+9FyelTOpf7nBGKqq+8DHuMVXJ10Px5xMGNvSqTbfmK1I9+REikhaR81z5Px0XX3nDADMgEzDc434Q+3E5PzZ1L3zfwyAQhzxeT2LqTLWHl/OGFGzi66e3U9eOKnofa162k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 599072C27;
	Wed, 20 Aug 2025 07:58:39 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F43E3F738;
	Wed, 20 Aug 2025 07:58:40 -0700 (PDT)
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
Subject: [PATCH v10 19/43] arm64: RME: Allow populating initial contents
Date: Wed, 20 Aug 2025 15:55:39 +0100
Message-ID: <20250820145606.180644-20-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VMM needs to populate the realm with some data before starting (e.g.
a kernel and initrd). This is measured by the RMM and used as part of
the attestation later on.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
Changes since v7:
 * Improve the error codes.
 * Other minor changes from review.
Changes since v6:
 * Handle host potentially having a larger page size than the RMM
   granule.
 * Drop historic "par" (protected address range) from
   populate_par_region() - it doesn't exist within the current
   architecture.
 * Add a cond_resched() call in kvm_populate_realm().
Changes since v5:
 * Refactor to use PFNs rather than tracking struct page in
   realm_create_protected_data_page().
 * Pull changes from a later patch (in the v5 series) for accessing
   pages from a guest memfd.
 * Do the populate in chunks to avoid holding locks for too long and
   triggering RCU stall warnings.
---
 arch/arm64/kvm/rme.c | 227 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 227 insertions(+)

diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 22168e8d8db7..817eb5c96728 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -663,6 +663,221 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
 		realm_unmap_private_range(kvm, start, end, may_block);
 }
 
+static int realm_create_protected_data_granule(struct realm *realm,
+					       unsigned long ipa,
+					       phys_addr_t dst_phys,
+					       phys_addr_t src_phys,
+					       unsigned long flags)
+{
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	int ret;
+
+	if (rmi_granule_delegate(dst_phys))
+		return -ENXIO;
+
+	ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
+	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+		/* Create missing RTTs and retry */
+		int level = RMI_RETURN_INDEX(ret);
+
+		WARN_ON(level == RMM_RTT_MAX_LEVEL);
+
+		ret = realm_create_rtt_levels(realm, ipa, level,
+					      RMM_RTT_MAX_LEVEL, NULL);
+		if (ret)
+			return -EIO;
+
+		ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
+	}
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int realm_create_protected_data_page(struct realm *realm,
+					    unsigned long ipa,
+					    kvm_pfn_t dst_pfn,
+					    kvm_pfn_t src_pfn,
+					    unsigned long flags)
+{
+	unsigned long rd = virt_to_phys(realm->rd);
+	phys_addr_t dst_phys, src_phys;
+	bool undelegate_failed = false;
+	int ret, offset;
+
+	dst_phys = __pfn_to_phys(dst_pfn);
+	src_phys = __pfn_to_phys(src_pfn);
+
+	for (offset = 0; offset < PAGE_SIZE; offset += RMM_PAGE_SIZE) {
+		ret = realm_create_protected_data_granule(realm,
+							  ipa,
+							  dst_phys,
+							  src_phys,
+							  flags);
+		if (ret)
+			goto err;
+
+		ipa += RMM_PAGE_SIZE;
+		dst_phys += RMM_PAGE_SIZE;
+		src_phys += RMM_PAGE_SIZE;
+	}
+
+	return 0;
+
+err:
+	if (ret == -EIO) {
+		/* current offset needs undelegating */
+		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
+			undelegate_failed = true;
+	}
+	while (offset > 0) {
+		ipa -= RMM_PAGE_SIZE;
+		offset -= RMM_PAGE_SIZE;
+		dst_phys -= RMM_PAGE_SIZE;
+
+		rmi_data_destroy(rd, ipa, NULL, NULL);
+
+		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
+			undelegate_failed = true;
+	}
+
+	if (undelegate_failed) {
+		/*
+		 * A granule could not be undelegated,
+		 * so the page has to be leaked
+		 */
+		get_page(pfn_to_page(dst_pfn));
+	}
+
+	return -ENXIO;
+}
+
+static int populate_region(struct kvm *kvm,
+			   phys_addr_t ipa_base,
+			   phys_addr_t ipa_end,
+			   unsigned long data_flags)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct kvm_memory_slot *memslot;
+	gfn_t base_gfn, end_gfn;
+	int idx;
+	phys_addr_t ipa = ipa_base;
+	int ret = 0;
+
+	base_gfn = gpa_to_gfn(ipa_base);
+	end_gfn = gpa_to_gfn(ipa_end);
+
+	idx = srcu_read_lock(&kvm->srcu);
+	memslot = gfn_to_memslot(kvm, base_gfn);
+	if (!memslot) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* We require the region to be contained within a single memslot */
+	if (memslot->base_gfn + memslot->npages < end_gfn) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	while (ipa < ipa_end) {
+		struct vm_area_struct *vma;
+		unsigned long hva;
+		struct page *page;
+		bool writeable;
+		kvm_pfn_t pfn;
+		kvm_pfn_t priv_pfn;
+		struct page *gmem_page;
+
+		hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
+		vma = vma_lookup(current->mm, hva);
+		if (!vma) {
+			ret = -EFAULT;
+			break;
+		}
+
+		pfn = __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), FOLL_WRITE,
+					&writeable, &page);
+
+		if (is_error_pfn(pfn)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = kvm_gmem_get_pfn(kvm, memslot,
+				       ipa >> PAGE_SHIFT,
+				       &priv_pfn, &gmem_page, NULL);
+		if (ret)
+			break;
+
+		ret = realm_create_protected_data_page(realm, ipa,
+						       priv_pfn,
+						       pfn,
+						       data_flags);
+
+		kvm_release_page_clean(page);
+
+		if (ret)
+			break;
+
+		ipa += PAGE_SIZE;
+	}
+
+out:
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret;
+}
+
+static int kvm_populate_realm(struct kvm *kvm,
+			      struct arm_rme_populate_realm *args)
+{
+	phys_addr_t ipa_base, ipa_end;
+	unsigned long data_flags = 0;
+
+	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
+		return -EPERM;
+
+	if (!IS_ALIGNED(args->base, PAGE_SIZE) ||
+	    !IS_ALIGNED(args->size, PAGE_SIZE) ||
+	    (args->flags & ~RMI_MEASURE_CONTENT))
+		return -EINVAL;
+
+	ipa_base = args->base;
+	ipa_end = ipa_base + args->size;
+
+	if (ipa_end < ipa_base)
+		return -EINVAL;
+
+	if (args->flags & RMI_MEASURE_CONTENT)
+		data_flags |= RMI_MEASURE_CONTENT;
+
+	/*
+	 * Perform the population in parts to ensure locks are not held for too
+	 * long
+	 */
+	while (ipa_base < ipa_end) {
+		phys_addr_t end = min(ipa_end, ipa_base + SZ_2M);
+
+		int ret = populate_region(kvm, ipa_base, end,
+					  args->flags);
+
+		if (ret)
+			return ret;
+
+		ipa_base = end;
+
+		cond_resched();
+	}
+
+	return 0;
+}
+
 enum ripas_action {
 	RIPAS_INIT,
 	RIPAS_SET,
@@ -907,6 +1122,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		r = kvm_init_ipa_range_realm(kvm, &args);
 		break;
 	}
+	case KVM_CAP_ARM_RME_POPULATE_REALM: {
+		struct arm_rme_populate_realm args;
+		void __user *argp = u64_to_user_ptr(cap->args[1]);
+
+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+
+		r = kvm_populate_realm(kvm, &args);
+		break;
+	}
 	default:
 		r = -EINVAL;
 		break;
-- 
2.43.0


