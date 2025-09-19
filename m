Return-Path: <kvm+bounces-58218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CA78B8B6E5
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 084A1587E23
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056DA2DC323;
	Fri, 19 Sep 2025 21:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I59G7LgF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C92D9787
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319187; cv=none; b=cVlwcUkuLsagSKzUOsIAdxhDfdPmF0y0UxbPHCp26EWuWUg2JDpXfhpepCLMhM0f29b/EvaLL4kTgWa4vuQY66DEPb3pp++tiuJXwRQ2vDGHLtQ/hlFk2gvIwgoaOa6tZ9hnoJ+3ZnXJ6a/mZ0cRhoy0Np8DmT9dnKBCNk4W4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319187; c=relaxed/simple;
	bh=LQi9xZFZpomwVS1kvlserOTepF/O5+6tFGi9AO/emJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WQdI4q15wDAB8Im/8Y/Mr4W6HPFIxMqB4iXwD8Bp/hY7tdANzd2wBy7MjZ/4QtGv3aWF2t/P63/2HLtktZnjKAWjxOhHNBp1r/ee/jDcW3sMMB6eRhLrmyNfl8YbWHp8sw1QnWmaagx0q+trgyel1jBhKmo29NC2JG11sUomSRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I59G7LgF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32df881dce2so2551949a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319185; x=1758923985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pqISDS/kdSq21LbwitCJHTGhR/0duoOZRffbBWrHzYo=;
        b=I59G7LgFSU217vy7Q41SZ5WV0+mkclH6BODGm/U+GgJjk0YVe8hVlDwv6KHFWi0mkp
         jOAr6HufxfbEq+1GRkvjvD1WkuQrF+OQHRcVCaPb6huKKaxY9eTU8QVsKjSPuZqnjV28
         MJUskguXy6YZIGDnU+YxOP5IqckE9L0IQUemqiW7/8bA5W0BPgdwZ5f4ez4cEFOwH05K
         AZ9nBr8UVjqztlx8BqMppAT0iGH72wPZID2i/c8fZuowSUGGo+G4XAqtGx2tHJii/JP3
         7RQzbC75v7qz+c7CwidIjAXwWSeXq2ocHl2lM9GIxqE9zSBbbXsBweqb9CTFvRDhO7L0
         xf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319185; x=1758923985;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pqISDS/kdSq21LbwitCJHTGhR/0duoOZRffbBWrHzYo=;
        b=aO5gT4pIX0fwAnFY2wT8hqavfReJl6c8EkgXX6Kbqmy0m9PEmwYKm6CllKKNk1mdhM
         +XLXuyduM+fTeqNf1hPw0MpyuGH8Ns1p2sGRYPqEEq4nDYNhf7A7fqCHrl13RD/8TLi9
         Vdbr4vKYf5sNjpGoMdgsgTXIBc8OoH2vFAFQRIHXHpj0zuyCblYxLGmGxJqFVk2LGoNL
         +N+ThGLMTvEvYmezoNIUBV92yAla+RyxwyUFGPG26R0UIkO0DhDGz1yptUmf27UhZEAj
         Jr6cdur0mCZNHpoDDnir2kMfvu3tU964ALPVKz+ngeMiorxS3vY1QJ08s0qgbOwxWS1C
         dtQg==
X-Gm-Message-State: AOJu0YzrONLRjbm+vwb7rzp0FekTmmgzoyRE/Bk6VJvYds6o5pt216ha
	fRn6qpWVbdYG40BPzZutoWkNak0r5dkO9PiisyWywxlChEDESwwMnyVNZrLiGvyvg+kHpB+UXnz
	vPZ9ekw==
X-Google-Smtp-Source: AGHT+IHPoIDEaEZaUDlf/9uaqIxYyi54zNnK1cgCZ3hFN7LH8DrptV6OdXw09GIMUxInl+VeFAjptl7+3nA=
X-Received: from pjbsy5.prod.google.com ([2002:a17:90b:2d05:b0:329:f232:dac7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c8f:b0:32f:98da:c397
 with SMTP id 98e67ed59e1d1-3309834b504mr5751177a91.24.1758319185101; Fri, 19
 Sep 2025 14:59:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:59:32 -0700
In-Reply-To: <20250919215934.1590410-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919215934.1590410-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919215934.1590410-6-seanjc@google.com>
Subject: [PATCH v4 5/7] KVM: SVM: Don't advise the user to do force_avic=y
 (when x2AVIC is detected)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Don't advise the end user to try to force enable AVIC when x2AVIC is
reported as supported in CPUID, as forcefully enabling AVIC isn't something
that should be done lightly.  E.g. some Zen4 client systems hide AVIC but
leave x2AVIC behind, and while such a configuration is indeed due to buggy
firmware in the sense the reporting x2AVIC without AVIC is nonsensical,
KVM has no idea _why_ firmware disabled AVIC in the first place.

Suggesting that the user try to run with force_avic=y is sketchy even if
the user explicitly tries to enable AVIC, and will be downright
irresponsible once KVM starts enabling AVIC by default.  Alternatively,
KVM could print the message only when the user explicitly asks for AVIC,
but running with force_avic=y isn't something that should be encouraged
for random users.  force_avic is a useful knob for developers and perhaps
even advanced users, but isn't something that KVM should advertise broadly.

Opportunistically append a newline to the pr_warn() so that it prints out
immediately, and tweak the message to say that AVIC is unsupported instead
of disabled (disabled suggests that the kernel/KVM is somehow responsible).

Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b8b73c4103c6..35dde7d89f56 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1154,10 +1154,8 @@ bool __init avic_hardware_setup(void)
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
-		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
-			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
-			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
-		}
+		if (boot_cpu_has(X86_FEATURE_X2AVIC))
+			pr_warn(FW_BUG "Cannot enable x2AVIC, AVIC is unsupported\n");
 		return false;
 	}
 
-- 
2.51.0.470.ga7dc726c21-goog


