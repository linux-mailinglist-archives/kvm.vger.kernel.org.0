Return-Path: <kvm+bounces-39378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1BEA46B9E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 706E116CA36
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BBF270EB6;
	Wed, 26 Feb 2025 19:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUVOJ8gV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048BF26FA49
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599761; cv=none; b=j9hrofZha56hpnk0srE99gJTdmm5SFGJ3g3mBanZ8Yc5O/RRw46zIcCYeVK3io0JzpkPJHT/8tO1l87mrHBYaamRn93PvgBBzhoWxiMmgq8aq5AQnaUOoiUJUA1tu/ZiLMWCe5As/vuMlEn6SToPjgjtNT6i/kwILebWFOSH+Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599761; c=relaxed/simple;
	bh=DHN8D2VM0x3HvVwlaErKkYPHV1qjF2W8CQJXHCF/Z70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVLSTbl902qbOqhXStLyAwjBV9UlwiMfWWzUr1L3ELRkN+CtIBkSZQutQgDqYHmmwI8YxnE3m5eVt1kZTIwaw8ybt4vhW6ze9Tm3tNj7G+9w/kzT7K6mfsjOFSteTOmTyK4XL/EBtJnA0lkRkN15GkvwjIcW0wi6GsPGCY4PfGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUVOJ8gV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJC2MrZUeuCN9GaSnrvyhVplXNA5i+39g2V3LZ01UX8=;
	b=AUVOJ8gV6Gi/ZLxO8TXGbeDF5DYDyewGNkqjCzxCiSum9Kw/BRXGGkLmIv0I2s5Up+wFwq
	OUs942NuRfrlxhmC2LBT8GYb/PoBJXxCFX1SB0MB9w+9iCaV18R4RP5IpOqcx+9GkcKI6f
	xZsL6aldp/v5PwOcQf2XhtNwFkfj6u0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-e9zM4soJN7yWua5AvmIe2w-1; Wed,
 26 Feb 2025 14:55:55 -0500
X-MC-Unique: e9zM4soJN7yWua5AvmIe2w-1
X-Mimecast-MFC-AGG-ID: e9zM4soJN7yWua5AvmIe2w_1740599754
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 325981800879;
	Wed, 26 Feb 2025 19:55:54 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3EE45300018D;
	Wed, 26 Feb 2025 19:55:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 17/29] KVM: TDX: Handle TLB tracking for TDX
Date: Wed, 26 Feb 2025 14:55:17 -0500
Message-ID: <20250226195529.2314580-18-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
Message-ID: <20241112073753.22228-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    | 44 +++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 81 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++
 3 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a4cb3d6b2986..0ea4bec0626e 100644
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
@@ -190,10 +226,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index f42772a5492b..b80fc035e471 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -8,6 +8,7 @@
 #include "x86_ops.h"
 #include "lapic.h"
 #include "tdx.h"
+#include "vmx.h"
 #include "mmu/spte.h"
 
 #pragma GCC poison to_vmx
@@ -519,6 +520,51 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
+		err = tdh_mem_track(&kvm_tdx->td);
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
@@ -1073,6 +1119,41 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
index ad1c2f3e546e..584db5fa8dab 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -132,6 +132,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
+void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -144,6 +146,8 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
+static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.43.5



