Return-Path: <kvm+bounces-51456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF071AF7164
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6DFE3A29C8
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252A92E498B;
	Thu,  3 Jul 2025 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="grS2bmSf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97862E4985
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540425; cv=none; b=Myf1OiAk+5MIAoq8YHX/fChmrBSRE1WxDRpgmjHmeP+Q4iMSnpEbdG6flAoqmUwGQxzdbIZQeBbd1DwljKsZhDqDVQ8R9uXE7SWeZtAq5TFmBrXARcAxAId7B64NUJTByGlK0jKEkonTwcUbTu5FjyBmgDYmdWDM9lx5IiMylZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540425; c=relaxed/simple;
	bh=bdNF5rjg57K5JnNoJgS/rcD6wPnyxQBr3UCcwEiPJQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjCOpg1XswI3NjKkc+cvJ4muB0Fni7u7cmdApnVG9/+YduJ/vsxh8NnKE4lscnYuqfJsbBpETnWvsMLB4KB5d2v5ScXFk0zldqqXIiv3CI7h4CEzTaG/jkZimhfHTZUxafYHi+2A37LrkE2dFAhZN23QhHQJ1jCVB2HvbXz84o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=grS2bmSf; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so538983f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540422; x=1752145222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtcgYIv7cyhzlknrW2Wv+nYV1/8CFpZnM220DOT3U/s=;
        b=grS2bmSf1hhrAT7siVIJupTQx+9tgPGbDOiN2iLTWYt5Z/4xR4PmITU6D6XpUJusgd
         /pWZo/HH85VerkE3g7Paro42oDgjKsPZ2esrex9IZPDLCYwVciQsm8D2jVxNTWAREWNE
         uuMu9d/UR/TrHeb3wbJMbY/Fpba1cXXuDQZwZIaVzciVqExBCtN72Do5DZ/h23YXoymL
         mIchrmiTEM3goW1qHeImfnGeQeijPiAiPtyIJOZc7ta8g/Py3eKxcm+RYzMfatQuGUT0
         oBZNF7TtjVx2iAmQQuj9iKPR+y6JHMkoQezG/Bptej3b0T6ZDMTvkJpXWlXQWG5hVIdz
         THMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540422; x=1752145222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VtcgYIv7cyhzlknrW2Wv+nYV1/8CFpZnM220DOT3U/s=;
        b=UNwWxHHfDAeP+srj/BTBty7K18qTbleQ9S7zCMR7bR5yw8XrfUwKxDIvF8Iwj1WzzM
         bd0EvmUOirnl1HmFV/p/hpeV4zvetVbN0bmRjshZ39PqdX6shvRwoHJkZaCg0gCTwD3p
         zXp8OwyBe6uBKHpen87Uc2GgHTncEMoZ5KrB1St/NMlzX5lAn4T9dnDE+/ohUh6CqftH
         c8Pmdz9Xh3bFCjMoazBUc2ecaiYQGC/NUs6YXUx6piEwoNAcFNZ7qYgYV/KnqkljVpGW
         KfrwhRBrMhCezH4hP2R8D2qRdBmCKiYiDDCyW4F7RhHdVsiZbkCymmgfpQI3ucMrwGvx
         Y3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoEeqJ0kOX8bxfW3civHx4DLD3X3s8izGKElgeK7AYstA4p4lB5/9Ak4SBffjCDwY0bko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6oGz5j3OLlyGpmFhVKx5ZBnNOn3qoz2jLNviljpu1W01jXj5J
	BuI8mY+xjTZrkwksR3KGbyGJeCKPN2phc8Ad+NFi8kP1hExVU5LVC6B+xueVn3Pdkuw=
X-Gm-Gg: ASbGncvYcoxKiIdt2HfwV/0LaFmd63u5s8XwSF+9rSRyLyUqN7FGUtvXRmFReZcpnqQ
	m6ncxzdTpPq9bmPfmBlUEduFXS0CdgpFhwxsUvEbx2f5FOiGFahM9OZU2VaVugZq5thFPK8U+Up
	WDVUNiyi2yxEhaHR5W+OlvQUjaLs/4+O0w+DFGYF3RKgXvKmDmmHM43ElZzjGeghtpPeP0lSuOB
	8aE0BGptaI1WhTjN6O5JRtbpjfLUUPMIy3AEBj0h2OZnzOQncyzJYqYOVrj9HzJjqfrvFkqd3xU
	ac0PuW22DQG23vqDQYrhOv+2gYVMRROOnZDIC9UITJMRBRUvJ0VtsRAaoNxBDkV2QqjOAkZAJcs
	aUY8mxU9rxN8=
X-Google-Smtp-Source: AGHT+IGD7TC9O4oxqN4AXMXx4fT0V4Qtg0hQBWZhDby2s+AzbNTf4+ZNgcj1dYa/jzmx9avOyZc4UA==
X-Received: by 2002:a05:6000:987:b0:3a3:7ba5:9a68 with SMTP id ffacd0b85a97d-3b343889c82mr1880924f8f.18.1751540421981;
        Thu, 03 Jul 2025 04:00:21 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52c99sm18125528f8f.49.2025.07.03.04.00.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:21 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 53/69] accel/dummy: Convert to AccelOpsClass::cpu_thread_routine
Date: Thu,  3 Jul 2025 12:55:19 +0200
Message-ID: <20250703105540.67664-54-philmd@linaro.org>
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

By converting to AccelOpsClass::cpu_thread_routine we can
let the common accel_create_vcpu_thread() create the thread.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Acked-by: Fabiano Rosas <farosas@suse.de>
---
 accel/dummy-cpus.h  |  2 +-
 accel/dummy-cpus.c  | 14 +-------------
 accel/qtest/qtest.c |  3 ++-
 accel/xen/xen-all.c |  3 ++-
 4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/accel/dummy-cpus.h b/accel/dummy-cpus.h
index c3af710ee8c..c2f9fee164c 100644
--- a/accel/dummy-cpus.h
+++ b/accel/dummy-cpus.h
@@ -10,6 +10,6 @@
 #define ACCEL_DUMMY_CPUS_H
 
 void dummy_thread_precreate(CPUState *cpu);
-void dummy_start_vcpu_thread(CPUState *cpu);
+void *dummy_cpu_thread_routine(void *arg);
 
 #endif
diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index 2cbc3fecc93..f637ab05e32 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -19,7 +19,7 @@
 #include "hw/core/cpu.h"
 #include "accel/dummy-cpus.h"
 
-static void *dummy_cpu_thread_fn(void *arg)
+void *dummy_cpu_thread_routine(void *arg)
 {
     CPUState *cpu = arg;
 
@@ -71,15 +71,3 @@ void dummy_thread_precreate(CPUState *cpu)
     qemu_sem_init(&cpu->sem, 0);
 #endif
 }
-
-void dummy_start_vcpu_thread(CPUState *cpu)
-{
-    char thread_name[VCPU_THREAD_NAME_SIZE];
-
-    dummy_thread_precreate(cpu);
-
-    snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/DUMMY",
-             cpu->cpu_index);
-    qemu_thread_create(cpu->thread, thread_name, dummy_cpu_thread_fn, cpu,
-                       QEMU_THREAD_JOINABLE);
-}
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 2606fe97b49..9f30098d133 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -64,7 +64,8 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
-    ops->create_vcpu_thread = dummy_start_vcpu_thread;
+    ops->thread_precreate = dummy_thread_precreate;
+    ops->cpu_thread_routine = dummy_cpu_thread_routine;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
 };
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index f412ea346bb..e2ad42c0d18 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -152,7 +152,8 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
-    ops->create_vcpu_thread = dummy_start_vcpu_thread;
+    ops->thread_precreate = dummy_thread_precreate;
+    ops->cpu_thread_routine = dummy_cpu_thread_routine;
 }
 
 static const TypeInfo xen_accel_ops_type = {
-- 
2.49.0


