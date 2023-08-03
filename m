Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697B576E1C5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjHCHh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjHCHgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:10 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4579A49DF;
        Thu,  3 Aug 2023 00:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047941; x=1722583941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qv737col8wU+/w5BrY2eGqQ22lxPRzjYmcTTHFYVkxo=;
  b=gfWBmPm+RUjfuegU538Ftf0zfYzCqxe9UVrUARsQ/zP92Y76IVDE3kfG
   VbI9aqBX8So6cr++ZHTS09VbQL590EykEvRFWzf0Au1XAPCCs0CT+7icQ
   Jyuie8ajZ0Yzd6ZnrAOAUiUaasyP8Lq/v3WWLXyVTbLsocbniRQqrrWmE
   nrHQJKCa+49tV3ZiicUO6dA+8EuS3+gLSdMno5vvZwQBdxG1gJ0F6TZUC
   w6v9J5IhvTuDb0wnYJKDVc8Lwx4J/tENxDj5/uBFoFKxNHKHWEFkKnjGc
   AQanUg2RkM8+0f7OWPUe5+QNuqCE2efC+SEg2vwF8E4rggt6vDKzYskkJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708157"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708157"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888511"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888511"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 14/19] KVM:VMX: Set host constant supervisor states to VMCS fields
Date:   Thu,  3 Aug 2023 00:27:27 -0400
Message-Id: <20230803042732.88515-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} VMCS
fields explicitly. Kernel IBT is supported and the setting in
MSR_IA32_S_CET is static after post-boot(except is BIOS call
case but vCPU thread never across it.), i.e. KVM doesn't need
to refresh HOST_S_CET field before every VM-Enter/VM-Exit
sequence.

Host supervisor shadow stack is not enabled now and SSP is not
accessible to kernel mode, thus it's safe to set host IA32_INT_
SSP_TAB/SSP VMCS fields to 0s. When shadow stack is enabled for
CPL3, SSP is reloaded from IA32_PL3_SSP before it exits to userspace.
Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/SYSRET/SYSENTER SYSEXIT/
RDSSP/CALL etc.

Prevent KVM module loading and if host supervisor shadow stack
SHSTK_EN is set in MSR_IA32_S_CET as KVM cannot co-exit with it
correctly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 arch/x86/kvm/x86.c              | 14 ++++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d0abee35d7ba..b1883f6c08eb 100644
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
index 6779b8a63789..99bf63b2a779 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4341,6 +4341,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
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
index 56aa5a3d3913..01b4f10fa8ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -113,6 +113,8 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+u64 __read_mostly host_s_cet;
+EXPORT_SYMBOL_GPL(host_s_cet);
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -9615,6 +9617,18 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
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
index 3b79d6db2f83..e42e5263fcf7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -323,6 +323,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
 extern u64 host_xss;
+extern u64 host_s_cet;
 
 extern struct kvm_caps kvm_caps;
 
-- 
2.27.0

