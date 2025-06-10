Return-Path: <kvm+bounces-48867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDAAAD434C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 130E67A9916
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA283264A7C;
	Tue, 10 Jun 2025 19:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lutOeWmo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA9264A9C
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585262; cv=none; b=N5JVeEPOQ59OMGCK6ScRC/fOHlE3vY14mMqbn/ChqdcLJDLixnyVkEzkatUkXKkzqvfnwoF+8JsGXKG82goTh6r0vhUw+Mccu/CPH8nqFX0wWjTNkydesHem0a6ATki3Scfrasl+QAklJvIhxIX/XhxwFeRLFTCFP0GHISgQQ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585262; c=relaxed/simple;
	bh=I0KuVIkg4UELeJPvfQwAcXwIS4FEY6Xa4KoHzVzUXak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L3CM88fdms96Bcyv49BieIxUoC6ZIQ9aEYAvibfsLIK0kTiVxe8FOUWynJuyGpzAvjfR0VLuw7OUlj/E1Mfys79MAVR8SQ26HCZhV8hGBO44hk/JY9J7VTdSRqLPx6/VX2v1/OE1WjnW3Uc7Fz9PwIkcdcZ+1uO5uOiGqPuKNxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lutOeWmo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31171a736b2so9795484a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585260; x=1750190060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ9GG0ILYoB1DzNtHAB3aI85GVPMr3czVhmSR4z5/qg=;
        b=lutOeWmoID0JnhdlYutw8tNGlgmvrUCvTvUDIpQT3dR2F/bAuUsfKNCq9a43B4QQ29
         dkUq0xb0w80g2pL6TRZUdbOCH6ojDoAYVkB6rjmnidaGx2NW3afMD9bc8NybSpvuj8Yt
         ymGIEaKrqyFbVcPB/FQ6XR8by9varAfqYxY9UtbPBVJV17THqqlDCZYwg1R2I6uNpTVl
         BSj1twyu3yLGComi+ybXmvigH1VJsH3qzTHNZPGXw2B3LcxjhCCT4uyql2K4U1RmZFAD
         wxI6cJCHFM1LhvxqYQ54kJlA82IlQELfrYxxhESuqYejUsciDo4ONGIjT1BdCdFXMrun
         49Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585260; x=1750190060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WZ9GG0ILYoB1DzNtHAB3aI85GVPMr3czVhmSR4z5/qg=;
        b=avxHOHyrj95IXG3tSE7WUgqO8hDoLzR42QLuPlRjdiYe3VRzK1O0HS+dNYlWG3hXpa
         z9JtNntzxLmPOdwzAPxJbbzDL1/1dX7C7bdNfYQwGHNf0Yef24ENKgFjA0+5ZcruJ3vt
         vy7ei8dPOy/IS0hDtbMopzC7kjjkmZhFwCMKs5K15mfxTNsLffMr2P/O9PTh+A4l4tWe
         azCWtt6O3SyuahB/ytekBm5zVTdKCwcEZGWl3EVmcqzhVeSBXa9e3Wa7IVoe90W/RfOP
         S+aTs2Jf8yD2XQk+tZF1r0klk3Q4jFpwAkbh9XcEmDbrrpqvGgRhvoNsxtuR4yoWMLDa
         /kBg==
X-Gm-Message-State: AOJu0YwO046MF4Mf5O3nPf9agiMahA1IOyC3RMp1dp2evKGVvpdkF5Xd
	LQDZrVmp9ingY9ZXDU4M3DxCDjf8EYFqFTpNulFb6KRvgBxvu3l81UoieqoDR4jIiKvIlggnmAt
	NQXPRTw==
X-Google-Smtp-Source: AGHT+IFaCFSvRfei1VDxH8+GnsJFjEbBSffqbPIM53RBdHp62QJPTrAsDTW1C7NousFpHXeGKn8lcKn1Jo8=
X-Received: from pjbsr16.prod.google.com ([2002:a17:90b:4e90:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc8:b0:311:e8cc:4248
 with SMTP id 98e67ed59e1d1-313af2929f1mr1106239a91.33.1749585260492; Tue, 10
 Jun 2025 12:54:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:02 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 01/14] x86: Encode X86_FEATURE_* definitions
 using a structure
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Encode X86_FEATURE_* macros using a new "struct x86_cpu_feature" instead
of manually packing the values into a u64.  Using a structure eliminates
open code shifts and masks, and is largely self-documenting.

Opportunistically replace single tabs with single spaces after #define
for relevant code; the existing code uses a mix of both, and a single
space is far more common.

Note, the code and naming scheme are stolen from KVM selftests.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 171 ++++++++++++++++++++++++--------------------
 1 file changed, 95 insertions(+), 76 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 5bc9ef89..d86fa0cf 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -6,6 +6,7 @@
 #include "msr.h"
 #include <bitops.h>
 #include <stdint.h>
+#include <util.h>
 
 #define CANONICAL_48_VAL 0xffffaaaaaaaaaaaaull
 #define CANONICAL_57_VAL 0xffaaaaaaaaaaaaaaull
@@ -232,100 +233,118 @@ static inline bool is_intel(void)
 	return strcmp((char *)name, "GenuineIntel") == 0;
 }
 
-#define	CPUID(a, b, c, d) ((((unsigned long long) a) << 32) | (b << 16) | \
-			  (c << 8) | d)
-
 /*
- * Each X86_FEATURE_XXX definition is 64-bit and contains the following
- * CPUID meta-data:
- *
- * 	[63:32] :  input value for EAX
- * 	[31:16] :  input value for ECX
- * 	[15:8]  :  output register
- * 	[7:0]   :  bit position in output register
+ * Pack the information into a 64-bit value so that each X86_FEATURE_XXX can be
+ * passed by value with no overhead.
  */
+struct x86_cpu_feature {
+	u32	function;
+	u16	index;
+	u8	reg;
+	u8	bit;
+};
+
+#define X86_CPU_FEATURE(fn, idx, gpr, __bit)					\
+({										\
+	struct x86_cpu_feature feature = {					\
+		.function = fn,							\
+		.index = idx,							\
+		.reg = gpr,							\
+		.bit = __bit,							\
+	};									\
+										\
+	static_assert((fn & 0xc0000000) == 0 ||					\
+		      (fn & 0xc0000000) == 0x40000000 ||			\
+		      (fn & 0xc0000000) == 0x80000000 ||			\
+		      (fn & 0xc0000000) == 0xc0000000);				\
+	static_assert(idx < BIT(sizeof(feature.index) * BITS_PER_BYTE));	\
+	feature;								\
+})
 
 /*
  * Basic Leafs, a.k.a. Intel defined
  */
-#define	X86_FEATURE_MWAIT		(CPUID(0x1, 0, ECX, 3))
-#define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
-#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
-#define	X86_FEATURE_PCID		(CPUID(0x1, 0, ECX, 17))
-#define X86_FEATURE_X2APIC		(CPUID(0x1, 0, ECX, 21))
-#define	X86_FEATURE_MOVBE		(CPUID(0x1, 0, ECX, 22))
-#define	X86_FEATURE_TSC_DEADLINE_TIMER	(CPUID(0x1, 0, ECX, 24))
-#define	X86_FEATURE_XSAVE		(CPUID(0x1, 0, ECX, 26))
-#define	X86_FEATURE_OSXSAVE		(CPUID(0x1, 0, ECX, 27))
-#define	X86_FEATURE_RDRAND		(CPUID(0x1, 0, ECX, 30))
-#define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
-#define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
-#define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
-#define	X86_FEATURE_DS			(CPUID(0x1, 0, EDX, 21))
-#define	X86_FEATURE_XMM			(CPUID(0x1, 0, EDX, 25))
-#define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
-#define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
-#define	X86_FEATURE_HLE			(CPUID(0x7, 0, EBX, 4))
-#define	X86_FEATURE_SMEP		(CPUID(0x7, 0, EBX, 7))
-#define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
-#define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
-#define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
-#define	X86_FEATURE_PCOMMIT		(CPUID(0x7, 0, EBX, 22))
-#define	X86_FEATURE_CLFLUSHOPT		(CPUID(0x7, 0, EBX, 23))
-#define	X86_FEATURE_CLWB		(CPUID(0x7, 0, EBX, 24))
-#define X86_FEATURE_INTEL_PT		(CPUID(0x7, 0, EBX, 25))
-#define	X86_FEATURE_UMIP		(CPUID(0x7, 0, ECX, 2))
-#define	X86_FEATURE_PKU			(CPUID(0x7, 0, ECX, 3))
-#define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
-#define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
-#define	X86_FEATURE_SHSTK		(CPUID(0x7, 0, ECX, 7))
-#define	X86_FEATURE_IBT			(CPUID(0x7, 0, EDX, 20))
-#define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
-#define	X86_FEATURE_FLUSH_L1D		(CPUID(0x7, 0, EDX, 28))
-#define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
-#define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
-#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
+#define X86_FEATURE_MWAIT		X86_CPU_FEATURE(0x1, 0, ECX, 3)
+#define X86_FEATURE_VMX			X86_CPU_FEATURE(0x1, 0, ECX, 5)
+#define X86_FEATURE_PDCM		X86_CPU_FEATURE(0x1, 0, ECX, 15)
+#define X86_FEATURE_PCID		X86_CPU_FEATURE(0x1, 0, ECX, 17)
+#define X86_FEATURE_X2APIC		X86_CPU_FEATURE(0x1, 0, ECX, 21)
+#define X86_FEATURE_MOVBE		X86_CPU_FEATURE(0x1, 0, ECX, 22)
+#define X86_FEATURE_TSC_DEADLINE_TIMER	X86_CPU_FEATURE(0x1, 0, ECX, 24)
+#define X86_FEATURE_XSAVE		X86_CPU_FEATURE(0x1, 0, ECX, 26)
+#define X86_FEATURE_OSXSAVE		X86_CPU_FEATURE(0x1, 0, ECX, 27)
+#define X86_FEATURE_RDRAND		X86_CPU_FEATURE(0x1, 0, ECX, 30)
+#define X86_FEATURE_MCE			X86_CPU_FEATURE(0x1, 0, EDX, 7)
+#define X86_FEATURE_APIC		X86_CPU_FEATURE(0x1, 0, EDX, 9)
+#define X86_FEATURE_CLFLUSH		X86_CPU_FEATURE(0x1, 0, EDX, 19)
+#define X86_FEATURE_DS			X86_CPU_FEATURE(0x1, 0, EDX, 21)
+#define X86_FEATURE_XMM			X86_CPU_FEATURE(0x1, 0, EDX, 25)
+#define X86_FEATURE_XMM2		X86_CPU_FEATURE(0x1, 0, EDX, 26)
+#define X86_FEATURE_TSC_ADJUST		X86_CPU_FEATURE(0x7, 0, EBX, 1)
+#define X86_FEATURE_HLE			X86_CPU_FEATURE(0x7, 0, EBX, 4)
+#define X86_FEATURE_SMEP		X86_CPU_FEATURE(0x7, 0, EBX, 7)
+#define X86_FEATURE_INVPCID		X86_CPU_FEATURE(0x7, 0, EBX, 10)
+#define X86_FEATURE_RTM			X86_CPU_FEATURE(0x7, 0, EBX, 11)
+#define X86_FEATURE_SMAP		X86_CPU_FEATURE(0x7, 0, EBX, 20)
+#define X86_FEATURE_PCOMMIT		X86_CPU_FEATURE(0x7, 0, EBX, 22)
+#define X86_FEATURE_CLFLUSHOPT		X86_CPU_FEATURE(0x7, 0, EBX, 23)
+#define X86_FEATURE_CLWB		X86_CPU_FEATURE(0x7, 0, EBX, 24)
+#define X86_FEATURE_INTEL_PT		X86_CPU_FEATURE(0x7, 0, EBX, 25)
+#define X86_FEATURE_UMIP		X86_CPU_FEATURE(0x7, 0, ECX, 2)
+#define X86_FEATURE_PKU			X86_CPU_FEATURE(0x7, 0, ECX, 3)
+#define X86_FEATURE_LA57		X86_CPU_FEATURE(0x7, 0, ECX, 16)
+#define X86_FEATURE_RDPID		X86_CPU_FEATURE(0x7, 0, ECX, 22)
+#define X86_FEATURE_SHSTK		X86_CPU_FEATURE(0x7, 0, ECX, 7)
+#define X86_FEATURE_IBT			X86_CPU_FEATURE(0x7, 0, EDX, 20)
+#define X86_FEATURE_SPEC_CTRL		X86_CPU_FEATURE(0x7, 0, EDX, 26)
+#define X86_FEATURE_FLUSH_L1D		X86_CPU_FEATURE(0x7, 0, EDX, 28)
+#define X86_FEATURE_ARCH_CAPABILITIES	X86_CPU_FEATURE(0x7, 0, EDX, 29)
+#define X86_FEATURE_PKS			X86_CPU_FEATURE(0x7, 0, ECX, 31)
+#define X86_FEATURE_LAM			X86_CPU_FEATURE(0x7, 1, EAX, 26)
 
 /*
  * KVM defined leafs
  */
-#define	KVM_FEATURE_ASYNC_PF		(CPUID(0x40000001, 0, EAX, 4))
-#define	KVM_FEATURE_ASYNC_PF_INT	(CPUID(0x40000001, 0, EAX, 14))
+#define KVM_FEATURE_ASYNC_PF		X86_CPU_FEATURE(0x40000001, 0, EAX, 4)
+#define KVM_FEATURE_ASYNC_PF_INT	X86_CPU_FEATURE(0x40000001, 0, EAX, 14)
 
 /*
  * Extended Leafs, a.k.a. AMD defined
  */
-#define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
-#define	X86_FEATURE_PERFCTR_CORE	(CPUID(0x80000001, 0, ECX, 23))
-#define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
-#define	X86_FEATURE_GBPAGES		(CPUID(0x80000001, 0, EDX, 26))
-#define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
-#define	X86_FEATURE_LM			(CPUID(0x80000001, 0, EDX, 29))
-#define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
-#define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
-#define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
-#define	X86_FEATURE_LBRV		(CPUID(0x8000000A, 0, EDX, 1))
-#define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
-#define X86_FEATURE_TSCRATEMSR		(CPUID(0x8000000A, 0, EDX, 4))
-#define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
-#define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
-#define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
-#define X86_FEATURE_VNMI		(CPUID(0x8000000A, 0, EDX, 25))
-#define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
+#define X86_FEATURE_SVM			X86_CPU_FEATURE(0x80000001, 0, ECX, 2)
+#define X86_FEATURE_PERFCTR_CORE	X86_CPU_FEATURE(0x80000001, 0, ECX, 23)
+#define X86_FEATURE_NX			X86_CPU_FEATURE(0x80000001, 0, EDX, 20)
+#define X86_FEATURE_GBPAGES		X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
+#define X86_FEATURE_RDTSCP		X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
+#define X86_FEATURE_LM			X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
+#define X86_FEATURE_RDPRU		X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
+#define X86_FEATURE_AMD_IBPB		X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
+#define X86_FEATURE_NPT			X86_CPU_FEATURE(0x8000000A, 0, EDX, 0)
+#define X86_FEATURE_LBRV		X86_CPU_FEATURE(0x8000000A, 0, EDX, 1)
+#define X86_FEATURE_NRIPS		X86_CPU_FEATURE(0x8000000A, 0, EDX, 3)
+#define X86_FEATURE_TSCRATEMSR		X86_CPU_FEATURE(0x8000000A, 0, EDX, 4)
+#define X86_FEATURE_PAUSEFILTER		X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
+#define X86_FEATURE_PFTHRESHOLD		X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
+#define X86_FEATURE_VGIF		X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
+#define X86_FEATURE_VNMI		X86_CPU_FEATURE(0x8000000A, 0, EDX, 25)
+#define X86_FEATURE_AMD_PMU_V2		X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
 
-static inline bool this_cpu_has(u64 feature)
+static inline u32 __this_cpu_has(u32 function, u32 index, u8 reg, u8 lo, u8 hi)
 {
-	u32 input_eax = feature >> 32;
-	u32 input_ecx = (feature >> 16) & 0xffff;
-	u32 output_reg = (feature >> 8) & 0xff;
-	u8 bit = feature & 0xff;
-	struct cpuid c;
-	u32 *tmp;
+	union {
+		struct cpuid cpuid;
+		u32 gprs[4];
+	} c;
 
-	c = cpuid_indexed(input_eax, input_ecx);
-	tmp = (u32 *)&c;
+	c.cpuid = cpuid_indexed(function, index);
 
-	return ((*(tmp + (output_reg % 32))) & (1 << bit));
+	return (c.gprs[reg] & GENMASK(hi, lo)) >> lo;
+}
+
+static inline bool this_cpu_has(struct x86_cpu_feature feature)
+{
+	return __this_cpu_has(feature.function, feature.index,
+			      feature.reg, feature.bit, feature.bit);
 }
 
 struct far_pointer32 {
-- 
2.50.0.rc0.642.g800a2b2222-goog


