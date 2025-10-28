Return-Path: <kvm+bounces-61354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5CDC17294
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F24CE353BE5
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25DD358D28;
	Tue, 28 Oct 2025 22:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kOq/QL92"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FD13587A3
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689570; cv=none; b=EEwXUgKVIkmwQqVoNxjkm+I6th5i0pRSHvd1VV1eR2GrVHexEo+JUsWAICi+ccdHyij8GPgDWyIooJc4toT3nPGs0crXNJexx2fleOLCzXP0WpqwCmJW5EaZgf3N0fVjulNKtmmZYZ80jcACLp0MMQz8koVgEfOHLJRq1rf+WGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689570; c=relaxed/simple;
	bh=prKO2rIazuH1Qiy1nQlxsof9l3kB4sniNcFZXUE3EVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRhjJZaGxmgghy/26IW7rpfpWHVHQwso3CWhua1SnNuoPDQcxEhQCQh7WgF/akt/S614ydilHZnut705kXnME4HCcN/ofm2rLbD22GhMKL21UgGMtxdW6/5464R1P6L9EBihkZKPjwVkTdvP0EMpHpO/PjQThBTdXtTz8EfHfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kOq/QL92; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761689566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZMmiyueSg6H0q/S7Z8qr8ZAZHcjubOiIA7bS8SwUfU=;
	b=kOq/QL92PuWiHebRvJyCyZ6iZey9gA8j0CVB6BHPsPPeSWEYQUZswsywvKfhB2PT72HPst
	ZJLvtVTCKaP1O3AVMbvdiS6WtVF9PM9fVAN9ADMSpaKG7xJhQqrSlHpm0239+p47IfPIZ3
	4fgzx6zCAF8zbNUONH18vMF6xFLNNoA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests v2 4/8] x86/svm: Add FEP helpers for SVM tests
Date: Tue, 28 Oct 2025 22:12:09 +0000
Message-ID: <20251028221213.1937120-5-yosry.ahmed@linux.dev>
In-Reply-To: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
References: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
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
2.51.1.851.g4ebd6896fd-goog


