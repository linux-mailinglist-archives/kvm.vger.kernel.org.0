Return-Path: <kvm+bounces-51406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C91DEAF710C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 568243AF132
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5A12E2F01;
	Thu,  3 Jul 2025 10:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XXEpdILk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653E2E175F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540161; cv=none; b=UFGRXgMc7bMQmoRbmgKve1UiYq3iaj1pslIiAlAFDQHnwWgvydQA2Ch0fxZgRMFT8q2YoiEKplUtydAqxaZaP2d7t6P6t+4wEcZvTi5AyO7fJYI0Mywh5/uVSbSpBc5a+Bz/f7e9ekASKSftJ9BX/I0ZWH4fS1jfaZnJOxDuOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540161; c=relaxed/simple;
	bh=fcUcGcXldSPzz9UF4B6QB3kX8zuhZEbMJxuP56A5fOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5lQ/h9zdKZTVsNmuLjEXP7oiOav9NG/tJ2NXtSFcioV1oDVhcHg6+Me19z9Ie4N99kBMAXUafyBRnr7KkRqDUZ5N8Om64ypghgKy+xWVAO5kP0GJ4B3q7jbCvAmQMZHDU809psvXdXGY//uQenjZ6e0bITu4gaQUeytLfJy+B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XXEpdILk; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4539cd7990cso5143835e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540158; x=1752144958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxv4WhKLwrx5svsx0yY+vpPljgpJNa1VqbPNSHemHI8=;
        b=XXEpdILkEKE9qXfoJ7ev5Hb83LuhfDvn/7pfE7WTVktLn2cv0ge5DCiMI1uhl375GE
         u9wHKf147Kxh4dcWZ24y0HOygVAhvBsre9h4YeirZWItlVTMbsCJRgEaFI9nd3QWtO/A
         4LS6Q/n8cYtWTOP6I2WGHaM1D48gDtQbU4nVc3yBBNd25jVrrkuIMTDjKdQaF30BnO2B
         Mg+YaY9beMai4qKy4jWrfNMmldk0DmrBnJmXCYMhr2a1XVri0Y93nzkR8tNehSgmO/Ko
         rJbVwi9e2su1fnfFVkV1cP3mw9LGcyPXy4+N8H0oBIFf1nUqUVR/OlR1sfARlawgNW0B
         pBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540158; x=1752144958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxv4WhKLwrx5svsx0yY+vpPljgpJNa1VqbPNSHemHI8=;
        b=dpQ+lKEvTnWpBiA7jMsj5qFTowZ8y7O+HI+J6K5pB+Lpz7pMLJod2l5kgYo2C7DuYM
         wRVezXhv09+ZFCYpIAIzfIlJ+2J0PB37HLoSlx7HfI+WyRCyrOLS2kd/Dbuv4Z7qZOfd
         ZMFWkzku/uHWM5QznvOn1FkUcnyZI43LkMYL6jHa9Fcd6zlabDs6IfuMe/ja+0sZHbj5
         F4uNlC3ytrmCF1fvb0OoDDKUsOMvQDAU7+T1O+CoMH2I6c+C+0O1hu6PV3+jSpRui0b4
         tGu6/dL1F37ezeePGILqTUCthX9eFe+7ZpFRbpwKvwn5MyQfSmvRB9Hh4xfZnnm59s8D
         SqCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTQc6qGVLEbxOceql9CtourN3OiyIUk4vU2Ic7DYo7AFgdUU95LRQlrZ384gFAPWLD+Ws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9b0UhAXCRjpwVVuUKYOG5jkU+J6kofc+9lvaptA55RdZFuiAZ
	m4kEUMJKGkLzQHiOcnKsBw0c1Fdy8DxHGKQVDqlBzeyq2scPmuj743uCy+S362hE8dI=
X-Gm-Gg: ASbGncvcg8eX/bmTuFmhf5d/0ixQfC2XV3SXc4Wgt00U7ADl8YokKwX8gj+fMAygi8k
	O/qlD5eKrM/SnON7gwt+FJMovrdoYw0+FkMw7gcDUBD6/0jKhQXaXdofeffeUco72QDtjhdL9BF
	1Vk7TcSK3d1uyRSWs+rK6GkyDYZSRb0OWyS2Sz/x8fBYJJxTaD15pWlr/nzAegzUTHdQYtbBaIR
	mxQkpl6srVWvKbufBGExG473TYTiSMBtEh6opDarRFErNws07zu1LO72Io/+sYYsEl/XCsdWlz3
	b9j5e9qupZIba3uUtq2my18QHw1qLY28YXcTTrmigRnTPRdAuuz6yY8PX/uduolNd6hfjsdGfft
	WylOXQtp2iBs=
X-Google-Smtp-Source: AGHT+IG1H8ch3ShI0aRQrECwXhkob5OWrVYrH2E7ESnTzOKHx1oaywxwnUfPeiJs+ptFSaoNI/+HhQ==
X-Received: by 2002:a05:600c:3b89:b0:453:84a:e8d6 with SMTP id 5b1f17b1804b1-454ab2ecdafmr23612155e9.1.1751540158345;
        Thu, 03 Jul 2025 03:55:58 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f842sm17994943f8f.86.2025.07.03.03.55.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:55:57 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 03/69] system/cpus: Defer memory layout changes until vCPUs are realized
Date: Thu,  3 Jul 2025 12:54:29 +0200
Message-ID: <20250703105540.67664-4-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

vCPUs are not really usable until fully realized. Do not attempt
to commit memory changes in the middle of vCPU realization. Defer
until realization is completed and vCPU fully operational.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 system/physmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/system/physmem.c b/system/physmem.c
index ff0ca40222d..8b2be31fa7e 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2792,6 +2792,14 @@ static void tcg_commit(MemoryListener *listener)
     cpuas = container_of(listener, CPUAddressSpace, tcg_as_listener);
     cpu = cpuas->cpu;
 
+    if (!qdev_is_realized(DEVICE(cpu))) {
+        /*
+         * The listener is also called during realize, before
+         * all of the tcg machinery for run-on is initialized.
+         */
+        return;
+    }
+
     /*
      * Defer changes to as->memory_dispatch until the cpu is quiescent.
      * Otherwise we race between (1) other cpu threads and (2) ongoing
-- 
2.49.0


