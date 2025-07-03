Return-Path: <kvm+bounces-51466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5934AF7173
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB5831769B6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CDD2E03EF;
	Thu,  3 Jul 2025 11:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MWZrL0By"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3D02E3B09
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540481; cv=none; b=ksZImb5TAvCigSGanmexfian1iZ/DQlddLqnckecN1FfhMJy1Ez+HdkhnH8Ourav9ApY7mCnSTRaWor6q8LuzcrYpJ3l2hpLhRUJdiigGmE6jiWcMahYy3N7L8rlJL3erDQeJgwKCaqYs/4DjDHxBAE9AajBv4fCpfN9bDEqaOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540481; c=relaxed/simple;
	bh=q5AACzvYuTP6wq2Svo7BUTKd47cXpIS4SYznDVq4A68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRlD0AnwfHe92lfV5h6qUlk/yow8aae9bYxIVR3qjHQBqHMe54eQPHxhOKD7bFuRgres4/nBHUme8dQnIMNjpyy+ifQDzdQirKEQuMcGqGvYM/tYDmwxMZhQ4kkeJA3E2qdMGFTn2WoMLzsgnsoDPlmwcR7GOTtlx3mn0NYKiWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MWZrL0By; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso4407874f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540477; x=1752145277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uKP0VLAduRG0J485sBOx50Iuc98l/po9P1xQbbf9Dzs=;
        b=MWZrL0By0SXcrE7znhVWGRLonD0SXoBA25gsSTF2uN3y8EJ9dUkp5FuTE1PX7ZO65W
         nYRnhBIIEpDkrrlnVLUw2RMMgGP9zxcNrhqvlm63MOhQQHPy+FZhsn36M+s2g17vBLxu
         NLOWT8vUIUofFyug6FsY849uFbcNbhLS+MKq8wNmrwIZTNPJoJDmM0w+Gx87Fh25khPJ
         6FpmtAi+f7xwGQ48yqznCcnxE8rIlI2PGi3yEnDRWQxE2jV+mwCnuP0G217H7vQElkyz
         Vsa0Spz39uC3RJWTte4v4qSo7oELUcQS3pxGKhPOSsOsjurWUUf9udVbcFnZfZOSJGc8
         nNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540477; x=1752145277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uKP0VLAduRG0J485sBOx50Iuc98l/po9P1xQbbf9Dzs=;
        b=oRzdYMjbMPUTkwaYZ68gv7+lUemIQU1jbwmn7m+FrmumdGuFrdVdqXeHvqPt8xtd1N
         MUQh0DhsN7Ffsp0tTJQ1oljmrawVp7Xtl9aVBeT52dZIZus5Of0h8K72M0QrApFGbvZT
         6zICxAAX4NmmwkpVVdBxqVISWROTd6cyMxMMaXLIm7XrLu1Wx5/CRgNX11+DIM4cFkpu
         oZbpufjwmkv6z1XGxl0Iytfpw7K1kSHWc/hadzK8h1gu9dmHWXq2oc0Wtwd2h2IKX0/e
         Z49O3pU2VYtTfKu9A42dmJkiBlwLK1Bcc+RrG4ZE+TDCGb5+Xv/IvLcF2GD90gJ4+ehi
         3lRg==
X-Forwarded-Encrypted: i=1; AJvYcCUJtwwBrl4IX3mXn3L34ufSMEKFw9XPF2dh/ksL1nVeUwIExDChkoRHq7Lb2M9EmOxxdIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9ytJgmqqlQq9Kw3ky7XCXMX6u6qflixIXOjuJ1Mnyga//5iPF
	xZ2Zi3iOYE7xsoNi09hk/w+t1pi6oFvvvhulIz8e/mF1rihIQH2xZzK1CNhdqKloq/E=
X-Gm-Gg: ASbGncvsmmRYB5A2IbsU05s7TDAkWRITiXJ8XsBXcUWHjbdngqkPj1gvKpqSiGhxUEw
	2ZrS3UXd6/qxv9mlxk0oQ5slYhmWlmfTbTItTW4n4RAl22QdH2k74/roDHqzlk8MDctt3pvkV1E
	c5LqtAO9HMxSDvdqpVN0Hg2kZXcWMVsbAWSmwmwT4qFJC2+4i1TOV12+u3A5+E9BtZ7yDhaFvsK
	nWU3ubUX3cyg6VCITpIjwtM7ppTy9gDehhtctIVfAn7EhIRXvIexAnIhSomXYW3XZYq1SKRdpVM
	29w6we1MD0P+ZUnzHmp3SkbIN1bP1NiF9NphvPPBwtw451R+YxQ2V1h0HNvxiEqgAHZ6SGKIdbC
	XLtSHJe/CSGg=
X-Google-Smtp-Source: AGHT+IH1waIm5SnslmK1jzYHT2bCe4cwQIZPcz0opPv+3p5nz+zh7l6lVax9Sh2kElftxEKA9kEKhw==
X-Received: by 2002:a05:6000:22c3:b0:3a4:d8f2:d9d with SMTP id ffacd0b85a97d-3b200865a0amr5118820f8f.38.1751540475685;
        Thu, 03 Jul 2025 04:01:15 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e62144sm18640340f8f.92.2025.07.03.04.01.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:15 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
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
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 63/69] accel: Always register AccelOpsClass::get_elapsed_ticks() handler
Date: Thu,  3 Jul 2025 12:55:29 +0200
Message-ID: <20250703105540.67664-64-philmd@linaro.org>
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

In order to dispatch over AccelOpsClass::get_elapsed_ticks(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::get_elapsed_ticks() mandatory.
Register the default cpu_get_ticks() for each accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
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


