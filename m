Return-Path: <kvm+bounces-58057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B480FB875AD
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FF78528548
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F782F747C;
	Thu, 18 Sep 2025 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQn1eaqR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27296279918;
	Thu, 18 Sep 2025 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237783; cv=none; b=FOzxU+cJbnxv0iZC8zNRRs21+gwpQ8DdUzvs2KPLhf84/yf9SI0lmGJjp/HOlADDr0glPZiPZ1Mfiv6jf5RZrjrXIlp1LkCmuN0pL4J+pKrJcp2Bqtj81Iw90GNLj0Z90vxZ1Hpy5hLWhYVrFngK+MyxmKLOUpqlNv35KqYzhfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237783; c=relaxed/simple;
	bh=EpNSS8PIxQPO1CF60bTfVpZURcvN4Plh+JHoiHb8sME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1sMaTQ7HoHr+/D/V8Yc4/2/zJlxrqIqu1Z3SorLPkHLdGrtagq+XcSbUA8e9avaANJNo2ps/2AF5njgLpW91nyIt/OWkC8hH3n2pvACa2fa6xmuHaJHrF/h3E7dsrh7ONp2rCIIQbAfdEXOULSu7RMmwHiPzjnuPlAwDnSWndE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQn1eaqR; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237781; x=1789773781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EpNSS8PIxQPO1CF60bTfVpZURcvN4Plh+JHoiHb8sME=;
  b=BQn1eaqRHi3Qz8IQBfiszWFmX8fdweiknf207MI0bARv1DARr31TfZ1H
   a8zzTUUfXykfHVGr0O77UFEgfX4ftyIiJW9I7hHXYcgVTkQPtrtswwa7k
   CJ6rH/oe6IdIo4RZBI0Krc0DLnZeWh0aVAJRHg2Lh0GTxuQZSDmQOYlHa
   9GQ8Rs7zl45WSUIEt3p982HJRAC+82T+qXtkfNWVsPhO/fcM/da8QaS67
   GVkPVY2T2jhDpza9LzRnqqUsSJPyyGYl//+OP48wfUUmc2YUS4s0VOeO2
   PC/TBtu5KFcSa72v2YdFLHhVzGW6Jp9qdhbk+vPD80qOXva73CtgLbB9k
   w==;
X-CSE-ConnectionGUID: ZGfYExo4QiKD4rhiEb2f5Q==
X-CSE-MsgGUID: 0fYMus1XQT2Q8gze3Ckdqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735375"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735375"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:00 -0700
X-CSE-ConnectionGUID: hbfJrnE3Q8m4DEG2mDGezg==
X-CSE-MsgGUID: jnT556yiTS2KsyOHfUr4vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491394"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:22:59 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 02/16] x86/tdx: Add helpers to check return status codes
Date: Thu, 18 Sep 2025 16:22:10 -0700
Message-ID: <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The TDX error code has a complex structure. The upper 32 bits encode the
status code (higher level information), while the lower 32 bits provide
clues about the error, such as operand ID, CPUID leaf, MSR index, etc.

In practice, the kernel logic cares mostly about the status code. Whereas
the error details are more often dumped to warnings to be used as
debugging breadcrumbs. This results in a lot of code that masks the status
code and then checks the resulting value. Future code to support Dynamic
PAMT will add yet mode SEAMCALL error code checking. To prepare for this,
do some cleanup to reduce the boiler plate error code parsing.

Since the lower bits that contain details are needed for both error
printing and a few cases where the logical code flow does depend on them,
don’t reduce the boiler plate by masking the detail bits inside the
SEAMCALL wrappers, returning only the status code. Instead, create some
helpers to perform the needed masking and comparisons.

For the status code based checks, create a macro for generating the
helpers based on the name. Name the helpers IS_TDX_FOO(), based on the
discussion in the Link.

Many of the checks that consult the error details are only done in a
single place. It could be argued that there is not any code savings by
adding helpers for these checks. Add helpers for them anyway so that the
checks look consistent when uses with checks that are used in multiple
places (i.e. sc_retry_prerr()).

Finally, update the code that previously open coded the bit math to use
the helpers.

Link: https://lore.kernel.org/kvm/aJNycTvk1GEWgK_Q@google.com/
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Enhance log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Split from "x86/tdx: Consolidate TDX error handling" (Dave, Kai)
 - Change name from IS_TDX_ERR_FOO() to IS_TDX_FOO() after the
   conclusion to one of those naming debates. (Sean, Dave)
---
 arch/x86/coco/tdx/tdx.c                 |  6 +--
 arch/x86/include/asm/shared/tdx_errno.h | 54 ++++++++++++++++++++++++-
 arch/x86/include/asm/tdx.h              |  2 +-
 arch/x86/kvm/vmx/tdx.c                  | 44 +++++++++-----------
 arch/x86/virt/vmx/tdx/tdx.c             |  8 ++--
 5 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7b2833705d47..96554748adaa 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -129,9 +129,9 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
 
 	ret = __tdcall(TDG_MR_REPORT, &args);
 	if (ret) {
-		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
+		if (IS_TDX_OPERAND_INVALID(ret))
 			return -ENXIO;
-		else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
+		else if (IS_TDX_OPERAND_BUSY(ret))
 			return -EBUSY;
 		return -EIO;
 	}
@@ -316,7 +316,7 @@ static void reduce_unnecessary_ve(void)
 {
 	u64 err = tdg_vm_wr(TDCS_TD_CTLS, TD_CTLS_REDUCE_VE, TD_CTLS_REDUCE_VE);
 
-	if (err == TDX_SUCCESS)
+	if (IS_TDX_SUCCESS(err))
 		return;
 
 	/*
diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
index f98924fe5198..49ab7ecc7d54 100644
--- a/arch/x86/include/asm/shared/tdx_errno.h
+++ b/arch/x86/include/asm/shared/tdx_errno.h
@@ -2,8 +2,10 @@
 #ifndef _X86_SHARED_TDX_ERRNO_H
 #define _X86_SHARED_TDX_ERRNO_H
 
+#include <asm/trapnr.h>
+
 /* Upper 32 bit of the TDX error code encodes the status */
-#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+#define TDX_STATUS_MASK				0xFFFFFFFF00000000ULL
 
 /*
  * TDX SEAMCALL Status Codes
@@ -52,4 +54,54 @@
 #define TDX_OPERAND_ID_SEPT			0x92
 #define TDX_OPERAND_ID_TD_EPOCH			0xa9
 
+#ifndef __ASSEMBLER__
+#include <linux/bits.h>
+#include <linux/types.h>
+
+static inline u64 TDX_STATUS(u64 err)
+{
+	return err & TDX_STATUS_MASK;
+}
+
+static inline bool IS_TDX_NON_RECOVERABLE(u64 err)
+{
+	return (err & TDX_NON_RECOVERABLE) == TDX_NON_RECOVERABLE;
+}
+
+static inline bool IS_TDX_SW_ERROR(u64 err)
+{
+	return (err & TDX_SW_ERROR) == TDX_SW_ERROR;
+}
+
+static inline bool IS_TDX_SEAMCALL_VMFAILINVALID(u64 err)
+{
+	return (err & TDX_SEAMCALL_VMFAILINVALID) ==
+		TDX_SEAMCALL_VMFAILINVALID;
+}
+
+static inline bool IS_TDX_SEAMCALL_GP(u64 err)
+{
+	return (err & TDX_SEAMCALL_GP) == TDX_SEAMCALL_GP;
+}
+
+static inline bool IS_TDX_SEAMCALL_UD(u64 err)
+{
+	return (err & TDX_SEAMCALL_UD) == TDX_SEAMCALL_UD;
+}
+
+
+#define DEFINE_TDX_ERRNO_HELPER(error)			\
+	static inline bool IS_##error(u64 err)	\
+	{						\
+		return TDX_STATUS(err) == error;	\
+	}
+
+DEFINE_TDX_ERRNO_HELPER(TDX_SUCCESS);
+DEFINE_TDX_ERRNO_HELPER(TDX_RND_NO_ENTROPY);
+DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_INVALID);
+DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_BUSY);
+DEFINE_TDX_ERRNO_HELPER(TDX_VCPU_NOT_ASSOCIATED);
+DEFINE_TDX_ERRNO_HELPER(TDX_FLUSHVP_NOT_DONE);
+
+#endif /* __ASSEMBLER__ */
 #endif /* _X86_SHARED_TDX_ERRNO_H */
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0e795e7c0b22..eedc479d23f5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -94,7 +94,7 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 
 	do {
 		ret = func(fn, args);
-	} while (ret == TDX_RND_NO_ENTROPY && --retry);
+	} while (IS_TDX_RND_NO_ENTROPY(ret) && --retry);
 
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ff41d3d00380..a952c7b6a22d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -207,12 +207,6 @@ static DEFINE_MUTEX(tdx_lock);
 
 static atomic_t nr_configured_hkid;
 
-static bool tdx_operand_busy(u64 err)
-{
-	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
-}
-
-
 /*
  * A per-CPU list of TD vCPUs associated with a given CPU.
  * Protected by interrupt mask. Only manipulated by the CPU owning this per-CPU
@@ -398,7 +392,7 @@ static void tdx_flush_vp(void *_arg)
 		 * migration.  No other thread uses TDVPR in those cases.
 		 */
 		err = tdh_vp_flush(&to_tdx(vcpu)->vp);
-		if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED)) {
+		if (unlikely(!IS_TDX_VCPU_NOT_ASSOCIATED(err))) {
 			/*
 			 * This function is called in IPI context. Do not use
 			 * printk to avoid console semaphore.
@@ -455,7 +449,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
 	/*
 	 * TDH.PHYMEM.CACHE.WB flushes caches associated with any TDX private
 	 * KeyID on the package or core.  The TDX module may not finish the
-	 * cache flush but return TDX_INTERRUPTED_RESUMEABLE instead.  The
+	 * cache flush but return TDX_ERR_INTERRUPTED_RESUMEABLE instead.  The
 	 * kernel should retry it until it returns success w/o rescheduling.
 	 */
 	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
@@ -511,7 +505,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 * associations, as all vCPU fds have been released at this stage.
 	 */
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
-	if (err == TDX_FLUSHVP_NOT_DONE)
+	if (IS_TDX_FLUSHVP_NOT_DONE(err))
 		goto out;
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
@@ -903,7 +897,7 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u32 exit_reason;
 
-	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	switch (TDX_STATUS(tdx->vp_enter_ret)) {
 	case TDX_SUCCESS:
 	case TDX_NON_RECOVERABLE_VCPU:
 	case TDX_NON_RECOVERABLE_TD:
@@ -977,7 +971,7 @@ static fastpath_t tdx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	 * EXIT_FASTPATH_REENTER_GUEST to exit fastpath, otherwise, the
 	 * requester may be blocked endlessly.
 	 */
-	if (unlikely(tdx_operand_busy(vp_enter_ret)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(vp_enter_ret)))
 		return EXIT_FASTPATH_EXIT_HANDLED;
 
 	return EXIT_FASTPATH_NONE;
@@ -1074,7 +1068,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely(tdx->vp_enter_ret == EXIT_REASON_EPT_MISCONFIG))
 		return EXIT_FASTPATH_NONE;
 
-	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
+	if (unlikely(IS_TDX_SW_ERROR(tdx->vp_enter_ret)))
 		return EXIT_FASTPATH_NONE;
 
 	if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
@@ -1606,7 +1600,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	u64 err;
 
 	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err))) {
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
 		tdx_unpin(kvm, page);
 		return -EBUSY;
 	}
@@ -1697,7 +1691,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
 				  &level_state);
 
-	if (unlikely(tdx_operand_busy(err))) {
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
 		/*
 		 * The second retry is expected to succeed after kicking off all
 		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
@@ -1734,7 +1728,7 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
 			       &level_state);
-	if (unlikely(tdx_operand_busy(err)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
 
 	if (KVM_BUG_ON(err, kvm)) {
@@ -1791,7 +1785,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 
-	if (unlikely(tdx_operand_busy(err))) {
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
 		/* After no vCPUs enter, the second retry is expected to succeed */
 		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
@@ -1847,7 +1841,7 @@ static void tdx_track(struct kvm *kvm)
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	err = tdh_mem_track(&kvm_tdx->td);
-	if (unlikely(tdx_operand_busy(err))) {
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
 		/* After no vCPUs enter, the second retry is expected to succeed */
 		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_track(&kvm_tdx->td);
@@ -2068,7 +2062,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
-	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
+	if (unlikely(IS_TDX_SW_ERROR(vp_enter_ret))) {
 		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
@@ -2079,7 +2073,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		 * not enabled, TDX_NON_RECOVERABLE must be set.
 		 */
 		WARN_ON_ONCE(vcpu->arch.guest_state_protected &&
-				!(vp_enter_ret & TDX_NON_RECOVERABLE));
+			     !IS_TDX_NON_RECOVERABLE(vp_enter_ret));
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason = exit_reason.full;
 		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
@@ -2093,7 +2087,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	}
 
 	WARN_ON_ONCE(exit_reason.basic != EXIT_REASON_TRIPLE_FAULT &&
-		     (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
+		     !IS_TDX_SUCCESS(vp_enter_ret));
 
 	switch (exit_reason.basic) {
 	case EXIT_REASON_TRIPLE_FAULT:
@@ -2540,7 +2534,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	err = tdh_mng_create(&kvm_tdx->td, kvm_tdx->hkid);
 	mutex_unlock(&tdx_lock);
 
-	if (err == TDX_RND_NO_ENTROPY) {
+	if (IS_TDX_RND_NO_ENTROPY(err)) {
 		ret = -EAGAIN;
 		goto free_packages;
 	}
@@ -2582,7 +2576,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	kvm_tdx->td.tdcs_pages = tdcs_pages;
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
 		err = tdh_mng_addcx(&kvm_tdx->td, tdcs_pages[i]);
-		if (err == TDX_RND_NO_ENTROPY) {
+		if (IS_TDX_RND_NO_ENTROPY(err)) {
 			/* Here it's hard to allow userspace to retry. */
 			ret = -EAGAIN;
 			goto teardown;
@@ -2595,7 +2589,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	}
 
 	err = tdh_mng_init(&kvm_tdx->td, __pa(td_params), &rcx);
-	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
+	if (IS_TDX_OPERAND_INVALID(err)) {
 		/*
 		 * Because a user gives operands, don't warn.
 		 * Return a hint to the user because it's sometimes hard for the
@@ -2888,7 +2882,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		return -EINVAL;
 
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
-	if (tdx_operand_busy(cmd->hw_error))
+	if (IS_TDX_OPERAND_BUSY(cmd->hw_error))
 		return -EBUSY;
 	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
 		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
@@ -3209,7 +3203,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
 			       src_page, &entry, &level_state);
 	if (err) {
-		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
+		ret = unlikely(IS_TDX_OPERAND_BUSY(err)) ? -EBUSY : -EIO;
 		goto out;
 	}
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..e962fffa73a6 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -81,16 +81,16 @@ static __always_inline int sc_retry_prerr(sc_func_t func,
 {
 	u64 sret = sc_retry(func, fn, args);
 
-	if (sret == TDX_SUCCESS)
+	if (IS_TDX_SUCCESS(sret))
 		return 0;
 
-	if (sret == TDX_SEAMCALL_VMFAILINVALID)
+	if (IS_TDX_SEAMCALL_VMFAILINVALID(sret))
 		return -ENODEV;
 
-	if (sret == TDX_SEAMCALL_GP)
+	if (IS_TDX_SEAMCALL_GP(sret))
 		return -EOPNOTSUPP;
 
-	if (sret == TDX_SEAMCALL_UD)
+	if (IS_TDX_SEAMCALL_UD(sret))
 		return -EACCES;
 
 	err_func(fn, sret, args);
-- 
2.51.0


