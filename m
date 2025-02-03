Return-Path: <kvm+bounces-37094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA95A25294
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 07:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AF413A4795
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 06:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7141E98EA;
	Mon,  3 Feb 2025 06:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7mV7qoj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5AA1D9688;
	Mon,  3 Feb 2025 06:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738564813; cv=none; b=hDsCn+hE+T/8e50uD1StS3izhAXGJg7jbEcC0wBoQZvcb2MrvmWCmqJ37LRf1HyxG70ukombFzeBaLrtFCF05zG1FjNE3jbkWHVo02gV33uxF3T8i4rvNkvrxo+DglhfbPkwt3NBhu0eYm+ZQMhq/kuuBDO9lbn6Tlb5Vqv0z/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738564813; c=relaxed/simple;
	bh=AJGgSFjnLvG14ktKseDbhiBaz0pVxRoJIgQO3axUhs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/Dqx2BMoH3RS9XzK7fCUF0gCeLmSAd/9OWfeVm16A8baq51I9kXFPq5fOpyTlznHMwfupzlbvk+zEwuwQ6akYAhjVZUGmjTSc83q8rRze0RQC/XkNk1U/MGgPvZbb2YakgcPNU8LrlShjKzyywnodDtZ+FWFDeMBTPNosJA5Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7mV7qoj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13C7C4CEE3;
	Mon,  3 Feb 2025 06:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738564812;
	bh=AJGgSFjnLvG14ktKseDbhiBaz0pVxRoJIgQO3axUhs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7mV7qojzSljEw9/4oBg/Zab3ZpVmvcVt6liE7RilHmx/v7pwx/+oE0YvP9qauEff
	 83LOJMP7n7Mgco9Gkb/lC1rDNPjT9I9nGVpq1qZCS1XMsu5N/7Uv6bJtGbX9neIuJd
	 NCqgCf3BC1AZUz1QTDOAIPQGH36yzkdmTDVXPBcuadVKVW1kfZlOY8ezW/FAj3/1iK
	 VLxNsCwu60l2nxiUj4nV3ZoZp/k5VcmfY266gsAbXk1fzE2aklJ1eOPbRktoPjYmgK
	 SKTi+gKvoNwyCrhM/r+qFUOm7g2U0VOxvu3BXACWAf2OyTvcv79lPRTqhuJOWI9fLU
	 KtG3NA3k36CBw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
Date: Mon,  3 Feb 2025 12:07:46 +0530
Message-ID: <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1738563890.git.naveen@kernel.org>
References: <cover.1738563890.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM allows VMMs to specify the maximum possible APIC ID for a virtual
machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
structures related to APIC/x2APIC. Utilize the same to set the AVIC
physical max index in the VMCB, similar to VMX. This helps hardware
limit the number of entries to be scanned in the physical APIC ID table
speeding up IPI broadcasts for virtual machines with smaller number of
vcpus.

The minimum allocation required for the Physical APIC ID table is one 4k
page supporting up to 512 entries. With AVIC support for 4096 vcpus
though, it is sufficient to only allocate memory to accommodate the
AVIC physical max index that will be programmed into the VMCB. Limit
memory allocated for the Physical APIC ID table accordingly.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 54 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.c  |  6 +++++
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4c940f4fd34d..e6ec3bcb1e37 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -85,6 +85,17 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool x2apic_mode)
+{
+	u32 avic_max_physical_id = x2apic_mode ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
+
+	/*
+	 * Assume vcpu_id is the same as APIC ID. Per KVM_CAP_MAX_VCPU_ID, max_vcpu_ids
+	 * represents the max APIC ID for this vm, rather than the max vcpus.
+	 */
+	return min(kvm->arch.max_vcpu_ids - 1, avic_max_physical_id);
+}
+
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
+		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -114,7 +125,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
 
 		/* For xAVIC and hybrid-xAVIC modes */
-		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, false);
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
 	}
@@ -174,6 +185,12 @@ int avic_ga_log_notifier(u32 ga_tag)
 	return 0;
 }
 
+static inline int avic_get_physical_id_table_order(struct kvm *kvm)
+{
+	/* Limit to the maximum physical ID supported in x2avic mode */
+	return get_order((avic_get_max_physical_id(kvm, true) + 1) * sizeof(u64));
+}
+
 void avic_vm_destroy(struct kvm *kvm)
 {
 	unsigned long flags;
@@ -185,7 +202,8 @@ void avic_vm_destroy(struct kvm *kvm)
 	if (kvm_svm->avic_logical_id_table_page)
 		__free_page(kvm_svm->avic_logical_id_table_page);
 	if (kvm_svm->avic_physical_id_table_page)
-		__free_page(kvm_svm->avic_physical_id_table_page);
+		__free_pages(kvm_svm->avic_physical_id_table_page,
+			     avic_get_physical_id_table_order(kvm));
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&kvm_svm->hnode);
@@ -198,22 +216,12 @@ int avic_vm_init(struct kvm *kvm)
 	int err = -ENOMEM;
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 	struct kvm_svm *k2;
-	struct page *p_page;
 	struct page *l_page;
-	u32 vm_id, entries;
+	u32 vm_id;
 
 	if (!enable_apicv)
 		return 0;
 
-	/* Allocating physical APIC ID table */
-	entries = x2avic_max_physical_id + 1;
-	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
-			     get_order(sizeof(u64) * entries));
-	if (!p_page)
-		goto free_avic;
-
-	kvm_svm->avic_physical_id_table_page = p_page;
-
 	/* Allocating logical APIC ID table (4KB) */
 	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!l_page)
@@ -264,6 +272,24 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 		avic_deactivate_vmcb(svm);
 }
 
+int avic_alloc_physical_id_table(struct kvm *kvm)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	struct page *p_page;
+
+	if (kvm_svm->avic_physical_id_table_page || !enable_apicv || !irqchip_in_kernel(kvm))
+		return 0;
+
+	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+			     avic_get_physical_id_table_order(kvm));
+	if (!p_page)
+		return -ENOMEM;
+
+	kvm_svm->avic_physical_id_table_page = p_page;
+
+	return 0;
+}
+
 static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 				       unsigned int index)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..19b9ebea4773 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1423,6 +1423,11 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 	svm->vmcb = target_vmcb->ptr;
 }
 
+static int svm_vcpu_precreate(struct kvm *kvm)
+{
+	return avic_alloc_physical_id_table(kvm);
+}
+
 static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
@@ -5009,6 +5014,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
+	.vcpu_precreate = svm_vcpu_precreate,
 	.vcpu_create = svm_vcpu_create,
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d7cdb8fbf87..68687c3bcce7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -696,6 +696,7 @@ bool avic_hardware_setup(void);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
+int avic_alloc_physical_id_table(struct kvm *kvm);
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
-- 
2.48.1


