Return-Path: <kvm+bounces-12047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C9187F407
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F51C283C87
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DBA5FB8B;
	Mon, 18 Mar 2024 23:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNRRGm2P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F12A5F85C
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804839; cv=none; b=bGpaKFTq6zoogQGv2QMDujXwbYhaBm8PYNAyo95eA62tg2+H+N4i6Mduv+q8ThMXqpmQETyooKC907ePGOqDEzYFXXmlFLYsrM7qxC04+iZWY84RPz+kxN8Hlq6eomCWhMDHvyb7FeEbDJENcX4c3oL/IRIj2ROfW9oQirnF1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804839; c=relaxed/simple;
	bh=i5gwrzMS2HNl76Uc/FxxfXQS70NRMCRGUuxiOfEz8cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ERl64ccy2/a9/im8cRnQHg389k2PdzGtXOMPZAglKaRqsPjjNTKaxbPF7HiblFkZSZ25WYVYH7Im1Cx5wIVRCvW4cgGtvLCTptH3zcHrYOueOa/sLO1endDWVWyUK2bQxAy9op9z9CeRBowcsYL+aDP8LoyBqzTzZV6XN9yjIts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNRRGm2P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3PbgxRhwV/Vx0juxMY6DUZ6KqhgB5Uik8V0TA6I1do=;
	b=PNRRGm2PabhEU5xm3kA3uu1dS3qtu8qGl3ksPal2UNeFfumuPJ5nW5i4MJ1f7VEPuzlgpP
	3Q1chqFE2qAXtPiOuxFheTzc3ducIneXJZMVIuIshETdJCSOyDPEoxEDzXYAojVQMMpbh4
	UXA8dYuLmSVYfaRLDquM4m5KdAKSOqE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-6Nmn9jhiOK6uoPvTYn2OPQ-1; Mon, 18 Mar 2024 19:33:55 -0400
X-MC-Unique: 6Nmn9jhiOK6uoPvTYn2OPQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD0278007A1;
	Mon, 18 Mar 2024 23:33:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5F2C1121312;
	Mon, 18 Mar 2024 23:33:54 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 05/15] KVM: SEV: publish supported VMSA features
Date: Mon, 18 Mar 2024 19:33:42 -0400
Message-ID: <20240318233352.2728327-6-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
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
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 12 +++++++++++
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/svm/sev.c                        | 21 +++++++++++++++++--
 arch/x86/kvm/svm/svm.c                        |  1 +
 arch/x86/kvm/svm/svm.h                        |  2 ++
 5 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 84335d119ff1..fb41470c0310 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -425,6 +425,18 @@ issued by the hypervisor to make the guest ready for execution.
 
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
index 73fee5f08391..22c35a39c25f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -43,6 +43,7 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = false;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+static u64 sev_supported_vmsa_features;
 
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -600,8 +601,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_es_debug_swap_enabled) {
-		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+	if (sev_supported_vmsa_features) {
+		save->sev_features = sev_supported_vmsa_features;
 		pr_warn_once("Enabling DebugSwap with KVM_SEV_ES_INIT. "
 			     "This will not work starting with Linux 6.10\n");
 	}
@@ -1840,6 +1841,18 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -2272,6 +2285,10 @@ void __init sev_hardware_setup(void)
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
index e7f47a1f3eb1..450535d6757f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5026,6 +5026,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
+	.dev_get_attr = sev_dev_get_attr,
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
 	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d20e48c31210..864fac367424 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -695,6 +695,7 @@ void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
@@ -707,6 +708,7 @@ static inline void __init sev_set_cpu_caps(void) {}
 static inline void __init sev_hardware_setup(void) {}
 static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
+static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 #endif
 
-- 
2.43.0



