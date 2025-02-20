Return-Path: <kvm+bounces-38647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CEDA3D27B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8710C1898FAF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3353D1EA7F2;
	Thu, 20 Feb 2025 07:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZ655Cyo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C0E1E5734;
	Thu, 20 Feb 2025 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740037304; cv=none; b=QiYYS6E92GJdfOctWRxWzjkOP6PA8o0iaTMexYHafof4BjjUVzcGXko1J0pvg18OrPX1fYi3aC1wzYAt7RDa3HihwqJgqeWzZlMap4tGlIzAkOPrR+GTZA5Sj/7WXa539QFQPp6wLaXlNw74fb8zDhjD4emRETLrNCLJipMlc0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740037304; c=relaxed/simple;
	bh=5x0s1WlNtpqFXMyrSmNE9vzJHobilFLK27L/pcU/Ilw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRql3K1r2I1TEmyS7sVALRGHq+ARAhSih3/mYAukpEvWRBsS13VC10xBwlSw6AZuZIm27E5feYnjIRaBsbWG7fFqu5uKMgW6YewHy+lWGIrDaoKKxxiuvv2AY+PeahOAo7s3v1eHyQAUiUYrar2Kr1tJLjpXwY1W568bBPEK+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZ655Cyo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B7AC4CEDD;
	Thu, 20 Feb 2025 07:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740037302;
	bh=5x0s1WlNtpqFXMyrSmNE9vzJHobilFLK27L/pcU/Ilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZ655CyoPlDc4RvyQwajAJJSoowEXHi1sCwjPzd0KI3EBkXM0NKxYlO0D0s8ZabQW
	 eZ6Iu3Uv7L1EtGioujNXqOUc1QwVGjKrOIkKzPWmlkR+vVvMeU8DwH5+BQkgEsr4Va
	 /L0t8fNCc5ERpaOIhAlSNE66GAgwM2VaSm2qXWbX7mi/V4WiJvBEFyAmhPw+dngWlh
	 MJSJ3wOuOG/c6SDdIQuje28bm2Qu2tmNurkm29rfckXAOEOYM2jTlsNb5nad6u4NMP
	 G9S5K7NK1wfKcWNEtOp0xDWrfafzeqvNH50eX+sWRf/orl7fzZMKMRr+THDIyr7v2C
	 S6yajYalJy1gg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v3 1/2] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
Date: Thu, 20 Feb 2025 13:08:02 +0530
Message-ID: <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
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

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Newer AMD platforms enhance x2AVIC feature to support up to 4096 vcpus.
This capatility is detected via CPUID_Fn8000000A_ECX[x2AVIC_EXT].

Modify the SVM driver to check the capability. If detected, extend bitmask
for guest max physical APIC ID to 0xFFF, increase maximum vcpu index to
4095, and increase the size of the Phyical APIC ID table from 4K to 32K in
order to accommodate up to 4096 entries.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/avic.c    | 45 ++++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e2fac21471f5..4ff5b2f767e1 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -268,6 +268,7 @@ enum avic_ipi_failure_cause {
 };
 
 #define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_4K_MASK	GENMASK_ULL(11, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
@@ -277,11 +278,14 @@ enum avic_ipi_failure_cause {
 
 /*
  * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
+ * For extended x2AVIC, the max index allowed for physical APIC ID table is 0xfff (4095).
  */
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
+#define X2AVIC_MAX_PHYSICAL_ID_4K	0xFFFUL
 
 static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
+static_assert((X2AVIC_MAX_PHYSICAL_ID_4K & AVIC_PHYSICAL_MAX_INDEX_4K_MASK) == X2AVIC_MAX_PHYSICAL_ID_4K);
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 65fd245a9953..1fb322d2ac18 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -38,9 +38,9 @@
  * size of the GATag is defined by hardware (32 bits), but is an opaque value
  * as far as hardware is concerned.
  */
-#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
+#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_4K_MASK
 
-#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
+#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_4K_MASK)
 #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
@@ -73,6 +73,9 @@ static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 bool x2avic_enabled;
+static bool x2avic_4k_vcpu_supported;
+static u64 x2avic_max_physical_id;
+static u64 avic_physical_max_index_mask;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -87,7 +90,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
-	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+	vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 
@@ -100,7 +103,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -122,7 +125,7 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
-	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+	vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
 
 	/*
 	 * If running nested and the guest uses its own MSR bitmap, there
@@ -182,7 +185,8 @@ void avic_vm_destroy(struct kvm *kvm)
 	if (kvm_svm->avic_logical_id_table_page)
 		__free_page(kvm_svm->avic_logical_id_table_page);
 	if (kvm_svm->avic_physical_id_table_page)
-		__free_page(kvm_svm->avic_physical_id_table_page);
+		__free_pages(kvm_svm->avic_physical_id_table_page,
+			     get_order(sizeof(u64) * (x2avic_max_physical_id + 1)));
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&kvm_svm->hnode);
@@ -197,13 +201,15 @@ int avic_vm_init(struct kvm *kvm)
 	struct kvm_svm *k2;
 	struct page *p_page;
 	struct page *l_page;
-	u32 vm_id;
+	u32 vm_id, entries;
 
 	if (!enable_apicv)
 		return 0;
 
-	/* Allocating physical APIC ID table (4KB) */
-	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	/* Allocating physical APIC ID table */
+	entries = x2avic_max_physical_id + 1;
+	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+			     get_order(sizeof(u64) * entries));
 	if (!p_page)
 		goto free_avic;
 
@@ -266,7 +272,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
 	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
-	    (index > X2AVIC_MAX_PHYSICAL_ID))
+	    (index > x2avic_max_physical_id))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -281,7 +287,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > X2AVIC_MAX_PHYSICAL_ID))
+	    (id > x2avic_max_physical_id))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
@@ -493,7 +499,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
+	u32 index = svm->vmcb->control.exit_info_2 & avic_physical_max_index_mask;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
@@ -1218,8 +1224,19 @@ bool avic_hardware_setup(void)
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-	if (x2avic_enabled)
-		pr_info("x2AVIC enabled\n");
+	if (x2avic_enabled) {
+		x2avic_4k_vcpu_supported = !!(cpuid_ecx(0x8000000a) & 0x40);
+		if (x2avic_4k_vcpu_supported) {
+			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
+			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
+		} else {
+			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
+			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
+		}
+
+		pr_info("x2AVIC enabled%s\n",
+			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");
+	}
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
-- 
2.48.1


