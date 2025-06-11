Return-Path: <kvm+bounces-49201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82ABAAD6377
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D458188876C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D472ED859;
	Wed, 11 Jun 2025 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ER129SOS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FC12ECE85
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682114; cv=none; b=k8LrXe5E4DRY53LQH9xjvpI1kmnDRERVzaxKVX0UYMCVlJCbrVjbswNeTmu635avc29pIvOw3cyXa317+LtmfJMD4DTbpLI+0kroGJfbjWFj9GBWuJjMvuvoYpFgNeMpQC+8FFg6yCfl2A0SW5tPr3zpfo0PKqV0QaII6K/oCts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682114; c=relaxed/simple;
	bh=dcr7IDmLmDNAS6afO+nTfTeJg/AHFl9bk+QccyO3URA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tL1Nv+0gpILMehriYOS3x8u5vq/A4R9ssGChhzOmnQrSBfn9UAJ+w8Qe8+WcqtSZv1kgu6070eKxARIf62dVE9LodODbGhBiBxfRBBDSauF5eAP2UwHBaQ+bbov/fBB2LeYqJqsiXUdt26Sc9YVdjVUq5VUvroARTNloIhYD5JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ER129SOS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25278so342061a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682111; x=1750286911; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y0ognzEJ7YTCwR3VXid30BiQbWyTOWaypqhwvcHXf3s=;
        b=ER129SOSDztfOJdNAl1t3d86Y8zd7GDv9aHCIG19XVRt4PR2xFkeP80mc846+xJQVS
         7sQIKr2iy+jTBtEHzK8kPVCyHZJ/Y4p9O6Nd0rpa1yKFl+g6E85GqnvaRmQzrxc3wkFK
         +4ADFQmevO7ILInkvM/zLLy6B95Ml94/tKfbClJvA0+IHGsd8tdrY5tDDqNwjHr+T4XE
         +46w4mQJuFLiwFL79TUwVnZ1cNMgD+hOkEx67UfcyY1afte2HKq5l+pxpJVThedl9Vru
         1uE7vds5PSWOhv/v/qzT7ic7SiLhh56TIHqu9QO9J+UBzC3TUN9ZN1rxWB6lCP5sa8p1
         3nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682111; x=1750286911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y0ognzEJ7YTCwR3VXid30BiQbWyTOWaypqhwvcHXf3s=;
        b=IbNOBV4inzMh0TrFThdri2+YiudG5lzulwJ/WDnARn/U98cay89v1ZvxmZsWVHalVD
         2XVVWfdILn333IsHNHvRsR3AQCCQ+mDt4vXyy4qd8DLH6YnyxfgVkbynLYYlUoeqWSjp
         wRx3XX0VbCvqttH7XWXUQS31TUoIcoImIWDqoeue5M+VniUV5RuyKP3mVCOL1VX4+jnu
         qBqlvTlJZ5ANWvqSWzHjDbjuqC/MDpbifq/FzsddxhBv3gerfZ/HbJaANSIX/XZkKyvn
         QaV/ebGWEcU79nP300L2yCNPwT4Toig8xtuBlBO9Hz+bPERUPhwFt9wBrgEqoZH/unCH
         RM3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRz1hSQGEkcfH5Rq66FjgTCZp9GvkoQVDIFyKyr0s3SEiMSsj9lhriok0RS/Ycv+zY0zw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfmcEmBJzsSaLZvUl666mZNTAhuTaAG3kqxLzWdL4wpLHM5hLV
	6zSyisVq4A3ynglPahZUYDx6m5a8K1vFsqChTdOUb5JRG7NrOd/TqwV+7FIYdfxUqW/HIJmQddO
	2ovD20w==
X-Google-Smtp-Source: AGHT+IFRdWwIjfXgF8mELaKVUoF9lDiiV8HL8783fqwQWOtpE70D1R2T9PRTPjRcVSy+irY7wjgYviQPM7o=
X-Received: from pjbsk13.prod.google.com ([2002:a17:90b:2dcd:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dcc:b0:311:f30b:c21
 with SMTP id 98e67ed59e1d1-313c08c831amr917024a91.26.1749682111071; Wed, 11
 Jun 2025 15:48:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:58 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-57-seanjc@google.com>
Subject: [PATCH v3 55/62] KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a vCPU's index, not its ID, for the GA log tag/metadata that's used to
find and kick vCPUs when a device posted interrupt serves as a wake event.
Lookups on a vCPU index are O(fast) (not sure what xa_load() actually
provides), whereas a vCPU ID lookup is O(n) if a vCPU's ID doesn't match
its index.

Unlike the Physical APIC Table, which is accessed by hardware when
virtualizing IPIs, hardware doesn't consume the GA tag, i.e. KVM _must_
use APIC IDs to fill the Physical APIC Table, but KVM has free rein over
the format/meaning of the GA tag.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c55cbb0610b4..bb74705d6cfd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -29,36 +29,39 @@
 #include "svm.h"
 
 /*
- * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
- * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
- * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ * Encode the arbitrary VM ID and the vCPU's _index_ into the GATag so that
+ * KVM can retrieve the correct vCPU from a GALog entry if an interrupt can't
+ * be delivered, e.g. because the vCPU isn't running.  Use the vCPU's index
+ * instead of its ID (a.k.a. its default APIC ID), as KVM is guaranteed a fast
+ * lookup on the index, where as vCPUs whose index doesn't match their ID need
+ * to walk the entire xarray of vCPUs in the worst case scenario.
  *
- * For the vCPU ID, use however many bits are currently allowed for the max
+ * For the vCPU index, use however many bits are currently allowed for the max
  * guest physical APIC ID (limited by the size of the physical ID table), and
  * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
  * size of the GATag is defined by hardware (32 bits), but is an opaque value
  * as far as hardware is concerned.
  */
-#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
+#define AVIC_VCPU_IDX_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
 
 #define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
 #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
-#define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
+#define AVIC_GATAG_TO_VCPUIDX(x)	(x & AVIC_VCPU_IDX_MASK)
 
-#define __AVIC_GATAG(vm_id, vcpu_id)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
-					 ((vcpu_id) & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG(vm_id, vcpu_id)					\
+#define __AVIC_GATAG(vm_id, vcpu_idx)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
+					 ((vcpu_idx) & AVIC_VCPU_IDX_MASK))
+#define AVIC_GATAG(vm_id, vcpu_idx)					\
 ({									\
-	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_id);			\
+	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_idx);			\
 									\
-	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUID(ga_tag) != (vcpu_id));	\
+	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUIDX(ga_tag) != (vcpu_idx));	\
 	WARN_ON_ONCE(AVIC_GATAG_TO_VMID(ga_tag) != (vm_id));		\
 	ga_tag;								\
 })
 
-static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
 
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
@@ -139,16 +142,16 @@ int avic_ga_log_notifier(u32 ga_tag)
 	struct kvm_svm *kvm_svm;
 	struct kvm_vcpu *vcpu = NULL;
 	u32 vm_id = AVIC_GATAG_TO_VMID(ga_tag);
-	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
+	u32 vcpu_idx = AVIC_GATAG_TO_VCPUIDX(ga_tag);
 
-	pr_debug("SVM: %s: vm_id=%#x, vcpu_id=%#x\n", __func__, vm_id, vcpu_id);
-	trace_kvm_avic_ga_log(vm_id, vcpu_id);
+	pr_debug("SVM: %s: vm_id=%#x, vcpu_idx=%#x\n", __func__, vm_id, vcpu_idx);
+	trace_kvm_avic_ga_log(vm_id, vcpu_idx);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
 		if (kvm_svm->avic_vm_id != vm_id)
 			continue;
-		vcpu = kvm_get_vcpu_by_id(&kvm_svm->kvm, vcpu_id);
+		vcpu = kvm_get_vcpu(&kvm_svm->kvm, vcpu_idx);
 		break;
 	}
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
@@ -785,7 +788,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 */
 		struct amd_iommu_pi_data pi_data = {
 			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-					     vcpu->vcpu_id),
+					     vcpu->vcpu_idx),
 			.is_guest_mode = kvm_vcpu_apicv_active(vcpu),
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
-- 
2.50.0.rc1.591.g9c95f17f64-goog


