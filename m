Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B842C723D03
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbjFFJTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbjFFJTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:19:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1B4E71;
        Tue,  6 Jun 2023 02:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043140; x=1717579140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XPZBPXOM1GhylITaBAqxYiF/joDXEhy6wJaBzdauyvM=;
  b=GjMJkQr9MouNwslwa6audfPb3muE5+SrXLrtvHPeBujWZVRaTC4aOtMw
   E7J4RwJXOhthpgxSL2fmUzzq0BXtrGmSVtDD04oUpj/c9rYqGlCIhX12r
   mrqseWO1aqLpZiKiroeuRgcTWv5VIWqe6g4cOtKWDfF/YuwXe4o4ItmV8
   XBeKR3UtZphXXyLIGRjtlKm2FzjIS6vOmDqS+cLjB5CeZu/YBGCfDd8VN
   PSwEwmTibs7QMjMzezzRuutC5gJ3VteADIz53L8E75pDfcH/uctg5hD2+
   qhSWeADCSNs6+sgWh8OqKLzCaSf802CBjibNR0Reubw/VTLOPCGnRtp4R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341252842"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341252842"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883263671"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="883263671"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.170.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:56 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Date:   Tue,  6 Jun 2023 17:18:40 +0800
Message-Id: <20230606091842.13123-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230606091842.13123-1-binbin.wu@linux.intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new optional interface untag_addr() to kvm_x86_ops to untag
the metadata from linear address. Implement LAM version in VMX.

When enabled feature like Intel Linear Address Masking or AMD Upper
Address Ignore, linear address may be tagged with metadata. Linear
address should be checked for modified canonicality and untagged in
instruction emulations or VMExit handlers if LAM or UAI is applicable.

Introduce untag_addr() to kvm_x86_ops to hide the vendor specific code.
Pass the 'flags' to avoid distinguishing processor vendor in common emulator
path for the cases whose untag policies are different in the future.

For VMX, LAM version is implemented.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +
 arch/x86/kvm/kvm_emulate.h         |  1 +
 arch/x86/kvm/vmx/vmx.c             | 73 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 +
 5 files changed, 79 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..c0cebe671d41 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
+KVM_X86_OP_OPTIONAL(untag_addr)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
 KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 46471dd9cc1b..62a72560fa65 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1588,6 +1588,8 @@ struct kvm_x86_ops {
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
 
+	void (*untag_addr)(struct kvm_vcpu *vcpu, gva_t *gva, u32 flags);
+
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
 	int  (*flush_remote_tlbs)(struct kvm *kvm);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 5b9ec610b2cb..c2091e24a6b9 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -91,6 +91,7 @@ struct x86_instruction_info {
 /* x86-specific emulation flags */
 #define X86EMUL_F_FETCH			BIT(0)
 #define X86EMUL_F_WRITE			BIT(1)
+#define X86EMUL_F_SKIPLAM		BIT(2)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 52dcf3c00bb8..82a225d1000e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8133,6 +8133,77 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
+static int lam_sign_extend_bit(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	u64 cr3, cr4;
+
+	/*
+	 * The LAM identification of a pointer as user or supervisor is
+	 * based solely on the value of pointer bit 63.
+	 */
+	if (!(addr >> 63)) {
+		cr3 = kvm_read_cr3(vcpu);
+		if (cr3 & X86_CR3_LAM_U57)
+			return 56;
+		if (cr3 & X86_CR3_LAM_U48)
+			return 47;
+	} else {
+		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
+		if (cr4 == LAM_S57_EN_MASK)
+			return 56;
+		if (cr4 & X86_CR4_LAM_SUP)
+			return 47;
+	}
+	return -1;
+}
+
+/*
+ * Only called in 64-bit mode.
+ *
+ * LAM has a modified canonical check when applicable:
+ * LAM_S48                : [ 1 ][ metadata ][ 1 ]
+ *                            63               47
+ * LAM_U48                : [ 0 ][ metadata ][ 0 ]
+ *                            63               47
+ * LAM_S57                : [ 1 ][ metadata ][ 1 ]
+ *                            63               56
+ * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
+ *                            63               56
+ * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
+ *                            63               56..47
+ *
+ * Untag the metadata bits by sign-extending the value of bit 47 (LAM48) or
+ * bit 56 (LAM57). The resulting address after untag isn't guaranteed to be
+ * canonical. Callers should perform the original canonical check and raise
+ * #GP/#SS if the address is non-canonical.
+ *
+ * Note that KVM masks the metadata in addresses, performs the (original)
+ * canonicality checking and then walks page table. This is slightly
+ * different from hardware behavior but achieves the same effect.
+ * Specifically, if LAM is enabled, the processor performs a modified
+ * canonicality checking where the metadata are ignored instead of
+ * masked. After the modified canonicality checking, the processor masks
+ * the metadata before passing addresses for paging translation.
+ */
+void vmx_untag_addr(struct kvm_vcpu *vcpu, gva_t *gva, u32 flags)
+{
+	int sign_ext_bit;
+
+	/*
+	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
+	 * If not set, vCPU doesn't supports LAM.
+	 */
+	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
+	    (flags & X86EMUL_F_SKIPLAM) || WARN_ON_ONCE(!is_64_bit_mode(vcpu)))
+		return;
+
+	sign_ext_bit = lam_sign_extend_bit(vcpu, *gva);
+	if (sign_ext_bit > 0)
+		*gva = (sign_extend64(*gva, sign_ext_bit) & ~BIT_ULL(63)) |
+		       (*gva & BIT_ULL(63));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8181,6 +8252,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
+	.untag_addr = vmx_untag_addr,
+
 	.flush_tlb_all = vmx_flush_tlb_all,
 	.flush_tlb_current = vmx_flush_tlb_current,
 	.flush_tlb_gva = vmx_flush_tlb_gva,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9e66531861cf..c4bbd3024fa8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+void vmx_untag_addr(struct kvm_vcpu *vcpu, gva_t *gva, u32 flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
-- 
2.25.1

