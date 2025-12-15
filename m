Return-Path: <kvm+bounces-66031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6322CBFA3E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:01:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6A1730386AE
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0385833DED3;
	Mon, 15 Dec 2025 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H2nSCkJ+"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565CA33D6EA
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827022; cv=none; b=H00iVdxWrh6K38jhfqpoypYynJkAOtSRVupZGW0UZz/fjndsXV7qLFpfDwujfEK4RT2rE5K268RS5ai4Kml+ZXOPzNWbpVTWSsu4hGUBuf7Eu37+OhmWwMole4FDWFinzQI15h9Px59/ZYjbOaRjOSvmeogvWApEMoyR8mO04eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827022; c=relaxed/simple;
	bh=yky3B0u+X2Y2r3XKXtCu7wc1g9g1Fblri+9HclGZtLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a06NbvPkNUA6092qAgQPjYJJwTD4z/b8drbMwpkqMZnPxeZyntKWkUSH6Zk04/E6t+pjGKCU2GY6C3W4KWJaT5rzF2XuK/QmbSBgd/CSSbnoacBaIRqmYMxzfDlWyvcdQXoah2ATtY8+2vbXrJfGo6T/Pj+4Q2ZkPy/ZfGyi9BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H2nSCkJ+; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765827014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KjkJJM354ssJGtbsLcNUku48oAW/i25AUs9uEX16SS0=;
	b=H2nSCkJ++EVn8poPO7YynauRikGFHtFXtysOrxtcpy6jfzgAu+tkBvhwDAGnFOltJH2VLR
	gMkSdayXm0gn5ppXs/RqEdWr3JK1odHctAnnJPM80EC8wTILcFH7Rmwoqsh8U6C9OBwHDw
	6iH9HsbtR8AX2asifhqssZW8M+Y1V1k=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v3 25/26] KVM: nSVM: Sanitize control fields copied from VMCB12
Date: Mon, 15 Dec 2025 19:27:20 +0000
Message-ID: <20251215192722.3654335-27-yosry.ahmed@linux.dev>
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

Make sure all fields used from VMCB12 in creating the VMCB02 are
sanitized, such that no unhandled or reserved bits end up in the VMCB02.

The following control fields are read from VMCB12 and have bits that are
either reserved or not handled/advertised by KVM: tlb_ctl, int_ctl,
int_state, int_vector, event_inj, misc_ctl, and misc_ctl2.

The following fields do not require any extra sanitizing:
- int_ctl: bits from VMCB12 are copied bit-by-bit as needed.
- misc_ctl: only used in consistency checks (particularly NP_ENABLE).
- misc_ctl2: bits from VMCB12 are copied bit-by-bit as needed.

For the remaining fields, make sure only defined bits are copied from
L1's VMCB12 into KVM'cache by defining appropriate masks where needed.
The only exception is tlb_ctl, which is unused, so remove it.

Opportunistically cleanup ignoring the lower bits of {io/msr}pm_base_pa
in __nested_copy_vmcb_control_to_cache() by using PAGE_MASK. Also, move
the ASID copying ahead with other special cases, and expand the comment
about the ASID being copied only for consistency checks.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h |  5 +++++
 arch/x86/kvm/svm/nested.c  | 28 +++++++++++++++-------------
 arch/x86/kvm/svm/svm.h     |  1 -
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 3accc9d4d663..f92c731d1066 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -219,6 +219,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK BIT(AVIC_ENABLE_SHIFT)
 
+#define SVM_INT_VECTOR_MASK GENMASK(7, 0)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -632,6 +634,9 @@ static inline void __unused_size_checks(void)
 #define SVM_EVTINJ_VALID_ERR BIT(11)
 #define SVM_EVTINJ_VALID BIT(31)
 
+#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
+				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
+
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d33a2a27efe5..2f1006119fe7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -465,32 +465,35 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
 		to->misc_ctl &= ~SVM_MISC_CTL_NP_ENABLE;
 
-	to->iopm_base_pa        = from->iopm_base_pa;
-	to->msrpm_base_pa       = from->msrpm_base_pa;
+	/*
+	 * Copy the ASID here because nested_vmcb_check_controls() will check
+	 * it.  The ASID could be invalid, or conflict with another VM's ASID ,
+	 * so it should never be used directly to run L2.
+	 */
+	to->asid = from->asid;
+
+	/* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
+	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
+	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
+
 	to->tsc_offset          = from->tsc_offset;
-	to->tlb_ctl             = from->tlb_ctl;
 	to->int_ctl             = from->int_ctl;
-	to->int_vector          = from->int_vector;
-	to->int_state           = from->int_state;
+	to->int_vector          = from->int_vector & SVM_INT_VECTOR_MASK;
+	to->int_state           = from->int_state & SVM_INTERRUPT_SHADOW_MASK;
 	to->exit_code           = from->exit_code;
 	to->exit_code_hi        = from->exit_code_hi;
 	to->exit_info_1         = from->exit_info_1;
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->event_inj           = from->event_inj;
+	to->event_inj           = from->event_inj & ~SVM_EVTINJ_RESERVED_BITS;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->misc_ctl2            = from->misc_ctl2;
+	to->misc_ctl2		= from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls() will check it */
-	to->asid           = from->asid;
-	to->msrpm_base_pa &= ~0x0fffULL;
-	to->iopm_base_pa  &= ~0x0fffULL;
-
 #ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
@@ -1778,7 +1781,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
 	dst->asid                 = from->asid;
-	dst->tlb_ctl              = from->tlb_ctl;
 	dst->int_ctl              = from->int_ctl;
 	dst->int_vector           = from->int_vector;
 	dst->int_state            = from->int_state;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 53ca9b3baff7..4f78a78f9b33 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -175,7 +175,6 @@ struct vmcb_ctrl_area_cached {
 	u64 msrpm_base_pa;
 	u64 tsc_offset;
 	u32 asid;
-	u8 tlb_ctl;
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
-- 
2.52.0.239.gd5f0c6e74e-goog


