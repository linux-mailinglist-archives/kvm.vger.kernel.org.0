Return-Path: <kvm+bounces-68131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A72CD21FDE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E3FB30B340A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF403277037;
	Thu, 15 Jan 2026 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="naFQ+INR"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A8A26D4C3
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439648; cv=none; b=LSWVn0M3+Q8IHS3zYq06nw0TdFyU44CiSQ13c8S5t/W/7HNJQF9awCgiy5O3gCfLitorU/olHrEq1Rn/SFKT14tZP6kpTafH9e7RFcez9hiVorspjSKRYUOBfRSlVk1oSjymge88uaL4MnlLFhoTDbZ8fgAwiuzKcfZEWPvBHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439648; c=relaxed/simple;
	bh=QZukHD1jb3jA7ZmfYuCVooVzql93sc61Up+B8EMXDTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl76V2pbFglO+fwEFrcJ0ZrA9NCZ9GkHHNGNurGs708+TTQixu+jdygC6gpM3IR3Og5SLHTgSgWefyEXFL2XyO7+8t7gSbW54Y4oyttXEnvc8uspJ1bo13S6I0E8M0JEb96iPshYctg10wky6W3joI0R8EdaYdLzuAcqXMNvRA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=naFQ+INR; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WNDyOlyEyIQPEF1lGqpybPE2otDvXgipCFufI2UQZoQ=;
	b=naFQ+INR1gCDZQvpXiHOyS/Ks/pBTEerXQbunUuTGb0slzvkcPEVE9SMrbkbuvdDamz9td
	Eracrp1kKfcoc4WGRMBDGGLdAwJolXyY8ONipvtu2Pi68T5GEUtpXlOhzFz5okkouohDMj
	X5+rcMrGHUvHxhuXHhUkIpEIaC8+UVs=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v4 20/26] KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
Date: Thu, 15 Jan 2026 01:13:06 +0000
Message-ID: <20260115011312.3675857-21-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
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
 tools/testing/selftests/kvm/lib/x86/svm.c     |  2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 50ece197c98a..2e39ac15ee5a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -143,7 +143,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u64 avic_vapic_bar;
 	u64 ghcb_gpa;
 	u32 event_inj;
@@ -240,9 +240,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
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
index 79db1e1c8b2a..605e202ba208 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -496,9 +496,9 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	nested_svm_sanitize_intercept(vcpu, to, RDPRU);
 
 	/* Always clear NP_ENABLE if the guest cannot use NPTs */
-	to->nested_ctl          = from->nested_ctl;
+	to->misc_ctl = from->misc_ctl;
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
-		to->nested_ctl &= ~SVM_NESTED_CTL_NP_ENABLE;
+		to->misc_ctl &= ~SVM_MISC_CTL_NP_ENABLE;
 
 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
@@ -837,7 +837,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	}
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
@@ -993,7 +993,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 				 vmcb12->save.rip,
 				 vmcb12->control.int_ctl,
 				 vmcb12->control.event_inj,
-				 vmcb12->control.nested_ctl,
+				 vmcb12->control.misc_ctl,
 				 vmcb12->control.nested_cr3,
 				 vmcb12->save.cr3,
 				 KVM_ISA_SVM);
@@ -1804,7 +1804,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
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
index f3901f9ee487..e64bbae8f852 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1149,7 +1149,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
-		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		control->misc_ctl |= SVM_MISC_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
@@ -3352,7 +3352,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
 	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
 	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
-	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%lld\n", "misc_ctl:", control->misc_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index dc0ce2141d5f..166d2b93797d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -167,7 +167,7 @@ struct vmcb_ctrl_area_cached {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 next_rip;
@@ -571,7 +571,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
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
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index 2e5c480c9afd..fd70984a2aa5 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -126,7 +126,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	guest_regs.rdi = (u64)svm;
 
 	if (svm->ncr3_gpa) {
-		ctrl->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		ctrl->misc_ctl |= SVM_MISC_CTL_CTL_NP_ENABLE;
 		ctrl->nested_cr3 = svm->ncr3_gpa;
 	}
 }
-- 
2.52.0.457.g6b5491de43-goog


