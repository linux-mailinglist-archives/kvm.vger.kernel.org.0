Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B140C6D6241
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbjDDNJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbjDDNJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:09:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5599726A3
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680613778; x=1712149778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4d4MvGLrRrowjXwqWAmjffMD8VAlfgoxSmzOLM/C/ug=;
  b=D4zOhcJeEPt0rd9xcJ++EOnAbg+nX4nVEeHj7b6d3uo258E7MLnHkduQ
   jZLL9yokP50R0SNtaI+c6S2PCy4Wf0UsIpLCn947ld1AnecWbTU/BCVdg
   Iz8WBK8/kHCqiymvkwvjLTxhewIwrV/DAtLzh+VaF6W9F/8Ilpv26Mf/S
   3YaswniPAJk8J0DYAzxPFEWQQbjYZT8vBAiQ/8LanlWf4ppQoZr9aLeUX
   uAr789ws00sF7pMoJlPQ9RncOyyDwcBUd/3xnbcJXX8Iz08FPxNN2z27I
   XfgK4U447M5HGGFa2SHox30whGbZWKgZkmy8OKAboqzSgzVSmB3dCyfaE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326193428"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="326193428"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750902099"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="750902099"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.215.140])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:35 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, kai.huang@intel.com, chao.gao@intel.com,
        xuelian.guo@intel.com, robert.hu@linux.intel.com
Subject: [PATCH v7 3/5] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Date:   Tue,  4 Apr 2023 21:09:21 +0800
Message-Id: <20230404130923.27749-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404130923.27749-1-binbin.wu@linux.intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new interface untag_addr() to kvm_x86_ops to untag the metadata
from linear address. Implement LAM version in VMX and dummy version in SVM.

When enabled feature like Intel Linear Address Masking or AMD Upper
Address Ignore, linear address may be tagged with metadata. Linear
address should be checked for modified canonicality and untagged in
instrution emulations or vmexit handlings if LAM or UAI is applicable.

Introduce untag_addr() to kvm_x86_ops to hide the code related to vendor
specific details.
- For VMX, LAM version is implemented.
  LAM has a modified canonical check when applicable:
  * LAM_S48                : [ 1 ][ metadata ][ 1 ]
                               63               47
  * LAM_U48                : [ 0 ][ metadata ][ 0 ]
                               63               47
  * LAM_S57                : [ 1 ][ metadata ][ 1 ]
                               63               56
  * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
                               63               56
  * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
                               63               56..47
  If LAM is applicable to certain address, untag the metadata bits and
  replace them with the value of bit 47 (LAM48) or bit 56 (LAM57). Later
  the untagged address will do legacy canonical check. So that LAM canonical
  check and mask can be covered by "untag + legacy canonical check".

  For cases LAM is not applicable, 'flags' is passed to the interface
  to skip untag.

- For SVM, add a dummy version to do nothing, but return the original
  address.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  5 +++
 arch/x86/kvm/svm/svm.c             |  7 ++++
 arch/x86/kvm/vmx/vmx.c             | 60 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 +
 5 files changed, 75 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8dc345cc6318..7d63d1b942ac 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
+KVM_X86_OP(untag_addr)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
 KVM_X86_OP_OPTIONAL(tlb_remote_flush)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 498d2b5e8dc1..cb674ec826d4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -69,6 +69,9 @@
 #define KVM_X86_NOTIFY_VMEXIT_VALID_BITS	(KVM_X86_NOTIFY_VMEXIT_ENABLED | \
 						 KVM_X86_NOTIFY_VMEXIT_USER)
 
+/* flags for kvm_x86_ops::untag_addr() */
+#define KVM_X86_UNTAG_ADDR_SKIP_LAM	_BITULL(0)
+
 /* x86-specific vcpu->requests bit members */
 #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
 #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
@@ -1607,6 +1610,8 @@ struct kvm_x86_ops {
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
 
+	u64 (*untag_addr)(struct kvm_vcpu *vcpu, u64 la, u64 flags);
+
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
 	int  (*tlb_remote_flush)(struct kvm *kvm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 252e7f37e4e2..a6e6bd09642b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4696,6 +4696,11 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static u64 svm_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags)
+{
+	return addr;
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -4745,6 +4750,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
 
+	.untag_addr = svm_untag_addr,
+
 	.flush_tlb_all = svm_flush_tlb_current,
 	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4d329ee9474c..73cc495bd0da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8137,6 +8137,64 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+
+#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
+
+static inline int lam_sign_extend_bit(bool user, struct kvm_vcpu *vcpu)
+{
+	u64 cr3, cr4;
+
+	if (user) {
+		cr3 = kvm_read_cr3(vcpu);
+		if (!!(cr3 & X86_CR3_LAM_U57))
+			return 56;
+		if (!!(cr3 & X86_CR3_LAM_U48))
+			return 47;
+	} else {
+		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
+		if (cr4 == LAM_S57_EN_MASK)
+			return 56;
+		if (!!(cr4 & X86_CR4_LAM_SUP))
+			return 47;
+	}
+	return -1;
+}
+
+/*
+ * Only called in 64-bit mode.
+ *
+ * Metadata bits are [62:48] in LAM48 and [62:57] in LAM57. Mask metadata in
+ * pointers by sign-extending the value of bit 47 (LAM48) or 56 (LAM57).
+ * The resulting address after untagging isn't guaranteed to be canonical.
+ * Callers should perform the original canonical check and raise #GP/#SS if the
+ * address is non-canonical.
+ */
+u64 vmx_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags)
+{
+	int sign_ext_bit;
+
+	/*
+	 * Instead of calling relatively expensive guest_cpuid_has(), just check
+	 * LAM_U48 in cr3_ctrl_bits. If not set, vCPU doesn't supports LAM.
+	 */
+	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
+	    !!(flags & KVM_X86_UNTAG_ADDR_SKIP_LAM))
+		return addr;
+
+	if(!is_64_bit_mode(vcpu)){
+		WARN_ONCE(1, "Only be called in 64-bit mode");
+		return addr;
+	}
+
+	sign_ext_bit = lam_sign_extend_bit(!(addr >> 63), vcpu);
+
+	if (sign_ext_bit < 0)
+		return addr;
+
+	return (sign_extend64(addr, sign_ext_bit) & ~BIT_ULL(63)) |
+	       (addr & BIT_ULL(63));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8185,6 +8243,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
+	.untag_addr = vmx_untag_addr,
+
 	.flush_tlb_all = vmx_flush_tlb_all,
 	.flush_tlb_current = vmx_flush_tlb_current,
 	.flush_tlb_gva = vmx_flush_tlb_gva,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2acdc54bc34b..79855b9a4aca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+u64 vmx_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
-- 
2.25.1

