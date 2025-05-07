Return-Path: <kvm+bounces-45802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 598DFAAEF84
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 427BE9C2260
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE23294A0E;
	Wed,  7 May 2025 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a5aYOpQw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEC2949EE
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661396; cv=none; b=L7ShKTRNkv6ZAXao0XnxZcY8Oxn08VyFKlW/9vC+mCEBUkxUQXBbvDNqgNsSmiMUq+Tf/FbSnH2OGCdvvdDjMacfwTHSd10qsR0Hzi684HBZfi5fEnrf0Z9v8CQUNMMuN9LgbirhcEnDaeuHJcaB6+QpyAiWvB+WrpyEcHEGfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661396; c=relaxed/simple;
	bh=DL8s2PBLHUk7nnU51Iqv6TagZNVpZyAU1f2RZEfhC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCYI0fnz3dDlhiqw+qO/23ODnMYa/TLoGBh/mKf01Kegf8t81ZuuuQ6WElP8mUyw/5BEhF64eSmyJUwzQzPcsVV1oMu180R3mlkQucc/abdKxgvLe7Izy5fvl1oK/C5ch7luExdad8bhfSd4rzGvq84B/qUxiJnp5QUwyGNTizk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a5aYOpQw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22c336fcdaaso5165875ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661394; x=1747266194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=a5aYOpQwNv8Q086+RJVOMoFt0CBSRYWQ9Gh6Nf/v2gqliUdphQmobJUBYlGRn9EmbG
         zn2Pd9fGAntPwzt9mOyAxuG1njS9Sr6ajHToaiOqDB4l/Bz0ltyFeWmho1YOxTz3XPF3
         lcdUfOhHbAmIo6Ue3t+QAnpb9gX3jbplMxjezsOElGWtGAzlXbiOjPxAbQYdqzNs6xme
         LG1Puags0lOSnxAt1c7CPdvzOVjyHfzTJ4cwB+Db9jDRzcPD1yo6tdXMSWREhstNrb9X
         OaJaAXcu1mOMPojipB/yyBA6289pivSpyzsZ5Uqx8kOQBhU/3iyDJuEPcOka+xDuViE/
         6SOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661394; x=1747266194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=kKGB7Yc7N5wPGdQFgi6CMMx2kCN+Tdmf35qgZjI90lh3POJrwBkKXcaMjn9qGsuPWY
         Fr6JcZ/WQTBt7CwVpfRAjb0UxW7mxwYwqeMfd3xLsxgXidx5UaxDvHr14uKm17TS/2ix
         Asn3zh1NBoSrpWRvHm8mziQf9E35YCVhlUNJc4G5h8gvHnb5OvIJ3KUW5XGn5SjZoryp
         HCHzEATVl7gIqFw25zC0Tn6E3pjd9RpGzL5qLhpFFnWbgv5U8ekHL2xRe6MUvdE0qC/2
         nw79U321n7C58hbIsjmffmUdXO/T1/9SUPBjDqQDXC5lJ456U2mEiASKnOc1D4wAziXD
         n7qA==
X-Forwarded-Encrypted: i=1; AJvYcCWKJT/kZEmdpF4nFXywjHh7KrmxrilUhsC2QKL7xrxOgUwDLVqgnWRuFnlk+HXcp5gZQKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYBtCryM0lwfm6S0TQ32KvDTIeIzbL0+sa4lIweCD2FCUwsP/F
	4QUQLCBF68/xnKlQ0Mnr64GZg06jPEODg2nMSdgBgx/BLdDyf9xF5zZggNRSoJU=
X-Gm-Gg: ASbGncuOuvMu8iHOPqQAjIgu46xtLiGI46ttYZlra2P40gewZOdvmXjxXCiLExgnjV3
	Or8GRmAOIK7TZISV5Dt+sL0lG2zM4NnqbeyOuvMZsd2wpgyQ42e5UIDM7c84yEl1KOX40LM8BY6
	f4elb58DdXqGUPcY/MdYdocSprBbbhcvxVCM9A9Tk70ByrxZlH6J126bc8LJ+8m6DS9HSbApJAh
	Bum9eG6ZqAO/M6XZCTNMnHarej/4KVSJ4+OeA55ntvL1iel9lyUX01lu5NNZAGML/OAXgeJfVi2
	xuHqVFYDrsdlbRaZR5PqUp0uh1f1iTQG0duraVNF
X-Google-Smtp-Source: AGHT+IE1Ej9xQIKVi4bEh4Jp4+ngGN9vsmsLRr556ET3roH8UN+f1PsZNybD/JH4J9gY+Vdhv/Zo2g==
X-Received: by 2002:a17:902:d4cc:b0:223:325c:89de with SMTP id d9443c01a7336-22e856138c1mr20161595ad.1.1746661394133;
        Wed, 07 May 2025 16:43:14 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:13 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 36/49] target/arm/machine: remove TARGET_AARCH64 from migration state
Date: Wed,  7 May 2025 16:42:27 -0700
Message-ID: <20250507234241.957746-37-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


