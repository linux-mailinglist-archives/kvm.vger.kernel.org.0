Return-Path: <kvm+bounces-39462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD06A47157
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4ABD1623C6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8431B87ED;
	Thu, 27 Feb 2025 01:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sX+ytRaW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00E415E5C2
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619551; cv=none; b=jHsH2OtcTYPIF93yK6A1ZPdAtsscRd7lrpKWnbqhcJFsybHei+/tCX5GhJuNer1mZ6pbqX8rIaSsOhXsFjDno0vJpxkKhjA8qWJeBrCUBUZQjElnDrWq1J0PLnXFTnewP1e+kTKNq90l7oSQP84cSI9NmJm37KJ5YUkSmB9994c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619551; c=relaxed/simple;
	bh=Bd2jcIIVus5KKhQQxvEgLThZpvhnEnb0Zp6oqmiDeNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NZ9tEiR4j+UbI5qp9a8z9pEORBygkQElcz4Mv//45ly2bKHES1yZt4ToaMe7lE3mWtqUgQliNcnjIdLgWugy0e1FB5hn2m3jXBxNz9C+oSXS89sP3QunDLcSfOJTPvbuRiviQqWVnAr7EO++OAZ4xq4EHCBTMRZka5/x27Me5Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sX+ytRaW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22350e4b7baso4602925ad.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619549; x=1741224349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SpiV/7IGUVGhPtuzMA7ncb1Ov7eVPXJdzTw8o7Y+oeM=;
        b=sX+ytRaWgmh8rx/g4QSbKm4lQHPMSzGHtVbJ1Wy1V6TnQmybyQVt3YbiYQhlmKEX0Z
         2RvmjqrzNyGl1bsd5mzPU7rwEeFVPEPS8T41yUQ1RZrVmKtT+iOFxaGPqrpUCbNNm7n+
         LZISBDJVVeYa4d5Bpr+qs0+IJgciD7wVX1EAyacNOYGjZGLsTHQ8VW8+BpMigcz9pZ9y
         j3pSFDXvf66VcAD0827ALYTduV2zO3kFm83FcgeJJviRyb4klyIM6g4WXvrr0f1n3/jP
         23kpn4GtmZBTYmm3Td5KnZHXpuR2HgwP2Km/tOfevX4u6ymLvrFBl5P+GSywf7IcofXT
         f+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619549; x=1741224349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SpiV/7IGUVGhPtuzMA7ncb1Ov7eVPXJdzTw8o7Y+oeM=;
        b=Ov4pMlLOWuls4B2kN8/vvthZIHZc5fCNjEHNutbnlkUbRxu106VDVLfaGI9o4LB6B+
         6sa8+9n1GiK/dHuEqx829ZpMBIKsqKlEnOr7o9T7/JTGGaPyzon+RtvkqY1INPnkvlwy
         rh3kOfpVUukrSDW0LFjrLsW423SIdKrpBS3WR8mXqThaed4P++S0dWLGRYCKp7nNInKf
         jkTISDJ6LwGHZTSmOUKvtQHUh/JocPtjVf/M8X2KgG7BfPxdLIB8Uay2NUdGTqVUkQW6
         S46STNDY6jE+wrcnSxarIAyf5+E3bMe2FmzZHHLfv2MXTl0VcgkBznIV7ybm+JhDeacD
         nYQg==
X-Gm-Message-State: AOJu0Ywaxzw4xS2Df7fXde2OFd4Y8q00olyKgo4ACr5c2f/0pP3NM/RB
	7JXXKzr6CIl2ZC6Zf1gzkhjBMAuRBiGOGSXpu9Atjs4wUnKNuH6IivRasYz03TOTJAlfEGSHKA1
	VFw==
X-Google-Smtp-Source: AGHT+IEBhn1N/oyrrmPhXLjz3V/jBJme9qVZVIFVvFpCt+5P1PKn2MbmobZJwvu3dN1sDK4eJAez625G97g=
X-Received: from pfcg22.prod.google.com ([2002:a05:6a00:23d6:b0:730:880d:7ed5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1310:b0:730:9567:c3d5
 with SMTP id d2e1a72fcca58-7347909fee5mr15105470b3a.4.1740619549128; Wed, 26
 Feb 2025 17:25:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:34 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-4-seanjc@google.com>
Subject: [PATCH v2 03/10] KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+
 guest has an invalid VMSA
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly reject KVM_RUN with KVM_EXIT_FAIL_ENTRY if userspace "coerces"
KVM into running an SEV-ES+ guest with an invalid VMSA, e.g. by modifying
a vCPU's mp_state to be RUNNABLE after an SNP vCPU has undergone a Destroy
event.  On Destroy or failed Create, KVM marks the vCPU HALTED so that
*KVM* doesn't run the vCPU, but nothing prevents a misbehaving VMM from
manually making the vCPU RUNNABLE via KVM_SET_MP_STATE.

Attempting VMRUN with an invalid VMSA should be harmless, but knowingly
executing VMRUN with bad control state is at best dodgy.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 16 +++++++++++++---
 arch/x86/kvm/svm/svm.c | 11 +++++++++--
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 719cd48330f1..218738a360ba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3452,10 +3452,19 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	svm->sev_es.ghcb = NULL;
 }
 
-void pre_sev_run(struct vcpu_svm *svm, int cpu)
+int pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
+	struct kvm *kvm = svm->vcpu.kvm;
+	unsigned int asid = sev_get_asid(kvm);
+
+	/*
+	 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
+	 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
+	 * AP Destroy event.
+	 */
+	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
+		return -EINVAL;
 
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
@@ -3468,11 +3477,12 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	 */
 	if (sd->sev_vmcbs[asid] == svm->vmcb &&
 	    svm->vcpu.arch.last_vmentry_cpu == cpu)
-		return;
+		return 0;
 
 	sd->sev_vmcbs[asid] = svm->vmcb;
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	return 0;
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8aa0f36850f..f72bcf2e590e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3587,7 +3587,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return svm_invoke_exit_handler(vcpu, exit_code);
 }
 
-static void pre_svm_run(struct kvm_vcpu *vcpu)
+static int pre_svm_run(struct kvm_vcpu *vcpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3609,6 +3609,8 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 	/* FIXME: handle wraparound of asid_generation */
 	if (svm->current_vmcb->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
+
+	return 0;
 }
 
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
@@ -4231,7 +4233,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	if (force_immediate_exit)
 		smp_send_reschedule(vcpu->cpu);
 
-	pre_svm_run(vcpu);
+	if (pre_svm_run(vcpu)) {
+		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		vcpu->run->fail_entry.hardware_entry_failure_reason = SVM_EXIT_ERR;
+		vcpu->run->fail_entry.cpu = vcpu->cpu;
+		return EXIT_FASTPATH_EXIT_USERSPACE;
+	}
 
 	sync_lapic_to_cr8(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5b159f017055..e51852977b70 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -713,7 +713,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-void pre_sev_run(struct vcpu_svm *svm, int cpu);
+int pre_sev_run(struct vcpu_svm *svm, int cpu);
 void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.48.1.711.g2feabab25a-goog


