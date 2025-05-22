Return-Path: <kvm+bounces-47425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49889AC1823
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 814FE17DFA1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267302D1920;
	Thu, 22 May 2025 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p2QRDkdP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3102C271A86
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957069; cv=none; b=FymbTokQgDQwTlj3cE3aanccXmYkkyVINd57hRZEElQpwqZ5rw/5N53a7TV/Di9dRXSLQqvVLeawTEZWZ9eke1lNDikZqT4XWs62jVQybFURMm+Cn8eWLy4skwEYQ+1lQvvyDNKxRjXKbkJu7gDBeUD6U01V6BKjo1yrWCEUcjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957069; c=relaxed/simple;
	bh=eNvNDKoeNT6JOGIaV2NQv10Yua3xIPhgPTUOOfxorRI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Czemr8DYj413yJZ8AD9ih39rCRZwjlWjJ+W4nk7PR2QXZczfkSeBXt74OTgcbkyMwf+F34DjV+m/ygVeGyln9B51dWOcj0hSG9ZymWpnZvns+lA4MQtnf3SVAmjUwIqiTV5j60V7HrlRWdD6CBCtUfqheL0BYFw09GsJPvTQPWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p2QRDkdP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e8425926eso9442604a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957066; x=1748561866; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yvw3d371CPvGh9bouzujsmuFtM9ubEnaNp4RJbDym00=;
        b=p2QRDkdPxTFxtS2IDSU9ohvjBa3+sgYoKfNbDIrC/8+OpDPLJHkl+Fda2CaXLicTWg
         wA/yATTXCMV2eAQ5zS5UAEWHxEaqNgrUnG9gV1J/cM6+JV/FDUYmbgcceCgYO9ulJ4OC
         usNe8O48DT5VWyplw9vxjKwdot9kuwaFCsravzXqbisb77loAN3DDc6FrOS+qOIS+ARW
         6fHx7zI2IGRj1YVvSLeeDz1J/k9SmbuJ8xTPATlyl24T9zzMgxCukm9nAUOT91BUNPgS
         wjGbuuo3yW0XAbqFT1TyjQY44ljuETgrMyNqzrUElR2Csh3BydRgJBAO8aY8S4z9Ms9O
         yIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957066; x=1748561866;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yvw3d371CPvGh9bouzujsmuFtM9ubEnaNp4RJbDym00=;
        b=CVElMIFCuYUIg8RdeuYBaf5sRvGYbo+7/xRMO4lFpNU9orUqwa6sWSqJ92JfczSZ3L
         rFIu2MqweKB3rSecAn6OWChSV/MRH2Kw3QaA2EsjGoDhYt3KPdQf8Ua/RWUkLUdPRbXo
         jBqiRryVGaVPerI0oaw/8t7+x57EBrpXP29hseaxeDKhj5UBnowgiGDqwQAEdR8zrr15
         Hz/NWRtxOI7xQMdTE4AXhRapI6tcOaEcwc1d8VAchu6GCdSk/jAvV/JqcPPWpJWut9mZ
         9cxMz9HQuplwTVtJDAlODuzAgLAOYpcgbQSd99BbVtBQwRJN4tjr95QDE/4XOTTy4ev/
         54gg==
X-Forwarded-Encrypted: i=1; AJvYcCUPJtBDdnDBgG/jNI9y27KS1kuYfWAPJs6iw4ys23+HyWi2NhvYqn7WQJKd88lFaweg+lM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8jDoGGJ0Hsu2PY4YrJ/zhFG6IMRFJ0IOj+XmNCj49xIEnaCMp
	H8hFtMfhDO1QM2X2Cs4PANmyno+NTg0rSnBDp+FFRi1gq4Y+Nt1/dN4CckMWO6OH/9k989U4Pu6
	GYcOe9w==
X-Google-Smtp-Source: AGHT+IGuDScws7kpg/friq+b634gqXx+BwD3tk0suRuGvu3JjtUiXgJphwYoBlYj4PDUcCLFI+H5bjTOQbU=
X-Received: from pjbsp5.prod.google.com ([2002:a17:90b:52c5:b0:2ff:5516:6add])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d44:b0:30e:7d09:2a7
 with SMTP id 98e67ed59e1d1-30e83107ed7mr42352428a91.14.1747957066514; Thu, 22
 May 2025 16:37:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:27 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-4-seanjc@google.com>
Subject: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Kevin Loughlin <kevinloughlin@google.com>

In line with WBINVD usage, add WBONINVD helper functions.  Explicitly fall
back to WBINVD (via alternative()) if WBNOINVD isn't supported even though
the instruction itself is backwards compatible (WBNOINVD is WBINVD with an
ignored REP prefix), so that disabling X86_FEATURE_WBNOINVD behaves as one
would expect, e.g. in case there's a hardware issue that affects WBNOINVD.

Opportunsitically add comments explaining the architectural behavior of
WBINVD and WBNOINVD, and to provide hints and pointers to uarch-specific
behavior.

Note, alternative() ensures compatibility with early boot code as needed.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/smp.h           |  6 ++++++
 arch/x86/include/asm/special_insns.h | 32 +++++++++++++++++++++++++++-
 arch/x86/lib/cache-smp.c             | 11 ++++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 028f126018c9..e08f1ae25401 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -113,6 +113,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 void wbinvd_on_all_cpus(void);
+void wbnoinvd_on_all_cpus(void);
=20
 void smp_kick_mwait_play_dead(void);
 void __noreturn mwait_play_dead(unsigned int eax_hint);
@@ -153,6 +154,11 @@ static inline void wbinvd_on_all_cpus(void)
 	wbinvd();
 }
=20
+static inline void wbnoinvd_on_all_cpus(void)
+{
+	wbnoinvd();
+}
+
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
 	return (struct cpumask *)cpumask_of(0);
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/sp=
ecial_insns.h
index 6266d6b9e0b8..f2240c4ac0ea 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -115,9 +115,39 @@ static inline void wrpkru(u32 pkru)
 }
 #endif
=20
+/*
+ * Write back all modified lines in all levels of cache associated with th=
is
+ * logical processor to main memory, and then invalidate all caches.  Depe=
nding
+ * on the micro-architecture, WBINVD (and WBNOINVD below) may or may not a=
ffect
+ * lower level caches associated with another logical processor that share=
s any
+ * level of this processor=E2=80=99s cache hierarchy.
+ *
+ * Note, AMD CPUs enumerate the behavior or WB{NO}{INVD} with respect to o=
ther
+ * logical, non-originating processors in CPUID 0x8000001D.EAX[N:0].
+ */
 static __always_inline void wbinvd(void)
 {
-	asm volatile("wbinvd": : :"memory");
+	asm volatile("wbinvd" : : : "memory");
+}
+
+/* Instruction encoding provided for binutils backwards compatibility. */
+#define ASM_WBNOINVD _ASM_BYTES(0xf3,0x0f,0x09)
+
+/*
+ * Write back all modified lines in all levels of cache associated with th=
is
+ * logical processor to main memory, but do NOT explicitly invalidate cach=
es,
+ * i.e. leave all/most cache lines in the hierarchy in non-modified state.
+ */
+static __always_inline void wbnoinvd(void)
+{
+	/*
+	 * Explicitly encode WBINVD if X86_FEATURE_WBNOINVD is unavailable even
+	 * though WBNOINVD is backwards compatible (it's simply WBINVD with an
+	 * ignored REP prefix), to guarantee that WBNOINVD isn't used if it
+	 * needs to be avoided for any reason.  For all supported usage in the
+	 * kernel, WBINVD is functionally a superset of WBNOINVD.
+	 */
+	alternative("wbinvd", ASM_WBNOINVD, X86_FEATURE_WBNOINVD);
 }
=20
 static inline unsigned long __read_cr4(void)
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 079c3f3cd32c..1789db5d8825 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -19,3 +19,14 @@ void wbinvd_on_all_cpus(void)
 	on_each_cpu(__wbinvd, NULL, 1);
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
+
+static void __wbnoinvd(void *dummy)
+{
+	wbnoinvd();
+}
+
+void wbnoinvd_on_all_cpus(void)
+{
+	on_each_cpu(__wbnoinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
--=20
2.49.0.1151.ga128411c76-goog


