Return-Path: <kvm+bounces-38535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A10CA3AEEE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86ACC3AAF11
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A261B6CE0;
	Wed, 19 Feb 2025 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NwwBUywx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F301AF0DC
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928445; cv=none; b=HrEUSu5C4pihQmqWwB48RaUlslD+HTaf9kHLO+ew08eKgXBsbBOAijcZzvFdMOx8W8gBfxnnfANhopXu02E5fglR9h553DLoEqboll2rZRTDsMECt5EkPQcji68ULLdesLoPQyM6183Tng7HN1fnsBWRbtmS6D1VLizVyBwkc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928445; c=relaxed/simple;
	bh=V3Cuy8lI8q4I7DcMzksfdRcqVIHVzLT7AUJQqU8p+y0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZZ4Sy3asUYq0XdyBgsyyeokGzn5Ju/RX55Y38iJD3H/45MORdmn9GcehoDI5UZFsZ5xGYWwFZuskZZkiY8JvBxaK6fAn3v9UtfXy3uzPyMkmKMaryIckm8BvdxC8oXQ6/wNmmN8ysXp7ZJrKCeYte7raBsq3h/51L21wkk5Xm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NwwBUywx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fbfa786a1aso19115614a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928443; x=1740533243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=O2hAAvRs0bclRxNF/THX7o+qs2YRSldWACuN7DP0Igc=;
        b=NwwBUywxTs1Qw24EnojYA+XMDSQgXf+yQ+dqQE8NgJFJJIb88xwGmzUkwU4/Seqi7D
         y/Ucdwq4weSJc/MCE897z2oDksi57RPZyobA4yWg6u7MPCfC3RIM/ujWP+/qRZWONRyv
         3aPiQF64kX5ZjA2H+tMIfHGoVhIdpTnxcFaMP4Mst0+SWeeTHUrZPAtwiQH67yudYShc
         +UWs3jOmZ3BYPHqbxjsTCfAZuXW741gxrGfzjR7h68UxaT+n0VMedciMOmDvgyxLk0w1
         egfXTPEBs7ONQh5RM8kKlJMf3p8CPj2HZqBy7oz2aDoM0ZOLCOfbsHXth07ai9+T/cun
         L/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928443; x=1740533243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O2hAAvRs0bclRxNF/THX7o+qs2YRSldWACuN7DP0Igc=;
        b=YJoqcKcTu5WQdxHbwjZgdOMIYUbbdqLLGi3C0cQfr6umDmZ27ia7o0IMhGOddR5h7h
         uiPvyAehGBTg2cnWWxq6bNXbVtM16eIpBObm9qBoUubc3/RRfoPvBCqHixbPhhflD2n6
         7CH7QCCVIdYjNPkPXOK585kuRifNs2ppa/giYlnRQECViclMmN16lvT2LOTOFu+gwSvj
         fVFOzPi0o44jMqcb00wFMo+Y3s+Yau5q1cxWTAHfjvB5fRJzyRCfgu7i8rS3U3CAdgRj
         6/ViNU76O5hQELlPQAQX/jFlGflDA7cW14a3jODsB1ykHYZSSuD9EVvaWd0WhhfXbK0p
         7NIA==
X-Gm-Message-State: AOJu0Yy+DcxTMAA2QsmUWUsxSBjrJvSdR3GjoAoQcCEcPjT0WqZ9IQ27
	aUF+jLJucZOF615Ccr6k3ydSny6181TSl77Z4L2/da8Rv3914I6iBe0+s6MKLZwFypVjUx3BGGW
	e3A==
X-Google-Smtp-Source: AGHT+IGu4IMnRtTe5JpUjyMMXjFyU78RL3gzj9/hwjwrFcEJ7OLX2ZwVfXeUKi5ybG86HCwh2Z09aVsgVKc=
X-Received: from pjbst12.prod.google.com ([2002:a17:90b:1fcc:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5110:b0:2f4:4003:f3ea
 with SMTP id 98e67ed59e1d1-2fc411505d8mr26779335a91.33.1739928443281; Tue, 18
 Feb 2025 17:27:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:27:04 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-10-seanjc@google.com>
Subject: [PATCH 09/10] KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Use guard(mutex) in sev_snp_init_protected_guest_state() and pull in its
lock-protected inner helper.  Without an unlock trampoline (and even with
one), there is no real need for an inner helper.  Eliminating the helper
also avoids having to fixup the open coded "lockdep" WARN_ON().

Opportunistically drop the error message if KVM can't obtain the pfn for
the new target VMSA.  The error message provides zero information that
can't be gleaned from the fact that the vCPU is stuck.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3a531232c3a1..15c324b61b24 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3839,11 +3839,26 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
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
@@ -3858,78 +3873,47 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
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
2.48.1.601.g30ceb7b040-goog


