Return-Path: <kvm+bounces-45519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1CCAAADE1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 623761BA700B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A084406C0A;
	Mon,  5 May 2025 23:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ubDIp70+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC952FC11E
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487458; cv=none; b=khL1z6uRKxVVQfoPL85HRbOc1MHoh7YrVdcJXXAc71vHqwvO8/F802H5axSqH5531JrFAlPsKzV7aHAQq5P63wMy8uEGAZjtSJL1xz9WRCSI2pLdfuKqE3+pkeUCN3lx780DQKdecFY02wtnywLu9xT/8dmtKORKC/JMuoUjBmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487458; c=relaxed/simple;
	bh=bS+PuU7N/it8Gj1bWtBWkfaiz1D+U5dOInbuqnO5WsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR83Hj4N42ecMNlEygn3TLjnbhNQRJbyBgTcRaPnFD33JYbgM4EfX/aS2TJkwUd7G7VaEpA01/nnLA0/YB9Vd7Bo2K7Rt+8pDbupWXFVu0r0OdfQB2Ilp4yzw41TLiv7TG9E21NR77fTJWyybJnWmykgn8eVG2nZGxnxRAbLfYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ubDIp70+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224171d6826so73702325ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487454; x=1747092254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lxiqm18+sn4NfhFWpGsu8e9acXNWibaUDGV6AOwg284=;
        b=ubDIp70+Rb2xy79FTtGZ8ZcVhPaMzcTRKwqu/zw7fzs71+nvBJu4Ywcc0dzUJZIPdm
         VCrW5iUFzA4hi+fPMxQRe8RccESgpaWQiIFPIuGWUVbpSf43DNRherJQq6txVTNbiPrw
         UgenT3K2X7vLXC4rMY/3W8tNPX/4iUDy0ViHrro8PT3Wyakk8vNG3S3OOawxOlJBOa0B
         TD/cmqLQoFWMIAPqdkv47puef6jUrWhGHN4vZ10YLGsb+Bap0BC64UufseQ1+gp+ghsX
         iv/jvgBLlouFh68g10krnHL1I3QW0JnsbTj9/BCvF39APMKRbcMvktjP5q7nCVjhKKyA
         T+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487454; x=1747092254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lxiqm18+sn4NfhFWpGsu8e9acXNWibaUDGV6AOwg284=;
        b=J3ZEz/jrZfTXMDER/29IO5H2yPFlWHW4+0NBwUHoGEIhllgBeIZ1sqCBvVfa+bAUrQ
         morJU7q4I6dZXCOwgysC6fUSaLAJPqoFUMXARt4fKXGu7rjdTDNhMJ2RUsLceeY+DgOd
         QAGRwyP92Cjy1KtFN5gwuIp3H3bW6S9R5kPsRDD1l6QZEXUU5DekpUsGgrgfF6R2w+0E
         e5JJjAz+yQL+B1vua2Q96hj/WBRTJiZ2mz5L9IDTvRyAwZ8QgOLWcyLOXwaQxPAHzkjX
         voNLA3RZ1xO866p2hY/k9JoInAloPR1PnETwTzWPHm4EjaW9PfzGCZjETgfa/n4C7XMZ
         EJXg==
X-Forwarded-Encrypted: i=1; AJvYcCXtQP4BZKmvqamqniB2NubOK8fddJeapqTn9rvG3xNDdRpbtyFtU07dSl9PeyHdSQll3ds=@vger.kernel.org
X-Gm-Message-State: AOJu0YySuZ8WousdI3A4xgeDGx/xt4G4cmhTSkljOGyjnN6JClmAzC4w
	npOpv07zYSCP8YBSQX/yN7H9ptetXkUmb8vaN6Waq5u6DHeiE/dvuAKSd5b+Pes=
X-Gm-Gg: ASbGnctqO2OIXwM8Wc4krTteoO0kUtZULcF0NiA7g+LWFmAu1YizSGrx2zOhojopbGf
	CXbMve/eGuE1LDDHcjL65eL6LoDPTpM8wClnT3kQu8R5KZbUsUfQrkpa2hJx5aI5TDKSXRMHB4L
	Le/tSTww2pyJ0gFfh8ukiZ0r0SBDMolUe/nj0sjeDCVrLqu2B6OvfPgzv4XHIn60uaN4ZSotFBa
	GOhRyG+CR26KQ0maa063UsW1KIhUC6Uy8SFmXi/J2Sg183lZNDUnQh+onkZxuu3I0mQ3mmqSdvu
	f085J8Ygmi7xEQOnlzyqgbur4D6+cSiYiBOzFOIH
X-Google-Smtp-Source: AGHT+IH+n+7t3z29C7R6sRRD9PrLWdyQFgHaAF6qg00b9P4xkufJ3wIXXkW4T544/tooWyNTVIcfsw==
X-Received: by 2002:a17:902:e54c:b0:215:7421:262 with SMTP id d9443c01a7336-22e328cf694mr20675215ad.12.1746487454294;
        Mon, 05 May 2025 16:24:14 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:13 -0700 (PDT)
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
Subject: [PATCH v6 47/50] target/arm/helper: restrict define_tlb_insn_regs to system target
Date: Mon,  5 May 2025 16:20:12 -0700
Message-ID: <20250505232015.130990-48-pierrick.bouvier@linaro.org>
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

Allows to include target/arm/tcg/tlb-insns.c only for system targets.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index ef9594eec29..6eaf6b3a04e 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7763,7 +7763,9 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_arm_cp_regs(cpu, not_v8_cp_reginfo);
     }
 
+#ifndef CONFIG_USER_ONLY
     define_tlb_insn_regs(cpu);
+#endif
 
     if (arm_feature(env, ARM_FEATURE_V6)) {
         /* The ID registers all have impdef reset values */
-- 
2.47.2


