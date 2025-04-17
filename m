Return-Path: <kvm+bounces-43582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F88A91D99
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 15:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51D613B9CA4
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 13:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7252D24633D;
	Thu, 17 Apr 2025 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d62AULNF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D484324503A;
	Thu, 17 Apr 2025 13:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744896006; cv=none; b=qJ/hXQ33UAqXPI9D/vsroqTDMOpHMQ+mYHzC5dsgRL1ntdy8xfASHG8RXUf2QSBwhnXJcruQU20Oymy1lv0BXaMMt3pof/FCe4/2Iq68BY4ugLTkYgkz5J0hNWw3zBOxgcsevZ4+6RDQ1fxOUTjTOyaEi22LI9Rkz1zamHEWuMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744896006; c=relaxed/simple;
	bh=ZpKmpUKBjMZXBbjXZcDXAx1IMWF1ABeWVMj3xH17rpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2EeC+mT3Oy74aDW0sU4zO7hGtxsHCXwn940VHwvVnleIsPxV6JYBhTOtV4BxPeq3mMpP6M2jypucsnu4tcV8GeA+MyravmRLz3O997Po/t4FUppc7vsPSML9a+Cv53IzwL7P+NEMoV1NmBPyMqt7ZWZZR303kQw0l0eojPBFwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d62AULNF; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744896005; x=1776432005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZpKmpUKBjMZXBbjXZcDXAx1IMWF1ABeWVMj3xH17rpw=;
  b=d62AULNF03GMoLpb5+JYQcS6xCTxQuXU8M2bJIX9ymFjMCPzBxhPLI/r
   7JcxMfLD3iALvfDKWoGowggsRUvJb+FVJNsHF82v2iriAkNO2+E8PpVl3
   08hTfq99qdP7vnOolVrusvVct7KbdSgAXEHCPecEqpb3U7PS/ufmUvGZ4
   kzE/udkiy3B90mE03xOAAfhl4qmJGQ+A4YnSvX+StjkylEXjBRTmb8Bfa
   LrohtwSXKGJDk7rmjndsp7eC6yhkpKpaykZ0UngqWiX/gvs+Jk7aL3O5z
   SHSDCC4SHC44UJ1mqe/rMoNHUkESALjif5+s90PGCQsfbYSBWB0dBl826
   Q==;
X-CSE-ConnectionGUID: pZPm0MPjQmCjc61G6G3Q7g==
X-CSE-MsgGUID: yjSLLSXwSriFwF3LR1sxvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="57852598"
X-IronPort-AV: E=Sophos;i="6.15,219,1739865600"; 
   d="scan'208";a="57852598"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 06:20:05 -0700
X-CSE-ConnectionGUID: vfA2SgW2Tcyw58bKgL4vBA==
X-CSE-MsgGUID: GlQvN1hRSTCuh/RtUGWVQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,219,1739865600"; 
   d="scan'208";a="131708221"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.254.135])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 06:20:00 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: mlevitsk@redhat.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Date: Thu, 17 Apr 2025 16:19:45 +0300
Message-ID: <20250417131945.109053-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250417131945.109053-1-adrian.hunter@intel.com>
References: <20250417131945.109053-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
which enables more efficient reclaim of private memory.

Private memory is removed from MMU/TDP when guest_memfds are closed. If
the HKID has not been released, the TDX VM is still in RUNNABLE state,
so pages must be removed using "Dynamic Page Removal" procedure (refer
TDX Module Base spec) which involves a number of steps:
	Block further address translation
	Exit each VCPU
	Clear Secure EPT entry
	Flush/write-back/invalidate relevant caches

However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
where all TDX VM pages are effectively unmapped, so pages can be reclaimed
directly.

Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
reclaim time.  For example:

	VCPUs	Size (GB)	Before (secs)	After (secs)
	 4	 18		  72		 24
	32	107		 517		134
	64	400		5539		467

[Adrian: wrote commit message, added KVM_TDX_TERMINATE_VM documentation,
 and moved cpus_read_lock() inside kvm->lock for consistency as reported
 by lockdep]

Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 16 ++++++
 arch/x86/include/uapi/asm/kvm.h          |  1 +
 arch/x86/kvm/vmx/tdx.c                   | 63 +++++++++++++++++-------
 3 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index de41d4c01e5c..e5d4d9cf4cf2 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
           KVM_TDX_INIT_MEM_REGION,
           KVM_TDX_FINALIZE_VM,
           KVM_TDX_GET_CPUID,
+          KVM_TDX_TERMINATE_VM,
 
           KVM_TDX_CMD_NR_MAX,
   };
@@ -214,6 +215,21 @@ struct kvm_cpuid2.
 	  __u32 padding[3];
   };
 
+KVM_TDX_TERMINATE_VM
+-------------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Release Host Key ID (HKID) to allow more efficient reclaim of private memory.
+After this, the TD is no longer in a runnable state.
+
+Using KVM_TDX_TERMINATE_VM is optional.
+
+- id: KVM_TDX_TERMINATE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
 KVM TDX creation flow
 =====================
 In addition to the standard KVM flow, new TDX ioctls need to be called.  The
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 225a12e0d5d6..a2f973e1d75d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -939,6 +939,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
+	KVM_TDX_TERMINATE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..5763a70d1ec6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -472,7 +472,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
 		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
 }
 
-void tdx_mmu_release_hkid(struct kvm *kvm)
+static void __tdx_release_hkid(struct kvm *kvm, bool terminate)
 {
 	bool packages_allocated, targets_allocated;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -485,10 +485,11 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	if (!is_hkid_assigned(kvm_tdx))
 		return;
 
+	if (KVM_BUG_ON(refcount_read(&kvm->users_count) && !terminate, kvm))
+		return;
+
 	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
 	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
-	cpus_read_lock();
-
 	kvm_for_each_vcpu(j, vcpu, kvm)
 		tdx_flush_vp_on_cpu(vcpu);
 
@@ -500,14 +501,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 */
 	mutex_lock(&tdx_lock);
 
-	/*
-	 * Releasing HKID is in vm_destroy().
-	 * After the above flushing vps, there should be no more vCPU
-	 * associations, as all vCPU fds have been released at this stage.
-	 */
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
-	if (err == TDX_FLUSHVP_NOT_DONE)
-		goto out;
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
 		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
@@ -515,6 +509,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -539,14 +534,20 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
-	cpus_read_unlock();
 	free_cpumask_var(targets);
 	free_cpumask_var(packages);
 }
 
+void tdx_mmu_release_hkid(struct kvm *kvm)
+{
+	cpus_read_lock();
+	__tdx_release_hkid(kvm, false);
+	cpus_read_unlock();
+}
+
 static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1789,13 +1790,13 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
+		WARN_ON_ONCE(!kvm->vm_dead);
+		ret = tdx_reclaim_page(page);
+		if (!ret)
+			tdx_unpin(kvm, page);
+		return ret;
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2790,6 +2791,27 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_terminate_vm(struct kvm *kvm)
+{
+	int r = 0;
+
+	guard(mutex)(&kvm->lock);
+	cpus_read_lock();
+
+	if (!kvm_trylock_all_vcpus(kvm)) {
+		r = -EBUSY;
+		goto out;
+	}
+
+	kvm_vm_dead(kvm);
+	kvm_unlock_all_vcpus(kvm);
+
+	__tdx_release_hkid(kvm, true);
+out:
+	cpus_read_unlock();
+	return r;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2805,6 +2827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	if (tdx_cmd.hw_error)
 		return -EINVAL;
 
+	if (tdx_cmd.id == KVM_TDX_TERMINATE_VM)
+		return tdx_terminate_vm(kvm);
+
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
-- 
2.43.0


