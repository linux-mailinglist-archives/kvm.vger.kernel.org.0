Return-Path: <kvm+bounces-51335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E0AAF622F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 899FF7AB741
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8ED2BE659;
	Wed,  2 Jul 2025 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EvsVFbGF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7252BE64F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482780; cv=none; b=R+kP73CoSv4vDVaavE+SUYRw3av5BdHVEfqxmMGgG6bsO70PqgBP38aiJBs70yBVITIFjxYp+at2G80TIXl4HHHyy0RNy7ZLFNh+yFdJGbiZSGru7ALSO9m8HvDIjWquazLkBHLKIGVZvWE+dhA1fxeDUJfGmizUIlBDs7NqU14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482780; c=relaxed/simple;
	bh=CIuVv7FH/DAx3pzZb1TkvmR5LWe7PjKUjJ5CHh6DScc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3mdjUWe6y5OYwo/Ew9Iseqpvu8ZHerdEHVYh+WzJ20pI09PjkO0Dll97c8qFKV4+u6IUNmwPnFIAp9vppY8fVhYE9BTOEslpX4WQRSCUmxQGD6HW8h0TufuJ246B9DgTdMB0eJgBYqVWJHlLvWzzHlZsCbEkA5SoKqvBO9laR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EvsVFbGF; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-453634d8609so51859995e9.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482775; x=1752087575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToXpM4w8/5sKNrHHneMedU0DiOt+AW+hpLalmA9y/oQ=;
        b=EvsVFbGFN9DvB2zG28cMD8KZ0HxoIxBcmfRmY7PE+8pJ1OuTdp8QLP/eI2Dpw0E1J7
         ytD7iVz2PRFGY+IppeLsZeSRKevdAkwOWPPcAmnMfpkI/aJgNG2I49B+KsY/u8PpNmRg
         rA2czIwGU3matyVQJlo9yjd5T70QE5QpGEuhz+1ZmFK/ehTfS6CUCpbaT8uiIzr+HpoO
         gdbHeV5KfSfAYA+cqenklCZS96OAPaDNPiI7PKH230xS6cxN5mbM8ce4USsBITQ0Ux7/
         zrLQC2eVZmFICRE8JwWZ29Wf4BqKd0Hb5XGRE/EbSGTSQpan/H9lqxftPw3BZWnROp5/
         X2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482775; x=1752087575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToXpM4w8/5sKNrHHneMedU0DiOt+AW+hpLalmA9y/oQ=;
        b=rLQ8dCZdbWftigBZ385O+Ra8Gz42Je9KJgQdbaCzC6ghjXD/iIvBKM/75j5lP64LrK
         0bNarQN9z2FRUDm9AtREtPKOcEhOwUXX4MJmauDWswulzotihwm+EZfpG8evf+9+CjWh
         zp/x3qb7AoguCRHWHYWSbpfob7Kyc4iiEvDVcxoNaPgzG/SaZhU+BgmMwSpxGeIYBI3m
         cASqIaDA5wwv2Dwk5TWTvTuHWPo9jekECDw4JH1+cv0TZSV/0ka9z3J9NwEx0mGsW6w3
         6HSofFXAYQJf0nbC1Nv+q56yTpl0x/kBwZkmjX7zFd1HIXn57F5KOaTu93ejzyttB88H
         zmDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQBswt+ALTZi3k3ySPSrMKsNePL7gRVWpLbtnIQZCuiT5gVnVVxNldE8WFdlGqi5nO4+E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf0jHvSMhKQ4uP4uPsqk2TdB+kTJ2SpjLRcCtSZqKGGsrNatar
	5XrWxPMM8JZ+Y6/WZtM8keX3YIP3wtZ+KgYWvPLsrnklWUuP7iSWdZ6ZsdrHbCv1oA0=
X-Gm-Gg: ASbGncs/2uZnOPWiu6WkdJtzi6n2TY4I+rJTxwDvr+7/5P46xcj1X2xyV4+r91MS5mY
	kcrx8OkSJqCj3/WLRtJRNS1jefai9VORtiALYuQSZrX3xuAxdbKADE/ufHRpKzbkPjrsM20zUqO
	yJQWqTa+H20TecE7oZpCAohCGrP3DkAh8xmu5SiTNfuTApbWBIvXexFUAS+ovkrRieAo3nqO2jk
	Sd7fovgZMVXkjktZAcCh6lLar7SKGvU9zwRW/2yd75ZuwBovSyEdZGYF/xzr4nN5T1Y/gNADd7l
	mtvW0WboB9Lei3gr8DumqHeqq1GVnRTZeiv0XrAu+fWyuR7nhjBXH5Vg1KS4lPgEGGe0RE8ET+x
	9uk6WJzGniURNwBLrPBWGNemNqNJgd0PKGarO
X-Google-Smtp-Source: AGHT+IGcleU2BExmeSNnNe4Qm+rWZsFT+Q42YV2sHKFD3Xq/CUYyqJEGaMrFdnzKpIfE8+vOW0prLg==
X-Received: by 2002:a05:600c:c87:b0:43d:fa58:81d3 with SMTP id 5b1f17b1804b1-454a373b1aemr38174275e9.32.1751482775247;
        Wed, 02 Jul 2025 11:59:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99b6f94sm5555695e9.32.2025.07.02.11.59.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:59:34 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 51/65] accel/kvm: Convert to AccelOpsClass::cpu_thread_routine
Date: Wed,  2 Jul 2025 20:53:13 +0200
Message-ID: <20250702185332.43650-52-philmd@linaro.org>
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


