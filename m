Return-Path: <kvm+bounces-36451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2530A1AD72
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB9E3AA8F0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CEE1D5CDE;
	Thu, 23 Jan 2025 23:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LRICaLzt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87681D514A
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675935; cv=none; b=K4jsaP/5PF/hoMoXPl+hTJnPEO5Qxbzck9ALBTyUpLM9dSAaEosoqDISiitbFx7TNpZy52wRM5Fuu8yglHr4L6ClmuQVptwbkfmph4VHvO7KPqUuLfMMq7h34joLhZOWzyEGfHzr/0oWzGMDEBXM6AJ1tWHPiMerwhQ5pEeZVUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675935; c=relaxed/simple;
	bh=Fn+sKVauGezihA42RNfMpurRkUcUgeItpWd87gdoiYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y433WcJv6ylrGFj1DMYzjffrsrUgOEXay6AW3m/5xXKhtk9P1zy9VlkFgbgoZcppYIoQdMi0SwT7llfTUVW3Kb9XUL47MbUYB1v9A71ghRwsiRdmhqJbBAuRUgBi8SjehK+sBwvEvBKUqwQJRrtbPH72JSL7FuINJ2w3q9TwL7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LRICaLzt; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-437a92d7b96so15375375e9.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675930; x=1738280730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGO8rj66FytAuOx0HD2g/yFD3gx++HeKfsSZtvEWB0o=;
        b=LRICaLztZgGumRgU2LAUvnJ9e3B021VWPgkUPUMgdEwzPmL+31uBTeUXGwm9cgv/yG
         2FW3qHv0PjvwgUQtRnYQEhHJSFy4GbFkJoPZo2wdiRAhKKnP2s5w99X3T88a65btTarA
         AKM7F66ibtv2ceejSuS4krksy54z81erApxuHGh0bZ8pB+Rfzn6pUcp3+6t2NyPMoFKt
         it6PvdYVX0v9QAizag7BQh2fNUYwwqeKMdyQjAE/ZATGJ7GBbCDMBdA/1QRY71u8Ttqm
         PngBTa3nuIhr7rbtzJ2ZUAvry3V7in4w6OjIfqVHVg+A/1V8HJeeLC0NvhlmKU4OUr+a
         U3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675930; x=1738280730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGO8rj66FytAuOx0HD2g/yFD3gx++HeKfsSZtvEWB0o=;
        b=oOV98yViWEKq0y8bt+gmoJYDWlXfHr851lIgoEVKH1HL76+C9rrF1TwLefIeI3LNHT
         7Hkhra3j7A8nJqwYoTkf0ByoXR8IrGC9sXtbYrvmcMP2DMMyv7Hqf02YckZRMRA63xo8
         mYpTANYnJ922KMNcBc1xJphymz7uERoaOru5OzJM6jwDB874jyUdn0PiE4x+5hgYh2AD
         l9VkSB4DrV/SfgmGnFfl6e3S3isSrNTo169iiI4DdjSB8q+1RefDDoIvOEdUhz6JMCIo
         Np/r0qskHlSEcqwurkBz2gp83yG/XLJ7pR5RkNC2tpF0/NfGRqPBd7saARfAJnjFRQrn
         JK8A==
X-Forwarded-Encrypted: i=1; AJvYcCXwGHccpnnYkYXhVnDyaGxCRak/r94e4bFJPqzr1NWFTkAE1F/MwMRRDNz4t16vFDiHHC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFezO4QPby9Z9QO47U4YuZkswKF7TmA6IVZwwui4SmF2JTfxS4
	Z1MxoOFLmAlr9SONvMI1bJ3LsOI3UV3HOWFfm8gqMHQVl0WMNyqFdXaLS2BX3mY=
X-Gm-Gg: ASbGncstR1zCefp6qp8yHoLUCl8UXSj4vhUIHTIaEI+DlWfOLCTxirzt9H2hAKfDao+
	WPla9AU7Dz2rWOJkCTLRPY6+HpsH4JTnKKNByr9VsJHnmtNljx9sKtXwbB7gPZxI/aKahVvhsYa
	x87aiPn/275S1LnGeboxjPJOKxUEvbfMvuTJakiRmgeWNyz03DeFNvMd+bujNICYcJkFGGQvgmK
	StNsAeXjojFSAr80v6LlNQmFahopY50r1C5Uk5fSWU9hWtE2VIednC7VQWnNyBT1tA2MCf6Npqv
	JyFBnc/YVt98N+hKG18diT21LG+YqtCj+Yi9yeMjSjIX08niCpPJaNE=
X-Google-Smtp-Source: AGHT+IGTWWuqfdRG1OdMv1JrJhUNbIyiZqrhlB9MFbw+o6IkF6P0PGvSwNrik0HZ18U5C5r24zY0/A==
X-Received: by 2002:a05:600c:1e0e:b0:438:a20b:6a2a with SMTP id 5b1f17b1804b1-438a20b6b71mr242006995e9.14.1737675930187;
        Thu, 23 Jan 2025 15:45:30 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4b9990sm7076685e9.29.2025.01.23.15.45.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:28 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 13/20] accel: Forward-declare AccelOpsClass in 'qemu/typedefs.h'
Date: Fri, 24 Jan 2025 00:44:07 +0100
Message-ID: <20250123234415.59850-14-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The heavily imported "system/cpus.h" header includes "accel-ops.h"
to get AccelOpsClass type declaration. Reduce headers pressure by
forward declaring it in "qemu/typedefs.h", where we already
declare the AccelCPUState type.

Reduce "system/cpus.h" inclusions by only including
"system/accel-ops.h" when necessary.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/typedefs.h           | 1 +
 include/system/accel-ops.h        | 1 -
 include/system/cpus.h             | 2 --
 accel/accel-system.c              | 1 +
 accel/hvf/hvf-accel-ops.c         | 1 +
 accel/kvm/kvm-accel-ops.c         | 1 +
 accel/qtest/qtest.c               | 1 +
 accel/tcg/cpu-exec-common.c       | 1 -
 accel/tcg/cpu-exec.c              | 1 -
 accel/tcg/monitor.c               | 1 -
 accel/tcg/tcg-accel-ops.c         | 1 +
 accel/tcg/translate-all.c         | 1 -
 accel/xen/xen-all.c               | 1 +
 cpu-common.c                      | 1 -
 cpu-target.c                      | 1 +
 gdbstub/system.c                  | 1 +
 system/cpus.c                     | 1 +
 target/i386/nvmm/nvmm-accel-ops.c | 1 +
 target/i386/whpx/whpx-accel-ops.c | 1 +
 19 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index 3d84efcac47..465cc501773 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -22,6 +22,7 @@
  * Please keep this list in case-insensitive alphabetical order.
  */
 typedef struct AccelCPUState AccelCPUState;
+typedef struct AccelOpsClass AccelOpsClass;
 typedef struct AccelState AccelState;
 typedef struct AddressSpace AddressSpace;
 typedef struct AioContext AioContext;
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 137fb96d444..4c99d25aeff 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -17,7 +17,6 @@
 #define TYPE_ACCEL_OPS "accel" ACCEL_OPS_SUFFIX
 #define ACCEL_OPS_NAME(name) (name "-" TYPE_ACCEL_OPS)
 
-typedef struct AccelOpsClass AccelOpsClass;
 DECLARE_CLASS_CHECKERS(AccelOpsClass, ACCEL_OPS, TYPE_ACCEL_OPS)
 
 /**
diff --git a/include/system/cpus.h b/include/system/cpus.h
index 1cffeaaf5c4..3226c765d01 100644
--- a/include/system/cpus.h
+++ b/include/system/cpus.h
@@ -1,8 +1,6 @@
 #ifndef QEMU_CPUS_H
 #define QEMU_CPUS_H
 
-#include "system/accel-ops.h"
-
 /* register accel-specific operations */
 void cpus_register_accel(const AccelOpsClass *i);
 
diff --git a/accel/accel-system.c b/accel/accel-system.c
index a7596aef59d..5df49fbe831 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -26,6 +26,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "hw/boards.h"
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "qemu/error-report.h"
 #include "accel-system.h"
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 945ba720513..12fc30c2761 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -54,6 +54,7 @@
 #include "exec/exec-all.h"
 #include "gdbstub/enums.h"
 #include "hw/boards.h"
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/hvf.h"
 #include "system/hvf_int.h"
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index a81e8f3b03b..54ea60909e2 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -16,6 +16,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
+#include "system/accel-ops.h"
 #include "system/kvm.h"
 #include "system/kvm_int.h"
 #include "system/runstate.h"
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index ad7e3441a5a..7fae80f6a1b 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -18,6 +18,7 @@
 #include "qemu/option.h"
 #include "qemu/config-file.h"
 #include "qemu/accel.h"
+#include "system/accel-ops.h"
 #include "system/qtest.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
diff --git a/accel/tcg/cpu-exec-common.c b/accel/tcg/cpu-exec-common.c
index 100746d555a..c5c513f1e4a 100644
--- a/accel/tcg/cpu-exec-common.c
+++ b/accel/tcg/cpu-exec-common.c
@@ -19,7 +19,6 @@
 
 #include "qemu/osdep.h"
 #include "exec/log.h"
-#include "system/cpus.h"
 #include "system/tcg.h"
 #include "qemu/plugin.h"
 #include "internal-common.h"
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 8ee76e14b0d..4070d532bf1 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -33,7 +33,6 @@
 #include "qemu/rcu.h"
 #include "exec/log.h"
 #include "qemu/main-loop.h"
-#include "system/cpus.h"
 #include "exec/cpu-all.h"
 #include "system/cpu-timers.h"
 #include "exec/replay-core.h"
diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index ae1dbeb79f8..eeb38a4d9ce 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -13,7 +13,6 @@
 #include "qapi/type-helpers.h"
 #include "qapi/qapi-commands-machine.h"
 #include "monitor/monitor.h"
-#include "system/cpus.h"
 #include "system/cpu-timers.h"
 #include "system/tcg.h"
 #include "tcg/tcg.h"
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 6e3f1fa92b2..132c5d14613 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -26,6 +26,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "system/accel-ops.h"
 #include "system/tcg.h"
 #include "system/replay.h"
 #include "system/cpu-timers.h"
diff --git a/accel/tcg/translate-all.c b/accel/tcg/translate-all.c
index 786e2f6f1a7..0914d6e98b2 100644
--- a/accel/tcg/translate-all.c
+++ b/accel/tcg/translate-all.c
@@ -54,7 +54,6 @@
 #include "qemu/cacheinfo.h"
 #include "qemu/timer.h"
 #include "exec/log.h"
-#include "system/cpus.h"
 #include "system/cpu-timers.h"
 #include "system/tcg.h"
 #include "qapi/error.h"
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index 852e9fbe5fe..7aa28b9ab93 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -18,6 +18,7 @@
 #include "hw/xen/xen_igd.h"
 #include "chardev/char.h"
 #include "qemu/accel.h"
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/xen.h"
 #include "system/runstate.h"
diff --git a/cpu-common.c b/cpu-common.c
index 4248b2d727e..f5dcc2d136b 100644
--- a/cpu-common.c
+++ b/cpu-common.c
@@ -21,7 +21,6 @@
 #include "qemu/main-loop.h"
 #include "exec/cpu-common.h"
 #include "hw/core/cpu.h"
-#include "system/cpus.h"
 #include "qemu/lockable.h"
 #include "trace/trace-root.h"
 
diff --git a/cpu-target.c b/cpu-target.c
index f97f3a14751..20933bde7d4 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -35,6 +35,7 @@
 #include "exec/address-spaces.h"
 #include "exec/memory.h"
 #endif
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/tcg.h"
 #include "exec/tswap.h"
diff --git a/gdbstub/system.c b/gdbstub/system.c
index 7f047a285c8..416c1dbe1e9 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -19,6 +19,7 @@
 #include "gdbstub/commands.h"
 #include "exec/hwaddr.h"
 #include "exec/tb-flush.h"
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/runstate.h"
 #include "system/replay.h"
diff --git a/system/cpus.c b/system/cpus.c
index 37e5892c240..2cc5f887ab5 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -31,6 +31,7 @@
 #include "qapi/qapi-events-run-state.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/gdbstub.h"
+#include "system/accel-ops.h"
 #include "system/hw_accel.h"
 #include "exec/cpu-common.h"
 #include "qemu/thread.h"
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index e7b56662fee..4e4e63de78e 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -10,6 +10,7 @@
 #include "qemu/osdep.h"
 #include "system/kvm_int.h"
 #include "qemu/main-loop.h"
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index ab2e014c9ea..81fdd06e487 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -11,6 +11,7 @@
 #include "qemu/osdep.h"
 #include "system/kvm_int.h"
 #include "qemu/main-loop.h"
+#include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "qemu/guest-random.h"
 
-- 
2.47.1


