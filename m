Return-Path: <kvm+bounces-18435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 297588D5278
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59F3C1C21416
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 19:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B22158A32;
	Thu, 30 May 2024 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EJrQkhai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6574E15887E
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098177; cv=none; b=oPp9ZZkkehRWT2zoLnFqbY7C0YjjVSnIvUOwW7JEpgydDH6guUrDOxJojtAM/mqFvNxlq/IOEGiSSROGHH/nsiOXvXZ0GjuakbLOaWAsk9/TPB/8Xtlc7fH8LC9+NT8iCQwSar1Lv2bHZBn5z/u+Kk0BcIwNtMMjL+pWZBSx4Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098177; c=relaxed/simple;
	bh=Dp9dyvN5Am2cxB/Xcgwh41bu6FnUWnTj5WMWUdHg0WY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVNqsUQ9vCMKtlcoFtK6liDLMNh6f6y9479eR1WTSoAiMovdnIhjo1672PLMkHOQ1Zt7U0XT4h0omw1e/dvAl+fvR8ubdPD2Cxjmyq7TAitpcSqWmTpqjZeZqtnQGfLQr+M2ZX5RHzacHx+viUoMwq/NANpkWXktUH8zccPBWgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EJrQkhai; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a62972c88a9so138269066b.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 12:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717098174; x=1717702974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uSiuGXiCgmtxSxVezOHytC/a0n/fTNdw2YFzo1KJ2YY=;
        b=EJrQkhai4XLCqo6wY/7KA0XMYhaE5ja/k40tcapwGgIoJ9LS88LRwgjif9OILKMAPA
         YsmlWH6s9bqej3vivJuAeeWmL/ErFbEdEVAt7NLncTkwO3IRIRCs6ZNAiY8e6cICS3JG
         VmJHhDXJh316IKjFLydaGojwChIfpXAkAVva/TYo7z8yY4bCxAT4ypPVZYbxjyK4xZJh
         ekZtJhFDnWpwDblmBA+ftjigCfIir1Z7w0jEO4bgwDnGMdSfzHu1xgU/oYOv7hao5Gv2
         8nrOlHBIcn35LeC2J0fCsLg7tYqsoEYMMgE/hxqUGGiyPnJ90ipWrrAVNWVjKIAvxJY+
         IlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098174; x=1717702974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uSiuGXiCgmtxSxVezOHytC/a0n/fTNdw2YFzo1KJ2YY=;
        b=LU/yG2B2AfAFwGPtIdA+U/vPuLWeAmeqs8ktYwBNSFIM7pR359tjo2IcltZEHufVgW
         pomRwZfl/gQ+wBDI4rzAlIuG2+bizBTKf7Ek7ypXLaQ6wSqmQzLvFNVnuaFlQUA/vMGw
         inQWnOCzr+28elaZS5G9v6vX4VD04tXsdDQ+Ht23aF6a7Z2Sf9w0di/cURP3VxFDzUCV
         2jyCpyLpqTTlXzNTjaGKJzwHqluIj4uv/fRW8aA6F1gx/olsFzcUSWEzorR83kE3Cx7F
         V3xrwJXV5qtjNT1jhLbxnXuQWwxJzoyy6mrzvcGL6dyCKCZuYJa8k7WLiVikgo86TdYz
         guQA==
X-Forwarded-Encrypted: i=1; AJvYcCU5zlAaK22ggECD6uHZDC5MHNsgxaBEQv1tOszvGmdUjYkFpOZfg8A+WGXU2yAKMZsqMZBDCTMVybC1FMnY21iVgS8/
X-Gm-Message-State: AOJu0Yzq0QtlkAKTE435KLCrz2Rx1ZY+coJURAyu+JL7rZl2M+O0FwqN
	KBerBb9rL/xzGXUUTMk9mTuGYlKdAR20w/rr+ck3idMRiIgIOW5yZc28hbredGY=
X-Google-Smtp-Source: AGHT+IGCaRuVtIWhRyQ8FoN38Rt6/VkrlKQU/oJb9EQPlJPnpazA4r4xUC8i+X5fKyvCMARa5tUTRQ==
X-Received: by 2002:a17:907:1dd3:b0:a59:ad15:6142 with SMTP id a640c23a62f3a-a65e92304eemr189379466b.77.1717098173472;
        Thu, 30 May 2024 12:42:53 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67eab85f32sm7774166b.180.2024.05.30.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F38205F8E7;
	Thu, 30 May 2024 20:42:50 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH 4/5] plugins: remove special casing for cpu->realized
Date: Thu, 30 May 2024 20:42:49 +0100
Message-Id: <20240530194250.1801701-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240530194250.1801701-1-alex.bennee@linaro.org>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now the condition variable is initialised early on we don't need to go
through hoops to avoid calling async_run_on_cpu.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 plugins/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/plugins/core.c b/plugins/core.c
index 0726bc7f25..badede28cf 100644
--- a/plugins/core.c
+++ b/plugins/core.c
@@ -65,11 +65,7 @@ static void plugin_cpu_update__locked(gpointer k, gpointer v, gpointer udata)
     CPUState *cpu = container_of(k, CPUState, cpu_index);
     run_on_cpu_data mask = RUN_ON_CPU_HOST_ULONG(*plugin.mask);
 
-    if (DEVICE(cpu)->realized) {
-        async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
-    } else {
-        plugin_cpu_update__async(cpu, mask);
-    }
+    async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
 }
 
 void plugin_unregister_cb__locked(struct qemu_plugin_ctx *ctx,
-- 
2.39.2


