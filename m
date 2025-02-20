Return-Path: <kvm+bounces-38648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61767A3D27C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEE547A34E1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74501EB9ED;
	Thu, 20 Feb 2025 07:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="modqC0LJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5F1EB1AA;
	Thu, 20 Feb 2025 07:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740037308; cv=none; b=ilY0rniJUwKiCzJt9oe7HpAkp8DXxZwoxcMbeTYF8H8WT6uWFIjda/g3tSwwS7zTDwt6LuHRXEdYrzYceZn6x7KciB1HsLvxVg/+F395kxlCogYvDnc6Jj/uvZRMoqvCePjvUUFkaWGlQJLS4yQN5tJRK9f+Z4lSozSPVZku0/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740037308; c=relaxed/simple;
	bh=2m5fMq0w89y2cVxObSFljzgnxj6ecbAOXIvZHg3WaRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2B62/dn4xflWPIQ0ymQRxMwJxtK4heh2C5jCX9H++hL4lml3g3DYCeNSvVkWLe7OW6HOTFVvFL3eqaGCOp+q98y6zHh1vIbUXMWSZXawCkevby1CAKtWKgu5DBjAVqCOb/x1G6RXXpd3JJ3TZ5mlfEWo1B9QY6DYPU9idMQIy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=modqC0LJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07757C4CED1;
	Thu, 20 Feb 2025 07:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740037307;
	bh=2m5fMq0w89y2cVxObSFljzgnxj6ecbAOXIvZHg3WaRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=modqC0LJcC7bgfBYPaLE7oc1nMfrcxeR9HtewLJuggSQgluMo4oLcOKZRiYIYdzBj
	 izRGFZ2toDIfcJPUdARSICdfjOyCgWpS88Mdz8ZXEvRhc22HWiApgQbc/LfKuf/o8c
	 /dz+u+jgE0S7Y8wHxJkfCu+82oxSybafr2be6P6KwJ/82CNQ8umdvMAK8yknswXUtk
	 jbInxR+lE4cKDlhfmof10kzeRrjGsrnhuzcYnFwFOkUABvC33n9J7f6NQUV9EXD7SX
	 bJxeXGTk+1DYvfG38uuTBIbytQikn8P/Aqu3S9nTefbr3YEu6qsUXdOAkHnRzdP+wO
	 NwWLVeMqMVfkQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v3 2/2] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
Date: Thu, 20 Feb 2025 13:08:03 +0530
Message-ID: <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740036492.git.naveen@kernel.org>
References: <cover.1740036492.git.naveen@kernel.org>
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
 arch/x86/kvm/svm/avic.c | 53 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.c  |  6 +++++
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1fb322d2ac18..dac4a6648919 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -85,6 +85,17 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool is_x2apic)
+{
+	u32 avic_max_physical_id = is_x2apic ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
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
@@ -186,7 +203,7 @@ void avic_vm_destroy(struct kvm *kvm)
 		__free_page(kvm_svm->avic_logical_id_table_page);
 	if (kvm_svm->avic_physical_id_table_page)
 		__free_pages(kvm_svm->avic_physical_id_table_page,
-			     get_order(sizeof(u64) * (x2avic_max_physical_id + 1)));
+			     avic_get_physical_id_table_order(kvm));
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&kvm_svm->hnode);
@@ -199,22 +216,12 @@ int avic_vm_init(struct kvm *kvm)
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
@@ -265,6 +272,24 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
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
index b8aa0f36850f..3cb23298cdc3 100644
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
@@ -5007,6 +5012,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
+	.vcpu_precreate = svm_vcpu_precreate,
 	.vcpu_create = svm_vcpu_create,
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5b159f017055..b4670afe0034 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,6 +694,7 @@ bool avic_hardware_setup(void);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
+int avic_alloc_physical_id_table(struct kvm *kvm);
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
-- 
2.48.1


