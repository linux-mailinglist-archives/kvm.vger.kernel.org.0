Return-Path: <kvm+bounces-41621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72AA9A6B0DC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06FF21899B58
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CD222D794;
	Thu, 20 Mar 2025 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hVuH2mwt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A457C22CBD5
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509832; cv=none; b=u+XtZtj4TNOQRpP2Ji3hTP3Gle8Yf4RFFrZ6Kut/iH2p2JdvNxMJ7At2DlcjaStO1JWF4yyP7G4OwDczmUBgNdGA48vTkDEZsKcBUY91t6DKRtrp45dqrvbvCo9lNDXK2e5JfbhhRyw0F0CtGvwiq5W3k/or9jGSqnQR0gw2hgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509832; c=relaxed/simple;
	bh=5De7ueIf9UgZRXPu/1q8Q1d2e6nkIduDS0bY6y+Dpnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ijgvKhcRiJrM4ELsCvpzGBmF+776+JUFsTOcf7hsINALmm7NfVqoDf+XsD/3VwRpBo2Oshkwf6I2Z+f7nlzz1I6FXY6DUu9ScG9kRutgujQ3A0fUh+Hy8nqEKrK7nICrgWr5c3Ca0OiKvVIGpDWWABlgR/UR6EnGKDEND9TSzYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hVuH2mwt; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-225fbdfc17dso22168835ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509830; x=1743114630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwN1XbujsuD3V7J/Bz3fRu7KgVCb0BPWWPB+rJlSEhI=;
        b=hVuH2mwtm1wE05SXmsLNFLfsprO4U+aQe+1ZjnI7bF2TtvUhizbqSMcEeAKOU57cWS
         mvpdIROk4MuczQgWUOn1+DIEzmZQApkZTyH3Ixcqh1uLJ1qoBCWKSS+gIOZvaaTUDlYB
         anUWc+rXm3RfQCaTy3PtxWHgOIcnFn9bClFmJaPYq5jcj4gGsgg4pi+7KqKXu7hMrZcN
         Q8dpvwKK61kzRqelq95HbnaBuSz/IB69yLXaQrefn5+zuBi1eo9m2IFpbYYU9kyNWwLw
         21PL74zHoZTo+y4M+v9IUqe+S4MzM25ZQvjFIaTPyjPATAvpeRsbkAh8sPa0pw1BUxD1
         QG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509830; x=1743114630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwN1XbujsuD3V7J/Bz3fRu7KgVCb0BPWWPB+rJlSEhI=;
        b=NYE706Ye7ELYpPg6UQWrSRidq9RkA8Z1ZjAjr+dSRdkHJDIrc+AUjgoOPyLfkf4Tul
         lWK/tH8eppQZGjK7FaGihi/U7CbVsw+l4O3vTOvzk9tgqOeD3yjJ2PzYTtwJYk6FjtnJ
         sbBo65IBHwAJRHQ9PkhfWNJkYxRV+kmunwLouTdEGrvkspsgVrMItnfcRVCBX9bQC6Jl
         dX49+KAxejRlcqEBxI5//CgLozB8lZvP//K0OWAxJEZinE0+Qg2xypLRtn048eJcfEjC
         P23tFiPjEmgIk0GtXja42+pqaTG92DbKVW9StS8ZhIFCgHX/eOaoHela0V9UMXR7E51P
         xdNA==
X-Gm-Message-State: AOJu0YwZb3xAdael9IGh4W1zar/5uidAM7coFGQAjMM59C9tkte2qpkY
	RfBRf/2SKInebXDKBygwdLjGwh5n3KVChXbZVtFNrCdWfKWaTCUGYcJIWs/d44A=
X-Gm-Gg: ASbGncsXHnA1hpi2lnAzOLOPJX1chQaLZAiVBdL1aysV1tZvgCY7GG7FzxXXmua5zUb
	C2/kLgOEItugHO2gd09PCZMfN0hw+i5fUE1f/AI0VerI4Ez5RcaiIFbFZ88xDnBQnnJM9jhwNtG
	9Re7ivhryZl4eR3+JUHckFxzMYucioyQPMSCKu9zi5oFq6U3INOCjCt3q9OPkQLhrPT5hKqgrGq
	pTW0PpwZCi8gimx2gokDkgxGdj35Qsp8am/j05sZ7O/tOT1Zqn/6MK9QOfE5I3b0xL2+o7yX/2h
	qBxXM3t91rxsdZntqs0T5y+hTUDxfXQ6iHOzxyzkF2SM
X-Google-Smtp-Source: AGHT+IFPlM9uNBTWNlrUQZHTXtzAV3hq70Es3JgASaflDsGAiltKwjCQjn1OTnh83OLfKZfNwL1qmw==
X-Received: by 2002:a17:902:f687:b0:216:3466:7414 with SMTP id d9443c01a7336-22780e25bd4mr13499905ad.44.1742509830242;
        Thu, 20 Mar 2025 15:30:30 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 18/30] accel/kvm: move KVM_HAVE_MCE_INJECTION define to kvm-all.c
Date: Thu, 20 Mar 2025 15:29:50 -0700
Message-Id: <20250320223002.2915728-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This define is used only in accel/kvm/kvm-all.c, so we push directly the
definition there. Add more visibility to kvm_arch_on_sigbus_vcpu() to
allow removing this define from any header.

The architectures defining KVM_HAVE_MCE_INJECTION are i386, x86_64 and
aarch64.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/kvm.h | 2 --
 target/arm/cpu.h     | 4 ----
 target/i386/cpu.h    | 2 --
 accel/kvm/kvm-all.c  | 5 +++++
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 716c7dcdf6b..b690dda1370 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -392,9 +392,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
-#ifdef KVM_HAVE_MCE_INJECTION
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
-#endif
 
 void kvm_arch_init_irq_routing(KVMState *s);
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ea9956395ca..a8a1a8faf6b 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -33,10 +33,6 @@
 #include "target/arm/multiprocessing.h"
 #include "target/arm/gtimer.h"
 
-#ifdef TARGET_AARCH64
-#define KVM_HAVE_MCE_INJECTION 1
-#endif
-
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
 #define EXCP_PREFETCH_ABORT  3
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 049bdd1a893..44ee263d8f1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -35,8 +35,6 @@
 
 #define XEN_NR_VIRQS 24
 
-#define KVM_HAVE_MCE_INJECTION 1
-
 /* support for self modifying code even if the modified instruction is
    close to the modifying instruction */
 #define TARGET_HAS_PRECISE_SMC
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0723a3933bb..7c5d1a98bc4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -57,6 +57,11 @@
 #include <sys/eventfd.h>
 #endif
 
+#if defined(__i386__) || defined(__x86_64__) || defined(__aarch64__)
+# define KVM_HAVE_MCE_INJECTION 1
+#endif
+
+
 /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
  * need to use the real host PAGE_SIZE, as that's what KVM will use.
  */
-- 
2.39.5


