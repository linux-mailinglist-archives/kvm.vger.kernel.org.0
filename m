Return-Path: <kvm+bounces-62648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C60C49C00
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:29:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EB903AD423
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FEC332EAE;
	Mon, 10 Nov 2025 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JHxcKIy6"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285BE307499
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817233; cv=none; b=jItfbJz4HxaER1nFHXWux2mX1f+MSeqMW314C4lwvs547b5jn+LFj/B4oe8Aa3dUsR3A/hSP4WXQRRFiPNGcsRaFHCy7DzY58MXsifJaJ9/0fM+347NXP0BrxFjI+Hn58y+S5jiGI1ZjiFxMS0Kawlmrv9KSFljs1Ku8zDlgA+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817233; c=relaxed/simple;
	bh=roYRu1M560hcl695WlAsLYjZC2PQoGNp3VD2CPQ9TNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5j9o0QHjZdU7G+GxkC+yOItm+FqnSv55fvqKnQ2s7n85kITv6EauG45hiiDxFV/9yyurPJRyzTw/b09zOnVBRR/sI7EGROn79uTWhq7BvYT+Y3LGKaMRfB77htYDKpKledZXPaw4QZMr+8hhrR6i2xEZ/2Wp/T5L/9IVaeo0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JHxcKIy6; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oK6NUMeTeGf2gh5AQUB1Dh0KArCUE3th1RWLcmN82Uk=;
	b=JHxcKIy6Sw4naNIlcI2i/m3gQ2APs8UISFb/TSuKqZf35Ow+w39Ih7x+At35JwPkjXtBSQ
	fRhgOuqmeG4Y9nrmUtvWE0+E2qPt/ZbwUQeNGcV79Xp/d9K9GCAHGpAc3jlWXnkuBD7GEE
	tnqn+NHLsfrrugRtADD4b9pR5RCMhic=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 05/14] x86/svm: Add FEP helpers for SVM tests
Date: Mon, 10 Nov 2025 23:26:33 +0000
Message-ID: <20251110232642.633672-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add helpers to check if FEP is enabled to use as supported() callbacks
in SVM tests for the emulator. Also add a macro that executes an
assembly instruction conditionally with FEP, which will make writing
SVM tests that run with and without FEP more convenient.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 lib/x86/desc.h | 8 ++++++++
 x86/svm.c      | 5 +++++
 x86/svm.h      | 1 +
 3 files changed, 14 insertions(+)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 68f38f3d75333..06c8be65221dc 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -284,6 +284,14 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 #define asm_fep_safe(insn, inputs...)				\
 	__asm_safe_out1(KVM_FEP, insn,, inputs)
 
+#define asm_conditional_fep_safe(fep, insn, inputs...)			\
+({									\
+	if (fep)							\
+		asm_fep_safe(insn, inputs);				\
+	else								\
+		asm_safe(insn, inputs);					\
+})
+
 #define __asm_safe_out1(fep, insn, output, inputs...)			\
 ({									\
 	asm volatile(__ASM_TRY(fep, "1f")				\
diff --git a/x86/svm.c b/x86/svm.c
index e715e270bc5b7..035367a1e90cf 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -53,6 +53,11 @@ bool default_supported(void)
 	return true;
 }
 
+bool fep_supported(void)
+{
+	return is_fep_available;
+}
+
 bool vgif_supported(void)
 {
 	return this_cpu_has(X86_FEATURE_VGIF);
diff --git a/x86/svm.h b/x86/svm.h
index c1dd84afb25eb..264583a6547ef 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -417,6 +417,7 @@ u64 *npt_get_pdpe(u64 address);
 u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
+bool fep_supported(void);
 bool vgif_supported(void);
 bool lbrv_supported(void);
 bool tsc_scale_supported(void);
-- 
2.51.2.1041.gc1ab5b90ca-goog


