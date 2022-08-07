Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7598C58BD5D
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiHGWEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbiHGWCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F73E959A;
        Sun,  7 Aug 2022 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909761; x=1691445761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Csz2jDUMfOQUZm1X19XDYrdo4YtxanBIxSXg8sYWpSY=;
  b=R659TMHAtj7BzsgX0/kbt3xWZDQMMe8rxqky5/hILeaAqq8CNc+SqfxI
   HIB8rnK4XQjDFoDWX5qtk3aFfx1B4i54pg7mIeQY5UEaWqh47gNBL+Nxy
   1Amm60unOCwoKwluU/TURF7UTUYFFZteI1T/9sIFFrZ07MMTOeh5bylf0
   mkd7Yebo6N6C9Qgj0j5jtf3ht86RMI1iHsZDdc1AA4IzLwCvK+fB3T75V
   1383SAUixrH1rzQTrR0mBa4axtqPCYPcY4Q2cq8E5whT1c+qLDmyfArPB
   +cWOU/ePxox2HJKrbCfqCWMEeeWRRwYbqQem9A8qdiaQnAcg1anYYmPe8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224099"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224099"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682522"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:33 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 027/103] KVM: TDX: Do TDX specific vcpu initialization
Date:   Sun,  7 Aug 2022 15:01:12 -0700
Message-Id: <c02d3a975e984fadb02673fe7fc234bd251f858b.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/include/asm/kvm-x86-ops.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  1 +
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/vmx/main.c               |  9 +++++++
 arch/x86/kvm/vmx/tdx.c                | 36 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  4 +++
 arch/x86/kvm/vmx/x86_ops.h            |  2 ++
 arch/x86/kvm/x86.c                    |  6 +++++
 tools/arch/x86/include/uapi/asm/kvm.h |  1 +
 9 files changed, 61 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d8d48a8f602c..de392bee9159 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -119,6 +119,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8131256e69ff..e856abbe80ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1613,6 +1613,7 @@ struct kvm_x86_ops {
 
 	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 97ce34d746af..3cd723b7e2cf 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -539,6 +539,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4f4ed4ad65a7..ce12cc8276ef 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -113,6 +113,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	return tdx_vm_ioctl(kvm, argp);
 }
 
+static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	if (!is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return tdx_vcpu_ioctl(vcpu, argp);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -255,6 +263,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ee682a65b233..37272fe1e69f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -69,6 +69,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
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
@@ -784,6 +789,37 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	u64 err;
+
+	if (tdx->vcpu_initialized)
+		return -EINVAL;
+
+	if (!is_td_initialized(vcpu->kvm) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.error || cmd.unused)
+		return -EINVAL;
+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	err = tdh_vp_init(tdx->tdvpr.pa, cmd.data);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_VP_INIT, err, NULL);
+		return -EIO;
+	}
+
+	tdx->vcpu_initialized = true;
+	return 0;
+}
+
 int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 3b34dfdbc699..91961d4f4b65 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -25,6 +25,8 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	bool finalized;
+
 	u64 tsc_offset;
 };
 
@@ -34,6 +36,8 @@ struct vcpu_tdx {
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
 
+	bool vcpu_initialized;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b98bbcd9ef42..b4ffa1590d41 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -143,6 +143,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
@@ -159,6 +160,7 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f0784f506a16..702012f56502 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5901,6 +5901,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_DEVICE_ATTR:
 		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
 		break;
+	case KVM_MEMORY_ENCRYPT_OP:
+		r = -ENOTTY;
+		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
+			goto out;
+		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);
+		break;
 	default:
 		r = -EINVAL;
 	}
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 965a1c2e347d..938fcf6bc002 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -533,6 +533,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

