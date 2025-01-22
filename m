Return-Path: <kvm+bounces-36195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF16A188C2
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58309163143
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 00:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90281AD58;
	Wed, 22 Jan 2025 00:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x8HEX7mw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63F8F7D
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737504852; cv=none; b=TV9xD/QwomdDZR4snkGEKjp5xWw1fyz7Yesq3AFXcAnqJtRK3079PacKoN9tqLoATRusgJ0hJ7z0AmZZ6pd5NZDKBJr0C5dxMQ9rkBoBHqtckcfytM4tjYqS3jJ7EtDlMFynrl1fSl4MPfcRwXattr2D5pVWLNPD/V+ziifJoJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737504852; c=relaxed/simple;
	bh=pavw5Q/YtL/Q2BNOYCX6WtkCWskWvTT3iu40/uQ7w3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDmPgIikZ0Big9USAq/dLrQGPBEcS8JRe2HYgX9jLFFdvusokSTCbbwYNVMJXPUo8BcO3WAc1ZyUey4PdVyJ7r61Cz+xuem9Kr8nUvE3+uJ2BUeUY7P5oDgjIeofPzEeWEs4SKK/UQo6T2K+3dMzOgOGW1ZTbVlAv0E2ulEieTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x8HEX7mw; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-851fda72550so120306639f.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737504850; x=1738109650; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ACQ8RHKDxdTw4Fdpix6AB+QY5l9iusJFQGzSKvRZf9w=;
        b=x8HEX7mwP9gDAhqHIJUcWL50DCHMKlzCFEWVogjswzmLt6Ex8FWuOw5CixT1RiNBUq
         FglrD7kP12ipNIWH9LLJE9Gy6jwa0SYi1VbgcKX69Ig4amfHgTth5r9GxbtRwnjuQ3Vu
         KVuIRNaC+G5h4L7TjoG6J6hwQadPpo6T64I6f8uziuzKJ/wTkZ6cd5m18Qwr0zf2Alqk
         UuQczqqX6+sC6G96uGyohEmppI46WDVQt9HWv7xYOz8FmNbE1v6phWnMBgHXTYspuPtR
         g+2KziEmosGdoM93dCE3ImXuYVd5X1Yd7v98OeTfr6R4yil4msP8i7nSBcuDfS9H8yKF
         5FLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737504850; x=1738109650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ACQ8RHKDxdTw4Fdpix6AB+QY5l9iusJFQGzSKvRZf9w=;
        b=sSOgMCVCnX/C+1YByMLpn3Cj3S3+8k8nfEPktnhGIuJGWkS4LTp29no5txhb1Zkj07
         Q8zWGXCitXkqYNlAKIboq9lIvJMZuNvCgR07jCtdLv2xHpkIMMbmONj2uW2up3D1878F
         DuAQqQpldTf9E4Oik9NUFI294uZIsoY6KaRpFXgrFCOoTVKkrzDMbmbuJR/nrW/W83Cg
         b9eG8Lr2/NPBZjfcTD/SWhjeCChUf95qm9zrA1PiTub35c43AiG6hV0nJTheZEPngydV
         p4Td5eF3oMfHZEwejkWeuqDEJ8C9m68OSYShekZ2H2Adeg063680RYbZOACfgEzpt3UR
         cU1A==
X-Forwarded-Encrypted: i=1; AJvYcCVM/iCnvW1pbmgLlQ1NGtZgnR3NJi/yY2T89V5YZH9xAA1sqGS1n3nJ9cg2ofKxrWU4uzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgoF5k0nrXogjUxfWRLs8XpJ5jSvoX0Mg3IPHTGj8eG0xTJDkk
	wdBDDU2lBq9ccdNxR0Axwo/XhjQ0dkiD1eamFCVovNCgiPwZfV7Uo4RU5eQaITo9Wu+Dcpy6Md5
	FkGE8afxQHPhlJQflMxBRxIclti6uJA==
X-Google-Smtp-Source: AGHT+IGzHze8zH6E7AZfedxE1Bu2uF2bJ9lTyRygPYdEojRb8Oibvph7VH1HQ03BFDj1dJe2iqHpAdN8TQTdgT/gaZVs
X-Received: from iobhb10.prod.google.com ([2002:a05:6602:678a:b0:84f:4cc1:bae3])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:26c5:b0:83b:5221:2a87 with SMTP id ca18e2360f4ac-851b616986dmr1741327739f.3.1737504850348;
 Tue, 21 Jan 2025 16:14:10 -0800 (PST)
Date: Wed, 22 Jan 2025 00:13:28 +0000
In-Reply-To: <20250122001329.647970-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com> <20250122001329.647970-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250122001329.647970-2-kevinloughlin@google.com>
Subject: [PATCH v3 1/2] x86, lib: Add WBNOINVD helper functions
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	rientjes@google.com, manalinandan@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"

In line with WBINVD usage, add WBONINVD helper functions. For the
wbnoinvd() helper, fall back to WBINVD if X86_FEATURE_WBNOINVD is not
present.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/include/asm/smp.h           |  7 +++++++
 arch/x86/include/asm/special_insns.h |  7 ++++++-
 arch/x86/lib/cache-smp.c             | 12 ++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index ca073f40698f..ecf93a243b83 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -112,6 +112,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 int wbinvd_on_all_cpus(void);
+int wbnoinvd_on_all_cpus(void);
 
 void smp_kick_mwait_play_dead(void);
 
@@ -160,6 +161,12 @@ static inline int wbinvd_on_all_cpus(void)
 	return 0;
 }
 
+static inline int wbnoinvd_on_all_cpus(void)
+{
+	wbnoinvd();
+	return 0;
+}
+
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
 	return (struct cpumask *)cpumask_of(0);
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 03e7c2d49559..bd2eb7430cd6 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -117,7 +117,12 @@ static inline void wrpkru(u32 pkru)
 
 static __always_inline void wbinvd(void)
 {
-	asm volatile("wbinvd": : :"memory");
+	asm volatile("wbinvd" : : : "memory");
+}
+
+static __always_inline void wbnoinvd(void)
+{
+	alternative("wbinvd", "wbnoinvd", X86_FEATURE_WBNOINVD);
 }
 
 static inline unsigned long __read_cr4(void)
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 7af743bd3b13..7ac5cca53031 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -20,3 +20,15 @@ int wbinvd_on_all_cpus(void)
 	return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
+
+static void __wbnoinvd(void *dummy)
+{
+	wbnoinvd();
+}
+
+int wbnoinvd_on_all_cpus(void)
+{
+	on_each_cpu(__wbnoinvd, NULL, 1);
+	return 0;
+}
+EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
-- 
2.48.1.262.g85cc9f2d1e-goog


