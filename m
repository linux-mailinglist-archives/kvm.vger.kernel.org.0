Return-Path: <kvm+bounces-51421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 63572AF712B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B5617A8EFB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D282E3AE5;
	Thu,  3 Jul 2025 10:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fHjMZcvy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3009329C335
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540241; cv=none; b=hqyY89tkCVW706MmC0BqIYeNy6mVI+RaHfM8QNre+Ho+N3Ug4zuc9KfuShoAaItqQV2OmJ+xjn0xxSwpu6EYOT07RuO/j+9XsLi5KB5+23wG5Aauv1o5+7aCz2nZ/Y6ZXcSieYwGvQMugyN36LDPRKDEwQSm0OezaxHSSZFCE6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540241; c=relaxed/simple;
	bh=7U2sJFXT38SD2/BGPiycgIPH7szZA5ie4SIr5FLBf8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6Cqy/bVwI2NftBD4cBfSENJLHc++zX2Rtzp5xCzQe1uZ0ea5rs3ehpsBrU6GWagq2Rb4nXtjd7O0QpSFp7Slek4mJPF4FC8gasTa+25ZjQ2Gsg5nGzZiOhi8EpOsRCq3PQbj3VDEAwerzWHFsmQA8sOVzSDswfpYAIjmtbwNas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fHjMZcvy; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso55529515e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540238; x=1752145038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bV84MiQpGOn60kTDkD54slrXkuHu95fcxpVNCRAl6i0=;
        b=fHjMZcvyKyw32wkIx3CmnjlHAIz4MJuYVN3HO5MJFI15/h4KsDVPYVnw4uOMdEf4vB
         +rdwMsQpTU4j/XmfvzA3Dyfz+mAIKCypW55ngJLH2Fda/fncRDuOHuNvze9kGWh/KBFc
         hbZofnWhkMOOcGkDj3dzFBCx1mta8zR1jssseZ4lizy+itnkvYvkKxN1wEUUIgkO4mzG
         ZXYh3iihvlU/RyV3RkzmtUyJObEYnfxkvT3cwZ9k1iJu/4ml0GtaZ3RMwVCsCXkYTwud
         6S/1ZU0ZB73ZHSSAnW/aAOAZ9mIKjMgGyvYgIvwouVkm6RB0u1kW0lxfGYZFmF3QWodl
         S7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540238; x=1752145038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bV84MiQpGOn60kTDkD54slrXkuHu95fcxpVNCRAl6i0=;
        b=WAzk0DfqPmcLfqIyP1GUzYJ/ywcUV/t29HbNaYGEiKHz3PXKvRfxYCGJqFEl9SqHij
         kS9/Q4FwrwL5tGVYu93VzDYwn/8JsQrtaWsFYXXaCA0Mi75Eu2HPLIdeESsXddNlSYDD
         DkCiq3QrfW0BTeQx5QCUpIZ0eIsFMxiy4A+E2bSeHZpSskGAVijMBP7BdvE9f+oH5ncV
         bZQtKk21OsYQ5IHVs0ymffjjsGj77FVrJexB6Vd9+3E92ZUXLoiVkBhk7FAzx/7HKiBC
         2W9M4U3LmxHEzEc2eliHmvnlLHrFyTB3mqSBXs9/zxyqow6JEFyaOJGwXOCZiZspHN2y
         5LyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgdLVmMptBNlsCRvaLZA7/1pF0TNro1+TvO9a5hDGbDzoa52bvTWcBqDa5bP6JvQt5xcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxppipHzUKwFvSx2PDkVfpttCQkE7c2/RIQHqB2NZEXVETEldhO
	NwMwIxv9y3v7NF4iVH3YNMjwQRWj5QXjORAolcaM3+R+fCHFGHJU0lK/4rbuVc20vd4=
X-Gm-Gg: ASbGncvs8rsvBJyiKX3/7TfNJWsp8UhXLAs+/5+QqgtgNz3q4V/8+LRM5tKOrfHWP0G
	22ukXyXeP2yZ5kcCQGS/HRsn+NXaPTT+uAR0XssyKoYCxR2DsWjOE1Hmh6IcsWPMA77ZqiGXqdr
	tdw2zC4Qpa/WP/NCcwou7mDnovpX0dfeSfybjtzBxixEGGYAhwLFRVmwEIKjKumcGYjx3UfgN03
	2maCQLCmLVQt1lRb7tPu45JPMz0ntiVejs9MxJLyqZr6VO24DaHD859GLY0Nwyrdcn1DdG+rZST
	yWDwCAN58txjg2d/BzBfaHYUXLzO0tjEMIzsjnhsibhmr/ThSdfdQYeT+pUPJsTPX1VQl21+G0o
	2AEITawzd94s=
X-Google-Smtp-Source: AGHT+IEmNLvtVHQf9NpB/fQmjEXmTAthaVxxUyGp9hx2gO4yuAi9n/eHxM8kk1TDX0WcFyurTuexYQ==
X-Received: by 2002:a05:600c:5248:b0:453:dda:a52e with SMTP id 5b1f17b1804b1-454a373d342mr54355175e9.33.1751540237572;
        Thu, 03 Jul 2025 03:57:17 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e591d7sm18631695f8f.67.2025.07.03.03.57.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Alexander Graf <agraf@csgraf.de>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org
Subject: [PATCH v5 18/69] accel: Move supports_guest_debug() declaration to AccelClass
Date: Thu,  3 Jul 2025 12:54:44 +0200
Message-ID: <20250703105540.67664-19-philmd@linaro.org>
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

In order to have AccelClass methods instrospect their state,
we need to pass AccelState by argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-cpus.h       | 1 -
 include/qemu/accel.h       | 1 +
 include/system/accel-ops.h | 1 -
 include/system/hvf.h       | 2 +-
 accel/hvf/hvf-accel-ops.c  | 2 +-
 accel/kvm/kvm-accel-ops.c  | 1 -
 accel/kvm/kvm-all.c        | 5 ++++-
 accel/tcg/tcg-accel-ops.c  | 6 ------
 accel/tcg/tcg-all.c        | 6 ++++++
 gdbstub/system.c           | 7 ++++---
 target/arm/hvf/hvf.c       | 2 +-
 target/i386/hvf/hvf.c      | 2 +-
 12 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index 688511151c8..3185659562d 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -16,7 +16,6 @@ void kvm_destroy_vcpu(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
 void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu);
-bool kvm_supports_guest_debug(void);
 int kvm_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len);
 int kvm_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len);
 void kvm_remove_all_breakpoints(CPUState *cpu);
diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 1c097ac4dfb..c6fe8dc3913 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -50,6 +50,7 @@ typedef struct AccelClass {
                        hwaddr start_addr, hwaddr size);
 
     /* gdbstub related hooks */
+    bool (*supports_guest_debug)(AccelState *as);
     int (*gdbstub_supported_sstep_flags)(AccelState *as);
 
     bool *allowed;
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index a863fe59388..51faf47ac69 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -65,7 +65,6 @@ struct AccelOpsClass {
     int64_t (*get_elapsed_ticks)(void);
 
     /* gdbstub hooks */
-    bool (*supports_guest_debug)(void);
     int (*update_guest_debug)(CPUState *cpu);
     int (*insert_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
diff --git a/include/system/hvf.h b/include/system/hvf.h
index 8c4409a13f1..7b9384d816c 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -71,7 +71,7 @@ void hvf_arch_update_guest_debug(CPUState *cpu);
 /*
  * Return whether the guest supports debugging.
  */
-bool hvf_arch_supports_guest_debug(void);
+bool hvf_arch_supports_guest_debug(AccelState *as);
 
 bool hvf_arch_cpu_realize(CPUState *cpu, Error **errp);
 
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 640f41faa43..e7f40888c26 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -364,6 +364,7 @@ static void hvf_accel_class_init(ObjectClass *oc, const void *data)
     ac->name = "HVF";
     ac->init_machine = hvf_accel_init;
     ac->allowed = &hvf_allowed;
+    ac->supports_guest_debug = hvf_arch_supports_guest_debug;
     ac->gdbstub_supported_sstep_flags = hvf_gdbstub_sstep_flags;
 }
 
@@ -600,7 +601,6 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->remove_breakpoint = hvf_remove_breakpoint;
     ops->remove_all_breakpoints = hvf_remove_all_breakpoints;
     ops->update_guest_debug = hvf_update_guest_debug;
-    ops->supports_guest_debug = hvf_arch_supports_guest_debug;
 };
 static const TypeInfo hvf_accel_ops_type = {
     .name = ACCEL_OPS_NAME("hvf"),
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index e5c15449aa6..96606090889 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -104,7 +104,6 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
     ops->update_guest_debug = kvm_update_guest_debug_ops;
-    ops->supports_guest_debug = kvm_supports_guest_debug;
     ops->insert_breakpoint = kvm_insert_breakpoint;
     ops->remove_breakpoint = kvm_remove_breakpoint;
     ops->remove_all_breakpoints = kvm_remove_all_breakpoints;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 45579f80fa5..a9d917f1ea6 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3528,7 +3528,7 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
     return data.err;
 }
 
-bool kvm_supports_guest_debug(void)
+static bool kvm_supports_guest_debug(AccelState *as)
 {
     /* probed during kvm_init() */
     return kvm_has_guest_debug;
@@ -3993,6 +3993,9 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
+#ifdef TARGET_KVM_HAVE_GUEST_DEBUG
+    ac->supports_guest_debug = kvm_supports_guest_debug;
+#endif
 
     object_class_property_add(oc, "kernel-irqchip", "on|off|split",
         NULL, kvm_set_kernel_irqchip,
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 37b4b21f882..07b1ec4ea50 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -106,11 +106,6 @@ void tcg_handle_interrupt(CPUState *cpu, int mask)
     }
 }
 
-static bool tcg_supports_guest_debug(void)
-{
-    return true;
-}
-
 /* Translate GDB watchpoint type to a flags value for cpu_watchpoint_* */
 static inline int xlat_gdb_type(CPUState *cpu, int gdbtype)
 {
@@ -218,7 +213,6 @@ static void tcg_accel_ops_init(AccelClass *ac)
     }
 
     ops->cpu_reset_hold = tcg_cpu_reset_hold;
-    ops->supports_guest_debug = tcg_supports_guest_debug;
     ops->insert_breakpoint = tcg_insert_breakpoint;
     ops->remove_breakpoint = tcg_remove_breakpoint;
     ops->remove_all_breakpoints = tcg_remove_all_breakpoints;
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 5904582a68d..93972bc0919 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -219,6 +219,11 @@ static void tcg_set_one_insn_per_tb(Object *obj, bool value, Error **errp)
     qatomic_set(&one_insn_per_tb, value);
 }
 
+static bool tcg_supports_guest_debug(AccelState *as)
+{
+    return true;
+}
+
 static int tcg_gdbstub_supported_sstep_flags(AccelState *as)
 {
     /*
@@ -242,6 +247,7 @@ static void tcg_accel_class_init(ObjectClass *oc, const void *data)
     ac->cpu_common_realize = tcg_exec_realizefn;
     ac->cpu_common_unrealize = tcg_exec_unrealizefn;
     ac->allowed = &tcg_allowed;
+    ac->supports_guest_debug = tcg_supports_guest_debug;
     ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
 
     object_class_property_add_str(oc, "thread",
diff --git a/gdbstub/system.c b/gdbstub/system.c
index 8a32d8e1a1d..bced226fd94 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -634,9 +634,10 @@ int gdb_signal_to_target(int sig)
 
 bool gdb_supports_guest_debug(void)
 {
-    const AccelOpsClass *ops = cpus_get_accel();
-    if (ops->supports_guest_debug) {
-        return ops->supports_guest_debug();
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    if (acc->supports_guest_debug) {
+        return acc->supports_guest_debug(accel);
     }
     return false;
 }
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 4c4d21e38cd..bd19a9f475d 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -2357,7 +2357,7 @@ void hvf_arch_update_guest_debug(CPUState *cpu)
     hvf_arch_set_traps(cpu);
 }
 
-bool hvf_arch_supports_guest_debug(void)
+bool hvf_arch_supports_guest_debug(AccelState *as)
 {
     return true;
 }
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 28484496710..bcf30662bec 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -1024,7 +1024,7 @@ void hvf_arch_update_guest_debug(CPUState *cpu)
 {
 }
 
-bool hvf_arch_supports_guest_debug(void)
+bool hvf_arch_supports_guest_debug(AccelState *as)
 {
     return false;
 }
-- 
2.49.0


