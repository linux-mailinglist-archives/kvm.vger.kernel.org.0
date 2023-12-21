Return-Path: <kvm+bounces-5012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC4781B1FC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 834DF1F24FAF
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9C35B5C9;
	Thu, 21 Dec 2023 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lsf0h+lX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC12658ACC;
	Thu, 21 Dec 2023 09:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149438; x=1734685438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lMZtS6Uq1+UmjnNud65lP8wqI6nTT04uC10gnZ4fF20=;
  b=Lsf0h+lX9MNfCjhhCF29NtXP9vd4NX+ihu+Qwrvpu58lOxwCbnI6BTEC
   /IVRSwLBkeaaYwbEEhn8uUInpKEeAPrhBf2/THZsdu1fgckvfRVtyPabe
   0N001IWZtp0ha96TTdmWIhmpQh9a3TGuwuAoQ9csmpMi+nr7gE+MzGcuF
   z6wRnpxCzJ39xkXpYpxV3DmDLqR6kM/jM7luv1F+AqX8xy53zOhhzRRSk
   5v6MceHNDWWGmE1xTgXsVzpQdWAT/JSEoHUQMYFTYuff6YJJh1Gh0IZJ4
   HhrLyJ5KVq9UfYKh11q1qU76LJVoe3er7ABIqKUgRZSSJed68hT1RsBwU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729740"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729740"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028641"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028641"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:11 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 23/26] KVM: VMX: Set host constant supervisor states to VMCS fields
Date: Thu, 21 Dec 2023 09:02:36 -0500
Message-Id: <20231221140239.4349-24-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
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
index 08058b182893..e9c0b571b3bb 100644
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
index cf0f9e4474a4..9596763fae8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -114,6 +114,8 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+u64 __read_mostly host_s_cet;
+EXPORT_SYMBOL_GPL(host_s_cet);
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -9840,6 +9842,18 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
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
2.39.3


