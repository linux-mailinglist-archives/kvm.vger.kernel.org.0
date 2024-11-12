Return-Path: <kvm+bounces-31584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 294699C4FC9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE44E1F23816
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C18C214434;
	Tue, 12 Nov 2024 07:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q17HO1RV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5BE2141D3;
	Tue, 12 Nov 2024 07:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397271; cv=none; b=mbjnV2dqq0mfGrPm56YZDUHcljs1baYKktozokYsiLhM8A3b0ObdL1gJ24+dqjEa8E6Vn0P6vDiYROnR+Vzof2e0v7LJKzZ9CV2yQxvbwJ318NnmJ/hWO02foyQWDqnd3c+oN1L3afiD1x/Px3Ykj4EUTha1M2J4UjJd6SmkKu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397271; c=relaxed/simple;
	bh=07u0JHTlb95NTfYGRNDculJVsJkNEKNN/iPuy0fvY3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oShNMhn3Dj4xVOriVQbrW6Qn71DQjIsz8Bzk15J5RpOPAdx2I/pAnhTmalA0E6V5Byh7qmermbMtiNSQ75fMMjxuqm/MIxzb0M698B/e+8wLqXZjnxG5PGM8Mg0B2VtKPDAS2QKa8ivdWVoa8NW1zixhTcHgSA2i8WfMY7NKbN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q17HO1RV; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397269; x=1762933269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=07u0JHTlb95NTfYGRNDculJVsJkNEKNN/iPuy0fvY3k=;
  b=Q17HO1RV/H3JWgptbUr586bJ4kYhaVRdhHNZWGNzqxtbqYE+CHT5kL41
   r/jmwS04aDZfgN3ff2WmdFvV5pansOc5ymlhuzVOwI6ReAxiOG60ns0Ta
   pN5rJYIhORChoiR/WUbqKx/FlaYkFIvzENgm2gLe3RjM5x84k2LYCTWOQ
   Va0zP+V2Pb8x1uc40+ZbMhhRWy4UwoFv8SuE6BDgmNnh9fVRLiwjwMmMy
   4pIQfjVYc/Zdy3FjpvGlCx0wgm1hxC8M0+HLPM2qIJwypWVasQf1PUw3J
   CXvi8CyPU87o+MEjvCzmFHi3qzu0zhyJs4sADLYkDgvqJDYDnkeR+ryZp
   Q==;
X-CSE-ConnectionGUID: i3jTT3JFTjSqNdpTfF9R/g==
X-CSE-MsgGUID: FHWFxUSORJC8N6DSqYOMDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="42598967"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="42598967"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:08 -0800
X-CSE-ConnectionGUID: tJlB+OgGSL+AEOfbKDYlEA==
X-CSE-MsgGUID: Xde3ebUbTPOfEy/HofXmig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87427183"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:04 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 21/24] KVM: TDX: Add an ioctl to create initial guest memory
Date: Tue, 12 Nov 2024 15:38:37 +0800
Message-ID: <20241112073837.22284-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new ioctl for the user space VMM to initialize guest memory with the
specified memory contents.

Because TDX protects the guest's memory, the creation of the initial guest
memory requires a dedicated TDX module API, TDH.MEM.PAGE.ADD(), instead of
directly copying the memory contents into the guest's memory in the case of
the default VM type.

Define a new subcommand, KVM_TDX_INIT_MEM_REGION, of vCPU-scoped
KVM_MEMORY_ENCRYPT_OP.  Check if the GFN is already pre-allocated, assign
the guest page in Secure-EPT, copy the initial memory contents into the
guest memory, and encrypt the guest memory.  Optionally, extend the memory
measurement of the TDX guest.

The ioctl uses the vCPU file descriptor because of the TDX module's
requirement that the memory is added to the S-EPT (via TDH.MEM.SEPT.ADD)
prior to initialization (TDH.MEM.PAGE.ADD).  Accessing the MMU in turn
requires a vCPU file descriptor, just like for KVM_PRE_FAULT_MEMORY.  In
fact, the post-populate callback is able to reuse the same logic used by
KVM_PRE_FAULT_MEMORY, so that userspace can do everything with a single
ioctl.

Note that this is the only way to invoke TDH.MEM.SEPT.ADD before the TD
in finalized, as userspace cannot use KVM_PRE_FAULT_MEMORY at that
point.  This ensures that there cannot be pages in the S-EPT awaiting
TDH.MEM.PAGE.ADD, which would be treated incorrectly as spurious by
tdp_mmu_map_handle_target_level() (KVM would see the SPTE as PRESENT,
but the corresponding S-EPT entry will be !PRESENT).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - Updated commit msg (Paolo)
 - Added a guard around kvm_tdp_mmu_gpa_is_mapped() (Paolo).
 - Remove checking kvm_mem_is_private() in tdx_gmem_post_populate (Rick)
 - No need for is_td_finalized() (Rick)
 - Remove decrement of nr_premapped (moved to "Finalize VM initialization"
   patch) (Paolo)
 - Take slots_lock before checking kvm_tdx->finalized in
   tdx_vcpu_init_mem_region(), and use guard() (Paolo)
 - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Add TD state handling (Tony)

TDX MMU part 2 v1:
 - Update the code according to latest gmem update.
   https://lore.kernel.org/kvm/CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com/
 - Fixup a aligment bug reported by Binbin.
 - Rename KVM_MEMORY_MAPPING => KVM_MAP_MEMORY (Sean)
 - Drop issueing TDH.MEM.PAGE.ADD() on KVM_MAP_MEMORY(), defer it to
   KVM_TDX_INIT_MEM_REGION. (Sean)
 - Added nr_premapped to track the number of premapped pages
 - Drop tdx_post_mmu_map_page().
 - Drop kvm_slot_can_be_private() check (Paolo)
 - Use kvm_tdp_mmu_gpa_is_mapped() (Paolo)

v19:
 - Switched to use KVM_MEMORY_MAPPING
 - Dropped measurement extension
 - updated commit message. private_page_add() => set_private_spte()
---
 arch/x86/include/uapi/asm/kvm.h |   9 ++
 arch/x86/kvm/vmx/tdx.c          | 147 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             |   1 +
 3 files changed, 157 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 36fa03376581..a19cd84cec76 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -931,6 +931,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
@@ -985,4 +986,12 @@ struct kvm_tdx_init_vm {
 	struct kvm_cpuid2 cpuid;
 };
 
+#define KVM_TDX_MEASURE_MEMORY_REGION   _BITULL(0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ead520083397..15cedacd717a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
@@ -7,6 +8,7 @@
 #include "tdx.h"
 #include "vmx.h"
 #include "mmu/spte.h"
+#include "common.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -1597,6 +1599,148 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+struct tdx_gmem_post_populate_arg {
+	struct kvm_vcpu *vcpu;
+	__u32 flags;
+};
+
+static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  void __user *src, int order, void *_arg)
+{
+	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_gmem_post_populate_arg *arg = _arg;
+	struct kvm_vcpu *vcpu = arg->vcpu;
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u8 level = PG_LEVEL_4K;
+	struct page *page;
+	int ret, i;
+	u64 err, entry, level_state;
+
+	/*
+	 * Get the source page if it has been faulted in. Return failure if the
+	 * source page has been swapped out or unmapped in primary memory.
+	 */
+	ret = get_user_pages_fast((unsigned long)src, 1, 0, &page);
+	if (ret < 0)
+		return ret;
+	if (ret != 1)
+		return -ENOMEM;
+
+	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * The private mem cannot be zapped after kvm_tdp_map_page()
+	 * because all paths are covered by slots_lock and the
+	 * filemap invalidate lock.  Check that they are indeed enough.
+	 */
+	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
+				ret = -EIO;
+				goto out;
+			}
+		}
+	}
+
+	ret = 0;
+	do {
+		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
+				       pfn_to_hpa(page_to_pfn(page)),
+				       &entry, &level_state);
+	} while (err == TDX_ERROR_SEPT_BUSY);
+	if (err) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
+		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+			err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &entry,
+					    &level_state);
+			if (err) {
+				ret = -EIO;
+				break;
+			}
+		}
+	}
+
+out:
+	put_page(page);
+	return ret;
+}
+
+static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_mem_region region;
+	struct tdx_gmem_post_populate_arg arg;
+	long gmem_ret;
+	int ret;
+
+	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
+		return -EINVAL;
+
+	guard(mutex)(&kvm->slots_lock);
+
+	/* Once TD is finalized, the initial guest memory is fixed. */
+	if (kvm_tdx->state == TD_STATE_RUNNABLE)
+		return -EINVAL;
+
+	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
+		return -EINVAL;
+
+	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
+		return -EFAULT;
+
+	if (!PAGE_ALIGNED(region.source_addr) || !PAGE_ALIGNED(region.gpa) ||
+	    !region.nr_pages ||
+	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
+	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
+	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
+		return -EINVAL;
+
+	kvm_mmu_reload(vcpu);
+	ret = 0;
+	while (region.nr_pages) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		arg = (struct tdx_gmem_post_populate_arg) {
+			.vcpu = vcpu,
+			.flags = cmd->flags,
+		};
+		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
+					     u64_to_user_ptr(region.source_addr),
+					     1, tdx_gmem_post_populate, &arg);
+		if (gmem_ret < 0) {
+			ret = gmem_ret;
+			break;
+		}
+
+		if (gmem_ret != 1) {
+			ret = -EIO;
+			break;
+		}
+
+		region.source_addr += PAGE_SIZE;
+		region.gpa += PAGE_SIZE;
+		region.nr_pages--;
+
+		cond_resched();
+	}
+
+	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
+		ret = -EFAULT;
+	return ret;
+}
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -1616,6 +1760,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	case KVM_TDX_INIT_VCPU:
 		ret = tdx_vcpu_init(vcpu, &cmd);
 		break;
+	case KVM_TDX_INIT_MEM_REGION:
+		ret = tdx_vcpu_init_mem_region(vcpu, &cmd);
+		break;
 	case KVM_TDX_GET_CPUID:
 		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
 		break;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 152afe67a00b..5901d03e372c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2600,6 +2600,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.43.2


