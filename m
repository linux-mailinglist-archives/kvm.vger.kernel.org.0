Return-Path: <kvm+bounces-51336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB6DAF6236
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9C8B7ACB49
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51DF7E0E4;
	Wed,  2 Jul 2025 19:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jmhv0wmU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647422E499D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 19:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482813; cv=none; b=nGOe32DJSD9whY59JkcMjwkdZwtvq2NH6QbMLABFSlHTJIQMpus6T/omaF22KgxQ4UX5OhuwVPfMwMc/eN13yX+oO9T8ynQQ85+IEepubg3aKNZwBfXR6aTg9vuwBfg6z8Jo/ZKJaxWp7UYCfeIV7lqULnS8zGPMP5vNp/SFSCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482813; c=relaxed/simple;
	bh=p2enImd9FMu+qiyMc7UDdYAC+ZbjVZ2oZIT4bftuVkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AR+WELvSb5StR+GVQ1QcDQ9OIQNKrXsixoam7+vFgeMzojRI3VoKzForRzG3Fir4SGY3BhUTnfgSY/kWSBj1NoNQHrCOVl+JyRsBiXFfjmk6mG9DSgHn8gSLUFUqPHaqShL5PIJCZe0XTb6ouE1xCJfxwsTj430CGlYSnkqr374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jmhv0wmU; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4538bc1cffdso46050225e9.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 12:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482805; x=1752087605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9AALSKsiWp+fyxrwu3Q2lSvTY3F2dydfTXpwq/TdYI=;
        b=jmhv0wmUb0KuJo45yyFU+JSb09JSlz1K8JFgRvlYKxn4dzMF6Eau1Y1vXil14yjnYu
         DT89dPTB6hfNJbEUWKDnc7ll0UMXdEyQ7jmajlqQ5lPds8l86755zHxiFc51RKzVSowQ
         4ZEbhVUUrXYHtByiQClp2si37KrY/LMxvNHxO7GIwIIkQRi5R/BJQ2fJ5X5l0lLxIyyl
         3IIslQE9xN/iUYc5NJw0RLnvNnXWTdLZ4wecakPNnUAkNo3WVC436ZyBr7+0uxy0dIb8
         GCb/xvmFUglsIrcAVKk3+Tt4DrnDmKClQ8fIkvJOeEXHbperfa1TJLHsmpeA9FMKeF49
         I5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482805; x=1752087605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9AALSKsiWp+fyxrwu3Q2lSvTY3F2dydfTXpwq/TdYI=;
        b=gxRqA+vL4nxY3QX6HmWI6HXiejznFTmdKtkl5fUIje6n4Gzr9bMPnPI315vHOQ1lT0
         w+GHEQhOvMoeZSf1soJBUEApQ2qc1nwJZ1i6tMuG4hkw5TATDcwOro3yVI7DlNOsJ17c
         juDDt2UI+1S3qSbRbV7HKSD2VDejY970oroMakHDYhAhEwXhd+KZ0EqRa7qhWCOQI5Rj
         yYfH9tRW19i3p05GCq7mvQKEm/bfv6RkEflik0pwz5zAewcKl07a+kcnjAML8X98NWE8
         YIz29c9RTk6/ku+obsOBAnHGVDYs6lTRsYfcSTcCB011qStLE+uOkiAzYG7EjpYF+rPJ
         qQLg==
X-Forwarded-Encrypted: i=1; AJvYcCXwXMaR07SazC44g8/ctUWwUkQ5V3MdKdFC7BFFPWhdQ2r2tjggNUIxxzbCquge1/BHWdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoOivrrZL7QUt3E+Duz9qqsWByx8Bi2snrBBbARm6kA2qrsnAC
	LdmzPH9V+3GthkoKujEWr52wdVWQKfwfxjBtX8iVkYsBbzZ43EtsuTwpoPhBVNn4pEk=
X-Gm-Gg: ASbGncvMLiF/3FI02dIMn00GPLCLQ/6/9Ewt+mT4VJ0fpj3dHqERM1HizJBZ3yDq3TF
	zFk3Crk0PVcBsJNOJ/dR7HtpULGGiDnEaXHFHnKnReLeDQsoeia4iQRtD2LSQJeKkm0i7CgAFNE
	wz7iJZe0zv1oN1eeYjj1dc1WihPIhgFHq6i1b1RVkF6uk1ROL8a2NMCEzXATvCmzwMPNMlYoHdU
	7e52Cu29kcTK/DZ4njOb/O3h77nqsFxwom7l6pPv0kbdbOFgl2gobqVxsZRIKsrbX4jC20ZUD8h
	fxpJmzSYpTNhOAAvbV5raw8GLrnVyqox9/Pwp9niec/JV+9+y9ir2GilpoEGgcOo1W8ulmrS5u1
	LBP/qeqysB3ja/4/xATZa4QVpo3WZEbEl6rSn
X-Google-Smtp-Source: AGHT+IHuTxwhhaxfDXpwsGGicEITW9gtMOvw6Tfvz+5/juL51xTCIjaJfAoPglR1/D0PNXoYflj/XQ==
X-Received: by 2002:a05:600c:1c1c:b0:43c:fda5:41e9 with SMTP id 5b1f17b1804b1-454a562a89fmr36055635e9.31.1751482804732;
        Wed, 02 Jul 2025 12:00:04 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7ec69dsm16541953f8f.6.2025.07.02.12.00.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 12:00:04 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v4 56/65] accel: Expose and register generic_handle_interrupt()
Date: Wed,  2 Jul 2025 20:53:18 +0200
Message-ID: <20250702185332.43650-57-philmd@linaro.org>
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

In order to dispatch over AccelOpsClass::handle_interrupt(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::handle_interrupt() mandatory.
Expose generic_handle_interrupt() prototype and register it
for each accelerator.

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/accel-ops.h        | 3 +++
 accel/hvf/hvf-accel-ops.c         | 1 +
 accel/kvm/kvm-accel-ops.c         | 1 +
 accel/qtest/qtest.c               | 1 +
 accel/xen/xen-all.c               | 1 +
 system/cpus.c                     | 9 +++------
 target/i386/nvmm/nvmm-accel-ops.c | 1 +
 target/i386/whpx/whpx-accel-ops.c | 1 +
 8 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 6d0791d73a4..dc8df9ba7dd 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -67,6 +67,7 @@ struct AccelOpsClass {
     void (*synchronize_state)(CPUState *cpu);
     void (*synchronize_pre_loadvm)(CPUState *cpu);
 
+    /* handle_interrupt is mandatory. */
     void (*handle_interrupt)(CPUState *cpu, int old_mask, int new_mask);
 
     /* get_vcpu_stats: Append statistics of this @cpu to @buf */
@@ -93,4 +94,6 @@ struct AccelOpsClass {
     void (*remove_all_breakpoints)(CPUState *cpu);
 };
 
+void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
+
 #endif /* ACCEL_OPS_H */
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b61f08330f1..420630773c8 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -355,6 +355,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_thread_routine = hvf_cpu_thread_fn,
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = hvf_cpu_synchronize_post_reset;
     ops->synchronize_post_init = hvf_cpu_synchronize_post_init;
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 841024148e1..b79c04b6267 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -85,6 +85,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+    ops->handle_interrupt = generic_handle_interrupt;
 
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
     ops->update_guest_debug = kvm_update_guest_debug_ops;
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 9f30098d133..47fa9e38ce3 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -68,6 +68,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
+    ops->handle_interrupt = generic_handle_interrupt;
 };
 
 static const TypeInfo qtest_accel_ops_type = {
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index e2ad42c0d18..a51f4c5b2ad 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -154,6 +154,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
+    ops->handle_interrupt = generic_handle_interrupt;
 }
 
 static const TypeInfo xen_accel_ops_type = {
diff --git a/system/cpus.c b/system/cpus.c
index 8c2647f5f19..efe1a5e211b 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -246,7 +246,7 @@ int64_t cpus_get_elapsed_ticks(void)
     return cpu_get_ticks();
 }
 
-static void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
+void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
 {
     if (!qemu_cpu_is_self(cpu)) {
         qemu_cpu_kick(cpu);
@@ -261,11 +261,7 @@ void cpu_interrupt(CPUState *cpu, int mask)
 
     cpu->interrupt_request |= mask;
 
-    if (cpus_accel->handle_interrupt) {
-        cpus_accel->handle_interrupt(cpu, old_mask, cpu->interrupt_request);
-    } else {
-        generic_handle_interrupt(cpu, old_mask, cpu->interrupt_request);
-    }
+    cpus_accel->handle_interrupt(cpu, old_mask, cpu->interrupt_request);
 }
 
 /*
@@ -674,6 +670,7 @@ void cpus_register_accel(const AccelOpsClass *ops)
 {
     assert(ops != NULL);
     assert(ops->create_vcpu_thread || ops->cpu_thread_routine);
+    assert(ops->handle_interrupt);
     cpus_accel = ops;
 }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index bef6f61b776..d568cc737b1 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -77,6 +77,7 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_thread_routine = qemu_nvmm_cpu_thread_fn;
     ops->kick_vcpu_thread = nvmm_kick_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = nvmm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = nvmm_cpu_synchronize_post_init;
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 8cbc6f4e2d8..fbffd952ac4 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -80,6 +80,7 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->cpu_thread_routine = whpx_cpu_thread_fn;
     ops->kick_vcpu_thread = whpx_kick_vcpu_thread;
     ops->cpu_thread_is_idle = whpx_vcpu_thread_is_idle;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = whpx_cpu_synchronize_post_reset;
     ops->synchronize_post_init = whpx_cpu_synchronize_post_init;
-- 
2.49.0


