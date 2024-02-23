Return-Path: <kvm+bounces-9513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C43C3860FA3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75C992865E3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6CA63104;
	Fri, 23 Feb 2024 10:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQqxvjeZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAD6166C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684819; cv=none; b=ONyv08gS8QomNvo4CKZ7yP2FE5QhhUXnvcIdAxUB3dPA/GTQ7aDV7nduS7TZdxZpzf7goDkuh7QGs0rRDXwSS+hckXwwkxy9QhnlioWN+DIYL3EVZyletFMi+XisjWysA96ZicSZtbgYmeDkfcygyO7tQu4ZnLQtua2q4bWkKVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684819; c=relaxed/simple;
	bh=WiHo26olXym8uZAe6XD29P5g1iEmbJr12ucwrhJHnGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTeV2ddtOM3YF3d4ojfsBdgdBdNfjoIrVjtvgqX9vAS2O2dJltxr66MASni71VJA5+AFYeZ07yMR6taK6lY0FZ0T0u2vr0LhHVd4Hn08e/umEpFzY2ZJVN9jdW+dPZAetD/y4/BFvYNcg4FTBU3F+U4TSE1vx+JiQFzIe1JpPwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MQqxvjeZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708684814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uGLY1gjVWOR89SFnq4m2u7ro5SjWOGyLr82g9TmbgOU=;
	b=MQqxvjeZymkuNnrI/M47T3A+C6E/6amWt+9zRRiwJ/7K5tr/v/HzkJrgvBZeh+3qdqFz6U
	Mceeg+UfNsgPWilOD+XfthzgQW6WgIeYUElEyuIdk4hZtWqyL3Opd3hem03/fvFVjQ6c7E
	IpDEwdwzI5oeYdIFvCJRMkEBII25ETA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-hrKTSp14MeSYYUCq4hVc5w-1; Fri,
 23 Feb 2024 05:40:11 -0500
X-MC-Unique: hrKTSp14MeSYYUCq4hVc5w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 342E63806720;
	Fri, 23 Feb 2024 10:40:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DBEB112132A;
	Fri, 23 Feb 2024 10:40:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v2 04/11] KVM: SEV: publish supported VMSA features
Date: Fri, 23 Feb 2024 05:40:02 -0500
Message-Id: <20240223104009.632194-5-pbonzini@redhat.com>
In-Reply-To: <20240223104009.632194-1-pbonzini@redhat.com>
References: <20240223104009.632194-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Compute the set of features to be stored in the VMSA when KVM is
initialized; move it from there into kvm_sev_info when SEV is initialized,
and then into the initial VMSA.

The new variable can then be used to return the set of supported features
to userspace, via the KVM_GET_DEVICE_ATTR ioctl.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20240209183743.22030-5-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 12 ++++++++++
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++--
 arch/x86/kvm/svm/svm.c                        |  1 +
 arch/x86/kvm/svm/svm.h                        |  1 +
 5 files changed, 36 insertions(+), 2 deletions(-)

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
index f760106c31f8..53e958805ab9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,10 +59,12 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+static u64 sev_supported_vmsa_features;
 #else
 #define sev_enabled false
 #define sev_es_enabled false
 #define sev_es_debug_swap_enabled false
+#define sev_supported_vmsa_features 0
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
@@ -612,8 +614,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_es_debug_swap_enabled)
-		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+	save->sev_features = sev_supported_vmsa_features;
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
@@ -1849,6 +1850,20 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -2276,6 +2291,10 @@ void __init sev_hardware_setup(void)
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
2.39.1



