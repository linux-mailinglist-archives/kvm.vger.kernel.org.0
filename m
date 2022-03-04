Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAA04CDF4B
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiCDUcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiCDUcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75201E6976;
        Fri,  4 Mar 2022 12:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425889; x=1677961889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Th1PMXo2bKjD7JnVPRXAlFglVJrPSpfRpkiskJNE6zY=;
  b=dJbD9clEoRZtyjfGkNvd2SkzjA8lWJ4eHzKeJ9DGQlQ8KUcMrOeu8IZe
   515AXKzZ3E0OgXVChrD0yUj8rq8l+ZcR7zF+/8QDS/tB74ndNwCLj9KhA
   TiQsNRcnQV81NMkZSr89fP5FLrSn4Pounr2l5jXKwZj7X19Jzk/hzljdX
   DlKKl99rpGvw0O6+X6TTxCsPi5rdgSumkFmF7ldTK/SBNsLGESVPGuVpy
   EimF0BX2dQ51oeqsfcN0bR73QR5uvJ32UW2yb+j3VpkmW6X8Z64UxWZs2
   b5U/B9Plbr0dVRPpEk/jtMe0PZ7+DwmeSbAbEoxEBpvDDm/zsjVNz+zus
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624237"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624237"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344426"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:30 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 060/104] KVM: TDX: Create initial guest memory
Date:   Fri,  4 Mar 2022 11:49:16 -0800
Message-Id: <676ece0bb9acb3bdc66c969c0f33520abbc1c265.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c                | 128 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |   2 +
 tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
 5 files changed, 149 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9702f0d95776..77f46260d868 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -533,6 +533,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -574,4 +575,12 @@ struct kvm_tdx_init_vm {
 	__u64 reserved[43];	/* must be zero for future extensibility */
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
index 72d8f200c819..23c954035227 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5226,6 +5226,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5d74ae001e4f..cd726c41d362 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -514,6 +514,21 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
+{
+	struct tdx_module_output out;
+	u64 err;
+	int i;
+
+	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+		err = tdh_mr_extend(kvm_tdx->tdr.pa, gpa + i, &out);
+		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
+			pr_tdx_error(TDH_MR_EXTEND, err, &out);
+			break;
+		}
+	}
+}
+
 static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 					enum pg_level level, kvm_pfn_t pfn)
 {
@@ -521,6 +536,7 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	struct tdx_module_output out;
+	hpa_t source_pa;
 	u64 err;
 
 	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
@@ -533,12 +549,33 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	/* Pin the page, TDX KVM doesn't yet support page migration. */
 	get_page(pfn_to_page(pfn));
 
+	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (likely(is_td_finalized(kvm_tdx))) {
 		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &out);
 		if (KVM_BUG_ON(err, kvm))
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
 		return;
 	}
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
+	WARN_ON(kvm_tdx->source_pa == INVALID_PAGE);
+	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
+
+	err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, hpa, source_pa, &out);
+	if (KVM_BUG_ON(err, kvm))
+		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
+	else if ((kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION))
+		tdx_measure_page(kvm_tdx, gpa);
+
+	kvm_tdx->source_pa = INVALID_PAGE;
 }
 
 static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -978,6 +1015,94 @@ void tdx_flush_tlb(struct kvm_vcpu *vcpu)
 		cpu_relax();
 }
 
+#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_USER_MASK)
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
+	if (cmd->metadata & ~KVM_TDX_MEASURE_MEMORY_REGION)
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
+				     (cmd->metadata & KVM_TDX_MEASURE_MEMORY_REGION);
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
@@ -995,6 +1120,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
index 906666c7c70b..bf9865a88991 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -28,6 +28,8 @@ struct kvm_tdx {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 
+	hpa_t source_pa;
+
 	bool finalized;
 	bool tdh_mem_track;
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 9702f0d95776..77f46260d868 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -533,6 +533,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -574,4 +575,12 @@ struct kvm_tdx_init_vm {
 	__u64 reserved[43];	/* must be zero for future extensibility */
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

