Return-Path: <kvm+bounces-30095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD899B6CAB
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:08:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0F0D1F21B1D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB806228021;
	Wed, 30 Oct 2024 19:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aS2CJfZY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391E421B433;
	Wed, 30 Oct 2024 19:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314876; cv=none; b=TgUSzmcyE3Ps+X7A3coa916SUDJ9psxGMC6mleijiwka7kcdNgl5+10DcvZ6jTQkg+9fjvvzE0mCAmIfRSWrl30FyknS6E+bQ/o4rVlgSR/l8vZbrLgNq0BLnculxlZd/pgktLPb3+UiLPJLfEvqBgRFCuUu33C9BN3XbD57q1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314876; c=relaxed/simple;
	bh=GKgUieIxvK4U5APsHBW7qMuw780AqPBpGdFDmp9XDHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBrJ8yFVb2vEs8Hjv6y/yO6cXsyXzvdjxCRnS+z3UaEybjHutWuMmd36VS1p9/IoImE+1ATa+AbuAxbopk3ZhcTkvEO+2OuIByPInQtdPNPwYya9Jil/Nco2WjzJGcoKr18wcaGSiZF9JsoFe1L9vvr8rtc1h18Hk3UJ6Tkp1tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aS2CJfZY; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314872; x=1761850872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GKgUieIxvK4U5APsHBW7qMuw780AqPBpGdFDmp9XDHw=;
  b=aS2CJfZYQ3oCmajlVuzdU8GAwI0JSQJlPcowgkKHLyl0rC27/aU2lcS6
   rma3/1exUq9SWAgJP8uK8pXHXgmK/NHJlMk8TGImp3B2YxoPO9mW8IZq5
   Qo3BeFStkkRHy7dFn0dspAAFcNSGa6R+y6dXBuisPFUnv5+9u2/ZGqG1x
   ci4ivJh6iBr+1TYj8JfbBCMb/Kbb8DE6rfhvzInRFBoKGCTZ30ERtwDhx
   G7kgHf9n/eza2M561WLASXtG7AHaNPOwZ9jv6+xC1DmzdxXmV3vemI59F
   fHN4lU0Kp4EMb6D3kmf4ZlN1ikhvbiuNFaQ3YixNLRuBpKhWvfCGgHQ75
   A==;
X-CSE-ConnectionGUID: MbXP5HxeTT6VGRalKV8fXg==
X-CSE-MsgGUID: /Sr8358OQlCIfxDapDvQYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678808"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678808"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:04 -0700
X-CSE-ConnectionGUID: 9GenwyJpSDawQWGUYVDh8Q==
X-CSE-MsgGUID: wvsHD7OJTN+g7nvfxZ8PxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499423"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 17/25] KVM: TDX: create/destroy VM structure
Date: Wed, 30 Oct 2024 12:00:30 -0700
Message-ID: <20241030190039.77971-18-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement managing the TDX private KeyID to implement, create, destroy
and free for a TDX guest.

When creating at TDX guest, assign a TDX private KeyID for the TDX guest
for memory encryption, and allocate pages for the guest. These are used
for the Trust Domain Root (TDR) and Trust Domain Control Structure (TDCS).

On destruction, free the allocated pages, and the KeyID.

Before tearing down the private page tables, TDX requires the guest TD to
be destroyed by reclaiming the KeyID. Do it at vm_destroy() kvm_x86_ops
hook.

Add a call for vm_free() at the end of kvm_arch_destroy_vm() because the
per-VM TDR needs to be freed after the KeyID.

Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
Comment: this SOB/developed-by chain is getting a bit long.

uAPI breakout v2:
 - Remove write_lock(&kvm->mmu_lock) in HKID release was moved and vCPUs
   should be destroyed (Isaku)
 - Drop include for tdx_ops.h (Xu)
 - Drop unncessary clearing of tdr_pa in __tdx_td_init() (Yuan)
 - Use is_td_created() in tdx_vm_free() (Nikolay)
 - Precalculate nr_tcds_pages (Nikolay)
 - fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Add TD state handling (Tony)

uAPI breakout v1:
 - Fix unnecessary include re-ordering (Chao)
 - Fix the unpaired curly brackets (Chao)
 - Drop the tdx_mng_key_config_lock  (Chao)
 - Drop unnecessary is_hkid_assigned() check (Chao)
 - Use KVM_GENERIC_PRIVATE_MEM and undo the removal of EXPERT (Binbin)
 - Drop the word typically from comments (Binbin)
 - Clarify comments for the need of global tdx_lock mutex (Kai)
 - Add function comments for tdx_clear_page() (Kai)
 - Clarify comments for tdx_clear_page() poisoned page (Kai)
 - Move and update comments for limitations of __tdx_reclaim_page() (Kai)
 - Drop comment related to "rare to contend" (Kai)
 - Drop comment related to TDR and target page (Tony)
 - Make code easier to read with line breaks between paragraphs (Kai)
 - Use cond_resched() retry (Kai)
 - Use for loop for retries (Tony)
 - Use switch to handle errors (Tony)
 - Drop loop for tdh_mng_key_config() (Tony)
 - Rename tdx_reclaim_control_page() td_page_pa to ctrl_page_pa (Kai)
 - Reorganize comments for tdx_reclaim_control_page() (Kai)
 - Use smp_func_do_phymem_cache_wb() naming to indicate SMP (Kai)
 - Use bool resume in smp_func_do_phymem_cache_wb() (Kai)
 - Add comment on retrying to smp_func_do_phymem_cache_wb() (Kai)
 - Move code change to tdx_module_setup() to __tdx_bringup() due to
   initializing is done in post hardware_setup() now and
   tdx_module_setup() is removed.  Remove the code to use API to read
   global metadata but use exported 'struct tdx_sysinfo' pointer.
 - Replace 'tdx_info->nr_tdcs_pages' with a wrapper
   tdx_sysinfo_nr_tdcs_pages() because the 'struct tdx_sysinfo' doesn't
   have nr_tdcs_pages directly.
 - Replace tdx_info->max_vcpus_per_td with the new exported pointer in
   tdx_vm_init().
 - Add comment to tdx_mmu_release_hkid() on KeyID allocated (Kai)
 - Update comments for tdx_mmu_release_hkid() for locking (Kai)
 - Clarify tdx_mmu_release_hkid() comments for freeing HKID (Kai)
 - Use KVM_BUG_ON() for SEAMCALLs in tdx_mmu_release_hkid() (Kai)
 - Use continue for loop in tdx_vm_free() (Kai)
 - Clarify comments in  tdx_vm_free() for reclaiming TDCS (Kai)
 - Use KVM_BUG_ON() for tdx_vm_free()
 - Prettify format with line breaks in tdx_vm_free() (Tony)
 - Prettify formatting for __tdx_td_init() with line breaks (Kai)
 - Simplify comments for __tdx_td_init() locking (Kai)
 - Update patch description (Kai)
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/kvm/Kconfig               |   2 +
 arch/x86/kvm/vmx/main.c            |  28 +-
 arch/x86/kvm/vmx/tdx.c             | 458 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h             |   7 +-
 arch/x86/kvm/vmx/x86_ops.h         |   6 +
 arch/x86/kvm/x86.c                 |   1 +
 8 files changed, 501 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f250137c837a..e7bd7867cb94 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -21,6 +21,7 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
+KVM_X86_OP_OPTIONAL(vm_free)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85ed576660ee..d8478e103f07 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1647,6 +1647,7 @@ struct kvm_x86_ops {
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
+	void (*vm_free)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
 	int (*vcpu_precreate)(struct kvm *kvm);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f09f13c01c6b..8d1c3f75028d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -92,6 +92,8 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
+	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
+	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6ed78deea543..ed4afa45b16b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -41,6 +41,28 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_vm_init(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return tdx_vm_init(kvm);
+
+	return vmx_vm_init(kvm);
+}
+
+static void vt_vm_destroy(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return tdx_mmu_release_hkid(kvm);
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
@@ -72,8 +94,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
-	.vm_destroy = vmx_vm_destroy,
+
+	.vm_init = vt_vm_init,
+	.vm_destroy = vt_vm_destroy,
+	.vm_free = vt_vm_free,
 
 	.vcpu_precreate = vmx_vcpu_precreate,
 	.vcpu_create = vmx_vcpu_create,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 253debbe685f..50217f601061 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -110,6 +110,285 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 	return 0;
 }
 
+/*
+ * Some SEAMCALLs acquire the TDX module globally, and can fail with
+ * TDX_OPERAND_BUSY.  Use a global mutex to serialize these SEAMCALLs.
+ */
+static DEFINE_MUTEX(tdx_lock);
+
+/* Maximum number of retries to attempt for SEAMCALLs. */
+#define TDX_SEAMCALL_RETRIES	10000
+
+static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
+{
+	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
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
+	 * The page could have been poisoned.  MOVDIR64B also clears
+	 * the poison bit so the kernel can safely use the page again.
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
+/* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
+static int __tdx_reclaim_page(hpa_t pa)
+{
+	u64 err, rcx, rdx, r8;
+	int i;
+
+	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
+		err = tdh_phymem_page_reclaim(pa, &rcx, &rdx, &r8);
+
+		/*
+		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
+		 * state.  i.e. destructing TD.
+		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
+		 * Because we're destructing TD, it's rare to contend with TDR.
+		 */
+		switch (err) {
+		case TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX:
+		case TDX_OPERAND_BUSY | TDX_OPERAND_ID_TDR:
+			cond_resched();
+			continue;
+		default:
+			goto out;
+		}
+	}
+
+out:
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, rcx, rdx, r8);
+		return -EIO;
+	}
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
+
+/*
+ * Reclaim the TD control page(s) which are crypto-protected by TDX guest's
+ * private KeyID.  Assume the cache associated with the TDX private KeyID has
+ * been flushed.
+ */
+static void tdx_reclaim_control_page(unsigned long ctrl_page_pa)
+{
+	/*
+	 * Leak the page if the kernel failed to reclaim the page.
+	 * The kernel cannot use it safely anymore.
+	 */
+	if (tdx_reclaim_page(ctrl_page_pa))
+		return;
+
+	free_page((unsigned long)__va(ctrl_page_pa));
+}
+
+static void smp_func_do_phymem_cache_wb(void *unused)
+{
+	u64 err = 0;
+	bool resume;
+	int i;
+
+	/*
+	 * TDH.PHYMEM.CACHE.WB flushes caches associated with any TDX private
+	 * KeyID on the package or core.  The TDX module may not finish the
+	 * cache flush but return TDX_INTERRUPTED_RESUMEABLE instead.  The
+	 * kernel should retry it until it returns success w/o rescheduling.
+	 */
+	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
+		resume = !!err;
+		err = tdh_phymem_cache_wb(resume);
+		switch (err) {
+		case TDX_INTERRUPTED_RESUMABLE:
+			continue;
+		case TDX_NO_HKID_READY_TO_WBCACHE:
+			err = TDX_SUCCESS; /* Already done by other thread */
+			fallthrough;
+		default:
+			goto out;
+		}
+	}
+
+out:
+	if (WARN_ON_ONCE(err))
+		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
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
+	/* KeyID has been allocated but guest is not yet configured */
+	if (!kvm_tdx->tdr_pa) {
+		tdx_hkid_free(kvm_tdx);
+		return;
+	}
+
+	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
+	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
+	cpus_read_lock();
+
+	/*
+	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global lock
+	 * and can fail with TDX_OPERAND_BUSY when it fails to get the lock.
+	 * Multiple TDX guests can be destroyed simultaneously. Take the
+	 * mutex to prevent it from getting error.
+	 */
+	mutex_lock(&tdx_lock);
+
+	/*
+	 * Releasing HKID is in vm_destroy().
+	 * After the above flushing vps, there should be no more vCPU
+	 * associations, as all vCPU fds have been released at this stage.
+	 */
+	for_each_online_cpu(i) {
+		if (packages_allocated &&
+		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
+					     packages))
+			continue;
+		if (targets_allocated)
+			cpumask_set_cpu(i, targets);
+	}
+	if (targets_allocated)
+		on_each_cpu_mask(targets, smp_func_do_phymem_cache_wb, NULL, true);
+	else
+		on_each_cpu(smp_func_do_phymem_cache_wb, NULL, true);
+	/*
+	 * In the case of error in smp_func_do_phymem_cache_wb(), the following
+	 * tdh_mng_key_freeid() will fail.
+	 */
+	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MNG_KEY_FREEID, err);
+		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
+		       kvm_tdx->hkid);
+	} else {
+		tdx_hkid_free(kvm_tdx);
+	}
+
+	mutex_unlock(&tdx_lock);
+	cpus_read_unlock();
+	free_cpumask_var(targets);
+	free_cpumask_var(packages);
+}
+
+static void tdx_reclaim_td_control_pages(struct kvm *kvm)
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
+		for (i = 0; i < kvm_tdx->nr_tdcs_pages; i++) {
+			if (!kvm_tdx->tdcs_pa[i])
+				continue;
+
+			tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);
+		}
+		kfree(kvm_tdx->tdcs_pa);
+		kvm_tdx->tdcs_pa = NULL;
+	}
+
+	if (!kvm_tdx->tdr_pa)
+		return;
+
+	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
+		return;
+
+	/*
+	 * Use a SEAMCALL to ask the TDX module to flush the cache based on the
+	 * KeyID. TDX module may access TDR while operating on TD (Especially
+	 * when it is reclaiming TDCS).
+	 */
+	err = tdh_phymem_page_wbinvd_tdr(kvm_tdx->tdr_pa);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+		return;
+	}
+	tdx_clear_page(kvm_tdx->tdr_pa);
+
+	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
+	kvm_tdx->tdr_pa = 0;
+}
+
+void tdx_vm_free(struct kvm *kvm)
+{
+	tdx_reclaim_td_control_pages(kvm);
+}
+
+static int tdx_do_tdh_mng_key_config(void *param)
+{
+	struct kvm_tdx *kvm_tdx = param;
+	u64 err;
+
+	/* TDX_RND_NO_ENTROPY related retries are handled by sc_retry() */
+	err = tdh_mng_key_config(kvm_tdx->tdr_pa);
+
+	if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
+		pr_tdx_error(TDH_MNG_KEY_CONFIG, err);
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
+	kvm->arch.has_private_mem = true;
+
+	/* Place holder for TDX specific logic. */
+	return __tdx_td_init(kvm);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
@@ -158,6 +437,180 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
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
+	kvm_tdx->nr_tdcs_pages = tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
+	tdcs_pa = kcalloc(kvm_tdx->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!tdcs_pa)
+		goto free_tdr;
+
+	for (i = 0; i < kvm_tdx->nr_tdcs_pages; i++) {
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
+
+	cpus_read_lock();
+
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
+	 * TDH.MNG.CREATE tries to grab the global TDX module and fails
+	 * with TDX_OPERAND_BUSY when it fails to grab.  Take the global
+	 * lock to prevent it from failure.
+	 */
+	mutex_lock(&tdx_lock);
+	kvm_tdx->tdr_pa = tdr_pa;
+	err = tdh_mng_create(kvm_tdx->tdr_pa, kvm_tdx->hkid);
+	mutex_unlock(&tdx_lock);
+
+	if (err == TDX_RND_NO_ENTROPY) {
+		ret = -EAGAIN;
+		goto free_packages;
+	}
+
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_CREATE, err);
+		ret = -EIO;
+		goto free_packages;
+	}
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
+		 * controller results in TDX_OPERAND_BUSY. No locking needed
+		 * beyond the cpus_read_lock() above as it serializes against
+		 * hotplug and the first online CPU of the package is always
+		 * used. We never have two CPUs in the same socket trying to
+		 * program the key.
+		 */
+		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
+				      kvm_tdx, true);
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
+	for (i = 0; i < kvm_tdx->nr_tdcs_pages; i++) {
+		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
+		if (err == TDX_RND_NO_ENTROPY) {
+			/* Here it's hard to allow userspace to retry. */
+			ret = -EBUSY;
+			goto teardown;
+		}
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_MNG_ADDCX, err);
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
+	/* Only free pages not yet added, so start at 'i' */
+	for (; i < kvm_tdx->nr_tdcs_pages; i++) {
+		if (tdcs_pa[i]) {
+			free_page((unsigned long)__va(tdcs_pa[i]));
+			tdcs_pa[i] = 0;
+		}
+	}
+	if (!kvm_tdx->tdcs_pa)
+		kfree(tdcs_pa);
+
+	tdx_mmu_release_hkid(kvm);
+	tdx_reclaim_td_control_pages(kvm);
+
+	return ret;
+
+free_packages:
+	cpus_read_unlock();
+	free_cpumask_var(packages);
+
+free_tdcs:
+	for (i = 0; i < kvm_tdx->nr_tdcs_pages; i++) {
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
+
+free_hkid:
+	tdx_hkid_free(kvm_tdx);
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -251,6 +704,11 @@ static int __init __tdx_bringup(void)
 {
 	int r;
 
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
+		pr_warn("MOVDIR64B is reqiured for TDX\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (!enable_ept) {
 		pr_err("Cannot enable TDX with EPT disabled.\n");
 		return -EINVAL;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index faed454385ca..e557a82bc882 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -12,7 +12,12 @@ extern bool enable_tdx;
 
 struct kvm_tdx {
 	struct kvm kvm;
-	/* TDX specific members follow. */
+
+	unsigned long tdr_pa;
+	unsigned long *tdcs_pa;
+
+	int hkid;
+	u8 nr_tdcs_pages;
 };
 
 struct vcpu_tdx {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 42901be70f9d..e7d5afce68f0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -119,8 +119,14 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
+int tdx_vm_init(struct kvm *kvm);
+void tdx_mmu_release_hkid(struct kvm *kvm);
+void tdx_vm_free(struct kvm *kvm);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
+static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
+static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
+static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d86a18a4195b..8a103c29dcd0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12883,6 +12883,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	static_call_cond(kvm_x86_vm_free)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
-- 
2.47.0


