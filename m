Return-Path: <kvm+bounces-16090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BDC8B42FC
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 02:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EDDC1F26220
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 00:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652AF3D56D;
	Sat, 27 Apr 2024 00:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kvZtbYD3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E71524BB
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 00:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714176004; cv=none; b=Rzhw9Z8y07oUeyJDPa3HkFMOLSd5Q99Xbt7svGR7NswHvKO5B4dWLr2LyefLy8eeuba52+8EhPhxlco4AIT1zHtdLjX8GFyrx9Hnqi7Dk85xoZJzNqEcUKpfg29oTBNABFjir3sJaqVUKPqWjlPXJujTz5tZ1rNXQXiqLrTJBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714176004; c=relaxed/simple;
	bh=kAXwkZ5ourxONL+nhOJPUSgmn75/9GEyN9evhXr19ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPOfXXxRw9qbtJzLplwm0SD/f7jVBd8RNbxW8FGvQVDgodE8grg7HvtcnZeMSXCY7Y859wYFg6krHX1M9Do4zIBxa6KLZRY4nFtLB2vXGAc+geZCZ33n33LNgdvb6I79hSG8l76KlU1yyfev8vstMJuiSHuNYK4usPuf7J8+nC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kvZtbYD3; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f103b541aeso2402015b3a.3
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714176002; x=1714780802; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9nKgoSM0sp6sf/g9BAlOnduSP6+NwHasqsoAKKtprFI=;
        b=kvZtbYD3keS8bxlHi4+1/9rUYwKgsdn7sMgzNvbAZH+2gxZ4yr8GorvGUXCFkXTk1x
         hCO7b+OoBIrMnKM0UPwteF5mNo53i8rw3mMEYSGp7KgW41BE9KIDRGXBN2ni4kmq3lVm
         Ww0PHnHbq3R8Fz38EJQ111dAgbBw532YlTOK14OdoT331X44l5eaoKrPO12p4D9vKAfl
         R1QOgTLHtGXBAy8TAX+CtGrP/0FRICkrNJRaVsXu0SyBP/yzgFGTq03Hw6o+ymjRgEvo
         lVXK/ljnO+UDZAymPQjojU2sfhpSNVOhBKJtFwEfK2lg2LUfUOTRrKAY/tbViAXalnm9
         Ft3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714176002; x=1714780802;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9nKgoSM0sp6sf/g9BAlOnduSP6+NwHasqsoAKKtprFI=;
        b=S0+ORKmpsCZohwHzSvQ92O4dKtEy5PV4FlxAz6+e43fGCQ+qmKVXN69Vj/ggjIZCkj
         lEzPVtfhpPI4S742taDOhza1KgT74GZ/RQisFJoHzl/6mybVDeS4avaMbkjPy9pW4ruh
         ukRfZiU4zC+RiHvuYdiRlBaLYZi6ZT9cU+1OGOwcgCJLC/nb/LlpAK3kpWDJkAK17cyf
         0HD2JgTDG4oMJ903CM92ieX0DzP5nbG9c41ufd4Z7lG7O/YEEbfvQvhmzdaw6vQe0kZ6
         rkCepkYIeWLZCdxLMfeuAS1dxIRNJQFiImmtEqtSEtODavgafa2SyNlEq8auVCMqM/WP
         BVsA==
X-Forwarded-Encrypted: i=1; AJvYcCUV2vrbst1dfmnxTxskp3WCs7Ql3DXPwpONF2aE4orCE2JkV6FfQ1wXCHh3huWE02UWjCHCkNykhoZN8/0giaxvIhQh
X-Gm-Message-State: AOJu0YwVYaqka1bi1/ozaz5uRPzzARQDwSmkzYVHHiPE54GLWfKLruLF
	NVOBAUZ2G/U8RJH8w5Klf48dorvSlviCjHl+BYuleXgN49FOIijNaxGBAJgvxEo=
X-Google-Smtp-Source: AGHT+IEsvRMCuekQ94DgQvZ05hh6aZ5npO3dcKp41Wr8dxgq9snbGePJb3r1rT7TaB8/2W1ubLy8lw==
X-Received: by 2002:a05:6a00:1395:b0:6ed:416d:e9a with SMTP id t21-20020a056a00139500b006ed416d0e9amr5962735pfg.7.1714176001896;
        Fri, 26 Apr 2024 17:00:01 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id b12-20020a056a00114c00b006ecfc3a8d6csm15313819pfm.124.2024.04.26.17.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 17:00:01 -0700 (PDT)
Date: Fri, 26 Apr 2024 16:59:59 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [RFC PATCH 5/7] riscv: add double trap driver
Message-ID: <Ziw//90J0WfOY/tl@debug.ba.rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240418142701.1493091-6-cleger@rivosinc.com>

On Thu, Apr 18, 2024 at 04:26:44PM +0200, Clément Léger wrote:
>Add a small driver to request double trap enabling as well as
>registering a SSE handler for double trap. This will also be used by KVM
>SBI FWFT extension support to detect if it is possible to enable double
>trap in VS-mode.
>
>Signed-off-by: Clément Léger <cleger@rivosinc.com>
>---
> arch/riscv/include/asm/sbi.h    |  1 +
> drivers/firmware/Kconfig        |  7 +++
> drivers/firmware/Makefile       |  1 +
> drivers/firmware/riscv_dbltrp.c | 95 +++++++++++++++++++++++++++++++++
> include/linux/riscv_dbltrp.h    | 19 +++++++
> 5 files changed, 123 insertions(+)
> create mode 100644 drivers/firmware/riscv_dbltrp.c
> create mode 100644 include/linux/riscv_dbltrp.h
>
>diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
>index 744aa1796c92..9cd4ca66487c 100644
>--- a/arch/riscv/include/asm/sbi.h
>+++ b/arch/riscv/include/asm/sbi.h
>@@ -314,6 +314,7 @@ enum sbi_sse_attr_id {
> #define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SPIE	(1 << 2)
>
> #define SBI_SSE_EVENT_LOCAL_RAS		0x00000000
>+#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP	0x00000001
> #define SBI_SSE_EVENT_GLOBAL_RAS	0x00008000
> #define SBI_SSE_EVENT_LOCAL_PMU		0x00010000
> #define SBI_SSE_EVENT_LOCAL_SOFTWARE	0xffff0000
>diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>index 59f611288807..a037f6e89942 100644
>--- a/drivers/firmware/Kconfig
>+++ b/drivers/firmware/Kconfig
>@@ -197,6 +197,13 @@ config RISCV_SSE_TEST
> 	  Select if you want to enable SSE extension testing at boot time.
> 	  This will run a series of test which verifies SSE sanity.
>
>+config RISCV_DBLTRP
>+	bool "Enable Double trap handling"
>+	depends on RISCV_SSE && RISCV_SBI
>+	default n
>+	help
>+	  Select if you want to enable SSE double trap handler.
>+
> config SYSFB
> 	bool
> 	select BOOT_VESA_SUPPORT
>diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
>index fb7b0c08c56d..ad67a1738c0f 100644
>--- a/drivers/firmware/Makefile
>+++ b/drivers/firmware/Makefile
>@@ -18,6 +18,7 @@ obj-$(CONFIG_RASPBERRYPI_FIRMWARE) += raspberrypi.o
> obj-$(CONFIG_FW_CFG_SYSFS)	+= qemu_fw_cfg.o
> obj-$(CONFIG_RISCV_SSE)		+= riscv_sse.o
> obj-$(CONFIG_RISCV_SSE_TEST)	+= riscv_sse_test.o
>+obj-$(CONFIG_RISCV_DBLTRP)	+= riscv_dbltrp.o
> obj-$(CONFIG_SYSFB)		+= sysfb.o
> obj-$(CONFIG_SYSFB_SIMPLEFB)	+= sysfb_simplefb.o
> obj-$(CONFIG_TI_SCI_PROTOCOL)	+= ti_sci.o
>diff --git a/drivers/firmware/riscv_dbltrp.c b/drivers/firmware/riscv_dbltrp.c
>new file mode 100644
>index 000000000000..72f9a067e87a
>--- /dev/null
>+++ b/drivers/firmware/riscv_dbltrp.c
>@@ -0,0 +1,95 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/*
>+ * Copyright (C) 2023 Rivos Inc.
>+ */

nit: fix copyright year
>+
>+#define pr_fmt(fmt) "riscv-dbltrp: " fmt
>+
>+#include <linux/cpu.h>
>+#include <linux/init.h>
>+#include <linux/riscv_dbltrp.h>
>+#include <linux/riscv_sse.h>
>+
>+#include <asm/sbi.h>
>+
>+static bool double_trap_enabled;
>+
>+static int riscv_sse_dbltrp_handle(uint32_t evt, void *arg,
>+				   struct pt_regs *regs)
>+{
>+	__show_regs(regs);
>+	panic("Double trap !\n");
>+
>+	return 0;
Curious:
Does panic return?
What's the point of returning from here?

>+}
>+
>+struct cpu_dbltrp_data {
>+	int error;
>+};
>+
>+static void
>+sbi_cpu_enable_double_trap(void *data)
>+{
>+	struct sbiret ret;
>+	struct cpu_dbltrp_data *cdd = data;
>+
>+	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
>+			SBI_FWFT_DOUBLE_TRAP_ENABLE, 1, 0, 0, 0, 0);
>+
>+	if (ret.error) {
>+		cdd->error = 1;
>+		pr_err("Failed to enable double trap on cpu %d\n", smp_processor_id());
>+	}
>+}
>+
>+static int sbi_enable_double_trap(void)
>+{
>+	struct cpu_dbltrp_data cdd = {0};
>+
>+	on_each_cpu(sbi_cpu_enable_double_trap, &cdd, 1);
>+	if (cdd.error)
>+		return -1;

There is a bug here. If `sbi_cpu_enable_double_trap` failed on all cpus but last cpu.
Then cdd.error would not record error and will be reflect as if double trap was enabled.

Its less likely to happen that FW would return success for one cpu and fail for others.
But there is non-zero probablity here.

>+
>+	double_trap_enabled = true;
>+
>+	return 0;
>+}
>+
>+bool riscv_double_trap_enabled(void)
>+{
>+	return double_trap_enabled;
>+}
>+EXPORT_SYMBOL(riscv_double_trap_enabled);
>+
>+static int __init riscv_dbltrp(void)
>+{
>+	struct sse_event *evt;
>+
>+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SSDBLTRP)) {
>+		pr_err("Ssdbltrp extension not available\n");
>+		return 1;
>+	}
>+
>+	if (!sbi_probe_extension(SBI_EXT_FWFT)) {
>+		pr_err("Can not enable double trap, SBI_EXT_FWFT is not available\n");
>+		return 1;
>+	}
>+
>+	if (sbi_enable_double_trap()) {
>+		pr_err("Failed to enable double trap on all cpus\n");
>+		return 1;
>+	}
>+
>+	evt = sse_event_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, 0,
>+				 riscv_sse_dbltrp_handle, NULL);
>+	if (IS_ERR(evt)) {
>+		pr_err("SSE double trap register failed\n");
>+		return PTR_ERR(evt);
>+	}
>+
>+	sse_event_enable(evt);
>+	pr_info("Double trap handling registered\n");
>+
>+	return 0;
>+}
>+device_initcall(riscv_dbltrp);
>diff --git a/include/linux/riscv_dbltrp.h b/include/linux/riscv_dbltrp.h
>new file mode 100644
>index 000000000000..6de4f43fae6b
>--- /dev/null
>+++ b/include/linux/riscv_dbltrp.h
>@@ -0,0 +1,19 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ * Copyright (C) 2023 Rivos Inc.
>+ */
>+
>+#ifndef __LINUX_RISCV_DBLTRP_H
>+#define __LINUX_RISCV_DBLTRP_H
>+
>+#if defined(CONFIG_RISCV_DBLTRP)
>+bool riscv_double_trap_enabled(void);
>+#else
>+
>+static inline bool riscv_double_trap_enabled(void)
>+{
>+	return false;
>+}
>+#endif
>+
>+#endif /* __LINUX_RISCV_DBLTRP_H */
>-- 
>2.43.0
>
>

