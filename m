Return-Path: <kvm+bounces-15107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9611A8A9D18
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F687B28DE8
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE29116D4F6;
	Thu, 18 Apr 2024 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vxzTKzzB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0D16C692
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450438; cv=none; b=D5C+TIx+Ox9w47Mfnz0aKMKn5lF0WvYvHJfUNYuffB4EPAYhSQwEkJGPZJE5v64+XAnUQECCkhTsAIW4284csCebFnhOX+3DwfcMeLiGD9A7svt5yT2c5MR3ANkdinpf4xmTcBfHivWTVC53tS3AJ8/f4dawmlZsJk28QNKS83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450438; c=relaxed/simple;
	bh=kcoG6jiY9kWv2/uOQlFh79xxb7l93htaZIA0+tqUeuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUthGkJlXAaqzURJJJW+mDur6B3Z5DaHJMNuP02CqChBQSPQ3XueQTm4gadtWmYRunZx+FY+sqNUzy3Iw49AetMSszgZo8jGhm1wVumlh5qQBsFMXMMJqzKOZ+fx0rjHqS8gjVmmBYfYzb32D8swLZ6NwiKc9benFdPehcbMUMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vxzTKzzB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-349a33a9667so132748f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450435; x=1714055235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AvdB3u3xfYtOVc85K9gr+w0O/Mfoyuz+qydkV22p5c=;
        b=vxzTKzzBJLSR4s1E3LLAE8ZNhOmy1jAWuFlqUwCD541Y06sB3wr6KamOju+8O05pH9
         pfVTGYFnzsBispbgw5umkEXCj6GMGv/jDIDb2EWrNwrQ8jSgo154zuE1/14d9QTdTYnp
         tRXlOaxRBcpTQp67Z88JwBlitbv7C28Y0U4H0CjJDYY/YM5paHDXiO7BiYYdNox+a4sO
         1Hyhz6T2C/0ghxHlMwISmlazGM3WQnGEe7U5W5wkeEq3HASHoAoBeq2OIOiqPxNVmjRU
         lf/AcSVRuCNIOzn0d6//0D9Jj9G6ij7lha0EvXiffBnDNDT9wlHw+18bgnl2xIMMFOzG
         X1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450435; x=1714055235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/AvdB3u3xfYtOVc85K9gr+w0O/Mfoyuz+qydkV22p5c=;
        b=b4oNDD/DTtuR5LGFYFG1vTP+vKW0CHXJgJmb+KS1uLHX6SE+4BoCmVqLWXZjN8nF0J
         /R329KGfT55KSIVgmJz1b+i5JYK1rOSenTmOrJDoRydEhHg7o5GFcQimT9y4xORlTz+H
         IIvDX6OE4TnxS6S3fPSwUfqtu5u/ChAUNqknUATo/TqCTfCHGja25qtX034yqByCOePo
         7AHDwq4eH/i5ItFPpkIt7eUaUd6UEEmHoeQ7qIxYdWGYkymNYSFJv4OWSPMqrJSbJUIl
         bg3Z0AQ//YZGxgIiWzxVRt28JSksbES96gotbznXtQLROl/j0gZCyWtvwXPsanlTC9PJ
         nlLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwdkGkIh4Iwyfdxrv6owJDTcGx7N7JUgSclH181L5ZMq7TDC2k2xR5DqW2p9wV5+OKnl5L1c/IJNp9cEEL5Pz/vRsr
X-Gm-Message-State: AOJu0YyvYAVdp0Hc8KjLl1QI1TmpTvqtC6NM86CenAEAef9+T7G5RYur
	tJlYcEuH4rwuQ6jmHo8Bw2AXYtZaUtuUAnBBXZW5MKA9283rNJR4fZbJtIh/SrA=
X-Google-Smtp-Source: AGHT+IEwlQ04KaJP3EVY+XCohGbQqha8fE09E68ZNltKaQxFJ4YDXOPGuVd4fVf/pEkQ78VT8bcTuA==
X-Received: by 2002:a05:600c:35ca:b0:418:9941:ca28 with SMTP id r10-20020a05600c35ca00b004189941ca28mr2125666wmq.2.1713450435180;
        Thu, 18 Apr 2024 07:27:15 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:14 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [RFC PATCH 5/7] riscv: add double trap driver
Date: Thu, 18 Apr 2024 16:26:44 +0200
Message-ID: <20240418142701.1493091-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a small driver to request double trap enabling as well as
registering a SSE handler for double trap. This will also be used by KVM
SBI FWFT extension support to detect if it is possible to enable double
trap in VS-mode.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h    |  1 +
 drivers/firmware/Kconfig        |  7 +++
 drivers/firmware/Makefile       |  1 +
 drivers/firmware/riscv_dbltrp.c | 95 +++++++++++++++++++++++++++++++++
 include/linux/riscv_dbltrp.h    | 19 +++++++
 5 files changed, 123 insertions(+)
 create mode 100644 drivers/firmware/riscv_dbltrp.c
 create mode 100644 include/linux/riscv_dbltrp.h

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 744aa1796c92..9cd4ca66487c 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -314,6 +314,7 @@ enum sbi_sse_attr_id {
 #define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SPIE	(1 << 2)
 
 #define SBI_SSE_EVENT_LOCAL_RAS		0x00000000
+#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP	0x00000001
 #define SBI_SSE_EVENT_GLOBAL_RAS	0x00008000
 #define SBI_SSE_EVENT_LOCAL_PMU		0x00010000
 #define SBI_SSE_EVENT_LOCAL_SOFTWARE	0xffff0000
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 59f611288807..a037f6e89942 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -197,6 +197,13 @@ config RISCV_SSE_TEST
 	  Select if you want to enable SSE extension testing at boot time.
 	  This will run a series of test which verifies SSE sanity.
 
+config RISCV_DBLTRP
+	bool "Enable Double trap handling"
+	depends on RISCV_SSE && RISCV_SBI
+	default n
+	help
+	  Select if you want to enable SSE double trap handler.
+
 config SYSFB
 	bool
 	select BOOT_VESA_SUPPORT
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index fb7b0c08c56d..ad67a1738c0f 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_RASPBERRYPI_FIRMWARE) += raspberrypi.o
 obj-$(CONFIG_FW_CFG_SYSFS)	+= qemu_fw_cfg.o
 obj-$(CONFIG_RISCV_SSE)		+= riscv_sse.o
 obj-$(CONFIG_RISCV_SSE_TEST)	+= riscv_sse_test.o
+obj-$(CONFIG_RISCV_DBLTRP)	+= riscv_dbltrp.o
 obj-$(CONFIG_SYSFB)		+= sysfb.o
 obj-$(CONFIG_SYSFB_SIMPLEFB)	+= sysfb_simplefb.o
 obj-$(CONFIG_TI_SCI_PROTOCOL)	+= ti_sci.o
diff --git a/drivers/firmware/riscv_dbltrp.c b/drivers/firmware/riscv_dbltrp.c
new file mode 100644
index 000000000000..72f9a067e87a
--- /dev/null
+++ b/drivers/firmware/riscv_dbltrp.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Rivos Inc.
+ */
+
+#define pr_fmt(fmt) "riscv-dbltrp: " fmt
+
+#include <linux/cpu.h>
+#include <linux/init.h>
+#include <linux/riscv_dbltrp.h>
+#include <linux/riscv_sse.h>
+
+#include <asm/sbi.h>
+
+static bool double_trap_enabled;
+
+static int riscv_sse_dbltrp_handle(uint32_t evt, void *arg,
+				   struct pt_regs *regs)
+{
+	__show_regs(regs);
+	panic("Double trap !\n");
+
+	return 0;
+}
+
+struct cpu_dbltrp_data {
+	int error;
+};
+
+static void
+sbi_cpu_enable_double_trap(void *data)
+{
+	struct sbiret ret;
+	struct cpu_dbltrp_data *cdd = data;
+
+	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
+			SBI_FWFT_DOUBLE_TRAP_ENABLE, 1, 0, 0, 0, 0);
+
+	if (ret.error) {
+		cdd->error = 1;
+		pr_err("Failed to enable double trap on cpu %d\n", smp_processor_id());
+	}
+}
+
+static int sbi_enable_double_trap(void)
+{
+	struct cpu_dbltrp_data cdd = {0};
+
+	on_each_cpu(sbi_cpu_enable_double_trap, &cdd, 1);
+	if (cdd.error)
+		return -1;
+
+	double_trap_enabled = true;
+
+	return 0;
+}
+
+bool riscv_double_trap_enabled(void)
+{
+	return double_trap_enabled;
+}
+EXPORT_SYMBOL(riscv_double_trap_enabled);
+
+static int __init riscv_dbltrp(void)
+{
+	struct sse_event *evt;
+
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SSDBLTRP)) {
+		pr_err("Ssdbltrp extension not available\n");
+		return 1;
+	}
+
+	if (!sbi_probe_extension(SBI_EXT_FWFT)) {
+		pr_err("Can not enable double trap, SBI_EXT_FWFT is not available\n");
+		return 1;
+	}
+
+	if (sbi_enable_double_trap()) {
+		pr_err("Failed to enable double trap on all cpus\n");
+		return 1;
+	}
+
+	evt = sse_event_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, 0,
+				 riscv_sse_dbltrp_handle, NULL);
+	if (IS_ERR(evt)) {
+		pr_err("SSE double trap register failed\n");
+		return PTR_ERR(evt);
+	}
+
+	sse_event_enable(evt);
+	pr_info("Double trap handling registered\n");
+
+	return 0;
+}
+device_initcall(riscv_dbltrp);
diff --git a/include/linux/riscv_dbltrp.h b/include/linux/riscv_dbltrp.h
new file mode 100644
index 000000000000..6de4f43fae6b
--- /dev/null
+++ b/include/linux/riscv_dbltrp.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 Rivos Inc.
+ */
+
+#ifndef __LINUX_RISCV_DBLTRP_H
+#define __LINUX_RISCV_DBLTRP_H
+
+#if defined(CONFIG_RISCV_DBLTRP)
+bool riscv_double_trap_enabled(void);
+#else
+
+static inline bool riscv_double_trap_enabled(void)
+{
+	return false;
+}
+#endif
+
+#endif /* __LINUX_RISCV_DBLTRP_H */
-- 
2.43.0


