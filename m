Return-Path: <kvm+bounces-12096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCB687F8B7
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5494282C75
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01F67CF1B;
	Tue, 19 Mar 2024 08:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgXwbcsv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05BD54656
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835253; cv=none; b=iyp1ElXPWDM/4ds0js7qLP4rZQofjcl6oBDx9lrBzDxkeMjH0gaJUsLQrqdeJDK96pzMQTBkQ0Ec05My1QyPE3YLgdibyKTt1i1yuPlnyNfQX+z8JyL0kpzbE7uaYFMEx1FrH7GEMcw3DaCIfo47ss5/9e3FyhzvXmBUfOMymt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835253; c=relaxed/simple;
	bh=2mWB4+rKz27VWu7Hw2xoeaMURh2u+mdmUKhygbx5uKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhYilkeFd1lIfHnfLc/gj7qbDPp17SiA/KCKqmxXOB54yXNHvqRMi9sOxB6iQpQdBLjdZjhNn2hOW6piWYEZPVjhZZj6Rm5PzEaWIBRtZkeGnHpezTU8jjFPNhZ+FFZkbWXaAzoAn8Y2udWzrXnOCVFMiMro+g/5XUV9pQPw980=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgXwbcsv; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6e4e51b0bfcso2491623a34.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835251; x=1711440051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmYXUw1NFQqCkvaC1UircBJTaa68tPuVL3/2t/uANro=;
        b=kgXwbcsvQBEWheQXX+jg/G3Ak4AsNyEJ9Va+6kPqQPhCUwLNo7UTrV3Q8NWIS4j70i
         68RbmC6SskqBllfwx5LMM5NN3rU37LkFBYLPLU4+FllH3QmtOYNZSWXJcaKJrYjolR3h
         YhRkJCci2meY9iQS8QwLvcAF2QZNW880kfyFxjXcoa5Wruy1CK9o7Ycm0FVtX9G/yX1C
         3kguP7xmejDQ592DSKc+kzt3TjM+035mADlr+Hwe1R2+56+rFqALoxDOg5PTqeL0NFGf
         TF3pZvMgrqAdSn/tCjkWwFeBswdYGgFJaiqFApLK29ShGG+/o1Y9EPfIp4Dij+RB/lGW
         K5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835251; x=1711440051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmYXUw1NFQqCkvaC1UircBJTaa68tPuVL3/2t/uANro=;
        b=wlzWmM+5PMKXBMk4byolfDebaWvgGHBEpaRBB75t11qcOoipiy0kqBeJWNXJhYL4cK
         gE0WxkNJWQ/EiiSB30Dedqj74XWB0EwAztlp1ZdDpnjd7B8Y7RoCrY/gEjUfY/ieZHa+
         qYaLvOe5rX6JWAcwGfiC+MTTaP67dFjomJJSBxLus24R/lswwVkQE/2w5nvaw4AYYrxx
         E8irWs0HpPgOYYzjg3KmOnH0sJV5nrE/05nhsMkDTt06HbBY0Saq2Sn08BupD30/nKM9
         7x7YmbQd1zt35Pip0xAlqHpY8n9j7g1Ka8ebqW9+RzS9wm5LHwtFOWCEjPQE5ZsCoSi7
         l40Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjkvd7Si+2OshOge9loGkqWK+U++qbPDqtJDIB7Upz+X98pCk9rgd+VTFDqE0j1E5F9e8opccdQt+O22WbEAB3ZjLo
X-Gm-Message-State: AOJu0Yy4Lna855WV47YzdZ1T8wkq1GDqybk2S2DGeohf1y9ZBQe6KK5C
	gVGpS4HIHJfvz0dRCDY6cgX6Yzu3tJ6gYQrVyhuM5+3BzlyPBqkL
X-Google-Smtp-Source: AGHT+IFfHuNzVGIE29NF+n08DtvfpVDdYpSp3yZpBjdFnpuN+dbSWe0Rtn2wUlx4d+yiEmJX+pa07w==
X-Received: by 2002:a05:6870:e9a9:b0:21e:8590:6a5 with SMTP id r41-20020a056870e9a900b0021e859006a5mr15351073oao.2.1710835250874;
        Tue, 19 Mar 2024 01:00:50 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:50 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 20/35] powerpc: Add rtas stop-self support
Date: Tue, 19 Mar 2024 17:59:11 +1000
Message-ID: <20240319075926.2422707-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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


