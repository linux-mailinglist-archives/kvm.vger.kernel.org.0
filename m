Return-Path: <kvm+bounces-51333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15531AF61FD
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 393231C4724D
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C8726B0A5;
	Wed,  2 Jul 2025 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jvJLGW5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29995221F06
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482548; cv=none; b=WglH2woydGbnlh80SxPJFRT2xQYahRmsxrbI+mq3JSMYiYhXyxtPeEMopIPRqyUl8f6sE3fAIdPW41onVmKTzR8w4Ju1HgGXJuLjJahuz1kbAl9wwMpjJFvgPjGeRUtH8Zb9R0Xr6M45pjY9qsY6rOFPxOF77arXFcJWZrhEYPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482548; c=relaxed/simple;
	bh=C7unUZP6r2JhngrcsaoqPmgFjPaxAh8NxsLNTmYaLig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sWNT8N9cfuijSANHMCo1peNjre0UtBMv9VHKoahHx8ezhXd8nRrsPXxMU9+kbDI2U3puycG5ef1pzmYdtwnJuN2MU75Y5OzXr24UdRyz1ief/P0UE+T2HSZ6I2/5Dwn7nzdmWZh3NBKDfszD0/auH1k2IOhPJbLXVoODfa303q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jvJLGW5J; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-450cf214200so39896625e9.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482544; x=1752087344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+aB/j0dD+Tw6oDsMLdkju47YZrsXLX4R6aGxhn5wulM=;
        b=jvJLGW5J0hxkSA1fsiBGEf+vKJIX7pIN5Pnzk9Tu0v5MYOp7U7egIPd31jh83ajZ2U
         +6+jLah4h26xVoaAHMKDH2NVfnYoyP10osY1aCrl/HJRyOanxJ0JB6XkMPnr6MOVjX8i
         moRdKN9YdyjdAPCJ9rrzoE42AIkitKPP3H6HSYZzlQlDznq66G8BQefwq6HcXWYDdunv
         vmofDdBAsLqaGkeqp9J4sd4tbgexmePtuj9dIIklVRQZvkd61X89yabyKlMU8wX5zyIT
         WG+nVoOvmIvZXIkvGKpOXbalc7bzbYJDJE6dnKa5oDqKLQwyLuWRhnTMvQzbIJIxGbii
         xedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482544; x=1752087344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+aB/j0dD+Tw6oDsMLdkju47YZrsXLX4R6aGxhn5wulM=;
        b=qx3edO2wxysz03kB0Mm94u+ChJCPPHDUOnC1CywjX82+OmYvkfItC0nXjgoiLFz6VS
         toQgn93hrPSYYhyx/hImBZq4686WVFZKTI9zNpz1xSUiqTr2Dz6ogUUojZnsxedzkW7t
         HQfmFVJ4xfFL3rTSIKgGruguRAY1ihgSMwXyXuyBofJ1e0tWX9PW0H52NUGWMb78V7nJ
         JMQxp5p7Kq4/5JrLoVZ21Pv4N5c+784R7cD4J2DB8zCciQzqlORFanNOryG6ZF3vBqam
         anTppWMdKnX5eJ4jOXd2gIcdMTkJM0qHqdJAaJhktpikOubvdUFJkWPBxZawjzcjCl5H
         e6JA==
X-Forwarded-Encrypted: i=1; AJvYcCWFA6TpNXBg3RWPMSkXDKqXbrrpgDqGB60fEl5/zIIC2d1ebmEx++HLHUrm6VZYMnMxpJk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8H/aSgxjT4aXMXbyJnyNLOUU7o4sFeIpKv5lCoisNTZruLNTM
	w8tCAT3MRg+pn7t+WCp31ZD4UDdYLhM7h5Mzo4IdPAqq3AvpyJFzf0aeEn21raPOooQ=
X-Gm-Gg: ASbGncu5gZ0VcXTMD1kS32fHM3cFPRYBpAfo8zTS0crDipcLeWHMQgpoHNk5k3Tnd2U
	JVwd6dMO/VbpgJ3+oEJ6WCtXyAyUzFMggmFIRglmruh/i24LNt3OGyDMgsIlTOeCD3pbvHmXQLN
	u7IlgQH6plcLl1EhCscH+bF1UBt2V5Y27/sqhFSGXby4Qnz4rCHmT7m+GvsaOR0pj86T/F80klb
	2XmANtSYYbnPeQdtT6NpB6+/rX1T22+mA+ZZYHTbksiU6oagGyQbd24OGgTvkGzF+vrfPHSmGz/
	5qMgyIhBpNYXooa1HMOk4euex8IqgJk7s7p/tyTN4990fM6yA6CX2xXyETgdYLJy6wCjo/25HtR
	Jf0ksQCqdkXwcnC18yvzXh38uK4aS3LMTBrng
X-Google-Smtp-Source: AGHT+IGCW4bTbz2dddSy6xxWh/wDXlXfWVKxcFEebZ5EDZfLvPjucngnBF2tRtCLb/AVvYsFIqjy8w==
X-Received: by 2002:a05:600c:6305:b0:453:6146:1182 with SMTP id 5b1f17b1804b1-454a9cb45afmr6910235e9.32.1751482544367;
        Wed, 02 Jul 2025 11:55:44 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde8c8sm5692795e9.31.2025.07.02.11.55.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:55:43 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 18/65] accel: Move cpus_are_resettable() declaration to AccelClass
Date: Wed,  2 Jul 2025 20:52:40 +0200
Message-ID: <20250702185332.43650-19-philmd@linaro.org>
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


