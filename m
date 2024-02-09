Return-Path: <kvm+bounces-8470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E0684FC41
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB732B2CA92
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A721292D7;
	Fri,  9 Feb 2024 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJRcPuWn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFF78288B
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707503874; cv=none; b=auZtMyo1bAFpOKuMkda6kxlWiSNcPcg2M9mfSlbtoIjB54iO3SF11NgaN+aJf8NOyTh2Kz03mimkmhJOd7xZEnrEb+luVdSm6j9E3xeAluevMc6FhyvDv7JtblwfGE9fWwI2Hiwajbd+t6I1AysAhPVsnwX8Nq9300kD067zzVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707503874; c=relaxed/simple;
	bh=p9XbuM+3mx1bbe8WFegD4GtDeDLMjPkGkOvBs6sIf6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fW9r2CEczq1Zzov8GF0B35Md67jjPZIk61Zywo9GOoa+xC0nkXbcK1jPZgnB/FOKmw7GXKsLXb2xhEBohwUqRk4yps2RrMwVmn8kyYtN+0ktBSSA0VRE7rWXjQaELlS+WbMiXPwc+Ahsaj/hdhUvDkdDiLWpuPbIhBY8P3U1AVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJRcPuWn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707503870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mGmAR+j/+7zxlBMY+sh8amh5lWxJNxwj6S5dPuiILUU=;
	b=XJRcPuWngvCmsJD26ECxHQ3dax18SbPU1dzUQo2Z7wfX2mko8iLibpDBUliKlF3DVzwjtS
	poWfjQlxoJ7WflZFczxV1or6eldRbzVplICU+Bo3k4gx/IFDlpKoovxgG4YegLp9b2Ut1+
	S/haD3PppksUdp6+O8hobMXQWuH3t34=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-DS7xU7L8MeGbd6FS7fsGNA-1; Fri, 09 Feb 2024 13:37:45 -0500
X-MC-Unique: DS7xU7L8MeGbd6FS7fsGNA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6459185A788;
	Fri,  9 Feb 2024 18:37:44 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9915C492BC6;
	Fri,  9 Feb 2024 18:37:44 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 04/10] KVM: SEV: publish supported VMSA features
Date: Fri,  9 Feb 2024 13:37:36 -0500
Message-Id: <20240209183743.22030-5-pbonzini@redhat.com>
In-Reply-To: <20240209183743.22030-1-pbonzini@redhat.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Compute the set of features to be stored in the VMSA when KVM is
initialized; move it from there into kvm_sev_info when SEV is initialized,
and then into the initial VMSA.

The new variable can then be used to return the set of supported features
to userspace, via the KVM_GET_DEVICE_ATTR ioctl.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 12 ++++++++++
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/svm/sev.c                        | 22 +++++++++++++++++--
 arch/x86/kvm/svm/svm.c                        |  1 +
 arch/x86/kvm/svm/svm.h                        |  1 +
 5 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 37c5c37f4f6e..5ed11bc16b96 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -424,6 +424,18 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+Device attribute API
+====================
+
+Attributes of the SEV implementation can be retrieved through the
+``KVM_HAS_DEVICE_ATTR`` and ``KVM_GET_DEVICE_ATTR`` ioctls on the ``/dev/kvm``
+device node.
+
+Currently only one attribute is implemented:
+
+* group 0, attribute ``KVM_X86_SEV_VMSA_FEATURES``: return the set of all
+  bits that are accepted in the ``vmsa_features`` of ``KVM_SEV_INIT2``.
+
 Firmware Management
 ===================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index b305daff056e..cccaa5ff6d01 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -459,6 +459,7 @@ struct kvm_sync_regs {
 
 /* attributes for system fd (group 0) */
 #define KVM_X86_XCOMP_GUEST_SUPP	0
+#define KVM_X86_SEV_VMSA_FEATURES	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c31f8..2e558f7538c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -65,6 +65,7 @@ module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 #define sev_es_debug_swap_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+static u64 sev_supported_vmsa_features;
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -612,8 +613,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_es_debug_swap_enabled)
-		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+	save->sev_features = sev_supported_vmsa_features;
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
@@ -1849,6 +1849,20 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+int sev_dev_get_attr(u64 attr, u64 *val)
+{
+	switch (attr) {
+#ifdef CONFIG_KVM_AMD_SEV
+	case KVM_X86_SEV_VMSA_FEATURES:
+		*val = sev_supported_vmsa_features;
+		return 0;
+#endif
+
+	default:
+		return -ENXIO;
+	}
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2276,6 +2290,10 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
+
+	sev_supported_vmsa_features = 0;
+	if (sev_es_debug_swap_enabled)
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..aa1792f402ab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5014,6 +5014,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_smi_window = svm_enable_smi_window,
 #endif
 
+	.dev_get_attr = sev_dev_get_attr,
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
 	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..d630026b23b0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -671,6 +671,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 extern unsigned int max_sev_asid;
 
 void sev_vm_destroy(struct kvm *kvm);
+int sev_dev_get_attr(u64 attr, u64 *val);
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range);
-- 
2.39.0



