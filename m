Return-Path: <kvm+bounces-51338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EFBAF6238
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63D5A525368
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 19:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92893221F08;
	Wed,  2 Jul 2025 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sKKVKijv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BAD2F7CF5
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 19:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482820; cv=none; b=YPrvkOLmM/p+hw6Rq+ISzrfQujHSf0G3Yu9bRkbdcjCJvu/PMAhQVbc8bgma6uX76z4kU9PABgn4ycNxVgn5xxI1DfqvX//sS5NQpuwlFdG1TjF/2oNnkxTVAMaqCKwQOcErwl3MCfNRdKUAkljfqkqdZXcl6raCEXpEgPjO5DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482820; c=relaxed/simple;
	bh=07xd0USMFl4sYnn/R8Q/0Y2xj+veTA6dJBtXuKiD8TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2aRMomkUWhFZOWgz/vEo2es+yJg7I+Xv3utKfrQsq9I86X6C1Ng3qaAWu+vZZEHgg3zVmRrXfZLeA4/rR8rq93RbQTvPrNcTYXkzcBIludu3TBnU38LT6zo3uMFP53XJXyTpvwPwI50rTkh4r9dqSkctFJZwWbvW1QQnF8AI+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sKKVKijv; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4537deebb01so25800145e9.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 12:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482815; x=1752087615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjqfaworQi5+uUmLYrSAUcjlpIaexJI+AEwRhAoMmIE=;
        b=sKKVKijvrDPFma6Tm4mozTnJSl+yvHdP/SLAU3VJWno4Opr5BGO319vCpRhpqm3yCV
         hlLaUttivSti1KLyope3ntHdlBAkC53zMFgur7G00RG9xxM79J5gOOu6ERMpuDr3/lKB
         iIZViEPxTbuBYS1+yVqk5Zm/q82/toZVeEPa2mkQUpUiyjj+zV3c5G3zHSb/5BW/bWPT
         D/GxFcKBFyVF9WsqWc8u8DcLfjQWemDMZ35eNL9uLAHSFZW+q65ag7sl8VBplg0HIuAd
         ioMXc1HGqFCVOBLvhr3UsAjNdP2pqiMWk1uA10lSV/0kfq3ZNIQPei146hvv0TZiFwlq
         SbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482815; x=1752087615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjqfaworQi5+uUmLYrSAUcjlpIaexJI+AEwRhAoMmIE=;
        b=EpKTuB1HnfppIjFohrBlUBeh4dkPkkeP4IOJqTBq5bGEJ39Q3mrZtfOon9cb/vt3vZ
         zN+KAxStki4+NyVXjDJToyC1nBKnB2nsfkckzGLXedPy8fawSVH8A867HUTjoI18Q215
         lHjWkxjYua/jCIOCtUZT6e6iUV+s15RnsBAPGOSJ4wDDNz2XjfM132loqDrHG12BvjiF
         PMEKaEAsE+0uzHcMZzd9radoA1gm8MfEjtgoOUZ4bNHsiCq1gimEI5GgPHGvFm6GRCM6
         OfJ/Ceiiz6awAMksi3uUFfmTYsA2u3bdIKCCoIlAjGTK7JXDaBevWdKUihT6GMdv57m1
         CCMA==
X-Forwarded-Encrypted: i=1; AJvYcCVcs6jasXEbC5g4MUYtRjHahKWqZaOwlOkIvLtxItuyN6dv/8id90nXxVYkdwgpoeIFeHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwtwhLRW32vIntcpOuSIBR6FXDZQB3Eo4s22slmmIye03IU1C4
	u4jJnUI80aJt4Qv8Yz//KqRdNSFBfuJ6ei5CfNQp+2DxrcjyNgVxgkycnQDdhOpw2co=
X-Gm-Gg: ASbGncsL2oing5bIdt8DRyQ66JyTZDz04DLapEQzBMDz1lf3X84AJFTo8htP5OcLko3
	1ZA/0rrhbB5y3otqfoN1FAeeYgXdobRuDjYvvi9g5j/zjTToJJiPACPb/bnIf+qI9Xo+9tZZSZb
	sviVR73LupojvlrUXLa+IuHEo5C/PGNDkr365rN0KjzGjFrPNyCqBfBkjIn/+Vn49et+wz53Da6
	qxC8RJO9G6xdO78dC7EDebfCVsuhvoPYYkgt9yG3OGA8lg0+SOHrS3ehuJHFVWKqQ++uLewA/zN
	/P7lW29Ap0wfv9cqLtxdPxpCXFq2Xrblpy2CAHPQH6H0ZOPWXEDFFJRDSWJK5SOkUVXxGYu104q
	Ix2Z/NghmXIRaNzIg4BEWObBpGIYEh/hpBwFU
X-Google-Smtp-Source: AGHT+IEMsqDmMhc/MmoijRDQjf3Y2fDb5Gx/YmjzjJrapmNl0kjGvDhI6axGOrVibgjZIifLKxTGyg==
X-Received: by 2002:a05:600c:6309:b0:445:1984:247d with SMTP id 5b1f17b1804b1-454aa185780mr4322005e9.7.1751482815180;
        Wed, 02 Jul 2025 12:00:15 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997b492sm5832775e9.13.2025.07.02.12.00.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 12:00:14 -0700 (PDT)
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
Subject: [PATCH v4 58/65] accel: Always register AccelOpsClass::get_elapsed_ticks() handler
Date: Wed,  2 Jul 2025 20:53:20 +0200
Message-ID: <20250702185332.43650-59-philmd@linaro.org>
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

In order to dispatch over AccelOpsClass::get_elapsed_ticks(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::get_elapsed_ticks() mandatory.
Register the default cpus_kick_thread() for each accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/accel-ops.h        | 1 +
 accel/hvf/hvf-accel-ops.c         | 2 ++
 accel/kvm/kvm-accel-ops.c         | 3 +++
 accel/qtest/qtest.c               | 2 ++
 accel/tcg/tcg-accel-ops.c         | 3 +++
 accel/xen/xen-all.c               | 2 ++
 system/cpus.c                     | 6 ++----
 target/i386/nvmm/nvmm-accel-ops.c | 3 +++
 target/i386/whpx/whpx-accel-ops.c | 3 +++
 9 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index e1e6985a27c..8683cd37716 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -86,6 +86,7 @@ struct AccelOpsClass {
     int64_t (*get_virtual_clock)(void);
     void (*set_virtual_clock)(int64_t time);
 
+    /* get_elapsed_ticks is mandatory. */
     int64_t (*get_elapsed_ticks)(void);
 
     /* gdbstub hooks */
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 420630773c8..17776e700eb 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -54,6 +54,7 @@
 #include "gdbstub/enums.h"
 #include "exec/cpu-common.h"
 #include "system/accel-ops.h"
+#include "system/cpu-timers.h"
 #include "system/cpus.h"
 #include "system/hvf.h"
 #include "system/hvf_int.h"
@@ -367,6 +368,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->remove_all_breakpoints = hvf_remove_all_breakpoints;
     ops->update_guest_debug = hvf_update_guest_debug;
 
+    ops->get_elapsed_ticks = cpu_get_ticks;
     ops->get_vcpu_stats = hvf_get_vcpu_stats;
 };
 
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index a4bcaa87c8d..f27228d4cd9 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -17,6 +17,7 @@
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "system/accel-ops.h"
+#include "system/cpu-timers.h"
 #include "system/kvm.h"
 #include "system/kvm_int.h"
 #include "system/runstate.h"
@@ -94,6 +95,8 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->remove_breakpoint = kvm_remove_breakpoint;
     ops->remove_all_breakpoints = kvm_remove_all_breakpoints;
 #endif
+
+    ops->get_elapsed_ticks = cpu_get_ticks;
 }
 
 static const TypeInfo kvm_accel_ops_type = {
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 8e2379d6e37..b019cf69412 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -20,6 +20,7 @@
 #include "qemu/accel.h"
 #include "system/accel-ops.h"
 #include "system/qtest.h"
+#include "system/cpu-timers.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 #include "qemu/main-loop.h"
@@ -67,6 +68,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
     ops->kick_vcpu_thread = cpus_kick_thread;
+    ops->get_elapsed_ticks = cpu_get_ticks;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
     ops->handle_interrupt = generic_handle_interrupt;
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index a8c24cf8a4c..f22f5d73abe 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -27,6 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "system/accel-ops.h"
+#include "system/cpu-timers.h"
 #include "system/tcg.h"
 #include "system/replay.h"
 #include "exec/icount.h"
@@ -205,6 +206,7 @@ static void tcg_accel_ops_init(AccelClass *ac)
         ops->cpu_thread_routine = mttcg_cpu_thread_routine;
         ops->kick_vcpu_thread = mttcg_kick_vcpu_thread;
         ops->handle_interrupt = tcg_handle_interrupt;
+        ops->get_elapsed_ticks = cpu_get_ticks;
     } else {
         ops->create_vcpu_thread = rr_start_vcpu_thread;
         ops->kick_vcpu_thread = rr_kick_vcpu_thread;
@@ -215,6 +217,7 @@ static void tcg_accel_ops_init(AccelClass *ac)
             ops->get_elapsed_ticks = icount_get;
         } else {
             ops->handle_interrupt = tcg_handle_interrupt;
+            ops->get_elapsed_ticks = cpu_get_ticks;
         }
     }
 
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index 18ae0d82db5..48d458bc4c7 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -20,6 +20,7 @@
 #include "qemu/accel.h"
 #include "accel/dummy-cpus.h"
 #include "system/accel-ops.h"
+#include "system/cpu-timers.h"
 #include "system/cpus.h"
 #include "system/xen.h"
 #include "system/runstate.h"
@@ -156,6 +157,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
     ops->kick_vcpu_thread = cpus_kick_thread;
     ops->handle_interrupt = generic_handle_interrupt;
+    ops->get_elapsed_ticks = cpu_get_ticks;
 }
 
 static const TypeInfo xen_accel_ops_type = {
diff --git a/system/cpus.c b/system/cpus.c
index 6c64ffccbb3..d32b89ecf7b 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -240,10 +240,7 @@ void cpus_set_virtual_clock(int64_t new_time)
  */
 int64_t cpus_get_elapsed_ticks(void)
 {
-    if (cpus_accel->get_elapsed_ticks) {
-        return cpus_accel->get_elapsed_ticks();
-    }
-    return cpu_get_ticks();
+    return cpus_accel->get_elapsed_ticks();
 }
 
 void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
@@ -668,6 +665,7 @@ void cpus_register_accel(const AccelOpsClass *ops)
     assert(ops->create_vcpu_thread || ops->cpu_thread_routine);
     assert(ops->kick_vcpu_thread);
     assert(ops->handle_interrupt);
+    assert(ops->get_elapsed_ticks);
     cpus_accel = ops;
 }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index d568cc737b1..4deff57471c 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -11,6 +11,7 @@
 #include "system/kvm_int.h"
 #include "qemu/main-loop.h"
 #include "system/accel-ops.h"
+#include "system/cpu-timers.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 
@@ -83,6 +84,8 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_post_init = nvmm_cpu_synchronize_post_init;
     ops->synchronize_state = nvmm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = nvmm_cpu_synchronize_pre_loadvm;
+
+    ops->get_elapsed_ticks = cpu_get_ticks;
 }
 
 static const TypeInfo nvmm_accel_ops_type = {
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index fbffd952ac4..f47033a502c 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -12,6 +12,7 @@
 #include "system/kvm_int.h"
 #include "qemu/main-loop.h"
 #include "system/accel-ops.h"
+#include "system/cpu-timers.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 
@@ -86,6 +87,8 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_post_init = whpx_cpu_synchronize_post_init;
     ops->synchronize_state = whpx_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = whpx_cpu_synchronize_pre_loadvm;
+
+    ops->get_elapsed_ticks = cpu_get_ticks;
 }
 
 static const TypeInfo whpx_accel_ops_type = {
-- 
2.49.0


