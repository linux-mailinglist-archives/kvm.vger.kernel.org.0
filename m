Return-Path: <kvm+bounces-39482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D00A471B9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:53:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 596793A15D7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3018316E863;
	Thu, 27 Feb 2025 01:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vc+clqhD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A451537CB
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620951; cv=none; b=Rmu7k5+Wbix0Jl4BYbpYds4w7Zw12Im7S3Y8V4sHoZDuCkdKBcu59AihEwQ1fMck8hfmvrnxEil7ENt0XnzLTu9/MdIUsGONY2waP8c9xbGU4zaqWOlRNVp93HoMYbp+jbuq1huG78JD5hX33OG4D5EcsHa1bKokr7JAlGkRyNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620951; c=relaxed/simple;
	bh=MLFcAaV7Kp3fzJwWXrLEW5MrwTlpZh8+LdBgVE9E8LY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H153qf7fGD3jL1fSLuw1PnxR41KEDnBZRyR+wnH10YehqO7GpZRlTyKzpF5owW7Rp67Tg/d0T5LTKhhUWNG14SDmP4pX3jaVYqkpNRAmvRxxE7T+43ng14+853CSHnWGCR5u2NkdktLx2T+uDlnhqRk+s6f/n3dro1B0zr55u8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vc+clqhD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05c00so1425037a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620949; x=1741225749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ql6MsPcFG1hKThKVbS33oCo+B0Gfqh6TWUoqCKtoqBs=;
        b=vc+clqhDIAXxr8H4NcwmaHg/cftakSAcCwiQN+XuxXitUuSgZ1DTE9UObEBh1Y5Ael
         EtBvS1tBVKtWCo6KMQtKViD7tzsSdYeetifJAeTRsPOMW2P1c+wtHG699ZsRv6VrG0pe
         EILhPxLFvyabVjWpItN+ao/WrjMOZtiUDT838Y0/hlHCBFK8pbF3NuSQt+X7rx44LJAy
         snvMYz4KVOKvRLZouVhwoT/JqaZISCA6VwLcKSRPihOrNJipSNG41YD/0U9LySrJpqbh
         /L31g31uln/ZRCkPWxmGGveEsbtUN/3JAGrCqqsz5OiUTIaEujVRFqOLqg8L/iZRsQWT
         GnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620949; x=1741225749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ql6MsPcFG1hKThKVbS33oCo+B0Gfqh6TWUoqCKtoqBs=;
        b=wacQ445+yQnzSsE2bwlDEdC70iqpp9hDmTwvLXkoGW09f1GYtuDFXRsneTGE8ccToo
         OyRhYj9pU96JJokRZCv3FgWdWPB2eYb29F+d3W1mkstbb/0o//7iqR/spn8GI6CL4Aa/
         f/AwW6IchqTR67XlmiRmwmPVJwSszQZ13quJk/XWTlr++nE27L/y7OeHG4nXLpNPAd/9
         iFv2Ldwaw1lijNsUw8Q8V0NIXeuW1Ava8soqENqNRDuDewXauSX50wZ2kw0nnzKQcbFj
         STLJ2l073Kr/Nm13PpsAUK/z2M9dLWWxQfsAn+fe7Ar3e+Rbex1tWrVHjoRwAUTFrWje
         GFng==
X-Forwarded-Encrypted: i=1; AJvYcCVdvCr90UQYoDyBSxfhd7zLS2DDWbDZtbDgDpODtGKwMh2N3rFSEMJZLd6P1a0BrmXqlII=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLBEFCYhGDKuirnUXBJJiHkgcVB5iL01RIJI/bcBHSJ+81rOPA
	H/Roi6yScom0GvyZkrn6zCbQIT91hzDg/FLPsSzGu4yoUvD9e59ftYxB//NvEo597b3IcRommMl
	DFA==
X-Google-Smtp-Source: AGHT+IHSebIlwvVX9AkLwVEhCgxbe2TyARpKt911VKqev26ad0iwG8j4dXRoe0e4YVDy+hyTSXHejlekFWY=
X-Received: from pjuw13.prod.google.com ([2002:a17:90a:d60d:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d43:b0:2fa:b84:b31f
 with SMTP id 98e67ed59e1d1-2fe68d065f6mr15204924a91.25.1740620949332; Wed, 26
 Feb 2025 17:49:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:54 -0800
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227014858.3244505-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-4-seanjc@google.com>
Subject: [PATCH 3/7] x86, lib: Add WBNOINVD helper functions
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kevin Loughlin <kevinloughlin@google.com>

In line with WBINVD usage, add WBONINVD helper functions.  Fall back to
WBINVD (via alternative()) if WBNOINVD isn't supported, as WBINVD provides
a superset of functionality, just more slowly.

Note, alternative() ensures compatibility with early boot code as needed.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
[sean: massage changelog and comments, use ASM_WBNOINVD and _ASM_BYTES]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/smp.h           |  6 ++++++
 arch/x86/include/asm/special_insns.h | 19 ++++++++++++++++++-
 arch/x86/lib/cache-smp.c             | 11 +++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index ee61e322e2a1..d4c50128aa6c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -112,6 +112,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 void wbinvd_on_all_cpus(void);
+void wbnoinvd_on_all_cpus(void);
 
 void smp_kick_mwait_play_dead(void);
 
@@ -159,6 +160,11 @@ static inline void wbinvd_on_all_cpus(void)
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
index 03e7c2d49559..962477a83584 100644
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
2.48.1.711.g2feabab25a-goog


