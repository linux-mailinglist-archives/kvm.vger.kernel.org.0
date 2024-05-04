Return-Path: <kvm+bounces-16576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6B58BBB42
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45C3FB2123A
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D61328DC9;
	Sat,  4 May 2024 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yc6YosPR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D42D1C695
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825783; cv=none; b=IhvGUn4Pb3NVaKFh2sAWD6mJUTf8xiFAHsjcl44ukvgG34HYSNh7h+DktpZvUpZoJvM7c7SItnX5ZxZpY02QsV7YZ6PJwr1YZjUrwMW/RWf9OfX9mETpsw4n87UxLJCAwzUCrqSuk6QYrDx7Q12c8zy5TC9V99RPktWGPMQ7Pdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825783; c=relaxed/simple;
	bh=y+0o1UmXCSE3i5SxUd1SgygW6YANYPQmLayO90zBYwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfxnwN/2HpOD/s76Cfk01PLuyCPXwTi56ahJh8AH/OGhr41kRF6kdshxqV841UYx4ZzsGBpMHh+85H7JV53n804Pi1VE25N8Kgz2TXa61qyUFWFe2m1e6qfpBOCfTg5U4LIrZfuWUArBrxybqnf/Ggd2xySkxvm2FhTkc/qHepQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yc6YosPR; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6f44a2d1e3dso420417b3a.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825781; x=1715430581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4yJRII8fMy/F3bi6dE4gOA3IVVXz2IcrfhDD/wKV2o=;
        b=Yc6YosPRP2qPFrRYC8kOrfllI6PwI8Af8Qn5eHCUPDrtxaeCXPNgypahDkge2Tnv1y
         zJ9LyPiq4q/SsYj2M5f7yC1CM6WqWcigoE8xgEWjiN7wGlLFkwAmq9btOlD1k60kxS6L
         FtQivRHyqd8Z0wuBfRpCJBxb2/3hFO89nrGDDKPJ8SzFRW+w/I0vH/O5pFMv43jh+dqq
         7OWweR2cmkWu+Bx09pvVAlAh1PCJ+8r9HWNWymAIFBq4xieM1pDoF8QExzC7P2BwsMoM
         tyyq4VLBsVuESDndzrWf2ybCpFQzYAQJv0LPhmp1Eqpbqp0VGO9qHY+Oy9W7Ws6YKVyu
         bJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825781; x=1715430581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4yJRII8fMy/F3bi6dE4gOA3IVVXz2IcrfhDD/wKV2o=;
        b=bH5iwcsB05fEhIHwvf3onqCGu6bZs4IJkzney+sRYhbKMYoDmLWmIkV3Q3F7mvSQSP
         AESWMRNhxt5q1/ctxy4F74dMmxU8hk8gmbrkbnLYwR28qQZNii/7OytLsl/BFpXWyWy2
         H36CKZXOtlcA06VazIyeJptKzJ/J23Jqm+aEqBEk8QlcMxdVDhQDjtxwNqF005r6mk1b
         lRhkZr3frE8QAXEhV7dt5aNQnQvhsr3cr4dHth4r1cG0qJmWSW81B3Kp/aeQHcAtWGVU
         fRuQYIsLIZoBAwHcLAnSWZsXA81dsK+tz0tGPwmHIhTWUG0UZqGhuHkrUofttUdVGBuF
         FMFw==
X-Forwarded-Encrypted: i=1; AJvYcCWVxl9sRuvK8zt/HNFI3TJEatCIXXx46cuhUygOZdilvxUDXW2bRZPbtnBV9bH6OhW9rAUtzqvy5rO1YswRNRbN1mg4
X-Gm-Message-State: AOJu0YzOO5+UmMUEi/uzXCL7+4ep9FdkQ0CMt9sfYULW+snyV/ks8F/5
	WpeA0kpPNKk/Tr26Je/+iNpyJqQw+laA8CcRkE1iBUWGz75UJJN3
X-Google-Smtp-Source: AGHT+IEVY84AEN6CkjA2mwQYQV9LLTUK8/xjcAaI/p883Mc0ey+jvDCcJWFOC5KONl0A8jAnUAwjbQ==
X-Received: by 2002:a05:6a00:23d1:b0:6ec:f282:f4ea with SMTP id g17-20020a056a0023d100b006ecf282f4eamr5430472pfc.34.1714825781511;
        Sat, 04 May 2024 05:29:41 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:40 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 13/31] powerpc: Add rtas stop-self support
Date: Sat,  4 May 2024 22:28:19 +1000
Message-ID: <20240504122841.1177683-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for improved SMP support, add stop-self support to the
harness. This is non-trivial because it requires an unlocked rtas
call: a CPU can't be holding a spin lock when it goes offline or it
will deadlock other CPUs. rtas permits stop-self to be called without
serialising all other rtas operations.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/rtas.h |  2 ++
 lib/powerpc/rtas.c     | 78 +++++++++++++++++++++++++++++++++---------
 2 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/lib/powerpc/asm/rtas.h b/lib/powerpc/asm/rtas.h
index 6fb407a18..364bf9355 100644
--- a/lib/powerpc/asm/rtas.h
+++ b/lib/powerpc/asm/rtas.h
@@ -23,8 +23,10 @@ struct rtas_args {
 extern void rtas_init(void);
 extern int rtas_token(const char *service, uint32_t *token);
 extern int rtas_call(int token, int nargs, int nret, int *outputs, ...);
+extern int rtas_call_unlocked(struct rtas_args *args, int token, int nargs, int nret, int *outputs, ...);
 
 extern void rtas_power_off(void);
+extern void rtas_stop_self(void);
 #endif /* __ASSEMBLY__ */
 
 #define RTAS_MSR_MASK 0xfffffffffffffffe
diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
index 41c0a243e..b477a38e0 100644
--- a/lib/powerpc/rtas.c
+++ b/lib/powerpc/rtas.c
@@ -87,40 +87,86 @@ int rtas_token(const char *service, uint32_t *token)
 	return 0;
 }
 
-int rtas_call(int token, int nargs, int nret, int *outputs, ...)
+static void __rtas_call(struct rtas_args *args)
 {
-	va_list list;
-	int ret, i;
+	enter_rtas(__pa(args));
+}
 
-	spin_lock(&rtas_lock);
+static int rtas_call_unlocked_va(struct rtas_args *args,
+			  int token, int nargs, int nret, int *outputs,
+			  va_list list)
+{
+	int ret, i;
 
-	rtas_args.token = cpu_to_be32(token);
-	rtas_args.nargs = cpu_to_be32(nargs);
-	rtas_args.nret = cpu_to_be32(nret);
-	rtas_args.rets = &rtas_args.args[nargs];
+	args->token = cpu_to_be32(token);
+	args->nargs = cpu_to_be32(nargs);
+	args->nret = cpu_to_be32(nret);
+	args->rets = &args->args[nargs];
 
-	va_start(list, outputs);
 	for (i = 0; i < nargs; ++i)
-		rtas_args.args[i] = cpu_to_be32(va_arg(list, u32));
-	va_end(list);
+		args->args[i] = cpu_to_be32(va_arg(list, u32));
 
 	for (i = 0; i < nret; ++i)
-		rtas_args.rets[i] = 0;
+		args->rets[i] = 0;
 
-	enter_rtas(__pa(&rtas_args));
+	__rtas_call(args);
 
 	if (nret > 1 && outputs != NULL)
 		for (i = 0; i < nret - 1; ++i)
-			outputs[i] = be32_to_cpu(rtas_args.rets[i + 1]);
+			outputs[i] = be32_to_cpu(args->rets[i + 1]);
+
+	ret = nret > 0 ? be32_to_cpu(args->rets[0]) : 0;
+
+	return ret;
+}
+
+int rtas_call_unlocked(struct rtas_args *args, int token, int nargs, int nret, int *outputs, ...)
+{
+	va_list list;
+	int ret;
 
-	ret = nret > 0 ? be32_to_cpu(rtas_args.rets[0]) : 0;
+	va_start(list, outputs);
+	ret = rtas_call_unlocked_va(args, token, nargs, nret, outputs, list);
+	va_end(list);
+
+	return ret;
+}
+
+int rtas_call(int token, int nargs, int nret, int *outputs, ...)
+{
+	va_list list;
+	int ret;
+
+	spin_lock(&rtas_lock);
+
+	va_start(list, outputs);
+	ret = rtas_call_unlocked_va(&rtas_args, token, nargs, nret, outputs, list);
+	va_end(list);
 
 	spin_unlock(&rtas_lock);
+
 	return ret;
 }
 
+void rtas_stop_self(void)
+{
+	struct rtas_args args;
+	uint32_t token;
+	int ret;
+
+	ret = rtas_token("stop-self", &token);
+	if (ret) {
+		puts("RTAS stop-self not available\n");
+		return;
+	}
+
+	ret = rtas_call_unlocked(&args, token, 0, 1, NULL);
+	printf("RTAS stop-self returned %d\n", ret);
+}
+
 void rtas_power_off(void)
 {
+	struct rtas_args args;
 	uint32_t token;
 	int ret;
 
@@ -130,6 +176,6 @@ void rtas_power_off(void)
 		return;
 	}
 
-	ret = rtas_call(token, 2, 1, NULL, -1, -1);
+	ret = rtas_call_unlocked(&args, token, 2, 1, NULL, -1, -1);
 	printf("RTAS power-off returned %d\n", ret);
 }
-- 
2.43.0


