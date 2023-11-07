Return-Path: <kvm+bounces-960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A06527E42A1
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 163D3B22EAA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0902347D6;
	Tue,  7 Nov 2023 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G/eqYTLC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D03328C2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:01:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78843C06;
	Tue,  7 Nov 2023 06:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369180; x=1730905180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sIkR/CJaXcbYffe924zsjXbKwd2ZpHVn7P1xYJD/unQ=;
  b=G/eqYTLCz9L/sX1BstbyQA46dAYUGLE88tQdrlSHRiDJvog/Kle/6MjV
   qLysYJsAEWcygpWpwNyPVkWj7Cm2KNAMLOa6QOO1fRghV7B9s5LBuKwr7
   wBLIJEZTJ4vu9LG5apB7KPDVh0cVFdw75WRNWqn3lTnLKK71y67i6LBQt
   VyxKwF4nLlcDoEuWJ/rJAvx/za3DcnBUNHyex1QswNXT+IDywIvb/7lel
   9I9CtiO33CnK0pGkuOhWEAc/US9Yanffg88GxOba5Tqk456N4OdJdgUgk
   hmg6pxbeCXweVYWF27htLw/RLBT2SIfdOx8OYZKuY+TTnu1mJSByPXtYd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462404"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462404"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851439"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:17 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	gkirkpatrick@google.com
Subject: [PATCH v17 059/116] KVM: TDX: Create initial guest memory
Date: Tue,  7 Nov 2023 06:56:25 -0800
Message-Id: <e8fdc92439efeed0ee05f39b1cd2dc1023014c11.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
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
v15 -> v16:
- add check if nr_pages isn't large with
  (nr_page << PAGE_SHIFT) >> PAGE_SHIFT

v14 -> v15:
- add a check if TD is finalized or not to tdx_init_mem_region()
- return -EAGAIN when partial population
---
 arch/x86/include/uapi/asm/kvm.h       |   9 ++
 arch/x86/kvm/mmu/mmu.c                |   1 +
 arch/x86/kvm/vmx/tdx.c                | 167 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                |   2 +
 tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
 5 files changed, 185 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 311a7894b712..a1815fcbb0be 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -572,6 +572,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -645,4 +646,12 @@ struct kvm_tdx_init_vm {
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
index 12f90116358e..18836345c99a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5667,6 +5667,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 27714d07bbff..2b635fcf11b4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -470,6 +470,21 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
+{
+	struct tdx_module_args out;
+	u64 err;
+	int i;
+
+	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+		err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
+		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
+			pr_tdx_error(TDH_MR_EXTEND, err, &out);
+			break;
+		}
+	}
+}
+
 static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	struct page *page = pfn_to_page(pfn);
@@ -515,6 +530,61 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
+			     enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_args out;
+	hpa_t source_pa;
+	bool measure;
+	u64 err;
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
+	} else if (measure)
+		tdx_measure_page(kvm_tdx, gpa);
+
+	return 0;
+
+}
+
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
@@ -537,9 +607,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_sept_page_aug(kvm, gfn, level, pfn);
 
-	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
-
-	return 0;
+	return tdx_sept_page_add(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1247,6 +1315,96 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
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
@@ -1266,6 +1424,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
index 57ecb83e2f35..4ae9cd66cefc 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,6 +17,8 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	hpa_t source_pa;
+
 	bool finalized;
 	atomic_t tdh_mem_track;
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 83bd9e3118d1..a3408f6e1124 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -567,6 +567,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -648,4 +649,12 @@ struct kvm_tdx_init_vm {
 	};
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
-- 
2.25.1


