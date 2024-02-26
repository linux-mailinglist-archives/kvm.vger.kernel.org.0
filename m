Return-Path: <kvm+bounces-9975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DF1868064
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B77131F27EDA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEACC131755;
	Mon, 26 Feb 2024 19:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKRYEeZP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FA312FF68
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974236; cv=none; b=rpOX0LEdIVhSC7JEEZ2+H2b3BCzuVTdwkI+o9mcG9a9IxmLJshH+tcrFXDErBtifGVeUVj8UrjtbvtWvWXqD4j7XlSJJYorAa19YLfwmR5j4SHxBRWvmmV5lrwJVKWNyZwS0Qo54fQC4QgKr4SqqDT41D5blvmBZwSgQm0CclCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974236; c=relaxed/simple;
	bh=HJtfOPqlQHYsyu4LuLGYOVpdrVW0qw+83oQO8vP7UIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXCGx1KX2DFneBxM+8O5wsuPdxf5UT93LYODUBBlNAhnClt4pg5Bj4/FqaqGK1g7gNIFtPgwP+SP0e8SPzZCxIwqOVOJVkhNpl4HgAdZyYnXQryIMIwpmuPtGYcA76MMGhKgRyjcdP2kJxWef/or02Q4MKA+yLeDUCCvaTzdGmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKRYEeZP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/2oRdroCx091i44wktZ7UeGTfa/yYpOncGeIYi3Q1ZE=;
	b=BKRYEeZPG4pEw9f7pEU5lyJMhMU6SGVU7XpKSCQR7ZSmd6yJ6AXa0Tww8Soxm55eOMkHIJ
	B9pQlrYy5HcLDtTbSMp2iLrvGaxdwKi3jXNCk6xtDCt18NeBvZm30r2jphs+lM56JNlWGW
	GzSQIf/KGyx3l/mBpGxm8/pJDn3B+1w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-vcF25hG7OUilrjb1q42_6g-1; Mon,
 26 Feb 2024 14:03:47 -0500
X-MC-Unique: vcF25hG7OUilrjb1q42_6g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 169FB3C14949;
	Mon, 26 Feb 2024 19:03:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E24B5492BC7;
	Mon, 26 Feb 2024 19:03:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 07/15] KVM: SEV: publish supported VMSA features
Date: Mon, 26 Feb 2024 14:03:36 -0500
Message-Id: <20240226190344.787149-8-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
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
 .../virt/kvm/x86/amd-memory-encryption.rst    | 12 +++++++++++
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/svm/sev.c                        | 20 +++++++++++++++++--
 arch/x86/kvm/svm/svm.c                        |  1 +
 arch/x86/kvm/svm/svm.h                        |  2 ++
 5 files changed, 34 insertions(+), 2 deletions(-)

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
index ef11aa4cab42..d0c1b459f7e9 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -459,6 +459,7 @@ struct kvm_sync_regs {
 
 /* attributes for system fd (group 0) */
 #define KVM_X86_XCOMP_GUEST_SUPP	0
+#define KVM_X86_SEV_VMSA_FEATURES	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2f4f54ab8e1b..16a5c64232b7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -43,6 +43,7 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+static u64 sev_supported_vmsa_features;
 
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -597,8 +598,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_es_debug_swap_enabled)
-		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+	save->sev_features = sev_supported_vmsa_features;
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
@@ -1834,6 +1834,18 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+int sev_dev_get_attr(u64 attr, u64 *val)
+{
+	switch (attr) {
+	case KVM_X86_SEV_VMSA_FEATURES:
+		*val = sev_supported_vmsa_features;
+		return 0;
+
+	default:
+		return -ENXIO;
+	}
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2264,6 +2276,10 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
+
+	sev_supported_vmsa_features = 0;
+	if (sev_es_debug_swap_enabled)
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
 void sev_hardware_unsetup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eaa973dbe543..595642099772 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5017,6 +5017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
+	.dev_get_attr = sev_dev_get_attr,
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
 	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 52bc955ed06f..8f2394169703 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -692,8 +692,10 @@ void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 #else
+static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
 static inline void sev_vm_destroy(struct kvm *kvm) {}
 static inline void __init sev_set_cpu_caps(void) {}
-- 
2.39.1



