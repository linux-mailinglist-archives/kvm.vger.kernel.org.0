Return-Path: <kvm+bounces-66026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CEF1CBFA81
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FF9830806A7
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A34C33CEB0;
	Mon, 15 Dec 2025 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bWqIgkY/"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58B8336EF7
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826997; cv=none; b=JEp9pgB8wFQMCb2tcmx8b35NlS1lT5pRvFdoHN/hN5XP9HZGN3G8fozvhNU6Czt+llDZUtk8ujZofjDhhV8gTExwYn+KH91UpvqwR9njReF+qnYv6Fq3MLEX4uYwiqbmO7MTTsTRofGVOew3ugndQwQOeLT0Eguu0GMTFkQXja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826997; c=relaxed/simple;
	bh=BkkXdRDEnbrGGaX4aYEivNWikXu+SbX4sPS+prpEBx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhR5YADH63oiX7sSIQdqAtcmuW8FQO+lsFLzD10EbC6DXvM8CW53k2gYZJ11cn8WZ8zSdiv0/m5Elsg3TnqziDhLAlCAt3vINrHmN6ZkJ0zsuMArHmqfzvNMMVxPCgzt8c8uGU85IaCStWfnzGL+8SgIYK5N2zjabIUhUKF/pYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bWqIgkY/; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ilqyo+CxRfXHnIF31GsW9Wzfc4FwgxAMvn5/cBLF4Rs=;
	b=bWqIgkY/yVpQTZ0ecAC7AodD800Z/YXML3E8BR67576qhtXucLNGGsWRMkbngiBlALMVc/
	KQFw8PYUnG771InC/TWx/PfkmPN4/Y3TR8CGuE9i8qNrjpW88FdLLrJKsjSNccyJUekAB8
	0zTsM+bINWAaOkJi+JIm+fY//TCuvEQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 20/26] KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
Date: Mon, 15 Dec 2025 19:27:15 +0000
Message-ID: <20251215192722.3654335-22-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'nested_ctl' field is misnamed. Although the first bit is for nested
paging, the other defined bits are for SEV/SEV-ES. Other bits in the
same field according to the APM (but not defined by KVM) include "Guest
Mode Execution Trap", "Enable INVLPGB/TLBSYNC", and other control bits
unrelated to 'nested'.

There is nothing common among these bits, so just name the field
misc_ctl. Also rename the flags accordingly.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h                    |  8 ++++----
 arch/x86/kvm/svm/nested.c                     | 10 +++++-----
 arch/x86/kvm/svm/sev.c                        |  4 ++--
 arch/x86/kvm/svm/svm.c                        |  4 ++--
 arch/x86/kvm/svm/svm.h                        |  4 ++--
 tools/testing/selftests/kvm/include/x86/svm.h |  6 +++---
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e69b6d0dedcf..d08106968ce4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -142,7 +142,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u64 avic_vapic_bar;
 	u64 ghcb_gpa;
 	u32 event_inj;
@@ -236,9 +236,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
-#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_MISC_CTL_NP_ENABLE		BIT(0)
+#define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
+#define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 229903e0ad40..d46d9047f871 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -461,9 +461,9 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 		to->intercepts[i] = from->intercepts[i];
 
 	/* Always clear NP_ENABLE if the guest cannot use NPTs */
-	to->nested_ctl          = from->nested_ctl;
+	to->misc_ctl = from->misc_ctl;
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
-		to->nested_ctl &= ~SVM_NESTED_CTL_NP_ENABLE;
+		to->misc_ctl &= ~SVM_MISC_CTL_NP_ENABLE;
 
 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
@@ -801,7 +801,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	}
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
@@ -944,7 +944,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 				 vmcb12->save.rip,
 				 vmcb12->control.int_ctl,
 				 vmcb12->control.event_inj,
-				 vmcb12->control.nested_ctl,
+				 vmcb12->control.misc_ctl,
 				 vmcb12->control.nested_cr3,
 				 vmcb12->save.cr3,
 				 KVM_ISA_SVM);
@@ -1745,7 +1745,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->exit_info_2          = from->exit_info_2;
 	dst->exit_int_info        = from->exit_int_info;
 	dst->exit_int_info_err    = from->exit_int_info_err;
-	dst->nested_ctl           = from->nested_ctl;
+	dst->misc_ctl		  = from->misc_ctl;
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
 	dst->next_rip             = from->next_rip;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..dbeb776b0492 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4564,7 +4564,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm, bool init_event)
 	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
-	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
+	svm->vmcb->control.misc_ctl |= SVM_MISC_CTL_SEV_ES_ENABLE;
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
@@ -4635,7 +4635,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	svm->vmcb->control.misc_ctl |= SVM_MISC_CTL_SEV_ENABLE;
 	clr_exception_intercept(svm, UD_VECTOR);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a2c6d7e0b8ce..6efbd1ccb075 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1107,7 +1107,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
-		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		control->misc_ctl |= SVM_MISC_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
@@ -3285,7 +3285,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
 	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
 	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
-	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%lld\n", "misc_ctl:", control->misc_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d0de7d390889..9c609cb54777 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -166,7 +166,7 @@ struct vmcb_ctrl_area_cached {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 next_rip;
@@ -551,7 +551,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 {
-	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
+	return svm->nested.ctl.misc_ctl & SVM_MISC_CTL_NP_ENABLE;
 }
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
diff --git a/tools/testing/selftests/kvm/include/x86/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
index 29cffd0a9181..5d2bcce34c01 100644
--- a/tools/testing/selftests/kvm/include/x86/svm.h
+++ b/tools/testing/selftests/kvm/include/x86/svm.h
@@ -98,7 +98,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u64 avic_vapic_bar;
 	u8 reserved_4[8];
 	u32 event_inj;
@@ -176,8 +176,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
+#define SVM_MISC_CTL_CTL_NP_ENABLE	BIT(0)
+#define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
 
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
-- 
2.52.0.239.gd5f0c6e74e-goog


