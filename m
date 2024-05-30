Return-Path: <kvm+bounces-18436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F07478D5279
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B73A1F227DA
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 19:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985A615887E;
	Thu, 30 May 2024 19:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Kig9uaye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8600C158A02
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098177; cv=none; b=JeaPRQ0b2LZEIBzqDHWOkmVTXRtgZfOWa4zH13O5k8Fbm36DDtdI2LOlUstqo7n6ReESComK9CrX6YpI4/045NtgEC19kxrAAv/ll0g2+3n9CoScf9j6vB/A4fQvGPFMDfZcxaQW2lSiz+DoKCZ5bA9i5alSd+7aGQpnVONiQCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098177; c=relaxed/simple;
	bh=rqiSfplPG/xQ9bjs7bp/4NUu5oKzzW9W+LMymGb3Kr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UbbSec8aqmGEB/82wSnNFcXrmpFLkm4VWdoxKHPrJgWiV3+2g9cYD7yNqrmdPtQsalifmLhQHESucU/SnrGa0dr2bmVZUGq0a3e2b/4FQPK1Cj/u7dZTpskHrEfH7OrN7MqCj78UtCeb5Ph0FbQhlDmJulfmsWLJJI2lAutwQVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Kig9uaye; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a62614b9ae1so155641166b.0
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 12:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717098174; x=1717702974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPCSTF6BhpGl/BOGWj8t6sMDRxBkBVgL05/HycPv784=;
        b=Kig9uayer52t6w/D4B1HOj8JSs0Dxpzm2BG8krTzSX0aZuvNBZ/tptS7EgKs5HVZnB
         rqqJsccZ+w8x7uA966BbdvB1IRBgDAKnf7pMwapz6oLPPrLGQSuPw4UX+sSL/kMOh52k
         Of9sQXuc/Uy6cjTziPlGtEDUkwpAjHtNmAPOkpAApwUcvKH5VlCE1ychPVWsRlhGBRLR
         LDwDkXqjiIGeIkdv50QyzQkq1XzKvZnM5fXwwtFlOWJ0QOCxHJEul9Mq3j3ZIuKow3Jz
         FME6uyfjHRKm+p+1WShzWy2MGIDQ6KGfoaEM3SYde+rtxtY2vs0T65+wv4FhCX7lbsXZ
         DGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098174; x=1717702974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPCSTF6BhpGl/BOGWj8t6sMDRxBkBVgL05/HycPv784=;
        b=R8+iC0oVjDnw2IhZnSsrLPMkVR7jvA76sa3tLaUiNc4huRzRi4yfmr8tYA7Q0R2oD3
         PcWUhpeIY4sMfaYSVFsyMTsrqcShcLnJcG6HtJfoWQR7bk6uhoHHR8ow3eROJMpRZ2KL
         Rjo5cgtNlA+BEX9lUgH/pgL4QcM6eiF1GH40J0HabqVaUjcTEVxvvlhJyaEU1qT9EYkH
         gk6ekfAY39u48Fy3HtMRczhGaIpJgAPikgYxkx0pZgjn0YG4IHs1u78o1QqCyrpNYuJO
         mVq9mG1rEq1nRTB9Jzx3XR4EME/At8S0LAqWn6ik1+uZKtCV9Sj8YBupdh0EK8EvodWy
         qi4A==
X-Forwarded-Encrypted: i=1; AJvYcCWo3O8cm7VkTI0zyDrZaAotQsbYcB4InRs2u2d9IBKt9oV/8u8apWqAsCo3M75GYk/tGH5Q+YeqaolwXpVSoU1qDIdP
X-Gm-Message-State: AOJu0YzDJ/buspmw18DTwqA0Zo/X/QBzryta/s+B5TRInkoUPfnSEL5N
	pYorQGLFfPZ6x9Z1rmiWcv83Z+jsds9FGLuwE8kn3bdnuQSPchoEEnUn8Tg9FMA=
X-Google-Smtp-Source: AGHT+IE6R76QAmiPveib3Be1Nxuw357LnoAEk7dKHLZ8AdvRVSDfuYn+KOWdz8CdSrBFOQdmXMpLAA==
X-Received: by 2002:a17:906:7714:b0:a67:da88:149a with SMTP id a640c23a62f3a-a67da881f76mr21672966b.55.1717098173884;
        Thu, 30 May 2024 12:42:53 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67eab85c8fsm7754766b.183.2024.05.30.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:42:53 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 16D015F8E9;
	Thu, 30 May 2024 20:42:51 +0100 (BST)
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
Subject: [PATCH 5/5] core/cpu-common: initialise plugin state before thread creation
Date: Thu, 30 May 2024 20:42:50 +0100
Message-Id: <20240530194250.1801701-6-alex.bennee@linaro.org>
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

Originally I tried to move where vCPU thread initialisation to later
in realize. However pulling that thread (sic) got gnarly really
quickly. It turns out some steps of CPU realization need values that
can only be determined from the running vCPU thread.

However having moved enough out of the thread creation we can now
queue work before the thread starts (at least for TCG guests) and
avoid the race between vcpu_init and other vcpu states a plugin might
subscribe to.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/core/cpu-common.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 6cfc01593a..bf1a7b8892 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -222,14 +222,6 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
         cpu_resume(cpu);
     }
 
-    /* Plugin initialization must wait until the cpu start executing code */
-#ifdef CONFIG_PLUGIN
-    if (tcg_enabled()) {
-        cpu->plugin_state = qemu_plugin_create_vcpu_state();
-        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_NULL);
-    }
-#endif
-
     /* NOTE: latest generic point where the cpu is fully realized */
 }
 
@@ -273,6 +265,18 @@ static void cpu_common_initfn(Object *obj)
     QTAILQ_INIT(&cpu->watchpoints);
 
     cpu_exec_initfn(cpu);
+
+    /*
+     * Plugin initialization must wait until the cpu start executing
+     * code, but we must queue this work before the threads are
+     * created to ensure we don't race.
+     */
+#ifdef CONFIG_PLUGIN
+    if (tcg_enabled()) {
+        cpu->plugin_state = qemu_plugin_create_vcpu_state();
+        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_NULL);
+    }
+#endif
 }
 
 static void cpu_common_finalize(Object *obj)
-- 
2.39.2


