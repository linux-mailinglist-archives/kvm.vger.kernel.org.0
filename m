Return-Path: <kvm+bounces-67513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E95BBD0709C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4CC913010BD0
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC359270552;
	Fri,  9 Jan 2026 03:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="beVfeS2M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B0A500953
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930641; cv=none; b=gXr4kA37xNDaLQG3CIPCwLtgYGq9xtmaqevUTSzUcKVstiqpVSw62jEPeQ4hW+4XmKcHVF2tvhFZbNL+j2yVyZAIVII1dSWg3g40pDauzYeH+V8QqVigxATA42mFKm6aStfSZK/tJf1WFNOCgJrizLUgpEVvfkn9Ei7yMpYzYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930641; c=relaxed/simple;
	bh=oD4IsSurVbBqHnnebpi5fOjtTt9wa72SiZ1ghv9RCEE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fx5JK4b42xUbjv0l/Gh6dwZaTsRqKFbqeu79ldoNv9cyTuQUSkSv75VCn+Q8Z1CowBpuiqdC+lcJllS/9ZAK2tPs4UndXR9mBNGmC7ETvbQeXVCHynwcVR+VMwvKpEM6jj/v+FhpAfy3IQ3BDCrJiwdHIZpGAogT3KWI/elv0tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=beVfeS2M; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0e952f153so93545515ad.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930639; x=1768535439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4glmtYGx5jUGrUZmIO8L5piniGt8eRx99VS1HEERP4=;
        b=beVfeS2MbMLBmxFLYhGRM3Ez9nN7DeCSXy1xvoALAHOjD3SGGF3+POxTxDggk+oym8
         7jWIfGC6pcCZbCBW+yWidmZTy1Y79EvxuX3sGxnGr9/K4glnpsAy7KvhmEfbwDRgJHJQ
         ONH1Tc9WtZu25x0HYUbKGvFaT9FhgFGtv2pfVpR329tuhqPgfthSBLUH3JlWE8E+kvxw
         lRbH7Y2yL6PFRGJHVF1uDEsfgYOvIuvOcEflEHftU/vf/RzMX20ky9nuzwcgvD+5mKwU
         uYkoHVy8mIDRQtQTJSvZLnlMVgwP7yoZh6e3qUg/yxviwwm17NJFSfUc5D4QPh1B1BZg
         Lvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930639; x=1768535439;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J4glmtYGx5jUGrUZmIO8L5piniGt8eRx99VS1HEERP4=;
        b=TwQNUuNvaTNrkwG1W+2K0ihZG75vZwi+qarR0avLbL9/ehUbujLv8MeeQotZDWt7Pz
         WnLCLeRLuKgv4jIv+haeSo8FyCAggMTsGmthuKtc76ekozJkUpN+2l3huLfusC8ruUyC
         fHTeiuMRASmnxCSZ7/Xhxni0VZnUxn7N1fPAcU9C0NRzw6j/9zYaEG9DUMAG5Ep2dvrw
         3nCntVlyGB23hfNIlU0pxEvdWWnB65kfMTn14EmFcHkaOFw02IXrU9X2MCMa1jAY8jx/
         g5yJslLVnwo0vNRRY7ccehWcmNp/nOi5UtJHJu5HFx+SChfU+PMd0P1AzvTuKCiLFEhp
         exMA==
X-Gm-Message-State: AOJu0YwNRn8hp6+g2+3zsg1707Rrxedr9S7xuZzwleFecWbk/BeSIoNL
	7yQ22iKnKqy/NIZzStuBZMQ/4DA2ZFiTBH34S0+oCH9W770mbKOlrvf54Zgs2xaBvSF/Him9QxR
	9XV1ULQ==
X-Google-Smtp-Source: AGHT+IGil3AcMq5ReI7Ex1AZOdllBv1y3hr+30w6damUL16TDHOzU9eGY6bUy7e3B6e1g9dNcrFPyvzVs5I=
X-Received: from plox9.prod.google.com ([2002:a17:902:8ec9:b0:2a0:c485:7eed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e952:b0:2a2:b293:27d2
 with SMTP id d9443c01a7336-2a3ee4b4cb5mr84697545ad.53.1767930639201; Thu, 08
 Jan 2026 19:50:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:50:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109035037.1015073-1-seanjc@google.com>
Subject: [PATCH v2] KVM: SVM: Fix an off-by-one typo in the comment for
 enabling AVIC by default
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Fix a goof in the comment that documents KVM's logic for enabling AVIC by
default to reference Zen5+ as family 0x1A (Zen5), not family 0x19 (Zen4).
The code is correct (checks for _greater_ than 0x19), only the comment is
flawed.

Opportunistically tweak the check too, even though it's already correct,
so that both the comment and the code reference 0x1A, and so that the
checks are "ascending", i.e. check Zen4 and then Zen5+.

No functional change intended.

Fixes: ca2967de5a5b ("KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support")
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Update the code to precisely match the comment. [Naveen]

v1: https://lore.kernel.org/all/20260107204546.570403-1-seanjc@google.com

 arch/x86/kvm/svm/avic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6b77b2033208..e8acac56da5b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1224,13 +1224,13 @@ static bool __init avic_want_avic_enabled(void)
 	 * In "auto" mode, enable AVIC by default for Zen4+ if x2AVIC is
 	 * supported (to avoid enabling partial support by default, and because
 	 * x2AVIC should be supported by all Zen4+ CPUs).  Explicitly check for
-	 * family 0x19 and later (Zen5+), as the kernel's synthetic ZenX flags
+	 * family 0x1A and later (Zen5+), as the kernel's synthetic ZenX flags
 	 * aren't inclusive of previous generations, i.e. the kernel will set
 	 * at most one ZenX feature flag.
 	 */
 	if (avic == AVIC_AUTO_MODE)
 		avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&
-		       (boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4));
+		       (cpu_feature_enabled(X86_FEATURE_ZEN4) || boot_cpu_data.x86 >= 0x1A);
 
 	if (!avic || !npt_enabled)
 		return false;

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.457.g6b5491de43-goog


