Return-Path: <kvm+bounces-39938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E467A4CECC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BA3E1713FF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F97D23F292;
	Mon,  3 Mar 2025 22:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WdJuMiIk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA88223958C
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 22:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741042395; cv=none; b=OSF8kMjG9GePkmwpmaRkz5CgBkg+K/9GJNuFlZRfpvOgAP5QE4wl4wJbNpZJ8/42u4x5GhGGzwgKeaLbbix4DbqVtaKq/nvhidv81dTzhkykOYOG+zF5f3JhjmoI7P2xNfZBB+fldJhsaFVpApTHdWkYFBzCdoCW8Vt46wvQo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741042395; c=relaxed/simple;
	bh=DxQuXHMlgc7H5Iz7LRmGc2M8YCqPk4tOjdxPmN2FNfI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ry0dQW4qkVxNDgAleRy3TcG11T+WgaNvl8up5Qauc5zTbvzYb1A19JKG6OikfHm5lE+NFEQ5yZpRMAs4NyhZFSlf93J4q/6FPasLag5mIJniXDf7cbDGMljI1HCQQdZxRcaTVMQv9BklX2/O6xgdDBUCXhuh0+9qPgF1qTMgq/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WdJuMiIk; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2239aa5da08so32746355ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 14:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741042393; x=1741647193; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mugBhowmjHeOZ8voD78niLPk8kFDSWBL6lZCl8cn1Qg=;
        b=WdJuMiIkIs3pUQXpxz7Z9HmUtPvCC79mJk/occ7KYGG/aZdiOmBHRmCNJhdTOf3/ef
         ovpBWaFkZU/v2DMGUw9V6pXveZmqaYiGBC56j7XIAZad2ocyzUG4D6T6+hEk5gaP94Fw
         VsXkGx+7uzLOu6QNKgxQZDi4HxBscik0se8xvAPweYri0I7hRmHEPx0d0wqW2CcqCN/h
         N4o+RyBR5xgif1GKI770sWlsnhnzzyufnWMaoEritGhZ29py8V5tvja0pu0oehAjlZy+
         7I/spmdEj4WD2ny8Xc1m55EZRBYIwT6a33H+8dc1T906V1Jmn7Qk8d7bPbSMbFd/dkTJ
         xihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741042393; x=1741647193;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mugBhowmjHeOZ8voD78niLPk8kFDSWBL6lZCl8cn1Qg=;
        b=ZMgaZqf8fBVF6ltXpO/4GHIQYdf5V6pIZr1d51wGx4H2b/jpHWYuIRrYtBTVt7aKI8
         tOfnHlIBIBbICjNSm0wapbrzVCB8E/6RacfhUbR9+cmlc+dllEA0njwbolh78ElytxWt
         iAd+fGKvnKBtYg1RDfMFozv+RYTXxSeGuWIUSZeocgB9VEyCcVhoAeTe3VJaPSOak8Xt
         GmZnzMc804+UsHBslkp7mKGNghiDRw+5SpHxKtKdFcW1b7JOvEXiOc81J9t1BEpDnqTv
         V0SWcOuStFuceWCKH8305QuwQCsu/YwRFgMQhHoI0/8eyH5GHm/VFT+LTOSZ8NA7poR+
         oWIg==
X-Gm-Message-State: AOJu0YwFtoIwkMpQCImCwLLkMSaiNKS+jJXeR4tYiOh8DdsoIJ2xRYLu
	HgxeRk2kUFO5DSkUgF/ZwMM6N3PV+8bhNv1aFGLxjG6NG+qAfiIKo8UCN5p5hMo=
X-Gm-Gg: ASbGncsBeFAwwe2Kbg1afWl4NMAHcxj8zjod/GdXAcSrNSZsfbhB0oM6tIFSext4ok8
	yJww+xvtBG8yi35A9lRCa3Btpoz/9Hs7k1r9+4PUcUL4xwZFzicdleeHuPJHWnxuBaFZ2I2cHFD
	8rznOnNRfGGzmbhM5LJOq9mY0My3rAPvg7+crEXznWHCrdWDvnBIrDqxZ8s8jQvuhoe9TeY1wbE
	iM8MGyXsqQUYT7aov83eCJiHPVxO8RRJdNaWFZYg1reRDkdT+TsGaOcSXm3bcx5LKFly6QI7WfD
	LD3AZJXQQs+WWjoDT2QjPgD4BHKAvTMZu5xpu9FLk5clPY7wBdb5x1x1gA==
X-Google-Smtp-Source: AGHT+IGcN7KmSzWUc3x2Q9hIKcCxmrhzor1ESo6ey42ZNpnLuX0uKU0+qCp3SXFy7hHj8nlBIEN6rA==
X-Received: by 2002:a05:6a00:240c:b0:732:2170:b68b with SMTP id d2e1a72fcca58-734abee4a68mr22681643b3a.0.1741042393072;
        Mon, 03 Mar 2025 14:53:13 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a003eb4fsm9440601b3a.129.2025.03.03.14.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 14:53:12 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 03 Mar 2025 14:53:06 -0800
Subject: [PATCH v2 1/4] RISC-V: KVM: Disable the kernel perf counter during
 configure
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250303-kvm_pmu_improve-v2-1-41d177e45929@rivosinc.com>
References: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
In-Reply-To: <20250303-kvm_pmu_improve-v2-0-41d177e45929@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

The perf event should be marked disabled during the creation as
it is not ready to be scheduled until there is SBI PMU start call
or config matching is called with auto start. Otherwise, event add/start
gets called during perf_event_create_kernel_counter function.
It will be enabled and scheduled to run via perf_event_enable during
either the above mentioned scenario.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 2707a51b082c..78ac3216a54d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -666,6 +666,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		.type = etype,
 		.size = sizeof(struct perf_event_attr),
 		.pinned = true,
+		.disabled = true,
 		/*
 		 * It should never reach here if the platform doesn't support the sscofpmf
 		 * extension as mode filtering won't work without it.

-- 
2.43.0


