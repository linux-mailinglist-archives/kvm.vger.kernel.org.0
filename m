Return-Path: <kvm+bounces-55337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFD8B301F5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429325684DE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0E73451CE;
	Thu, 21 Aug 2025 18:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="runX6P2n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D217343D66;
	Thu, 21 Aug 2025 18:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800611; cv=none; b=Uw8nf2LChtl/dvf4qEKf1u51NAeRpqyws5Gcj/PI4ZDOt8c+muRMUZ9da05uO6Tewx7VAk+UL44ko60wOyAGP9FmiXOljzDGXBZ0ReUMuO7P7HIgF0JSeO17adC1HgIao7mTmODr+aStdz5T7wzDLeeLHPlEKxQug+PSNy9/8jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800611; c=relaxed/simple;
	bh=Jz4K02/DkA+KjN4qPfqmXopJA34UvBEt2w0g5HHD59M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltZsvObR7nw3kmmyUx2ahgLF0gBUsywGpVolSoG8eeO80mxN8XhgAaFbCFlScfHH54bTFGbfceMi9VeF7b6FJzDZ72b3ZEsXNYOug6uRp+F9mA0TpA9rNKQCuleIsdqvED2n30bXu7JYrEmznjQQAdr9CgoFB6sBL2DUzTKblak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=runX6P2n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38409C4CEEB;
	Thu, 21 Aug 2025 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800610;
	bh=Jz4K02/DkA+KjN4qPfqmXopJA34UvBEt2w0g5HHD59M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=runX6P2nYn1iaWZr7MetT29pQAO4T3bAw3MRE0DrClqKqZ5JBxOAjTacU5OymOi09
	 bnV38F604/eGIaNC9fS71cjAaSTpFM0ok4M2CzmzTXHOw2A97JQQP7LLEV7EUGCvY+
	 TMEViUqd6MWrw8w2MRYa168g1mg1wVvUVZh6lw/5kyouoRzn8O/BqraeYyoaIwKMBA
	 TqpWqkdQxTi1oIsmOVSm7CrVG/PX4B+wOu4ONEi9mxRTClyXz2m+9WxxakkaEvvm1c
	 YUNydNiYEw3t+XgsHzWSuC7/3GngxnwMxD2GnkaRZK1+rTvvW8nqoPuwSbzc92OcWy
	 hyYfYfXiL1IVg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v4 7/7] KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode
Date: Thu, 21 Aug 2025 23:48:38 +0530
Message-ID: <69a5a2958b6aa111d36881a1d58d56bb20c43cac.1755797611.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755797611.git.naveen@kernel.org>
References: <cover.1755797611.git.naveen@kernel.org>
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
index 58c10991521c..16d71752606b 100644
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


