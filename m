Return-Path: <kvm+bounces-48877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B46E7AD4356
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 762D93A5026
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460B1266EE7;
	Tue, 10 Jun 2025 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HRZhGZJa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB633266B5D
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585279; cv=none; b=gKFSHr5YSmZ1X+/VuKcuiOVb8Fi7279PjNBjDjvbr37O0RIfruenMuROJXY7EnUT2AS2oVyXdypSfM/ZCJdy84+WEOQ56Q/E7b87mwSd0yvoUZnSR8SBedeFwodNWbUax6m9nP5gcONknJWbdHONlh3ZQE7cPjEZsoGRg4l7AjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585279; c=relaxed/simple;
	bh=SAoN3nHkBcP3z2r1cvu2GV7M/BMH4QdsxPnrsxLz/fA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UnJZhFgHvlbyrNHrF8qRJzXrAzaVcoU5mSpVAKV70+lHdlprEs05rHQEpviswn8X9hOKvHsqvN/wAId/LOvbws3QOWtfOauCoGbDcrZIXFdu+fx9R6byIPuWE+Zwu97yBgxVoU2Z6YO/HYwqBpBFWh3XejvgTd+knc8Bd6CA0hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HRZhGZJa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e1d70d67so52632175ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585277; x=1750190077; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JXaNz8Gs1pIi8xoWQ14AMpw8KRupn017zA/xscXv24Q=;
        b=HRZhGZJatN4tZ5wiFC9yk6Eh6+n/gW1xZeaM+3noDYYit8HLyPmahMB6EW3q7rhkwF
         VQUV32hY5eUp+y7SiFbKTOQN0hbF3JzmadJof1jTyHPiWg5SHmmHMcCcg9bQI1W1g9Mp
         v7ZhfZCuknTSRKR/1aW4YsUpZAFW5AmCsT62u2hKXo7TiQHb9cP0QLkz/YlTSvikFZdo
         WBuW32uAz7p2GLSAFhnGNOOVFc5UwAgCpk3Pg1Hj/OSE8GyEQojWf+yfO18G0BKRhRZm
         Xu47D3gVy1/Oz9EB/zZvF9VSIWk2U1tPrHPOIWutWtz12H30TYB2PQI0cIpbWN5Ifq35
         d8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585277; x=1750190077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXaNz8Gs1pIi8xoWQ14AMpw8KRupn017zA/xscXv24Q=;
        b=mbRGMu+I/ULXmmEjSZwgcZMsOQMRtl7NKp8pRcJfbVo4NfA/TmteAB08ceGw3y/qoT
         BHqS4GFELLmSf/Sdoal2zM/CWD1S08G2RRGZIhXZm3TmSZPTmQbfmFgNgmZKXeQWb5B3
         wUXSIohOL4VLolaa/O8vrVucnFBoP4m4bUTDJlfJnbB69vsHXHhaPMiLfWiAkVmtV53O
         QqTFee18cc+GPDe9rO7wFSNOWFsog519GW4mAIsLVysQTOcXN+3aEXiM/C45ZKDXXA5R
         T+XBQjyAjjYejWNT/q3qBWkbecexPCDAEeBN/mZZf13v9cwHpwJ6SHS66pBe1W6PPRtW
         E3mQ==
X-Gm-Message-State: AOJu0Yxk0CaL8oGSHDw8ZYrNKSewXhFWLAQMwDEofP8ffMBqWVe7Ylqh
	eR0qcduqjT1dPKz0tuPnK/+ADFG5lCkZBuJVWZg12rlNx40fmaP56pMc+IOTe2WRvG2yprhHIGt
	FZ7e6MQ==
X-Google-Smtp-Source: AGHT+IGGY1rmoqHkD66UYmwSXUq53TqirC++C/Px5yHZFpTGm7WaY+EUJA5UAefjvuuiNL5/OhmcbNDZhDo=
X-Received: from pga21.prod.google.com ([2002:a05:6a02:4f95:b0:b2c:3afe:6ece])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec8:b0:220:d257:cdbd
 with SMTP id d9443c01a7336-23641b26273mr7953055ad.48.1749585277240; Tue, 10
 Jun 2025 12:54:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:12 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-12-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 11/14] x86/sev: Define and use X86_FEATURE_*
 flags for CPUID 0x8000001F
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Define proper X86_FEATURE_* flags for CPUID 0x8000001F, and use them
instead of open coding equivalent checks in amd_sev_{,es_}enabled().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/amd_sev.c   | 32 +++++---------------------------
 lib/x86/amd_sev.h   |  3 ---
 lib/x86/processor.h |  9 +++++++++
 3 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 6c0a66ac..b7cefd0f 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -17,31 +17,15 @@ static unsigned short amd_sev_c_bit_pos;
 
 bool amd_sev_enabled(void)
 {
-	struct cpuid cpuid_out;
 	static bool sev_enabled;
 	static bool initialized = false;
 
 	/* Check CPUID and MSR for SEV status and store it for future function calls. */
 	if (!initialized) {
-		sev_enabled = false;
 		initialized = true;
 
-		/* Test if we can query SEV features */
-		cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
-		if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
-			return sev_enabled;
-		}
-
-		/* Test if SEV is supported */
-		cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
-		if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
-			return sev_enabled;
-		}
-
-		/* Test if SEV is enabled */
-		if (rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK) {
-			sev_enabled = true;
-		}
+		sev_enabled = this_cpu_has(X86_FEATURE_SEV) &&
+			      rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK;
 	}
 
 	return sev_enabled;
@@ -72,17 +56,11 @@ bool amd_sev_es_enabled(void)
 	static bool initialized = false;
 
 	if (!initialized) {
-		sev_es_enabled = false;
 		initialized = true;
 
-		if (!amd_sev_enabled()) {
-			return sev_es_enabled;
-		}
-
-		/* Test if SEV-ES is enabled */
-		if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
-			sev_es_enabled = true;
-		}
+		sev_es_enabled = amd_sev_enabled() &&
+				 this_cpu_has(X86_FEATURE_SEV_ES) &&
+				 rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK;
 	}
 
 	return sev_es_enabled;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index ca7216d4..defcda75 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -21,12 +21,9 @@
 
 /*
  * AMD Programmer's Manual Volume 3
- *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
  *   - Section "Function 8000_001Fh - Encrypted Memory Capabilities"
  */
-#define CPUID_FN_LARGEST_EXT_FUNC_NUM 0x80000000
 #define CPUID_FN_ENCRYPT_MEM_CAPAB    0x8000001f
-#define SEV_SUPPORT_MASK              0b10
 
 /*
  * AMD Programmer's Manual Volume 2
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index e3b3df89..1adfd027 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -320,6 +320,15 @@ struct x86_cpu_feature {
 #define X86_FEATURE_PFTHRESHOLD		X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
 #define X86_FEATURE_VGIF		X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
 #define X86_FEATURE_VNMI		X86_CPU_FEATURE(0x8000000A, 0, EDX, 25)
+#define X86_FEATURE_SME			X86_CPU_FEATURE(0x8000001F, 0, EAX,  0)
+#define X86_FEATURE_SEV			X86_CPU_FEATURE(0x8000001F, 0, EAX,  1)
+#define X86_FEATURE_VM_PAGE_FLUSH	X86_CPU_FEATURE(0x8000001F, 0, EAX,  2)
+#define X86_FEATURE_SEV_ES		X86_CPU_FEATURE(0x8000001F, 0, EAX,  3)
+#define X86_FEATURE_SEV_SNP		X86_CPU_FEATURE(0x8000001F, 0, EAX,  4)
+#define X86_FEATURE_V_TSC_AUX		X86_CPU_FEATURE(0x8000001F, 0, EAX,  9)
+#define X86_FEATURE_SME_COHERENT	X86_CPU_FEATURE(0x8000001F, 0, EAX, 10)
+#define X86_FEATURE_DEBUG_SWAP		X86_CPU_FEATURE(0x8000001F, 0, EAX, 14)
+#define X86_FEATURE_SVSM		X86_CPU_FEATURE(0x8000001F, 0, EAX, 28)
 #define X86_FEATURE_AMD_PMU_V2		X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
 
 /*
-- 
2.50.0.rc0.642.g800a2b2222-goog


