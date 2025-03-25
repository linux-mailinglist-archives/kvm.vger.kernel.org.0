Return-Path: <kvm+bounces-41893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D61A6E8F9
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D4633AA996
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70731ADC7C;
	Tue, 25 Mar 2025 04:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PaY9dQeb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765821A727D
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878767; cv=none; b=ISmpJqU1pjKFapZjrLi9SFUqx1gpSeNzK2KiMHyKxpi+KViFpbbg9XGvMrBkY1aPEZg/AenzQU5l5dyOZv9VVtujjaf6wiIuT3kTas358At9WLvam3yXLfTibPcErnKAHVvTBsRw9XuSGTKfLf05hlgTTL41OKfSg9eRnAfKw2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878767; c=relaxed/simple;
	bh=51CXS5dKz0hSaOQdvDkN1hNg5woxfoOivRBACB8ftO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fd8plMWQ/gsKmItzx74zsVmhi/YN4ZytVOiyW9NaTGlwm69aEtQVxpbLU9Jd82m1KlYBUSPoDYFc1fPZJ0x7DFIAsQXuco4TJ2WcDzeq6C2NxSUI3GMIbgVbOtrstGWdlrTHfuFVvWoR9HW7MXnn80Aw39WVlgX5B95ZyYgvMS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PaY9dQeb; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22398e09e39so103653145ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878765; x=1743483565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MN4UgqEwiL4w4rQY8ucWfe1J0m6eYAX694euQp2wpb4=;
        b=PaY9dQebJPSznfuXH32X0p9DzHRmhGP1L9skjPRd8CzLF9wnMNNlKai6gD8ngqH9xf
         ZUExO0YfC1vFxCVLoGBszbVEvxs0eiJX4ICWcdBfpI9uJBhJYybwQER9s2cSjzgcwdp9
         g2xIF2Xz1ebQkVj1zN8NiEmeWDQRDaGiFjphaEW2qAv+bpYJ5NpJRFk0hIZF1+F+4tnk
         D7Fg03SK5J6VvoACxvtuOUF60W4hJEQCTIWsnJWHVyusvY+XQjPTcqDIZiipehGy9rHG
         6jqjdafLjVn1UzmqOu3yb7zwfx9zwkqFKhVwN1CyjvJAvIIuY0mgbWezzL7Wn0eF9Y2U
         gfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878765; x=1743483565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MN4UgqEwiL4w4rQY8ucWfe1J0m6eYAX694euQp2wpb4=;
        b=Z40Jc/aQlJV0MCoBDRQbIy18jkP6ISNMn+UYYuO17qPf3i+rQyHN8icJh61OgvK/2W
         OY2m7dEh0VF73EtJppCOcIItC2IKtRbCszY9VPOswDPn/V9L3xoYEO+n1DQerWqMeIAH
         gVpNn7mJBi2qfjIqNoTaTof5qAWSUMcnao10mXepKN5QyUNu+MNzHA5gUxfXgeRibTDB
         mQfj4PAanC0jSLpJFc3VZquIvMbZec3xT2zZi/0ldPxSb/UnZyV6TcPOgvhV0v+/Tpli
         WPAHH9Cp1JV9V33+Zs7/nMGOagSzR088e9CCG4g5d7seX0Mg1VtND3hqZAK6leh7aJIW
         dE3w==
X-Forwarded-Encrypted: i=1; AJvYcCWmSLo9BZ64acRpuL00XNIizOEgA/ZSXBhI1SFwMhlVbF9SgyObEEDt8vwSoL1Gy3R8pZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZGI19jWAgdwnAuA2ixsoVpuBDs+Aw383ReB9cZsbmTWbJXD1k
	BcWgklTYqmYjd07ZWBlVKQO3UpDrnRgxxwk9Rtl7iJhaHsdaZ1WdbIBQHMcVW6w=
X-Gm-Gg: ASbGncvmvEtGlPtTdLjIiNSZAU1i9o8hxXugdC8ZNaKLp1oKjSUHZCVZRlF62HrEUcX
	AuZcdaaZoDsMDp8Tm3GsGeBC4yYtuSQUhLMTa64qwXbLUqc0HM9dCrNlUq50sLpH1SqObAaYoHV
	1sRlLRfM9N0J87kLpVvbabWpwMwlcyawKazdJa23qQfrnNWkr9c0sZ99hMN8caumq01MgM0OTiX
	Zu9/DqzmiHldwunDrbqK/de1cL2WwuvqgcH1XKK+GET6EgpbfwYEyVXR2zFaOvG6MQsmQaf4OQo
	oOn+RVTp6J+r5OKw8Gx2PlRiE82CTe1a1S4KoYaWI6Zf
X-Google-Smtp-Source: AGHT+IEhdiwVNCAUxVqAXEujnJe80rlTseAWcro62yNqBId6GD4J1Z8w34u8f/q5GRpM3AW3E012lQ==
X-Received: by 2002:a17:90b:4a08:b0:2ee:863e:9ffc with SMTP id 98e67ed59e1d1-3030feabaf5mr19365794a91.21.1742878764496;
        Mon, 24 Mar 2025 21:59:24 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 03/29] include/exec/cpu-all: move compile time check for CPUArchState to cpu-target.c
Date: Mon, 24 Mar 2025 21:58:48 -0700
Message-Id: <20250325045915.994760-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 4 ----
 cpu-target.c           | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 74017a5ce7c..b1067259e6b 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -34,8 +34,4 @@
 
 #include "cpu.h"
 
-/* Validate correct placement of CPUArchState. */
-QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
-QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
-
 #endif /* CPU_ALL_H */
diff --git a/cpu-target.c b/cpu-target.c
index 519b0f89005..587f24b34e5 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -29,6 +29,10 @@
 #include "accel/accel-cpu-target.h"
 #include "trace/trace-root.h"
 
+/* Validate correct placement of CPUArchState. */
+QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
+QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
+
 char *cpu_model_from_type(const char *typename)
 {
     const char *suffix = "-" CPU_RESOLVING_TYPE;
-- 
2.39.5


