Return-Path: <kvm+bounces-20104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B75689109AF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 425611F233E9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0771AED45;
	Thu, 20 Jun 2024 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hTtzqOSt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B61B013E
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896958; cv=none; b=lhamiyyW7CeJo+PwTJa97zqiLxdNRFCKuSeDeAyAGZiae2HPU7GhoPjWpC+qU3dSJQQrwUlbMKHdFMeZAhx29kYRON8FWMugYyOrQKKzkkCkdd+GhDxPmwRTzpe4KJxvFwFNw/WdyV8fT35lJJG6fXI+FTmj6vj+yBrHrk3cB/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896958; c=relaxed/simple;
	bh=zMyxd/0cgt94CkKT8dAJw6AXCgBcWkEglxBAz0hwelI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jGlsQ/wiymPTCR7DKBeSQ7OUa0M/ymS5ufGWb5XCW8AaGEKOqUrNFERaTJO1Rcfq72XxUw2zEW+TCKVaUVBhHESvvOo3Sn5SlnBXF8oLfjFfNvmZj2bZJniGAISEmF1Ye0ktSKeuU9pyEgkdPaz6sBDqWxVUToUZl034gVJ1N1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hTtzqOSt; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57d280e2d5dso368055a12.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896954; x=1719501754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRGnfZngJdWMgOcvZ7TtStbP9AmubDNWr9Hu5lfqXOc=;
        b=hTtzqOSttZx2T7mAYeXMArY0fHEYVKxwRSauXhgWSbMDeVeWDheIUNgLfbw4SBjAs2
         xxdnApddVLwyOhu00zD9JpqlcvdKXnBrXJ2oRHE/vqXxVzS09Vw/+RwUeglf/8xgrdad
         p7UcO1RkhfNJaxIdGueGArfxFgyQc/4wzqSfpCI5Y+jmGgt7LGieNvg1tFAZUvQsYWSU
         RPNTG1O7YAPVROBAnDfO9+xFx+fHsmm2Fjjp98uyCK92fjQ0NQ2pWBhGdOL7Jtq/ggV2
         5a26cZJHBFGM7QSYFSaEPD3dlJbl3BwxpRQsVbRk9Nn0NIQp9a+jdR0741JnyaJUFPq6
         OrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896954; x=1719501754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bRGnfZngJdWMgOcvZ7TtStbP9AmubDNWr9Hu5lfqXOc=;
        b=b856O4mjC8Bzw1k3IdGnAziJXVGl7OSjVR/ClCDXH10zXSEjg8DU0qjpVVsvt7YuRT
         ip8m2RzC28H8SpZ9etCuj5/WF18ECgh79VZe2xRYz9HGqwq56WsHgd+/Q6q7Pfb6/NJz
         UK1zGDbYQPxvwOAGuK3BFoShSJ8GrtM+AgMbtWkfH0R5SA+UMPIqYkHDkU5MnNPAp0vo
         tKfkpwlEqWNg1y/0dLmGAWm8LwEZKZhhDCv6253cPglME0GfLO1Kq0gLh74QLiG3wEpl
         H5gMnq4x71YkdY6h/5VaGmYLaisat/Y16jN7RIUcq7XDDi4oXO2Wl4a0XhmazaaGpU0A
         /ufQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyaE8n/1VitVoTd2+UsnvG4kILpsLYyOxZvtJhaC+PBSf9hH6CJSZdjeLVjAXmcMUUzOkjvCnhCyxyOXg7cKlHcdMf
X-Gm-Message-State: AOJu0YzZsLxbfCRTtDV8irkSqfUO3eT7eXMCmIZzTa2oDuoR7Yn+9LgL
	B59jWnq7nJjTXCLj8/kQVrJ1r7EKzx7vqg5LY04GMNFnNx55JPQpqoGWjP7yR2Y=
X-Google-Smtp-Source: AGHT+IEiVE4x6H+fZARaO4Zg3BaGTcyG+2ERR3isx5aQQpt7wxoNKnSQpwaFZQ2FBRWx1WpkNkdG7g==
X-Received: by 2002:a50:9f4a:0:b0:57d:5ac:7426 with SMTP id 4fb4d7f45d1cf-57d07e66c47mr3246096a12.9.1718896954416;
        Thu, 20 Jun 2024 08:22:34 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72e9115sm9869605a12.46.2024.06.20.08.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 81C2E5F9FF;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 05/12] qtest: use cpu interface in qtest_clock_warp
Date: Thu, 20 Jun 2024 16:22:13 +0100
Message-Id: <20240620152220.2192768-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This generalises the qtest_clock_warp code to use the AccelOps
handlers for updating its own sense of time. This will make the next
patch which moves the warp code closer to pure code motion.

From: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240530220610.1245424-3-pierrick.bouvier@linaro.org>
---
 include/sysemu/qtest.h | 1 +
 accel/qtest/qtest.c    | 1 +
 system/qtest.c         | 6 +++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/qtest.h b/include/sysemu/qtest.h
index b5d5fd3463..45f3b7e1df 100644
--- a/include/sysemu/qtest.h
+++ b/include/sysemu/qtest.h
@@ -36,6 +36,7 @@ void qtest_server_set_send_handler(void (*send)(void *, const char *),
 void qtest_server_inproc_recv(void *opaque, const char *buf);
 
 int64_t qtest_get_virtual_clock(void);
+void qtest_set_virtual_clock(int64_t count);
 #endif
 
 #endif
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index f6056ac836..53182e6c2a 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -52,6 +52,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, void *data)
 
     ops->create_vcpu_thread = dummy_start_vcpu_thread;
     ops->get_virtual_clock = qtest_get_virtual_clock;
+    ops->set_virtual_clock = qtest_set_virtual_clock;
 };
 
 static const TypeInfo qtest_accel_ops_type = {
diff --git a/system/qtest.c b/system/qtest.c
index 507a358f3b..5be66b0140 100644
--- a/system/qtest.c
+++ b/system/qtest.c
@@ -332,14 +332,14 @@ int64_t qtest_get_virtual_clock(void)
     return qatomic_read_i64(&qtest_clock_counter);
 }
 
-static void qtest_set_virtual_clock(int64_t count)
+void qtest_set_virtual_clock(int64_t count)
 {
     qatomic_set_i64(&qtest_clock_counter, count);
 }
 
 static void qtest_clock_warp(int64_t dest)
 {
-    int64_t clock = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
+    int64_t clock = cpus_get_virtual_clock();
     AioContext *aio_context;
     assert(qtest_enabled());
     aio_context = qemu_get_aio_context();
@@ -348,7 +348,7 @@ static void qtest_clock_warp(int64_t dest)
                                                       QEMU_TIMER_ATTR_ALL);
         int64_t warp = qemu_soonest_timeout(dest - clock, deadline);
 
-        qtest_set_virtual_clock(qtest_get_virtual_clock() + warp);
+        cpus_set_virtual_clock(cpus_get_virtual_clock() + warp);
 
         qemu_clock_run_timers(QEMU_CLOCK_VIRTUAL);
         timerlist_run_timers(aio_context->tlg.tl[QEMU_CLOCK_VIRTUAL]);
-- 
2.39.2


