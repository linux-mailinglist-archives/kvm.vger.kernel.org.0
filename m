Return-Path: <kvm+bounces-13660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32709899802
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56B741C21019
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB4A15FA9A;
	Fri,  5 Apr 2024 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mtm4rWu4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E22B15FA66
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306234; cv=none; b=t5/vKKpMVF1N44xOeR6rttKqbRLN6ORlSpEN7n3oYoF3UYbLSg4/z4aJBqrmFupdB5V0+qu68BlVcMGF4Krr27dVPq3A3EqTYZk7ObiArbEDnfTqH9XPBJ0WtLW9vtM7r59YsigQvBPTVVTW6LEXjD3ZTFcBv2CGZE7l52pqGH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306234; c=relaxed/simple;
	bh=y+0o1UmXCSE3i5SxUd1SgygW6YANYPQmLayO90zBYwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eprctk8BgJq0Rw9JB4MNDpDpjNLkLU7UqfBW3AkPNLc9VbkQn24kl3DL/Hc+MxDhvRvuDUGw+BqYGy4L3vswTCbDvq10GwkgW55uTGmP46T6KAuL77wQDwhSwtOuURgttggDfFNEQu5Qy7D5ObHfMkcadcjwBeGxrMstG0ImOlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mtm4rWu4; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3bbbc6b4ed1so1212112b6e.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306231; x=1712911031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4yJRII8fMy/F3bi6dE4gOA3IVVXz2IcrfhDD/wKV2o=;
        b=Mtm4rWu4L4dmWdnraVtB/nkIP4gzne9Tov21ueh1rT7T2gD1BzkRU+Wc48W5Ug22Ai
         4nzvM+zzBW//UbiTaDsYtNoMpMGKeiLt8CO8d2P9IvWU7dz4UDmeWRlQyCFC8gSC+AI5
         16BEoQbERTwGcFK50IRkaX84q0q5Fi+fcD9yv+tF9u7W2zOlXkLNd30xLOsjA7/rWDbI
         KI6LbApgTJ6i8DFb9wmnJAC6VbbW0QD3zeq+DjIca/j3dKXCauNmSWk7K/4iTClv2xN6
         Ipv8V5B3k9PdXGk+xGM7dPxIcn7omBSV5lr+x/D6ohGSN35cXCGWus7ydThO8CG+L5io
         jV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306231; x=1712911031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4yJRII8fMy/F3bi6dE4gOA3IVVXz2IcrfhDD/wKV2o=;
        b=PAc3wo/51M4nL56IG1BTR6hjrYM7Fc4prVDl6xdm562SLNal5MuOOZA+DaJKjkhsK4
         29hIRmCyTfaWguNMpJwC3XWjzqWzv8SasjWgEZjzb2NUxTOi79JIY0MhrV5yLZwfTHZR
         g0aO+y1UJS+RF5jTtPFEjzLaxe5d5NYnACslMaabv6LEWSRNrmFXZMdYNNZjo+X7UABM
         VkUvU5oKrhoq4tL5w5UCJuKzzn4t1OWdmVMZl1ts/iwy0gY2Lxfh6/MN+muvweWY76S/
         I9QEnKAAZshoSyUUMMwDuK3Ixe+lZuI//EI6gwhGBeXhO8thazl68ZvY6I83521srLG4
         IpWg==
X-Forwarded-Encrypted: i=1; AJvYcCXDHbukkX//NF22Nw5lv9eycZvyjJHJrjnduY2S9tHbYE2Jgy6CTxm+n+x6/Cs9ML3NlJulEukMP/Z9W35vFm9amYM3
X-Gm-Message-State: AOJu0Yx7MOf/zNCXGMp3aJtxBZpuc6pPERbKvin4ynJywx5auydye5VX
	l0lvoCXwBduwzEMUQyLJg5qlsQDF2BcHq7RAiPLqSx3UnKpm0bkX
X-Google-Smtp-Source: AGHT+IHWk4PAG8vMEvtXvT6Gf7/v++jLBVRs7XzHWrQhnPduk3qJmIL7Ajo2FU0nBAvkX13v3rrtVA==
X-Received: by 2002:a05:6808:2a62:b0:3c4:eaa2:2610 with SMTP id fu2-20020a0568082a6200b003c4eaa22610mr751804oib.46.1712306231582;
        Fri, 05 Apr 2024 01:37:11 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:11 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 20/35] powerpc: Add rtas stop-self support
Date: Fri,  5 Apr 2024 18:35:21 +1000
Message-ID: <20240405083539.374995-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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


