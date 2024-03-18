Return-Path: <kvm+bounces-12054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E1E87F413
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38D9D283B7D
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60828605BD;
	Mon, 18 Mar 2024 23:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7cquNUm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCB35FBB0
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804844; cv=none; b=ZDGhv5wtUGcQoRxH/jmds+5YRNnNveRvjRoit9YFyKHuynZBlOsHV6GcOYX7TcaAvtUseKN3wvuHcLYKIXOIPY+WPc7m64RMjgHvYWFBc+Ms2ZuL9qFkhEePIxi4cZvwEnaQLHOCTuQa7r/YsPNgwMnO+3caef5Zd/LPBLyfZAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804844; c=relaxed/simple;
	bh=ew7TCB5jB/OfQ1oPkcNxpM+lLgrFDIYzu6VzC7K1Eho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qOKCwMEP8s+rc02EWUNTZmYcCr/doYmgwPgV3iS0BTrXXxbp5w8tcv5ZNx1VU7wN5cKW5bd1UwtpZL7GsRJ7Y3p9VB2tFcQFqwVRGEhhdq5ydjNemSkk6Ul6DWFXL+RxUWyPypkoUKUjd7cPsJEiKErX+2HV64lHcGwHnsHTlbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7cquNUm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmT+FkpK1ACWziAEuRucxqxAsy5iYObv6aeH+d06aZY=;
	b=E7cquNUm/OmA1XJKEJLO3/ra/FNEPU+hL7rGnndyZkid36SvXm3oWmFTWgEW7OUB7sgMhs
	Vs/2tWnHs/nZx5r6SNPsi0ksuren1tcRGyBraSuHIa9e+dkdYseKMwz8cGYqnr9rIZx4cL
	pGzhuF4xXErZBdlgLxZltJg4kxvcDW4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-KPC4hWj-PZOmgSMo5moJZw-1; Mon,
 18 Mar 2024 19:33:56 -0400
X-MC-Unique: KPC4hWj-PZOmgSMo5moJZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 205483C02459;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EECAC1C060A4;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 11/15] KVM: SEV: define VM types for SEV and SEV-ES
Date: Mon, 18 Mar 2024 19:33:48 -0400
Message-ID: <20240318233352.2728327-12-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

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
index d0c1b459f7e9..9d950b0b64c9 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -857,5 +857,7 @@ struct kvm_hyperv_eventfd {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_SEV_VM		2
+#define KVM_X86_SEV_ES_VM	3
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 704cd42b4f1b..7c2b0471b92c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -249,6 +249,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
+	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+		return -EINVAL;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
@@ -270,6 +273,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	INIT_LIST_HEAD(&sev->regions_list);
 	INIT_LIST_HEAD(&sev->mirror_vms);
+	sev->need_init = false;
 
 	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
 
@@ -1841,7 +1845,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_fput;
 
-	if (sev_guest(kvm) || !sev_guest(source_kvm)) {
+	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
+	    sev_guest(kvm) || !sev_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2162,6 +2167,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->asid = source_sev->asid;
 	mirror_sev->fd = source_sev->fd;
 	mirror_sev->es_active = source_sev->es_active;
+	mirror_sev->need_init = false;
 	mirror_sev->handle = source_sev->handle;
 	INIT_LIST_HEAD(&mirror_sev->regions_list);
 	INIT_LIST_HEAD(&mirror_sev->mirror_vms);
@@ -2227,10 +2233,14 @@ void sev_vm_destroy(struct kvm *kvm)
 
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
index 03108055a7b0..0f3b59da0d4a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4078,6 +4078,9 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
+	if (to_kvm_sev_info(vcpu->kvm)->need_init)
+		return -EINVAL;
+
 	return 1;
 }
 
@@ -4883,6 +4886,14 @@ static void svm_vm_destroy(struct kvm *kvm)
 
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
index 6313679d464b..c08eb6095e80 100644
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



