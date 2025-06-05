Return-Path: <kvm+bounces-48600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC2DACF7ED
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9695178930
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7824527BF6F;
	Thu,  5 Jun 2025 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TOCvXwUr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CCA1C84CB
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151610; cv=none; b=lH0oSS3o2h1sWOTNa2L3przuX6BjWpd1TzdomCfwl9ZkHOqtNk4bSQhYxmXlFtreAya+0A8EXaKfI9+/wU/8xpUNRFAgZxkX6NT+IzcoXzNoje7vU18Mr4Jyv+TwySbRUDa2Uv+bYKV5t3ozWR5gcffDfbUmSwCdCrP+mpd4+bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151610; c=relaxed/simple;
	bh=lFNL2XLMRLjounJMEA7D2swrwzNKWQ0vrqbYpgaXa1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dk+gZqWPUE6UEmL5p2GbBsqsbXCXQzDptZ1/TGrV8HywdtoOJYz1WxF2qToG5h7hEX4MddGkIz69jX1QICmZ5G8FA+CVWcIJYQtecCBc5L6oilfIkLj3UDH0NwPyskX3TL0UHtZwe7ZDR48Lbzm09rNxpc5mIp6NEq9I0evL1yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TOCvXwUr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2350804a43eso18428895ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151608; x=1749756408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RhI1A8/9NaPxjVZ6LaRvLIcKkRdN+UrlnUMxkn6SJf4=;
        b=TOCvXwUrn4ioUgyoMuDus3fAKz7rd6AieoGPvas+CUOdPIkup6ZYeRLipKQVJ8AG8z
         0cKI1pemjMrJtpy+rI4uJnJfQqN17H8+4dCoxoXqZ/zuG8BqATHJUYHTO59nBO2/Vntn
         yfdxtekw55i3nS6hgHIbUj8C0K/uX93QYlYjqQNK+27nhBUVVryzt8l+P3g5MSj2Oz6t
         V6qbn70i2r1hy13F7jLeXPlgEWkgoc2mrGl9Q+kCjexfwVQTUUcoGjNoVED/Cf3jbriE
         +GeXpjhIWiuPcTra4nb04PmNS/PR+iYAGWPzknKkpAwLJ4IdXqczCkFVhjLylNKmTiCJ
         ucPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151608; x=1749756408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RhI1A8/9NaPxjVZ6LaRvLIcKkRdN+UrlnUMxkn6SJf4=;
        b=e7DVQekppX1oNcko/g6oJJQPWyYbT8gMSAcIBRtxfK/pW3fWA/92kUFxooj69wy1+S
         6GJRtmQxPkH6Ig77sLLbjei/OOTSH7t4uxFMXgq3P2OOJTosHazte0pVc6qW/f2uuEGE
         x94lSLDvJv+zfQamsPXOuGC58VSeTHRNLkn1wTAJwEK2qa+3fzE+BPhYMIn7jLjQKHZG
         HLInywpA70St9lei7u0rnyRKF7wbH5Ufl9EBR9M5mgst0J1Rl6kkDkbWowvWmOsI+AYJ
         qSIVKz8YbRNCRArJkNxahy7LsbzhpYLXM3SoDr62795Ql27Hj+I1rV5vAg/GrrNYNRGN
         o4TA==
X-Gm-Message-State: AOJu0Yzfs2Z8P1Gl/tpsqepo/XYu0e3eNlO6wcgetpqEvADVTEsxOiTj
	flBH65CRyVDph05jKqu5cuMd0tH501GWe+FNJEJ4HnWOikAQdZYWKymXRoRSeSw+cWeJhqW9NRG
	MlqMDmQ==
X-Google-Smtp-Source: AGHT+IFef4O1EPvxRllJlUZQLbpCDQEum5hfxBAVYSrfGsdnq9aKNM/UoYEx8WNeuSdFpNYrxKtCNo6TtpA=
X-Received: from plpm17.prod.google.com ([2002:a17:903:3df1:b0:234:d2a4:ddf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce82:b0:22e:3e0e:5945
 with SMTP id d9443c01a7336-23601deaf5cmr6784055ad.50.1749151608089; Thu, 05
 Jun 2025 12:26:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:26:42 -0700
In-Reply-To: <20250605192643.533502-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192643.533502-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192643.533502-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] x86/msr: Add a testcase to verify
 SPEC_CTRL exists (or not) as expected
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Verify that SPEC_CTRL can be read when it should exist, #GPs on all reads
and writes does not exist, and that various bits can be set when they're
supported.

Opportunistically define more AMD mitigation features.

Cc: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h       |  8 ++++++--
 lib/x86/processor.h |  9 +++++++--
 x86/msr.c           | 31 +++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index ccfd6bdd..cc4cb855 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -32,8 +32,12 @@
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
 /* Intel MSRs. Some also available on other CPUs */
-#define MSR_IA32_SPEC_CTRL              0x00000048
-#define MSR_IA32_PRED_CMD               0x00000049
+#define MSR_IA32_SPEC_CTRL		0x00000048
+#define SPEC_CTRL_IBRS			BIT(0)
+#define SPEC_CTRL_STIBP			BIT(1)
+#define SPEC_CTRL_SSBD			BIT(2)
+
+#define MSR_IA32_PRED_CMD		0x00000049
 #define PRED_CMD_IBPB			BIT(0)
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9e3659d4..cbfaa018 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -288,13 +288,13 @@ struct x86_cpu_feature {
 #define	X86_FEATURE_LA57		X86_CPU_FEATURE(0x7, 0, ECX, 16)
 #define	X86_FEATURE_RDPID		X86_CPU_FEATURE(0x7, 0, ECX, 22)
 #define	X86_FEATURE_SHSTK		X86_CPU_FEATURE(0x7, 0, ECX, 7)
+#define	X86_FEATURE_PKS			X86_CPU_FEATURE(0x7, 0, ECX, 31)
 #define	X86_FEATURE_IBT			X86_CPU_FEATURE(0x7, 0, EDX, 20)
 #define	X86_FEATURE_SPEC_CTRL		X86_CPU_FEATURE(0x7, 0, EDX, 26)
 #define	X86_FEATURE_FLUSH_L1D		X86_CPU_FEATURE(0x7, 0, EDX, 28)
 #define	X86_FEATURE_ARCH_CAPABILITIES	X86_CPU_FEATURE(0x7, 0, EDX, 29)
-#define	X86_FEATURE_PKS			X86_CPU_FEATURE(0x7, 0, ECX, 31)
+#define X86_FEATURE_SSBD		X86_CPU_FEATURE(0x7, 0, EDX, 31)
 #define	X86_FEATURE_LAM			X86_CPU_FEATURE(0x7, 1, EAX, 26)
-
 /*
  * KVM defined leafs
  */
@@ -312,6 +312,11 @@ struct x86_cpu_feature {
 #define	X86_FEATURE_LM			X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
 #define	X86_FEATURE_RDPRU		X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
 #define	X86_FEATURE_AMD_IBPB		X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
+#define	X86_FEATURE_AMD_IBRS		X86_CPU_FEATURE(0x80000008, 0, EBX, 14)
+#define X86_FEATURE_AMD_STIBP		X86_CPU_FEATURE(0x80000008, 0, EBX, 15)
+#define X86_FEATURE_AMD_STIBP_ALWAYS_ON	X86_CPU_FEATURE(0x80000008, 0, EBX, 17)
+#define X86_FEATURE_AMD_IBRS_SAME_MODE	X86_CPU_FEATURE(0x80000008, 0, EBX, 19)
+#define X86_FEATURE_AMD_SSBD		X86_CPU_FEATURE(0x80000008, 0, EBX, 24)
 #define	X86_FEATURE_NPT			X86_CPU_FEATURE(0x8000000A, 0, EDX, 0)
 #define	X86_FEATURE_LBRV		X86_CPU_FEATURE(0x8000000A, 0, EDX, 1)
 #define	X86_FEATURE_NRIPS		X86_CPU_FEATURE(0x8000000A, 0, EDX, 3)
diff --git a/x86/msr.c b/x86/msr.c
index ac12d127..ca265fac 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -290,10 +290,37 @@ static void test_x2apic_msrs(void)
 	__test_x2apic_msrs(true);
 }
 
-static void test_cmd_msrs(void)
+static void test_mitigation_msrs(void)
 {
+	u64 spec_ctrl_bits = 0, val;
 	int i;
 
+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) || this_cpu_has(X86_FEATURE_AMD_IBRS))
+		spec_ctrl_bits |= SPEC_CTRL_IBRS;
+
+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) || this_cpu_has(X86_FEATURE_AMD_STIBP))
+		spec_ctrl_bits |= SPEC_CTRL_STIBP;
+
+	if (this_cpu_has(X86_FEATURE_SSBD) || this_cpu_has(X86_FEATURE_AMD_SSBD))
+		spec_ctrl_bits |= SPEC_CTRL_SSBD;
+
+	if (spec_ctrl_bits) {
+		for (val = 0; val <= spec_ctrl_bits; val++) {
+			/*
+			 * Test only values that are guaranteed not to fault,
+			 * virtualization of SPEC_CTRL has myriad holes that
+			 * won't be ever closed.
+			 */
+			if ((val & spec_ctrl_bits) != val)
+				continue;
+
+			test_msr_rw(MSR_IA32_SPEC_CTRL, "SPEC_CTRL", val);
+		}
+	} else {
+		test_rdmsr_fault(MSR_IA32_SPEC_CTRL, "SPEC_CTRL");
+		test_wrmsr_fault(MSR_IA32_SPEC_CTRL, "SPEC_CTRL", 0);
+	}
+
 	test_rdmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD");
 	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
 	    this_cpu_has(X86_FEATURE_AMD_IBPB) ||
@@ -332,7 +359,7 @@ int main(int ac, char **av)
 		test_misc_msrs();
 		test_mce_msrs();
 		test_x2apic_msrs();
-		test_cmd_msrs();
+		test_mitigation_msrs();
 	}
 
 	return report_summary();
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


