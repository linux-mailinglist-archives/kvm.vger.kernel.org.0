Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518F971A202
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbjFAPFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbjFAPFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:05:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC1D1A6;
        Thu,  1 Jun 2023 08:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685631849; x=1717167849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=atIMQ453MmU200T6ZuCKJrrV46VwSuyWV8VVDSHc8gU=;
  b=UXHtoTY6vVugtxldXqUVAkwXaD9IOcMO0PJ7rJdmx9QnpzsmlKLDYJGK
   zFabKc4sPW7LYKIvOuYmXtLXkJZaoV7pHLqxg5HK+AD7kDZQZfslcwF18
   wTgLq0oJm69OHZ94blnsltGIJGzAgzXT9TDFz7RBFCFIAvCZw2bkOuFY0
   jTKXKZkqclAsSE0+Q151xkdjmh4OkUz2bm8nhVph6RBGVAEZkXHwQF2H7
   ZzOBeY8i0oeyNFdrGh/nzxwnAtTYTmYLlRy56Kvxc6sRJ1euGosmhdnlZ
   Hgh/JzAg+1BQgr94d3eKP5yuFflLTia+Dr9fw+B4C5x/yuEsYoZsJyY54
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383853415"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383853415"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="657828205"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="657828205"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:45 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
Date:   Thu,  1 Jun 2023 22:23:06 +0800
Message-Id: <20230601142309.6307-4-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel introduces LASS (Linear Address Separation) feature providing
an independent mechanism to achieve the mode-based protection.

LASS partitions 64-bit linear address space into two halves, user-mode
address (LA[bit 63]=0) and supervisor-mode address (LA[bit 63]=1). It
stops any code execution or conditional data access[1]
    1. from user mode to supervisor-mode address space
    2. from supervisor mode to user-mode address space
and generates LASS violation fault accordingly.

[1]A supervisor mode data access causes a LASS violation only if supervisor
mode access protection is enabled (CR4.SMAP = 1) and either RFLAGS.AC = 0
or the access implicitly accesses a system data structure.

Following are the rules of LASS violation check on the linear address(LA).
User access to supervisor-mode address space:
    LA[bit 63] && (CPL == 3)
Supervisor access to user-mode address space:
    Instruction fetch: !LA[bit 63] && (CPL < 3)
    Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
                 CPL < 3) || Implicit supervisor access)

Add new ops in kvm_x86_ops to do LASS violation check.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 +-
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/kvm_emulate.h         |  1 +
 arch/x86/kvm/vmx/vmx.c             | 47 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 ++
 5 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..8980a3bfa687 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
-KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
+KVM_X86_OP_OPTIONAL_RET0(check_lass)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 92d8e65fe88c..98666d1e7727 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 5b9ec610b2cb..f1439ab7c14b 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -91,6 +91,7 @@ struct x86_instruction_info {
 /* x86-specific emulation flags */
 #define X86EMUL_F_FETCH			BIT(0)
 #define X86EMUL_F_WRITE			BIT(1)
+#define X86EMUL_F_SKIPLASS		BIT(2)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a33205ded85c..876997e8448e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8130,6 +8130,51 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+/*
+ * Determine whether an access to the linear address causes a LASS violation.
+ * LASS protection is only effective in long mode. As a prerequisite, caller
+ * should make sure vCPU running in long mode and invoke this api to do LASS
+ * violation check.
+ */
+bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags)
+{
+	bool user_mode, user_as, rflags_ac;
+
+	if (!!(flags & X86EMUL_F_SKIPLASS) ||
+	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
+		return false;
+
+	WARN_ON_ONCE(!is_long_mode(vcpu));
+
+	user_as = !(la >> 63);
+
+	/*
+	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
+	 * accesses a system data structure. For implicit accesses to system
+	 * data structure, the processor acts as if RFLAGS.AC is clear.
+	 */
+	if (access & PFERR_IMPLICIT_ACCESS) {
+		user_mode = false;
+		rflags_ac = false;
+	} else {
+		user_mode = vmx_get_cpl(vcpu) == 3;
+		if (!user_mode)
+			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
+	}
+
+	if (user_mode == user_as)
+		return false;
+
+	/*
+	 * Supervisor-mode _data_ accesses to user address space
+	 * cause LASS violations only if SMAP is enabled.
+	 */
+	if (!user_mode && !(access & PFERR_FETCH_MASK))
+		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;
+
+	return true;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8269,6 +8314,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.check_lass = vmx_check_lass,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9e66531861cf..f2e775b9849b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
-- 
2.27.0

