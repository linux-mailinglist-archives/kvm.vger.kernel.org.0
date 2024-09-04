Return-Path: <kvm+bounces-25826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F4696AF1B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068CB1F2600F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7547714430E;
	Wed,  4 Sep 2024 03:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iPspYo3y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA0759155;
	Wed,  4 Sep 2024 03:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419686; cv=none; b=hJUoa63wSEelDWWCQnhZGmSw3yCIp1oZsv6hXmgsgHywA127GopD0ondb2llj+/D+naC6ZJo92XrRuI8nSFfmIkEMzkWBq/SXR/KM9bdciVcQ++tN+OJvLqYEgZdwiPN5HsBrAjjHIfMq7NzR+/KyKBbPlpAdoYwNRlhc0wEPfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419686; c=relaxed/simple;
	bh=nndpORrLQUk9Aw9kC1XdXsRMcRLXZY0XeYbkhI+fpss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j1Q5NB9CTB1K46MHG4icmuYqJEnFg8OvZBMID8PVb/fdfohoKQKs+xfYUmwQJ1KeEkrAr/ozTtkI992p42ApVGyRWosz5ZrQ/DAg6+yLWek7rfhOUTZNMhsUeeF78nnkzE4fwpKi+QoEcNWLcwVaOjj9z840yFrJOrSt74+roro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iPspYo3y; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419684; x=1756955684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nndpORrLQUk9Aw9kC1XdXsRMcRLXZY0XeYbkhI+fpss=;
  b=iPspYo3yE1lTQ8fWs45pNfskf/QFMqfN3GtyKl3snQrXe8Va4E2pxco9
   dOP/gQt1hoA3tR3gd41HWXELPJko63ofO6CG3hf/iEyKiwCiGmkdtjkqN
   QMWoxZq7i8qv6OBXh58eUYG+HpU65AjXRQ89kedRSS0U4B0PTQtabuXQI
   LBCGB4J3cLD3V0yBDcBJBehpyUYTc5Qnvx5ZwH4tZf1/cko7il4htWcZJ
   EqOxvBxzEjTlec+WhNtqmFNo6zOvpioI8ruWkuTqOCfVa6m3SubIeEonN
   5gblLq9P/2VsMC0zhisoTr0FetdMfh/Z0e13WV/fgsAXRJbusXJDo9XPV
   Q==;
X-CSE-ConnectionGUID: FfUnSgV1Rk66qyDQWF+dxw==
X-CSE-MsgGUID: Fd0AdSxmTyqLXxE1N75Jhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564726"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564726"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:12 -0700
X-CSE-ConnectionGUID: 9X7FYh3AQ4m3KLeB7qTFfw==
X-CSE-MsgGUID: dZJbLmi5QpOEJJuCCkqtew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106375"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:12 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest memory
Date: Tue,  3 Sep 2024 20:07:49 -0700
Message-Id: <20240904030751.117579-20-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
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

Discussion history:
- Originally, KVM_TDX_INIT_MEM_REGION used the callback of the TDP MMU of
  the KVM page fault handler.  It issues TDX SEAMCALL deep in the call
  stack, and the ioctl passes down the necessary parameters.  [2] rejected
  it.  [3] suggests that the call to the TDX module should be invoked in a
  shallow call stack.

- Instead, introduce guest memory pre-population [1] that doesn't update
  vendor-specific part (Secure-EPT in TDX case) and the vendor-specific
  code (KVM_TDX_INIT_MEM_REGION) updates only vendor-specific parts without
  modifying the KVM TDP MMU suggested at [4]

    Crazy idea.  For TDX S-EPT, what if KVM_MAP_MEMORY does all of the
    SEPT.ADD stuff, which doesn't affect the measurement, and even fills in
    KVM's copy of the leaf EPTE, but tdx_sept_set_private_spte() doesn't do
    anything if the TD isn't finalized?

    Then KVM provides a dedicated TDX ioctl(), i.e. what is/was
    KVM_TDX_INIT_MEM_REGION, to do PAGE.ADD.  KVM_TDX_INIT_MEM_REGION
    wouldn't need to map anything, it would simply need to verify that the
    pfn from guest_memfd() is the same as what's in the TDP MMU.

- Use the common guest_memfd population function, kvm_gmem_populate()
  instead of a custom function.  It should check whether the PFN
  from TDP MMU is the same as the one from guest_memfd. [1]

- Instead of forcing userspace to do two passes, pre-map the guest
  initial memory in tdx_gmem_post_populate. [5]

Link: https://lore.kernel.org/kvm/20240419085927.3648704-1-pbonzini@redhat.com/ [1]
Link: https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/ [2]
Link: https://lore.kernel.org/kvm/Zh8DHbb8FzoVErgX@google.com/ [3]
Link: https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/ [4]
Link: https://lore.kernel.org/kvm/CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com/ [5]
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
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
 arch/x86/kvm/vmx/tdx.c          | 150 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             |   1 +
 3 files changed, 160 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 39636be5c891..789d1d821b4f 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -931,6 +931,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
@@ -996,4 +997,12 @@ struct kvm_tdx_init_vm {
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
index 50ce24905062..796d1a495a66 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -8,6 +8,7 @@
 #include "tdx_ops.h"
 #include "vmx.h"
 #include "mmu/spte.h"
+#include "common.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -1586,6 +1587,152 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
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
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		ret = -EFAULT;
+		goto out_put_page;
+	}
+
+	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
+	if (ret < 0)
+		goto out_put_page;
+
+	read_lock(&kvm->mmu_lock);
+
+	if (!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = 0;
+	do {
+		err = tdh_mem_page_add(kvm_tdx, gpa, pfn_to_hpa(pfn),
+				       pfn_to_hpa(page_to_pfn(page)),
+				       &entry, &level_state);
+	} while (err == TDX_ERROR_SEPT_BUSY);
+	if (err) {
+		ret = -EIO;
+		goto out;
+	}
+
+	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
+	atomic64_dec(&kvm_tdx->nr_premapped);
+
+	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
+		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+			err = tdh_mr_extend(kvm_tdx, gpa + i, &entry,
+					&level_state);
+			if (err) {
+				ret = -EIO;
+				break;
+			}
+		}
+	}
+
+out:
+	read_unlock(&kvm->mmu_lock);
+out_put_page:
+	put_page(page);
+	return ret;
+}
+
+static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_mem_region region;
+	struct tdx_gmem_post_populate_arg arg;
+	long gmem_ret;
+	int ret;
+
+	if (!to_tdx(vcpu)->initialized)
+		return -EINVAL;
+
+	/* Once TD is finalized, the initial guest memory is fixed. */
+	if (is_td_finalized(kvm_tdx))
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
+	    !kvm_is_private_gpa(kvm, region.gpa) ||
+	    !kvm_is_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
+		return -EINVAL;
+
+	mutex_lock(&kvm->slots_lock);
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
+	mutex_unlock(&kvm->slots_lock);
+
+	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
+		ret = -EFAULT;
+	return ret;
+}
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -1605,6 +1752,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
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
index 73fc3334721d..0822db480719 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2639,6 +2639,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.34.1


