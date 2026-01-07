Return-Path: <kvm+bounces-67256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2AFCFF73B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4B44D300F735
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 18:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C4C33468C;
	Wed,  7 Jan 2026 18:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cAYolrHI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33AC320CA7
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767810040; cv=none; b=FimFgoPgOoh0vSjdY+KfRvyhdNaVdQv1Ht4lf0gMgpQDHJ24zTIZzMH/8QZXsdtclz6jcPYem8zd0z76fDR30eOQq6wceoKbvdYYNLtbOwcCmLdm7cGrXV0LfXA6U+jrg5EzEc/GPUSSf39Qic8Nh1M12mQ6CAzixhrCdREW9l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767810040; c=relaxed/simple;
	bh=g+YKz7APZ4qUOHwWthV16+ep34def0NOTAAUBBDUsH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z98Fz4CPZZ34UV44nxk5DiAnSqjIwkEV1q6/v5X+39tInHq/pO7sfWUSCB+6GyKfcwD2k+nrpHlPck0VJCU8VdBZQLFXb4977j8siiZ15Lm6pPC64Z1SriA5uItLr9XUAEots0OW1uhEfH1+E9H8fbNffe1xoabkV1ScFPBjI5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cAYolrHI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47774d3536dso10889915e9.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 10:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767810036; x=1768414836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5vUbPm6z1uOCPE8G5muzfEnqNfVl9U7aMx0sRH9rCw=;
        b=cAYolrHIaET7tUA7pockhMMWVRQkSnPXavGNl2R872x/iksAcwHCTremPGkWWrqwyU
         qAejqUbJAP8NrLSkI+tZyjj+yBpmqKM6lBA9zu5+/AoE4jnHA54g8vdfwCNlc100VuTi
         nEQRtomnF9bQ58/ewbGZSXUIMJWKQ9UiMmxWVjZWhgCRHz3rwvFBxtU15pJC5hxGYZnu
         /Q4Iaue62vV0IcF9jLnVIRK/wnfE760pXIcTn7hSUOV+/CacbdznKvIEvPPgoxYoAOus
         YrVwzdkHdoXoy+pEOlJknAEzJ1E+Fgxz1A77oSK2PD3rnBKjEzCiAABwW/fP+f9JRl6s
         hj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767810036; x=1768414836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c5vUbPm6z1uOCPE8G5muzfEnqNfVl9U7aMx0sRH9rCw=;
        b=o5mkx8EGswadGNnhq08AmK4gDlx/3aajkfpmImGdPWHuG3NRKPsZ1oxt/fAurwZ/p5
         +yspIOBqhD50iyAv+3spIh1k051WhllCzQvWpUeGpUFana/r9QbORxmwZoud1C2/UNlX
         znvYlJ8emZayQf7Wg2k6XJkRL7eGI8GMyLg6+OoYEDexKy3j33zhuQja+42gQjdErek0
         7bIc5F4BguEN44kIUY/IHfaQtyYIT7yqGbedXfM3ODDFXR6FSdZPq/NAmkNZwKzuOIeO
         rB3B0hxzxcOHKGSfGQ2TSQSGsw/x7T26A32jJdH0QZywSJmo1BeKTjPtpMgtfA2R5L4V
         a6Ng==
X-Forwarded-Encrypted: i=1; AJvYcCWAOj4XecmsBvrDEdvADuVknzzdqO0WPFZ7fwGCFYCnvKB3/uI+tK0zELIN9HiiM37jM6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhd0ZDNUaHSepItDyLr83Z4ITieAlW9qMhpUFq74Z7Wx96kTnL
	O4L9Kb3aX4QXd2foqA3e64lCXRqzYSyf/cY4vsFfb2Z9LPOo8rJIi95U+2akgPINdFE=
X-Gm-Gg: AY/fxX7HymKSl9DuqtAYyntgxv/wofQVyH2KcK1ERuAPXDO8hV7ukU5G8+QHgTDU3+o
	N+RMKY48QXtQy6SY2CSStv8hFk4O+VwiqWDzSad9lDI7qrWUiMij0F7u9ZKcdK9Sb/b8T20yXIq
	sMGBiaa3YK9wjIj2NnT+q74OacVJ8Qqfy7UuWolxaGNudsB3griZNOP6kz4hl896w/JvPEGqV/R
	CfuE2gmTTpz0tx+HDnuiwd4E4lEFoFocW59Y4MP7eVSuPuS3ILQNC0iTajaDqtlBBzeBXR76LFa
	F8J0iKvUPG9dEKHe5ZFC7K522D8moBOdGoyVyRA9HqozVYJvLQWyaTejOTc69YVwG15eDRRFnBc
	oY9fYnq7jR6yEWb1zlVthe5naQ3RH4L2GiqhPhdTitdpEQKegvjfM/QTGZH8poqGgxvZPvEiGrX
	XpkPj26KF3HoUHy9nSXHkI5qbX3yE+upWz3IbELR1GJLfy0nH9YpkQYHOl5hTY
X-Google-Smtp-Source: AGHT+IH35LX58d6iyis4US3zlff2ddmvK+Kej9v1Ob5JXh2aZ9aKF+hD5J/dRbIVvn6vm/UBgCxgjA==
X-Received: by 2002:a05:600c:a30c:b0:479:13e9:3d64 with SMTP id 5b1f17b1804b1-47d848787eemr36087415e9.15.1767810035952;
        Wed, 07 Jan 2026 10:20:35 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f620ac8sm107925335e9.0.2026.01.07.10.20.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 10:20:35 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-riscv@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	kvm@vger.kernel.org
Subject: [PATCH 2/2] monitor/hmp: Reduce target-specific definitions
Date: Wed,  7 Jan 2026 19:20:19 +0100
Message-ID: <20260107182019.51769-3-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107182019.51769-1-philmd@linaro.org>
References: <20260107182019.51769-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From "monitor/hmp-target.h", only the MonitorDef structure
is target specific (by using the 'target_long' type). All
the rest (even target_monitor_defs and target_get_monitor_def)
can be exposed to target-agnostic units, allowing to build
some of them in meson common source set.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/monitor/hmp-target.h  | 28 +++++-----------------------
 include/monitor/hmp.h         | 23 +++++++++++++++++++++++
 hw/i386/sgx-stub.c            |  2 +-
 hw/i386/sgx.c                 |  1 -
 monitor/hmp-cmds.c            |  1 -
 stubs/target-monitor-defs.c   |  2 +-
 target/i386/cpu-apic.c        |  2 +-
 target/i386/sev-system-stub.c |  2 +-
 target/i386/sev.c             |  1 -
 target/m68k/monitor.c         |  1 +
 target/riscv/monitor.c        |  1 +
 target/sh4/monitor.c          |  1 -
 target/xtensa/monitor.c       |  1 -
 13 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
index b679aaebbff..d39d8c8abe1 100644
--- a/include/monitor/hmp-target.h
+++ b/include/monitor/hmp-target.h
@@ -25,9 +25,12 @@
 #ifndef MONITOR_HMP_TARGET_H
 #define MONITOR_HMP_TARGET_H
 
-typedef struct MonitorDef MonitorDef;
+#include "monitor/hmp.h"
+
+#ifndef COMPILING_PER_TARGET
+#error hmp-target.h included from common code
+#endif
 
-#ifdef COMPILING_PER_TARGET
 #include "cpu.h"
 struct MonitorDef {
     const char *name;
@@ -36,29 +39,8 @@ struct MonitorDef {
                              int val);
     int type;
 };
-#endif
 
 #define MD_TLONG 0
 #define MD_I32   1
 
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
 #endif /* MONITOR_HMP_TARGET_H */
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 83721b5ffc6..48cd8cefe98 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -17,6 +17,29 @@
 #include "qemu/readline.h"
 #include "qapi/qapi-types-common.h"
 
+typedef struct MonitorDef MonitorDef;
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
index f7ff6ec90ec..1ab789ff468 100644
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
index fb5a3b5d778..7e2a5df8867 100644
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
index 2bdf6acae0a..784f5730919 100644
--- a/target/m68k/monitor.c
+++ b/target/m68k/monitor.c
@@ -7,6 +7,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "monitor/hmp.h"
 #include "monitor/hmp-target.h"
 #include "monitor/monitor.h"
 
diff --git a/target/riscv/monitor.c b/target/riscv/monitor.c
index 8a77476db93..478fd392ac6 100644
--- a/target/riscv/monitor.c
+++ b/target/riscv/monitor.c
@@ -22,6 +22,7 @@
 #include "cpu.h"
 #include "cpu_bits.h"
 #include "monitor/monitor.h"
+#include "monitor/hmp.h"
 #include "monitor/hmp-target.h"
 #include "system/memory.h"
 
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


