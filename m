Return-Path: <kvm+bounces-45501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B87AAB02C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 771F57BCEB3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19DC3B1987;
	Mon,  5 May 2025 23:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jz042UZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD3D3B28BE
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487249; cv=none; b=SQ4sTsmDQpy6TkXrJyTZ1pLAC+oaDIRw1s0mQICca3tOt7DgaEgOl6zCvsO0B8X0Rc0D/GkesOBPvcTb1JbSqE3GTU1EaaV/Sbou2TYEwdvDdDnO9l9DnSa6cXkQWt+usPu2SbbvAq33lzLc043Q3cQzk/L1zjPpcIhTrCWlC0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487249; c=relaxed/simple;
	bh=jBQ48UUiTmKfd2YtIeycQ+HfzJJ8p0Zs5JvaTTN+QW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4vCQRIQFEw19GTuhS5oJil4zx2GudZcpBW+PllyUN5XyLUOiA0rHPwRpL4OenLb6bZsZhD3yB0icnMkOQJIKEdJbD6fZa8vG234GLHGB77RBW1YtfYa8JRDnu4HWCFTpJw0gvVL8FdrPhGUJiqedAQgsZQuZh4Zm61sEhJPpXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jz042UZA; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-223fd89d036so56057665ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487246; x=1747092046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=Jz042UZAo0Pude7okTKMTufJTwE7EfcIFZnH5R4bbhOR76s72BV+Kj3TcOo1DjQkXf
         XNBjY34Y8pZzO05tkjAg6OqkzCuSIovoCp4b9OAdBfueolK2HmUbUVIr8uQJu2yWajIj
         f+pGSjPegWVUsn//h/H8YIUiwfJXwGObIu2Z7S7J5sR5/9O3an2NtJlYSnRQoq84g2Uy
         HVeMtYFkPsNaWt/9LVfKfLiNXRW+13lSgUdHEQzoQMmzr5dHkTOX1RWXuFXW3OOoF2aB
         twvmdoCN38Re1qXhT+5v1GUvwkUOHMI92aeIXkfO5jcLpLXT4kI3t6W/Kz1Oua1KXChu
         GKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487246; x=1747092046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=Xh/AJlVX/0l7qcAH8heFHfnRSFjd8iaE8Z6QuQHaoP6Q+8mUqukQPnmUh/fVqJHkPF
         c4WCrFnXNtVPGD6sY9+LOs3o+UBXldWVsxF+z3iLQWdfp1WdgNz8NlZoZFGblq1rY627
         rQAxld/bFHanM+XCy7DbY34CM4gh4IwECkwB5dkSIiM//wmkRVnO7IoYDUjzlWCnT76m
         Bh33tBmU9GCWC8gVsI9MjMAxwC4Gx9vw9yXIz3xkMNgXrkNHVllYEviKPXr0CU8h4RdC
         PE8/mh5q9g8v3P8xgTn6g3ZwDs0YuCgG00rsMx9WKenj0QEkO3sw9NpXGakT9T5FYtG8
         KzdA==
X-Forwarded-Encrypted: i=1; AJvYcCV2zHkErNi9eY+Bbpv6j5rX1Ws3pmtC/jx+bZ97ise2HxHp+b9lwv4NoSANBwdUJsLh5FQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjYtgU4t++RTjRxKltYSgLbC4RLHCj0u7JJgJHHP6I/V6+9moi
	nlkr9SzVrgcNlKaK63jsQXexBhdrpy9eEKwalbSmN0fPzueGyl+LwiZzI2hIOr0=
X-Gm-Gg: ASbGncsCstA6BGjtJioB/os7IZhE/IKSIn7clZSF10kGfDtZu/oPNQBViFy9QxnPBWd
	+3xlKbHIAeyrnNj106VZTzuUfXLk52hP+1tp3Ng4zDBcZS170letLFXwVoynybdxlQnuH0m2Bxs
	EjpOIxtEA6amxri0Vsz11NKCsO5t3syPZDGZu9k0pyk+vSCGW24KPQr1gnEjskeXM0iozPrc7JQ
	GFGE8D7hGwwWQX4Ti12IooUyCplt9zu2fLSQhXOK7dvKwqIVLDZVOsLAonZgiE9VOtR89yPDeg2
	xazDgGjXcJKJUxmw3j5QfbRODW3beXS36hRaeqeI
X-Google-Smtp-Source: AGHT+IFNUpBxaxlaaMr2/wMPpI/FmXGW2lNuJg+7HXwY+aLS43ce6Bg6LfXYfcUASH6/r3st2BArqA==
X-Received: by 2002:a17:902:d2d1:b0:224:2175:b0cd with SMTP id d9443c01a7336-22e32ba0bddmr14905925ad.26.1746487246254;
        Mon, 05 May 2025 16:20:46 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:45 -0700 (PDT)
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
Subject: [PATCH v6 29/50] target/arm/arm-powerctl: compile file once (system)
Date: Mon,  5 May 2025 16:19:54 -0700
Message-ID: <20250505232015.130990-30-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 95a2b077dd6..7db573f4a97 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
   'machine.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
+  'arm-powerctl.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


