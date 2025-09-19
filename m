Return-Path: <kvm+bounces-58079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 904E1B8776E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 532534611AB
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D7B254841;
	Fri, 19 Sep 2025 00:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L16eSsB8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B48246781
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241307; cv=none; b=C8J05aro7ycF9pQhd/IokfE5/VA2qEul6KQIsPQQDd1WIjwDoO9J1hH8rGj2BrDjW3bNCUJJzBRRxhqM5aaVPBaAZAtlu3Bu9dczwWilYIBNYxk39Rcn5CS5GCqcboJeSQi76UInjRkqeP9iDNVusXcCRAoUtWvMKFzqQIuITjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241307; c=relaxed/simple;
	bh=uR8EWR+aR/ZBzhlH8PMTT7QLPFi5Y9kpl91tdSjqO/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GjsW90+mZ5+NuBlqg4atX5WpfeT3K3/+eAqgGihw6lLU07Zk8qjuiuNfHdJc10Ba+3oARlU9e4C2ZxIZI/OMJfg8iRIBY9xdZ8O6+HBzkBd8yLf6ZGA4r9vnaQ1wmizHRIAzOyartEdUAihb9Bkz9svb2a4MsfFQUd0Nt9gU+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L16eSsB8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so1307338a91.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241305; x=1758846105; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kAOxtVdYXlNFHXrxQs4hk1M8tgpSADrBdmDcGNSV7fI=;
        b=L16eSsB8elsrieiSoKvK1W6YuxUwAb8wq/kzKQFC5Jd2rCmgfl0Q1NlHF2Aj9F1xxq
         MxI+DowDvLTbkgK7HTXZ5DWX/Bn8/8r5CgswwTut+GjIN1Mq3LH0Dng2zIufRhrffGGB
         qFDcsdQGCNDkVVwIX+l62byJSQvLlG5XXpT5ApFcXTPh+ditSMSw+MrAxIvg9A8Syq7y
         hwoNnXXSuVVI4/I0HOBMQrtpmLkaUwVa/SRyA9SvqVfeoirpseSqojUNFE0BZoDpqNl2
         II8GpZEtFIq5vp47rr3QoqaZMlZYOhbOP8I985pMTvV94oue8m3+7nEgShH4toUkUT3i
         q2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241305; x=1758846105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kAOxtVdYXlNFHXrxQs4hk1M8tgpSADrBdmDcGNSV7fI=;
        b=YcX15TVGwyqMIQpFIAuYvhBq+vyM5bDzbjfRbFi7+Y7NpcM3g7O6o/6Gic+gSWjj3p
         w4eGLqTSgNtva6tboxEifBZEI5qxKUbV5y4ppVgvkQSGWsSg43Rd02/12BBkmwMAx0ii
         PZ2WtMbNnU/aDotvz6GybdPsKGxDwV9vlnDdv32uF1pFHfSrbl5JyRjobMvf1SuS1Q5F
         XPTatvTLmsbCca09807tL5J4KurvG64xUnHJIK4wsZX/YC/BY+oVxJhcNYevwyadeqMn
         Qt4Jvei+qOLOzHvJ3sbc0Kyp0dHec4mCiX+glGBVELPU8tcqes2y1LIN4YDnIoMytD4K
         Y+xw==
X-Gm-Message-State: AOJu0YzbJ+FCQuoGaNLE525erPNGVPVgLm62bnGP8ZSERuI0vbb5pH17
	nUO6D0025H7tUuhTsv0ix6696k+0RoWfq5JAKXYUPdjMUYmkacqRLfchN5MefLOHv9mLg3JXRaS
	RieteTQ==
X-Google-Smtp-Source: AGHT+IEbLmauAmVJ3kfuAJUo2uqSb5YOltEYyw+1bKa8JZGv5ZAIj9GTRGbYYMv6m8PEfzurqfv8GLwqOYU=
X-Received: from pji13.prod.google.com ([2002:a17:90b:3fcd:b0:330:6c04:207])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e12:b0:32d:fcd8:1a9
 with SMTP id 98e67ed59e1d1-33098385bd1mr1332845a91.32.1758241305547; Thu, 18
 Sep 2025 17:21:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:21:34 -0700
In-Reply-To: <20250919002136.1349663-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919002136.1349663-5-seanjc@google.com>
Subject: [PATCH v3 4/6] KVM: SVM: Don't advise the user to do force_avic=y
 (when x2AVIC is detected)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
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

Suggested-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bafef2f75af2..497d755c206f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1154,10 +1154,8 @@ bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
 
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


