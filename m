Return-Path: <kvm+bounces-31580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6C89C4FBC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B5211F272D6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2458B20DD5A;
	Tue, 12 Nov 2024 07:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G3GxDkT1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D744420BB49;
	Tue, 12 Nov 2024 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397233; cv=none; b=ATOkJymQ7B2o6IVeg9NTir9Iuyqyb3Ac7wrRUP+ig9rKjsmXr0uTy0wk2VaOmYyI0m2c83YU8CYD7LK0AcwR2+Rattiosl/mXyzNAabSGUeX19cHIrjwrqgn84NdEhIj8tnfjXJooy4V44LblVGDq1CTa7gQFNiTOHkNej6kfYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397233; c=relaxed/simple;
	bh=Y28Bn1uVmNPfYs5Pzm1YxRbZtqYBIEZoCJS9YviJUok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERp+E+mJCv5zGG60rRtOJaJJplTz+7lnwrPkwsdqbyqRCj/UfFJpS6TbgYvNePghVrX3VLRAZwZ3mwU0l3a1r47TpcgJ/5Xv5AtrJNi/+htdA2IcUFSjlZjD3rEmeY6D/o9kMVDm783ZbNYRapTRfANCjuIUrotbwiyMiwlT0Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G3GxDkT1; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397231; x=1762933231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y28Bn1uVmNPfYs5Pzm1YxRbZtqYBIEZoCJS9YviJUok=;
  b=G3GxDkT1/5ol2Z7jXyyiuqazjo896bYiG7Gt4c1lzXu+Al1QAJ8pnTc4
   cx9muPw5PI8/2lkRZL+8b8sv3qUCTDBb5wMPbVQcZ/mCNQglcMZW8FL/m
   TBKb1S8xZSj8EwCd+YCfmsPNVpwZwXzF/XVoAycfETKKSyPX57vUt0mMT
   twRR6s5HRsDfePS1utPxFxmznsQ8E+WJpytX6C9H3wWD7diJSndKrO6s3
   pd2OhXIOtm712LOCoGERTx5B6oxm6Jh2+F3wnSNdse0F9zQuWlLlMrQbt
   Y8L8RFaqIXXfYaQzXJXa3EPfqsaqHUtjmguU+C/LgG68vE1N+S4AIhugN
   Q==;
X-CSE-ConnectionGUID: TII8dMbgS1SQnNYO4OgUPg==
X-CSE-MsgGUID: XYQYD5NxQoiJlPHe80qSMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31090671"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31090671"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:24 -0800
X-CSE-ConnectionGUID: QzoqBj2dSkupYP6K/28R2g==
X-CSE-MsgGUID: vOknj8eeQ/2W1nkFjEUvlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92089528"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:20 -0800
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
Subject: [PATCH v2 17/24] KVM: TDX: Handle TLB tracking for TDX
Date: Tue, 12 Nov 2024 15:37:53 +0800
Message-ID: <20241112073753.22228-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle TLB tracking for TDX by introducing function tdx_track() for private
memory TLB tracking and implementing flush_tlb* hooks to flush TLBs for
shared memory.

Introduce function tdx_track() to do TLB tracking on private memory, which
basically does two things: calling TDH.MEM.TRACK to increase TD epoch and
kicking off all vCPUs. The private EPT will then be flushed when each vCPU
re-enters the TD. This function is unused temporarily in this patch and
will be called on a page-by-page basis on removal of private guest page in
a later patch.

In earlier revisions, tdx_track() relied on an atomic counter to coordinate
the synchronization between the actions of kicking off vCPUs, incrementing
the TD epoch, and the vCPUs waiting for the incremented TD epoch after
being kicked off.

However, the core MMU only actually needs to call tdx_track() while
aleady under a write mmu_lock. So this sychnonization can be made to be
unneeded. vCPUs are kicked off only after the successful execution of
TDH.MEM.TRACK, eliminating the need for vCPUs to wait for TDH.MEM.TRACK
completion after being kicked off. tdx_track() is therefore able to send
requests KVM_REQ_OUTSIDE_GUEST_MODE rather than KVM_REQ_TLB_FLUSH.

Hooks for flush_remote_tlb and flush_remote_tlbs_range are not necessary
for TDX, as tdx_track() will handle TLB tracking of private memory on
page-by-page basis when private guest pages are removed. There is no need
to invoke tdx_track() again in kvm_flush_remote_tlbs() even after changes
to the mirrored page table.

For hooks flush_tlb_current and flush_tlb_all, which are invoked during
kvm_mmu_load() and vcpu load for normal VMs, let VMM to flush all EPTs in
the two hooks for simplicity, since TDX does not depend on the two
hooks to notify TDX module to flush private EPT in those cases.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - No need for is_td_finalized() (Rick)
 - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Add TD state handling (Tony)
 - Added tdx_flush_tlb_all() (Paolo)
 - Re-explanined the reason to do global invalidation in
   tdx_flush_tlb_current() (Yan)

TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Modification of synchronization mechanism in tdx_track().
 - Dropped hooks flush_remote_tlb and flush_remote_tlbs_range.
 - Let VMM to flush all EPTs in hooks flush_tlb_all and flush_tlb_current.
 - Dropped KVM_BUG_ON() in vt_flush_tlb_gva(). (Rick)
---
 arch/x86/kvm/vmx/main.c    | 44 +++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 81 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++
 3 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a34c0bebe1c3..4902d7bb86f3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -99,6 +99,42 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_flush_tlb_all(vcpu);
+		return;
+	}
+
+	vmx_flush_tlb_all(vcpu);
+}
+
+static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_flush_tlb_current(vcpu);
+		return;
+	}
+
+	vmx_flush_tlb_current(vcpu);
+}
+
+static void vt_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_flush_tlb_gva(vcpu, addr);
+}
+
+static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_flush_tlb_guest(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			    int pgd_level)
 {
@@ -188,10 +224,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
-	.flush_tlb_all = vmx_flush_tlb_all,
-	.flush_tlb_current = vmx_flush_tlb_current,
-	.flush_tlb_gva = vmx_flush_tlb_gva,
-	.flush_tlb_guest = vmx_flush_tlb_guest,
+	.flush_tlb_all = vt_flush_tlb_all,
+	.flush_tlb_current = vt_flush_tlb_current,
+	.flush_tlb_gva = vt_flush_tlb_gva,
+	.flush_tlb_guest = vt_flush_tlb_guest,
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.vcpu_run = vmx_vcpu_run,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 37696adb574c..9eef361c8e57 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 #include "mmu.h"
 #include "x86_ops.h"
 #include "tdx.h"
+#include "vmx.h"
 #include "mmu/spte.h"
 
 #undef pr_fmt
@@ -523,6 +524,51 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+/*
+ * Ensure shared and private EPTs to be flushed on all vCPUs.
+ * tdh_mem_track() is the only caller that increases TD epoch. An increase in
+ * the TD epoch (e.g., to value "N + 1") is successful only if no vCPUs are
+ * running in guest mode with the value "N - 1".
+ *
+ * A successful execution of tdh_mem_track() ensures that vCPUs can only run in
+ * guest mode with TD epoch value "N" if no TD exit occurs after the TD epoch
+ * being increased to "N + 1".
+ *
+ * Kicking off all vCPUs after that further results in no vCPUs can run in guest
+ * mode with TD epoch value "N", which unblocks the next tdh_mem_track() (e.g.
+ * to increase TD epoch to "N + 2").
+ *
+ * TDX module will flush EPT on the next TD enter and make vCPUs to run in
+ * guest mode with TD epoch value "N + 1".
+ *
+ * kvm_make_all_cpus_request() guarantees all vCPUs are out of guest mode by
+ * waiting empty IPI handler ack_kick().
+ *
+ * No action is required to the vCPUs being kicked off since the kicking off
+ * occurs certainly after TD epoch increment and before the next
+ * tdh_mem_track().
+ */
+static void __always_unused tdx_track(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+
+	/* If TD isn't finalized, it's before any vcpu running. */
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
+		return;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	do {
+		err = tdh_mem_track(kvm_tdx->tdr_pa);
+	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
+
+	if (KVM_BUG_ON(err, kvm))
+		pr_tdx_error(TDH_MEM_TRACK, err);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
@@ -1068,6 +1114,41 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * flush_tlb_current() is invoked when the first time for the vcpu to
+	 * run or when root of shared EPT is invalidated.
+	 * KVM only needs to flush shared EPT because the TDX module handles TLB
+	 * invalidation for private EPT in tdh_vp_enter();
+	 *
+	 * A single context invalidation for shared EPT can be performed here.
+	 * However, this single context invalidation requires the private EPTP
+	 * rather than the shared EPTP to flush shared EPT, as shared EPT uses
+	 * private EPTP as its ASID for TLB invalidation.
+	 *
+	 * To avoid reading back private EPTP, perform a global invalidation for
+	 * shared EPT instead to keep this function simple.
+	 */
+	ept_sync_global();
+}
+
+void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TDX has called tdx_track() in tdx_sept_remove_private_spte() to
+	 * ensure that private EPT will be flushed on the next TD enter. No need
+	 * to call tdx_track() here again even when this callback is a result of
+	 * zapping private EPT.
+	 *
+	 * Due to the lack of the context to determine which EPT has been
+	 * affected by zapping, invoke invept() directly here for both shared
+	 * EPT and private EPT for simplicity, though it's not necessary for
+	 * private EPT.
+	 */
+	ept_sync_global();
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f49135094c94..7151ac38bc31 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -130,6 +130,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
+void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -143,6 +145,8 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
+static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.43.2


