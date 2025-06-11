Return-Path: <kvm+bounces-49177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F568AD6335
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 911827AAD26
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1602E2EED;
	Wed, 11 Jun 2025 22:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FXcZtVPP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E812DECD7
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682071; cv=none; b=Isl21uR4jPxvZve6dh1r7nxQPd+dBtBHrG4JCK7IOALkoWfOW1qSD25QfTYJFsb1CACYLhJwp1KvntdcJ0fl26SdEXX3XIk8ma+3dIfmSzdxUxmGDvJ7exmy4WifqYDviAuQxj0S/AtJnk/Uw8O0ZiQjSg1tiODzHH1hqJsfEpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682071; c=relaxed/simple;
	bh=v9xpEwTTwYfGYHriPTRdWxsTpOCI407W6+22LUMIZys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PWpDGplAUppWs8NhEgNkQbDI7YUxks5W2gQXar1/tNytxBhOQloZbQFteK6maG6aozR5+mjwAiZ/6mqTs3uG/Fz00glrnfqlxfXE/kmfvaoUcT6V5+SvV36Hthey5Q5AHtoqMETcjqWCE5wE5de9spEFN25lthmghHG/qf3Ox7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FXcZtVPP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742cf6f6a10so522184b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682069; x=1750286869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A6kFV0aM2/7WGCbUITdYj+59/K3RoQFqsqt5SwSOyE0=;
        b=FXcZtVPPNwGc0wHYTogAlgWIUVMmJlghgSexk/Pr2LyURi8dg8GEcXy69VVxKTk9mp
         HC1SesPfXJSm20zb5ODOzrOTwstVvT/tBgPfhZw280Mpoko8aEgm2YATN04zfLSVWxhU
         2SawCeynYH/D6drUUQ7H4qNOMqcn1xlp93YI7ULJ4u93IRZx+CUWCMtw4TtcS/M6cB6h
         Nj5CX9SdpCMgdipcJZgjLIyVvNZtof5IBCp7s61WkKyKeMvNR7xrKZzBKamPpPuata/d
         WVgVp/+ZgMMeiGaoqkAP6gZ/vlo+eSyMCf/mZgjYOdt0P49k1AiSRTGf0xcvDXLU1/cg
         llwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682069; x=1750286869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6kFV0aM2/7WGCbUITdYj+59/K3RoQFqsqt5SwSOyE0=;
        b=gQO+oLin4fnwPI57nKjuUj8YtRyem2eduM2Q6f8QE0LQnw5cWrctZLUZK/tgyqC96m
         4qPTADd0/4tN54rjwa6w9ybSn9MY7KJHcmWJE+g9v5SQiUIG3YZ0c54jPsUp2rmBQJOo
         nxn6I76i16LbabRE+b2R50eX/abdm/6Z0+s/7q5XlkBOiuQWCElq0T9KPVdBCpduzuAo
         4VpO+1RVfrtCEmwHudVqcrTl1/kgG5KfkxrUMtEvX2VGVB0Vvd+u8lGQgh8GyLtfFfDv
         4PFg/2rUeuUBNL9hRyjoAv0LNTlRVNZYaAQulvufew4SsD/L030GJCGZ5K+5H3MLhsbb
         ZH6w==
X-Forwarded-Encrypted: i=1; AJvYcCU8QCKR2F9NGmNEcUA+34clDwvnRkxDDb7aWYummgwWv9FSIWJAAfZ1Gh1tCXdWqk2QElI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywga37KZPPxzpXqegdPggaIw4qDwmCr4DxVhO+5wVMo99H2xdXR
	uUMKwtFdeVZzvheqb4H7eCnsP2jhe8rAgfLw4VgN+WTJRIgOQGK/jt5wFROSNrUQ92HLj3dcf0O
	d8MwwSA==
X-Google-Smtp-Source: AGHT+IEYMkMwcnIeyPgfPFP0NuScaZzgC9Stpbf3ExVHDUo0EXQg9uCGSRWh/jAB4CmBrW8hxEhAywt4G8k=
X-Received: from pfsq2.prod.google.com ([2002:a05:6a00:2a2:b0:746:25af:51c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ac4:b0:737:678d:fb66
 with SMTP id d2e1a72fcca58-7487e082857mr873149b3a.5.1749682068984; Wed, 11
 Jun 2025 15:47:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:34 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-33-seanjc@google.com>
Subject: [PATCH v3 31/62] iommu: KVM: Split "struct vcpu_data" into separate
 AMD vs. Intel structs
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

Split the vcpu_data structure that serves as a handoff from KVM to IOMMU
drivers into vendor specific structures.  Overloading a single structure
makes the code hard to read and maintain, is *very* misleading as it
suggests that mixing vendors is actually supported, and bastardizing
Intel's posted interrupt descriptor address when AMD's IOMMU already has
its own structure is quite unnecessary.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/irq_remapping.h | 15 ++++++++++++++-
 arch/x86/kvm/svm/avic.c              | 21 ++++++++-------------
 arch/x86/kvm/vmx/posted_intr.c       |  4 ++--
 drivers/iommu/amd/iommu.c            | 12 ++++--------
 drivers/iommu/intel/irq_remapping.c  | 10 +++++-----
 include/linux/amd-iommu.h            | 12 ------------
 6 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 5036f13ab69f..2dbc9cb61c2f 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -26,7 +26,20 @@ enum {
 	IRQ_REMAP_X2APIC_MODE,
 };
 
-struct vcpu_data {
+/*
+ * This is mainly used to communicate information back-and-forth
+ * between SVM and IOMMU for setting up and tearing down posted
+ * interrupt
+ */
+struct amd_iommu_pi_data {
+	u64 vapic_addr;		/* Physical address of the vCPU's vAPIC. */
+	u32 ga_tag;
+	u32 vector;		/* Guest vector of the interrupt */
+	bool is_guest_mode;
+	void *ir_data;
+};
+
+struct intel_iommu_pi_data {
 	u64 pi_desc_addr;	/* Physical address of PI Descriptor */
 	u32 vector;		/* Guest vector of the interrupt */
 };
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a0f3cdd2ea3f..6085a629c5e6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -822,23 +822,18 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	 */
 	if (vcpu && kvm_vcpu_apicv_active(vcpu)) {
 		/*
-		 * Try to enable guest_mode in IRTE.  Note, the address
-		 * of the vCPU's AVIC backing page is passed to the
-		 * IOMMU via vcpu_info->pi_desc_addr.
+		 * Try to enable guest_mode in IRTE.
 		 */
-		struct vcpu_data vcpu_info = {
-			.pi_desc_addr = avic_get_backing_page_address(to_svm(vcpu)),
-			.vector = vector,
-		};
-
-		struct amd_iommu_pi_data pi = {
-			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id, vcpu->vcpu_id),
+		struct amd_iommu_pi_data pi_data = {
+			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
+					     vcpu->vcpu_id),
 			.is_guest_mode = true,
-			.vcpu_data = &vcpu_info,
+			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
+			.vector = vector,
 		};
 		int ret;
 
-		ret = irq_set_vcpu_affinity(host_irq, &pi);
+		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
 		if (ret)
 			return ret;
 
@@ -849,7 +844,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
+		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 687ffde3b61c..3a23c30f73cb 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -303,12 +303,12 @@ int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       struct kvm_vcpu *vcpu, u32 vector)
 {
 	if (vcpu) {
-		struct vcpu_data vcpu_info = {
+		struct intel_iommu_pi_data pi_data = {
 			.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu)),
 			.vector = vector,
 		};
 
-		return irq_set_vcpu_affinity(host_irq, &vcpu_info);
+		return irq_set_vcpu_affinity(host_irq, &pi_data);
 	} else {
 		return irq_set_vcpu_affinity(host_irq, NULL);
 	}
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5141507587e1..36749efcc781 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3860,10 +3860,10 @@ int amd_iommu_deactivate_guest_mode(void *data)
 }
 EXPORT_SYMBOL(amd_iommu_deactivate_guest_mode);
 
-static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
+static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 {
 	int ret;
-	struct amd_iommu_pi_data *pi_data = vcpu_info;
+	struct amd_iommu_pi_data *pi_data = info;
 	struct amd_ir_data *ir_data = data->chip_data;
 	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
 	struct iommu_dev_data *dev_data;
@@ -3886,14 +3886,10 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	ir_data->cfg = irqd_cfg(data);
 
 	if (pi_data) {
-		struct vcpu_data *vcpu_pi_info = pi_data->vcpu_data;
-
 		pi_data->ir_data = ir_data;
 
-		WARN_ON_ONCE(!pi_data->is_guest_mode);
-
-		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
-		ir_data->ga_vector = vcpu_pi_info->vector;
+		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
+		ir_data->ga_vector = pi_data->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
 		ret = amd_iommu_activate_guest_mode(ir_data);
 	} else {
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 3bc2a03cceca..6165bb919520 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1244,10 +1244,10 @@ static void intel_ir_compose_msi_msg(struct irq_data *irq_data,
 static int intel_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 {
 	struct intel_ir_data *ir_data = data->chip_data;
-	struct vcpu_data *vcpu_pi_info = info;
+	struct intel_iommu_pi_data *pi_data = info;
 
 	/* stop posting interrupts, back to the default mode */
-	if (!vcpu_pi_info) {
+	if (!pi_data) {
 		__intel_ir_reconfigure_irte(data, true);
 	} else {
 		struct irte irte_pi;
@@ -1265,10 +1265,10 @@ static int intel_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 		/* Update the posted mode fields */
 		irte_pi.p_pst = 1;
 		irte_pi.p_urgent = 0;
-		irte_pi.p_vector = vcpu_pi_info->vector;
-		irte_pi.pda_l = (vcpu_pi_info->pi_desc_addr >>
+		irte_pi.p_vector = pi_data->vector;
+		irte_pi.pda_l = (pi_data->pi_desc_addr >>
 				(32 - PDA_LOW_BIT)) & ~(-1UL << PDA_LOW_BIT);
-		irte_pi.pda_h = (vcpu_pi_info->pi_desc_addr >> 32) &
+		irte_pi.pda_h = (pi_data->pi_desc_addr >> 32) &
 				~(-1UL << PDA_HIGH_BIT);
 
 		ir_data->irq_2_iommu.posted_vcpu = true;
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index deeefc92a5cf..99b4fa9a0296 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -12,18 +12,6 @@
 
 struct amd_iommu;
 
-/*
- * This is mainly used to communicate information back-and-forth
- * between SVM and IOMMU for setting up and tearing down posted
- * interrupt
- */
-struct amd_iommu_pi_data {
-	u32 ga_tag;
-	bool is_guest_mode;
-	struct vcpu_data *vcpu_data;
-	void *ir_data;
-};
-
 #ifdef CONFIG_AMD_IOMMU
 
 struct task_struct;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


