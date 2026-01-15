Return-Path: <kvm+bounces-68136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2EB8D21FFC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9388A3043A55
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B2A3002A0;
	Thu, 15 Jan 2026 01:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qUj6AEYQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A7A264A65
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439655; cv=none; b=KYk5tC+SnYUQvrNVkT5TEqBnmZa3VLftoVLw9m54OuertoPFZOSQhyxaK44L69nvQ1eSF+sI39gDHoUHxAsvG3I8AuxLe5FEvtiu1j64pBpDrlGG8yUymr36wpRiSbvV5d1VwAuYwESTb+aVFwHS70aFPzYBlZ1o0HrTU1sN4oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439655; c=relaxed/simple;
	bh=jgExKD7Pqhku8XbX3FURIJcuUtj+mT/Dip5GXR/zGk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKotsrqOSHqqn+3FVrwO6XIXliGOK8ZJ4zFP1jRCYUBzYp5cVGI+qr+TqS6VShwGdoFCb0LymT4o+dwGaoepLzhh6hL+Sxuz1cUMvn8afgNvyg/fDGSO4ehYf5gd9LLogw2YZkXHhmBFbICnYLxue3X/tqd3cHqU6H9Y0IPBfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qUj6AEYQ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AaPwS3yIusekQJKUcXWje+5DrHU3lEqF2BgYk2mX7ns=;
	b=qUj6AEYQj839qjoHJmqBHXguKPKjV5lTFur3Z+SvleYzGngBh6qD3vCNGGas/DTBgzuLM0
	NajBdwe3V1r+xSntQUDiEmr7wT7rzQX0smoEarMX8Ii21Dcu1V33UhMeQ5x/t57VDPOM3r
	gZLS8kvMe8LqQA7nCJAaeexllOzP778=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v4 25/26] KVM: nSVM: Sanitize control fields copied from VMCB12
Date: Thu, 15 Jan 2026 01:13:11 +0000
Message-ID: <20260115011312.3675857-26-yosry.ahmed@linux.dev>
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
index 0bc26b2b3fd7..d3632fbb80be 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -223,6 +223,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK BIT(AVIC_ENABLE_SHIFT)
 
+#define SVM_INT_VECTOR_MASK GENMASK(7, 0)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -636,6 +638,9 @@ static inline void __unused_size_checks(void)
 #define SVM_EVTINJ_VALID_ERR BIT(11)
 #define SVM_EVTINJ_VALID BIT(31)
 
+#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
+				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
+
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ffb741f401d0..e62fd6524feb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -500,33 +500,36 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
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
 	to->erap_ctl            = from->erap_ctl;
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
@@ -1836,7 +1839,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
 	dst->asid                 = from->asid;
-	dst->tlb_ctl              = from->tlb_ctl;
 	dst->erap_ctl             = from->erap_ctl;
 	dst->int_ctl              = from->int_ctl;
 	dst->int_vector           = from->int_vector;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2fc25803d0c7..4bc69e0d7e0a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -175,7 +175,6 @@ struct vmcb_ctrl_area_cached {
 	u64 msrpm_base_pa;
 	u64 tsc_offset;
 	u32 asid;
-	u8 tlb_ctl;
 	u8 erap_ctl;
 	u32 int_ctl;
 	u32 int_vector;
-- 
2.52.0.457.g6b5491de43-goog


