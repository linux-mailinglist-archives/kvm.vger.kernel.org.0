Return-Path: <kvm+bounces-68132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08BEDD21FEA
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CF0D2306DA86
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2A32EBB81;
	Thu, 15 Jan 2026 01:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j59JEpYx"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFE82D2491
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439650; cv=none; b=LhvXPOewaE7bm4GHT6bmY14IG1FnsYtzsQ1xcOximtcSPGrzM+EHVvw6W+nYwloe7k9bMPOjXuzlEcgtba8yLs71wnNPfHHaqKSovRyGaelk5X7ql+Jwm0yhwbjApqZmlOhAGeE2IDD82bGswOPBfMnUUeI8Yo76AM4PuXe5qq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439650; c=relaxed/simple;
	bh=3QP0bb3GDMptRIKrVXdEcSGoJ5I47VZUMyyzgkRfKMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr82wTcU1NFWyoZNijR/asUJAuqDS6duX/zbO4mxk76h8RtZ+rvKJYZnYJ/75DjAKTDQ8HNx3rT0ALuT3S03MoIHVhWdedhGtSSOBxXFwsTd9fV1OiUwrsCwkzR4ReLLpy8yLbDVdzAgSZrjfQgW4Q7lMVEOkYMd6CvvNQ5sz30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j59JEpYx; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7IrGfhTdzxgOo0JvNAgS7vFeXnezCbGeHIZllu7YIbE=;
	b=j59JEpYxO4DDHcSvtWiZqH/yJL2pbQUVBqd/kn213XZwrC+o/54mX8aXfjp5Osv3Tv+lRa
	0mh50DmEPnl1raiGtPCB1qAZx0LtXy7JkVFsgNusLkHoQdoF8A8di9bnHgRsdBxLWQYSsY
	qrOtlgIgm38UETbbf/j8ohQdqniN+o4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v4 22/26] KVM: SVM: Use BIT() and GENMASK() for definitions in svm.h
Date: Thu, 15 Jan 2026 01:13:08 +0000
Message-ID: <20260115011312.3675857-23-yosry.ahmed@linux.dev>
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

Use BIT() and GENMASK() (and *_ULL() variants) to define the bitmasks in
svm.h.

Opportunistically switch the definitions of AVIC_ENABLE_{SHIFT/MASK}
and X2APIC_MODE_{SHIFT/MASK}, as well as SVM_EVTINJ_VALID and
SVM_EVTINJ_VALID_ERR, such that the bitmasks are defined in the correct
order.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h | 78 +++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 770c7aed5fa5..0bc26b2b3fd7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -189,39 +189,39 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
-#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
+#define V_IRQ_MASK BIT(V_IRQ_SHIFT)
 
 #define V_GIF_SHIFT 9
-#define V_GIF_MASK (1 << V_GIF_SHIFT)
+#define V_GIF_MASK BIT(V_GIF_SHIFT)
 
 #define V_NMI_PENDING_SHIFT 11
-#define V_NMI_PENDING_MASK (1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_PENDING_MASK BIT(V_NMI_PENDING_SHIFT)
 
 #define V_NMI_BLOCKING_SHIFT 12
-#define V_NMI_BLOCKING_MASK (1 << V_NMI_BLOCKING_SHIFT)
+#define V_NMI_BLOCKING_MASK BIT(V_NMI_BLOCKING_SHIFT)
 
 #define V_INTR_PRIO_SHIFT 16
-#define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
+#define V_INTR_PRIO_MASK GENMASK(V_INTR_PRIO_SHIFT + 3, V_INTR_PRIO_SHIFT)
 
 #define V_IGN_TPR_SHIFT 20
-#define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
+#define V_IGN_TPR_MASK BIT(V_IGN_TPR_SHIFT)
 
 #define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
 
 #define V_INTR_MASKING_SHIFT 24
-#define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
+#define V_INTR_MASKING_MASK BIT(V_INTR_MASKING_SHIFT)
 
 #define V_GIF_ENABLE_SHIFT 25
-#define V_GIF_ENABLE_MASK (1 << V_GIF_ENABLE_SHIFT)
+#define V_GIF_ENABLE_MASK BIT(V_GIF_ENABLE_SHIFT)
 
 #define V_NMI_ENABLE_SHIFT 26
-#define V_NMI_ENABLE_MASK (1 << V_NMI_ENABLE_SHIFT)
-
-#define AVIC_ENABLE_SHIFT 31
-#define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
+#define V_NMI_ENABLE_MASK BIT(V_NMI_ENABLE_SHIFT)
 
 #define X2APIC_MODE_SHIFT 30
-#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
+#define X2APIC_MODE_MASK BIT(X2APIC_MODE_SHIFT)
+
+#define AVIC_ENABLE_SHIFT 31
+#define AVIC_ENABLE_MASK BIT(AVIC_ENABLE_SHIFT)
 
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
@@ -232,10 +232,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_ASIZE_SHIFT 7
 
 #define SVM_IOIO_TYPE_MASK 1
-#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
-#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
-#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
-#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
+#define SVM_IOIO_STR_MASK BIT(SVM_IOIO_STR_SHIFT)
+#define SVM_IOIO_REP_MASK BIT(SVM_IOIO_REP_SHIFT)
+#define SVM_IOIO_SIZE_MASK GENMASK(SVM_IOIO_SIZE_SHIFT + 2, SVM_IOIO_SIZE_SHIFT)
+#define SVM_IOIO_ASIZE_MASK GENMASK(SVM_IOIO_ASIZE_SHIFT + 2, SVM_IOIO_ASIZE_SHIFT)
 
 #define SVM_MISC_CTL_NP_ENABLE		BIT(0)
 #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
@@ -251,9 +251,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 
 /* AVIC */
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	GENMASK_ULL(7, 0)
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
-#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
+#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		BIT(AVIC_LOGICAL_ID_ENTRY_VALID_BIT)
 
 /*
  * GA_LOG_INTR is a synthetic flag that's never propagated to hardware-visible
@@ -264,15 +264,15 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	GENMASK_ULL(51, 12)
-#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
-#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		BIT_ULL(62)
+#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		BIT_ULL(63)
+#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		GENMASK_ULL(7, 0)
 
 #define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
 
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
-#define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
-#define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
+#define AVIC_UNACCEL_ACCESS_OFFSET_MASK		GENMASK(11, 4)
+#define AVIC_UNACCEL_ACCESS_VECTOR_MASK		GENMASK(31, 0)
 
 enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_INT_TYPE,
@@ -611,30 +611,30 @@ static inline void __unused_size_checks(void)
 #define SVM_SELECTOR_G_SHIFT 11
 
 #define SVM_SELECTOR_TYPE_MASK (0xf)
-#define SVM_SELECTOR_S_MASK (1 << SVM_SELECTOR_S_SHIFT)
-#define SVM_SELECTOR_DPL_MASK (3 << SVM_SELECTOR_DPL_SHIFT)
-#define SVM_SELECTOR_P_MASK (1 << SVM_SELECTOR_P_SHIFT)
-#define SVM_SELECTOR_AVL_MASK (1 << SVM_SELECTOR_AVL_SHIFT)
-#define SVM_SELECTOR_L_MASK (1 << SVM_SELECTOR_L_SHIFT)
-#define SVM_SELECTOR_DB_MASK (1 << SVM_SELECTOR_DB_SHIFT)
-#define SVM_SELECTOR_G_MASK (1 << SVM_SELECTOR_G_SHIFT)
-
-#define SVM_SELECTOR_WRITE_MASK (1 << 1)
+#define SVM_SELECTOR_S_MASK BIT(SVM_SELECTOR_S_SHIFT)
+#define SVM_SELECTOR_DPL_MASK GENMASK(SVM_SELECTOR_DPL_SHIFT + 1, SVM_SELECTOR_DPL_SHIFT)
+#define SVM_SELECTOR_P_MASK BIT(SVM_SELECTOR_P_SHIFT)
+#define SVM_SELECTOR_AVL_MASK BIT(SVM_SELECTOR_AVL_SHIFT)
+#define SVM_SELECTOR_L_MASK BIT(SVM_SELECTOR_L_SHIFT)
+#define SVM_SELECTOR_DB_MASK BIT(SVM_SELECTOR_DB_SHIFT)
+#define SVM_SELECTOR_G_MASK BIT(SVM_SELECTOR_G_SHIFT)
+
+#define SVM_SELECTOR_WRITE_MASK BIT(1)
 #define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
-#define SVM_SELECTOR_CODE_MASK (1 << 3)
+#define SVM_SELECTOR_CODE_MASK BIT(3)
 
-#define SVM_EVTINJ_VEC_MASK 0xff
+#define SVM_EVTINJ_VEC_MASK GENMASK(7, 0)
 
 #define SVM_EVTINJ_TYPE_SHIFT 8
-#define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_MASK GENMASK(SVM_EVTINJ_TYPE_SHIFT + 2, SVM_EVTINJ_TYPE_SHIFT)
 
 #define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
 
-#define SVM_EVTINJ_VALID (1 << 31)
-#define SVM_EVTINJ_VALID_ERR (1 << 11)
+#define SVM_EVTINJ_VALID_ERR BIT(11)
+#define SVM_EVTINJ_VALID BIT(31)
 
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
@@ -651,7 +651,7 @@ static inline void __unused_size_checks(void)
 #define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
 #define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
 
-#define SVM_EXITINFO_REG_MASK 0x0F
+#define SVM_EXITINFO_REG_MASK GENMASK(3, 0)
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
-- 
2.52.0.457.g6b5491de43-goog


