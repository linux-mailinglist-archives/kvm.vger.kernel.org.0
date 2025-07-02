Return-Path: <kvm+bounces-51334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 805D0AF6212
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A9F4A66FF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B793B2727F7;
	Wed,  2 Jul 2025 18:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QWLNj3Bt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5EF224B01
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482680; cv=none; b=pNwYIvhc/pQyg368FL/PlVHIQJCUO+TpO3XxR+ZBAXfOby7lk25nvXQ44/6GckPUPeAOG8+fDcjIwlMgqsf4+56FrHJ7gAbgC/Y1VQS2yB0sf5p6rWpQ7bgbW/xRz3YsF96TBHsfMhCY3tLbbzq7wj2iX2NvseFEr6okYrTZjko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482680; c=relaxed/simple;
	bh=p4v5+xFQO3bIoTjIeunVHI9ztp+MZVY9SK6UWvAZyg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E66kcF4UDHP8kfUnNriNNJWbvIOTj2m6w654BIbV3cDXbPhRGojoGGwT9O7uDrTdAcA2Ib15nCOSlKROb4Y4MjXeWQvyjyUPmvPotajXjDpm+aBMV5dHWhndvfsxjRBoHzh+mHzQz+YmY6D4VxnE7ikyDv5voJ0SVhbkJGUccrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QWLNj3Bt; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a54690d369so4547507f8f.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482677; x=1752087477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOj2l0QjwiOWVtDmZos93I73sy6okOj775eGXYWLug4=;
        b=QWLNj3BtG6Jv40hpX4QMMDGfMQ5k3XWW5sefeK7PnQ4k1PxDaRuAZIuPL6Rb4EQrz2
         JXgblQId24sCMeengNJhCUgT5s1Df4q+yLIaUnIPckp1qWzB3omvkHK4ONt9HFG7hHVN
         BHVkhyLClJIcR+Afb8yJ3B0CJEoM1Z+OCoKj4v6bfGZ5x8X0yHFmioMHIRf9bwr/11v7
         oMatrZPjYjSoQYlh21OJSgqDRs30QgxfBYlaY3tFH9TZbsdrkh63Pb9ZCp+iS1ULGaxT
         4Cx7HZ37UbbHP8CmiXWoaoLBmOayL3hcl05TFbSpqib6U9vByzcon+eJYSz7Qredcci/
         +nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482677; x=1752087477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOj2l0QjwiOWVtDmZos93I73sy6okOj775eGXYWLug4=;
        b=JZ050aCTybnzYSwrQZnmCoJjR/G7YIYraRDnEpHRNF9vSE4zkh+2pH6irbDbJWh8cJ
         V97xnSVdbGL6J+3RUnq67Q9YKooMgEIBQrZAHDNkmIbUNNF/Dwj8LO5gLQ9qskw22/YC
         KwKYx6o9RpY8zcQJrA9QrOtLiVhy6JySeE8hXXbsb9JCmiMvn9DVO4IPLawRk39LypQB
         86b33XPWTgPrPUUlGG9gMpT6/In5CxRuGM32Jvf9+n3ZG0bD9Phsd9+iMDceelA22heh
         Hc4/dgy9WsZ6qVmIyzqT5hyywxnQXrIC6oFSLMu9RISGQWCbie4H879JgPVX1NM+BqbY
         Wh7g==
X-Forwarded-Encrypted: i=1; AJvYcCUbD3WvyRrMPQySpi3gaQHHKB18xEf3UA1BUxhKi4/FQZycurkgwNA2q/XugwjzTOYwMss=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ5Gs7BuN0mJBs5MHV1omOYFPt1R11l0eFPiDX9LTLWnM0/s6q
	DQukGqjlcFSUkRRAPeU3+hxavJmZwa1DNmSgZNI6Px1FesXzecciZnzeEZIboFpOImo=
X-Gm-Gg: ASbGnctteDh55ALe7BSuShhnebGk/QFL+FAgXLYgPPViQcN5sdx1rAGnB2/cV1MYxHm
	AcEqAb/BesqR8BKGB5ayrdBb5ayddadvJRxDngNVqsPSoHyWoRof7pYLbPmOoEmj85OK5H4/ZzZ
	xlREKuE1n+7WbgsqZ9Qdo+t/edaR5MLPS2OSwM4/BZKSrWj36QTKXo6hNiNSvPzIGWLg1u677PX
	dDgIKYcMDX8hV7OrX6nxAEIi3b5nF+Qg9wHBYC2DWHawERO12wYOeERoeccwW8xaRtM8OtOraBC
	UcuemFOGKKKS4x0cMV4ja7I79yJHGqFdj48eMw+lyGaorqz5T6N9wyBfTaHiPeMYVuV6FsrqnMu
	kLVfB896Uv8EY7aFchiBpJoRWQ2LI+xJz0l5P
X-Google-Smtp-Source: AGHT+IF6RqLjg+vn4QGMC4sTXHfVfU93wY6vxLMBCeNTzfIOZZe23lOIWbUk4TcPLqEvHidDXetMCw==
X-Received: by 2002:a05:6000:4408:b0:3a4:ef36:1f4d with SMTP id ffacd0b85a97d-3b20067c8a8mr2567192f8f.38.1751482677289;
        Wed, 02 Jul 2025 11:57:57 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99b6d6bsm5505475e9.31.2025.07.02.11.57.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:57:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 36/65] accel/kvm: Remove kvm_cpu_synchronize_state() stub
Date: Wed,  2 Jul 2025 20:52:58 +0200
Message-ID: <20250702185332.43650-37-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
to accel/kvm") the kvm_cpu_synchronize_state() stub is not
necessary.

Fixes: e0715f6abce ("kvm: remove kvm specific functions from global includes")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/kvm-stub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index b9b4427c919..68cd33ba973 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -29,10 +29,6 @@ void kvm_flush_coalesced_mmio_buffer(void)
 {
 }
 
-void kvm_cpu_synchronize_state(CPUState *cpu)
-{
-}
-
 bool kvm_has_sync_mmu(void)
 {
     return false;
-- 
2.49.0


