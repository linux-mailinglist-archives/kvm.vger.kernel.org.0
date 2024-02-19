Return-Path: <kvm+bounces-9038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 098AB859DA4
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B413D1F21682
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F745446A7;
	Mon, 19 Feb 2024 07:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C0FTN5mm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773AE3D96C;
	Mon, 19 Feb 2024 07:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328880; cv=none; b=q2qp5ifZFyEEqhkWjB9kG4Xnhm19WcFF068wpyOrt8bEwZrMJnDzeHw0J7rgXZuqfAtv7Bt4HcH24pElSvmoFyG+jHj4hKZ3ezbXC+wPp1ZsM8q19Rw6xc8SzoggSsvmKtKe14TaATqt6GF0cEpaQwVpcxLpRzW9tsp9gYW6Xk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328880; c=relaxed/simple;
	bh=Uv5NXvZAXmi5JcnTTPv3AnGIZ1+vXF1EKPUlOm+C42U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoVzcgFVGWTyDpbvGGft0GlqGiB/Oc9I/5vIUBdJUH2A6AWL9raFHHlPDWk1i2OFTM2v8DBhlpc4lzvygSGuWPGtkwoar3B54wdtusYjBB7PNtnCGs84i9hvsfLNMDOxt9VdCY98tWRHDBG3McZIz+QP80uxnwGi6JvJrQmnO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C0FTN5mm; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328878; x=1739864878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uv5NXvZAXmi5JcnTTPv3AnGIZ1+vXF1EKPUlOm+C42U=;
  b=C0FTN5mmmN697p/fBd8yakE4dkg3cM5USnk/1nIeZ8vS6jfc6fhScfe+
   RVICkh9mEBBTIJx5T7iQpRxNw0+ZP7v0qaBrpCPhoZLaFV5kLUi0g+ZRV
   pWA5ghEiP3WnkmzvjPRAb1r8W04ZtZUqwXzhGWZW0tYGBfPFlFLZ6P21S
   n7VADNg7yI/OtLjoZYHRxJjJSqvIc5Pzf9qf4LC5GV1CmLEYprbySd0v4
   wstOWmUDUXk26VZXkgeR51PGaXMMmdQyiSkcLK0/HgUSQmD/O2y/V2hVB
   Z2GRvHoeuPrKCUkQmWLtzJGVYtVbfSVwWP75bAW+3WRv5m7g6scON1sVu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535163"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535163"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966127"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966127"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 23/27] KVM: VMX: Set host constant supervisor states to VMCS fields
Date: Sun, 18 Feb 2024 23:47:29 -0800
Message-ID: <20240219074733.122080-24-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
post-boot(The exception is BIOS call case but vCPU thread never across it)
and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
VM-Exit sequence.

Host supervisor shadow stack is not enabled now and SSP is not accessible
to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.

Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 arch/x86/kvm/x86.c              | 14 ++++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..ee8938818c8a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 24e921c4e7e3..342b5b94c892 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4371,6 +4371,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, host_efer);
+
+	/*
+	 * Supervisor shadow stack is not enabled on host side, i.e.,
+	 * host IA32_S_CET.SHSTK_EN bit is guaranteed to 0 now, per SDM
+	 * description(RDSSP instruction), SSP is not readable in CPL0,
+	 * so resetting the two registers to 0s at VM-Exit does no harm
+	 * to kernel execution. When execution flow exits to userspace,
+	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
+	 * 3 and 4 for details.
+	 */
+	if (cpu_has_load_cet_ctrl()) {
+		vmcs_writel(HOST_S_CET, host_s_cet);
+		vmcs_writel(HOST_SSP, 0);
+		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
+	}
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 281c3fe728c5..73a55d388dd9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -114,6 +114,8 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+u64 __read_mostly host_s_cet;
+EXPORT_SYMBOL_GPL(host_s_cet);
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -9862,6 +9864,18 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -EIO;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+		rdmsrl(MSR_IA32_S_CET, host_s_cet);
+		/*
+		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
+		 * KVM doesn't save/restore the associated MSRs, i.e. KVM may
+		 * clobber the host values.  Yell and refuse to load if SSS is
+		 * unexpectedly enabled, e.g. to avoid crashing the host.
+		 */
+		if (WARN_ON_ONCE(host_s_cet & CET_SHSTK_EN))
+			return -EIO;
+	}
+
 	x86_emulator_cache = kvm_alloc_emulator_cache();
 	if (!x86_emulator_cache) {
 		pr_err("failed to allocate cache for x86 emulator\n");
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9c19dfb5011d..656107e64c93 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -325,6 +325,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 extern u64 host_xcr0;
 extern u64 host_xss;
 extern u64 host_arch_capabilities;
+extern u64 host_s_cet;
 
 extern struct kvm_caps kvm_caps;
 
-- 
2.43.0


