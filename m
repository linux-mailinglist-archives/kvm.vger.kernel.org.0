Return-Path: <kvm+bounces-6660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7292837842
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 771DB29254A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320A46D1C2;
	Mon, 22 Jan 2024 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="che48mL6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18C6774A;
	Mon, 22 Jan 2024 23:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967759; cv=none; b=SARRGF0GQ4UaTAQQgfBmhX8Rz/qmREFx2LIQOpkv38DnmDvCmw7AKl2nXHXQs6AFRiD4NtB+tUj7ohMnIWyAXZCo4dDmjX/bosGDDyvTouQ2zsHFyDsVcDnI3nKWI7PPuXetwpFfqWzs4Z1+ASBM7i1czgz4qqv1vF6WRoytSpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967759; c=relaxed/simple;
	bh=+RmaBw2NmsoJscpzGY5cQs7JUt1WE4iiwRtKXSMaiLw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EBPKmAynE7SKV2cmGi0lZY+INOrE0ZdqdbX/W7zhCEtE4R5IFt3EWB2T0INJaX5llcdRYdLrYqH0MrOrI+nvOLunU9Vx9wk10zRc/ysj3URU/gueJrUbh/daIzdGcotTNNPiLtX1n4cEYtdqflpKnFhvG6jpYa1bKy/SpdbrdGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=che48mL6; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967756; x=1737503756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+RmaBw2NmsoJscpzGY5cQs7JUt1WE4iiwRtKXSMaiLw=;
  b=che48mL6ujrOhrVel4WCHQI8NJq4GR8jmJYJrZ/hs1PxoaBRZetURTj5
   ucoStX8DYR1TpK0JpGn3dWNTeLwH6LC7/aZ+4ZNcG4IPs6Yueu0CAWWm1
   UVzrsY8caD1e9CBuhwV7y4t9MtisSvMvtmR0eVLftlpz9DE8wONRJmaVZ
   HHwMpJuXJI0BS85fK06pqXGQWnobBis0UtDjidaTTKsPduPFhRoy0CO2E
   aYQholX+lOKtGShdKve+rb6gfsBmaqQXJkUkfSn1zhn+o7I83LaOh2hRE
   OvbUt8TeFT3z+pic+ZZP5zvF2aAlxMJ5IDkAL0Tx3aDsW8o3Tx0aWrUqT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016490"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016490"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468226"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:38 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	gkirkpatrick@google.com
Subject: [PATCH v18 064/121] KVM: TDX: Create initial guest memory
Date: Mon, 22 Jan 2024 15:53:40 -0800
Message-Id: <97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because the guest memory is protected in TDX, the creation of the initial
guest memory requires a dedicated TDX module API, tdh_mem_page_add, instead
of directly copying the memory contents into the guest memory in the case
of the default VM type.  KVM MMU page fault handler callback,
private_page_add, handles it.

Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
memory contents into the guest memory, encrypts the guest memory.  At the
same time, optionally it extends memory measurement of the TDX guest.  It
calls the KVM MMU page fault(EPT-violation) handler to trigger the
callbacks for it.

Reported-by: gkirkpatrick@google.com
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v18:
- rename tdx_sept_page_add() -> tdx_mem_page_add().
- open code tdx_measure_page() into tdx_mem_page_add().
- remove the change of tools/arch/x86/include/uapi/asm/kvm.h.

v15 -> v16:
- add check if nr_pages isn't large with
  (nr_page << PAGE_SHIFT) >> PAGE_SHIFT

v14 -> v15:
- add a check if TD is finalized or not to tdx_init_mem_region()
- return -EAGAIN when partial population
---
 arch/x86/include/uapi/asm/kvm.h |   9 ++
 arch/x86/kvm/mmu/mmu.c          |   1 +
 arch/x86/kvm/vmx/tdx.c          | 160 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h          |   2 +
 4 files changed, 169 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 4000a2e087a8..9fda7c90b7b5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -572,6 +572,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -649,4 +650,12 @@ struct kvm_tdx_init_vm {
 	struct kvm_cpuid2 cpuid;
 };
 
+#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 26d215e85b76..fc258f112e73 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5663,6 +5663,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4cbcedff4f16..1a5a91b99de9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -591,6 +591,69 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn,
+			    enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_args out;
+	hpa_t source_pa;
+	bool measure;
+	u64 err;
+	int i;
+
+	/*
+	 * KVM_INIT_MEM_REGION, tdx_init_mem_region(), supports only 4K page
+	 * because tdh_mem_page_add() supports only 4K page.
+	 */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	/*
+	 * In case of TDP MMU, fault handler can run concurrently.  Note
+	 * 'source_pa' is a TD scope variable, meaning if there are multiple
+	 * threads reaching here with all needing to access 'source_pa', it
+	 * will break.  However fortunately this won't happen, because below
+	 * TDH_MEM_PAGE_ADD code path is only used when VM is being created
+	 * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl (which
+	 * always uses vcpu 0's page table and protected by vcpu->mutex).
+	 */
+	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
+		tdx_unpin(kvm, pfn);
+		return -EINVAL;
+	}
+
+	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
+	measure = kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION;
+	kvm_tdx->source_pa = INVALID_PAGE;
+
+	do {
+		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, source_pa,
+				       &out);
+		/*
+		 * This path is executed during populating initial guest memory
+		 * image. i.e. before running any vcpu.  Race is rare.
+		 */
+	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
+		tdx_unpin(kvm, pfn);
+		return -EIO;
+	} else if (measure) {
+		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+			err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
+			if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
+				pr_tdx_error(TDH_MR_EXTEND, err, &out);
+				break;
+			}
+		}
+	}
+
+	return 0;
+
+}
+
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
@@ -613,9 +676,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
-
-	return 0;
+	return tdx_mem_page_add(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1322,6 +1383,96 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
 	tdx_track(vcpu->kvm);
 }
 
+#define TDX_SEPT_PFERR	(PFERR_WRITE_MASK | PFERR_GUEST_ENC_MASK)
+
+static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_mem_region region;
+	struct kvm_vcpu *vcpu;
+	struct page *page;
+	int idx, ret = 0;
+	bool added = false;
+
+	/* Once TD is finalized, the initial guest memory is fixed. */
+	if (is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	/* The BSP vCPU must be created before initializing memory regions. */
+	if (!atomic_read(&kvm->online_vcpus))
+		return -EINVAL;
+
+	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
+		return -EINVAL;
+
+	if (copy_from_user(&region, (void __user *)cmd->data, sizeof(region)))
+		return -EFAULT;
+
+	/* Sanity check */
+	if (!IS_ALIGNED(region.source_addr, PAGE_SIZE) ||
+	    !IS_ALIGNED(region.gpa, PAGE_SIZE) ||
+	    !region.nr_pages ||
+	    region.nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
+	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
+	    !kvm_is_private_gpa(kvm, region.gpa) ||
+	    !kvm_is_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT)))
+		return -EINVAL;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (mutex_lock_killable(&vcpu->mutex))
+		return -EINTR;
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_mmu_reload(vcpu);
+
+	while (region.nr_pages) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		/* Pin the source page. */
+		ret = get_user_pages_fast(region.source_addr, 1, 0, &page);
+		if (ret < 0)
+			break;
+		if (ret != 1) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		kvm_tdx->source_pa = pfn_to_hpa(page_to_pfn(page)) |
+				     (cmd->flags & KVM_TDX_MEASURE_MEMORY_REGION);
+
+		ret = kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_PFERR,
+					   PG_LEVEL_4K);
+		put_page(page);
+		if (ret)
+			break;
+
+		region.source_addr += PAGE_SIZE;
+		region.gpa += PAGE_SIZE;
+		region.nr_pages--;
+		added = true;
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	mutex_unlock(&vcpu->mutex);
+
+	if (added && region.nr_pages > 0)
+		ret = -EAGAIN;
+	if (copy_to_user((void __user *)cmd->data, &region, sizeof(region)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1341,6 +1492,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_INIT_MEM_REGION:
+		r = tdx_init_mem_region(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 783ce329d7da..d589a2caedfb 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,6 +17,8 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	hpa_t source_pa;
+
 	bool finalized;
 	atomic_t tdh_mem_track;
 
-- 
2.25.1


