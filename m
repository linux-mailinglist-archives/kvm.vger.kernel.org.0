Return-Path: <kvm+bounces-62028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFF1C32DEB
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C80B18C5A7E
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4BD9303CB2;
	Tue,  4 Nov 2025 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QLYm/0uU"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F4E302166
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286428; cv=none; b=HDvCn+GKitVTSAIRGbeKbszA3rGPJxnWUGVSeRmeuyr4mv/fgsX8Kch4JhsE1BP9JsPW48LbBNAlzY10x6aJK2+Pu6jKKxbszpexG3IaTQ1ff2OwsXjibMfw2GnMp/cpLd0S0/Syua4K/ZjjH094oWMkQZZ7/5KVzKGIYrR92UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286428; c=relaxed/simple;
	bh=hdzkScNW4oXT5ryoTMG1XNViFhMWMZyn1m7hJDS28Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHneLkhNbh4DETO4wK4TeL6hPRy5hwQtXzwXXqz7ga/CAJNjZlX8hshBtWSDMZkJWN5B2+FvAMcGpHX1vsywSIFlL3V7oPOBvjF/aN/pTVp6Cl4MKFVpjE677Uk5nUzUXBr9fObBToHE/frvqadUnHkvzTyCjPbGCPqgH+2jCEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QLYm/0uU; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y6h4U37/LyiCJa7yadKikLFLsvzIrDOp15rdYY+w+cI=;
	b=QLYm/0uUzY0UIYz2cHFTihFPt/TS5kyrU+/HYV7D3Imy7AeFyjaP0UftJtL8KAIlpjQC77
	HwgV0TpES4czz64LP5DdXNn8gZ3G2yLQn8LH/QW4/W7mP5qGYGj+Ghs8gey05+1N79Ij/Y
	0RzjIU6pxsdM/E7C2cj189V5rkTFrgQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 10/11] KVM: nSVM: Sanitize control fields copied from VMCB12
Date: Tue,  4 Nov 2025 19:59:48 +0000
Message-ID: <20251104195949.3528411-11-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Make sure all fields used from VMCB12 in creating the VMCB02 are
sanitized, such no unhandled or reserved bits end up in the VMCB02.

The following control fields are read from VMCB12 and have bits that are
either reserved or not handled/advertised by KVM: tlb_ctl, int_ctl,
int_state, int_vector, event_inj, misc_ctl, and misc_ctl2.

The following fields do not require any extra sanitizing:
- int_ctl: bits from VMCB12 are copied bit-by-bit as needed.
- misc_ctl: only used in consistency checks (particularly NP_ENABLE).
- misc_ctl2: bits from VMCB12 are copied bit-by-bit as needed.

For the remaining fields, make sure only defined bits are copied from
VMCB12 by defining appropriate masks where needed. The only exception is
tlb_ctl, which is unused, so remove it.

Opportunisitcally move some existing definitions in svm.h around such
that they are ordered by bit position, and cleanup ignoring the lower
bits of {io/msr}pm_base_pa in __nested_copy_vmcb_control_to_cache() by
using PAGE_MASK. Also, expand the comment about the ASID being copied
only for consistency checks.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h | 11 ++++++++---
 arch/x86/kvm/svm/nested.c  | 26 ++++++++++++++------------
 arch/x86/kvm/svm/svm.h     |  1 -
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 5f3781587dd01..f583871dcc3b5 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -213,11 +213,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_NMI_ENABLE_SHIFT 26
 #define V_NMI_ENABLE_MASK (1 << V_NMI_ENABLE_SHIFT)
 
+#define X2APIC_MODE_SHIFT 30
+#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
+
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
-#define X2APIC_MODE_SHIFT 30
-#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
+#define SVM_INT_VECTOR_MASK (0xff)
 
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
@@ -629,8 +631,11 @@ static inline void __unused_size_checks(void)
 #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
 
-#define SVM_EVTINJ_VALID (1 << 31)
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
+#define SVM_EVTINJ_VALID (1 << 31)
+
+#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
+				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
 
 /* Only valid exceptions (and not NMIs) are allowed for SVM_EVTINJ_TYPE_EXEPT */
 #define SVM_EVNTINJ_INVALID_EXEPTS (NMI_VECTOR | BIT_ULL(9) | BIT_ULL(15) | \
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3c0d8990ecd11..a223887e5b78d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -461,10 +461,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		to->intercepts[i] = from->intercepts[i];
 
-	to->iopm_base_pa        = from->iopm_base_pa;
-	to->msrpm_base_pa       = from->msrpm_base_pa;
+	/* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
+	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
+	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
+
 	to->tsc_offset          = from->tsc_offset;
-	to->tlb_ctl             = from->tlb_ctl;
 	to->int_ctl             = from->int_ctl;
 	to->int_vector          = from->int_vector;
 	to->int_state           = from->int_state;
@@ -474,19 +475,21 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->misc_ctl          = from->misc_ctl;
+	to->misc_ctl		= from->misc_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->misc_ctl2            = from->misc_ctl2;
+	to->misc_ctl2		= from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls will check it.  */
+	/*
+	 * Copy asid here because nested_vmcb_check_controls() will check it.
+	 * The ASID could be invalid, or conflict with another VM's ASID , so it
+	 * should never be used directly to run L2.
+	 */
 	to->asid           = from->asid;
-	to->msrpm_base_pa &= ~0x0fffULL;
-	to->iopm_base_pa  &= ~0x0fffULL;
 
 #ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
@@ -875,9 +878,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
 		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);
 
-	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
-	vmcb02->control.int_state           = svm->nested.ctl.int_state;
-	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
+	vmcb02->control.int_vector          = svm->nested.ctl.int_vector & SVM_INT_VECTOR_MASK;
+	vmcb02->control.int_state           = svm->nested.ctl.int_state & SVM_INTERRUPT_SHADOW_MASK;
+	vmcb02->control.event_inj           = svm->nested.ctl.event_inj & ~SVM_EVTINJ_RESERVED_BITS;
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
 	/*
@@ -1760,7 +1763,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
 	dst->asid                 = from->asid;
-	dst->tlb_ctl              = from->tlb_ctl;
 	dst->int_ctl              = from->int_ctl;
 	dst->int_vector           = from->int_vector;
 	dst->int_state            = from->int_state;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70cb8985904b8..23e901cec8799 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -178,7 +178,6 @@ struct vmcb_ctrl_area_cached {
 	u64 msrpm_base_pa;
 	u64 tsc_offset;
 	u32 asid;
-	u8 tlb_ctl;
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
-- 
2.51.2.1026.g39e6a42477-goog


