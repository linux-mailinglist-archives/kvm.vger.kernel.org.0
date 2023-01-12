Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A16667B63
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjALQmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbjALQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A55B4BC;
        Thu, 12 Jan 2023 08:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541237; x=1705077237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vb4LigEtfMJgCGZNB450fBnom1WQXOq4e/Bhz+HX24A=;
  b=PuJdhZtfED2FnncGllvY8mpKnGIWXKBCjJgXLl95tBNy9oRJh0m80AAT
   P0lKBuXou9hswdHukD5Gbomed3N/G0Sr4AYwzi90NQeaEeBvovDD2MNS8
   rHWQbLUCmJWBJcXTG5Ma75C8EQ3MK2I5UOf1/olaxw2CTWjejQh+CbB++
   //zJLIV7AGgnZ0kmRD00buR/JoI9PmYMITwFk4dnuJLURUKwL0f+bvYeA
   nvyNO8XmaMSwIDEfm5QL0clVvNYhNaE1ZPLK+P69mE8tPuwnDiYZMdyfT
   uCdqUy7gi4I1+wTy5m/mcbYYwI1ZwQ7BWj7HotmPt1eTIe1zFHMON2hKN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811763"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811763"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151704"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151704"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:23 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 024/113] KVM: TDX: Do TDX specific vcpu initialization
Date:   Thu, 12 Jan 2023 08:31:32 -0800
Message-Id: <c8f51a32315dce7d4f48d9ae6668da249e22a432.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

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
 arch/x86/include/asm/kvm-x86-ops.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |   1 +
 arch/x86/include/uapi/asm/kvm.h       |   1 +
 arch/x86/kvm/vmx/main.c               |   9 ++
 arch/x86/kvm/vmx/tdx.c                | 147 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                |   7 ++
 arch/x86/kvm/vmx/x86_ops.h            |  10 +-
 arch/x86/kvm/x86.c                    |   6 ++
 tools/arch/x86/include/uapi/asm/kvm.h |   1 +
 9 files changed, 178 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 1a27f3aee982..e3e9b1c2599b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,6 +123,7 @@ KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 30f4ddb18548..35773f925cc5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1698,6 +1698,7 @@ struct kvm_x86_ops {
 
 	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index b8f28d86d4fd..9236c1699c48 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -536,6 +536,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 59813ca05f36..23b3ffc3fe23 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -103,6 +103,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
 	.name = KBUILD_MODNAME,
 
@@ -249,6 +257,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 099f0737a5aa..e2f5a07ad4e5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
+static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
+{
+	return tdx->tdvpr_pa;
+}
+
 static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
 {
 	return kvm_tdx->tdr_pa;
@@ -65,6 +70,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->hkid > 0;
 }
 
+static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->finalized;
+}
+
 static void tdx_clear_page(unsigned long page_pa)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -327,7 +337,21 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	/* This is stub for now.  More logic will come. */
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/* Can't reclaim or free pages if teardown failed. */
+	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
+		return;
+
+	if (tdx->tdvpx_pa) {
+		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
+			tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
+		kfree(tdx->tdvpx_pa);
+		tdx->tdvpx_pa = NULL;
+	}
+	tdx_reclaim_td_page(tdx->tdvpr_pa);
+	tdx->tdvpr_pa = 0;
 }
 
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -337,6 +361,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/* TDX doesn't support INIT event. */
 	if (WARN_ON_ONCE(init_event))
 		goto td_bugged;
+	if (WARN_ON_ONCE(is_td_vcpu_created(to_tdx(vcpu))))
+		goto td_bugged;
 
 	/* TDX rquires X2APIC. */
 	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
@@ -791,6 +817,125 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	unsigned long *tdvpx_pa = NULL;
+	unsigned long tdvpr_pa;
+	unsigned long va;
+	int ret, i;
+	u64 err;
+
+	if (is_td_vcpu_created(tdx))
+		return -EINVAL;
+
+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!va)
+		return -ENOMEM;
+	tdvpr_pa = __pa(va);
+
+	tdvpx_pa = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx_pa),
+			   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!tdvpx_pa) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
+		if (!va)
+			goto free_tdvpx;
+		tdvpx_pa[i] = __pa(va);
+	}
+
+	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
+	if (WARN_ON_ONCE(err)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
+		goto td_bugged_free_tdvpx;
+	}
+	tdx->tdvpr_pa = tdvpr_pa;
+
+	tdx->tdvpx_pa = tdvpx_pa;
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
+		if (WARN_ON_ONCE(err)) {
+			ret = -EIO;
+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
+			for (; i < tdx_caps.tdvpx_nr_pages; i++) {
+				free_page((unsigned long)__va(tdvpx_pa[i]));
+				tdvpx_pa[i] = 0;
+			}
+			goto td_bugged;
+		}
+	}
+
+	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
+	if (WARN_ON_ONCE(err)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_INIT, err, NULL);
+		goto td_bugged;
+	}
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return 0;
+
+td_bugged_free_tdvpx:
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		free_page((unsigned long)__va(tdvpx_pa[i]));
+		tdvpx_pa[i] = 0;
+	}
+	kfree(tdvpx_pa);
+td_bugged:
+	vcpu->kvm->vm_bugged = true;
+	return ret;
+
+free_tdvpx:
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
+		if (tdvpx_pa[i])
+			free_page((unsigned long)__va(tdvpx_pa[i]));
+	kfree(tdvpx_pa);
+	tdx->tdvpx_pa = NULL;
+free_tdvpr:
+	if (tdvpr_pa)
+		free_page((unsigned long)__va(tdvpr_pa));
+	tdx->tdvpr_pa = 0;
+
+	return ret;
+}
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	int ret;
+
+	if (tdx->vcpu_initialized)
+		return -EINVAL;
+
+	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.error || cmd.unused)
+		return -EINVAL;
+
+	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
+	if (ret)
+		return ret;
+
+	tdx->vcpu_initialized = true;
+	return 0;
+}
+
 static int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index af7fdc1516d5..e909883d60fa 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,12 +17,19 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	bool finalized;
+
 	u64 tsc_offset;
 };
 
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
+	unsigned long tdvpr_pa;
+	unsigned long *tdvpx_pa;
+
+	bool vcpu_initialized;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 37ab2cfd35bc..fba8d0800597 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -148,11 +148,12 @@ int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
 
-int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
-
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -165,11 +166,12 @@ static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
 
-static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
-
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+
+static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e8bc66031a1d..d548d3af6428 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5976,6 +5976,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index eb800965b589..6971f1288043 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

