Return-Path: <kvm+bounces-51452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32095AF715E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 444AE4E708D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD67291C37;
	Thu,  3 Jul 2025 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VpnCtlSc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF212E611C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540404; cv=none; b=Pe+gzt68bUZ+KIowez1yeEOFLzrZghskBwsb43pi1v1EVGIz6zGhLiDrQ0TPaL5mgV8j6EJJZ6XW6nNBYkWUvVGMjga/nis3Wz/89cH+Caod+w3YVSPANtp+VjCAYVfKjokMopKnhefLV09K47KUBs2rhi77plYmjDQ3cRa0rvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540404; c=relaxed/simple;
	bh=SXS3h0pDboMsH3gZPR0w9yhYqJkyVPEqp3wclizqqto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tehM7pvBUdhWCe23hKRiWXYHa50y3redJeEBL7rBQFNONtu5Lgqi0HEtIPOgveBRR+fuVavOEpUmTfjnMBu7L/IK8Ld8oc7JF2pPEUAxjA/616ODnQPCbUYxao/XJWBWn8SVa77zEv3ZZAetbokajkfdkx3cPM3i93XuR1guirc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VpnCtlSc; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a6cd1a6fecso8440104f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540401; x=1752145201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MatxngaEO94wJIDihnh1PuQvEdZF8b672v9QuG9ABiI=;
        b=VpnCtlScUNtLrlg2mh2pqTiD5rWhKtLVu/dFmzeqAhnww/awUteqvmt9tQK/85BSt7
         Mm606AJES4VSH2g62qiLYHg0CnGCgCM0uGxyMt5PSs3aaKrov0Co89U9oEWnlD5J8Oyt
         v9BioWqKWmiXXyAe50pmQVMoIjS9GjEyzcr5/ZqVIDYeJbkuawwS+GlGeW1b0F0s/tay
         kUoI4XT81EhXrmBzFu0mARtDQB3Qax62D3L8RggxozKWDy8y+ZIM3o6wycVmpKZHvcVe
         6NCALzPje9BqOIOiwvJV6X/JuteS0mm07cPjl2Qc3ZzBrfaB7J4jFg3m+r6tzoBQbI55
         qIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540401; x=1752145201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MatxngaEO94wJIDihnh1PuQvEdZF8b672v9QuG9ABiI=;
        b=I+gUjVkGYuWmKmsh+2OJvE+YW0UjOrgQeJ1+9CKJBVcAujsSmDOr0v7U0LnYqh6a0n
         5kRW86pREL4e+CVsCHv0hJmwuG2cP9A+Q5GOJhh+HkbsIsFspsjHKiPz6hb7c3Dcxfu1
         /5lTkzEL62RaIucaJUAbjj8D2A9FHQD4Jd6V4kjS2OIBCXD7Q0lquy+Z3/+IOsIbI8OA
         WXdW1BoKZl+zbhjYlkGj+LSaZOzCIY9jvpaVAs1mvsRd8GNa7Y42XkW+Z2hWAuzzbi9Q
         RA6dn9uIE7Bz6y7CCcrzj1FkIIyKfUkIpiPWVUsb9etlI2PGpAfzDQ8G0G/2RV6fa7yj
         Cx6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVCRPtWmB9l9EOBoSnMoMEq65LWIxvrGeHwSu0MH/C9hO5OFJgBnbrHdegA4nAxR18nQ1c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8gUqjB1zpz3ltxgzZvM1ZI5N1EBTpr9kj2OPyEfmPVu4dkkDT
	ebnoZI8CJBHZUMsymqVdKKLyfMzf95rZ0Ij85JH9emzYEKdoscCJ3OsEtxajR2XtJVo=
X-Gm-Gg: ASbGncu2GZQqcBF1xQSVuYK9K5/cZ1MdBAQhFUTeaIe1pN0naoo9QbC2D6hAkE8gwgs
	TgmOi0F8F6xdS7XlvtHvVMr5VP9xvWNvdfhsR73AF6vvE9OO5Ml61XMWpJNJ186k7KXNxcjzrY/
	8Gn5ExhQNjBIzE08fuWQP5KF+KUBaplXo0bBeRBvtUZhCQXfVNAl1D6fd1tGqdDAJyq0TWsDg2v
	6PaYiqHixocrs95DDUehGeV2ThEHx44vzrJy2dn7pOytgfEdcjwWo6rASwhnrkfO2U+GY5ZgP1+
	QUWeJ5A+kF1qNpSfMSm8/h0DMC+W/6vX31GqVn8BKa75tdn5C6684USCcL+H8aEdLb2jxfI6XDy
	wtrkg3zdn9dI=
X-Google-Smtp-Source: AGHT+IEb87tlXA/8eGOwxvjDb6DUjurmHoTXreDjZy8v6I2Ff8ndoUXgQehkRndFFAluWuvIfQDt3A==
X-Received: by 2002:a05:6000:2481:b0:3a4:fc3f:b7fd with SMTP id ffacd0b85a97d-3b1fe2de84dmr4668675f8f.19.1751540401208;
        Thu, 03 Jul 2025 04:00:01 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e61f48sm18613334f8f.93.2025.07.03.04.00.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:00 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 49/69] accel/dummy: Factor dummy_thread_precreate() out
Date: Thu,  3 Jul 2025 12:55:15 +0200
Message-ID: <20250703105540.67664-50-philmd@linaro.org>
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

Initialize the semaphore before creating the thread,
factor out as dummy_thread_precreate().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/dummy-cpus.h |  1 +
 accel/dummy-cpus.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/accel/dummy-cpus.h b/accel/dummy-cpus.h
index d18dd0fdc51..c3af710ee8c 100644
--- a/accel/dummy-cpus.h
+++ b/accel/dummy-cpus.h
@@ -9,6 +9,7 @@
 #ifndef ACCEL_DUMMY_CPUS_H
 #define ACCEL_DUMMY_CPUS_H
 
+void dummy_thread_precreate(CPUState *cpu);
 void dummy_start_vcpu_thread(CPUState *cpu);
 
 #endif
diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index 03cfc0fa01e..2cbc3fecc93 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -65,15 +65,21 @@ static void *dummy_cpu_thread_fn(void *arg)
     return NULL;
 }
 
+void dummy_thread_precreate(CPUState *cpu)
+{
+#ifdef _WIN32
+    qemu_sem_init(&cpu->sem, 0);
+#endif
+}
+
 void dummy_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
+    dummy_thread_precreate(cpu);
+
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/DUMMY",
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, dummy_cpu_thread_fn, cpu,
                        QEMU_THREAD_JOINABLE);
-#ifdef _WIN32
-    qemu_sem_init(&cpu->sem, 0);
-#endif
 }
-- 
2.49.0


