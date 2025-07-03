Return-Path: <kvm+bounces-51512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C39AF7EED
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746B817C590
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FABB2BEC5C;
	Thu,  3 Jul 2025 17:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fqPd/CPY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A840025A2AE
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564035; cv=none; b=HsyXlgd6Kj1ZCNluQ3RaW3ITopeZrhV7NqY0SpANpslwSwBj/H+Azo4Ic6YvP2v7+kn0C2mCtGJVeE2Mi83Qe0iVKmy+mF2E8VD0C/EuUBQadxF8Ysvh1w5Aqioghhhp8pqGr+puTzrFn4OqguDvxUnJDAUT5EUPvhAbjWvP5cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564035; c=relaxed/simple;
	bh=KYa05MYOC91slHCOaCgr+M2v1WnF0WYHXf5LYu/75yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDCOZumey5Zmg4IO6KuP5jmkPLx5aH5wa2XhESVG+EOPMOfTd2j6Xkhy/KbxqZa4neQUe+7bO89O4J5Tb458wb8dsKAxlia6IKhv9xTdkJ5csiJekuy+NkZs1+R0IfLAuBBmJHeAK62n3JpbqxRoMLetqHjLHuFEzh/J8JYD6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fqPd/CPY; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4535fbe0299so488565e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564032; x=1752168832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XcfnS13GIUjtg983McguNHeXSVu+J5s+ZUMQk0qRbKs=;
        b=fqPd/CPYyPVvbafqpIoXxieoRif6ejypOE/j6Rte7PkEoUl3d40ztJnlUEFMLoC8vS
         tx+E7GyuVhI81G/hskyPd/OKPOZbgrLUDEdootaxUuznz0VPq/8YzfXzo3uok6IGAXpq
         0X8wibAG83UfgMF4Tpke+WhJQbePSWaJsJ99hulOuFHz4XlcfEUGU9i27gm9BUiIsTGV
         qh8dv1Nh7Tabyd8dauPXVIwIIgu9ESxIKK+FBLJte547paDGENxZXQ+Qt7o+4iKHd4yD
         wwVAdXBGp0Y6cwpL2SwUo7twTwpZtFuTXNlOqjY5wBcHX9FWFkhXAMsQnm+otriQMFHX
         tJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564032; x=1752168832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XcfnS13GIUjtg983McguNHeXSVu+J5s+ZUMQk0qRbKs=;
        b=sAMxaTDR6PBygA2gs5V4dEMUIeOsdztge5WRJHwJ30HuSvkGU93nLVRFGc6ak9qt4O
         jP4k8xN3/pzHp3rZJjAP9lYOsOkdtG7mIjAMXYcUOfZxEmniCXrkEYkDQupFg3sJTC3n
         qp5An+EiXVrt7avS7beAwIln+1UVu71mDifFfZ8X5cu2BfVP7QW/1CUvPkZ6uvXc2KPx
         eqHFxvbA8MkbSPkMuRcSsXvW+X6tNm2p2ARC9b8q33hdLrTO4DnbrjDcWj074EnwWA/U
         aM0LLwHa0TkZ1cfQUHPg+V5G8wNM8TuYeA8AMN114bvksIwKjXCegXT0Mh5KnTu02Xe4
         XnQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuceoM3du1MC1sBq0z09bZ5PBVFv8IEw9qrOuV+3H8wR1jovj1Gt7c5PNPY0QLsGjzwjM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5QGcHUw+Zy7ESHF5OqCAmLwLMU39QhNmftk3Oo+Sw+83hONqL
	oUKZfNUwzlXtBrP7qKOMPu+zHMzyjWoa7UOn/yhR72oJpy6RzDLsRSnQgvj1CKehdmk=
X-Gm-Gg: ASbGncsGVxmZRSGPcg12J7KGDi53/X8zVqXKo+P1Jz+EwKdLFK9OxvjaE8eM3opPl8O
	P7pyhSthYAQGOl7k2r2btjkCcZScAL+xhvf2nC5GZWM62rkYjZg2Q7b1mc/lLqy01IFLIyLuzoz
	lXmc78qKkRpm2qdAYeVNZWJbD2nkZZfdZhF+OvEC5yOjIEDmCG7yPanRZ908GubMwDYo58hzN/q
	gLdSD8wMl97F1+2mib3jkcAKledeTN6kJmZKr1eqaHe3jGQgA9lhkItjei9+WqMP2JvHaxjzwG+
	DtG2TWiBkF1oCNQ+ci9oDrHbKXIsYbxdXxCtWo6Fb9C3ngmeM5FAIDdZ4TC2nCIeBoWUfMBqkWJ
	7n03AgyX3JKi8gOO2mwNXQZb9m1MuZDf9Orjs
X-Google-Smtp-Source: AGHT+IEFHjox5AGA4sYKqeK/FG7AbGqmsv8ejvJN4rlnX1vF5JW7xikwMjQzSAdkM74+gnv+3GpQ/A==
X-Received: by 2002:a05:600c:1554:b0:450:d4a6:79ad with SMTP id 5b1f17b1804b1-454a9ca8543mr46409505e9.23.1751564031784;
        Thu, 03 Jul 2025 10:33:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b1628ed7sm3556035e9.15.2025.07.03.10.33.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:33:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Alexander Graf <agraf@csgraf.de>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org
Subject: [PATCH v6 12/39] accel: Move supports_guest_debug() declaration to AccelClass
Date: Thu,  3 Jul 2025 19:32:18 +0200
Message-ID: <20250703173248.44995-13-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
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

Restrict kvm_supports_guest_debug() scope.

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
 gdbstub/system.c           | 8 +++++---
 target/arm/hvf/hvf.c       | 2 +-
 target/i386/hvf/hvf.c      | 2 +-
 12 files changed, 20 insertions(+), 17 deletions(-)

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
index fbd3d897fef..fb176e89bad 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -47,6 +47,7 @@ typedef struct AccelClass {
                        hwaddr start_addr, hwaddr size);
 
     /* gdbstub related hooks */
+    bool (*supports_guest_debug)(AccelState *as);
     int (*gdbstub_supported_sstep_flags)(void);
 
     bool *allowed;
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 4c99d25aeff..700df92ac6d 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -63,7 +63,6 @@ struct AccelOpsClass {
     int64_t (*get_elapsed_ticks)(void);
 
     /* gdbstub hooks */
-    bool (*supports_guest_debug)(void);
     int (*update_guest_debug)(CPUState *cpu);
     int (*insert_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
diff --git a/include/system/hvf.h b/include/system/hvf.h
index a9a502f0c8f..a9fd13d9bba 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -71,7 +71,7 @@ void hvf_arch_update_guest_debug(CPUState *cpu);
 /*
  * Return whether the guest supports debugging.
  */
-bool hvf_arch_supports_guest_debug(void);
+bool hvf_arch_supports_guest_debug(AccelState *as);
 #endif /* COMPILING_PER_TARGET */
 
 #endif
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b38977207d2..aed791a3f3e 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -366,6 +366,7 @@ static void hvf_accel_class_init(ObjectClass *oc, const void *data)
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
index 17235f26464..c8611552d19 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3533,7 +3533,7 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
     return data.err;
 }
 
-bool kvm_supports_guest_debug(void)
+static bool kvm_supports_guest_debug(AccelState *as)
 {
     /* probed during kvm_init() */
     return kvm_has_guest_debug;
@@ -3998,6 +3998,9 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
+#ifdef TARGET_KVM_HAVE_GUEST_DEBUG
+    ac->supports_guest_debug = kvm_supports_guest_debug;
+#endif
 
     object_class_property_add(oc, "kernel-irqchip", "on|off|split",
         NULL, kvm_set_kernel_irqchip,
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 6116644d1c0..f579685a611 100644
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
@@ -216,7 +211,6 @@ static void tcg_accel_ops_init(AccelOpsClass *ops)
     }
 
     ops->cpu_reset_hold = tcg_cpu_reset_hold;
-    ops->supports_guest_debug = tcg_supports_guest_debug;
     ops->insert_breakpoint = tcg_insert_breakpoint;
     ops->remove_breakpoint = tcg_remove_breakpoint;
     ops->remove_all_breakpoints = tcg_remove_all_breakpoints;
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 6e5dc333d59..0cff0f8a0f9 100644
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
 static int tcg_gdbstub_supported_sstep_flags(void)
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
index 8a32d8e1a1d..03934deed49 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -13,6 +13,7 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
+#include "qemu/accel.h"
 #include "qemu/cutils.h"
 #include "exec/gdbstub.h"
 #include "gdbstub/syscalls.h"
@@ -634,9 +635,10 @@ int gdb_signal_to_target(int sig)
 
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
index 7b6d291e79c..995a6a74b06 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -2352,7 +2352,7 @@ void hvf_arch_update_guest_debug(CPUState *cpu)
     hvf_arch_set_traps(cpu);
 }
 
-bool hvf_arch_supports_guest_debug(void)
+bool hvf_arch_supports_guest_debug(AccelState *as)
 {
     return true;
 }
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 99e37a33e50..b25bff0df41 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -1019,7 +1019,7 @@ void hvf_arch_update_guest_debug(CPUState *cpu)
 {
 }
 
-bool hvf_arch_supports_guest_debug(void)
+bool hvf_arch_supports_guest_debug(AccelState *as)
 {
     return false;
 }
-- 
2.49.0


