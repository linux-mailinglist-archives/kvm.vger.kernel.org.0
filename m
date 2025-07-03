Return-Path: <kvm+bounces-51461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2E4AF7165
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 238024E1036
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAEB2E427C;
	Thu,  3 Jul 2025 11:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LWyM/Wc6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203482E54C5
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540451; cv=none; b=ZCeKObIiPJowuxsBwVm+lKu03JOQ+lT25+QFjKtK+zu4FZbL0uqq67gsDO+x+FB/my7BVnt2QCc1uYs18dJ1uwLCtqnM7Dp6K4GT8a7Tzit0+rq5Zdd0oqEbQMXXY/fZSJPI8Z6oDeOUcQnN6GDr7WT/aG+58FWZxn9Oe5s3R+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540451; c=relaxed/simple;
	bh=RGPfar0f5H97T7kpAGr3aD4sUv+ZC8j6kgnBZVGghkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOtQQB+8fG2AoscFxjQQnoBXoXDw9vxf14uClfZ+XIXUkSnpJBJ6eFbhkGu7IC1+nfa6Qpctj6PydKkhAd+VmIjcq4c/67hcjzFtZkw3ZOfPQGJIoRA6e5D4kBuHL8vB97svWGzKVCoLLq9T29g1ecBbVAQhz8gfwfplFdgp1Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LWyM/Wc6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a5257748e1so3730422f8f.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540448; x=1752145248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJV4IXnKJHt8hWaUBPPZ6mJUKwfXPExjXmNVkOYEHB0=;
        b=LWyM/Wc6l3yNw1r14tRy6O7jzXK+gxKLZkLAOUl3lHCpO2pRHRFICizg3z+DJLnXps
         OkSrrNAv+ccZbVlOkxizPKB9AyFujtp5dl/GrM1vsZmCSAhVOyHCS8/0lpSI7x414VjK
         3lXam6jugBRud9kqpraLK1aDqEK9Wq/xxWq+qjavaJEiiHbnhzJcJ0IkJCK3KyldY2eM
         CDdH/UBHd3vQnjOB91Yp5it89OCE8oqdvebJxt5yXat9/iFC6KiLSeqvK6uUiMV+jOkN
         0Dp7SFIFlf+F1/+xNJqr+KVFbwg5w1v+uE/va4LRGZOFud6MIlSG3rLIxmnuC66M4gty
         QTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540448; x=1752145248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJV4IXnKJHt8hWaUBPPZ6mJUKwfXPExjXmNVkOYEHB0=;
        b=Av/BoLMLwWQTmQEc/ZiRMONvchxRgKrVtxl3FrCvimprGlwsIBHUxivFPKjO2SlSnm
         kkKR3JQzAXV/S8PoKS6iyg6HCipRwRPcAVj+ETs0XedX+mgpfA8dd/d1LDZF8ChEsq9M
         VLp4HT6/7lHQ/S0FxLbHVdFTV57NaXqUxoDCr1lBPnyf+6m4T6xSFJidAC7f1001F//B
         CWorF98tTsT295T8LrUehKW4Zq2tx9C5zhdp7oY8vWjq82s/7RRoLayP9yRVZzrVJ4Nu
         G9thPu9kHXyoKkB2UXs6lxShp5C/kHuUGll7pWGFrYUrLTgLuDu6AHvx5TcaeBCxVcdn
         d82Q==
X-Forwarded-Encrypted: i=1; AJvYcCValPnENQODPkceFAkbYai0AXGWjHZPSsnPVE9S8BJVcSJh/OqYAg8WiuM7fFA7jvNOQkw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFFoFZNd5f8LjxRXGutuEJpumM86SEPgh6mGjMbUwyue6GvKOT
	6qH6GKy/hy57ufgFk62L3mpuN8/p9eN62d43kd7+60cKiSS5goxOSaWuvj4ldu9dJLQ=
X-Gm-Gg: ASbGncsoDOLMNWoZD2aFqL6ZL0zBUERMyWrmKiznDP/+Lw50M2BVxNqlcbc4ja9fDiJ
	uayB+H8i1yJ+TRL2C8rHPGb0ncgXLzM3UST9iqxZOLIKG3xRHGLxjfDS+etmunk86Tem8Go4PuN
	i1nLYmWhLeA9FK1l3+EC8RoKFTuL1cW1eLHMXc+e8tbjR1hJwCFx2UW8BzJNjUWqgnrrnhafPVb
	bbEHUEmZ9Nt3570Ycnhnuw06oa2/RgXjMLm1MMGkr9bgloVkoLWMqzvB3oM7ZAk5ECxjBUL0drV
	UeudSNfI1VQRwcOoiljYt0CO9sc/KY5wujhXM+xx2E5mgibdW6+qygYtLpN2+8O4eGBuPRVkSKE
	X2d9oMl8lkcU=
X-Google-Smtp-Source: AGHT+IHqlssT48uJmEPZ4O3QCmimDjy4zBtYSgC8cT/L+FfgYjN8oU142izdLTVwVo9xkf1rmJVshw==
X-Received: by 2002:a05:6000:4610:b0:3a4:e609:dc63 with SMTP id ffacd0b85a97d-3b1ff1473bdmr5354926f8f.20.1751540448033;
        Thu, 03 Jul 2025 04:00:48 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e72b6sm18616881f8f.15.2025.07.03.04.00.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:47 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH v5 58/69] accel/whpx: Convert to AccelOpsClass::cpu_thread_routine
Date: Thu,  3 Jul 2025 12:55:24 +0200
Message-ID: <20250703105540.67664-59-philmd@linaro.org>
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
---
 target/i386/whpx/whpx-accel-ops.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 011810b5e50..8cbc6f4e2d8 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -61,16 +61,6 @@ static void *whpx_cpu_thread_fn(void *arg)
     return NULL;
 }
 
-static void whpx_start_vcpu_thread(CPUState *cpu)
-{
-    char thread_name[VCPU_THREAD_NAME_SIZE];
-
-    snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/WHPX",
-             cpu->cpu_index);
-    qemu_thread_create(cpu->thread, thread_name, whpx_cpu_thread_fn,
-                       cpu, QEMU_THREAD_JOINABLE);
-}
-
 static void whpx_kick_vcpu_thread(CPUState *cpu)
 {
     if (!qemu_cpu_is_self(cpu)) {
@@ -87,7 +77,7 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
-    ops->create_vcpu_thread = whpx_start_vcpu_thread;
+    ops->cpu_thread_routine = whpx_cpu_thread_fn;
     ops->kick_vcpu_thread = whpx_kick_vcpu_thread;
     ops->cpu_thread_is_idle = whpx_vcpu_thread_is_idle;
 
-- 
2.49.0


