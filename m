Return-Path: <kvm+bounces-51337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3589DAF6237
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00AA64A3674
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 19:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432292BE63A;
	Wed,  2 Jul 2025 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uV1oJ4Xl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61DA2BE63F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482816; cv=none; b=VkInMjMOZc8EYA+vt71I1z0PR4xw4EtSu1Y11K8f0biBjaNXlSLBVLESTVS1KGiXz8gdxGNBeiH8rjEzbF4vuynWeWSRzgeWJROKHNmEVpI96j/rX30Kv4ehqMhgzP9+4t7c14mvbUcDdwlrGy10tdFFFv1p9rmx9LSdvHEbqtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482816; c=relaxed/simple;
	bh=LfrQ+bBErzfdClVbwe9SY79r5t9JMHsUZ2encSpxSu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R188WX+yAYaXpXdz9lcEnVHwCEdR7js7iI0Lo8Cgi/QupEFWlqk/KrTxYoWl03PxopvbZblizIDs60h3EcMcEmA1hE8e+ywqmfPZSjzaT5v6k/VDyY0Z4KlmPMzR5tL6UmhPBFF0gsvHO6RiPzIpIMOV4ZGm0w+wAmQA86Xnt1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uV1oJ4Xl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a582e09144so3486735f8f.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482810; x=1752087610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MeO0MVHQxtzOMjVIG+Z9L61DD5vh1obKnrosrBS7YI=;
        b=uV1oJ4Xl8/sxKYOC0cYcq2Ewo/qcern254coxIWld2BJ+TzskxKsoXWdaPa2jtrYwc
         e7g/vaAXgcqG5fYGN5VTURc78lgyQaHB93suZUyC5hhyObMUVpbPi9W6IN+qqUIIk3Fz
         IoGUmpPVOMZ9GRD8PFM7EBsJ/ybzooDKAVLoxHhwGqvEsDAfISuJyXtZHsqLqBr5IUeg
         N3tU4uKt/MJMMIUAGSvAliw1vavu1+iyIYtw3p/CRpLMEF2Isb5AikfsRjN+592VkZUP
         MgFKm/KYHSUNVSLf1vdRTINScZPiRRTHLpRNoBUBTU2BMZMVkDNcJqgb4Vnqw/JONJi3
         GSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482810; x=1752087610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MeO0MVHQxtzOMjVIG+Z9L61DD5vh1obKnrosrBS7YI=;
        b=ty9Zy4nM6X/CaQaSYjN1EI2ZTIqiAArg1zwjbn4l6NoaEiw+XdShTdi3fTErrU0xlg
         4/oYfzGDvyPX1N7baiODmrrw+NvBGb6wHSphERZBP2qn9tMa/ppu/5PlfZe2XVC0hk6e
         T+JmqnyhvGmfpxssVQoNPEVFNdgxcjF+xXZy+zAue5xJf9IBnL7aRlw6FYR3hNEceXGI
         YUsCNv8V6OR9+cC52ofvebeOAyq8ab6jnNaKw3FMvJxrv/gJWShK2O9E4ou4++G99lAX
         Tf2/8JcMJ0t1yAGboD5TPDVM+QGzpHRk5BFnh6D796f+b2zdoipBEup6ms0CgRPQs88v
         OGGw==
X-Forwarded-Encrypted: i=1; AJvYcCVaq8x8QkJYJM8+/kEzPmrKHZqYZ2bVcRqrxMCYKszRxei557HEOfMnFLaDWel90NXZzc4=@vger.kernel.org
X-Gm-Message-State: AOJu0YytaHbVV5L7aGT8F7cYdt1DaMT9ZEVjp5rYBMi5OPw0zHrlRfkN
	H+rX+U+mqw7pkP8C5rHp8HDZMBjVA7n58+dsN2RMatnxtEohi+BF0kwbcgQjEJtn7xs=
X-Gm-Gg: ASbGnctMhWSqVZBov7ExZJJYv+jxuuAasZRzZupRMPlX9f7PX9/BwzU8mCllDGcq3lw
	nNLEv5Z4GPN5S8A2tUk1nU0nbapeTrRD1dYWIE0hqQpzqglzGF9EVgORQVEmh+SEXH0DKjcNZRW
	ulRJAgg5AjwIM9Ew1Jiaax/SX9koJTDp8qgKvSh12Zki7GGeODSPUrJENdXwVsZ1HafTeH9V96W
	4piQ0Wqqjt3kKpSHGbf1VXBGxemT9mTct85PTDtcC8ivDahS432CATVtIrsRjHp4dEIbZDsBbfF
	N3zuq0NbobJFcM9xuMOeNGd9R5Quq1FCH1/26X3Onj28zKONMdjzhf4/2hCqaqIjVvoZ4Lp0x9V
	0QJonBVC/RmVnFKuek72JC4lyZMGyA6UOhfrP
X-Google-Smtp-Source: AGHT+IGAzFYW2tCDZllrD+UyqAdQOcQvAD/ViiyKPGAS9AB0EUk4i5HkuSqBJEdDHxidIq6E8KU+xg==
X-Received: by 2002:a05:6000:4807:b0:3a6:d579:ec21 with SMTP id ffacd0b85a97d-3b1fe5beeeemr3514236f8f.12.1751482809769;
        Wed, 02 Jul 2025 12:00:09 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e6f23sm17160457f8f.11.2025.07.02.12.00.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 12:00:09 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v4 57/65] accel: Always register AccelOpsClass::kick_vcpu_thread() handler
Date: Wed,  2 Jul 2025 20:53:19 +0200
Message-ID: <20250702185332.43650-58-philmd@linaro.org>
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

In order to dispatch over AccelOpsClass::kick_vcpu_thread(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::kick_vcpu_thread() mandatory.
Register the default cpus_kick_thread() for each accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/accel-ops.h | 1 +
 accel/kvm/kvm-accel-ops.c  | 1 +
 accel/qtest/qtest.c        | 1 +
 accel/xen/xen-all.c        | 1 +
 system/cpus.c              | 7 ++-----
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index dc8df9ba7dd..e1e6985a27c 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -43,6 +43,7 @@ struct AccelOpsClass {
     void *(*cpu_thread_routine)(void *);
     void (*thread_precreate)(CPUState *cpu);
     void (*create_vcpu_thread)(CPUState *cpu);
+    /* kick_vcpu_thread is mandatory. */
     void (*kick_vcpu_thread)(CPUState *cpu);
     bool (*cpu_thread_is_idle)(CPUState *cpu);
 
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index b79c04b6267..a4bcaa87c8d 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -81,6 +81,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_thread_routine = kvm_vcpu_thread_fn;
     ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
+    ops->kick_vcpu_thread = cpus_kick_thread;
     ops->synchronize_post_reset = kvm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 47fa9e38ce3..8e2379d6e37 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -66,6 +66,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
+    ops->kick_vcpu_thread = cpus_kick_thread;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
     ops->handle_interrupt = generic_handle_interrupt;
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index a51f4c5b2ad..18ae0d82db5 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -154,6 +154,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
+    ops->kick_vcpu_thread = cpus_kick_thread;
     ops->handle_interrupt = generic_handle_interrupt;
 }
 
diff --git a/system/cpus.c b/system/cpus.c
index efe1a5e211b..6c64ffccbb3 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -486,11 +486,7 @@ void cpus_kick_thread(CPUState *cpu)
 void qemu_cpu_kick(CPUState *cpu)
 {
     qemu_cond_broadcast(cpu->halt_cond);
-    if (cpus_accel->kick_vcpu_thread) {
-        cpus_accel->kick_vcpu_thread(cpu);
-    } else { /* default */
-        cpus_kick_thread(cpu);
-    }
+    cpus_accel->kick_vcpu_thread(cpu);
 }
 
 void qemu_cpu_kick_self(void)
@@ -670,6 +666,7 @@ void cpus_register_accel(const AccelOpsClass *ops)
 {
     assert(ops != NULL);
     assert(ops->create_vcpu_thread || ops->cpu_thread_routine);
+    assert(ops->kick_vcpu_thread);
     assert(ops->handle_interrupt);
     cpus_accel = ops;
 }
-- 
2.49.0


