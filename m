Return-Path: <kvm+bounces-37010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82652A245C8
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32CE93A7C73
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 00:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E92E2628D;
	Sat,  1 Feb 2025 00:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u7Z4o9yw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AB2A934
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 00:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738368189; cv=none; b=XqZacIipl97u7vwO6XHbPlvWPo7OiAPNfzw1jJTmZyXYF0i2Aq5cS2cqoPZo60TVQTLBKHo5ctZfm6Ij3ac7tK/AhaaMvX97H8LbdzmcUVOx+jxqOpYa7cNb3sQVZgrnrq7+l9ECChVZud+yJWw0lcGvHA3bWXi4fXCEwayvK2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738368189; c=relaxed/simple;
	bh=4GmVHoIvr9/HsHiiywbwuz0s6cbVHi24NxG3rxAgFiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F5RMUsJMcw91F0c3KyfHIrXIwkh2sbj61dxL+iNYlDymKzWGJT/Ds28UgR/CE93n4/awr4oes6UtL3yRIuxbtY1p3yJduLkQafFG3G3YHlDeumOei6BQX9gdoub7Y15LMOd0ySpU4Tgh8f2yd/7cRo01RZXyNxnugawRcqai/98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u7Z4o9yw; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-844d5c7d664so165564839f.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 16:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738368187; x=1738972987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/FSKsUubj0Qsn5eQEprpgV4tiVS88QLZg+LTAfvOd4Q=;
        b=u7Z4o9ywY/jWcjf6rJKp1Id0Jf3LKKxVaqgmf0PCHl/jtepmoEpwOo1o9VH3r/JKIa
         DaTevbx+laIH2gu+fLyOHe9IASIBe19prDjV45nERIriVratLK2cKyQSuIWRdohvUf4s
         4qQYPftLoyKo0ycm+Xpm4odDWJgnrQnR8+JU20waF8uEx+Sga8bgAFJpmhqw4lBfffop
         VH/QmnzJeqx/7vvKAfB/ragpO/cwzqsT7TRukdHGaNlPSWNmZ2xUd3oom2fXR8la/1yo
         6hfdjmvY/iO3gRuYPrE68MAd7G6yDiU2pB0UZ2YVUGQqqbNfy7PGT+Wa9ZhUHrj680Gx
         pN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738368187; x=1738972987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FSKsUubj0Qsn5eQEprpgV4tiVS88QLZg+LTAfvOd4Q=;
        b=Ikbr1xrHPAV7LhAEp5Jg7lPcApQ7n2M70Y1KuCmKooy/9DzPUZrXM7JicbXuwdRHEi
         zgf3TIfjf+JmUfPkbAjvweStuzOblMF05HxbWs9ZYxL37DJ1oVxT2UaaYbumclSwRft4
         axZ+//owkNiAi/i1zqR7V3HqE60ZgqxAVEB8FApBOBtnjQUPerS454hE6+ck6+e7qpr1
         F8AgpczdfpJytsXMoDk8J+/MRM2HknMKhe4piAHnkc6Q4/kwQdFVtPtb66SGzfEjGbLq
         5t2pT2tW3ma+gFWfsXd5gKEKsXwbGWBJj76W47ylUxGDJVklCoAZHcRoqd7Cl2vt7LEq
         OSrw==
X-Forwarded-Encrypted: i=1; AJvYcCUDMbTxWu7/mRi5WvS95lR6BxK6ucb9rVvPPyvNTW+uSm17tLYtTres5CpPWOEhqNrl7DU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkH27Bs5TtjA1Wb+3WN0UvsVzc5zQPGQCVFrUwYBaCG+nDZgFu
	LduT3GBgBZy/Bmwq0J7Txq+F1puPhcNuPvw4PjVtrhMAphI+ppaiF0AG8CUxrrO1NQUr8KzshA+
	94yujRzyRd5X78b14oXNBgUQIbgqQBQ==
X-Google-Smtp-Source: AGHT+IHgu+KhlTRU78S3aLawb2EPbz3Nu1d/FQrvmlitnbGv/+v+zOiD3oO/O3xRTVmCngaigziMdprykGf5qEn+FtDZ
X-Received: from iobjh3.prod.google.com ([2002:a05:6602:7183:b0:852:28bf:8778])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:2b85:b0:842:ef83:d3b2 with SMTP id ca18e2360f4ac-85427e0d83dmr1376167039f.12.1738368187440;
 Fri, 31 Jan 2025 16:03:07 -0800 (PST)
Date: Sat,  1 Feb 2025 00:02:58 +0000
In-Reply-To: <20250201000259.3289143-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123002422.1632517-1-kevinloughlin@google.com> <20250201000259.3289143-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201000259.3289143-2-kevinloughlin@google.com>
Subject: [PATCH v6 1/2] x86, lib: Add WBNOINVD helper functions
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
wbnoinvd() helper, fall back to WBINVD if via alternative() if
X86_FEATURE_WBNOINVD is not present. alternative() ensures
compatibility with early boot code if needed.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 arch/x86/include/asm/smp.h           |  7 +++++++
 arch/x86/include/asm/special_insns.h | 19 ++++++++++++++++++-
 arch/x86/lib/cache-smp.c             | 12 ++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

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
index 03e7c2d49559..86a903742139 100644
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
+#define WBNOINVD ".byte 0xf3,0x0f,0x09"
+
+/*
+ * Cheaper version of wbinvd(). Call when caches
+ * need to be written back but not invalidated.
+ */
+static __always_inline void wbnoinvd(void)
+{
+	/*
+	 * If WBNOINVD is unavailable, fall back to the compatible but
+	 * more destructive WBINVD (which still writes the caches back
+	 * but also invalidates them).
+	 */
+	alternative("wbinvd", WBNOINVD, X86_FEATURE_WBNOINVD);
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
2.48.1.362.g079036d154-goog


