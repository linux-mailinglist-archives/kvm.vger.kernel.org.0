Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A116C6A3CD8
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjB0I1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjB0I0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:26:54 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66E81E5C1;
        Mon, 27 Feb 2023 00:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486301; x=1709022301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIYJoz3gOJ0fv60dErCRVxeDGvP4DZYUFM2kK0Hz8dQ=;
  b=B5QeTkhZk0xTNM3Mw1bG7v1R1Ze3prGoMs/8tY5xURuGgFHV6t6pt650
   uUYh/HplwH2FEhlO1sgrSXwzVhCsRgwoHBRgQEAVfatE2YWcKJlsfm4Ka
   j25mzHwKVAj4YaWjRm7rWZkgC0l3QYxFir+nnPKUEwyYCXlhs6Qo8NzIX
   7Ogv1x8/MJJC2G4zG7QV8HolthwkpEqUCdKdSy5SSyEfeEZ2+A1xhaKWS
   J5t5Bd55O7aCXhTrZQoqzY6XHb6lvrKY5fN3lSUJD6tqCM8C8w+KSfQXQ
   7XlQZb2B8M6Y189pHa4H3shFH56z3jSiznCucZUBDktGK2nksPlv59e3E
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608884"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608884"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242237"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242237"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:10 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 053/106] KVM: TDX: Create initial guest memory
Date:   Mon, 27 Feb 2023 00:22:52 -0800
Message-Id: <8bbd6c6cb0bb04de920a2c3f59f8aceb91b07c2c.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h       |   9 ++
 arch/x86/kvm/mmu/mmu.c                |   1 +
 arch/x86/kvm/vmx/tdx.c                | 156 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                |   2 +
 tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
 5 files changed, 172 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 212df13e4ab5..096ff9465fc0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -537,6 +537,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -605,4 +606,12 @@ struct kvm_tdx_init_vm {
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
index 6fef584c92c3..7a7ba4e4574c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5587,6 +5587,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f532f5c352f3..e503590f5e59 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -469,6 +469,21 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
+{
+	struct tdx_module_output out;
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
@@ -483,12 +498,10 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	struct tdx_module_output out;
+	hpa_t source_pa;
+	bool measure;
 	u64 err;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
-
 	/*
 	 * Because restricted mem doesn't support page migration with
 	 * a_ops->migrate_page (yet), no callback isn't triggered for KVM on
@@ -499,7 +512,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	get_page(pfn_to_page(pfn));
 
+	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (likely(is_td_finalized(kvm_tdx))) {
+		/* TODO: handle large pages. */
+		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+			return -EINVAL;
+
 		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
 		if (err == TDX_ERROR_SEPT_BUSY) {
 			tdx_unpin(kvm, pfn);
@@ -513,7 +531,45 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		return 0;
 	}
 
-	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
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
+	} while (err == TDX_ERROR_SEPT_BUSY);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
+		tdx_unpin(kvm, pfn);
+		return -EIO;
+	} else if (measure)
+		tdx_measure_page(kvm_tdx, gpa);
 
 	return 0;
 }
@@ -1177,6 +1233,93 @@ void tdx_flush_tlb(struct kvm_vcpu *vcpu)
 		cpu_relax();
 }
 
+#define TDX_SEPT_PFERR	PFERR_WRITE_MASK
+
+static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_mem_region region;
+	struct kvm_vcpu *vcpu;
+	struct page *page;
+	kvm_pfn_t pfn;
+	int idx, ret = 0;
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
+		pfn = kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_PFERR,
+					   PG_LEVEL_4K);
+		if (is_error_noslot_pfn(pfn) || kvm->vm_bugged)
+			ret = -EFAULT;
+		else
+			ret = 0;
+
+		put_page(page);
+		if (ret)
+			break;
+
+		region.source_addr += PAGE_SIZE;
+		region.gpa += PAGE_SIZE;
+		region.nr_pages--;
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	mutex_unlock(&vcpu->mutex);
+
+	if (copy_to_user((void __user *)cmd->data, &region, sizeof(region)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1193,6 +1336,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
index 7acd708bffa8..9d8445324841 100644
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
index 4bde72881dc1..ac0bef5e497d 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -537,6 +537,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -614,4 +615,12 @@ struct kvm_tdx_init_vm {
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

