Return-Path: <kvm+bounces-9984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E8986807A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46ABE1C20A5F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8880A1350C5;
	Mon, 26 Feb 2024 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fP++q3bI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABBA1332BF
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974241; cv=none; b=TNCrrIRcZKSx5DEDfQ3y70kf2b45hECORUvIFoxIQ9NBChD2lyqpPjd4wnbdkvGSX3Hl+xWb93Fy7YQWqg7NFGbjxHUBN/ozklcDYLnvQeKcdBl5ODzN11ZpLamHWeqge0joMhbWAqwqkZfZATd37lm/OFDfUNOiQGHm8W8493E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974241; c=relaxed/simple;
	bh=MKdPVqybJx+yUazMzrxA3fRZNvilom9H2HTpOiyF0rA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1fBiYYsAt4Oy3pcy8DRDtCYg223WYrAluezuXSdi/vKTUkRQ3t7rZxAcFgWvKILz3rRVRjoSBFTGcURWPSvH1GjxahouF3U+4DVRYcq4g3KIMxZlGKwEfJ8tyz3a17OmGKCleMUUIPFcgs0Tb0SDnIPTzZHXvuMHKyF5POsFZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fP++q3bI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8nmWNDUyYukZZP1ueJe+cOG2n3yMwyfYzVyARW8Tlk=;
	b=fP++q3bI2JAsLAhWdATu/4tlMRhA8vql824iCsalHUWXmVC9AD5fOreA2dNPXGD72EUyH8
	dRxJ/QXoa9yIaZLJdOdHfYWsDsbs3uDN6++q3HeGHaT29/4ktfSqBCiZ4VfUWRNz3qYzwx
	AsY7sgfFikKuFhEcQgSCaKMtrEPQjhk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-E5YkqV7yNVKEa4Kp88TusQ-1; Mon, 26 Feb 2024 14:03:48 -0500
X-MC-Unique: E5YkqV7yNVKEa4Kp88TusQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 486198F7760;
	Mon, 26 Feb 2024 19:03:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1FF1B492BC8;
	Mon, 26 Feb 2024 19:03:47 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 08/15] KVM: SEV: store VMSA features in kvm_sev_info
Date: Mon, 26 Feb 2024 14:03:37 -0500
Message-Id: <20240226190344.787149-9-pbonzini@redhat.com>
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
 arch/x86/kvm/svm/sev.c | 22 ++++++++++++++++++----
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/svm/svm.h |  3 ++-
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 16a5c64232b7..b46612db0594 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -96,6 +96,14 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
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
@@ -244,6 +252,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
+	sev->vmsa_features = sev_supported_vmsa_features;
+
 	ret = sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -263,6 +273,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->vmsa_features = 0;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -557,6 +568,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -598,7 +611,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	save->sev_features = sev_supported_vmsa_features;
+	save->sev_features = sev->vmsa_features;
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
@@ -1678,6 +1691,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
 	dst->es_active = src->es_active;
+	dst->vmsa_features = src->vmsa_features;
 
 	src->asid = 0;
 	src->active = false;
@@ -3048,7 +3062,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-	if (!sev_es_debug_swap_enabled) {
+	if (!sev_vcpu_has_debug_swap(svm)) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 		recalc_intercepts(svm);
@@ -3103,7 +3117,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
 {
 	/*
 	 * All host state for SEV-ES guests is categorized into three swap types
@@ -3131,7 +3145,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
 	 * saves and loads debug registers (Type-A).
 	 */
-	if (sev_es_debug_swap_enabled) {
+	if (sev_vcpu_has_debug_swap(svm)) {
 		hostsa->dr0 = native_get_debugreg(0);
 		hostsa->dr1 = native_get_debugreg(1);
 		hostsa->dr2 = native_get_debugreg(2);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 595642099772..1cf9e5f1fd02 100644
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
index 8f2394169703..d6147ad18571 100644
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
@@ -684,7 +685,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
+void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
-- 
2.39.1



