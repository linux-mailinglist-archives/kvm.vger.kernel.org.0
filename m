Return-Path: <kvm+bounces-45518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B412AAB0A6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C15F3A4254
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1D128FAAF;
	Mon,  5 May 2025 23:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MJ8UQlqC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BDB2FC0FC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487454; cv=none; b=n7r8GRcKPs1U2A4ia0Jn/PIp8tZpo7ibcg2wXqLKo8C9eoIuc8I6ORcXM9SXB7L2GdL/QoUbUzbYFTxf0eFY7A7AnqJRH7ddBjFLrFCVbMglPrhBgP/BwCSpXXVhmqNAG1FeNJvIAlf4dKw9r/b8iyAy4YqpenCpHNVVWmRC45Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487454; c=relaxed/simple;
	bh=GS+LpiUTrwRekFuYztpgtocEnVpEtfVgbqHCILtV+eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7RlVxb/T57g1h0VrdeinT7rlWzFm/5MeXj/x3LZLSbI0HchqfHeoZuk4ytG7zUA/Ixeid9c/8+nOnmmTw/f87v0ta1L5IybLSQklPnQGVZ3hz9LzUHSQaUJb8oRQ3gdsudBbdhhLYdEbXrU9UxeIIB6DeuXcpf/l2K7fYw29gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MJ8UQlqC; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224341bbc1dso65421905ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487451; x=1747092251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wE+ks75IW4zuYyzk7c3HX2M0GM7VkI4W6D0uip1dkOg=;
        b=MJ8UQlqCXneWTa9a9du9Mg7FAzDvXXHxM7wRLFOExgKLK+JnE/qn09uBQGM+gZYp+I
         G9cdRG0bY0yOJcry+hXa3mAt3wuKGCA6NwuJyJmd3VTHP8MskP+PvQ/6XWYFm2pTEEa1
         G1BnZCQSXgVa09pjPpFWWyTFeRwcJmIK3Z/eQ4B3jt2DfBXkHs8nmQdBx98YRAk1jKyI
         iF6xOJ9R3GcmA4TTxUYK7SyXpvuDFM6IYcnwNjrQTCUd7r00rn5GL1lHc1tY0EErv4yS
         ro92oFbEqPLeS+hEQiBnZh5hGscGf//qlMGjPz0ogT+IexbMAH/8oOkEUCegBA9kofWB
         YX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487451; x=1747092251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wE+ks75IW4zuYyzk7c3HX2M0GM7VkI4W6D0uip1dkOg=;
        b=MKVCB4imDxPOyu49MF3HJn2yyd2cuJGGrEhGauRvFJEgkri64LMJme1x/SQwV3GZ9N
         7lBKvGFlCF7cLfAdFhWjmJZQP15uC+MpbSkf8Jj6DkcLzsuSxCTIhUp8RUQz0kEJTInM
         bAkNA4iV+d9AMLqN0xnb2LR0H/VhAM7PglfPYclkN17MMgR4lkHOSG/Q9TNKDD4rXEet
         mwdoc1aK1p44TszVwnV0jAhQcLY1ULs7NWZa7jT0tseUkxH6SRDUy+5UHp6YRO4hYLCx
         E7nZ9v+sXf+QgkSllIFi9am4pzFqFxVTdFmIAm+gOKc4cXshl+lPbrPWMHrifQTCeHwo
         bgeg==
X-Forwarded-Encrypted: i=1; AJvYcCWhs82HpYQnROEXz/WlETzoraQsMnVCjeg1NppgxRKw2k6X5wiQ3Z7aF8uN5v6jb1vnyfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoA9HEAgsnbUaQi547tDkyXT3E4dLKb7X/5ZQSPPOBRowzaxqt
	z7k/kxi0sPnLpxEaSo3BqkqH6swzdnPuxv5LNhNG/i+bQ1YipQb60VqWW88O9E4=
X-Gm-Gg: ASbGncvL9fxGcUbC91czgZghbh3wzfIKFkE86R5hahuuU10WpEqZsVn8gkytkRd19am
	EqeXl5gW+y8HRQvmjGV//fjh1MnswhamorGwMGAa3OeyorAL2JeB1bcLEArR5Bq3hbOH2nhu8ZA
	kywm5Ti6seJUqLOsSK90jvfxe4KtyrmPGd3wcURhbaBfBgMmRuv8LKC7jeW6bmzKLm/DDtOC5YD
	bmlwfE1OXfT42ewX3CaYBKqIcBWtP/3AbwK3lwOqRmQwi1bxKuxi45aeMVfnYtRU/lS3Kc9QKLM
	TpoVdiryyOfqUobpgOJ2V4Of0cyfYZvaiXg+1QuV03f//iwbd14=
X-Google-Smtp-Source: AGHT+IHFYgo3dGI6oymiueOZq/2WBNSFS6bNBMqt9jfge9pyyjbKnOcspVMZnv8e5GSJtvTzFP61hg==
X-Received: by 2002:a17:902:e80a:b0:220:c813:dfce with SMTP id d9443c01a7336-22e363ac721mr10768215ad.39.1746487450836;
        Mon, 05 May 2025 16:24:10 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:10 -0700 (PDT)
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
Subject: [PATCH v6 43/50] target/arm/tcg/hflags: compile file twice (system, user)
Date: Mon,  5 May 2025 16:20:08 -0700
Message-ID: <20250505232015.130990-44-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/hflags.c    | 4 +++-
 target/arm/tcg/meson.build | 8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index e51d9f7b159..9fdc18d5ccb 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -9,9 +9,11 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "cpregs.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 static inline bool fgt_svc(CPUARMState *env, int el)
 {
     /*
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 2f73eefe383..cee00b24cda 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'hflags.c',
   'iwmmxt_helper.c',
   'm_helper.c',
   'mve_helper.c',
@@ -66,3 +65,10 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 arm_common_ss.add(files(
   'crypto_helper.c',
 ))
+
+arm_common_system_ss.add(files(
+  'hflags.c',
+))
+arm_user_ss.add(files(
+  'hflags.c',
+))
-- 
2.47.2


