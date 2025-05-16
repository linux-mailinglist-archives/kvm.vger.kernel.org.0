Return-Path: <kvm+bounces-46885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BAB6ABA531
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56BB4A7209
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18E1281524;
	Fri, 16 May 2025 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fg3daL2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81601281355
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431013; cv=none; b=ca0ji41LoccBfChkMPsG7yQk0VkDE8/94au5MTXUSzYIIfKBejcSOQ4mxzIc2Ae1pa78CCDLr7n4SOfNrow1blNLkcw+lfUbOWhmxRptcuyk+/whWxdyO5tR8oqllLpUbVGNpZ9JYqN+TJrXfKOjH5b1J9ccNTpNn3uBmyQeG2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431013; c=relaxed/simple;
	bh=Dc2CblWGVBVuskP0Q7s2EWDSw3Z8JzeBhNUqDFQE4jw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d1OWdm+OpOPVLXtiUjI2bguzkW9Wuc5LEbqZ/IvAvPVNX0uoT1C80i/gv/hRowDLCHa8UpTAp2yMiGhrFzM8v0vfvZW6j1pCLDfJhIVgSrItoFXI4g8ieARo7rs1U1RMrtAkx0ITJ6AVsYFg3ERCmhKHDc2SGkBtJh+PdQobpbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fg3daL2E; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00e4358a34so1538621a12.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431011; x=1748035811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XXHpJVmCrSZ9FxACIyOchlyq3sCWnKzqZMy4NYSrXEo=;
        b=Fg3daL2EmSzDtxi1iGsTR2AfLI12QOImjoKbHZG9XV2WKWh115YQVmvyyEW2UGZEiU
         HdwYR0JnJH2PYG6Np3DSuHDmvAOoHk7hJq1OPMjKkzqNgkJ/kO1Mb9Ix+gR2iLjzIPtu
         zzRCd00xbIfMfL7S1/Xe97A46CJ5ThX7CllQf3NVCWjERV0p5TRgUI/lBIfbajsDq0CE
         51qhaFsCtYq0p7GW62T1Sbc7GnsNW9UPIT2qbKEKo/8E2qdeBardjF/pXSCorgvku3kx
         IGRYBIjEyBbvLEQ60zw+5Ioq+4a9hjRSUpzSjsw+QYfkiEpDfgAianTrR5wCqvaX+dRr
         Yv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431011; x=1748035811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXHpJVmCrSZ9FxACIyOchlyq3sCWnKzqZMy4NYSrXEo=;
        b=mzSxY7bDVx+t8wHJE5GCujUditiEYWSaxuBlO1wkByUceiJeXyeMfAytkrZPr56SXi
         pMMgJaCP56YraROi18Si/uwSyjZYm3gSQtUT4fO+Oka6vn9QcKG4UFrxvsdj37O9useN
         wa21RDsai0grdOv/6Fw7y8YnLdZapP+o8oxn1R8VEE1wurvXZz+W0MM8ITzk+MD4jY+t
         BxRYGmjkcmxRCRePiCOv0vtw0JSFiYOhUHd2PQaqdVgRGDdu/3sJWb2ce8ORsku2uuM2
         HO4h/c6S5NmX4Foe+D7b/G5HbY0E5MuQZJlleFqeEAAnC0Ww9x+iD67QbNsErFCHyFOa
         OpoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWqh6blvD+y+1Vqu713zsxpaaIjqdpeyRxHttB5m/tdMtrRBKL5MIu7uSSxZMOk+jUYkI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH0Geu5zFoY6pvGgBYPv3Ssv9EM0tFF3o9GcUMagKzz05r791Z
	3lShHtKe8OFCpbA4VoUoNodZzZTy3C+dM/xEKvV/RbIlRfnR4bZEZtqztPQ3HlBoeDBbMbYx86I
	PZ12pDg==
X-Google-Smtp-Source: AGHT+IEeTLUSaLphMvwH3ICiNx6NcrDzw6LvXIQfL11JWb1+SBH0kSl8HCWC4BRH4JIZt1VlaecUPLeiPHQ=
X-Received: from pjb12.prod.google.com ([2002:a17:90b:2f0c:b0:30a:a05c:6e7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2644:b0:309:e195:59d4
 with SMTP id 98e67ed59e1d1-30e7d52b166mr9407454a91.12.1747431010844; Fri, 16
 May 2025 14:30:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:29 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-5-seanjc@google.com>
Subject: [PATCH v2 4/8] x86, lib: Add WBNOINVD helper functions
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kevin Loughlin <kevinloughlin@google.com>, 
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kevin Loughlin <kevinloughlin@google.com>

In line with WBINVD usage, add WBONINVD helper functions.  Fall back to
WBINVD (via alternative()) if WBNOINVD isn't supported, as WBINVD provides
a superset of functionality, just more slowly.

Note, alternative() ensures compatibility with early boot code as needed.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
[sean: massage changelog and comments, use ASM_WBNOINVD and _ASM_BYTES]
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/smp.h           |  6 ++++++
 arch/x86/include/asm/special_insns.h | 19 ++++++++++++++++++-
 arch/x86/lib/cache-smp.c             | 11 +++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 028f126018c9..e08f1ae25401 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -113,6 +113,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 void wbinvd_on_all_cpus(void);
+void wbnoinvd_on_all_cpus(void);
 
 void smp_kick_mwait_play_dead(void);
 void __noreturn mwait_play_dead(unsigned int eax_hint);
@@ -153,6 +154,11 @@ static inline void wbinvd_on_all_cpus(void)
 	wbinvd();
 }
 
+static inline void wbnoinvd_on_all_cpus(void)
+{
+	wbnoinvd();
+}
+
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
 	return (struct cpumask *)cpumask_of(0);
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 6266d6b9e0b8..46b3961e3e4b 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -117,7 +117,24 @@ static inline void wrpkru(u32 pkru)
 
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
+ * Cheaper version of wbinvd(). Call when caches need to be written back but
+ * not invalidated.
+ */
+static __always_inline void wbnoinvd(void)
+{
+	/*
+	 * If WBNOINVD is unavailable, fall back to the compatible but
+	 * more destructive WBINVD (which still writes the caches back
+	 * but also invalidates them).
+	 */
+	alternative("wbinvd", ASM_WBNOINVD, X86_FEATURE_WBNOINVD);
 }
 
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
-- 
2.49.0.1112.g889b7c5bd8-goog


