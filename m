Return-Path: <kvm+bounces-31585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB1C89C4FCE
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C303B2618E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAEF2144D0;
	Tue, 12 Nov 2024 07:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8K38Ocg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1BD20E32C;
	Tue, 12 Nov 2024 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397283; cv=none; b=DOXnneHsmGibdp2c2bgDJbb0REMhS19P4cRkCpOzFj4NLu13SGN1HQrh/3Shyx1Zp1DoOr3bBCAIX82MHoHAHe09sTcf4A7R+thkwV0HvL2EwhWC0BTwMEEwsZw6WiHouN37GaJEyjwHEUArQZGnhaEXoCmrk5Hytf41Dj7EDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397283; c=relaxed/simple;
	bh=2p2WLMrmWNOutVqrBIwb/cMEvzMPFLs3YqKeMUFkIRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHOXcULZYVJH7uej9IzijXVGKwM44MmcnTBeeQ24XFZkhVG0zmlQgbE1C6uZG3q8vRWzRDabpvuCJKn+YvJqPQkCLZYWcBp8hN2Lg6T5Sr9ErdHbIznn/nFkfF8LyW/+uIQKm4d1m0fnaviVUsWF0CCG0hfgLjfTGN69irYRDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8K38Ocg; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397282; x=1762933282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2p2WLMrmWNOutVqrBIwb/cMEvzMPFLs3YqKeMUFkIRI=;
  b=E8K38OcgUqTfyBP2p9qlh5y8MZgSjvXQCWVl1Tj7t3g2DJnvYyDerBfr
   on+IZDTkHb3XcTnJNqG+9DbRlCRu4CehYxmPnzdeM3webbdFDhD8GgiOj
   E5iFLuoOE8wfFHHVEU24G+X00s6jkTNxcgrlZ0kU4DEQcaqNTdszpYZ8s
   Nztn/yAGhZpiqikwLIugUJmMsbtsJ0X4qtUhiVUnQetkByizU7A8Uz7Fi
   aC2VF4ap/Q6Jv/DibRna0Tza+g/kOLtx2BqKXIxgv3a1HS7lWmNY1Qp0E
   Beail5aXFFQH6ofgXD/wQ1yaEGG6nbVXI4EaHfiBlZWDYO8gp+ktC+xBM
   Q==;
X-CSE-ConnectionGUID: YYrWEUU6QJSO6/mvD6a4Vw==
X-CSE-MsgGUID: YSX0nIjPRduPnA3s29PTFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31311578"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31311578"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:19 -0800
X-CSE-ConnectionGUID: +4WwSx3LQHS3EdM6kqC18w==
X-CSE-MsgGUID: 76bSvV3/RqGsDwaM8ETWOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="124830653"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:15 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 22/24] KVM: TDX: Finalize VM initialization
Date: Tue, 12 Nov 2024 15:38:48 +0800
Message-ID: <20241112073848.22298-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.

The API documentation is provided in a separate patch:
“Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)”.

Enhance TDX’s set_external_spte() hook to record the pre-mapping count
instead of returning without action when the TD is not finalized.

Adjust the pre-mapping count when pages are added or if the mapping is
dropped.

Set pre_fault_allowed to true after the finalization is complete.

Note: TD Measurement Finalization is the process by which the initial state
of the TDX VM is measured for attestation purposes. It uses the SEAMCALL
TDH.MR.FINALIZE, after which:
1. The VMM can no longer add TD private pages with arbitrary content.
2. The TDX VM becomes runnable.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2
 - Merge changes from patch "KVM: TDX: Premap initial guest memory" into
   this patch (Paolo)
 - Consolidate nr_premapped counting into this patch (Paolo)
 - Page level check should be (and is) in tdx_sept_set_private_spte() in
   patch "KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror
   page table" not in tdx_mem_page_record_premap_cnt() (Paolo)
 - Protect finalization using kvm->slots_lock (Paolo)
 - Set kvm->arch.pre_fault_allowed to true after finalization is done
   (Paolo)
 - Add a memory barrier to ensure correct ordering of the updates to
   kvm_tdx->finalized and kvm->arch.pre_fault_allowed (Adrian)
 - pre_fault_allowed must not be true before finalization is done.
   Highlight that fact by checking it in tdx_mem_page_record_premap_cnt()
   (Adrian)
 - No need for is_td_finalized() (Rick)
 - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Add nr_premapped where it's first used (Tao)

TDX MMU part 2 v1:
 - Added premapped check.
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Add check if nr_premapped is zero.  If not, return error.
 - Use KVM_BUG_ON() in tdx_td_finalizer() for consistency.
 - Change tdx_td_finalizemr() to take struct kvm_tdx_cmd *cmd and return error
   (Adrian)
 - Handle TDX_OPERAND_BUSY case (Adrian)
 - Updates from seamcall overhaul (Kai)
 - Rename error->hw_error

v18:
 - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.

v15:
 - removed unconditional tdx_track() by tdx_flush_tlb_current() that
   does tdx_track().
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 78 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.h          |  3 ++
 3 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a19cd84cec76..eee6de05f261 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 15cedacd717a..acaa11be1031 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -563,6 +563,31 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+/*
+ * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to get guest pages and
+ * tdx_gmem_post_populate() to premap page table pages into private EPT.
+ * Mapping guest pages into private EPT before TD is finalized should use a
+ * seamcall TDH.MEM.PAGE.ADD(), which copies page content from a source page
+ * from user to target guest pages to be added. This source page is not
+ * available via common interface kvm_tdp_map_page(). So, currently,
+ * kvm_tdp_map_page() only premaps guest pages into KVM mirrored root.
+ * A counter nr_premapped is increased here to record status. The counter will
+ * be decreased after TDH.MEM.PAGE.ADD() is called after the kvm_tdp_map_page()
+ * in tdx_gmem_post_populate().
+ */
+static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
+					  enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
+		return -EINVAL;
+
+	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
+	atomic64_inc(&kvm_tdx->nr_premapped);
+	return 0;
+}
+
 int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, kvm_pfn_t pfn)
 {
@@ -582,14 +607,15 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	get_page(pfn_to_page(pfn));
 
+	/*
+	 * To match ordering of 'finalized' and 'pre_fault_allowed' in
+	 * tdx_td_finalizemr().
+	 */
+	smp_rmb();
 	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
 		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	/*
-	 * TODO: KVM_TDX_INIT_MEM_REGION support to populate before finalize
-	 * comes here for the initial memory.
-	 */
-	return -EOPNOTSUPP;
+	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -621,10 +647,12 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
 		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
 		/*
-		 * This page was mapped with KVM_MAP_MEMORY, but
-		 * KVM_TDX_INIT_MEM_REGION is not issued yet.
+		 * Page is mapped by KVM_TDX_INIT_MEM_REGION, but hasn't called
+		 * tdh_mem_page_add().
 		 */
 		if (!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) {
+			WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
+			atomic64_dec(&kvm_tdx->nr_premapped);
 			tdx_unpin(kvm, pfn);
 			return 0;
 		}
@@ -1368,6 +1396,36 @@ void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
 	ept_sync_global();
 }
 
+static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	guard(mutex)(&kvm->slots_lock);
+
+	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
+		return -EINVAL;
+	/*
+	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
+	 * TDH.MEM.PAGE.ADD().
+	 */
+	if (atomic64_read(&kvm_tdx->nr_premapped))
+		return -EINVAL;
+
+	cmd->hw_error = tdh_mr_finalize(kvm_tdx->tdr_pa);
+	if ((cmd->hw_error & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY)
+		return -EAGAIN;
+	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
+		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
+		return -EIO;
+	}
+
+	kvm_tdx->state = TD_STATE_RUNNABLE;
+	/* TD_STATE_RUNNABLE must be set before 'pre_fault_allowed' */
+	smp_wmb();
+	kvm->arch.pre_fault_allowed = true;
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1392,6 +1450,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalizemr(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1656,6 +1717,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
+	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
+	atomic64_dec(&kvm_tdx->nr_premapped);
+
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
 			err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &entry,
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 727bcf25d731..aeddf2bb0a94 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -32,6 +32,9 @@ struct kvm_tdx {
 	u64 tsc_offset;
 
 	enum kvm_tdx_state state;
+
+	/* For KVM_TDX_INIT_MEM_REGION. */
+	atomic64_t nr_premapped;
 };
 
 /* TDX module vCPU states */
-- 
2.43.2


