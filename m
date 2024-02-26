Return-Path: <kvm+bounces-9819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A13F8670ED
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:28:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCD751C278EF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B395D8E7;
	Mon, 26 Feb 2024 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yh/yX9tT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953225D46A
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942418; cv=none; b=m4zaZKdfQxq0hYaechk4p91u/j2yn+Bd/Voimid4chLH8RHCMia+CIkA8vH8UKuBlaJMGmEO7TpbAKUyCzNHbqvnSv7u5OW1uT4uvZRrq1DahQ2jWPGRfmg/6XxXvbRs5ausCWOwV+UPX1PmGHaiUZfHdrNElbC5iNsFDuk2ReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942418; c=relaxed/simple;
	bh=2mWB4+rKz27VWu7Hw2xoeaMURh2u+mdmUKhygbx5uKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJrMEAdpUjdMjwuLyvV4vI6//EiUAucAL/LiWMWZduetz5qRMp8m+krkhpoItLjUqCsfckwy95F2rskYMViBbItw6xNltqdJm4i9iFiaJRHuxAifgXugyPbobTT5JMZPkYrqF94uy9lnum9JWCrcC5HhIDnOdK9dyoN9/Vv25pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yh/yX9tT; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e08dd0fa0bso2452253b3a.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942416; x=1709547216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmYXUw1NFQqCkvaC1UircBJTaa68tPuVL3/2t/uANro=;
        b=Yh/yX9tTpcByWjmLyzKGQe67dj06MkU45D8mVPokYiMCKydhdopQSGgK78OixIMyG6
         lAT5OrJURjKcQQdHsNZxZewqLgnRCRq8x+BHRmRVrPyhZaKUP8mPAoojF5QzMvvNOUJi
         YkJerJR5n/HERDu5wU4xzqh18yxMlG6vOY30U9nSY4BQyC7o1uRBSLQw7RdpPyiRH7//
         ccXQNYFVF+bG1lTcLv+B04zrrYJA2fxOIWAqYqFSPjyhbxygetWpsQKxnbRkqR327DRW
         lV9r2D1QpMrRBsL7LK4wSg6/GIzdgMY6QE7vuYPy8WSXhuy9v6MR5U6xrxNmXauVeN4B
         EX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942416; x=1709547216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmYXUw1NFQqCkvaC1UircBJTaa68tPuVL3/2t/uANro=;
        b=KcwXnLuBCDKTKsBLavhcgWZ0FebM65kS09hlE/yPs8nO7SUjlzhO8BGTSz12axTLkd
         uHyq1MOBVZGhorVZT8dNj3ALjqd6wQpmJyzV0wC8G7YshavwZ+6oZxS0OgqDGqcj92go
         p6W5cwBUvc6wbNuglC3/yKwjSh/gUDm5hefrtjAHgLAb8bwOWqeISp08iAfuU5ihIdw+
         /tUad+TWUr/CaKoOdq75UVRmHw01iJsfnIkhYd2foSpBRrl3gpFCuU2V52LXxur+be/N
         fVTFBPi7MwAP1aJAVa9ygQWztyqj2i3jlKw7EvjhxKnQVIVNSc/yIQZH1019uMwYbzHi
         U3yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh94s0BWpAugU6aNARRsMyAw3hLd+JYykb1LNTpqEN+3iPlKvgqU3eRmwXrrTsKWJWZkNXpz3gd39eTsms8WAWiAPa
X-Gm-Message-State: AOJu0YxPxbK6DpS5gj7UvNrL3x+Y5wXijRVK1H4U5QS+YDoKpXC6atxa
	/Nxa5H6yxdxf/6jZwnifPQhg9xvOM4h4T3nmvHYAgrwa8jzt7RzV
X-Google-Smtp-Source: AGHT+IE33yelqfo5A7bE1yL/3t2I8wNS1alI2QNk8jsV/3YN15t109k0RXhDJbdYg8N6DJxAffnFlQ==
X-Received: by 2002:a05:6a00:1783:b0:6e5:3f18:6a30 with SMTP id s3-20020a056a00178300b006e53f186a30mr59868pfg.13.1708942415856;
        Mon, 26 Feb 2024 02:13:35 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:35 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 15/32] powerpc: Add rtas stop-self support
Date: Mon, 26 Feb 2024 20:12:01 +1000
Message-ID: <20240226101218.1472843-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
2.42.0


