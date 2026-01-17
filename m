Return-Path: <kvm+bounces-68437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A99D38FC8
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 17:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 813D63012950
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 16:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE64D22127B;
	Sat, 17 Jan 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xuLCkXvM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6F91DE3AD
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768667430; cv=none; b=NGGgAGaMHk03MzwKCEZS3ka4u3QUDxmh8g3rmGkooM0gOlBSYpGh5dNrvMvVZNwBJoQSHQfNhaf7yFChref5H3GCZL5jWHyqcJPs99d+NHbWUm4XGOBToo4/O4TpsfUydmIYV3YrO1HGHH9lBDAktgTcoUK7YF0OVZDB4Z9zxO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768667430; c=relaxed/simple;
	bh=3ywg+lIbyYY7cvogqkjzqciTPZ117DxVwD5daVD3Ilo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dl6Ia0VA2ZmkEsmBw/R5zcQKGb/g/dFRJQP4+30QCSjOq3vTq2UBAJRGmKncEN3cm13+AB7EnHiDvwN1cuzFPmhgwav9vw20RPMqyZUnpj+CFCWHqpWOiRKiziN088/J/R4dljR+f2eu5N1jYFY2r6LELqx3hwTVt9Mous0nxbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xuLCkXvM; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-432d256c2e6so2472851f8f.3
        for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 08:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768667426; x=1769272226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JK1bLOADrs29MiINWo9DrQI2aKUVmVhFJeqP3VoFJ8U=;
        b=xuLCkXvMdl1NIyxPl85XNZyOaO5dtTFSXPT9tsXLbe5KIuv9tohzvZLPbye2fTzhtf
         sPJxaOhfXOOipKmYtrEvyFLE5o1zL6X01R0HJVW6NPAuiaRUfWdWukK+ZXiXqkEsTfOd
         HL72lqPENfNxYX8GSIe4sKvSOa9Nk7o9+0/dmoR8rWlJ6CUvhMReMMu2S/4+SJh31UZA
         m5e+RmC4LZBj2JW27JQ7fx6bQ1lnmd3TQyFXOcaVPZgYJx6PcbT2vDFYrZSAU53/tLQu
         aeLgT/aMGH0j0jtaKg2zVk8w3t3/PQbVD9xgEvEoXKrNRFyhHvxqWkF7e/OCPNcqEGlN
         j9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768667426; x=1769272226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JK1bLOADrs29MiINWo9DrQI2aKUVmVhFJeqP3VoFJ8U=;
        b=hPZu2MwLTIoj5YGAV4A0+UT0zR86jrVs68YDNoTAsj0CfdexzqiJirAmOdfwKxO02J
         GGTBG1UzYbU+2ryO650nrwDuAvhtwxXBXB6sUFBlQiswYE585HNO1p9OrbBXa5V9ZQId
         UGXx0zOxHrXC7ArT9W++Cz/1hGg8DJWUWnKxpBNP4Uegrqgc0oaqQQer/zejc8cg3VjR
         WanGTcscPh9n1A0ZZoDb3GSqifHbOxdR5VZRDaFsmwE0PGd5bYMUA3+qPy8Uy0WU4sjy
         gF3Bx/rwqgbzaiErZMyHe4T6AxOX/LNNi6yAixRkX9oD2KGksQ+N2Pqh0IqndjYN7HIS
         StJw==
X-Forwarded-Encrypted: i=1; AJvYcCWkFVCcpGnm9UpYUTCJw35EsN58LD94L06IyF2M/gT2oXxAmxJutR+NijVyskhbGjVITSk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw/99CUiN0vVIZAE2znG+3S+vSUmTsQNuEk9DUzoUySMnU6x8x
	LHDD9lEQkhUwqr2rI6Qi3VoD6QRqDD4cYmIBdW8s+rmPJXCrB79R46TT1DGyuLn/wMc=
X-Gm-Gg: AY/fxX6boVsieLN030uPtxv+k/f4FjY5L2l0YJQPMvu+ojYkcP6n78ECCDxpHlacVyX
	XVDbtUxtA/UAMe0MxKv9dyE6SINJU25MZrVNFVL54jX1StF6MWdqEPVjPgSbH6b6vha3s5YCdIv
	loVhWPEtTpPIt8AIEcag7PTUfvlGCD8cLQtxhRce7lSDJ+kxVORDHUlWTows9itaEnRYJACdc0f
	XQBUr+6N4/wR19xOvtQPbwOOsw+/KHsHp78R8QVajujZ5YhrS/kDt+ckz1L9EZFflo7TSElAUaz
	UvfVn+hnAIzgxsN73R7fZ+l6FLcy4yL+ZVPUtvZnPwZYumqi1f63q8MW8AvOhfenwhpulki0EYO
	qHrFmGQK+b2h08xjvAvYsNpxuvEcmKczx/HgjFk6buTLI+KxreQPEg+DsxHxEnYHVJxUVVuNOds
	TMXHQ6j1g/jWDHOf1W2FFqfQqqU9Q/5eKzFUlexJqxWAk56miVUD5S0XE/nD4U
X-Received: by 2002:adf:f28b:0:b0:435:6f0e:2e5e with SMTP id ffacd0b85a97d-4356f0e3006mr5755131f8f.62.1768667426326;
        Sat, 17 Jan 2026 08:30:26 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dadbsm11972737f8f.21.2026.01.17.08.30.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Jan 2026 08:30:25 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org
Subject: [PATCH v2 8/8] monitor: Remove 'monitor/hmp-target.h' header
Date: Sat, 17 Jan 2026 17:29:26 +0100
Message-ID: <20260117162926.74225-9-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260117162926.74225-1-philmd@linaro.org>
References: <20260117162926.74225-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The "monitor/hmp-target.h" header doesn't contain any
target-specific declarations anymore. Merge it with
"monitor/hmp.h", its target-agnostic counterpart.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS                   |  2 +-
 include/monitor/hmp-target.h  | 60 -----------------------------------
 include/monitor/hmp.h         | 31 ++++++++++++++++++
 hw/i386/sgx-stub.c            |  2 +-
 hw/i386/sgx.c                 |  1 -
 monitor/hmp-cmds.c            |  1 -
 monitor/hmp-target.c          |  1 -
 monitor/hmp.c                 |  1 -
 stubs/target-monitor-defs.c   |  2 +-
 target/i386/cpu-apic.c        |  2 +-
 target/i386/monitor.c         |  1 -
 target/i386/sev-system-stub.c |  2 +-
 target/i386/sev.c             |  1 -
 target/m68k/monitor.c         |  2 +-
 target/ppc/ppc-qmp-cmds.c     |  1 -
 target/riscv/monitor.c        |  2 +-
 target/riscv/riscv-qmp-cmds.c |  1 -
 target/sh4/monitor.c          |  1 -
 target/sparc/monitor.c        |  1 -
 target/xtensa/monitor.c       |  1 -
 20 files changed, 38 insertions(+), 78 deletions(-)
 delete mode 100644 include/monitor/hmp-target.h

diff --git a/MAINTAINERS b/MAINTAINERS
index de8246c3ffd..1e0d71c7bb8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3377,7 +3377,7 @@ F: monitor/monitor.c
 F: monitor/hmp*
 F: hmp.h
 F: hmp-commands*.hx
-F: include/monitor/hmp-target.h
+F: include/monitor/hmp.h
 F: tests/qtest/test-hmp.c
 F: include/qemu/qemu-print.h
 F: util/qemu-print.c
diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
deleted file mode 100644
index 713936c4523..00000000000
--- a/include/monitor/hmp-target.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * QEMU monitor
- *
- * Copyright (c) 2003-2004 Fabrice Bellard
- *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to deal
- * in the Software without restriction, including without limitation the rights
- * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
- * copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
- * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
- * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
- * THE SOFTWARE.
- */
-
-#ifndef MONITOR_HMP_TARGET_H
-#define MONITOR_HMP_TARGET_H
-
-typedef struct MonitorDef MonitorDef;
-
-struct MonitorDef {
-    const char *name;
-    int offset;
-    uint64_t (*get_value)(Monitor *mon, const struct MonitorDef *md, int val);
-    int type;
-};
-
-#define MD_TLONG 0
-#define MD_I32   1
-
-const MonitorDef *target_monitor_defs(void);
-int target_get_monitor_def(CPUState *cs, const char *name, uint64_t *pval);
-
-CPUArchState *mon_get_cpu_env(Monitor *mon);
-CPUState *mon_get_cpu(Monitor *mon);
-
-void hmp_info_mem(Monitor *mon, const QDict *qdict);
-void hmp_info_tlb(Monitor *mon, const QDict *qdict);
-void hmp_mce(Monitor *mon, const QDict *qdict);
-void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
-void hmp_info_sev(Monitor *mon, const QDict *qdict);
-void hmp_info_sgx(Monitor *mon, const QDict *qdict);
-void hmp_info_via(Monitor *mon, const QDict *qdict);
-void hmp_memory_dump(Monitor *mon, const QDict *qdict);
-void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict);
-void hmp_info_registers(Monitor *mon, const QDict *qdict);
-void hmp_gva2gpa(Monitor *mon, const QDict *qdict);
-void hmp_gpa2hva(Monitor *mon, const QDict *qdict);
-void hmp_gpa2hpa(Monitor *mon, const QDict *qdict);
-
-#endif /* MONITOR_HMP_TARGET_H */
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 83721b5ffc6..fb678786101 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -17,6 +17,37 @@
 #include "qemu/readline.h"
 #include "qapi/qapi-types-common.h"
 
+typedef struct MonitorDef {
+    const char *name;
+    int offset;
+    uint64_t (*get_value)(Monitor *mon, const struct MonitorDef *md, int val);
+    int type;
+} MonitorDef;
+
+#define MD_TLONG 0
+#define MD_I32   1
+
+const MonitorDef *target_monitor_defs(void);
+
+int target_get_monitor_def(CPUState *cs, const char *name, uint64_t *pval);
+
+CPUArchState *mon_get_cpu_env(Monitor *mon);
+CPUState *mon_get_cpu(Monitor *mon);
+
+void hmp_info_mem(Monitor *mon, const QDict *qdict);
+void hmp_info_tlb(Monitor *mon, const QDict *qdict);
+void hmp_mce(Monitor *mon, const QDict *qdict);
+void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
+void hmp_info_sev(Monitor *mon, const QDict *qdict);
+void hmp_info_sgx(Monitor *mon, const QDict *qdict);
+void hmp_info_via(Monitor *mon, const QDict *qdict);
+void hmp_memory_dump(Monitor *mon, const QDict *qdict);
+void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict);
+void hmp_info_registers(Monitor *mon, const QDict *qdict);
+void hmp_gva2gpa(Monitor *mon, const QDict *qdict);
+void hmp_gpa2hva(Monitor *mon, const QDict *qdict);
+void hmp_gpa2hpa(Monitor *mon, const QDict *qdict);
+
 bool hmp_handle_error(Monitor *mon, Error *err);
 void hmp_help_cmd(Monitor *mon, const char *name);
 strList *hmp_split_at_comma(const char *str);
diff --git a/hw/i386/sgx-stub.c b/hw/i386/sgx-stub.c
index d295e54d239..6e82773a86d 100644
--- a/hw/i386/sgx-stub.c
+++ b/hw/i386/sgx-stub.c
@@ -1,6 +1,6 @@
 #include "qemu/osdep.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
+#include "monitor/hmp.h"
 #include "hw/i386/pc.h"
 #include "hw/i386/sgx-epc.h"
 #include "qapi/qapi-commands-misc-i386.h"
diff --git a/hw/i386/sgx.c b/hw/i386/sgx.c
index e2801546ad6..54d2cae36d8 100644
--- a/hw/i386/sgx.c
+++ b/hw/i386/sgx.c
@@ -16,7 +16,6 @@
 #include "hw/mem/memory-device.h"
 #include "monitor/qdev.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qapi/qapi-commands-misc-i386.h"
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 5a673cddb2a..7c2b69dfa5b 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -21,7 +21,6 @@
 #include "gdbstub/enums.h"
 #include "monitor/hmp.h"
 #include "qemu/help_option.h"
-#include "monitor/hmp-target.h"
 #include "monitor/monitor-internal.h"
 #include "qapi/error.h"
 #include "qapi/qapi-commands-control.h"
diff --git a/monitor/hmp-target.c b/monitor/hmp-target.c
index a3306b69c93..2574c5d8b4b 100644
--- a/monitor/hmp-target.c
+++ b/monitor/hmp-target.c
@@ -27,7 +27,6 @@
 #include "monitor/qdev.h"
 #include "net/slirp.h"
 #include "system/device_tree.h"
-#include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "block/block-hmp-cmds.h"
 #include "qapi/qapi-commands-control.h"
diff --git a/monitor/hmp.c b/monitor/hmp.c
index 82d2bbdf77d..4dc8c5f9364 100644
--- a/monitor/hmp.c
+++ b/monitor/hmp.c
@@ -27,7 +27,6 @@
 #include "hw/core/qdev.h"
 #include "monitor-internal.h"
 #include "monitor/hmp.h"
-#include "monitor/hmp-target.h"
 #include "qobject/qdict.h"
 #include "qobject/qnum.h"
 #include "qemu/bswap.h"
diff --git a/stubs/target-monitor-defs.c b/stubs/target-monitor-defs.c
index 35a0a342772..0dd4cdb34f6 100644
--- a/stubs/target-monitor-defs.c
+++ b/stubs/target-monitor-defs.c
@@ -1,5 +1,5 @@
 #include "qemu/osdep.h"
-#include "monitor/hmp-target.h"
+#include "monitor/hmp.h"
 
 const MonitorDef *target_monitor_defs(void)
 {
diff --git a/target/i386/cpu-apic.c b/target/i386/cpu-apic.c
index eeee62b52a2..3b73a04597f 100644
--- a/target/i386/cpu-apic.c
+++ b/target/i386/cpu-apic.c
@@ -10,7 +10,7 @@
 #include "qobject/qdict.h"
 #include "qapi/error.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
+#include "monitor/hmp.h"
 #include "system/hw_accel.h"
 #include "system/kvm.h"
 #include "system/xen.h"
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index cce23f987ef..1c16b003371 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -25,7 +25,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "qobject/qdict.h"
 #include "qapi/error.h"
diff --git a/target/i386/sev-system-stub.c b/target/i386/sev-system-stub.c
index 7c5c02a5657..f799a338d60 100644
--- a/target/i386/sev-system-stub.c
+++ b/target/i386/sev-system-stub.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
+#include "monitor/hmp.h"
 #include "qapi/error.h"
 #include "sev.h"
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1d70f96ec1f..31dbabe4b51 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -36,7 +36,6 @@
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
 #include "qapi/qapi-commands-misc-i386.h"
 #include "confidential-guest.h"
 #include "hw/i386/pc.h"
diff --git a/target/m68k/monitor.c b/target/m68k/monitor.c
index 161f41853ec..05d05440f42 100644
--- a/target/m68k/monitor.c
+++ b/target/m68k/monitor.c
@@ -7,7 +7,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "monitor/hmp-target.h"
+#include "monitor/hmp.h"
 #include "monitor/monitor.h"
 
 void hmp_info_tlb(Monitor *mon, const QDict *qdict)
diff --git a/target/ppc/ppc-qmp-cmds.c b/target/ppc/ppc-qmp-cmds.c
index 07938abb15f..08314e3c1cd 100644
--- a/target/ppc/ppc-qmp-cmds.c
+++ b/target/ppc/ppc-qmp-cmds.c
@@ -26,7 +26,6 @@
 #include "cpu.h"
 #include "monitor/monitor.h"
 #include "qemu/ctype.h"
-#include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "qapi/error.h"
 #include "qapi/qapi-commands-machine.h"
diff --git a/target/riscv/monitor.c b/target/riscv/monitor.c
index 8a77476db93..bc176dd8771 100644
--- a/target/riscv/monitor.c
+++ b/target/riscv/monitor.c
@@ -22,7 +22,7 @@
 #include "cpu.h"
 #include "cpu_bits.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
+#include "monitor/hmp.h"
 #include "system/memory.h"
 
 #ifdef TARGET_RISCV64
diff --git a/target/riscv/riscv-qmp-cmds.c b/target/riscv/riscv-qmp-cmds.c
index d5e9bec0f86..79232d34005 100644
--- a/target/riscv/riscv-qmp-cmds.c
+++ b/target/riscv/riscv-qmp-cmds.c
@@ -34,7 +34,6 @@
 #include "qemu/ctype.h"
 #include "qemu/qemu-print.h"
 #include "monitor/hmp.h"
-#include "monitor/hmp-target.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
 #include "cpu-qom.h"
diff --git a/target/sh4/monitor.c b/target/sh4/monitor.c
index 2da6a5426eb..50324d3600c 100644
--- a/target/sh4/monitor.c
+++ b/target/sh4/monitor.c
@@ -24,7 +24,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 
 static void print_tlb(Monitor *mon, int idx, tlb_t *tlb)
diff --git a/target/sparc/monitor.c b/target/sparc/monitor.c
index 3e1f4dd5c9c..79f564c551a 100644
--- a/target/sparc/monitor.c
+++ b/target/sparc/monitor.c
@@ -24,7 +24,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 
 
diff --git a/target/xtensa/monitor.c b/target/xtensa/monitor.c
index fbf60d55530..2af84934f83 100644
--- a/target/xtensa/monitor.c
+++ b/target/xtensa/monitor.c
@@ -24,7 +24,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 
 void hmp_info_tlb(Monitor *mon, const QDict *qdict)
-- 
2.52.0


