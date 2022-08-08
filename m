Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BFE58BD62
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbiHGWDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHGWCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270EE657C;
        Sun,  7 Aug 2022 15:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909757; x=1691445757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXic3L2VIG7jM559YfwNSBOfDbJo43sER5hBbxKZhVI=;
  b=SxvqwFXoVNpb8QGVtC8dXtwZIvK5UYr0dztIHv/XujgcCO6MbhrYH8Cw
   Tw0ylldfbFZnRvCSBgd4g8mBykm3baK6Pj2D6ehVXJYLQtD0RvFCe8o6x
   OOpwE9eBVn/pnBQQIeeyxN6zP+NFleMqtbRQDuFveQYQyZmHMXW0FakKc
   aoCNKclgHnNtp+w5++CgZGccfpYRCIWGvTGQNwrFI+LxJNl+UdrXC1kO1
   VBKhaEQU0UavEGLJiuPpD8TIZbmAymDN/9LEn5vtO3Tf6FnLmB4JrbNGo
   6+rgS5rTeHyb6mdP2ru5iHY5osWfeUvYo9tdwLA/353GQG5I6o+o/8dQe
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224084"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224084"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682500"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 020/103] KVM: TDX: create/destroy VM structure
Date:   Sun,  7 Aug 2022 15:01:05 -0700
Message-Id: <810ce6dbd0330f06a80e05afa0a068b5f5b332f3.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

As the first step to create TDX guest, create/destroy VM struct.  Assign
TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
allocate extra pages for the TDX guest. On destruction, free allocated
pages, and HKID.

Before tearing down private page tables, TDX requires some resources of the
guest TD to be destroyed (i.e. keyID must have been reclaimed, etc).  Add
flush_shadow_all_private callback before tearing down private page tables
for it.

Add a second kvm_x86_ops hook in kvm_arch_destroy_vm() to support TDX's
destruction path, which needs to first put the VM into a teardown state,
then free per-vCPU resources, and finally free per-VM resources.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   2 +
 arch/x86/kvm/vmx/main.c            |  34 ++-
 arch/x86/kvm/vmx/tdx.c             | 364 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h             |   2 +
 arch/x86/kvm/vmx/x86_ops.h         |  11 +
 arch/x86/kvm/x86.c                 |   8 +
 7 files changed, 420 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3857bff6949c..968e5ba1e4e6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -21,7 +21,9 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
+KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
 KVM_X86_OP_OPTIONAL(vm_destroy)
+KVM_X86_OP_OPTIONAL(vm_free)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a371f806f6d8..7a8a3d76346e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1458,7 +1458,9 @@ struct kvm_x86_ops {
 	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
+	void (*flush_shadow_all_private)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
+	void (*vm_free)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
 	int (*vcpu_precreate)(struct kvm *kvm);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 47bfa94e538e..6a93b19a8b06 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -39,18 +39,44 @@ static int __init vt_post_hardware_enable_setup(void)
 	return 0;
 }
 
+static void vt_hardware_unsetup(void)
+{
+	tdx_hardware_unsetup();
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
+		return tdx_mmu_release_hkid(kvm);
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
+		return tdx_vm_free(kvm);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
-	.hardware_unsetup = vmx_hardware_unsetup,
+	.hardware_unsetup = vt_hardware_unsetup,
 	.check_processor_compatibility = vmx_check_processor_compatibility,
 
 	.hardware_enable = vmx_hardware_enable,
@@ -60,7 +86,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vt_vm_init,
-	.vm_destroy = vmx_vm_destroy,
+	.flush_shadow_all_private = vt_flush_shadow_all_private,
+	.vm_destroy = vt_vm_destroy,
+	.vm_free = vt_vm_free,
 
 	.vcpu_precreate = vmx_vcpu_precreate,
 	.vcpu_create = vmx_vcpu_create,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 386bb2e86b77..4e6c3bc99777 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -31,6 +31,353 @@ struct tdx_capabilities {
 /* Capabilities of KVM + the TDX module. */
 static struct tdx_capabilities tdx_caps;
 
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
+	return kvm_tdx->tdr.added;
+}
+
+static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
+{
+	tdx_keyid_free(kvm_tdx->hkid);
+	kvm_tdx->hkid = -1;
+}
+
+static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->hkid > 0;
+}
+
+static void tdx_clear_page(unsigned long page)
+{
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
+	unsigned long i;
+
+	/*
+	 * Zeroing the page is only necessary for systems with MKTME-i:
+	 * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
+	 * required to clear/write the page with new keyid to prevent integrity
+	 * error when read on the page with new keyid.
+	 */
+	if (!static_cpu_has(X86_FEATURE_MOVDIR64B))
+		return;
+
+	for (i = 0; i < 4096; i += 64)
+		/* MOVDIR64B [rdx], es:rdi */
+		asm (".byte 0x66, 0x0f, 0x38, 0xf8, 0x3a"
+		     : : "d" (zero_page), "D" (page + i) : "memory");
+}
+
+static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
+{
+	struct tdx_module_output out;
+	u64 err;
+
+	err = tdh_phymem_page_reclaim(pa, &out);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
+		return -EIO;
+	}
+
+	if (do_wb) {
+		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			return -EIO;
+		}
+	}
+
+	tdx_clear_page(va);
+	return 0;
+}
+
+static int tdx_alloc_td_page(struct tdx_td_page *page)
+{
+	page->va = __get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!page->va)
+		return -ENOMEM;
+
+	page->pa = __pa(page->va);
+	return 0;
+}
+
+static void tdx_mark_td_page_added(struct tdx_td_page *page)
+{
+	WARN_ON_ONCE(page->added);
+	page->added = true;
+}
+
+static void tdx_reclaim_td_page(struct tdx_td_page *page)
+{
+	if (page->added) {
+		/*
+		 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
+		 * assigned to the TD.  Here the cache associated to the TD
+		 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
+		 * cache doesn't need to be flushed again.
+		 */
+		if (tdx_reclaim_page(page->va, page->pa, false, 0))
+			return;
+
+		page->added = false;
+	}
+	free_page(page->va);
+}
+
+static int tdx_do_tdh_phymem_cache_wb(void *param)
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
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+void tdx_mmu_release_hkid(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	cpumask_var_t packages;
+	bool cpumask_allocated;
+	u64 err;
+	int ret;
+	int i;
+
+	if (!is_hkid_assigned(kvm_tdx))
+		return;
+
+	if (!is_td_created(kvm_tdx))
+		goto free_hkid;
+
+	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
+	cpus_read_lock();
+	for_each_online_cpu(i) {
+		if (cpumask_allocated &&
+			cpumask_test_and_set_cpu(topology_physical_package_id(i),
+						packages))
+			continue;
+
+		/*
+		 * We can destroy multiple the guest TDs simultaneously.
+		 * Prevent tdh_phymem_cache_wb from returning TDX_BUSY by
+		 * serialization.
+		 */
+		mutex_lock(&tdx_lock);
+		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
+		mutex_unlock(&tdx_lock);
+		if (ret)
+			break;
+	}
+	cpus_read_unlock();
+	free_cpumask_var(packages);
+
+	mutex_lock(&tdx_lock);
+	err = tdh_mng_key_freeid(kvm_tdx->tdr.pa);
+	mutex_unlock(&tdx_lock);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
+		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
+			kvm_tdx->hkid);
+		return;
+	}
+
+free_hkid:
+	tdx_hkid_free(kvm_tdx);
+}
+
+void tdx_vm_free(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	int i;
+
+	/* Can't reclaim or free TD pages if teardown failed. */
+	if (is_hkid_assigned(kvm_tdx))
+		return;
+
+	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
+		tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
+	kfree(kvm_tdx->tdcs);
+
+	/*
+	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
+	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
+	 * TDX global HKID is needed.
+	 */
+	if (kvm_tdx->tdr.added &&
+		tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, true,
+				tdx_global_keyid))
+		return;
+
+	free_page(kvm_tdx->tdr.va);
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
+int tdx_vm_init(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	cpumask_var_t packages;
+	int ret, i;
+	u64 err;
+
+	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
+	kvm->max_vcpus = 0;
+
+	kvm_tdx->hkid = tdx_keyid_alloc();
+	if (kvm_tdx->hkid < 0)
+		return -EBUSY;
+
+	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
+	if (ret)
+		goto free_hkid;
+
+	kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages, sizeof(*kvm_tdx->tdcs),
+				GFP_KERNEL_ACCOUNT);
+	if (!kvm_tdx->tdcs)
+		goto free_tdr;
+	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
+		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
+		if (ret)
+			goto free_tdcs;
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
+	err = tdh_mng_create(kvm_tdx->tdr.pa, kvm_tdx->hkid);
+	mutex_unlock(&tdx_lock);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
+		ret = -EIO;
+		goto free_tdcs;
+	}
+	tdx_mark_td_page_added(&kvm_tdx->tdr);
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto free_tdcs;
+	}
+	cpus_read_lock();
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
+				      &kvm_tdx->tdr.pa, true);
+		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
+		if (ret)
+			break;
+	}
+	cpus_read_unlock();
+	free_cpumask_var(packages);
+	if (ret)
+		goto teardown;
+
+	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
+		err = tdh_mng_addcx(kvm_tdx->tdr.pa, kvm_tdx->tdcs[i].pa);
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
+			ret = -EIO;
+			goto teardown;
+		}
+		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
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
+	tdx_mmu_release_hkid(kvm);
+	tdx_vm_free(kvm);
+	return ret;
+
+free_tdcs:
+	/* @i points at the TDCS page that failed allocation. */
+	for (--i; i >= 0; i--)
+		free_page(kvm_tdx->tdcs[i].va);
+	kfree(kvm_tdx->tdcs);
+free_tdr:
+	free_page(kvm_tdx->tdr.va);
+free_hkid:
+	tdx_hkid_free(kvm_tdx);
+	return ret;
+}
+
 int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
@@ -78,6 +425,9 @@ bool tdx_is_vm_type_supported(unsigned long type)
 
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
+	int max_pkgs;
+	int i;
+
 	if (!enable_ept) {
 		pr_warn("Cannot enable TDX with EPT disabled\n");
 		return -EINVAL;
@@ -88,8 +438,22 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 		return -ENODEV;
 	}
 
+	max_pkgs = topology_max_packages();
+	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
+				   GFP_KERNEL);
+	if (!tdx_mng_key_config_lock)
+		return -ENOMEM;
+	for (i = 0; i < max_pkgs; i++)
+		mutex_init(&tdx_mng_key_config_lock[i]);
+
 	pr_info("kvm: TDX is supported. x86 phys bits %d\n",
 		boot_cpu_data.x86_phys_bits);
 
 	return 0;
 }
+
+void tdx_hardware_unsetup(void)
+{
+	/* kfree accepts NULL. */
+	kfree(tdx_mng_key_config_lock);
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f50d37f3fc9c..8058b6b153f8 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -19,6 +19,8 @@ struct kvm_tdx {
 
 	struct tdx_td_page tdr;
 	struct tdx_td_page *tdcs;
+
+	int hkid;
 };
 
 struct vcpu_tdx {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 3f194ed53f07..cf616f9f0a07 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -131,9 +131,20 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
+void tdx_hardware_unsetup(void);
+
+int tdx_vm_init(struct kvm *kvm);
+void tdx_mmu_release_hkid(struct kvm *kvm);
+void tdx_vm_free(struct kvm *kvm);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
+static inline void tdx_hardware_unsetup(void) {}
+
+static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
+static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
+static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
+static inline void tdx_vm_free(struct kvm *kvm) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bba34c8cf1a..0b8152d14052 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12248,6 +12248,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	static_call_cond(kvm_x86_vm_free)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
@@ -12512,6 +12513,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
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
 
-- 
2.25.1

