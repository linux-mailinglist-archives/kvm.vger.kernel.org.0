Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264657CAF9E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbjJPQgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjJPQfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:35:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CED86FB7;
        Mon, 16 Oct 2023 09:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473355; x=1729009355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aX9THh6vMdVVV0zZ9PrlLuHmpyJbFuKX1nOnJlonLv0=;
  b=dCe+sydYeWbB/MODeRAWZh1QxRSL7pQxotA+0LWI2YlrQNmB9ak/edoW
   waTHu/2mGoZm1fzmQdJk9+wecg4qUdt2IV0FCsNGBcj+nu4Tx87e4FXNy
   CEbVcAve3dll4HWLQnW+etvPBmaspyL/MKER+xkeaoZPyxSGr82LX2sX/
   DTMx6C9Nn0gzalgcVp7Bx8yW2b1wap2HJKO6/V5u4CR50PGdsRw4S/aen
   XM6X3QUzap274kJbbm0q0uVm7AtS4i6mrbXphgiKydow6z8gC7yZwu/lA
   nqdyOvBsfMCDz1/Avow0rjRp7iSl0u8AKpg+mnaobCPIIYLAKnqRlvjej
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825961"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825961"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126044"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126044"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:29 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v16 020/116] KVM: TDX: create/destroy VM structure
Date:   Mon, 16 Oct 2023 09:13:32 -0700
Message-Id: <83793a7bafa0e6c38f3b416e1b838e5b6765ba86.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

As the first step to create TDX guest, create/destroy VM struct.  Assign
TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
allocate extra pages for the TDX guest. On destruction, free allocated
pages, and HKID.

Before tearing down private page tables, TDX requires some resources of the
guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
mmu notifier release callback before tearing down private page tables for
it.

Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
because some per-VM TDX resources, e.g. TDR, need to be freed after other
TDX resources, e.g. HKID, were freed.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v16:
- Simplified tdx_reclaim_page()
- Reorganize the locking of tdx_release_hkid(), and use smp_call_mask()
  instead of smp_call_on_cpu() to hold spinlock to race with invalidation
  on releasing guest memfd
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   2 +
 arch/x86/kvm/Kconfig               |   2 +
 arch/x86/kvm/mmu/mmu.c             |   7 +
 arch/x86/kvm/vmx/main.c            |  35 ++-
 arch/x86/kvm/vmx/tdx.c             | 471 ++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h             |   6 +-
 arch/x86/kvm/vmx/x86_ops.h         |   8 +
 arch/x86/kvm/x86.c                 |   1 +
 9 files changed, 528 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 214dcaa3b384..d5a900842535 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -24,7 +24,9 @@ KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP_OPTIONAL(max_vcpus);
 KVM_X86_OP_OPTIONAL(vm_enable_cap)
 KVM_X86_OP(vm_init)
+KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
 KVM_X86_OP_OPTIONAL(vm_destroy)
+KVM_X86_OP_OPTIONAL(vm_free)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9dde92c8ee2f..f23557850c27 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1570,7 +1570,9 @@ struct kvm_x86_ops {
 	unsigned int vm_size;
 	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
 	int (*vm_init)(struct kvm *kvm);
+	void (*flush_shadow_all_private)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
+	void (*vm_free)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
 	int (*vcpu_precreate)(struct kvm *kvm);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8452ed0228cb..4a864dbaa982 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -92,6 +92,8 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
+	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
+	select KVM_PRIVATE_MEM if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bffa50927739..c3d0f8461e1c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6791,6 +6791,13 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	/*
+	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
+	 * tearing down private page tables, TDX requires some TD resources to
+	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
+	 * kvm_x86_flush_shadow_all_private() for this.
+	 */
+	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
 	kvm_mmu_zap_all(kvm);
 }
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5579557fa6f6..463ba7214392 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -63,14 +63,41 @@ static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 	return -EINVAL;
 }
 
+static void vt_hardware_unsetup(void)
+{
+	if (enable_tdx)
+		tdx_hardware_unsetup();
+	vmx_hardware_unsetup();
+}
+
 static int vt_vm_init(struct kvm *kvm)
 {
 	if (is_td(kvm))
-		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
+		return tdx_vm_init(kvm);
 
 	return vmx_vm_init(kvm);
 }
 
+static void vt_flush_shadow_all_private(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		tdx_mmu_release_hkid(kvm);
+}
+
+static void vt_vm_destroy(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return;
+
+	vmx_vm_destroy(kvm);
+}
+
+static void vt_vm_free(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		tdx_vm_free(kvm);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -93,7 +120,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.check_processor_compatibility = vmx_check_processor_compat,
 
-	.hardware_unsetup = vmx_hardware_unsetup,
+	.hardware_unsetup = vt_hardware_unsetup,
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
@@ -104,7 +131,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_enable_cap = vt_vm_enable_cap,
 	.vm_init = vt_vm_init,
-	.vm_destroy = vmx_vm_destroy,
+	.flush_shadow_all_private = vt_flush_shadow_all_private,
+	.vm_destroy = vt_vm_destroy,
+	.vm_free = vt_vm_free,
 
 	.vcpu_precreate = vmx_vcpu_precreate,
 	.vcpu_create = vmx_vcpu_create,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 331fbaa10d46..692619411da2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,9 +5,10 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
-#include "x86.h"
 #include "mmu.h"
 #include "tdx.h"
+#include "tdx_ops.h"
+#include "x86.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -47,6 +48,289 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 	return r;
 }
 
+struct tdx_info {
+	u8 nr_tdcs_pages;
+};
+
+/* Info about the TDX module. */
+static struct tdx_info tdx_info __ro_after_init;
+
+/*
+ * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
+ * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
+ * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
+ * spinning or waiting due to a constraint on execution time.  It's caller's
+ * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
+ * to avoid race in TDX module because the kernel knows better about scheduling.
+ */
+static DEFINE_MUTEX(tdx_lock);
+static struct mutex *tdx_mng_key_config_lock;
+
+static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
+{
+	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
+}
+
+static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->tdr_pa;
+}
+
+static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
+{
+	tdx_guest_keyid_free(kvm_tdx->hkid);
+	kvm_tdx->hkid = -1;
+}
+
+static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->hkid > 0;
+}
+
+static void tdx_clear_page(unsigned long page_pa)
+{
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
+	void *page = __va(page_pa);
+	unsigned long i;
+
+	/*
+	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
+	 * required to clear/write the page with new keyid to prevent integrity
+	 * error when read on the page with new keyid.
+	 *
+	 * clflush doesn't flush cache with HKID set.  The cache line could be
+	 * poisoned (even without MKTME-i), clear the poison bit.
+	 */
+	for (i = 0; i < PAGE_SIZE; i += 64)
+		movdir64b(page + i, zero_page);
+	/*
+	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
+	 * from seeing potentially poisoned cache.
+	 */
+	__mb();
+}
+
+static int __tdx_reclaim_page(hpa_t pa)
+{
+	struct tdx_module_args out;
+	u64 err;
+
+	do {
+		err = tdh_phymem_page_reclaim(pa, &out);
+		/*
+		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
+		 * state.  i.e. destructing TD.
+		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
+		 * Because we're destructing TD, it's rare to contend with TDR.
+		 */
+	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tdx_reclaim_page(hpa_t pa)
+{
+	int r;
+
+	r = __tdx_reclaim_page(pa);
+	if (!r)
+		tdx_clear_page(pa);
+	return r;
+}
+
+static void tdx_reclaim_td_page(unsigned long td_page_pa)
+{
+	WARN_ON_ONCE(!td_page_pa);
+
+	/*
+	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
+	 * assigned to the TD.  Here the cache associated to the TD
+	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
+	 * cache doesn't need to be flushed again.
+	 */
+	if (tdx_reclaim_page(td_page_pa))
+		/*
+		 * Leak the page on failure:
+		 * tdx_reclaim_page() returns an error if and only if there's an
+		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
+		 * incorrect concurrency in KVM, a TDX Module bug, etc.
+		 * Retrying at a later point is highly unlikely to be
+		 * successful.
+		 * No log here as tdx_reclaim_page() already did.
+		 */
+		return;
+	free_page((unsigned long)__va(td_page_pa));
+}
+
+static void tdx_do_tdh_phymem_cache_wb(void *unused)
+{
+	u64 err = 0;
+
+	do {
+		err = tdh_phymem_cache_wb(!!err);
+	} while (err == TDX_INTERRUPTED_RESUMABLE);
+
+	/* Other thread may have done for us. */
+	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
+		err = TDX_SUCCESS;
+	if (WARN_ON_ONCE(err))
+		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
+}
+
+void tdx_mmu_release_hkid(struct kvm *kvm)
+{
+	bool packages_allocated, targets_allocated;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	cpumask_var_t packages, targets;
+	u64 err;
+	int i;
+
+	if (!is_hkid_assigned(kvm_tdx))
+		return;
+
+	if (!is_td_created(kvm_tdx)) {
+		tdx_hkid_free(kvm_tdx);
+		return;
+	}
+
+	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
+	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
+	cpus_read_lock();
+
+	/*
+	 * We can destroy multiple the guest TDs simultaneously.  Prevent
+	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
+	 */
+	mutex_lock(&tdx_lock);
+
+	/*
+	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
+	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable.  Make the transition atomic
+	 * to other functions to operate private pages and Secure-EPT pages.
+	 *
+	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
+	 * This function is called via mmu notifier, mmu_release().
+	 * kvm_gmem_release() is called via fput() on process exit.
+	 */
+	write_lock(&kvm->mmu_lock);
+
+	for_each_online_cpu(i) {
+		if (packages_allocated &&
+		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
+					     packages))
+			continue;
+		if (targets_allocated)
+			cpumask_set_cpu(i, targets);
+	}
+	if (targets_allocated)
+		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, 1);
+	else
+		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, 1);
+	/*
+	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
+	 * tdh_mng_key_freeid() will fail.
+	 */
+
+	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
+		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
+		       kvm_tdx->hkid);
+	} else
+		tdx_hkid_free(kvm_tdx);
+
+	write_unlock(&kvm->mmu_lock);
+	mutex_unlock(&tdx_lock);
+	cpus_read_unlock();
+	free_cpumask_var(targets);
+	free_cpumask_var(packages);
+}
+
+void tdx_vm_free(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+	int i;
+
+	/*
+	 * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
+	 * heavily with TDX module.  Give up freeing TD pages.  As the function
+	 * already warned, don't warn it again.
+	 */
+	if (is_hkid_assigned(kvm_tdx))
+		return;
+
+	if (kvm_tdx->tdcs_pa) {
+		for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
+			if (kvm_tdx->tdcs_pa[i])
+				tdx_reclaim_td_page(kvm_tdx->tdcs_pa[i]);
+		}
+		kfree(kvm_tdx->tdcs_pa);
+		kvm_tdx->tdcs_pa = NULL;
+	}
+
+	if (!kvm_tdx->tdr_pa)
+		return;
+	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
+		return;
+	/*
+	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
+	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
+	 * TDX global HKID is needed.
+	 */
+	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
+						     tdx_global_keyid));
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+		return;
+	}
+	tdx_clear_page(kvm_tdx->tdr_pa);
+
+	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
+	kvm_tdx->tdr_pa = 0;
+}
+
+static int tdx_do_tdh_mng_key_config(void *param)
+{
+	hpa_t *tdr_p = param;
+	u64 err;
+
+	do {
+		err = tdh_mng_key_config(*tdr_p);
+
+		/*
+		 * If it failed to generate a random key, retry it because this
+		 * is typically caused by an entropy error of the CPU's random
+		 * number generator.
+		 */
+	} while (err == TDX_KEY_GENERATION_FAILED);
+
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int __tdx_td_init(struct kvm *kvm);
+
+int tdx_vm_init(struct kvm *kvm)
+{
+	/*
+	 * TDX has its own limit of the number of vcpus in addition to
+	 * KVM_MAX_VCPUS.
+	 */
+	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
+
+	/* Place holder for TDX specific logic. */
+	return __tdx_td_init(kvm);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -107,6 +391,167 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+static int __tdx_td_init(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	cpumask_var_t packages;
+	unsigned long *tdcs_pa = NULL;
+	unsigned long tdr_pa = 0;
+	unsigned long va;
+	int ret, i;
+	u64 err;
+
+	ret = tdx_guest_keyid_alloc();
+	if (ret < 0)
+		return ret;
+	kvm_tdx->hkid = ret;
+
+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!va)
+		goto free_hkid;
+	tdr_pa = __pa(va);
+
+	tdcs_pa = kcalloc(tdx_info.nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!tdcs_pa)
+		goto free_tdr;
+	for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
+		if (!va)
+			goto free_tdcs;
+		tdcs_pa[i] = __pa(va);
+	}
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto free_tdcs;
+	}
+	cpus_read_lock();
+	/*
+	 * Need at least one CPU of the package to be online in order to
+	 * program all packages for host key id.  Check it.
+	 */
+	for_each_present_cpu(i)
+		cpumask_set_cpu(topology_physical_package_id(i), packages);
+	for_each_online_cpu(i)
+		cpumask_clear_cpu(topology_physical_package_id(i), packages);
+	if (!cpumask_empty(packages)) {
+		ret = -EIO;
+		/*
+		 * Because it's hard for human operator to figure out the
+		 * reason, warn it.
+		 */
+#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
+		pr_warn_ratelimited(MSG_ALLPKG);
+		goto free_packages;
+	}
+
+	/*
+	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
+	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
+	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
+	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
+	 * caller to handle the contention.  This is because of time limitation
+	 * usable inside the TDX module and OS/VMM knows better about process
+	 * scheduling.
+	 *
+	 * APIs to acquire the lock of KOT:
+	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
+	 * TDH.PHYMEM.CACHE.WB.
+	 */
+	mutex_lock(&tdx_lock);
+	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
+	mutex_unlock(&tdx_lock);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
+		ret = -EIO;
+		goto free_packages;
+	}
+	kvm_tdx->tdr_pa = tdr_pa;
+
+	for_each_online_cpu(i) {
+		int pkg = topology_physical_package_id(i);
+
+		if (cpumask_test_and_set_cpu(pkg, packages))
+			continue;
+
+		/*
+		 * Program the memory controller in the package with an
+		 * encryption key associated to a TDX private host key id
+		 * assigned to this TDR.  Concurrent operations on same memory
+		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
+		 * mutex.
+		 */
+		mutex_lock(&tdx_mng_key_config_lock[pkg]);
+		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
+				      &kvm_tdx->tdr_pa, true);
+		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
+		if (ret)
+			break;
+	}
+	cpus_read_unlock();
+	free_cpumask_var(packages);
+	if (ret) {
+		i = 0;
+		goto teardown;
+	}
+
+	kvm_tdx->tdcs_pa = tdcs_pa;
+	for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
+		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
+			ret = -EIO;
+			goto teardown;
+		}
+	}
+
+	/*
+	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
+	 * ioctl() to define the configure CPUID values for the TD.
+	 */
+	return 0;
+
+	/*
+	 * The sequence for freeing resources from a partially initialized TD
+	 * varies based on where in the initialization flow failure occurred.
+	 * Simply use the full teardown and destroy, which naturally play nice
+	 * with partial initialization.
+	 */
+teardown:
+	for (; i < tdx_info.nr_tdcs_pages; i++) {
+		if (tdcs_pa[i]) {
+			free_page((unsigned long)__va(tdcs_pa[i]));
+			tdcs_pa[i] = 0;
+		}
+	}
+	if (!kvm_tdx->tdcs_pa)
+		kfree(tdcs_pa);
+	tdx_mmu_release_hkid(kvm);
+	tdx_vm_free(kvm);
+	return ret;
+
+free_packages:
+	cpus_read_unlock();
+	free_cpumask_var(packages);
+free_tdcs:
+	for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
+		if (tdcs_pa[i])
+			free_page((unsigned long)__va(tdcs_pa[i]));
+	}
+	kfree(tdcs_pa);
+	kvm_tdx->tdcs_pa = NULL;
+
+free_tdr:
+	if (tdr_pa)
+		free_page((unsigned long)__va(tdr_pa));
+	kvm_tdx->tdr_pa = 0;
+free_hkid:
+	if (is_hkid_assigned(kvm_tdx))
+		tdx_hkid_free(kvm_tdx);
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -150,9 +595,11 @@ static int __init tdx_module_setup(void)
 		return ret;
 	}
 
-	/* Sanitary check just in case. */
 	tdsysinfo = tdx_get_sysinfo();
 	WARN_ON(tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS);
+	tdx_info = (struct tdx_info) {
+		.nr_tdcs_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
+	};
 
 	return 0;
 }
@@ -195,13 +642,27 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	struct vmx_tdx_enabled vmx_tdx = {
 		.err = ATOMIC_INIT(0),
 	};
+	int max_pkgs;
 	int r = 0;
+	int i;
 
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
+		pr_warn("MOVDIR64B is reqiured for TDX\n");
+		return -EOPNOTSUPP;
+	}
 	if (!enable_ept) {
 		pr_warn("Cannot enable TDX with EPT disabled\n");
 		return -EINVAL;
 	}
 
+	max_pkgs = topology_max_packages();
+	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
+				   GFP_KERNEL);
+	if (!tdx_mng_key_config_lock)
+		return -ENOMEM;
+	for (i = 0; i < max_pkgs; i++)
+		mutex_init(&tdx_mng_key_config_lock[i]);
+
 	if (!zalloc_cpumask_var(&vmx_tdx.vmx_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
 		goto out;
@@ -222,3 +683,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 out:
 	return r;
 }
+
+void tdx_hardware_unsetup(void)
+{
+	/* kfree accepts NULL. */
+	kfree(tdx_mng_key_config_lock);
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 22c0b57f69ca..ae117f864cfb 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -8,7 +8,11 @@
 
 struct kvm_tdx {
 	struct kvm kvm;
-	/* TDX specific members follow. */
+
+	unsigned long tdr_pa;
+	unsigned long *tdcs_pa;
+
+	int hkid;
 };
 
 struct vcpu_tdx {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c3fc3148dcf3..01f3b02a5b46 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -136,18 +136,26 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+void tdx_hardware_unsetup(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 
 int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
+int tdx_vm_init(struct kvm *kvm);
+void tdx_mmu_release_hkid(struct kvm *kvm);
+void tdx_vm_free(struct kvm *kvm);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
+static inline void tdx_hardware_unsetup(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 
 static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 {
 	return -EINVAL;
 };
+static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
+static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
+static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1354274ffe4..fbd80f2e403e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12538,6 +12538,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	static_call_cond(kvm_x86_vm_free)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
-- 
2.25.1

