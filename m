Return-Path: <kvm+bounces-49186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 480A6AD634C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED42646074D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9305D2E88AC;
	Wed, 11 Jun 2025 22:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pPG/ujpM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787CB2E7F37
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682087; cv=none; b=bEBO6k3xZygT/o7PQNjMGFhBCZaNcYPts+UcMHPz+YSVUQGY+pXYREJtKzoa+JEn8ma9Z/ASx++jqil2cuWE5hMJgQ4IgHx3mhPyVvJn/6bQi/hjXnLZJg7MFZOlJaLe7C+frUmpfvoq229+GEP9niv9IRtt+RT3P96BQbM9IPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682087; c=relaxed/simple;
	bh=ROsYHJ2+uptkBCMldWoifTL2iyHuDtHFhXfuGyDjoaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f8un5WMOE25iK6TxGHZO/nCaoURXLao/DJL1uFrv7s9VJQpd9hUbQCeUI69rUANZnfZH7jcKLk4m7QPhT3qFC7+8XSlgR5a6CKnRfTGpt4IBI2o+Xp1088PcesP5l2KDi01pxH0DnDiwtYgtQP93MqLTFCbkj8ec1DwA80ADNqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pPG/ujpM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311a6b43ed7so302297a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682085; x=1750286885; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P6T8kurORmpNzIZT5z+9LdZIjpG753fy442i5aXkbLU=;
        b=pPG/ujpM3N6ygqL5cAXNlC9QCIRxgGqVloROODuZNWaMI2jNQS+tTk9e2hDDHndNcq
         oXrTf6u+5e2j8m7vrQbUpJ2ZUvfPMi6gJNwVrHoUdv9xO+cOfxtglJ00wbrUXpcaewDm
         1qyW32ds0ufZgCLQpytRsG8i/x5NiZ3CXetHwysA4NxuOVlK9+yTlXQsyQuNpjBTV+rv
         LK5Ja/xqwdU9onMsqUuV4/+k98QieybQ0KmFi0t2dTdCC/NAJRThnqD2TE0zcZ0M5XAA
         Ngul5NqK1r3hfAXA3VTIb1JY3dkN30NLSfOiWA575X/S8ZzcEWeDoSlfrZaCtxWPdiEh
         lAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682085; x=1750286885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P6T8kurORmpNzIZT5z+9LdZIjpG753fy442i5aXkbLU=;
        b=qT7JQPMgK9cDPOx7+J9YThceLJv2n9IMvnm8YjMT73MVy92wyxDRqfNaTYhwqI5+8x
         WO+2b3o/5mQoyKSgq9uohSG68Ljd8OM5a1pjKvQSLSDNAYMkuVzRu+ZJ+geYgMc4gLp3
         SsK1Xc6/YYkOyaPIF4/njkSf7LE2H1yg1padqGxscgCuAIgyr8w04gKL8bEFnm69+iVJ
         4ediO3kKY9qFWTl0+NJq1hNPyrYBkf9gGfMUx7EVVO3gheTQTuUWyrNIaxactPCxK3mK
         rkWR+NclBXwaEHDavCZ1HOdb1dBBzyWyFpA5LWP5rkXFJtrH5y3FVIMZBII9wxFqcqPa
         OHUQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3AXI/xa/aDuHjOst10s9ujsXfOFioHW/ihr4zXVPGvR+hJRN7CtUYUmw0EPaTIFWjSgs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6y4psbNZG5QJ2BBHvBLWwDSmowPTi7Zk07jxdPxvCa2ftCDTz
	CUx6XSag+krNqcFQAAK9kQ0qdVFlddMKaipRPONGaInDDbdU6FsYAUN6Nmd6CazoYOJqytaAEZw
	3+cnkVQ==
X-Google-Smtp-Source: AGHT+IHM2JiHfqb+1Ng9CU9uayKnCjtF1dPWv5M1I7XqoBrZnGh5QqqmhGY2K+sybQnd4fFqJpbnKADbhuc=
X-Received: from pjz6.prod.google.com ([2002:a17:90b:56c6:b0:312:15b:e5d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a44:b0:313:14b5:2538
 with SMTP id 98e67ed59e1d1-313c09109e8mr1093727a91.35.1749682084860; Wed, 11
 Jun 2025 15:48:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:43 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-42-seanjc@google.com>
Subject: [PATCH v3 40/62] iommu/amd: KVM: SVM: Infer IsRun from validity of
 pCPU destination
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

Infer whether or not a vCPU should be marked running from the validity of
the pCPU on which it is running.  amd_iommu_update_ga() already skips the
IRTE update if the pCPU is invalid, i.e. passing %true for is_run with an
invalid pCPU would be a blatant and egregrious KVM bug.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 11 +++++------
 drivers/iommu/amd/iommu.c | 14 +++++++++-----
 include/linux/amd-iommu.h |  6 ++----
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4747fb09aca4..c79648d96752 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -832,7 +832,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		entry = svm->avic_physical_id_entry;
 		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
-					    true, pi_data.ir_data);
+					    pi_data.ir_data);
 
 		irqfd->irq_bypass_data = pi_data.ir_data;
 		list_add(&irqfd->vcpu_list, &svm->ir_list);
@@ -841,8 +841,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static inline int
-avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
+static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -861,7 +860,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 		return 0;
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
-		ret = amd_iommu_update_ga(cpu, r, irqfd->irq_bypass_data);
+		ret = amd_iommu_update_ga(cpu, irqfd->irq_bypass_data);
 		if (ret)
 			return ret;
 	}
@@ -923,7 +922,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -963,7 +962,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+	avic_update_iommu_vcpu_affinity(vcpu, -1);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	svm->avic_physical_id_entry = entry;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5adc932b947e..bb804bbc916b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3990,15 +3990,17 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
  * Update the pCPU information for an IRTE that is configured to post IRQs to
  * a vCPU, without issuing an IOMMU invalidation for the IRTE.
  *
- * This API is intended to be used when a vCPU is scheduled in/out (or stops
- * running for any reason), to do a fast update of IsRun and (conditionally)
- * Destination.
+ * If the vCPU is associated with a pCPU (@cpu >= 0), configure the Destination
+ * with the pCPU's APIC ID and set IsRun, else clear IsRun.  I.e. treat vCPUs
+ * that are associated with a pCPU as running.  This API is intended to be used
+ * when a vCPU is scheduled in/out (or stops running for any reason), to do a
+ * fast update of IsRun and (conditionally) Destination.
  *
  * Per the IOMMU spec, the Destination, IsRun, and GATag fields are not cached
  * and thus don't require an invalidation to ensure the IOMMU consumes fresh
  * information.
  */
-int amd_iommu_update_ga(int cpu, bool is_run, void *data)
+int amd_iommu_update_ga(int cpu, void *data)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
@@ -4015,8 +4017,10 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
 					APICID_TO_IRTE_DEST_LO(cpu);
 		entry->hi.fields.destination =
 					APICID_TO_IRTE_DEST_HI(cpu);
+		entry->lo.fields_vapic.is_run = true;
+	} else {
+		entry->lo.fields_vapic.is_run = false;
 	}
-	entry->lo.fields_vapic.is_run = is_run;
 
 	return __modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
 				ir_data->irq_2_irte.index, entry);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 99b4fa9a0296..fe0e16ffe0e5 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -30,8 +30,7 @@ static inline void amd_iommu_detect(void) { }
 /* IOMMU AVIC Function */
 extern int amd_iommu_register_ga_log_notifier(int (*notifier)(u32));
 
-extern int
-amd_iommu_update_ga(int cpu, bool is_run, void *data);
+extern int amd_iommu_update_ga(int cpu, void *data);
 
 extern int amd_iommu_activate_guest_mode(void *data);
 extern int amd_iommu_deactivate_guest_mode(void *data);
@@ -44,8 +43,7 @@ amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
 	return 0;
 }
 
-static inline int
-amd_iommu_update_ga(int cpu, bool is_run, void *data)
+static inline int amd_iommu_update_ga(int cpu, void *data)
 {
 	return 0;
 }
-- 
2.50.0.rc1.591.g9c95f17f64-goog


