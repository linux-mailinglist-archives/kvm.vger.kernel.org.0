Return-Path: <kvm+bounces-51422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CBCAF711F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C222D527235
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD0D2E3B01;
	Thu,  3 Jul 2025 10:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XBftEJ9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7B72D9EEE
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540246; cv=none; b=FauXXz3WyudzEqwQlvSlq0glQe8kfCY62NsW5guG8ree5lZcvAzgxR8M5CqZUNS5vKh+UXZWfGAER+G/4k79NHqgfuxYFJtpevZOvDm78ACGcQ1wLp4/nOyuP7MgtV8JJaozOwvPdMs+fJ8pOhBydDt9bzrYenR2gjSpWjg88Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540246; c=relaxed/simple;
	bh=C7unUZP6r2JhngrcsaoqPmgFjPaxAh8NxsLNTmYaLig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLwKYpdqZV2MvVuRqBGRqoIBwuS9paXpZXNviXDNTfNyeoAsNjdXSP7piTHSnYjYIwmVq2gOxa+YdApYqc4e+WATNoqRU7qLkm/ABI6eXkza6gQHBIBcY2JatpPv/9uInPg+/1rcSP9uB55IQ8aO1KMAN5ZRUiMKTT6fziP44sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XBftEJ9b; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45348bff79fso55544815e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540243; x=1752145043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+aB/j0dD+Tw6oDsMLdkju47YZrsXLX4R6aGxhn5wulM=;
        b=XBftEJ9b5BqH7FWmX2P83m6c0vA7Bt0UoJgSyYYwmssjW3W+eQcQZHZ9Oouu7PCdO+
         NcIdPAnXvKRvmWiqKzTlEdkCGIh3LpNa+NHAlBPeJHyaLG1fh2J6ynMDv1kAFFeyE7gw
         0+6YxU3hCbMuCsA7JZ3NF6xne8k89Npq7Jdw3o31yM7bZeqOK4GmipnsWrqeyBo+KOdE
         R8NnmOJvkGY8k7mkuTAFtiGH4jNbFFnqPuBypUfNyU6fdyp4eJ6ISSPWaVRKgd0X1z++
         seUeA8atnj13wh/lj9LIvoZH91sfOmy8IjZZ8xIyFOgd3JY0zeEfuorJgTc3Yu9Z5IO4
         M5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540243; x=1752145043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+aB/j0dD+Tw6oDsMLdkju47YZrsXLX4R6aGxhn5wulM=;
        b=Xp35v1y80aok7lWoLALpsxmIJnIqIzfPL8ZgK4HFL0mpVLaqpx5F8n2KJyinSARRNe
         lqc+DCm+J2kk9sWk/8fgxQiGwkxu7JfzzgvQFZlOk+KC3jncJESAm5Nwu9NeTdvA5PdK
         gKSb22E26L+3/9li7SPYVb/vDSgmeLTMyBenybCLAx1R7QWeuuQp9E87NHd8cqumnxJ9
         4uY2dy9DSlBQNtFyeG2wc1A4C4oqhwzZ4goRmp9LZICukBQr26W96d0LyoRLhskxtlGF
         KzYXK61N03XpjTScBZnij1n5UDm0tF2KOfy3VeFfw0BvOziy9qZd2ZK3btKc0Wg2O7GT
         9vkQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+xDt+XaG1F5qyY+EttMuh/mV4zQh2nLmXeJvp11x/SJn/ss1xtnEdowcFhhBzU1296MM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbW9NNb3hxU9buONvKp6t26Bp/4KNRryagCPWC4omMAWuFp3TJ
	e2fGSeH5hLtq59/cwT5cMiXVw3iYyySq9B36w7FXoNwDJSTVkvBLv2iilSJfCQd0k0fzzFDUJO5
	l7Xj1TX0=
X-Gm-Gg: ASbGncvxRQncckCpMgT7+ukEYuN7neRsRzyEhk+jFxFLvUlPZ5kd7yoKJ2TuigAaUBu
	En6omfQixmEKt6T+CXjOFjalyiI5vRWsHzTpHxcyyYycx6ROiogEy7BF2Vk7eKDvrEv20uKZb9b
	YSLTEKxb7ncc/ZD4C25vPTTVzoiddyuDnAYbsVRMLfUxCvyXmzKOlSC8vWW3udUt6Je9RrSDqZE
	LGCG7SIRuguwGTyHBV3Wr1fxpmv8wBXBLvY/OCLVnncIx7XdDN4+LpBcxSkeJMOX7fXsdl8wuVR
	Mh0xvQdDqSbGpMgAS6kRlTTGtTE+c452skDKbmsoFm2DuV5SntOIL1fAKQJCy6FRw8jN93ODLtn
	f9364Ixka0a4=
X-Google-Smtp-Source: AGHT+IFY575descHYaPdwzTKawSS5YJf9NFJv4bMQ6/yUPx4/P07s8hQbXogExn1Qi/cQ/c9nYIcQQ==
X-Received: by 2002:a05:600c:638e:b0:43c:f44c:72a6 with SMTP id 5b1f17b1804b1-454a36d8b1bmr64595345e9.2.1751540242724;
        Thu, 03 Jul 2025 03:57:22 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9beb2b2sm22701505e9.35.2025.07.03.03.57.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 19/69] accel: Move cpus_are_resettable() declaration to AccelClass
Date: Thu,  3 Jul 2025 12:54:45 +0200
Message-ID: <20250703105540.67664-20-philmd@linaro.org>
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

AccelOpsClass is for methods dealing with vCPUs.
When only dealing with AccelState, AccelClass is sufficient.

Move cpus_are_resettable() declaration to accel/accel-system.c.

In order to have AccelClass methods instrospect their state,
we need to pass AccelState by argument.

Adapt KVM handler.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h       |  1 +
 include/system/accel-ops.h |  1 -
 accel/accel-system.c       | 10 ++++++++++
 accel/kvm/kvm-accel-ops.c  |  6 ------
 accel/kvm/kvm-all.c        |  6 ++++++
 system/cpus.c              |  8 --------
 6 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index c6fe8dc3913..3c6350d6d63 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -48,6 +48,7 @@ typedef struct AccelClass {
     void (*setup_post)(AccelState *as);
     bool (*has_memory)(AccelState *accel, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
+    bool (*cpus_are_resettable)(AccelState *as);
 
     /* gdbstub related hooks */
     bool (*supports_guest_debug)(AccelState *as);
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 51faf47ac69..d854b84a66a 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -34,7 +34,6 @@ struct AccelOpsClass {
     /* initialization function called when accel is chosen */
     void (*ops_init)(AccelClass *ac);
 
-    bool (*cpus_are_resettable)(void);
     bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
     void (*cpu_reset_hold)(CPUState *cpu);
 
diff --git a/accel/accel-system.c b/accel/accel-system.c
index af713cc9024..637e2390f35 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -62,6 +62,16 @@ void accel_setup_post(MachineState *ms)
     }
 }
 
+bool cpus_are_resettable(void)
+{
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    if (acc->cpus_are_resettable) {
+        return acc->cpus_are_resettable(accel);
+    }
+    return true;
+}
+
 /* initialize the arch-independent accel operation interfaces */
 void accel_init_ops_interfaces(AccelClass *ac)
 {
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 96606090889..99f61044da5 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -78,11 +78,6 @@ static bool kvm_vcpu_thread_is_idle(CPUState *cpu)
     return !kvm_halt_in_kernel();
 }
 
-static bool kvm_cpus_are_resettable(void)
-{
-    return !kvm_enabled() || !kvm_state->guest_state_protected;
-}
-
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
 static int kvm_update_guest_debug_ops(CPUState *cpu)
 {
@@ -96,7 +91,6 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->create_vcpu_thread = kvm_start_vcpu_thread;
     ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
-    ops->cpus_are_resettable = kvm_cpus_are_resettable;
     ops->synchronize_post_reset = kvm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a9d917f1ea6..9d1dc56d7e8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3974,6 +3974,11 @@ static void kvm_accel_instance_init(Object *obj)
     s->msr_energy.enable = false;
 }
 
+static bool kvm_cpus_are_resettable(AccelState *as)
+{
+    return !kvm_enabled() || !kvm_state->guest_state_protected;
+}
+
 /**
  * kvm_gdbstub_sstep_flags():
  *
@@ -3992,6 +3997,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     ac->init_machine = kvm_init;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
+    ac->cpus_are_resettable = kvm_cpus_are_resettable;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
     ac->supports_guest_debug = kvm_supports_guest_debug;
diff --git a/system/cpus.c b/system/cpus.c
index a43e0e4e796..4fb764ac880 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -195,14 +195,6 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu)
     }
 }
 
-bool cpus_are_resettable(void)
-{
-    if (cpus_accel->cpus_are_resettable) {
-        return cpus_accel->cpus_are_resettable();
-    }
-    return true;
-}
-
 void cpu_exec_reset_hold(CPUState *cpu)
 {
     if (cpus_accel->cpu_reset_hold) {
-- 
2.49.0


