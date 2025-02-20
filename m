Return-Path: <kvm+bounces-38754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 545EEA3E220
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74B943BA09D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE4D22A1CB;
	Thu, 20 Feb 2025 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YG4g6W6J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBCC2139D1
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071216; cv=none; b=Dbv1GTf7iAfL5dBWweLHU9jaoMzMh6D9/YhjlEos4WIzhOM8//ZHmENVc3lG+g6XC7PueEqzvWgnNqR8sWqt+VginwktkkFL1tx5tC5Di7ru9XEkkMo67luQqL3kxuCrTw6aWB+SexNntZXWy5vOAmuWkSb+mJxdTN/xc0CpZNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071216; c=relaxed/simple;
	bh=SRUHghBt0EjAXA2PPZey7S9tMi48R+sW2GBl1FWSsZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAUWLf1P9rSaAFgu03I/qKbcBa3AJcI2KtJJUIbKoozlq7F/E/aJ2CzWQ+4Bg18/5z/+eS/jxTOjulmMAgR0tQ485AYKGbarc9zxK1woEEMQKDenwTCWl2ym22uOc/LUsSv3iv5kH34wK/bBgfdQKpYruOUZysY8iD40oSnd42k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YG4g6W6J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FKThzOWBhSgB3n7KXEQU7sCM801172+qrbI8O9kVTnc=;
	b=YG4g6W6J8pAwebzW77kc938pdvD3iGrp2ciWCrFNJxhQtMeQ2c04alynY6URiY4PAEWPet
	jXOxgQr3keWOAf3vjjfQHw+YH1HqD+02WUVyv1Z4AA5fiQOLseZGHLu58kyjY4VJfwc1S3
	Vj4bBVPHaDEd84vpUI91WgvPy9N/iyc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-gasat3lHOJqHNxNPIJRoyA-1; Thu,
 20 Feb 2025 12:06:48 -0500
X-MC-Unique: gasat3lHOJqHNxNPIJRoyA-1
X-Mimecast-MFC-AGG-ID: gasat3lHOJqHNxNPIJRoyA_1740071206
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D74719030A0;
	Thu, 20 Feb 2025 17:06:46 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2929819412A3;
	Thu, 20 Feb 2025 17:06:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 27/30] KVM: TDX: Do TDX specific vcpu initialization
Date: Thu, 20 Feb 2025 12:06:01 -0500
Message-ID: <20250220170604.2279312-28-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

TD guest vcpu needs TDX specific initialization before running.  Repurpose
KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
KVM_TDX_INIT_VCPU, and implement the callback for it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 - Fix comment: https://lore.kernel.org/kvm/Z36OYfRW9oPjW8be@google.com/
   (Sean)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/lapic.c               |   1 +
 arch/x86/kvm/vmx/main.c            |   9 ++
 arch/x86/kvm/vmx/tdx.c             | 172 ++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h             |  11 +-
 arch/x86/kvm/vmx/x86_ops.h         |   4 +
 arch/x86/kvm/x86.c                 |   7 ++
 9 files changed, 205 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index bb909e6125b4..e9e4cecd6897 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -127,6 +127,7 @@ KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP_OPTIONAL(dev_get_attr)
 KVM_X86_OP(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 831b20830a09..1d3d0dfcc572 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1847,6 +1847,7 @@ struct kvm_x86_ops {
 
 	int (*dev_get_attr)(u32 group, u64 attr, u64 *val);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index b64351076f2a..9316afbd4a88 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -931,6 +931,7 @@ struct kvm_hyperv_eventfd {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a009c94c26c2..a1cbca31ec30 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2657,6 +2657,7 @@ int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_apic_set_base);
 
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d06f9f0519bd..d78f0cf3dd9c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -106,6 +106,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -262,6 +270,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_untagged_addr = vmx_get_untagged_addr,
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4ab5c994d877..7dfb0b486dd9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -424,6 +424,7 @@ int tdx_vm_init(struct kvm *kvm)
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (kvm_tdx->state != TD_STATE_INITIALIZED)
 		return -EIO;
@@ -447,12 +448,42 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
 
+	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
+
 	return 0;
 }
 
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	/* This is stub for now.  More logic will come. */
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/*
+	 * It is not possible to reclaim pages while hkid is assigned. It might
+	 * be assigned if:
+	 * 1. the TD VM is being destroyed but freeing hkid failed, in which
+	 * case the pages are leaked
+	 * 2. TD VCPU creation failed and this on the error path, in which case
+	 * there is nothing to do anyway
+	 */
+	if (is_hkid_assigned(kvm_tdx))
+		return;
+
+	if (tdx->vp.tdcx_pages) {
+		for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
+			if (tdx->vp.tdcx_pages[i])
+				tdx_reclaim_control_page(tdx->vp.tdcx_pages[i]);
+		}
+		kfree(tdx->vp.tdcx_pages);
+		tdx->vp.tdcx_pages = NULL;
+	}
+	if (tdx->vp.tdvpr_page) {
+		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
+		tdx->vp.tdvpr_page = 0;
+	}
+
+	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -662,6 +693,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_hkid;
 
 	kvm_tdx->td.tdcs_nr_pages = tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
+	/* TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages), -1 for TDVPR. */
+	kvm_tdx->td.tdcx_nr_pages = tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
 	tdcs_pages = kcalloc(kvm_tdx->td.tdcs_nr_pages, sizeof(*kvm_tdx->td.tdcs_pages),
 			     GFP_KERNEL | __GFP_ZERO);
 	if (!tdcs_pages)
@@ -938,6 +971,143 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct page *page;
+	int ret, i;
+	u64 err;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	tdx->vp.tdvpr_page = page;
+
+	tdx->vp.tdcx_pages = kcalloc(kvm_tdx->td.tdcx_nr_pages, sizeof(*tdx->vp.tdcx_pages),
+			       	     GFP_KERNEL);
+	if (!tdx->vp.tdcx_pages) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+
+	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page) {
+			ret = -ENOMEM;
+			goto free_tdcx;
+		}
+		tdx->vp.tdcx_pages[i] = page;
+	}
+
+	err = tdh_vp_create(&kvm_tdx->td, &tdx->vp);
+	if (KVM_BUG_ON(err, vcpu->kvm)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_CREATE, err);
+		goto free_tdcx;
+	}
+
+	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
+		err = tdh_vp_addcx(&tdx->vp, tdx->vp.tdcx_pages[i]);
+		if (KVM_BUG_ON(err, vcpu->kvm)) {
+			pr_tdx_error(TDH_VP_ADDCX, err);
+			/*
+			 * Pages already added are reclaimed by the vcpu_free
+			 * method, but the rest are freed here.
+			 */
+			for (; i < kvm_tdx->td.tdcx_nr_pages; i++) {
+				__free_page(tdx->vp.tdcx_pages[i]);
+				tdx->vp.tdcx_pages[i] = NULL;
+			}
+			return -EIO;
+		}
+	}
+
+	err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
+	if (KVM_BUG_ON(err, vcpu->kvm)) {
+		pr_tdx_error(TDH_VP_INIT, err);
+		return -EIO;
+	}
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return 0;
+
+free_tdcx:
+	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
+		if (tdx->vp.tdcx_pages[i])
+			__free_page(tdx->vp.tdcx_pages[i]);
+		tdx->vp.tdcx_pages[i] = NULL;
+	}
+	kfree(tdx->vp.tdcx_pages);
+	tdx->vp.tdcx_pages = NULL;
+
+free_tdvpr:
+	if (tdx->vp.tdvpr_page)
+		__free_page(tdx->vp.tdvpr_page);
+	tdx->vp.tdvpr_page = 0;
+
+	return ret;
+}
+
+static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
+{
+	u64 apic_base;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int ret;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	if (tdx->state != VCPU_TD_STATE_UNINITIALIZED)
+		return -EINVAL;
+
+	/*
+	 * TDX requires X2APIC, userspace is responsible for configuring guest
+	 * CPUID accordingly.
+	 */
+	apic_base = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
+		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0);
+	if (kvm_apic_set_base(vcpu, apic_base, true))
+		return -EINVAL;
+
+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd->data);
+	if (ret)
+		return ret;
+
+	tdx->state = VCPU_TD_STATE_INITIALIZED;
+
+	return 0;
+}
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct kvm_tdx_cmd cmd;
+	int ret;
+
+	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.hw_error)
+		return -EINVAL;
+
+	switch (cmd.id) {
+	case KVM_TDX_INIT_VCPU:
+		ret = tdx_vcpu_init(vcpu, &cmd);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f12854c8ff07..c3bde94c19dc 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -32,9 +32,18 @@ struct kvm_tdx {
 	struct tdx_td td;
 };
 
+/* TDX module vCPU states */
+enum vcpu_tdx_state {
+	VCPU_TD_STATE_UNINITIALIZED = 0,
+	VCPU_TD_STATE_INITIALIZED,
+};
+
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
-	/* TDX specific members follow. */
+
+	struct tdx_vp vp;
+
+	enum vcpu_tdx_state state;
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6e1ff7d88b61..499566441717 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -130,6 +130,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
@@ -139,6 +141,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 007195d9ab0b..70a33c0a6e6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6275,6 +6275,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -12660,6 +12666,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.43.5



