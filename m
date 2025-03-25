Return-Path: <kvm+bounces-41900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4219A6E8FD
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5777816878D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7611E2838;
	Tue, 25 Mar 2025 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TCpJ52gW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C413C1D932F
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878773; cv=none; b=UeE2o9WS8WVz5nd+rH/Po7EdtWrLSNgg/0fGNfWcJ8Sei0fskrdd8OEgZloQ5CEYjADYFo/+TJiHSPKXGihvQ70B6QWBwo/TX/Xkmqx4lHc8PySRLhq5WWRHq8vhUORGLHwDtpgSWR91Lfp8zuuBE7BJP4W0J5jUQbxn1+JTd2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878773; c=relaxed/simple;
	bh=QXS9OuX8GShcsxcJNJgq9ybhkb1+N8n1hBW6w0IwuvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=badeZBLraqEmzYzZvq0yieCTXwuIm4nrOObeiNFeP0n6zCImT75P9ySGNyxVR6995GAxZs3I9x0GAvciaugkVW8FCRmnXgHnGcJNpCoas57i60+zTLqnqT1WLbvxvqRKrL+xUD6nn0VVc9Xh9GqgTxqKCXKFTlt1ST8ZpWTswC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TCpJ52gW; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3018e2d042bso6349958a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878770; x=1743483570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WTNae8XkEmsB47R0C3fMvPlwK+1d7ZJ05j1htpY09PQ=;
        b=TCpJ52gWJ0HRvB/BknisdZAaWZrTWqJaQBIoMHzU+n+nNb+wNtP8871BqzBUABWyrq
         ESb3qOuK9kV8OmEvcmbUQXk9PyynhEJI7mjNZJX92RUUntkickP6BNlnaQHJQDKW6l2+
         0VCqu4Y/X1IgWu0qxxROmufLi6287p0Rp9WN3RWIGZPt/WGbmirrNE3sWvryyGsEsDcf
         nTod8Qni1A5wtiCjacSDMu4P6yt3NdB2ttslDfBt6cjIinsig4+GmI9Fq7OJLRxhz7AR
         6+/iuYDqBw7E6qbn9+rMhu4Lb29ykGr69CBblHKRJRVkHXjRKxwD14CswHnRolpyATuO
         4+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878770; x=1743483570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTNae8XkEmsB47R0C3fMvPlwK+1d7ZJ05j1htpY09PQ=;
        b=WB6nSPr3aIUkTbzgcjjZ5ao27YfoIWbwQ58qejN6Hm/FRX8dqexkIfPJsY2eJ6YmXx
         kamZARn5SqIJzaUz9swoa1/l5BX00RPchuAZ640P38eGG/V+t6ODOJ6fi1U6e5NOA/R0
         PksKj844BebbtDkzcSGMigCG7wgapw1j8TbD+cKdHJNCOkF0/3WrDjISJXqY7kihUAB8
         7gP2OBAvcezdQPWg7gZEyG4v5mPACd85iLlpRWHdnx6GrMAcXjf6PCMLCHp/kb7m8P6O
         S55hCfeDveFXPKc4V+d8mcC31a8+h/K8fN+fEWTUQ5lhKztAlj9ibaQ+b4o31rjiQUPT
         pFDA==
X-Forwarded-Encrypted: i=1; AJvYcCVtlfBAn9N0JC1+WKRwCWCcKEbVAnzloBAQyrwstMhtstXOU4rKvt2bsJCZc9dHYqhBH1k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0YbISOWWkagL6fniC95plFz5PPowbxI7KDvJL4FK82G5Gt6Z2
	gPnIkM1qoTF5XJKC9cL6BqwLHG9jBXNASQ0RhtXPJVv0LvdshvqWqPZqYd4FpPc=
X-Gm-Gg: ASbGnct0Fawf4hDEqOisgQJywEvM5St/pBbFRzyZISdWdcui63p2VzMaX4K3TqEZsDr
	6tko8txFunGLenhc8BmknY0MTFPN6+HLoRDzuRIMv2TW9ewWl6IzHRjAezWLXhRdfFeY+OpIKUc
	N8KzEdLiLhXXq/okl4ErP+RiOOjgOYa+YByPXngX8O6G46IC307q/L89I4lN28EbYnZZt/bI5Kg
	9KlVKh6S6D/KTBOQG1ZtCxdI7TZuteAjNJ2Fyo0cKKoY7GGVsSgCq5ern6cruwpeP6zzIoS0Yll
	5qzBn0gCc4CFvXQA/UMNWz+ayIQSxKughjGys4gMFCjE
X-Google-Smtp-Source: AGHT+IEqtAaXOrsTgwrhzk+QpZj6qbjcnfJJiOXsjubSglNkpTpo7u2mvfgfoC2fSkdQZDxCN8CRhg==
X-Received: by 2002:a17:90b:5408:b0:2ff:6788:cc67 with SMTP id 98e67ed59e1d1-3030ff0dfd6mr21566664a91.34.1742878769766;
        Mon, 24 Mar 2025 21:59:29 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 09/29] exec/cpu-all: remove exec/target_page include
Date: Mon, 24 Mar 2025 21:58:54 -0700
Message-Id: <20250325045915.994760-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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
index 01d0581f62a..3b98089e908 100644
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
index ddf3f1f6e0a..27f72049f34 100644
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
index 2d5309d6f55..023105416e0 100644
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
index b5814690f5a..a461c193da8 100644
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
index 76e0fcd8733..92260f4e285 100644
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
index 5aaafb40dac..126fcc34c03 100644
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
index d3cb7270ff5..becdf3ea980 100644
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


