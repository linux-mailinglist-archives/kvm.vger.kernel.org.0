Return-Path: <kvm+bounces-41615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE11EA6B0D5
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6FA6189AA28
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E61722CBE9;
	Thu, 20 Mar 2025 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D+IDdU1D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3A322B8C8
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509827; cv=none; b=bSB7uyEYXtsA0gBCa1Px6a3ci/+uvvdvEKKO/FOSs1ARxr/8NMN5VxGP+EtijTko8QbP9pDIUuPHVRRcwVQNfRouc3G/unHWt002Irb90wafT+VnI0xthy2W3AZZ3dB614dxevVyEcFaDWl/7QdSlZdPF+XJYmvtU11r0jpuvUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509827; c=relaxed/simple;
	bh=0VcFpLpNVp6xDMhGY/C8+KfcUWYH8yyzTSN7bX02guM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F1YaKHuJjn25fg6vkAkqVJqbmGLEpPnDMXyZ3QkZ72EIZLFp6SvXeB1jzEc19ucX39CUZ0lbisCR4idkAXG6NjwbhLkthnrYMM4t4lWwV8/qMubXN3CEkKwqSntFmantVkIYMCD4o/bggCNI+zABSFgwOv5BZ0VAvgAo758TaLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D+IDdU1D; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2260c91576aso24278345ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509823; x=1743114623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvVg8hZsz7dkUMjowIKzbUwj5JrV7fSVlVByVyTJiR4=;
        b=D+IDdU1DgWP6/Gt2kp/1gBVeMlnvFxdOveyYiuWRzPn39yV/YuZK08OEZtqCfCcf+W
         KnbVdvv+rLKfxfZGwVWNe4aMnEC225SLl7Tl7wsQfbyJffpiqgObjrada8n6HJKNGIH2
         h04NK+0wPipuUWoX6emda4bWi776Y9EYWRnt/9fve7QYv3lZkMKhuBHcqmWIppkYED01
         MY4M+2Q5+6rHntqk/rj5OMde7rwXdMeb57Jdlhg7Z6bHaaG96ynLCfpQ4bDd9FNjgZZN
         DHRYJfxqEmBj7v121R3Dr1WzchCbNkrQ+oP/uIGiC8eWX6t70WKJXJ5FFsvQRS+iecs7
         g2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509823; x=1743114623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvVg8hZsz7dkUMjowIKzbUwj5JrV7fSVlVByVyTJiR4=;
        b=mhjA1PUAH7pf/2lUeVQ+bKPu731foQfSR3xNipFe0kNiUHMxYpyWhaGwULnlo67Kih
         X6Hbv/SUWIpzo4u6v0TB/sykdLw1PpzDovC8PcStScXk73uACB+acZNBsTqgukU8b6Lv
         V6+2V1vOQXS7tp17xaDXfhCE1fwaexLgFQAqdDXv5vDRteAE8Lz9JLNhQIRZus+8myPz
         a9a+sgbhjPcdw9qhXwESg70sn4QqecfQW69Qm83OBZxjg5qJAQcnIGMgDAbtIXaXhPWq
         A6+QEPV0ZQe0RlZAYNGNkRH9IaoCfg53346Xw62VNpjA/0Rt2XAiKVDB7YdapHJa0kox
         61Lg==
X-Gm-Message-State: AOJu0YyV3FnCawpXq7O/E5N0JDSZrleaFGK3DIIIMflGccCmsUAmh2eX
	UJa9AUr6Fa7PNeMWeTiHxW3tTRlg0cPNJJ8ZqTmerLsVQth/dHXnGGQpfhcKSmg=
X-Gm-Gg: ASbGnctvGkVYpwEsldJ0AsdEmFddq6qRbpOJt5HnFFrSeN+zeOib8pw7KhWxaFXerKE
	lJql3xt/d/4/TT41413kZ8hOvX4HRPJCggyD/nBrU3/DCVcVQFSDl/lT1f26e0CkjzFvjrD46ES
	d6T3xR4dePAlFvOEaSdHPCeOtK3xigjYAL44de862K/oxfmdYk+M0DpZ00kjG4JptOcSCcJaLMc
	uoxJ0QcLWvjOcZ1YBWBhUCzBRcdDJieIAkCE2TLZGhpTaRrpqIaC+OEXkDI9D0ldFjaQ2inViL0
	s/91GmxpWuD+Je0J7+XF/slB76DBzTciM5kpygUtPQV1
X-Google-Smtp-Source: AGHT+IF3p98xOYYrhO5QQaYNcYnxJgU/551mVEoDwnX0IX9zqJGnjweDjdzJDng7FqK36WV1BrN5GQ==
X-Received: by 2002:a17:902:d48c:b0:223:6657:5008 with SMTP id d9443c01a7336-22780d83a42mr17033955ad.24.1742509823276;
        Thu, 20 Mar 2025 15:30:23 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 10/30] exec/cpu-all: remove exec/target_page include
Date: Thu, 20 Mar 2025 15:29:42 -0700
Message-Id: <20250320223002.2915728-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/s390x/ipl.h                      | 1 +
 include/exec/cpu-all.h              | 3 ---
 include/exec/exec-all.h             | 1 +
 include/exec/tlb-flags.h            | 1 +
 linux-user/sparc/target_syscall.h   | 2 ++
 hw/alpha/dp264.c                    | 1 +
 hw/arm/boot.c                       | 1 +
 hw/arm/smmuv3.c                     | 1 +
 hw/hppa/machine.c                   | 1 +
 hw/i386/multiboot.c                 | 1 +
 hw/i386/pc.c                        | 1 +
 hw/i386/pc_sysfw_ovmf.c             | 1 +
 hw/i386/vapic.c                     | 1 +
 hw/loongarch/virt.c                 | 1 +
 hw/m68k/q800.c                      | 1 +
 hw/m68k/virt.c                      | 1 +
 hw/openrisc/boot.c                  | 1 +
 hw/pci-host/astro.c                 | 1 +
 hw/ppc/e500.c                       | 1 +
 hw/ppc/mac_newworld.c               | 1 +
 hw/ppc/mac_oldworld.c               | 1 +
 hw/ppc/ppc_booke.c                  | 1 +
 hw/ppc/prep.c                       | 1 +
 hw/ppc/spapr_hcall.c                | 1 +
 hw/riscv/riscv-iommu-pci.c          | 1 +
 hw/riscv/riscv-iommu.c              | 1 +
 hw/s390x/s390-pci-bus.c             | 1 +
 hw/s390x/s390-pci-inst.c            | 1 +
 hw/s390x/s390-skeys.c               | 1 +
 hw/sparc/sun4m.c                    | 1 +
 hw/sparc64/sun4u.c                  | 1 +
 monitor/hmp-cmds-target.c           | 1 +
 target/alpha/helper.c               | 1 +
 target/arm/gdbstub64.c              | 1 +
 target/arm/tcg/tlb-insns.c          | 1 +
 target/avr/helper.c                 | 1 +
 target/hexagon/translate.c          | 1 +
 target/i386/helper.c                | 1 +
 target/i386/hvf/hvf.c               | 1 +
 target/i386/kvm/hyperv.c            | 1 +
 target/i386/kvm/kvm.c               | 1 +
 target/i386/kvm/xen-emu.c           | 1 +
 target/i386/sev.c                   | 1 +
 target/loongarch/cpu_helper.c       | 1 +
 target/loongarch/tcg/translate.c    | 1 +
 target/microblaze/helper.c          | 1 +
 target/microblaze/mmu.c             | 1 +
 target/mips/tcg/system/cp0_helper.c | 1 +
 target/mips/tcg/translate.c         | 1 +
 target/openrisc/mmu.c               | 1 +
 target/riscv/pmp.c                  | 1 +
 target/rx/cpu.c                     | 1 +
 target/s390x/helper.c               | 1 +
 target/s390x/ioinst.c               | 1 +
 target/tricore/helper.c             | 1 +
 target/xtensa/helper.c              | 1 +
 target/xtensa/xtensa-semi.c         | 1 +
 57 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/hw/s390x/ipl.h b/hw/s390x/ipl.h
index 6557ac3be5b..cb55101f062 100644
--- a/hw/s390x/ipl.h
+++ b/hw/s390x/ipl.h
@@ -14,6 +14,7 @@
 #define HW_S390_IPL_H
 
 #include "cpu.h"
+#include "exec/target_page.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
 #include "hw/qdev-core.h"
diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index db44c0d3016..d4705210370 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -22,9 +22,6 @@
 #include "exec/cpu-common.h"
 #include "hw/core/cpu.h"
 
-/* page related stuff */
-#include "exec/target_page.h"
-
 #include "cpu.h"
 
 #endif /* CPU_ALL_H */
diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
index 19b0eda44a7..c00683f74b0 100644
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -24,6 +24,7 @@
 #include "exec/cpu_ldst.h"
 #endif
 #include "exec/mmu-access-type.h"
+#include "exec/target_page.h"
 #include "exec/translation-block.h"
 
 #if defined(CONFIG_TCG)
diff --git a/include/exec/tlb-flags.h b/include/exec/tlb-flags.h
index c371ae77602..2273144f421 100644
--- a/include/exec/tlb-flags.h
+++ b/include/exec/tlb-flags.h
@@ -20,6 +20,7 @@
 #define TLB_FLAGS_H
 
 #include "exec/cpu-defs.h"
+#include "exec/target_page.h"
 
 #ifdef CONFIG_USER_ONLY
 
diff --git a/linux-user/sparc/target_syscall.h b/linux-user/sparc/target_syscall.h
index e4211653574..c22ede1ddd2 100644
--- a/linux-user/sparc/target_syscall.h
+++ b/linux-user/sparc/target_syscall.h
@@ -1,6 +1,8 @@
 #ifndef SPARC_TARGET_SYSCALL_H
 #define SPARC_TARGET_SYSCALL_H
 
+#include "exec/target_page.h"
+
 #if defined(TARGET_SPARC64) && !defined(TARGET_ABI32)
 struct target_pt_regs {
     abi_ulong u_regs[16];
diff --git a/hw/alpha/dp264.c b/hw/alpha/dp264.c
index 570ea9edf24..c1e24a4ffe8 100644
--- a/hw/alpha/dp264.c
+++ b/hw/alpha/dp264.c
@@ -15,6 +15,7 @@
 #include "hw/rtc/mc146818rtc.h"
 #include "hw/ide/pci.h"
 #include "hw/isa/superio.h"
+#include "exec/target_page.h"
 #include "net/net.h"
 #include "qemu/cutils.h"
 #include "qemu/datadir.h"
diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index e296b62fa12..d3811b896fd 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -14,6 +14,7 @@
 #include <libfdt.h>
 #include "hw/arm/boot.h"
 #include "hw/arm/linux-boot-if.h"
+#include "exec/target_page.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
 #include "system/system.h"
diff --git a/hw/arm/smmuv3.c b/hw/arm/smmuv3.c
index 704469abf19..62d0b3933ca 100644
--- a/hw/arm/smmuv3.c
+++ b/hw/arm/smmuv3.c
@@ -25,6 +25,7 @@
 #include "hw/qdev-core.h"
 #include "hw/pci/pci.h"
 #include "cpu.h"
+#include "exec/target_page.h"
 #include "trace.h"
 #include "qemu/log.h"
 #include "qemu/error-report.h"
diff --git a/hw/hppa/machine.c b/hw/hppa/machine.c
index c5f247633eb..c430bf28dd2 100644
--- a/hw/hppa/machine.c
+++ b/hw/hppa/machine.c
@@ -11,6 +11,7 @@
 #include "elf.h"
 #include "hw/loader.h"
 #include "qemu/error-report.h"
+#include "exec/target_page.h"
 #include "system/reset.h"
 #include "system/system.h"
 #include "system/qtest.h"
diff --git a/hw/i386/multiboot.c b/hw/i386/multiboot.c
index cd07a058614..6e6b96bc345 100644
--- a/hw/i386/multiboot.c
+++ b/hw/i386/multiboot.c
@@ -29,6 +29,7 @@
 #include "multiboot.h"
 #include "hw/loader.h"
 #include "elf.h"
+#include "exec/target_page.h"
 #include "system/system.h"
 #include "qemu/error-report.h"
 
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 63a96cd23f8..c0a22d8232c 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -24,6 +24,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/units.h"
+#include "exec/target_page.h"
 #include "hw/i386/pc.h"
 #include "hw/char/serial-isa.h"
 #include "hw/char/parallel.h"
diff --git a/hw/i386/pc_sysfw_ovmf.c b/hw/i386/pc_sysfw_ovmf.c
index 07a4c267faa..da947c3ca41 100644
--- a/hw/i386/pc_sysfw_ovmf.c
+++ b/hw/i386/pc_sysfw_ovmf.c
@@ -26,6 +26,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "hw/i386/pc.h"
+#include "exec/target_page.h"
 #include "cpu.h"
 
 #define OVMF_TABLE_FOOTER_GUID "96b582de-1fb2-45f7-baea-a366c55a082d"
diff --git a/hw/i386/vapic.c b/hw/i386/vapic.c
index 26aae64e5d8..347431eeef3 100644
--- a/hw/i386/vapic.c
+++ b/hw/i386/vapic.c
@@ -11,6 +11,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/module.h"
+#include "exec/target_page.h"
 #include "system/system.h"
 #include "system/cpus.h"
 #include "system/hw_accel.h"
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 08ae2d96925..39a1400465b 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -8,6 +8,7 @@
 #include "qemu/units.h"
 #include "qemu/datadir.h"
 #include "qapi/error.h"
+#include "exec/target_page.h"
 #include "hw/boards.h"
 #include "hw/char/serial-mm.h"
 #include "system/kvm.h"
diff --git a/hw/m68k/q800.c b/hw/m68k/q800.c
index aeed4c8ddb8..c2e365a8205 100644
--- a/hw/m68k/q800.c
+++ b/hw/m68k/q800.c
@@ -24,6 +24,7 @@
 #include "qemu/units.h"
 #include "qemu/datadir.h"
 #include "qemu/guest-random.h"
+#include "exec/target_page.h"
 #include "system/system.h"
 #include "cpu.h"
 #include "hw/boards.h"
diff --git a/hw/m68k/virt.c b/hw/m68k/virt.c
index d967bdd7438..911f018c03e 100644
--- a/hw/m68k/virt.c
+++ b/hw/m68k/virt.c
@@ -14,6 +14,7 @@
 #include "cpu.h"
 #include "hw/boards.h"
 #include "hw/qdev-properties.h"
+#include "exec/target_page.h"
 #include "elf.h"
 #include "hw/loader.h"
 #include "ui/console.h"
diff --git a/hw/openrisc/boot.c b/hw/openrisc/boot.c
index 0a5881be314..c81efe8138a 100644
--- a/hw/openrisc/boot.c
+++ b/hw/openrisc/boot.c
@@ -9,6 +9,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/cpu-defs.h"
+#include "exec/target_page.h"
 #include "elf.h"
 #include "hw/loader.h"
 #include "hw/openrisc/boot.h"
diff --git a/hw/pci-host/astro.c b/hw/pci-host/astro.c
index 039cc3ad01d..eef154335f9 100644
--- a/hw/pci-host/astro.c
+++ b/hw/pci-host/astro.c
@@ -31,6 +31,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/pci-host/astro.h"
 #include "hw/hppa/hppa_hardware.h"
+#include "exec/target_page.h"
 #include "migration/vmstate.h"
 #include "target/hppa/cpu.h"
 #include "trace.h"
diff --git a/hw/ppc/e500.c b/hw/ppc/e500.c
index 69269aa24c4..f77b2cb9233 100644
--- a/hw/ppc/e500.c
+++ b/hw/ppc/e500.c
@@ -26,6 +26,7 @@
 #include "hw/block/flash.h"
 #include "hw/char/serial-mm.h"
 #include "hw/pci/pci.h"
+#include "exec/target_page.h"
 #include "system/block-backend-io.h"
 #include "system/system.h"
 #include "system/kvm.h"
diff --git a/hw/ppc/mac_newworld.c b/hw/ppc/mac_newworld.c
index 624c2731a65..55b583dd33a 100644
--- a/hw/ppc/mac_newworld.c
+++ b/hw/ppc/mac_newworld.c
@@ -59,6 +59,7 @@
 #include "hw/ppc/mac_dbdma.h"
 #include "hw/pci/pci.h"
 #include "net/net.h"
+#include "exec/target_page.h"
 #include "system/system.h"
 #include "hw/nvram/fw_cfg.h"
 #include "hw/char/escc.h"
diff --git a/hw/ppc/mac_oldworld.c b/hw/ppc/mac_oldworld.c
index 439953fc29e..e23b25654e2 100644
--- a/hw/ppc/mac_oldworld.c
+++ b/hw/ppc/mac_oldworld.c
@@ -32,6 +32,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/boards.h"
 #include "hw/input/adb.h"
+#include "exec/target_page.h"
 #include "system/system.h"
 #include "net/net.h"
 #include "hw/isa/isa.h"
diff --git a/hw/ppc/ppc_booke.c b/hw/ppc/ppc_booke.c
index 925e670ba0a..8b9467753f3 100644
--- a/hw/ppc/ppc_booke.c
+++ b/hw/ppc/ppc_booke.c
@@ -26,6 +26,7 @@
 #include "cpu.h"
 #include "hw/ppc/ppc.h"
 #include "qemu/timer.h"
+#include "exec/target_page.h"
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "hw/loader.h"
diff --git a/hw/ppc/prep.c b/hw/ppc/prep.c
index 3e68d8e6e20..50e86cafd5f 100644
--- a/hw/ppc/prep.c
+++ b/hw/ppc/prep.c
@@ -32,6 +32,7 @@
 #include "hw/pci/pci_host.h"
 #include "hw/ppc/ppc.h"
 #include "hw/boards.h"
+#include "exec/target_page.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/log.h"
diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 406aea4ecbe..fb949a760ef 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1,6 +1,7 @@
 #include "qemu/osdep.h"
 #include "qemu/cutils.h"
 #include "qapi/error.h"
+#include "exec/target_page.h"
 #include "system/hw_accel.h"
 #include "system/runstate.h"
 #include "system/tcg.h"
diff --git a/hw/riscv/riscv-iommu-pci.c b/hw/riscv/riscv-iommu-pci.c
index 12451869e41..e49f593446c 100644
--- a/hw/riscv/riscv-iommu-pci.c
+++ b/hw/riscv/riscv-iommu-pci.c
@@ -27,6 +27,7 @@
 #include "qemu/error-report.h"
 #include "qemu/host-utils.h"
 #include "qom/object.h"
+#include "exec/target_page.h"
 
 #include "cpu_bits.h"
 #include "riscv-iommu.h"
diff --git a/hw/riscv/riscv-iommu.c b/hw/riscv/riscv-iommu.c
index d46beb2d64c..baf3bcd734e 100644
--- a/hw/riscv/riscv-iommu.c
+++ b/hw/riscv/riscv-iommu.c
@@ -25,6 +25,7 @@
 #include "migration/vmstate.h"
 #include "qapi/error.h"
 #include "qemu/timer.h"
+#include "exec/target_page.h"
 
 #include "cpu_bits.h"
 #include "riscv-iommu.h"
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 2591ee49c11..8d460576b1c 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -26,6 +26,7 @@
 #include "hw/pci/msi.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
+#include "exec/target_page.h"
 #include "system/reset.h"
 #include "system/runstate.h"
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index b4e003c19c9..2f23a4d0768 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -23,6 +23,7 @@
 #include "hw/s390x/s390-pci-kvm.h"
 #include "hw/s390x/s390-pci-vfio.h"
 #include "hw/s390x/tod.h"
+#include "exec/target_page.h"
 
 #include "trace.h"
 
diff --git a/hw/s390x/s390-skeys.c b/hw/s390x/s390-skeys.c
index 425e3e4a878..d21bcffa7b9 100644
--- a/hw/s390x/s390-skeys.c
+++ b/hw/s390x/s390-skeys.c
@@ -18,6 +18,7 @@
 #include "qapi/qapi-commands-misc-target.h"
 #include "qobject/qdict.h"
 #include "qemu/error-report.h"
+#include "exec/target_page.h"
 #include "system/memory_mapping.h"
 #include "system/address-spaces.h"
 #include "system/kvm.h"
diff --git a/hw/sparc/sun4m.c b/hw/sparc/sun4m.c
index d27a9b693a5..dbb6c4646ae 100644
--- a/hw/sparc/sun4m.c
+++ b/hw/sparc/sun4m.c
@@ -35,6 +35,7 @@
 #include "migration/vmstate.h"
 #include "hw/sparc/sparc32_dma.h"
 #include "hw/block/fdc.h"
+#include "exec/target_page.h"
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "system/system.h"
diff --git a/hw/sparc64/sun4u.c b/hw/sparc64/sun4u.c
index c7bccf584e6..a93326e145a 100644
--- a/hw/sparc64/sun4u.c
+++ b/hw/sparc64/sun4u.c
@@ -28,6 +28,7 @@
 #include "qapi/error.h"
 #include "qemu/datadir.h"
 #include "cpu.h"
+#include "exec/target_page.h"
 #include "hw/irq.h"
 #include "hw/pci/pci.h"
 #include "hw/pci/pci_bridge.h"
diff --git a/monitor/hmp-cmds-target.c b/monitor/hmp-cmds-target.c
index 011a367357e..8e4d8f66309 100644
--- a/monitor/hmp-cmds-target.c
+++ b/monitor/hmp-cmds-target.c
@@ -24,6 +24,7 @@
 
 #include "qemu/osdep.h"
 #include "disas/disas.h"
+#include "exec/target_page.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
 #include "monitor/hmp-target.h"
diff --git a/target/alpha/helper.c b/target/alpha/helper.c
index f6261a3a53c..096eac34458 100644
--- a/target/alpha/helper.c
+++ b/target/alpha/helper.c
@@ -22,6 +22,7 @@
 #include "cpu.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 #include "fpu/softfloat-types.h"
 #include "exec/helper-proto.h"
 #include "qemu/qemu-print.h"
diff --git a/target/arm/gdbstub64.c b/target/arm/gdbstub64.c
index a9d8352b766..cb596d96ea9 100644
--- a/target/arm/gdbstub64.c
+++ b/target/arm/gdbstub64.c
@@ -19,6 +19,7 @@
 #include "qemu/osdep.h"
 #include "qemu/log.h"
 #include "cpu.h"
+#include "exec/target_page.h"
 #include "internals.h"
 #include "gdbstub/helpers.h"
 #include "gdbstub/commands.h"
diff --git a/target/arm/tcg/tlb-insns.c b/target/arm/tcg/tlb-insns.c
index 630a481f0f8..0407ad5542d 100644
--- a/target/arm/tcg/tlb-insns.c
+++ b/target/arm/tcg/tlb-insns.c
@@ -8,6 +8,7 @@
 #include "qemu/osdep.h"
 #include "qemu/log.h"
 #include "exec/cputlb.h"
+#include "exec/target_page.h"
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
diff --git a/target/avr/helper.c b/target/avr/helper.c
index 64781bbf826..1ea7a258d1d 100644
--- a/target/avr/helper.c
+++ b/target/avr/helper.c
@@ -26,6 +26,7 @@
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/cpu_ldst.h"
+#include "exec/target_page.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
 #include "exec/helper-proto.h"
diff --git a/target/hexagon/translate.c b/target/hexagon/translate.c
index fe7858703c8..deb945829ee 100644
--- a/target/hexagon/translate.c
+++ b/target/hexagon/translate.c
@@ -22,6 +22,7 @@
 #include "tcg/tcg-op-gvec.h"
 #include "exec/helper-gen.h"
 #include "exec/helper-proto.h"
+#include "exec/target_page.h"
 #include "exec/translation-block.h"
 #include "exec/cpu_ldst.h"
 #include "exec/log.h"
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 64d9e8ab9c4..265b3c1466f 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -21,6 +21,7 @@
 #include "qapi/qapi-events-run-state.h"
 #include "cpu.h"
 #include "exec/cputlb.h"
+#include "exec/target_page.h"
 #include "exec/translation-block.h"
 #include "system/runstate.h"
 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 9ba0e04ac75..638a1d0e5ea 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -76,6 +76,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/accel.h"
 #include "target/i386/cpu.h"
+#include "exec/target_page.h"
 
 static Error *invtsc_mig_blocker;
 
diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
index 70b89cacf94..9865120cc43 100644
--- a/target/i386/kvm/hyperv.c
+++ b/target/i386/kvm/hyperv.c
@@ -13,6 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/main-loop.h"
+#include "exec/target_page.h"
 #include "hyperv.h"
 #include "hw/hyperv/hyperv.h"
 #include "hyperv-proto.h"
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee81..c9a3c02e3e3 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -67,6 +67,7 @@
 #include "hw/pci/msix.h"
 #include "migration/blocker.h"
 #include "exec/memattrs.h"
+#include "exec/target_page.h"
 #include "trace.h"
 
 #include CONFIG_DEVICES
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index b23010374f1..0918b7aa9c4 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -14,6 +14,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/error-report.h"
 #include "hw/xen/xen.h"
+#include "exec/target_page.h"
 #include "system/kvm_int.h"
 #include "system/kvm_xen.h"
 #include "kvm/kvm_i386.h"
diff --git a/target/i386/sev.c b/target/i386/sev.c
index ba88976e9f7..878dd20f2c9 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -26,6 +26,7 @@
 #include "qemu/uuid.h"
 #include "qemu/error-report.h"
 #include "crypto/hash.h"
+#include "exec/target_page.h"
 #include "system/kvm.h"
 #include "kvm/kvm_i386.h"
 #include "sev.h"
diff --git a/target/loongarch/cpu_helper.c b/target/loongarch/cpu_helper.c
index 8662fb36ed6..4597e29b153 100644
--- a/target/loongarch/cpu_helper.c
+++ b/target/loongarch/cpu_helper.c
@@ -9,6 +9,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/cpu-mmu-index.h"
+#include "exec/target_page.h"
 #include "internals.h"
 #include "cpu-csr.h"
 
diff --git a/target/loongarch/tcg/translate.c b/target/loongarch/tcg/translate.c
index e59e4ed25b1..03573bbf81f 100644
--- a/target/loongarch/tcg/translate.c
+++ b/target/loongarch/tcg/translate.c
@@ -9,6 +9,7 @@
 #include "cpu.h"
 #include "tcg/tcg-op.h"
 #include "tcg/tcg-op-gvec.h"
+#include "exec/target_page.h"
 #include "exec/translation-block.h"
 #include "exec/translator.h"
 #include "exec/helper-proto.h"
diff --git a/target/microblaze/helper.c b/target/microblaze/helper.c
index 996514ffe88..9e6969ccc9a 100644
--- a/target/microblaze/helper.c
+++ b/target/microblaze/helper.c
@@ -23,6 +23,7 @@
 #include "exec/cputlb.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 #include "qemu/host-utils.h"
 #include "exec/log.h"
 
diff --git a/target/microblaze/mmu.c b/target/microblaze/mmu.c
index 987ac9e3a73..7f20c4e4c69 100644
--- a/target/microblaze/mmu.c
+++ b/target/microblaze/mmu.c
@@ -24,6 +24,7 @@
 #include "exec/cputlb.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 
 static unsigned int tlb_decode_size(unsigned int f)
 {
diff --git a/target/mips/tcg/system/cp0_helper.c b/target/mips/tcg/system/cp0_helper.c
index 01a07a169f6..0ff86686f3f 100644
--- a/target/mips/tcg/system/cp0_helper.c
+++ b/target/mips/tcg/system/cp0_helper.c
@@ -28,6 +28,7 @@
 #include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/cputlb.h"
+#include "exec/target_page.h"
 
 
 /* SMP helpers.  */
diff --git a/target/mips/tcg/translate.c b/target/mips/tcg/translate.c
index 78b848a6d9a..d0a166ef537 100644
--- a/target/mips/tcg/translate.c
+++ b/target/mips/tcg/translate.c
@@ -26,6 +26,7 @@
 #include "translate.h"
 #include "internal.h"
 #include "exec/helper-proto.h"
+#include "exec/target_page.h"
 #include "exec/translation-block.h"
 #include "semihosting/semihost.h"
 #include "trace.h"
diff --git a/target/openrisc/mmu.c b/target/openrisc/mmu.c
index 47ac783c525..acea50c41eb 100644
--- a/target/openrisc/mmu.c
+++ b/target/openrisc/mmu.c
@@ -23,6 +23,7 @@
 #include "cpu.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 #include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #include "hw/loader.h"
diff --git a/target/riscv/pmp.c b/target/riscv/pmp.c
index b0841d44f4c..c13a117e3f9 100644
--- a/target/riscv/pmp.c
+++ b/target/riscv/pmp.c
@@ -26,6 +26,7 @@
 #include "trace.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 
 static bool pmp_write_cfg(CPURISCVState *env, uint32_t addr_index,
                           uint8_t val);
diff --git a/target/rx/cpu.c b/target/rx/cpu.c
index 0ba0d55ab5b..948ee5023e6 100644
--- a/target/rx/cpu.c
+++ b/target/rx/cpu.c
@@ -23,6 +23,7 @@
 #include "migration/vmstate.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 #include "exec/translation-block.h"
 #include "hw/loader.h"
 #include "fpu/softfloat.h"
diff --git a/target/s390x/helper.c b/target/s390x/helper.c
index e660c69f609..3c57c32e479 100644
--- a/target/s390x/helper.c
+++ b/target/s390x/helper.c
@@ -27,6 +27,7 @@
 #include "target/s390x/kvm/pv.h"
 #include "system/hw_accel.h"
 #include "system/runstate.h"
+#include "exec/target_page.h"
 #include "exec/watchpoint.h"
 
 void s390x_tod_timer(void *opaque)
diff --git a/target/s390x/ioinst.c b/target/s390x/ioinst.c
index a944f16c254..8b0ab38277a 100644
--- a/target/s390x/ioinst.c
+++ b/target/s390x/ioinst.c
@@ -17,6 +17,7 @@
 #include "trace.h"
 #include "hw/s390x/s390-pci-bus.h"
 #include "target/s390x/kvm/pv.h"
+#include "exec/target_page.h"
 
 /* All I/O instructions but chsc use the s format */
 static uint64_t get_address_from_regs(CPUS390XState *env, uint32_t ipb,
diff --git a/target/tricore/helper.c b/target/tricore/helper.c
index be3d97af78d..a5ae5bcb619 100644
--- a/target/tricore/helper.c
+++ b/target/tricore/helper.c
@@ -22,6 +22,7 @@
 #include "exec/cputlb.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/page-protection.h"
+#include "exec/target_page.h"
 #include "fpu/softfloat-helpers.h"
 #include "qemu/qemu-print.h"
 
diff --git a/target/xtensa/helper.c b/target/xtensa/helper.c
index 4824b97e371..553e5ed271f 100644
--- a/target/xtensa/helper.c
+++ b/target/xtensa/helper.c
@@ -31,6 +31,7 @@
 #include "exec/cputlb.h"
 #include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
+#include "exec/target_page.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "qemu/host-utils.h"
diff --git a/target/xtensa/xtensa-semi.c b/target/xtensa/xtensa-semi.c
index 2ded8e5634e..636f421da2b 100644
--- a/target/xtensa/xtensa-semi.c
+++ b/target/xtensa/xtensa-semi.c
@@ -29,6 +29,7 @@
 #include "cpu.h"
 #include "chardev/char-fe.h"
 #include "exec/helper-proto.h"
+#include "exec/target_page.h"
 #include "semihosting/semihost.h"
 #include "semihosting/uaccess.h"
 #include "qapi/error.h"
-- 
2.39.5


