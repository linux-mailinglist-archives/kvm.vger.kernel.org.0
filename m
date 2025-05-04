Return-Path: <kvm+bounces-45313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E01AA8402
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65321179FCB
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89B719D88B;
	Sun,  4 May 2025 05:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zWElNWBc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1E019D8A7
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336580; cv=none; b=jQFk9wDKqgw7k/R9YbCMtKKciF6YCIEkinownfeTIFxCgdKSqLXGEZSkLugAmBR4A4QWiCZfp6+fA73EdUXyOV+UdESNa+i0Rt+30+9BAu7FXGKQtU2bo3jPrnBza5dQjgwuxuYeBipPP2PZUuozZL4cXHzAv8Zi6FkOkUTLNu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336580; c=relaxed/simple;
	bh=wOIbeAJIuUXbVaGPlv6oNTk4fusBeiutPPBC8G5Ng34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsdCJJgcFsw6jhvkBBcrCi+l2IZKqAn6rgRMFr8FRgsv59eNn1Rwx2Mobw4IhLD1doF00E0/+f5yiTqTtGUfrbkdMUx96wFBTL2Byj3/U0ZWFfMo46h4xDyV0WBP/atx9dTHczJzm6De4e85NomLe3MDh65kou4CIGDwziy9IJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zWElNWBc; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736b350a22cso2834298b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336579; x=1746941379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86LVIOw/2dppRQJ4fgmxpMIcvI46MI2lVjbVrJNlYmw=;
        b=zWElNWBciPyFumO1fV8hMaoYI+vbgjJXThqMBTPv54MwNL8Pwz3NVfLjDLEcyRRtZW
         f3FRyJKj6Fr2UMfVMqpYuD7ArNIAsZve7Hx4OyiK/HJ6+oIaQK2bIHfb3G3++vpkjw7J
         nsb/Gs/pYDN49PQkKXNZBpdc1DMUljuHIxkt7cOOyM8JOQHupWdEY03vd2/XM6TaSRrN
         1piC+0y56/by7u7uFi03ajedxyAd6qDuliWddr/jFznj9cz8USliwK2CHlNjbnmC8Plu
         EewklL6E2ONv72HoPryenw9zLlOvj/VkSBivnXL4IYr/SgPDv4e2phPC5CWNf3YPtgSQ
         XNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336579; x=1746941379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=86LVIOw/2dppRQJ4fgmxpMIcvI46MI2lVjbVrJNlYmw=;
        b=TvRHogrgAnq4mvHGXQ0tOK5EVv3ydSnguyPfHzQEPhtyxzSeRWCGKNc2z969s4BnKf
         m4w+WVFK3LQpS/LRLDC4ThMWEpcsWqU6Sr5EIYNMv0NrxlR22bPeafSqFYpx+hWLw+kt
         5E3++/eU4iJEGCURO9CrX8zhhC6vHrsLM6xhyttyE3+CX+LoVVaMakjpqWajvrqUSvqZ
         /myTA5qCNu4DUnOQs+Br82PaRGEIhXqf99+N7//WM5LJ5RgqN+1XWLpjTOaNM8HnDWQ6
         TkcMR19fEvgdErzCU/c+v8Q6hmkxu1SMQUNb6tJrGZAQr1hU7XR2tTMU6fIE/HwLNgC8
         7WGA==
X-Forwarded-Encrypted: i=1; AJvYcCXmK+UPsZv3GiU47oYLyPpYeh4UmFiQAB46M23zdYV8+EXHxyp2JPiWTYXnZ9ojgABkOTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9HwvPSphpf81odrUpMP5PClO5Zz9eU6fBiahbVLIS1ZUfHPgD
	2Y1RwpC08RyOKLsnMU2b7jlbY2QR8is2m70ZgpPgG9N6uJxg7r/cSvYbgXkEL5M=
X-Gm-Gg: ASbGncvWt4V4ZQgCUDzl9CW2uFjdJcYVwp+wIb6SQ5rY/XxNT2m48knBSnh0UkGHzmu
	uFJapA1L5xiQxwFQXKubU0G8NYb7hNo44Kq8yZFAlJZiav7kv5meyttdXwaQ0KyrX/eTumpENhX
	ZaOGqkmtS3xq3ASRwBaO/RMuNDA9ZRLZZNLhk2RNGlj5JQ0rZbodGe+yFgKLxVAXEUuqmssgDj9
	LN7EnFaUgp/md1pMK8bTyvwucOq/NQsNBsDALX/OAGMWLAEw+0mpMa7okrkFX08fWvhTpv8n8ux
	Y3/wNf8e9jyLDvhGPEKxPGT7r/B4OewamRP1JGl+
X-Google-Smtp-Source: AGHT+IG4ULaEA/GoSGjxEhxOoVD4iO7XzTMOWyT0+0o23OyJwF3hTP78uWvNt/UX6GWnXj4rDAzS1w==
X-Received: by 2002:a05:6a20:c901:b0:209:ca8b:91f2 with SMTP id adf61e73a8af0-20cded4359dmr12181184637.19.1746336578692;
        Sat, 03 May 2025 22:29:38 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:38 -0700 (PDT)
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
Subject: [PATCH v4 21/40] target/arm/helper: restrict include to common helpers
Date: Sat,  3 May 2025 22:28:55 -0700
Message-ID: <20250504052914.3525365-22-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 257b1ba5270..085c1656027 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -12,7 +12,6 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
 #include "qemu/main-loop.h"
@@ -36,6 +35,9 @@
 #include "target/arm/gtimer.h"
 #include "qemu/plugin.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
 static void switch_mode(CPUARMState *env, int mode);
-- 
2.47.2


