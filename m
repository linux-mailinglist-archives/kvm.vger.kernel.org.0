Return-Path: <kvm+bounces-64191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 70426C7B3E0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B73014EF272
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEFB30AAC8;
	Fri, 21 Nov 2025 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jgw3SFwP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DF92FD679
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748558; cv=none; b=L/65KJD0Cd3guf34xib8/JxPoiw0StS4OOKDFX4VNtpbu6it1WTaAk77fWRpUHthc8sl+qaoD2ZmKUUBsmxEoHRw70Xb97jghb3EOOJHeJ6+r537UBZNGQpe1liwse/NrV0DN8wJYREGP/HNLryD2kFe/5KEZBjb211GruVXi+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748558; c=relaxed/simple;
	bh=NY7KsrSYOGUjVGcSNkSUT34/HkoSkqwyW1G2mlSaXsU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MAYOPzYxs92eR8grtC90G6tjuOmTw9iTgoUl0Ya8jABXtNgKScyq1wK1wmeRoTSQ691VnJUg6OGPQWwUgWaJ4nX+fNdkBBhGfUeXTdq/ZG105gde94Q+zGAWdmyNxG/syBqIHTEUI8sKGZjk5iEb0OVO35p00g+vVjTqgrRYIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jgw3SFwP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341616a6fb7so2718112a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748556; x=1764353356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2NpNxPSqMSmshegtTPA2E3hIO3j0cvAOT9SXM0SG4ZQ=;
        b=jgw3SFwPnstdmVHno0yj4NgG36jXHG67hJwJlF7qFNrFYeiaAiApXEA6csQHSu3thj
         1FciQ/2FNZ6cY4uDu/KqvOrWKIc1n/IuUBn9T2EqxXcfjM1M9Iq3Z/y9Fv7OcugCrOYw
         bVAv+3kSNW78V8qhzAICV/MUvshxKV9vkWDZ3zBzjeEVx/LGO2/7XYKwp3+LWp7PXQ1X
         rZyexMzlNS5IREhM09rxOv4Y84sUr1XPhTQ7xIpTzr/tSg6tGPb0s7WMb+a/IjB1RY1V
         W1X9fn9NuBLxTwMiuwaPoAMmj2jwvFoVcPW7TWS/mTWaNWHHazdRptEVdbtj0iWgdvW6
         fxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748556; x=1764353356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2NpNxPSqMSmshegtTPA2E3hIO3j0cvAOT9SXM0SG4ZQ=;
        b=GkAm5Qa01WTcxeFZObzlK71bgByWW3hBr3y11H+rlBq2aK35VxaWpgLR6QsLtCxv/R
         +73J1OhgL0a0lTkcpXJKyDvPJ6YIX1KvHckuNpmqV5E+tjqvp2ixJWGa06cXMRVcv/3x
         ge92DqpCKXBSmlusjIGnmzEiPflDdooyQWD8M7hSXtmBLL8Xrwq1Qu9h7KGqIwjVlATN
         VO80Fg8I1cM5SNus59lakv3UWBO5IjWy5pKrm8frl0IxUZIvkPHPM3H780YI8ECajM16
         h/uGVFFJCsdtdVCTDzPMe0d3Eys/dy9XmW1cp/LQqm+N5/vzIo0XJscwGsuZg28O4SaO
         tndw==
X-Gm-Message-State: AOJu0YxXebvgt8Yb63HEpEuqCQBMqDs8pAYVRd+At/bvJP8KrJ9wdlKT
	X6RdR9tE7iHaVK3gz9nqSNCZ9diDZQ//2+Ix1S7iRh6gJ6Q3embJicaB3jz1W6iTBVpAnqgWy5R
	TGCeCXA==
X-Google-Smtp-Source: AGHT+IGUkuyBrwZCSe3j0S2LU5EZlgKrs+9ljuxngPq9Ae7GxXsV1JB949UDnqa1PL+V/TUAz1yGzZNOXLg=
X-Received: from pjuf21.prod.google.com ([2002:a17:90a:ce15:b0:340:d03e:4ed9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a08:b0:336:b60f:3936
 with SMTP id 98e67ed59e1d1-34733e72342mr3890016a91.12.1763748555676; Fri, 21
 Nov 2025 10:09:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:53 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 03/11] x64: xsave: Use non-safe write_cr4()
 when toggling OSXSAVE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use the non-safe variant of write_cr4() when toggling OSXSAVE as continuing
on if XSAVE support can't be enabled is pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index fc18a4b0..9062484a 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -24,7 +24,8 @@ static void test_xsave(void)
 	       "Check minimal XSAVE required bits");
 
 	cr4 = read_cr4();
-	report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == 0, "Set CR4 OSXSAVE");
+	write_cr4(cr4 | X86_CR4_OSXSAVE);
+
 	report(this_cpu_has(X86_FEATURE_OSXSAVE),
 	       "Check CPUID.1.ECX.OSXSAVE - expect 1");
 
@@ -66,8 +67,7 @@ static void test_xsave(void)
 	report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
 	       "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
 
-	cr4 &= ~X86_CR4_OSXSAVE;
-	report(write_cr4_safe(cr4) == 0, "Unset CR4 OSXSAVE");
+	write_cr4(cr4 & ~X86_CR4_OSXSAVE);
 	report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
 	       "Check CPUID.1.ECX.OSXSAVE - expect 0");
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


