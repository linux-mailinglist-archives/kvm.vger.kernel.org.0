Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690D83B0F23
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhFVVDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFVVDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:32 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1F8C061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:16 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id q207-20020a3743d80000b02903ab34f7ef76so19655167qka.5
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=haFo17eReeDWA+IklGU6ghGSlouWNmR/tQ+kfJMYFHo=;
        b=rI1jga/NemXCjZrjvi73czNB91eMrXpgNcLnmA7XHKcJiUGkzECXjWvFVE0qeLkZct
         tQa+9vB2haIFD3XcSENumjqac27nfm1LFZVqektxyi4tSyPsUHMv1bw4KSQ1fNE4m1/0
         iA3HejfuZaLmLpi4zQFxC1c2gdpHVtgN3bQmuSxsjGltmhHZSVYgEoEI3+jXUYp/mhJ2
         fReWSwrnp1ciBuVOEnIBi70M59DrZ5CP9kuRIa4PRuhT/IsCZn+C8rmHjM43H6HUxgKG
         0z2uIE1oja9P3pGFmJzlTMyUyt7m4iMhK4iMYQFXNIWlRA/2OeRw0Eg1edPHiiSh5G4X
         4NUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=haFo17eReeDWA+IklGU6ghGSlouWNmR/tQ+kfJMYFHo=;
        b=rF28BSnWj+zmrkrfoUHZZNP1DXvOO9RE8M7KMXI/QGuCd9kFi9xjiMWFAEytmfO/SK
         QW0J+6XjP7NWcdAMP5fdNWjuA7DV2PIbG/uYIcP983OVEeWJerL+gm1XSCIJd8QI0OPl
         VwQJN2LZaLjYAB6CRffd7oa9Muxj3L2QofHVfmdQf2J2WJMsIwB695tGamgHhGGwp/lk
         8MeJLuHdcnVCE3lMpihjuw1u2AlhG2vZHyhMYiD46bKyoKR5GGhcUUFWCRiy6WSyFuur
         ibTjDiZNS2upPXk4dDBsVPpHiFnZ/AAH7Z1kKfAFAjd9CJN2si3bYmK944D6jyItZ/hf
         TgUA==
X-Gm-Message-State: AOAM533u+J6qOJS1hIMG/8PPdiZR89QpCSdtJNY/1IynG9vx2+7PBxOT
        TE3x/n7xbLVXM4aCbFDa2lhuDH2km7E=
X-Google-Smtp-Source: ABdhPJzgkyL0zhnRTtAL60+xp+IXPRddXBF+9GyrHrpr77CU4t7ZAGZkveZYS61UVSaNjAJWyHh46Wn0Wss=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a5b:58e:: with SMTP id l14mr7626762ybp.303.1624395675608;
 Tue, 22 Jun 2021 14:01:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:46 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 11/12] x86: Add GBPAGES CPUID macro, clean up
 CPUID comments
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a GBPAGES CPUID macro for a future NPT test and reorganize the
entries to be explicitly Basic vs. Extended, with a hint that Basic leafs
come from Intel and Extended leafs come from AMD.  Organizing by Intel
vs. AMD is at best misleading, e.g. if both support a feature, and at
worst flat out wrong, e.g. AMD defined NX and LM (not sure about RDPRU,
but avoiding such questions is the whole point of organizing by type).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 8db13e9..173520f 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -141,7 +141,7 @@ static inline bool is_intel(void)
  */
 
 /*
- * Intel CPUID features
+ * Basic Leafs, a.k.a. Intel defined
  */
 #define	X86_FEATURE_MWAIT		(CPUID(0x1, 0, ECX, 3))
 #define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
@@ -174,15 +174,16 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
+
+/*
+ * Extended Leafs, a.k.a. AMD defined
+ */
+#define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
+#define	X86_FEATURE_GBPAGES		(CPUID(0x80000001, 0, EDX, 26))
+#define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
 #define	X86_FEATURE_LM			(CPUID(0x80000001, 0, EDX, 29))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
-
-/*
- * AMD CPUID features
- */
-#define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
-#define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
 #define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
-- 
2.32.0.288.g62a8d224e6-goog

