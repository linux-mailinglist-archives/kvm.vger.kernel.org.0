Return-Path: <kvm+bounces-51450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BE9AF715D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0F633BF3A1
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220772E425E;
	Thu,  3 Jul 2025 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KzZXhtpK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924A32E339B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540394; cv=none; b=nZoU5RNUEQGSF7SXZjB56JtDGVvjzYlxqTYnHNsXJbXThTQS9+0Ho7glSY/7FVE/AYD8Clq5e9MNU0v+wkCq2iOf6AY3lLLtEVv2ExV30Q8iUHVIE6s+5YONm7tw2WnAe8Llctdve3MpFlLJV06iG+PJRuzFdepdrvlcQs424pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540394; c=relaxed/simple;
	bh=jCsPqNurZfbZWzjeAaZO7tXw2upB6/+lwB+3Ka7VrcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inL4JsubbLLR3Hlup5wnkk2JfaSIAZgX/+/UFYMBpXkD+dgX8rDdbF0Dqo6qwgZ5iKYtOLYC+mw0TbEv24AP+xdhWzbQMsgL/skiQooxihqLaldFALGWDV6ds84cVPumSvwX8v9F8rmtpxmKpOJq3dH1ZUdJhqnVjY6P/naz/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KzZXhtpK; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso55553815e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540391; x=1752145191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+WutgSqJXFykFHZTQaYKZd8VkTwajJGbTU9Mch4jWg=;
        b=KzZXhtpKBxHXEe7ZsP+lCdIh7N2e2rn55gQrbD5Uydu3tZWrJ2I0WlmEQ7si9nk8XS
         5QvzAb+KdTAFLy877RF5EteDUeG4PBCcf4VdsMfrDO1Ie0xSGOTFyEa5crrGXTUTW02X
         y+dyZQwW6vcj8UdSRuoNx3cOLhhP/9AnLwMXsJ1z5XYXnOjp4HiEj9aAAgIWBNCH4bgS
         gx18GS42LxUPzqQN5O7gAH+z0bptqwegn2I8MmlojG7Ks5q9OYUxEmSeL668f6Ic7k4F
         Ne0k4g8C1a6DXS059nDdaiXkXl6Rd/hakEsrKudkzGw+/HgcB3bciEmB25CCUqNtAPjg
         HgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540391; x=1752145191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+WutgSqJXFykFHZTQaYKZd8VkTwajJGbTU9Mch4jWg=;
        b=XBfCzvM+dAOZ7cDhQ3NCTOd2hIYeHCnLI5w1mEQUBW50RAW6OvYMCIjMadgXOF9oob
         I2ZPFpFAlvvBPgltolEhhrywitGngJz0psRT5ERz70QNPdjaIsjGrYzdTHpbLFuQ8oav
         Qj4TpA5oIWlFRHlLHfUt/Cw6nOPR6u1zjzI2LmrLxzlEq2PLo7QNS3J69ju+H9gQM2I6
         9aGuf9o9WSw3tj0dwNkZDuLZ3M+vcV9x9kiHt4NknJt4lCR+S+XQzgdGp0A8tgOqvj/D
         mRRc1KxV7yucNrp1ESJeUd4LL2zSGYHYXgTN8d+noAA9IwQ9xkqmQW5XCuVx/JIKZXAU
         DC5A==
X-Forwarded-Encrypted: i=1; AJvYcCW98F/Mr6K4T6+95YI56iSVXN2/8jTOL6RHwvWwya+T60S8Pe9Zsf0nFiEu++COg/iXpJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJJcsml2hSZMZq5YgXnYWAl0u0+pUP4otPeYFK+1RA7Xvc8rox
	rmpIT/sneSW8kzQlyaWq7raj9uf2V+4QU4IjLyT7scHrGLaQAAgK6P5Hbn+al9l4es89RIEg4S5
	QYH3fY/k=
X-Gm-Gg: ASbGncszoJQkbtFZlfDZUhhNjEAbcfWCodm4lCGO8zL6WZCRcLb4WgXHV7Rlm+sE/52
	SDLFToj+tqGnO/H0wBTvHz+jZ5lfgMaLvW7EDIsvz5Ei2vgt6o9I53rN6x0wpf3Zbg5f34CETpT
	fX0SsewNvcjnP1Px8o5MY9nL8U6xDEfaky2U3G4FpFo+mAHF2q7FOgGMtM5M74KWj5IOMKMnACb
	Wd6tpoKt5W/7i8BTxDkduDadyd/ODzxWE69AGMMnIZGdEIOXrgvowhIt60PZdLpnsrEwF9DSJ8x
	KBTL9ygSQZMjnMomo7yKRbhR0glDR/Dn5sNOj4PZpbEUgb6Y5UbUiehaDgayeRHVQVaXfUuHoTN
	4ed4opVfNkMk=
X-Google-Smtp-Source: AGHT+IFkJTWECY2pugXbhxGY6HjeCgJxFNGAomzZaEG1B6sFjMYNKg+pM1wp3bta32pi3CVqInJhiA==
X-Received: by 2002:a05:600c:6792:b0:450:c20d:64c3 with SMTP id 5b1f17b1804b1-454a370308cmr75309655e9.18.1751540390713;
        Thu, 03 Jul 2025 03:59:50 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9989423sm23583475e9.19.2025.07.03.03.59.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:50 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org
Subject: [PATCH v5 47/69] target/arm: Use generic hwaccel_enabled() to check 'host' cpu type
Date: Thu,  3 Jul 2025 12:55:13 +0200
Message-ID: <20250703105540.67664-48-philmd@linaro.org>
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

We should be able to use the 'host' CPU with any hardware accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/arm-qmp-cmds.c | 5 +++--
 target/arm/cpu.c          | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index cefd2352638..ee5eb1bac9f 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -30,6 +30,7 @@
 #include "qapi/qapi-commands-misc-arm.h"
 #include "qobject/qdict.h"
 #include "qom/qom-qobject.h"
+#include "system/hw_accel.h"
 #include "cpu.h"
 
 static GICCapability *gic_cap_new(int version)
@@ -116,8 +117,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         return NULL;
     }
 
-    if (!kvm_enabled() && !strcmp(model->name, "host")) {
-        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
+    if (!hwaccel_enabled() && !strcmp(model->name, "host")) {
+        error_setg(errp, "The CPU type 'host' requires hardware accelerator");
         return NULL;
     }
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index ebac86f70d3..e37376dbd2d 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1978,8 +1978,9 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
      * this is the first point where we can report it.
      */
     if (cpu->host_cpu_probe_failed) {
-        if (!kvm_enabled() && !hvf_enabled()) {
-            error_setg(errp, "The 'host' CPU type can only be used with KVM or HVF");
+        if (!hwaccel_enabled()) {
+            error_setg(errp, "The 'host' CPU type can only be used with "
+                             "hardware accelator such KVM/HVF");
         } else {
             error_setg(errp, "Failed to retrieve host CPU features");
         }
-- 
2.49.0


