Return-Path: <kvm+bounces-45514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0EDAAB00F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D73B464128
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8099F307202;
	Mon,  5 May 2025 23:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nciPoCUv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056953B3593
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487256; cv=none; b=OxXxaFdYmDaCvrisNWFIod8Q49ipLt6yoH5Z/Ayrjnm9IU2P1aN79PDcoE1EP6tH4eGQWtNlZ/WTaLOldmppJ+QROdSc3Zi5QOTOxTuUrV5wt1nyp5Si9yK+6ONow3CumLcdr0uQ7JuHeireCUiilEKJ8ebzaLzBapBE2xOAGHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487256; c=relaxed/simple;
	bh=DL8s2PBLHUk7nnU51Iqv6TagZNVpZyAU1f2RZEfhC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9t9ATxUcRrovBPaZL62BoV6P+8iPAnXM41Gl90prGq1IN21GZS7ngfD6eDAdbCNOOAm3WWLRpXk0P4GmuPjIPLMM/hQpYTX1f0sBvgi6ZgNeDjm8BsV5Cl0v7YdT9G5eZSO7UJGLn320VPmw9LrkIca0s05k9Wh8KNa2FbwmKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nciPoCUv; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2241053582dso75178185ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487253; x=1747092053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=nciPoCUvOpnt0LY9ULH5E9dcj+kH4tivVY34MlCsA+BIJC5Hsw5A4i1VuGHDg9b6MQ
         juLiD53MVkRxNLBWjPyo0PCKDUQN1IDfDSF0WjHlSfZw7wPnWNINaJvKYeVTlSrNNf1W
         ZjfnaThOegYrExvG7yP3K91gNNNQoKGA7h14XMJkfAbBJwlR40U/Vt+qPzUr0mGD6eO4
         JxG0CnOCn6YB8SzWyk5JGvqjEU2Kjm+9NF3oyUY711eU+GMRkzjldD6Pxr7T4T8t0CU0
         yi8t/mnjIkZwAFBRlZMjcR6UOVRH084shJ1k6vLKi8GT7NRtw2CtqtevIMeRdmlh70Y0
         hwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487253; x=1747092053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=sr7fAUMyNYi1Yu7DPNUgbLa/OZ3qZ38kIx/uEAr5wS27pdNx3B6gN698Hu70w/Z+KM
         jT6nT5gtbTnLSpyFKpunqTso8Ypri4zOuSak6yN0P8y3YEiRBeXIi3OiUE+4MO6Zo/z6
         BD7rNG/4b/0oNGO0HaqqXpjoza5IyWBGWs7jj45ZwqMu8BYwMMK8TQ3Bl4TqZ+P4eLnF
         EuvJ4OsTNrgp/C0v6sZr5mMs5nGvmQCD4By4wlCLXpvmiFUAuNEFIXICPFUmDpvVGadH
         JE32B0WoT9ZycYWJCodg+W0890szlYQl1mfuyy9bizcFaj8jsF7f+YvLyDwdmEhOS0mx
         fDGw==
X-Forwarded-Encrypted: i=1; AJvYcCXtWvsfMUr5gW71VtVqUq3JT8tOB0cOi1yif5XjKIqIvXrmi7IXvEnKhwr1VHa3Z5WB1UY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4YOHJQdAUO45NPutDCoqxiMZhT7xpoBq0D/eM02bJKjZaO9kV
	+wvpniy2n9NnMfl6RboMCDcJichJVko5wPi2eKkO5g4VhFVS0+Uyse5mJOhQMeA=
X-Gm-Gg: ASbGncsr42k8sYUhSyOc59obQ/6yk/zPYtXMHXkKXEXx4UQsKQjHLnynkAxdXSMSISQ
	RSszotubqyeIFGXkxd50ZmvLHMsG1v7jl7uTkbqBpnHFYHRhFxT28C3FVW4otCx7MP48td32b08
	bvXO7GOLMoPW/2dI+jdCXbEJ2ZnTQBNzYPHrogU/w8YKrcHQc1H0WYzCiouamrXj36GAtiO7//5
	akrJpwkXhEjFNJOlSorTrY1pFghioM6f0vLZEKN+0CpBMTlX4cebkqwNEdiTLbeYCoP3jhOvfMh
	7/xrGm1YWkR8DUjcVEgVW57xn6AJnDDknWYN+B3J
X-Google-Smtp-Source: AGHT+IEQz1uooxmmnU26y3jx3diyYO9Qb7x/IWS7jSUjRxMekEpaYNdIascgkfukWRRtAFkV+bb+RA==
X-Received: by 2002:a17:903:2349:b0:220:be86:a421 with SMTP id d9443c01a7336-22e32f00884mr19329055ad.38.1746487253295;
        Mon, 05 May 2025 16:20:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 37/50] target/arm/machine: remove TARGET_AARCH64 from migration state
Date: Mon,  5 May 2025 16:20:02 -0700
Message-ID: <20250505232015.130990-38-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This exposes two new subsections for arm: vmstate_sve and vmstate_za.
Those sections have a ".needed" callback, which already allow to skip
them when not needed.

vmstate_sve .needed is checking cpu_isar_feature(aa64_sve, cpu).
vmstate_za .needed is checking ZA flag in cpu->env.svcr.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index f7956898fa1..868246a98c0 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -241,7 +241,6 @@ static const VMStateDescription vmstate_iwmmxt = {
     }
 };
 
-#ifdef TARGET_AARCH64
 /* The expression ARM_MAX_VQ - 2 is 0 for pure AArch32 build,
  * and ARMPredicateReg is actively empty.  This triggers errors
  * in the expansion of the VMSTATE macros.
@@ -321,7 +320,6 @@ static const VMStateDescription vmstate_za = {
         VMSTATE_END_OF_LIST()
     }
 };
-#endif /* AARCH64 */
 
 static bool serror_needed(void *opaque)
 {
@@ -1102,10 +1100,8 @@ const VMStateDescription vmstate_arm_cpu = {
         &vmstate_pmsav7,
         &vmstate_pmsav8,
         &vmstate_m_security,
-#ifdef TARGET_AARCH64
         &vmstate_sve,
         &vmstate_za,
-#endif
         &vmstate_serror,
         &vmstate_irq_line_state,
         &vmstate_wfxt_timer,
-- 
2.47.2


