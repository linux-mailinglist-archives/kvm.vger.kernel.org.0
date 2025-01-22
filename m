Return-Path: <kvm+bounces-36210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F621A18994
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 474E11880861
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D3913A3ED;
	Wed, 22 Jan 2025 01:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VZWY4y1X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6174C9F
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509692; cv=none; b=PDk6S3hOfXikvcfbc19rdZohqPsIRWpwPhWuji4nLczLmzFCwODjF9lkKRI2U5Hjwevd7od8KF5dJNgsIqIHhn9EDm/e+g494Qk1URIkpjPKk32iuClE+Sh3L013ZJs17DITYNTw60z0CAIGHm85j3ynfUpzbiwsThCIHY5e9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509692; c=relaxed/simple;
	bh=9Ade7knO5VEVNmwnbjnPb6BiwOMU+ufwYFiIL/gLHIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rY9i0VuFz4x7MquwNKqs3k/ogs/LkPzZYgwGbcHai0SgEn22OiwPaS2AfDwHZGSmuI0p5Bb7/xa/vA0hOZGngnYQO62vEa2RUnsFJ+uapC0qjh7cxkaDQtF2RDM0T2hQjVHn273lPpm4OJwCmdPGbKAgdGNp1d0yO0J1rRPWc/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VZWY4y1X; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-3eb85c4285fso4296494b6e.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737509690; x=1738114490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HgteI4fiuJZOEkE1qejk8g/bCWMB3HRRd+RVqIi5LEs=;
        b=VZWY4y1XKeINUrUhj3QnTzL5VW27YH7+iBjdhE1z8h/CIpuK1b1ImQ6+/pZUbqynuJ
         DhN2CcclTBXUKiMYZ/GGk1S3psH2q/BWQin6Y8IAarlDzY25Ese8JXsBayiLOOriEXhQ
         FQMgIFseKweaCu3fhXWvOjyclge1TdozCDKm2tyhT0OiAMC4i3sSV4xJ1issMtPb56D6
         GVoSybIY4QIq1p61vbjT24Dw3RCm7nEFQE/VpaRSrrSN7nRmPM0d5iQqaeXwZabVyNbz
         ev5d//Fy9wZ/Z70I0yKRODzE1Xt3h68YdVYNTCrhrcg1wjqWHrFP0QrRPAq9Kbc+ssyZ
         igbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737509690; x=1738114490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HgteI4fiuJZOEkE1qejk8g/bCWMB3HRRd+RVqIi5LEs=;
        b=YXnb4xCaE12jXIEZtOMFB9mSZjrW8YSpWqgkyzZnYOtiW5Lz17GG45npq4uFd0jGCF
         xeLtSpr4gEum2sm+LIHt01i9pa8y+eEjNBAZn7rV0EUCzsxUye3TRI3Jzm73C/T3uI4P
         3/BZlGBYY+A3mXrJRboQAKio/BDPZY6jtyBp+0Jc9DI0NDFkJUsrw2t465EAxMFiUGv3
         UayfQS6+DWXAlpZ4JkJGLtO8qwDsgGVcORBVQ+EGrfTn0jUuTwS32D/IRzKqez1fU3th
         kiWNEwTeeWjE3Iz/U2FmzR+x4yo8HNOo7KTjPVXs7ujZAJ07hhF2Z/nwO0QtXC9SnbEJ
         FWaw==
X-Forwarded-Encrypted: i=1; AJvYcCWdHBhWf4NOl1xvVVLuUHg13N3lRNxh/smvjK+A9htwj4TKi9rLZaheNhlde8n9JMpklcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmunRpsrBUWLIFuo+B+8FzzJ5mq5kvhuHwsQIomSf1s9UCr+yt
	pDV5j9mV0VjqUmMAADVhrO9ZAaYSE0xIcBfcN64ntZK8PhvbtLwFD83IE6TIRmw46Lxtzfmq6AB
	/LWvu9bbQvqwr0iBCyN1+QBGz7XE7eA==
X-Google-Smtp-Source: AGHT+IE77jKtUq5gPhUy8no02bvIde6UggrYU2Sq+8Doh8YUX3w9e8Gjr8vJMgO6IKwaiiZbIw7Z330GjHpSMRqnl3lV
X-Received: from oiwq37.prod.google.com ([2002:a05:6808:2025:b0:3eb:6944:3f22])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4e0f:b0:3e6:5522:b333 with SMTP id 5614622812f47-3f19fc87b21mr10329879b6e.22.1737509690070;
 Tue, 21 Jan 2025 17:34:50 -0800 (PST)
Date: Wed, 22 Jan 2025 01:34:37 +0000
In-Reply-To: <20250122013438.731416-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122001329.647970-1-kevinloughlin@google.com> <20250122013438.731416-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250122013438.731416-2-kevinloughlin@google.com>
Subject: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
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
 arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
 arch/x86/lib/cache-smp.c             | 12 ++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

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
index 03e7c2d49559..94640c3491d7 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -117,7 +117,20 @@ static inline void wrpkru(u32 pkru)
 
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
+	 * Use the compatible but more destructive "invalidate"
+	 * variant when no-invalidate is unavailable.
+	 */
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


