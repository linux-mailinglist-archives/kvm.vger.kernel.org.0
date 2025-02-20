Return-Path: <kvm+bounces-38747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C241BA3E229
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D492F3B5522
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6AF2139B0;
	Thu, 20 Feb 2025 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BmtdaBAw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAB621CC7D
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071208; cv=none; b=EkaSUs7pdjEJGjwi9FyH5elWAdPr5ktk5sXMtDe36FTRE2QsGgU7olrcWA5iARYZXcyF04k1+dStd79j8848pp2umdzBLEVCPAWV8fcydlWCmmL9xnT1oR2Dg7Bm0awqWyuD8/7BabN57Fl/amFoIXQTm30QDRB3YOTE4mhexHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071208; c=relaxed/simple;
	bh=VKFp8WlSLyYiESTl1y/92aIdbI/52iPf9W6R6cK3Tl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obK9+e2hHbydVRA5ZHReab/+gxMBiAAbfs0G5R43FDZ7suEjHk0a02NSkvKAWbSZtLUfqvwD8U9gHs0L9RlkW82kCEKwZ6I+N6gMBgVGHvw8e3f1tQih4uWfpef0QMK3IaR+r5DpXN5FXkxnl6RVBENyKZXrsTS0IcmS6WECRSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BmtdaBAw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ov2adn0i+9E8/WF3+1VTErS7R/vkRGsNMQFp+o/lZQc=;
	b=BmtdaBAwbNj2lZve3sgCVLCB5phULUX8upPA6cNpkDd8yzbr2Es9YEmz6uujY8UzJynU+0
	tIFEqUEfxrWD+WV3KOUiSof7DQfPdw9FLEeOLNMj2994iVk5qzamJwl1rXegyPLbB2oE+e
	lZmcLQ0FTkE2DYKbeKfwPzczXFcYlP8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-RG1BcHj1NlC4QTJKnp9AnQ-1; Thu,
 20 Feb 2025 12:06:39 -0500
X-MC-Unique: RG1BcHj1NlC4QTJKnp9AnQ-1
X-Mimecast-MFC-AGG-ID: RG1BcHj1NlC4QTJKnp9AnQ_1740071197
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FCC31800873;
	Thu, 20 Feb 2025 17:06:37 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 082BD19412A3;
	Thu, 20 Feb 2025 17:06:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 20/30] KVM: TDX: create/destroy VM structure
Date: Thu, 20 Feb 2025 12:05:54 -0500
Message-ID: <20250220170604.2279312-21-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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
 - Fix build issue in kvm-coco-queue
 - Init ret earlier to fix __tdx_td_init() error handling. (Chao)
 - Standardize -EAGAIN for __tdx_td_init() retry errors (Rick)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/kvm/Kconfig               |   2 +
 arch/x86/kvm/vmx/main.c            |  28 +-
 arch/x86/kvm/vmx/tdx.c             | 450 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h             |   4 +-
 arch/x86/kvm/vmx/x86_ops.h         |   6 +
 arch/x86/kvm/x86.c                 |   1 +
 8 files changed, 490 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 1eca04087cf4..bb909e6125b4 100644
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
index 0b7af5902ff7..831b20830a09 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1663,6 +1663,7 @@ struct kvm_x86_ops {
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
+	void (*vm_free)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
 	int (*vcpu_precreate)(struct kvm *kvm);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fe8cbee6f614..0d445a317f61 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -94,6 +94,8 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
+	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
+	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 69c65085f81a..b655a5051c13 100644
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
index 630d19114429..c270e2109d7d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -120,6 +120,280 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
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
+static void tdx_clear_page(struct page *page)
+{
+	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
+	void *dest = page_to_virt(page);
+	unsigned long i;
+
+	/*
+	 * The page could have been poisoned.  MOVDIR64B also clears
+	 * the poison bit so the kernel can safely use the page again.
+	 */
+	for (i = 0; i < PAGE_SIZE; i += 64)
+		movdir64b(dest + i, zero_page);
+	/*
+	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
+	 * from seeing potentially poisoned cache.
+	 */
+	__mb();
+}
+
+/* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
+static int __tdx_reclaim_page(struct page *page)
+{
+	u64 err, rcx, rdx, r8;
+	int i;
+
+	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
+		err = tdh_phymem_page_reclaim(page, &rcx, &rdx, &r8);
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
+static int tdx_reclaim_page(struct page *page)
+{
+	int r;
+
+	r = __tdx_reclaim_page(page);
+	if (!r)
+		tdx_clear_page(page);
+	return r;
+}
+
+
+/*
+ * Reclaim the TD control page(s) which are crypto-protected by TDX guest's
+ * private KeyID.  Assume the cache associated with the TDX private KeyID has
+ * been flushed.
+ */
+static void tdx_reclaim_control_page(struct page *ctrl_page)
+{
+	/*
+	 * Leak the page if the kernel failed to reclaim the page.
+	 * The kernel cannot use it safely anymore.
+	 */
+	if (tdx_reclaim_page(ctrl_page))
+		return;
+
+	__free_page(ctrl_page);
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
+	if (!kvm_tdx->td.tdr_page) {
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
+	err = tdh_mng_key_freeid(&kvm_tdx->td);
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
+	if (kvm_tdx->td.tdcs_pages) {
+		for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
+			if (!kvm_tdx->td.tdcs_pages[i])
+				continue;
+
+			tdx_reclaim_control_page(kvm_tdx->td.tdcs_pages[i]);
+		}
+		kfree(kvm_tdx->td.tdcs_pages);
+		kvm_tdx->td.tdcs_pages = NULL;
+	}
+
+	if (!kvm_tdx->td.tdr_page)
+		return;
+
+	if (__tdx_reclaim_page(kvm_tdx->td.tdr_page))
+		return;
+
+	/*
+	 * Use a SEAMCALL to ask the TDX module to flush the cache based on the
+	 * KeyID. TDX module may access TDR while operating on TD (Especially
+	 * when it is reclaiming TDCS).
+	 */
+	err = tdh_phymem_page_wbinvd_tdr(&kvm_tdx->td);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+		return;
+	}
+	tdx_clear_page(kvm_tdx->td.tdr_page);
+
+	__free_page(kvm_tdx->td.tdr_page);
+	kvm_tdx->td.tdr_page = NULL;
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
+	err = tdh_mng_key_config(&kvm_tdx->td);
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
@@ -168,6 +442,177 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+static int __tdx_td_init(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	cpumask_var_t packages;
+	struct page **tdcs_pages = NULL;
+	struct page *tdr_page;
+	int ret, i;
+	u64 err;
+
+	ret = tdx_guest_keyid_alloc();
+	if (ret < 0)
+		return ret;
+	kvm_tdx->hkid = ret;
+
+	ret = -ENOMEM;
+
+	tdr_page = alloc_page(GFP_KERNEL);
+	if (!tdr_page)
+		goto free_hkid;
+
+	kvm_tdx->td.tdcs_nr_pages = tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
+	tdcs_pages = kcalloc(kvm_tdx->td.tdcs_nr_pages, sizeof(*kvm_tdx->td.tdcs_pages),
+			     GFP_KERNEL | __GFP_ZERO);
+	if (!tdcs_pages)
+		goto free_tdr;
+
+	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
+		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		if (!tdcs_pages[i])
+			goto free_tdcs;
+	}
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		goto free_tdcs;
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
+	kvm_tdx->td.tdr_page = tdr_page;
+	err = tdh_mng_create(&kvm_tdx->td, kvm_tdx->hkid);
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
+	kvm_tdx->td.tdcs_pages = tdcs_pages;
+	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
+		err = tdh_mng_addcx(&kvm_tdx->td, tdcs_pages[i]);
+		if (err == TDX_RND_NO_ENTROPY) {
+			/* Here it's hard to allow userspace to retry. */
+			ret = -EAGAIN;
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
+	for (; i < kvm_tdx->td.tdcs_nr_pages; i++) {
+		if (tdcs_pages[i]) {
+			__free_page(tdcs_pages[i]);
+			tdcs_pages[i] = NULL;
+		}
+	}
+	if (!kvm_tdx->td.tdcs_pages)
+		kfree(tdcs_pages);
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
+	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
+		if (tdcs_pages[i])
+			__free_page(tdcs_pages[i]);
+	}
+	kfree(tdcs_pages);
+	kvm_tdx->td.tdcs_pages = NULL;
+
+free_tdr:
+	if (tdr_page)
+		__free_page(tdr_page);
+	kvm_tdx->td.tdr_page = 0;
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
@@ -322,6 +767,11 @@ int __init tdx_bringup(void)
 	if (!enable_tdx)
 		return 0;
 
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
+		pr_err("MOVDIR64B is reqiured for TDX\n");
+		goto success_disable_tdx;
+	}
+
 	if (!kvm_can_support_tdx()) {
 		pr_err("tdx: no TDX private KeyIDs available\n");
 		goto success_disable_tdx;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index abe77ceddb9f..8102461f775d 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -13,7 +13,9 @@ extern bool enable_tdx;
 
 struct kvm_tdx {
 	struct kvm kvm;
-	/* TDX specific members follow. */
+	int hkid;
+
+	struct tdx_td td;
 };
 
 struct vcpu_tdx {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2c87a8e7bddc..917473c6bf3c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -122,8 +122,14 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
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
index 374d89e6663f..e0b9b845df58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12884,6 +12884,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	static_call_cond(kvm_x86_vm_free)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
-- 
2.43.5



