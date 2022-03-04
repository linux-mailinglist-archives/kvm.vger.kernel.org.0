Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66EE4CDE9C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiCDUHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiCDUHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57F1F9FBD;
        Fri,  4 Mar 2022 12:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424113; x=1677960113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rI7F1WEA0edZzRl2GMT42P/qDd9IF52hRZpENDRAObY=;
  b=Cv7G2lVpZxmVO7YAwTGM60UbyHS/CDeQyFxb12eLSDig9pI17ifP2oHJ
   Py5gdeGTAJ+QIyJgbYq+vgy92/BDFtKRfD2QocCwOVFE4c5t46J84OeH0
   t5wPLMg4zOQFjlMfNkFa1xGCi53uZOVO80ufVN2u4uIOk33xlHkVUYNr8
   DRrTQ0Ew/keMQg+DLf3nAAPzsU1TLzuT78GH3cEXxYP+LkZie/1XtDGYz
   yc1iX1/KnvhfZ1Rp6Kxd85Te1FraM66+dC+PzgoX9K69W7iuh2qqcyXj+
   3FmMBvCsECi9o4P5duw1yAlfJYjSoYd4ESV4KYOvr+gFLC9I46h185/vq
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983431"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983431"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344279"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 030/104] KVM: TDX: Do TDX specific vcpu initialization
Date:   Fri,  4 Mar 2022 11:48:46 -0800
Message-Id: <8df2f973f7d58277a4dcbd796274982aab11c892.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TD guest vcpu need to be configured before ready to run which requests
addtional information from Device model (e.g. qemu), one 64bit value is
passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
additional vcpu configuration.

Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h       |  1 +
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/vmx/main.c               | 25 +++++++++++++-------
 arch/x86/kvm/vmx/tdx.c                | 34 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  4 ++++
 arch/x86/kvm/vmx/x86_ops.h            |  2 ++
 arch/x86/kvm/x86.c                    |  6 +++++
 tools/arch/x86/include/uapi/asm/kvm.h |  1 +
 8 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 290e200f012c..208b29b0e637 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1483,6 +1483,7 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
+	int (*mem_enc_op_vcpu)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 6e26dde0dce6..9702f0d95776 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -532,6 +532,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a11d3e870a98..3eb9db6d83ac 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -57,14 +57,6 @@ static void vt_vm_free(struct kvm *kvm)
 		return tdx_vm_free(kvm);
 }
 
-static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
-{
-	if (!is_td(kvm))
-		return -ENOTTY;
-
-	return tdx_vm_ioctl(kvm, argp);
-}
-
 static int vt_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -89,6 +81,22 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
+static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_ioctl(kvm, argp);
+}
+
+static int vt_mem_enc_op_vcpu(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	if (!is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return tdx_vcpu_ioctl(vcpu, argp);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -229,6 +237,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.mem_enc_op = vt_mem_enc_op,
+	.mem_enc_op_vcpu = vt_mem_enc_op_vcpu,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e43ca93ff95b..f86a257dd71b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -73,6 +73,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->hkid > 0;
 }
 
+static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->finalized;
+}
+
 static void tdx_clear_page(unsigned long page)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -756,6 +761,35 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	u64 err;
+
+	if (tdx->initialized)
+		return -EINVAL;
+
+	if (!is_td_initialized(vcpu->kvm) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.metadata || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	err = tdh_vp_init(tdx->tdvpr.pa, cmd.data);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_VP_INIT, err, NULL);
+		return -EIO;
+	}
+
+	tdx->initialized = true;
+	return 0;
+}
+
 static int __tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f116c40ac319..4ce7fcab6f64 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -27,6 +27,8 @@ struct kvm_tdx {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 
+	bool finalized;
+
 	u64 tsc_offset;
 	unsigned long tsc_khz;
 };
@@ -36,6 +38,8 @@ struct vcpu_tdx {
 
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
+
+	bool initialized;
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f1640f201a19..81f246493ec7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,6 +142,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline void tdx_pre_kvm_init(
 	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
@@ -158,6 +159,7 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 158e1891ac14..c52a052e208c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5680,6 +5680,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_DEVICE_ATTR:
 		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
 		break;
+	case KVM_MEMORY_ENCRYPT_OP:
+		r = -EINVAL;
+		if (!kvm_x86_ops.mem_enc_op_vcpu)
+			goto out;
+		r = kvm_x86_ops.mem_enc_op_vcpu(vcpu, argp);
+		break;
 	default:
 		r = -EINVAL;
 	}
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 6e26dde0dce6..9702f0d95776 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -532,6 +532,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

