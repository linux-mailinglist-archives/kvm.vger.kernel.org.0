Return-Path: <kvm+bounces-51459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9720AAF7170
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B574F3B54AB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC622E5431;
	Thu,  3 Jul 2025 11:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hYlZJm3H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C32E5428
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540441; cv=none; b=lsRY+7ZW+lsoFPTTgnj6Tdyw9K7usQ1rSAY0yKEasoc5hJwR8KWySZkkKF2u9KFnoDljh2agYfgZtxIBcJlIcsnXio6YO1Cf3TKfDNiTJAFXj4/D3VDPbcF8eBSvdzffopxPcmOGX4OZVGmfc+WtnidoI/XLiwUgEeQuXrB13uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540441; c=relaxed/simple;
	bh=CIuVv7FH/DAx3pzZb1TkvmR5LWe7PjKUjJ5CHh6DScc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KMqRqdCQfb5MRGZnAAAwGjXpELAgG1YH1maktwQLEhjG6eiIz6ZCqN+mU/aKRpTn+JnQ+ZXkthvmBl4LB7Te6ClYey+Pu+uF3Hc4NlL9kTO1+RGGOpoP8IH32hQCByspwWnv1YS41oKKVLQXi6GA79BAQRviILGYtScYvfBUkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hYlZJm3H; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a54700a46eso4372059f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540438; x=1752145238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToXpM4w8/5sKNrHHneMedU0DiOt+AW+hpLalmA9y/oQ=;
        b=hYlZJm3HO/gXCVaCx8NS/8VTxlG+HDEwF8rruVshB/XRmd/p/xXkHAz9tF3xDWwzKf
         R5ie3FlBnbp5BiEhvVbW/UE+HOQJY3aElmqj8I9wo9NPNWeMYCMz4B1U72KN+2gn47my
         jhVQD5ecHylMJVpHUNm/Yw8MP02p9gUoSlyCEIB8yj8exHe+v5RikUfBFJT7+AhmgHns
         bR87Pw2yGdMbpOxq9EZoVwwrIep9e/feOvzKSrefI/nt1hUwv6pCO/nHemm/fpnSzM6U
         o6LGVBXihGykJ/xLGnnxY0sXLqv4dF0HvDF5R36QnEEkoXMHJ802gYGEs8hy9v/EF0ff
         0UFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540438; x=1752145238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToXpM4w8/5sKNrHHneMedU0DiOt+AW+hpLalmA9y/oQ=;
        b=uezqTgYd40HCAbnZHvK0jipTUZukVpo29SY8rdO6A8sdx5GypLPL9l1/lEs2pAzaHo
         1Vc9EDvoXc0O6rwu+j0p017AK3GeNWZ0oQGu0DOVfXGmA6fzXglgeEoHgzurRr11bnHe
         yN55MtC3Ow+YnVxPVfkqXpqHnUC+2bf8xtmOdi0pu5moOiEGk5uHNvYihryoGW0lqRHE
         i1eMrrtAd3xHptwvNyscMsFQW0eEzHsmW0R+vTVypQcTE7Q9VEaRxN43q/DUgYLuYTiv
         ak0P9YkZwicwP1Q1hBSl+6SCVCLmtPHd5K940Oh6uLeWhQyMkgA0PhwrUlbuIVpgb3xe
         snWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCPGquc0GPuyEYFegZs0AWi6B5mB3FwQ8Eao08FR9joQJIKlAimcQY+Ogv8QuhaKH2jR0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcnZI+cVUV7inZrxF23KWRJBtp3UhoqoMOK4DtgnIAo8YikaYE
	Jiz0a48DnHVk/dxlB4r7D/0OuNo8uQS3S0Ea0gCQ512Vrx+X+Jmvf9CtyzLQZqluyLw=
X-Gm-Gg: ASbGnctELqIG74u35XawgBbP70n6UvvnWpGnuAzFy/lVoCDtNipRalV0moib0/NLCQq
	vLtgFlHMTIl3OOscHA5863LDZi4r5YQhAiNihkT/PK9jskvYVdULHNfGTeRQDX1ZQEcwfIJKCNQ
	a0KyKsAaKAcS3MqicmNa+JJlwTG4w0y02/OZUzWZMvXGvODW5+//90thf4hEUYdaXdrvUa+6/z5
	3fAhWIIcC1WBAh/tq06YX99ycuJuMMVHr1JL3lXBTLwXwyhEF53OyAP9P3jrQbEGFZGTyvSRwIY
	11tGLsl165Ctfz54aS+DcpVEIKC/8Umy7X3N+Pi8ICndyNCreRE3wfUFziua+zdvWLG7PWi05Cl
	Xg66vmOw52SE=
X-Google-Smtp-Source: AGHT+IEYK8CL39ld4Lpk8KjQCggVRRvPPW9KemNA8oVB4CaF2cQopLBTu2Fy1Kp1q6F5HqEp/pYaTw==
X-Received: by 2002:a05:6000:248a:b0:3a5:2ec5:35ba with SMTP id ffacd0b85a97d-3b1ff9f59a3mr5047430f8f.30.1751540437658;
        Thu, 03 Jul 2025 04:00:37 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcef22sm23604935e9.19.2025.07.03.04.00.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:37 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 56/69] accel/kvm: Convert to AccelOpsClass::cpu_thread_routine
Date: Thu,  3 Jul 2025 12:55:22 +0200
Message-ID: <20250703105540.67664-57-philmd@linaro.org>
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
 accel/kvm/kvm-accel-ops.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 99f61044da5..841024148e1 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -63,16 +63,6 @@ static void *kvm_vcpu_thread_fn(void *arg)
     return NULL;
 }
 
-static void kvm_start_vcpu_thread(CPUState *cpu)
-{
-    char thread_name[VCPU_THREAD_NAME_SIZE];
-
-    snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/KVM",
-             cpu->cpu_index);
-    qemu_thread_create(cpu->thread, thread_name, kvm_vcpu_thread_fn,
-                       cpu, QEMU_THREAD_JOINABLE);
-}
-
 static bool kvm_vcpu_thread_is_idle(CPUState *cpu)
 {
     return !kvm_halt_in_kernel();
@@ -89,7 +79,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
-    ops->create_vcpu_thread = kvm_start_vcpu_thread;
+    ops->cpu_thread_routine = kvm_vcpu_thread_fn;
     ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
     ops->synchronize_post_reset = kvm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
-- 
2.49.0


