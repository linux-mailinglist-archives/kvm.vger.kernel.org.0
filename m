Return-Path: <kvm+bounces-56849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 707B5B4458D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10FDFAA07AF
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E713930BBBC;
	Thu,  4 Sep 2025 18:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqvmO3Ql"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5C2367D5
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757011012; cv=none; b=kwg3NnBrHtqReKRwkv/onzKrU7U4g+CCwS78tYRnvzsgFXBJOsTF4nM6iXDh+GxAvq1lq+3Ko/OkgGsWmSZMb3gsURUyGtdKEuQl3cFvy6z5im0Wfl71o+UpeBZfnqcvNxc98gn0uY+z4KrRtFa/rJ1V2nVhrW5uJ6dPr9OIqfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757011012; c=relaxed/simple;
	bh=SuJCvA2/LMGVOA2TJV8DADJgVZB7NFw/ilhgnfXc6/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaUe+cDoVqRz3lWoCb2wYfQfwdK/YWLIVZmFpk1+QjaAMQUFhRjDPG5MQk40hNgTHPcQRYEtIgXTmOTDuqiuHkVEDNgNIWl1s6CGPVydv0DgTp2i7RFzRTjMqQA+9yX4/Jen3Q8qkoqNZ/LP0Yndv8kLq751kfkjXx7HYkP9lZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqvmO3Ql; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84E7C4CEF0;
	Thu,  4 Sep 2025 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757011011;
	bh=SuJCvA2/LMGVOA2TJV8DADJgVZB7NFw/ilhgnfXc6/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqvmO3Ql7x5QsPDfZ1RGsTh/kNJ9gbRKEd1b+S/fponU/hLyQwLScTuOEpnB88j9h
	 Gbe8yKsUxdlmaesWKvZU9xWzgTCYhGvarzDc9v7x64unVeejhO0UdTDlNjI2uZpZzt
	 2ItYe8Deshnp/XsiQ5vDKfIQH/kcLmMjEvJLw4X/EFWE6rmqCj0eVNp7SzWsexx+ts
	 83meeFAzgZW6iqoeo0AdU7wdb5n8cxzL2HiWaYZ1GGg3d0HEE375PGMNJZe1s2o+bP
	 4fH7L5pB7GWaSabRolkVW2wPLPH+tIrk/V5pktiVANUAzhMkR4xCqEVK+aLxbnqP5J
	 5+yAAjTHo/kJw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>,
	<kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RESEND v4 7/7] KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode
Date: Fri,  5 Sep 2025 00:03:07 +0530
Message-ID: <7fc5962f6da028f7dd3c79dbbd5c574fa02c99dd.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757009416.git.naveen@kernel.org>
References: <cover.1757009416.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With AVIC support for 4k vCPUs, the maximum supported physical ID in
x2AVIC mode is 4095. Since this is no longer fixed, introduce a variable
(x2avic_max_physical_id) to capture the maximum supported physical ID on
the current platform and use that in place of the existing macro
(X2AVIC_MAX_PHYSICAL_ID).

With AVIC support for 4k vCPUs, the AVIC Physical ID table is no
longer a single page and can occupy up to 8 contiguous 4k pages. Since
AVIC hardware accesses of the physical ID table are limited by the
physical max index programmed in the VMCB, it is sufficient to allocate
only as many pages as are required to have a physical table entry for
the max guest APIC ID. Since the guest APIC mode is not available at
this point, provision for the maximum possible x2AVIC ID. For this
purpose, add a variant of avic_get_max_physical_id() that works with a
NULL vCPU pointer and returns the max x2AVIC ID. Wrap this in a new
helper for obtaining the allocation order.

To make it easy to identify support for 4k vCPUs in x2AVIC mode, update
the message printed to the kernel log to print the maximum number of
vCPUs supported. Do this on all platforms supporting x2AVIC since it is
useful to know what is supported on a specific platform.

Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 43 ++++++++++++++++++++++++++++----------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index d227e710c6b4..e69b6d0dedcf 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -289,11 +289,14 @@ enum avic_ipi_failure_cause {
 
 /*
  * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
+ * With X86_FEATURE_X2AVIC_EXT, the max index is increased to 0xfff (4095).
  */
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
+#define X2AVIC_4K_MAX_PHYSICAL_ID	0xFFFUL
 
 static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
+static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_4K_MAX_PHYSICAL_ID);
 
 #define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b5a397b7c684..1dda90d29f4e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -78,13 +78,14 @@ static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 bool x2avic_enabled;
+static u64 x2avic_max_physical_id;
 
-static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
+static u32 __avic_get_max_physical_id(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	u32 arch_max;
 
-	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
-		arch_max = X2AVIC_MAX_PHYSICAL_ID;
+	if (x2avic_enabled && (!vcpu || apic_x2apic_mode(vcpu->arch.apic)))
+		arch_max = x2avic_max_physical_id;
 	else
 		arch_max = AVIC_MAX_PHYSICAL_ID;
 
@@ -92,7 +93,12 @@ static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
 	 * Despite its name, KVM_CAP_MAX_VCPU_ID represents the maximum APIC ID plus one,
 	 * so the max possible APIC ID is one less than that.
 	 */
-	return min(vcpu->kvm->arch.max_vcpu_ids - 1, arch_max);
+	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
+}
+
+static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
+{
+	return __avic_get_max_physical_id(vcpu->kvm, vcpu);
 }
 
 static void avic_activate_vmcb(struct vcpu_svm *svm)
@@ -185,6 +191,12 @@ int avic_ga_log_notifier(u32 ga_tag)
 	return 0;
 }
 
+static int avic_get_physical_id_table_order(struct kvm *kvm)
+{
+	/* Provision for the maximum physical ID supported in x2avic mode */
+	return get_order((__avic_get_max_physical_id(kvm, NULL) + 1) * sizeof(u64));
+}
+
 int avic_alloc_physical_id_table(struct kvm *kvm)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
@@ -192,7 +204,8 @@ int avic_alloc_physical_id_table(struct kvm *kvm)
 	if (kvm_svm->avic_physical_id_table || !enable_apicv || !irqchip_in_kernel(kvm))
 		return 0;
 
-	kvm_svm->avic_physical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	kvm_svm->avic_physical_id_table = (void *)__get_free_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+								   avic_get_physical_id_table_order(kvm));
 	if (!kvm_svm->avic_physical_id_table)
 		return -ENOMEM;
 
@@ -208,7 +221,8 @@ void avic_vm_destroy(struct kvm *kvm)
 		return;
 
 	free_page((unsigned long)kvm_svm->avic_logical_id_table);
-	free_page((unsigned long)kvm_svm->avic_physical_id_table);
+	free_pages((unsigned long)kvm_svm->avic_physical_id_table,
+		   avic_get_physical_id_table_order(kvm));
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&kvm_svm->hnode);
@@ -290,7 +304,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	 * fully initialized AVIC.
 	 */
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
+	    (id > x2avic_max_physical_id)) {
 		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
 		vcpu->arch.apic->apicv_active = false;
 		return 0;
@@ -910,7 +924,8 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
 	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
-	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
+	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >=
+			 PAGE_SIZE << avic_get_physical_id_table_order(vcpu->kvm)))
 		return;
 
 	/*
@@ -972,7 +987,8 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 
 	lockdep_assert_preemption_disabled();
 
-	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
+	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >=
+			 PAGE_SIZE << avic_get_physical_id_table_order(vcpu->kvm)))
 		return;
 
 	/*
@@ -1156,8 +1172,13 @@ bool avic_hardware_setup(void)
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-	if (x2avic_enabled)
-		pr_info("x2AVIC enabled\n");
+	if (x2avic_enabled) {
+		if (cpu_feature_enabled(X86_FEATURE_X2AVIC_EXT))
+			x2avic_max_physical_id = X2AVIC_4K_MAX_PHYSICAL_ID;
+		else
+			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
+		pr_info("x2AVIC enabled (max %lld vCPUs)\n", x2avic_max_physical_id + 1);
+	}
 
 	/*
 	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
-- 
2.50.1


