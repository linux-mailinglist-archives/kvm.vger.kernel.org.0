Return-Path: <kvm+bounces-13544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0558B8986E3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8422E1F27623
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9D4126F2F;
	Thu,  4 Apr 2024 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czY283J4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DB183CDE
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232814; cv=none; b=PlJzhNNb5XfZzYjK5gYQspvzHnOWlAZKj64BZ/2nuESIR/Wij33eCtn8oek9Hxp8URNxkx6fsajjIwXTgfMFgE2Q7sylR0YQQYndeS0tQNxZZP+JHJQ4xBQ988Zat1lR2FJL55/rAFPIj6aEVDmyxfYjVpI7jcwDJSnkItH/Cfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232814; c=relaxed/simple;
	bh=0SEsPGVrorS4AjqPHJGQGPhzQkJYZLsEgmAk2LXEGV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2fryaLzMJZpSHnPSUh1Y9MEHBeUsCJ0aKORsOnVrCIMDv7e4KR/3nFpDAOXdLaNGaKPVnPWg88La3VVT4oyXSZJzycdyFhpp3Ey9eLAEvyjQotGz7g4ItNY38IRoZpw7bJRyR4oJmY4/k0g/KYYveJgeo7Itxq8eICJ8m8q724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czY283J4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SLdwR2CmNU1OSrj60kkf/CLyqhGbne7vwNMOxWrOGwQ=;
	b=czY283J4dmcmYQTgK7dvyDkPRkvrcRDHo8vsOZZfOzaDvgUfIig5YjYhxkg9mNFyEvNo63
	Nf+arJqVReySWpzVULSYmsRMNaTqD1pxq2C7hVzT5sGe85Pg9Sah72Lx/VphVr4ml0t199
	iPYc4Bq6rjZReWJT3VVwOd3SKal2GG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-zVpTHWE1P2WFCp6sY793EQ-1; Thu, 04 Apr 2024 08:13:29 -0400
X-MC-Unique: zVpTHWE1P2WFCp6sY793EQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84E3284FA94;
	Thu,  4 Apr 2024 12:13:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 636C42024517;
	Thu,  4 Apr 2024 12:13:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH v5 06/17] KVM: SEV: store VMSA features in kvm_sev_info
Date: Thu,  4 Apr 2024 08:13:16 -0400
Message-ID: <20240404121327.3107131-7-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Right now, the set of features that are stored in the VMSA upon
initialization is fixed and depends on the module parameters for
kvm-amd.ko.  However, the hypervisor cannot really change it at will
because the feature word has to match between the hypervisor and whatever
computes a measurement of the VMSA for attestation purposes.

Add a field to kvm_sev_info that holds the set of features to be stored
in the VMSA; and query it instead of referring to the module parameters.

Because KVM_SEV_INIT and KVM_SEV_ES_INIT accept no parameters, this
does not yet introduce any functional change, but it paves the way for
an API that allows customization of the features per-VM.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20240209183743.22030-6-pbonzini@redhat.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 29 +++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/svm/svm.h |  3 ++-
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5055935dfd1d..e24f7d243a0a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -99,6 +99,14 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
 	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
 }
 
+static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
+	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
@@ -248,6 +256,11 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
+	sev->vmsa_features = sev_supported_vmsa_features;
+	if (sev_supported_vmsa_features)
+		pr_warn_once("Enabling DebugSwap with KVM_SEV_ES_INIT. "
+			     "This will not work starting with Linux 6.10\n");
+
 	ret = sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -269,6 +282,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->vmsa_features = 0;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -563,6 +577,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -604,11 +620,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_supported_vmsa_features) {
-		save->sev_features = sev_supported_vmsa_features;
-		pr_warn_once("Enabling DebugSwap with KVM_SEV_ES_INIT. "
-			     "This will not work starting with Linux 6.10\n");
-	}
+	save->sev_features = sev->vmsa_features;
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
@@ -1688,6 +1700,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
 	dst->es_active = src->es_active;
+	dst->vmsa_features = src->vmsa_features;
 
 	src->asid = 0;
 	src->active = false;
@@ -3063,7 +3076,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-	if (!sev_es_debug_swap_enabled) {
+	if (!sev_vcpu_has_debug_swap(svm)) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 		recalc_intercepts(svm);
@@ -3118,7 +3131,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
 {
 	/*
 	 * All host state for SEV-ES guests is categorized into three swap types
@@ -3146,7 +3159,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
 	 * saves and loads debug registers (Type-A).
 	 */
-	if (sev_es_debug_swap_enabled) {
+	if (sev_vcpu_has_debug_swap(svm)) {
 		hostsa->dr0 = native_get_debugreg(0);
 		hostsa->dr1 = native_get_debugreg(1);
 		hostsa->dr2 = native_get_debugreg(2);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 450535d6757f..c22e87ebf0de 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1523,7 +1523,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		struct sev_es_save_area *hostsa;
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
 
-		sev_es_prepare_switch_to_guest(hostsa);
+		sev_es_prepare_switch_to_guest(svm, hostsa);
 	}
 
 	if (tsc_scaling)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1c6601a9cbbf..4a1623cacbae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,6 +85,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	u64 vmsa_features;
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
@@ -670,7 +671,7 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 #ifdef CONFIG_KVM_AMD_SEV
-- 
2.43.0



