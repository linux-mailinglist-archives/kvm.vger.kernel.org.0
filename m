Return-Path: <kvm+bounces-39468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AA5A47161
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 455963B9365
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EDB22FAC3;
	Thu, 27 Feb 2025 01:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gISGwIj3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649F22E3E1
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619560; cv=none; b=ppGbuaoXpknNlUZcEHEoDYx1MfM8pVRnsLLGOTUTrQK49zqEx+Eg2bQm7DBp+s3F1RR4A8fB55l8fHoqUDPrJhpXGZnXVQx9Gc3j99R1WBaiPrV/OvRhhPe1QzuPz5XGPrvb7cgyELXGUy4v4h7R+vxMWg/jLvhYzDXoDftX4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619560; c=relaxed/simple;
	bh=SlIP7vUVEAl3Nff6A3KsmF5s6lnEtycCZy5mDlywOrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iPgpd1QWTlACwMJ1Hwwy3lFkrvDcn1e7UhcWNh+ZQTKeYzkAJYFAMMs6bqXRsOIsdVE+zU60jEy5i+0AaeNbVEw9Wg/ZXCAoc6HMMkPnfPJvwCATWpL2vpmp0sa0qBCb/ueoO7PDzlLr8IWMfTo2K6P/FFGhTbuvB0i7xeYW/LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gISGwIj3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8fdfdd94so1007509a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619559; x=1741224359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IOWwEu0l/k3HhYntL/yg0gERPToOEmSlz8zTPMBWJgM=;
        b=gISGwIj3vhxdRYYF83elUi4DoTM6Y4ggEZPZtUJhMf4xfHehe3LNKkSQtpWVhpBBF4
         0N/86YkqRAaoW/xtpjwAhVDro6pDvS8WGJ+ubOAbeciuhkTBFtTqIyuHcH6S+CfsmbC4
         ahO1TJSJ+Aw2WHtsCijR4R5m7PlQI8WNIIrfrSIKjfhfuq40jypKHVSPwz5VHNIWG8s1
         jpBIKMx1YrO97yQrxZwRcDRT2suMMfJ5xxRlxPZ5T6i8TLmH2BBXqx4tAvSgN38arWf/
         ZdM9kJMEM77TBdtkjFNJXPpkozBAMYYAlrPBUV7rm3GGX6uEAftRyO6sx8O5veYVTgdg
         1U2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619559; x=1741224359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IOWwEu0l/k3HhYntL/yg0gERPToOEmSlz8zTPMBWJgM=;
        b=cUvScjfXXXZ9bQBpbKS+CCJNGTu8uJ1ywH6aWc9PnGPvR+S/Bwbv8pYYepvSyySCmu
         JdRcBDql8VfP1K9nTc9rsiTPl9oFZ4bDOZ781S1whC+aMW892S6hN4vkBRDeR8AW94xk
         vinQwPahv4s4IoKYUUpIlXx+3ilbwbPTnEqbHOQOhiAfMipPK99z7nPknYdlr4gQ9XYI
         173mBHgzSzXjD7ia2u5/mYLfo0qC+usxydYTna5xCe3C8CW1lTe67GAVDLx/gH2nQWpp
         X9qP6gBxjEoYA/gNVuW8oAkDxEBHCzVspKUPuVV7L3Oo6pnZcdY90JLYF2h17RQi0116
         XlAw==
X-Gm-Message-State: AOJu0YxWcs+XrjhY/vX06KugTi8OUaKHjToUbpwMcXb/NAPsYeaIgQje
	DCoM4l+nGYg4skzff3NqTaJ4c8MvOVYCWYvmj5D01yqCClQWmPD8A7C/b5VXDAbJpguqMrW/3wD
	Dmw==
X-Google-Smtp-Source: AGHT+IGFu8FDn0du2s+v5ekzGMy8fn8oWBPrPcbohW0kjuPN3LZYNucs2Vyp5314eaCBsaigs6BDRwkMzfU=
X-Received: from pja5.prod.google.com ([2002:a17:90b:5485:b0:2fa:1fac:2695])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2502:b0:2fe:9783:afd3
 with SMTP id 98e67ed59e1d1-2fe9783b117mr3818666a91.2.1740619558983; Wed, 26
 Feb 2025 17:25:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:40 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-10-seanjc@google.com>
Subject: [PATCH v2 09/10] KVM: SVM: Use guard(mutex) to simplify SNP vCPU
 state updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Use guard(mutex) in sev_snp_init_protected_guest_state() and pull in its
lock-protected inner helper.  Without an unlock trampoline (and even with
one), there is no real need for an inner helper.  Eliminating the helper
also avoids having to fixup the open coded "lockdep" WARN_ON().

Opportunistically drop the error message if KVM can't obtain the pfn for
the new target VMSA.  The error message provides zero information that
can't be gleaned from the fact that the vCPU is stuck.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c74cc64ceb81..3f85bd1cac37 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3837,11 +3837,26 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	BUG();
 }
 
-static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_memory_slot *slot;
+	struct page *page;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
 
-	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_waiting_for_reset)
+		return;
+
+	svm->sev_es.snp_ap_waiting_for_reset = false;
 
 	/* Mark the vCPU as offline and not runnable */
 	vcpu->arch.pv.pv_unhalted = false;
@@ -3856,78 +3871,47 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 	 */
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
-		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
-		struct kvm_memory_slot *slot;
-		struct page *page;
-		kvm_pfn_t pfn;
-
-		slot = gfn_to_memslot(vcpu->kvm, gfn);
-		if (!slot)
-			return -EINVAL;
-
-		/*
-		 * The new VMSA will be private memory guest memory, so
-		 * retrieve the PFN from the gmem backend.
-		 */
-		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
-			return -EINVAL;
-
-		/*
-		 * From this point forward, the VMSA will always be a
-		 * guest-mapped page rather than the initial one allocated
-		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
-		 * could be free'd and cleaned up here, but that involves
-		 * cleanups like wbinvd_on_all_cpus() which would ideally
-		 * be handled during teardown rather than guest boot.
-		 * Deferring that also allows the existing logic for SEV-ES
-		 * VMSAs to be re-used with minimal SNP-specific changes.
-		 */
-		svm->sev_es.snp_has_guest_vmsa = true;
-
-		/* Use the new VMSA */
-		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
-
-		/* Mark the vCPU as runnable */
-		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
-
-		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-
-		/*
-		 * gmem pages aren't currently migratable, but if this ever
-		 * changes then care should be taken to ensure
-		 * svm->sev_es.vmsa is pinned through some other means.
-		 */
-		kvm_release_page_clean(page);
-	}
-
-	return 0;
-}
-
-/*
- * Invoked as part of svm_vcpu_reset() processing of an init event.
- */
-void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret;
-
-	if (!sev_snp_guest(vcpu->kvm))
+	if (!VALID_PAGE(svm->sev_es.snp_vmsa_gpa))
 		return;
 
-	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
+	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
 
-	if (!svm->sev_es.snp_ap_waiting_for_reset)
-		goto unlock;
-
-	svm->sev_es.snp_ap_waiting_for_reset = false;
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!slot)
+		return;
 
-	ret = __sev_snp_update_protected_guest_state(vcpu);
-	if (ret)
-		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+	/*
+	 * The new VMSA will be private memory guest memory, so retrieve the
+	 * PFN from the gmem backend.
+	 */
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
+		return;
 
-unlock:
-	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+	/*
+	 * From this point forward, the VMSA will always be a guest-mapped page
+	 * rather than the initial one allocated by KVM in svm->sev_es.vmsa. In
+	 * theory, svm->sev_es.vmsa could be free'd and cleaned up here, but
+	 * that involves cleanups like wbinvd_on_all_cpus() which would ideally
+	 * be handled during teardown rather than guest boot.  Deferring that
+	 * also allows the existing logic for SEV-ES VMSAs to be re-used with
+	 * minimal SNP-specific changes.
+	 */
+	svm->sev_es.snp_has_guest_vmsa = true;
+
+	/* Use the new VMSA */
+	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
+
+	/* Mark the vCPU as runnable */
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
+
+	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+
+	/*
+	 * gmem pages aren't currently migratable, but if this ever changes
+	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
+	 * through some other means.
+	 */
+	kvm_release_page_clean(page);
 }
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
-- 
2.48.1.711.g2feabab25a-goog


