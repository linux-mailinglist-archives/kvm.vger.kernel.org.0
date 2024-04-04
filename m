Return-Path: <kvm+bounces-13545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A5538986E9
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14E428D04C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4310412880F;
	Thu,  4 Apr 2024 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c78LOx0w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F40185624
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232816; cv=none; b=EkbP4b/a7XPfv2i2glFfZIOfPZ9sSAe2COchiat6Vq/HFHeVD3FJZWSWtGBP4q5vjSdN5KhUbvRRgiIrhktTqmEm6xQq0nEEVKsHeL1WmfRRppTBkGSwbjKSvVk9e3k2KMzbhKzhwzDqwDjdPBLuBz2aIZ7XXIV9a8sb+gx7r00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232816; c=relaxed/simple;
	bh=dDnXQG83NREX0KGTuArR2KluZTWpu8CC8OC0sfsRtSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFSCwZLeI02+Pc5vxXyqxjo4QsvamQzVxwrpZ/VqGpytAo3jzsPii0OtvOhw53wo3CdTDq0pPTB9EvItBI6kfp79y4tZHwfMMd5+/wfRu6qJTPLZHeMCLhq/yUVTMGGBJNF/eKz5d2CZ7bPKtr9NZF8x4IFG5KcultIG7ZJYuk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c78LOx0w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W5Uc8faQRJYSlCpg4awEicXOFHLwoDeIhfe16I6jRNg=;
	b=c78LOx0w1yxjFTgDMWyVlZAVe9yzFfs87lq9wzPbRGPdc8tPXI+/jl2gYfL+r5Sm8QOcVL
	EQLwt3nL28p56SkZZuzOXtHZF0WPFv32bUOaZHPjRAfepzXWVvhp3eBCVlEbp9a3zOBUOc
	7qsQ4zLITNJCbdEhBf2MbfZKggXNgGI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-bPd2qbELOiKncFBd8YmjKw-1; Thu,
 04 Apr 2024 08:13:30 -0400
X-MC-Unique: bPd2qbELOiKncFBd8YmjKw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60DE61C05AB6;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CDE4492BC6;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH v5 10/17] KVM: SEV: define VM types for SEV and SEV-ES
Date: Thu,  4 Apr 2024 08:13:20 -0400
Message-ID: <20240404121327.3107131-11-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst  |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 16 +++++++++++++---
 arch/x86/kvm/svm/svm.c          | 11 +++++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..f0b76ff5030d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8819,6 +8819,8 @@ means the VM type with value @n is supported.  Possible values of @n are::
 
   #define KVM_X86_DEFAULT_VM	0
   #define KVM_X86_SW_PROTECTED_VM	1
+  #define KVM_X86_SEV_VM	2
+  #define KVM_X86_SEV_ES_VM	3
 
 Note, KVM_X86_SW_PROTECTED_VM is currently only for development and testing.
 Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index b7dc515f4c27..ab609adacb11 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -861,5 +861,7 @@ struct kvm_hyperv_eventfd {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_SEV_VM		2
+#define KVM_X86_SEV_ES_VM	3
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f98448dc8be8..1512bacd74a9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -251,6 +251,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
+	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+		return -EINVAL;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
@@ -272,6 +275,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	INIT_LIST_HEAD(&sev->regions_list);
 	INIT_LIST_HEAD(&sev->mirror_vms);
+	sev->need_init = false;
 
 	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
 
@@ -1808,7 +1812,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (sev_guest(kvm) || !sev_guest(source_kvm)) {
+	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
+	    sev_guest(kvm) || !sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2132,6 +2137,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->asid = source_sev->asid;
 	mirror_sev->fd = source_sev->fd;
 	mirror_sev->es_active = source_sev->es_active;
+	mirror_sev->need_init = false;
 	mirror_sev->handle = source_sev->handle;
 	INIT_LIST_HEAD(&mirror_sev->regions_list);
 	INIT_LIST_HEAD(&mirror_sev->mirror_vms);
@@ -2197,10 +2203,14 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
-	if (sev_enabled)
+	if (sev_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV);
-	if (sev_es_enabled)
+		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
+	}
+	if (sev_es_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
+		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
+	}
 }
 
 void __init sev_hardware_setup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c22e87ebf0de..b0038ece55cb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4086,6 +4086,9 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
+	if (to_kvm_sev_info(vcpu->kvm)->need_init)
+		return -EINVAL;
+
 	return 1;
 }
 
@@ -4891,6 +4894,14 @@ static void svm_vm_destroy(struct kvm *kvm)
 
 static int svm_vm_init(struct kvm *kvm)
 {
+	int type = kvm->arch.vm_type;
+
+	if (type != KVM_X86_DEFAULT_VM &&
+	    type != KVM_X86_SW_PROTECTED_VM) {
+		kvm->arch.has_protected_state = (type == KVM_X86_SEV_ES_VM);
+		to_kvm_sev_info(kvm)->need_init = true;
+	}
+
 	if (!pause_filter_count || !pause_filter_thresh)
 		kvm->arch.pause_in_guest = true;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d5b8ed43db8..323901782547 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool need_init;		/* waiting for SEV_INIT2 */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
-- 
2.43.0



