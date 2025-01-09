Return-Path: <kvm+bounces-34969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 509D7A08305
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 23:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 229F3188BC01
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 22:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF6B2063CC;
	Thu,  9 Jan 2025 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5mpKjyE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244F1205AAE
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736463361; cv=none; b=MmhGOH0C+TYMC9fVynlUvBxWG6bQF2Hh7GFYKt5QfKpVIwwQxzXA/tg+aVWjRDluTtL4iXrGBdJJ/7zsmTV8vYjC5ffoitioNt3x/XU4GkCyfPee9YYlXI+Nu0uNMNfFWzAt9Tfxqa3mv8kcH0UOijcGcjJ2n1UKbtJ0TUj7Bu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736463361; c=relaxed/simple;
	bh=wgDvIx1ft3AVQZjqCLs6ZcLJWjcJ+wveeGMeKbrskqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bKcdl5ItwZ/MPecPeKRSUfd2S3Po/i34GJ8CBK8AoiJKBIeL8jQBghpYVQVpBadH69p0R7sHoBjv/IpKL1n8t/w953OXZzldCDv1IgVqd0A5EWRJe6I2KXdNrh5BdgbiVcDDMomM2pjFZ98pd5Ep7gWFzH5WbQyLfEh8/50Q58I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5mpKjyE; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3a819a4e83dso15229785ab.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 14:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736463359; x=1737068159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U/oLdB+jF+T7dwxJNpfMM64SG4eJPsQJJU1EekA7fZk=;
        b=V5mpKjyEYALhTavR3Odzpw4ja3w00k26Mx0xB7v+uLzRNfz+hAylN3rJJl3WNOTHzl
         hjY1C7LydV3ClrKRLQuyY3bzcEJ2dnRfBWW2MWBtxMT20rhYfpWaksrRSBTbDEo82rye
         VpjMVRed8v0iK+EByawFgAnGnybE+q1F6MgegCPM6TkfOh1RZsrZOE+0zjw7YTQwuk3s
         HOquZwcHkDG2OHmz31Pd7N/1jZw4PW4QWoaJwgwhkv52CGg5NZlQK7Dnb+6PfHIPxkPr
         qppoClSJdlZ9buRGzjlRN/GhCN+lSzZNs1mSiz78iscG03pF50w9a5Tg02W2AL4Jc38/
         tM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736463359; x=1737068159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U/oLdB+jF+T7dwxJNpfMM64SG4eJPsQJJU1EekA7fZk=;
        b=W8jK3kzDb2XcpJIy1u3dh2kz/pB3z7de7dbfWFKnSrz3CuQ4BQKbo9CPDv2YKjBheB
         r2WEmKdu2t2njgPIpVSJ4vMN3ypSg/wWiJjz/ktvZtX0WYPEAKm+cVotuExT0FrjiAmI
         /2bsVvmJ+pHHqC8PYG8Rk98BUUO7qFevfnIrYQ0toCuEHQS+boFvsKD0ZdKg+jzxwC7W
         +gOrjC4D/p7E6K3ZfHgxNiE9kUqj4XMNOv9tbJQHgQAUKSvFcmU1e96oJdnyXa+LUhej
         CZ+sbEAMjgfACQ60L7OBUake+ihBk3pvtJSFsjFt/G96rW8Tfps+j3Kgw312i2y7s82d
         yrfw==
X-Forwarded-Encrypted: i=1; AJvYcCXXzv894R1Jxk5SphY4qFIwo606G2FPm1N6l03sBJtHI9HKItxYcvDyMTkWU2kBbBUu7Ug=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2TeYq//kIfS79FAqffR0S6nn+pauDRgIqYinnPZ25pVpdG+bh
	ZXY8iu2rLHXu8ZhLk58Fjp45pMibEtO6NwItht99E2Up6td82fwTNgwP1VwUHMPL20nVRfiQCWU
	Atp04B/Zmu5zQBS4uHZZH8HGaPzulWw==
X-Google-Smtp-Source: AGHT+IEb83UVdWIhp+TQ03vSsQ/mXXGysN3VVBnbetJ41Y+zCfiY202TqiE4nB4EFBA4rPyeS+hnOgepBR0ES+om+HDn
X-Received: from jabc18.prod.google.com ([2002:a05:6638:c212:b0:4e2:c5d6:9701])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:cdab:0:b0:3a7:c5b1:a55c with SMTP id e9e14a558f8ab-3ce3a8936efmr65056265ab.0.1736463359373;
 Thu, 09 Jan 2025 14:55:59 -0800 (PST)
Date: Thu,  9 Jan 2025 22:55:32 +0000
In-Reply-To: <20250109225533.1841097-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250109225533.1841097-2-kevinloughlin@google.com>
Subject: [PATCH v2 1/2] x86, lib: Add WBNOINVD helper functions
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"

In line with WBINVD usage, add WBONINVD helper functions.

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
index fab7c8af27a4..3db7bf86f81f 100644
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
+	asm volatile("wbnoinvd" : : : "memory");
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
2.47.1.688.g23fc6f90ad-goog


