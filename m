Return-Path: <kvm+bounces-45310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F59AA8400
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A91417A0A5
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4270519D8A2;
	Sun,  4 May 2025 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ziqVfzcZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3A19CC2E
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336578; cv=none; b=FDgMB7KuwbUj1VxwtPbyeu1KriEaP5jzP4y7TwVStf0KqlF4w//QNHOeDIuPuni+bhjFAuIcvA/jUtA2hVRgNjdAyg3xB8kjWhbjflDWsRdLREzgskrYcxUl7FmQf7ziaZ0dWz7pUuD252HtU5fQM3EeYnRwnP8CiAmhSuMhH2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336578; c=relaxed/simple;
	bh=ml2TA0vrP9neaHTahuIEL5NgcIVEpZ1CGdXaGOWH+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyBmU0zVNTG34dukBwScDhoVbIV/80Hm97wLlGJDEQ2CYez/YmJibAAMAcdOQIzWUWi9tLV5aJzStuW+a9bzrot480VBJ2eXAQRceQO7g9kxQLUmAyanURXdD5lsCTQjIz8FGfIbiy752XkrhgKQpQS10U1AaqiDv77r7v0ojV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ziqVfzcZ; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-736aaeed234so3024245b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336576; x=1746941376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92Ra51BscJ7plqFLljDp4Imt4ck5QTPqHgH4Y/GteZ4=;
        b=ziqVfzcZ8jNH42gxl05CdkuiQEQKPrKarImqwX8+geXJd24xVGnlrD5VMKKsU9cmwl
         eqSd9sSPIEKC3l8kmtz7dZlp8zJqBaHJ4TXNfl/MRnBdtKqMHdgTRu89M/rl8BkIMwmU
         p0TwQqVqP/Ju18UzxU15nqSuBzChtbvposb4u/eiog0sj2zh2phuJ/gqez0D7W1W0SOD
         lrBPE3wY8M/d9BNWMXkWVHQwdLgDeY+YmUEfpwru1gP+ARceART8WnSihbZ6iBoOfoRo
         XGRYCrq8Z24AghhiNdH2xqkwquaoHXDPtWZ9wnNMYQTq7zm/m6tqwH2grsrvxXH6WEIC
         aWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336576; x=1746941376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92Ra51BscJ7plqFLljDp4Imt4ck5QTPqHgH4Y/GteZ4=;
        b=aq7AGJloJYRehfqtNwinS9HBCzhQinnim69bg4rulNkD/v09pH3mc/1ITxKeiIgii1
         HqywdBRKbPjw+01xJ7VqgNNWANd13qJjg6b3XmhW/v7s0hTTzk4p2cxG74VPVATXtIrI
         bm/rBTMI4fAGsyyoBJqVBcIrCyiZjZtfFRm1iULSYaTsdiTyTPYppj948jK/4wzlxPAm
         BbR0WQr6+hj3VyJHdiXalfNSxtFKJ6zAMuz5zkT+LUs3K4zL1r3Q9UcP2DAK9e+E3XDQ
         sISI59HqyGfZkXbN/JWKefslQdjTgJG0pgYDvY+w1apEU3m9tWZush9Bp73/s5lB0nbA
         cQNA==
X-Forwarded-Encrypted: i=1; AJvYcCVSfJRjs2n9CCAPQJd62IJWj+iUJ2+kPkcQ1Hf4whQA53Mg/HJs2pahrMWOjhyn/UgqprA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHYltkp8nceB+zZui+xP1yKLRS+I0sEms34BNxYpaaybK1xGXG
	qzew8AzoN1KYxHbH4ygJT8eK7ztz9WrYQyqUJhIBM9YshjUdRQ+T64vKlPfXdz8=
X-Gm-Gg: ASbGncuUg9N2hlwNwCahh+mIAgs5JvdbIWYIdpe/ZRMuzqp2olqfgv6Rs8Vuuaz/C5S
	jBDXyINR8W/Q1OgeiDcv7QC0NCVuec6f3dwkI+xLLBbjSVkQjDzkIBLmZeM5Mqyq3kYTKV7SU/X
	oZnCcS5MqaNdGp3kfvQNO7Azob0iehcbZRl6U7rXcJSdoPkmKwxel64IA8b3t9W7S+SqeXukf/r
	2BFLQ5n9DGippv5kpYd3nXLBvC1O7mLxNlJCNNn58n/p96bC6TNSWgvfePgGGRG1DIYNJkNdMmB
	5dD29aIa55tAQfPL0cMFpp7HWIuUv50szbqcQuy8
X-Google-Smtp-Source: AGHT+IHt0nxDsMjHoseXmw2UOIivIDWLffGkOy9QVpGII4Ziv7ZjjANeetTaX9aqaJQD3dqm3X0F7A==
X-Received: by 2002:a05:6a00:279e:b0:73d:fa54:afb9 with SMTP id d2e1a72fcca58-7406f0ace76mr4520291b3a.7.1746336576180;
        Sat, 03 May 2025 22:29:36 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:35 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 18/40] target/arm/debug_helper: only include common helpers
Date: Sat,  3 May 2025 22:28:52 -0700
Message-ID: <20250504052914.3525365-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid pulling helper.h which contains TARGET_AARCH64.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 473ee2af38e..357bc2141ae 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -12,10 +12,12 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "exec/exec-all.h"
-#include "exec/helper-proto.h"
 #include "exec/watchpoint.h"
 #include "system/tcg.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #ifdef CONFIG_TCG
 /* Return the Exception Level targeted by debug exceptions. */
 static int arm_debug_target_el(CPUARMState *env)
-- 
2.47.2


