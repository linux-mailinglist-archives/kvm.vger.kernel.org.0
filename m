Return-Path: <kvm+bounces-51460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9360AF7161
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4DEE1891E5F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0C02E54B0;
	Thu,  3 Jul 2025 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XbimB0fU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FED92E5428
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540447; cv=none; b=ppUYrSZGOEYe7DD5Bc4/zaV/mN8vbLrDDqT08L9LSyOurc0bMJB23G0gd5K3MrCTY7MQK9mXZfOSwjwXnSPJY1k9wUNG2gQCZv6yJphA1KySyM/gaECSYHp4iFuwp2mzpm86WHDvSP6kbPThjMGtJFvER/aHc3dQhk7WPHnaC4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540447; c=relaxed/simple;
	bh=/JCI7iFloMbvN6U9OgMNRFuv6t9BA51eu2e/587iHO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FbgjoG2Egu/3/HgfWays5O4RKfUGFHENywr9n0xNR74FoGvD+jywFZ6hyfLB+yXrMMIlyYfgqg6OVsNt540FUYQ7nemHjesFLS+BxJUk1kzHGysBlV9Gn3XUcICv9QoOFk3tKfJkHrE59ZIat5mnf+SHZyqTw4cBiEU1CEHXW04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XbimB0fU; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4530921461aso52381185e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540443; x=1752145243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tF+udBuXlMZaTJB7NQwpx0fE1exKYPgD405Hy0Dxyzg=;
        b=XbimB0fUMsh61C1lb84MHOLOey9JT5tpKX0dbaO781W6PV/Dp8/1mFSfSObS+fLp/5
         W7JzGLl6tDgMlIICgajfh4T3BImnyEPyM4KP569iWS8LEVNVOnJp9HPG6IMs5JEKdryc
         6RYEnYT8hcgtD7iE0AAGL3to7q+vQUfytqqC071YMvDrVzX+HD23Kn+Pu/Y0qAy6p5cS
         B0yDFK+UvkhxFnUvQktlMkqq35kimvhFaKszhjRN1FRfNG80IPFeo23sFx9DeVdBSaee
         Xn1sN9k3OCVx38hvOLWFD8ruYw3R3t9IKSaxcq9M7+BtzwNTYcTE0BXqabaI2tobekEk
         8YLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540443; x=1752145243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tF+udBuXlMZaTJB7NQwpx0fE1exKYPgD405Hy0Dxyzg=;
        b=EbY4qih2PL8wZwccUkW4U/yqHoBlv2/FRqtbOqQ/CFCY58HP8LsLm/0ECVcWtdsG6b
         JeIFD3WN08iOY74mHaJ3JO/H334FmM8XbhP/MyaYZLXGf7Zk3wATntuwNEFH9Ojc7q+a
         kEt5XOaBm2RMnaPiJXtWozLZ3c8lB1wvm8mGX/IwLzG7iM5bF0SEb4SFfgZft72uCN/E
         lhtfK8QC4bZIO6nCXp9dUWLKFSqKSroumdoeyF1oe2dMY6KzYYBzdidkuV4RN+rS1grC
         uuZSkattbEM7SlAjEwXstcUw0t5Cg0ReklAg9YJO+JeDD57zSDjaRtzaVf8EOcTBHNXL
         9MOw==
X-Forwarded-Encrypted: i=1; AJvYcCVIYPGLok9sQRch+SMMiW+d8Cx3rgXYqdeOh+oc1Fnv+ljXlLsivNZnuUTxYie/r2JL3a0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxpWJWunDuvC40RHCw7Atwx41iAJdyfVs9pi9DQTxCb6/ZdfhJ
	Icoiue3JUqxHfDB4BxhZVkcvKjlEdeVU/5/+oOserBL2YJAWJHjLIcSDzeA9ptkzH0w=
X-Gm-Gg: ASbGncvk2JX4O4osp3GuCeFjuxF/G2pbrJufT+nhXKBEHpxHlVYhlS6n6kuqyQqgYBE
	7eLpGI6TclY+c5T0vJfm6kg0Nf/s2v4l7CN2wpZHA26knEMLLr+C5wvAbupme/lXiw7MLfDhcYo
	n8C1FTVhfQGH7Q7JkjypIoFkp1KBBWHbqo4xvAo/EyoWvhHCYuqRLc2X6G3vjxB4cRWlI3oai5U
	uwZelqI3QqY8RiUDz0CoQVCFiF5C4YVD6YGg5dFxPZTcZl9DGtJ17a4ukaAdEC6BiA96iXsBkGr
	/sdLSauOUHuat4RnXxX1C7S/2GF86coQkAJGBL+z+mGnuvbIAxcqKHGNb3dwL/0eSiM+YPTfUyz
	RoVJeCKDgxYI=
X-Google-Smtp-Source: AGHT+IE9MaP6O8rg7LcUD14UXSi8Yb3/Nbk4djuxfcMPH9STA702dENVi7CTAIjgya/lSPc6DJculA==
X-Received: by 2002:a05:6000:2503:b0:3a5:8a68:b82d with SMTP id ffacd0b85a97d-3b32f28e522mr2309608f8f.43.1751540442845;
        Thu, 03 Jul 2025 04:00:42 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a87e947431sm18348471f8f.0.2025.07.03.04.00.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Reinoud Zandijk <reinoud@netbsd.org>
Subject: [PATCH v5 57/69] accel/nvmm: Convert to AccelOpsClass::cpu_thread_routine
Date: Thu,  3 Jul 2025 12:55:23 +0200
Message-ID: <20250703105540.67664-58-philmd@linaro.org>
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
 target/i386/nvmm/nvmm-accel-ops.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index 21443078b72..bef6f61b776 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -61,16 +61,6 @@ static void *qemu_nvmm_cpu_thread_fn(void *arg)
     return NULL;
 }
 
-static void nvmm_start_vcpu_thread(CPUState *cpu)
-{
-    char thread_name[VCPU_THREAD_NAME_SIZE];
-
-    snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/NVMM",
-             cpu->cpu_index);
-    qemu_thread_create(cpu->thread, thread_name, qemu_nvmm_cpu_thread_fn,
-                       cpu, QEMU_THREAD_JOINABLE);
-}
-
 /*
  * Abort the call to run the virtual processor by another thread, and to
  * return the control to that thread.
@@ -85,7 +75,7 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
-    ops->create_vcpu_thread = nvmm_start_vcpu_thread;
+    ops->cpu_thread_routine = qemu_nvmm_cpu_thread_fn;
     ops->kick_vcpu_thread = nvmm_kick_vcpu_thread;
 
     ops->synchronize_post_reset = nvmm_cpu_synchronize_post_reset;
-- 
2.49.0


