Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6239B67E385
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbjA0LeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjA0Ldy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:33:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D8557267F;
        Fri, 27 Jan 2023 03:32:08 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 185F61576;
        Fri, 27 Jan 2023 03:31:06 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE4E13F64C;
        Fri, 27 Jan 2023 03:30:21 -0800 (PST)
From:   Steven Price <steven.price@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: [RFC PATCH 16/28] arm64: RME: Allow populating initial contents
Date:   Fri, 27 Jan 2023 11:29:20 +0000
Message-Id: <20230127112932.38045-17-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMM needs to populate the realm with some data before starting (e.g.
a kernel and initrd). This is measured by the RMM and used as part of
the attestation later on.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rme.c | 366 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 366 insertions(+)

diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 16e0bfea98b1..3405b43e1421 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/hugetlb.h>
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
@@ -426,6 +427,359 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size)
 	}
 }
 
+static int realm_create_protected_data_page(struct realm *realm,
+					    unsigned long ipa,
+					    struct page *dst_page,
+					    struct page *tmp_page)
+{
+	phys_addr_t dst_phys, tmp_phys;
+	int ret;
+
+	copy_page(page_address(tmp_page), page_address(dst_page));
+
+	dst_phys = page_to_phys(dst_page);
+	tmp_phys = page_to_phys(tmp_page);
+
+	if (rmi_granule_delegate(dst_phys))
+		return -ENXIO;
+
+	ret = rmi_data_create(dst_phys, virt_to_phys(realm->rd), ipa, tmp_phys,
+			      RMI_MEASURE_CONTENT);
+
+	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+		/* Create missing RTTs and retry */
+		int level = RMI_RETURN_INDEX(ret);
+
+		ret = realm_create_rtt_levels(realm, ipa, level,
+					      RME_RTT_MAX_LEVEL, NULL);
+		if (ret)
+			goto err;
+
+		ret = rmi_data_create(dst_phys, virt_to_phys(realm->rd), ipa,
+				      tmp_phys, RMI_MEASURE_CONTENT);
+	}
+
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	if (WARN_ON(rmi_granule_undelegate(dst_phys))) {
+		/* Page can't be returned to NS world so is lost */
+		get_page(dst_page);
+	}
+	return -ENXIO;
+}
+
+static int fold_rtt(phys_addr_t rd, unsigned long addr, int level,
+		    struct realm *realm)
+{
+	struct rtt_entry rtt;
+	phys_addr_t rtt_addr;
+
+	if (rmi_rtt_read_entry(rd, addr, level, &rtt))
+		return -ENXIO;
+
+	if (rtt.state != RMI_TABLE)
+		return -EINVAL;
+
+	rtt_addr = rmi_rtt_get_phys(&rtt);
+	if (rmi_rtt_fold(rtt_addr, rd, addr, level + 1))
+		return -ENXIO;
+
+	free_delegated_page(realm, rtt_addr);
+
+	return 0;
+}
+
+int realm_map_protected(struct realm *realm,
+			unsigned long hva,
+			unsigned long base_ipa,
+			struct page *dst_page,
+			unsigned long map_size,
+			struct kvm_mmu_memory_cache *memcache)
+{
+	phys_addr_t dst_phys = page_to_phys(dst_page);
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	unsigned long phys = dst_phys;
+	unsigned long ipa = base_ipa;
+	unsigned long size;
+	int map_level;
+	int ret = 0;
+
+	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
+		return -EINVAL;
+
+	switch (map_size) {
+	case PAGE_SIZE:
+		map_level = 3;
+		break;
+	case RME_L2_BLOCK_SIZE:
+		map_level = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (map_level < RME_RTT_MAX_LEVEL) {
+		/*
+		 * A temporary RTT is needed during the map, precreate it,
+		 * however if there is an error (e.g. missing parent tables)
+		 * this will be handled below.
+		 */
+		realm_create_rtt_levels(realm, ipa, map_level,
+					RME_RTT_MAX_LEVEL, memcache);
+	}
+
+	for (size = 0; size < map_size; size += PAGE_SIZE) {
+		if (rmi_granule_delegate(phys)) {
+			struct rtt_entry rtt;
+
+			/*
+			 * It's possible we raced with another VCPU on the same
+			 * fault. If the entry exists and matches then exit
+			 * early and assume the other VCPU will handle the
+			 * mapping.
+			 */
+			if (rmi_rtt_read_entry(rd, ipa, RME_RTT_MAX_LEVEL, &rtt))
+				goto err;
+
+			// FIXME: For a block mapping this could race at level
+			// 2 or 3...
+			if (WARN_ON((rtt.walk_level != RME_RTT_MAX_LEVEL ||
+				     rtt.state != RMI_ASSIGNED ||
+				     rtt.desc != phys))) {
+				goto err;
+			}
+
+			return 0;
+		}
+
+		ret = rmi_data_create_unknown(phys, rd, ipa);
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RETURN_INDEX(ret);
+
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      RME_RTT_MAX_LEVEL,
+						      memcache);
+			WARN_ON(ret);
+			if (ret)
+				goto err_undelegate;
+
+			ret = rmi_data_create_unknown(phys, rd, ipa);
+		}
+		WARN_ON(ret);
+
+		if (ret)
+			goto err_undelegate;
+
+		phys += PAGE_SIZE;
+		ipa += PAGE_SIZE;
+	}
+
+	if (map_size == RME_L2_BLOCK_SIZE)
+		ret = fold_rtt(rd, base_ipa, map_level, realm);
+	if (WARN_ON(ret))
+		goto err;
+
+	return 0;
+
+err_undelegate:
+	if (WARN_ON(rmi_granule_undelegate(phys))) {
+		/* Page can't be returned to NS world so is lost */
+		get_page(phys_to_page(phys));
+	}
+err:
+	while (size > 0) {
+		phys -= PAGE_SIZE;
+		size -= PAGE_SIZE;
+		ipa -= PAGE_SIZE;
+
+		rmi_data_destroy(rd, ipa);
+
+		if (WARN_ON(rmi_granule_undelegate(phys))) {
+			/* Page can't be returned to NS world so is lost */
+			get_page(phys_to_page(phys));
+		}
+	}
+	return -ENXIO;
+}
+
+static int populate_par_region(struct kvm *kvm,
+			       phys_addr_t ipa_base,
+			       phys_addr_t ipa_end)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct kvm_memory_slot *memslot;
+	gfn_t base_gfn, end_gfn;
+	int idx;
+	phys_addr_t ipa;
+	int ret = 0;
+	struct page *tmp_page;
+	phys_addr_t rd = virt_to_phys(realm->rd);
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
+	tmp_page = alloc_page(GFP_KERNEL);
+	if (!tmp_page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mmap_read_lock(current->mm);
+
+	ipa = ipa_base;
+
+	while (ipa < ipa_end) {
+		struct vm_area_struct *vma;
+		unsigned long map_size;
+		unsigned int vma_shift;
+		unsigned long offset;
+		unsigned long hva;
+		struct page *page;
+		kvm_pfn_t pfn;
+		int level;
+
+		hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
+		vma = vma_lookup(current->mm, hva);
+		if (!vma) {
+			ret = -EFAULT;
+			break;
+		}
+
+		if (is_vm_hugetlb_page(vma))
+			vma_shift = huge_page_shift(hstate_vma(vma));
+		else
+			vma_shift = PAGE_SHIFT;
+
+		map_size = 1 << vma_shift;
+
+		/*
+		 * FIXME: This causes over mapping, but there's no good
+		 * solution here with the ABI as it stands
+		 */
+		ipa = ALIGN_DOWN(ipa, map_size);
+
+		switch (map_size) {
+		case RME_L2_BLOCK_SIZE:
+			level = 2;
+			break;
+		case PAGE_SIZE:
+			level = 3;
+			break;
+		default:
+			WARN_ONCE(1, "Unsupport vma_shift %d", vma_shift);
+			ret = -EFAULT;
+			break;
+		}
+
+		pfn = gfn_to_pfn_memslot(memslot, gpa_to_gfn(ipa));
+
+		if (is_error_pfn(pfn)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = rmi_rtt_init_ripas(rd, ipa, level);
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			ret = realm_create_rtt_levels(realm, ipa,
+						      RMI_RETURN_INDEX(ret),
+						      level, NULL);
+			if (ret)
+				break;
+			ret = rmi_rtt_init_ripas(rd, ipa, level);
+			if (ret) {
+				ret = -ENXIO;
+				break;
+			}
+		}
+
+		if (level < RME_RTT_MAX_LEVEL) {
+			/*
+			 * A temporary RTT is needed during the map, precreate
+			 * it, however if there is an error (e.g. missing
+			 * parent tables) this will be handled in the
+			 * realm_create_protected_data_page() call.
+			 */
+			realm_create_rtt_levels(realm, ipa, level,
+						RME_RTT_MAX_LEVEL, NULL);
+		}
+
+		page = pfn_to_page(pfn);
+
+		for (offset = 0; offset < map_size && !ret;
+		     offset += PAGE_SIZE, page++) {
+			phys_addr_t page_ipa = ipa + offset;
+
+			ret = realm_create_protected_data_page(realm, page_ipa,
+							       page, tmp_page);
+		}
+		if (ret)
+			goto err_release_pfn;
+
+		if (level == 2) {
+			ret = fold_rtt(rd, ipa, level, realm);
+			if (ret)
+				goto err_release_pfn;
+		}
+
+		ipa += map_size;
+		kvm_set_pfn_accessed(pfn);
+		kvm_set_pfn_dirty(pfn);
+		kvm_release_pfn_dirty(pfn);
+err_release_pfn:
+		if (ret) {
+			kvm_release_pfn_clean(pfn);
+			break;
+		}
+	}
+
+	mmap_read_unlock(current->mm);
+	__free_page(tmp_page);
+
+out:
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret;
+}
+
+static int kvm_populate_realm(struct kvm *kvm,
+			      struct kvm_cap_arm_rme_populate_realm_args *args)
+{
+	phys_addr_t ipa_base, ipa_end;
+
+	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
+		return -EBUSY;
+
+	if (!IS_ALIGNED(args->populate_ipa_base, PAGE_SIZE) ||
+	    !IS_ALIGNED(args->populate_ipa_size, PAGE_SIZE))
+		return -EINVAL;
+
+	ipa_base = args->populate_ipa_base;
+	ipa_end = ipa_base + args->populate_ipa_size;
+
+	if (ipa_end < ipa_base)
+		return -EINVAL;
+
+	return populate_par_region(kvm, ipa_base, ipa_end);
+}
+
 static int set_ipa_state(struct kvm_vcpu *vcpu,
 			 unsigned long ipa,
 			 unsigned long end,
@@ -748,6 +1102,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		r = kvm_init_ipa_range_realm(kvm, &args);
 		break;
 	}
+	case KVM_CAP_ARM_RME_POPULATE_REALM: {
+		struct kvm_cap_arm_rme_populate_realm_args args;
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
2.34.1

