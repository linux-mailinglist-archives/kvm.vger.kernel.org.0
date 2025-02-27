Return-Path: <kvm+bounces-39481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED69A471B1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62AE61654A3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F0813B2BB;
	Thu, 27 Feb 2025 01:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SHGpuEdc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6941474B8
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620949; cv=none; b=D/iwUfYbANAUxm5QjVLi6kCmYJOEzcTd2rEjm2aNvwsuJYQYpjsEfZhzOmcvQUMKRidOjiSVrhbfdG4xLIvjQQUiRbzOgo7omZMfhkQWfq1vOe8/B2oKuvoXhj8Ef0ja57lwb4iIwcai9XU8Sm8vIE+/OLhQ1xbkl4RKYYCBpyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620949; c=relaxed/simple;
	bh=43j1TPRazK8BCh3mEM3X8xpew+6c1YDyF0sMhn/7bR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ubpYsCvDOE0V9s9EeCSU93d3GcHXoIF9fvUPgBcflmfJYLUm5v/i4HkmNLTY5shBX6yP+9Yf5MTTGO+XHli2ISyj1pMxffW/MH/O6xmIygw2MsK6uLlB2kWhtQDkEhR+lvhT/lpf7O0Gz+U2ayl6aSZUYrBfcEJM8XiAweS1pLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SHGpuEdc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2234bf13b47so7239545ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620947; x=1741225747; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EonFhjKCFXLwW4g8Vs93xIs2sNaiaGoxwaxHmKn8ztc=;
        b=SHGpuEdceExb/nYtvEI5uS5zY+Lys3ilHaJJwfpnnZWea0urDvO6IkGX9hfVLXtXLP
         jOfV8ZaX9vcdQjD61/eTRXxYX7GNX3Nq9qp+JLnbC4b266VrpPzNjMIP0vhb5wcSbkvR
         Fxhy9cKRd6xHN0e1qRYLhOUwPnWVKNTAOcIkHgaU9ShbMrze5srhfI1N47qPcYAi6BgJ
         sIC1cDBL9P0VbRAvKu4/UWAJKwwto7PlNVbx1AIy4mI4OCxOX0jbdfnWu3wSrpEzc+Su
         VfDpI7nSWbfSgJxKT5kAlkc8GTH4FkxTuPQy6sH5qBJOOFbhpDjlNkNzEMINKmD5Kquf
         PQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620947; x=1741225747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EonFhjKCFXLwW4g8Vs93xIs2sNaiaGoxwaxHmKn8ztc=;
        b=ioIUgAPXP+tc5xH5tsniCkAI7h9Ra1BibfajZ3PwqBl384Bkz4f0VrMc9Y1mfl9Ywj
         4xOR9mD91kvvPWyjDnrHgbDpqs0WLpTVT+X8pWGDUfr8G2ilwPQVxy1B6fyAp9JwsKWn
         zBRZ2+/66zzbhdvkdbtHujxnBlCV0OUXBeUQ7whP3QXzwcFatZQDPdaVsjgzyl8LGFMJ
         Ayit0M+JB3jYdb6HRTbukDVSp8XuLtIdBUdD6YOfDmGNoCUvAsgYx4XsiAOpae+4pWGa
         M5xwlNtBK+y5E4E37XzEqw83Tf/sEIKqkOcNF5B/MCLH2usH2GLbQDs4+Xk7a+PRTvMZ
         x6Eg==
X-Forwarded-Encrypted: i=1; AJvYcCX0mTRTZKy9QyAoCp7S5bld2Wat672kwVVyeJRMZm5qEyGC4eQHHTlANmgfDC9HVFSKiXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIyQAdUdSlFUb3IG0KAYoDfg9j+Udp/a02FxsYVYmyjtQyPiT+
	CBXCTryJVBrCnSiYwpH8IOXvbPuhMjKj2z5NyxPi9xa5vPgoIwq1XW5i7/GC4/hIXxMhhjvUmvG
	qGg==
X-Google-Smtp-Source: AGHT+IGE5mWIDU4Vs4EAjIB3CweF7rOyGspQLWufKH4bsvLgDhV8Q0xoTjomyWDxZBWJ7lKHEMgh7W8MY2M=
X-Received: from plau19.prod.google.com ([2002:a17:903:3053:b0:220:e8a0:ec1d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d502:b0:220:f509:686a
 with SMTP id d9443c01a7336-221a10f1e97mr389509235ad.29.1740620947569; Wed, 26
 Feb 2025 17:49:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:53 -0800
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227014858.3244505-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-3-seanjc@google.com>
Subject: [PATCH 2/7] x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop wbinvd_on_all_cpus()'s return value; both the "real" version and the
stub always return '0', and none of the callers check the return.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/smp.h | 5 ++---
 arch/x86/lib/cache-smp.c   | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index ca073f40698f..ee61e322e2a1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -111,7 +111,7 @@ void __noreturn hlt_play_dead(void);
 void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
-int wbinvd_on_all_cpus(void);
+void wbinvd_on_all_cpus(void);
 
 void smp_kick_mwait_play_dead(void);
 
@@ -154,10 +154,9 @@ static inline struct cpumask *cpu_l2c_shared_mask(int cpu)
 
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)     wbinvd()
-static inline int wbinvd_on_all_cpus(void)
+static inline void wbinvd_on_all_cpus(void)
 {
 	wbinvd();
-	return 0;
 }
 
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 7af743bd3b13..079c3f3cd32c 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -14,9 +14,8 @@ void wbinvd_on_cpu(int cpu)
 }
 EXPORT_SYMBOL(wbinvd_on_cpu);
 
-int wbinvd_on_all_cpus(void)
+void wbinvd_on_all_cpus(void)
 {
 	on_each_cpu(__wbinvd, NULL, 1);
-	return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
-- 
2.48.1.711.g2feabab25a-goog


