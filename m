Return-Path: <kvm+bounces-51521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CED0BAF7F08
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95F5C188A243
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2122F2347;
	Thu,  3 Jul 2025 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dnhe/ZOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2583D2BEC5C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564177; cv=none; b=OHQkM6+8rhSGOI4w76gP3l6mKglQTm0kccG0yC90gB71YpIOMsFpzW/gfSp4H5aNfGmqF2CP8CEBYTrBJ9kVvKZ5N6n7/ncBkGn2VQKGJUWyKKIK13LoKVpYKDfdw5SCLQ6I2SPGecjgLSaCfnSoea5RP7oX4/Rv481y3mcdV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564177; c=relaxed/simple;
	bh=U3k0pWvR5I0kJl4pkEub9SQPswW8UuWRnN2FTNZc0fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAUbLU/5HFtXr2Qe9PozojgH6jNUC9ZqEyyyySHa1vFtWZ0zDtcAI2VIX2O/ppJJ2mCx3wKlitwdRTSfUkzdpnmV1VC6mEzB2GrGqtEOM7x7Yv8iA0MHU3DWxd70piEnlttrU6pHaHlc3v+Yyo0naQHbSssDtw8lT/305eksLlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dnhe/ZOh; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45363645a8eso893715e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564173; x=1752168973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/MPU0TKBYtEFG1xkEVwMxLJwA3rZpWlg2w7MDgOvBBA=;
        b=dnhe/ZOhSp58mEsaEj+/hGR/Hp6wSlxD/kb5vmsM13VUN39F+Soxs7oWFyU27a6DmM
         68eUpKzcW9k68Bg79htHveVKvMHUKvT76MlYZYI/nHtaW/RcyOH+eYBGSvEChh0nUqRO
         CIVEUYZNxOVfIGKEYXk0K3rGJAAF5WZQadeJroumnulq6KXruAjBWb5BBkSCzBwhoQxH
         34Ci4rWJ8J1xqWnWH5AYvQAqQgJEPieDzr4BFW8fcGtlWNsiH+rmiTaNu/pjKAq1zGqH
         XIYn+7OZRoT+FMt4nM1O+jTz4F2njddlxmE1eacO1BCTGpMod76hd+FZUWB4eOaYtd/U
         EFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564173; x=1752168973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MPU0TKBYtEFG1xkEVwMxLJwA3rZpWlg2w7MDgOvBBA=;
        b=K+uUosE/8Qb6hBqLZmrhfl4WYhEOgVcDE/KS7bYaSbgpnyz2Q+ZK89wNi6fCHgzgnJ
         A4RrhwzOmHdhDxy+U5jzzBq/Zk7zblviTLowZKmPooK/1cqv8bK7BFNgKLvlg3tZYN+y
         l/eZ7B3yhq1I8BBTY1N4d6kWam1s/2P2IdzqpXM7u6dAF7SZWB7cW8eGCRSvcN3u86fa
         vehyTlhXYpmJC06qXxY3Zp9mtd0LAsCs5/S/aIbVBbzziASrerha+6WjhLgIVQ6l++O4
         7qqAkbxfSC6LvpV98ODBeji8vAiwogIA87uUndlfizS+oorhpkEutJRRRRAehtNRl7fv
         Mz2A==
X-Forwarded-Encrypted: i=1; AJvYcCWZORKAk4aIxhsB406+idK/aumHp4qEHk1PuaGk0AoHCBrM+Cw8sckKppRovms0Buum5Sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YybF769bf8w5hfZ7vrCUDpbE3J6+OnO2eto6mCoLs2faozBSYcG
	lBXrcoGKo4yBYLFrReoeDYHhYFa99K73vJhz5wShOGZxjEAhoPSHzfAUEpftszXStKI=
X-Gm-Gg: ASbGncvQJTs8JgISrsTXOfPEBMMcZzHO81Z8B+DWtEiVB9A5uSAQ8GRT6L6Ws/Nje3m
	NkJEFMeRGZJl/cODNJBE+LTcVXB8/M79bit45Lz4bjFY1mFwJ2lvi6GhCOPtkAQTFH+IHbZLkSU
	Ka+TiOEdZbSoaDYPlwQHYwxzaDnds7b4lsAbZFoTJJrfmtd9e6v+ABuIRuQhFPlM4YnFVC0+8oH
	VgGbIyjijzSgln1yzXHGf178+I9EG9NQePqYtCDmqmpRKw5efKlboCoEkXYYt3pUsKAmCB+ZOv3
	+El9q6G2FppAqURjl+pPIst8S8iqga5/EysGz3hC6xvJBb420iWYZ11AjvJGhF+3hFtJDMlvfXW
	GV4CVxgypU1OHjzXI3reKcJtv6IAAGdHfxu8d
X-Google-Smtp-Source: AGHT+IF1KdJk6c4ueSnjnRty/oc46EojwVkf/EW5AwRmuKQECJq5AW7BgV+yFnxaCbwEOJm8eBUtQQ==
X-Received: by 2002:a05:600c:c8f:b0:453:9bf:6f79 with SMTP id 5b1f17b1804b1-454a9cd69d9mr43963695e9.26.1751564173127;
        Thu, 03 Jul 2025 10:36:13 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997de2asm32406255e9.12.2025.07.03.10.36.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:36:12 -0700 (PDT)
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
Subject: [PATCH v6 37/39] accel: Rename 'system/accel-ops.h' -> 'accel/accel-cpu-ops.h'
Date: Thu,  3 Jul 2025 19:32:43 +0200
Message-ID: <20250703173248.44995-38-philmd@linaro.org>
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

Unfortunately "system/accel-ops.h" handlers are not only
system-specific. For example, the cpu_reset_hold() hook
is part of the vCPU creation, after it is realized.

Mechanical rename to drop 'system' using:

  $ sed -i -e s_system/accel-ops.h_accel/accel-cpu-ops.h_g \
              $(git grep -l system/accel-ops.h)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/{system/accel-ops.h => accel/accel-cpu-ops.h} | 8 ++++----
 accel/accel-common.c                                  | 2 +-
 accel/accel-system.c                                  | 2 +-
 accel/hvf/hvf-accel-ops.c                             | 2 +-
 accel/kvm/kvm-accel-ops.c                             | 2 +-
 accel/qtest/qtest.c                                   | 2 +-
 accel/tcg/tcg-accel-ops.c                             | 2 +-
 accel/xen/xen-all.c                                   | 2 +-
 cpu-target.c                                          | 2 +-
 gdbstub/system.c                                      | 2 +-
 system/cpus.c                                         | 2 +-
 target/i386/nvmm/nvmm-accel-ops.c                     | 2 +-
 target/i386/whpx/whpx-accel-ops.c                     | 2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)
 rename include/{system/accel-ops.h => accel/accel-cpu-ops.h} (96%)

diff --git a/include/system/accel-ops.h b/include/accel/accel-cpu-ops.h
similarity index 96%
rename from include/system/accel-ops.h
rename to include/accel/accel-cpu-ops.h
index 17c80887016..a045d7c5d4a 100644
--- a/include/system/accel-ops.h
+++ b/include/accel/accel-cpu-ops.h
@@ -1,5 +1,5 @@
 /*
- * Accelerator OPS, used for cpus.c module
+ * Accelerator per-vCPU handlers
  *
  * Copyright 2021 SUSE LLC
  *
@@ -7,8 +7,8 @@
  * See the COPYING file in the top-level directory.
  */
 
-#ifndef ACCEL_OPS_H
-#define ACCEL_OPS_H
+#ifndef ACCEL_CPU_OPS_H
+#define ACCEL_CPU_OPS_H
 
 #include "qemu/accel.h"
 #include "exec/vaddr.h"
@@ -88,4 +88,4 @@ struct AccelOpsClass {
 
 void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
 
-#endif /* ACCEL_OPS_H */
+#endif /* ACCEL_CPU_OPS_H */
diff --git a/accel/accel-common.c b/accel/accel-common.c
index b3fbe3216aa..b490612447b 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -10,7 +10,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "qemu/target-info.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "accel/accel-cpu.h"
 #include "accel-internal.h"
 
diff --git a/accel/accel-system.c b/accel/accel-system.c
index 637e2390f35..451567e1a50 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -26,7 +26,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "hw/boards.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "qemu/error-report.h"
 #include "accel-internal.h"
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index a0248942f3a..b13937b29e1 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -54,7 +54,7 @@
 #include "gdbstub/enums.h"
 #include "exec/cpu-common.h"
 #include "hw/core/cpu.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "system/hvf.h"
 #include "system/hvf_int.h"
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 2a744092749..2c8f4fecb17 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -16,7 +16,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/kvm.h"
 #include "system/kvm_int.h"
 #include "system/runstate.h"
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 2b831260201..a7fc8bee6dd 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -18,7 +18,7 @@
 #include "qemu/option.h"
 #include "qemu/config-file.h"
 #include "qemu/accel.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/qtest.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index bc809ad5640..8f071d2cfeb 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -26,7 +26,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/tcg.h"
 #include "system/replay.h"
 #include "exec/icount.h"
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index bd0ff64befc..55a60bb42c2 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -19,7 +19,7 @@
 #include "chardev/char.h"
 #include "qemu/accel.h"
 #include "accel/dummy-cpus.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "system/xen.h"
 #include "system/runstate.h"
diff --git a/cpu-target.c b/cpu-target.c
index 1c90a307593..2049eb1d0f6 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -19,7 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "exec/cpu-common.h"
 #include "exec/tswap.h"
diff --git a/gdbstub/system.c b/gdbstub/system.c
index 03934deed49..1c48915b6a5 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -20,7 +20,7 @@
 #include "gdbstub/commands.h"
 #include "exec/hwaddr.h"
 #include "exec/tb-flush.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "system/runstate.h"
 #include "system/replay.h"
diff --git a/system/cpus.c b/system/cpus.c
index f90b8be9eee..dae66a1bc4d 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -31,7 +31,7 @@
 #include "qapi/qapi-events-run-state.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/gdbstub.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/hw_accel.h"
 #include "exec/cpu-common.h"
 #include "qemu/thread.h"
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index a5517b0abf3..3799260bbde 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -10,7 +10,7 @@
 #include "qemu/osdep.h"
 #include "system/kvm_int.h"
 #include "qemu/main-loop.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 31cf15f0045..2b51b35bfa6 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -11,7 +11,7 @@
 #include "qemu/osdep.h"
 #include "system/kvm_int.h"
 #include "qemu/main-loop.h"
-#include "system/accel-ops.h"
+#include "accel/accel-cpu-ops.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 
-- 
2.49.0


