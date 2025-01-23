Return-Path: <kvm+bounces-36308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF703A19BBD
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E268F1680B2
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F721CA8D;
	Thu, 23 Jan 2025 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l40KK7y9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08059168DA
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737591870; cv=none; b=GnFt80pCRZDpSGRHPwVyD9mb0Q2pNzPog/2Ksu/rKYdYlhf97dG68alFVKDtcfHuF2MimUqnHwXdk4SMkN4KSSbi54r6osLwjv+DXogYIel+KR50qCQieLnECN4zAihFOSMcDCVMZ9Fv0Ju949wUbWxlgwTtoA1ES/slT//z9eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737591870; c=relaxed/simple;
	bh=r+HWsD8gnaQzieW/wZ7ceu2cR1j9SMexHgI9i1fazyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m+gxoU+f9Tfb2d7qMJv1++Fb0tHyH6jcPvAZgZJq6QyeWPSp/eGrGRacGEK3ceNvB39ejFjx1uA4OOgS9XbMh4l8fAOHS8Ld4CQvazDa2T6lyvD+P9XXFJvlMmG7Dl2s73ftN9ffPQoqLD/Ch4RUT/Kch1iIV3AI0fKVFFFlsD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l40KK7y9; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-29fb38de98eso144632fac.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737591868; x=1738196668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hY2W6Pi5WQ5MJM/k+tqOXJx54Jivf1bazmvOgWkEgDs=;
        b=l40KK7y9apfKgCoGaN7YRhzc3H8Sm5Whh3lQ+RaGv6PZVNyy7ZHwsF3Z/oHpnuHQYj
         ijnz8prObGdprTqiAlqTVizunTtsDTWymyynPnT4TJNudolpCTZv0UAzvhYVIu2sfRcz
         xzTX8NOCN/yd6H5a8lJX0Jp9swUXMnGYfFgEFNn8fYq+kZ+hW7Z/t9lJYmyHg+z1Hyi+
         xF8MU2gf3uZCWAszQphPcIUx6ot/CIx/D+NwVW/6ija+WXmWXfqFsfphXZ1yKyQwwEWV
         4W1tGlU8/+j0lrRT6SNRsLqiGka2X5Ts+w3UbBKcEC6ZWHwZuMWg9abJGpUj3Vcfh/zp
         rFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737591868; x=1738196668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hY2W6Pi5WQ5MJM/k+tqOXJx54Jivf1bazmvOgWkEgDs=;
        b=uklpD8+KS9FtwreDLzlfsxTRkFuOvN+17UbXVwuZjuotp2XMBEbhW/1YuG2TixVg/a
         6ZyE1KJf5IkXubXj6UxoG9s8bBuKeUrWJUvrElLzbupCG4dVoHcBrG54d+35ROiYd5Ny
         4Vkjd6AispbKi+mV5si/F3jeGO2kRRZPzdXu/Mk45qkEGeYpE0Bysfp3djxSz6wQoUCa
         3nNYwwj0aORx8GM519crDdS1yHgdvvWEKk/pwKzWap1dggUrnKfqCwW/fX5/y0zF72ag
         URVHP3UsgNJjcynRqWEfMyOvU4cFyPZ2D1I1yjxjjeRiiqFBuPAaJpzFpbIGdvvEPVfi
         eRkg==
X-Forwarded-Encrypted: i=1; AJvYcCUkI7rzK3VT5erbJwyQ1r+LphOy7snY6YMhDRB0KGT5vx0vAAk04uYzq3rxrPxj5vDBkag=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj5k3QE8zd/PoK0i/S0jfA920zhlsicfLTbSevtzYG6F7Lcbpl
	uIHITqeU6WA7SCkASJodgamAzl0tPuRffoFgxwCJKUEy1M2tA4lrGZjUm3pJn38qbS7+3hWvPYK
	vYU+5B1tVwh4PuiQHxGQ7+1DVYZssWg==
X-Google-Smtp-Source: AGHT+IEUkGZp3Os/RbTZ92Osl5l9DAN3+i3XsU5dhAqujNCm2OpuwSA4JDloHHfMV4r52r6jw6M5zYU0JpGlfZ/jRlZ7
X-Received: from oabuz19.prod.google.com ([2002:a05:6870:af93:b0:297:2777:a7bb])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:6307:b0:29e:40f8:ad9b with SMTP id 586e51a60fabf-2b1c09b7e7cmr13906358fac.14.1737591868164;
 Wed, 22 Jan 2025 16:24:28 -0800 (PST)
Date: Thu, 23 Jan 2025 00:24:21 +0000
In-Reply-To: <20250123002422.1632517-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122013438.731416-1-kevinloughlin@google.com> <20250123002422.1632517-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250123002422.1632517-2-kevinloughlin@google.com>
Subject: [PATCH v5 1/2] x86, lib: Add WBNOINVD helper functions
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
 arch/x86/include/asm/special_insns.h | 20 +++++++++++++++++++-
 arch/x86/lib/cache-smp.c             | 12 ++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

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
index 03e7c2d49559..fb3ddb2ddea9 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -117,7 +117,25 @@ static inline void wrpkru(u32 pkru)
 
 static __always_inline void wbinvd(void)
 {
-	asm volatile("wbinvd": : :"memory");
+	asm volatile("wbinvd" : : : "memory");
+}
+
+/*
+ * Cheaper version of wbinvd(). Call when caches
+ * need to be written back but not invalidated.
+ */
+static __always_inline void wbnoinvd(void)
+{
+	/*
+	 * WBNOINVD is encoded as 0xf3 0x0f 0x09. Making this
+	 * encoding explicit ensures compatibility with older versions of
+	 * binutils, which may not know about WBNOINVD.
+	 *
+	 * If WBNOINVD is unavailable, fall back to the compatible but
+	 * more destructive WBINVD (which still writes the caches back
+	 * but also invalidates them).
+	 */
+	alternative("wbinvd", ".byte 0xf3,0x0f,0x09", X86_FEATURE_WBNOINVD);
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


