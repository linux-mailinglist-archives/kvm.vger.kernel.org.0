Return-Path: <kvm+bounces-41352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B793A668A9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 400563A910B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCF41C7B62;
	Tue, 18 Mar 2025 04:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LVv9Gj1D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729141C5D70
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273500; cv=none; b=ifADdFqjzGp9Bwltr23A+jahRlRzxy1dKmVe+ZiFCCu70rdwX1eCEfUwNxT4UW3vaYaLd/ZV7IiVYozMIl0Hsg1aNYHir0OfdQ8/aZW1+568DJ4AwDqyoOsz4NRgbRBRm3wIL7b/4WEjjmqJUMZwWIW3esmslVV8qaeNUfVLbiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273500; c=relaxed/simple;
	bh=Kv2hn9xuv2PLwevmdCXy1ijJMbAyEjYMLhWMuIgU//Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JnkUFVWdsShpF0KJ3LYT8wrUZ4LheHZy6mrHNEw7/jPEI57VAPPYsV/veWf8kEfwbGlzBJl45bPjeSdT1q7686t+IqGmwWrw9GRx4O4YWfZb2d4obyg3RXbvsj7GsT+pDnVZGj0xuKSBti/pSYIv9FWJkGWhNAFR6JFgNwpRgrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LVv9Gj1D; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2243803b776so57803825ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273498; x=1742878298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OcGAZaWPVIysHTdBCRYBHO7NUCxy0k+KHYN46Zgiu4k=;
        b=LVv9Gj1D487nlveZC2cSwfKnBEvRJfNf0haNT9qqQ1Fw7dlROXY0NtRno2d2L9gVvq
         KcEEWeNkIaqRq01e58qkhNGvpR9ocrpr51mo3mBtmnMI7UJryEgxMJTCju6kkv47MYim
         mPkuwGc0eA6+Rc4QL1GcMQ2aI2im5n31b8QDBQfb56k5plilrF4+05RMFd6XMdf+VD7O
         ECcJYLYVThfDmcD15qecEnDU/NtTfLbQrkN3aJGQn/mdc/a+pTfncA7yHyWl9uBnbkEM
         hxiBbYvZWsNX3tfZcEECVVYSLKaLizZm/MOj3RMm9Y/Tg4mR7jrdDGk76jk5pWGK9Fiv
         ThZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273498; x=1742878298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OcGAZaWPVIysHTdBCRYBHO7NUCxy0k+KHYN46Zgiu4k=;
        b=dtYIlzvxAlx/uPM+KZkGtjcOCEsP1nHxBEwoyG7MLolXtixGk/EoV3+3WCKUkB4cMh
         YEQDvfIbB5iH4CL5DmLKTPigL7KEHkukTeVzA8Hjxn1Qj9ntd+31EV2VI4A1HiCgKRGO
         WkYRZYe8M6GevH1K3kCo82qJ4mcDYHqoGqRaC2sE/1VC3pwjB9mp+fERNwiFINED2qb+
         2bvpOO6d/9fbGBaVJUbAkqLQatBA/IQN6+hxxpkUFNtnB/Oc/3oUDMWE3IhD5kiSIKgB
         BxAppDO8eaqjU0edNMlsmrz4xZneBdVRwojiQGD8iSGuJcrCzONXYfXsiMF8W60YYjGj
         0aWw==
X-Forwarded-Encrypted: i=1; AJvYcCXAED47U0QQ51E4VbehYrrrg8m7ppST3rYJmNg5LeQ3gE0q0U5J3VyeJGBv+2ORUM8fMCo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh3DqqXv8q5BiipA6XdhNKyUjds8OUuoTZVQNpBBTBkmzyBM/k
	5LETtgLUimvizssXq+k8xhg5uo5/ZSiVlK7BwACsidas6Q33V+VrQ2fM+QEoLJk=
X-Gm-Gg: ASbGnctoHwhNy8lAyDRbhdGIv2ArvqiU4ah6831dfnurOV2nxpxRcduwntPMSvdN8gN
	l2t9ScrTz3xPT4xQ5UwbRhL8utFpjtdErCQ5mTAmALi18W9V3UXtxSUZ02iSnaDKYoXlDY1SMbe
	oQHnz+4zMlTyKYsK5yPe4q7QiKwYIzuPGChTbzRV24l64oUSE4kx/cJRi6AV5vaZA5S0rDlP+tS
	jsNJLkt2UcwVTwEFBAiwPaDW7LsyKO4XUW6ZZ4S8nGXIDQWqCpYQiXk36/JW0DTHyvVeUJZbegF
	EwctCfRjB/g1E3iwyo3fKE9oJZYC3o+h6j1G2fwyUGNL
X-Google-Smtp-Source: AGHT+IGd5D4o5uKL9Q2v7Y3e6Bm9G+stqVZhHdXsULQqp3gKY9DtvnzsLjdYrwnF2yMZJulAsCZvKw==
X-Received: by 2002:a05:6a00:1954:b0:736:fff2:99b with SMTP id d2e1a72fcca58-737572df1b9mr2862896b3a.23.1742273497827;
        Mon, 17 Mar 2025 21:51:37 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:37 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 05/13] target/arm/cpu: move KVM_HAVE_MCE_INJECTION to kvm-all.c file directly
Date: Mon, 17 Mar 2025 21:51:17 -0700
Message-Id: <20250318045125.759259-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This define is used only in accel/kvm/kvm-all.c, so we push directly the
definition there. Add more visibility to kvm_arch_on_sigbus_vcpu() to
allow removing this define from any header.

The only other architecture defining KVM_HAVE_MCE_INJECTION is i386,
which we can cleanup later.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/kvm.h | 2 --
 target/arm/cpu.h     | 4 ----
 accel/kvm/kvm-all.c  | 4 ++++
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 716c7dcdf6b..b690dda1370 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -392,9 +392,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
-#ifdef KVM_HAVE_MCE_INJECTION
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
-#endif
 
 void kvm_arch_init_irq_routing(KVMState *s);
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 7aeb012428c..23c2293f7d1 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -33,10 +33,6 @@
 
 #define CPU_INCLUDE "target/arm/cpu.h"
 
-#ifdef TARGET_AARCH64
-#define KVM_HAVE_MCE_INJECTION 1
-#endif
-
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
 #define EXCP_PREFETCH_ABORT  3
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f89568bfa39..28de3990699 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -13,6 +13,10 @@
  *
  */
 
+#ifdef TARGET_AARCH64
+#define KVM_HAVE_MCE_INJECTION 1
+#endif
+
 #include "qemu/osdep.h"
 #include <sys/ioctl.h>
 #include <poll.h>
-- 
2.39.5


