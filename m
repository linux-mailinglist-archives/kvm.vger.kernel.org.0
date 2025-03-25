Return-Path: <kvm+bounces-41897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3A0A6E900
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C6BB7A39FB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E6E1DC985;
	Tue, 25 Mar 2025 04:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JbHGy27I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D131C5D56
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878770; cv=none; b=lWJswwb8E8UL+Yo5SLteyNwlAKvzdBEb0QgwbRLvX3/ZHNJd7TbLYkZeHLn+9t3di+6r/7d7bectbHg1wRQWKZ6do+if43fZCHtoRgEaDzqJocKxf4cICrX9gfCXi0bnxs1ejI7u0wQDfhokbxj8D0hnO3Egmx+HhHVizi789Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878770; c=relaxed/simple;
	bh=pHckSb0jRum44PK14rMruxhF2nbJsYcqjkcmsA6JWkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U0zkaMdMv8jkwjBwKM/1dVWXKndvkFoQmyfftSRDrnr7LoP5yhGlXZ+kQVW/alBLzBFEPN8/N1fv/97DoxOY/pFD6EA32ydWWnZVm7c/u1VNre52gZ5ThVu0NMiXl8r+M0Nja5AyuGz1rQCEN6SLCfQtgkKCXquUYSyp61bRSX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JbHGy27I; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-301302a328bso9807242a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878768; x=1743483568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Org2345gwISbkRqtcCIQg/RHNCRTSRlXvAPbgPEQ0IA=;
        b=JbHGy27IUZFu79BKuRVPg6ZNoWYi2LlXRYGaHB+Z+dSMgCaeFQYoVr+g7TdOOS7I+p
         6uI+rmJOQYViBGPyUJ1CKR6jM+YvT+Ot4cQRiHrzNBHuAskJOAN/y0HpKfYlG1SdQLso
         NexzlymrbcVpcqk4kc9njJrJnP5/s6rDzKZu2B/IbEiR11kQv3PFdYkDOh71K6+h1ET2
         gsj12Q/lu/sTUhwlQMFxBeMdVYCyBQQhX63aF68yRVI3ngysWfkZwLIiPqIQI9f2kjvi
         KbDJvPIFDDmLsFe1SADHeojsYav2YWAF1aYTZwbjiI5TK/SozSsK1oWCjre7MW0W02SX
         uHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878768; x=1743483568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Org2345gwISbkRqtcCIQg/RHNCRTSRlXvAPbgPEQ0IA=;
        b=Ct69RPonB7R0YClr7au99AXHnkqfv9QU/kW1ICiQ4PiiT6O6DxRSDSmu5NNbdglJqt
         i+7Swxl+xDtAWOA+hu9vONG07jNpwF8w2KCYn/ayxQ4KdwTO09BU8wSvC1nsiUWbPtvF
         gPGZtQTj8U4VasovuouUlmIVBW6bUUDUmjOO1+AdfvxBdVT4i00hO8T28zHU2ZE27Pld
         g0VNPihnsBvr2WYjKCu6EjlN8GYnxs0iXSFGj41IDMq6xTSLdC5uIq26YAGtQVJzyol2
         kLzca80VYweZfGac70TRn6rl5ynDme9cQX8r4hQUvfsSyEZOt82338E5DzrtuvSDC3AQ
         HjSg==
X-Forwarded-Encrypted: i=1; AJvYcCU3PP+ROz8IXeEB5Sigv5zolx48KsdLkLIZDpa5q8RrZUNOiQoZqf8lqSaRCyk0EuBRAoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxiC0UInbfYVDvcAM2irVq5RebN3cxrgYrSmo89xjDtap0Bgii
	uiJS3S3GZp+t9eyWDgfAsxKf9917ahsgAwWg7lHTMulz7ND1/pia42tuFXJpmRo=
X-Gm-Gg: ASbGncujYa63WBrZI8lxwuxqXKgImRsBIcTILhFXeLPRuqmfVDpbA+Jz1eozUeFD7BE
	mrQhy7CTrQU5gGlBN7QiWGMBkPTiuOeewym/VAsSWg4UrtfLH5U9AKH8hqF8+auxDFtBz0zvTPW
	maSUdKcNh0O41YGAeiT9RlFrB8HspjpQqmWDWW+ZfouNXy15cCUXcbxpm5zISsva5vHKfLNB4hw
	jPC4TKTSFdgqDWugbO/R4Ii3E8/lzkEnXVc/R5vYUo5Gcc2h3RIQgD4fJUhJByh5lDcg+W+GE5d
	Mc18igGhf/k5GpL4bPFrIWDvk+hF99csNiz+FN9Qd1Gs
X-Google-Smtp-Source: AGHT+IHabWwVD3wJqLYVJFSCVba25yVxMopHqjmL7IhxQTtf9QY7LAVwfCCLUMQE7U74Hqiw5Bl0hw==
X-Received: by 2002:a17:90b:51cf:b0:2ee:edae:75e with SMTP id 98e67ed59e1d1-3030fe86471mr24805706a91.13.1742878767928;
        Mon, 24 Mar 2025 21:59:27 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:27 -0700 (PDT)
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
Subject: [PATCH v3 07/29] exec/cpu-all: remove exec/cpu-interrupt include
Date: Mon, 24 Mar 2025 21:58:52 -0700
Message-Id: <20250325045915.994760-8-pierrick.bouvier@linaro.org>
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
 include/exec/cpu-all.h  | 1 -
 target/alpha/cpu.h      | 1 +
 target/arm/cpu.h        | 1 +
 target/avr/cpu.h        | 1 +
 target/hppa/cpu.h       | 1 +
 target/i386/cpu.h       | 1 +
 target/loongarch/cpu.h  | 1 +
 target/m68k/cpu.h       | 1 +
 target/microblaze/cpu.h | 1 +
 target/mips/cpu.h       | 1 +
 target/openrisc/cpu.h   | 1 +
 target/ppc/cpu.h        | 1 +
 target/riscv/cpu.h      | 1 +
 target/rx/cpu.h         | 1 +
 target/s390x/cpu.h      | 1 +
 target/sh4/cpu.h        | 1 +
 target/sparc/cpu.h      | 1 +
 target/xtensa/cpu.h     | 1 +
 accel/tcg/cpu-exec.c    | 1 +
 hw/alpha/typhoon.c      | 1 +
 hw/m68k/next-cube.c     | 1 +
 hw/ppc/ppc.c            | 1 +
 hw/xtensa/pic_cpu.c     | 1 +
 23 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 1539574a22a..e5d852fbe2c 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -20,7 +20,6 @@
 #define CPU_ALL_H
 
 #include "exec/cpu-common.h"
-#include "exec/cpu-interrupt.h"
 #include "hw/core/cpu.h"
 
 /* page related stuff */
diff --git a/target/alpha/cpu.h b/target/alpha/cpu.h
index 80562adfb5c..42788a6a0bc 100644
--- a/target/alpha/cpu.h
+++ b/target/alpha/cpu.h
@@ -22,6 +22,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
 
 #define ICACHE_LINE_SIZE 32
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index a8177c6c2e8..958a921490e 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -25,6 +25,7 @@
 #include "hw/registerfields.h"
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "exec/gdbstub.h"
 #include "exec/page-protection.h"
 #include "qapi/qapi-types-common.h"
diff --git a/target/avr/cpu.h b/target/avr/cpu.h
index 06f5ae4d1b1..714c6821e2f 100644
--- a/target/avr/cpu.h
+++ b/target/avr/cpu.h
@@ -23,6 +23,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 
 #ifdef CONFIG_USER_ONLY
 #error "AVR 8-bit does not support user mode"
diff --git a/target/hppa/cpu.h b/target/hppa/cpu.h
index bb997d07516..986dc655fc1 100644
--- a/target/hppa/cpu.h
+++ b/target/hppa/cpu.h
@@ -22,6 +22,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "system/memory.h"
 #include "qemu/cpu-float.h"
 #include "qemu/interval-tree.h"
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 76f24446a55..64706bd6e5d 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -24,6 +24,7 @@
 #include "cpu-qom.h"
 #include "kvm/hyperv-proto.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "exec/memop.h"
 #include "hw/i386/topology.h"
 #include "qapi/qapi-types-common.h"
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index 1916716547a..1dba8ac6a7c 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -10,6 +10,7 @@
 
 #include "qemu/int128.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "fpu/softfloat-types.h"
 #include "hw/registerfields.h"
 #include "qemu/timer.h"
diff --git a/target/m68k/cpu.h b/target/m68k/cpu.h
index ddb0f29f4a3..451644a05a3 100644
--- a/target/m68k/cpu.h
+++ b/target/m68k/cpu.h
@@ -22,6 +22,7 @@
 #define M68K_CPU_H
 
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
 #include "cpu-qom.h"
 
diff --git a/target/microblaze/cpu.h b/target/microblaze/cpu.h
index e44ddd53078..d29681abed4 100644
--- a/target/microblaze/cpu.h
+++ b/target/microblaze/cpu.h
@@ -23,6 +23,7 @@
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
 #include "qemu/cpu-float.h"
+#include "exec/cpu-interrupt.h"
 
 typedef struct CPUArchState CPUMBState;
 #if !defined(CONFIG_USER_ONLY)
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 9ef72a95d71..29362498ec4 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -3,6 +3,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #ifndef CONFIG_USER_ONLY
 #include "system/memory.h"
 #endif
diff --git a/target/openrisc/cpu.h b/target/openrisc/cpu.h
index b97d2ffdd26..c153823b629 100644
--- a/target/openrisc/cpu.h
+++ b/target/openrisc/cpu.h
@@ -22,6 +22,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "fpu/softfloat-types.h"
 
 /**
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index 3ee83517dcd..7489ba95648 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -23,6 +23,7 @@
 #include "qemu/int128.h"
 #include "qemu/cpu-float.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "cpu-qom.h"
 #include "qom/object.h"
 #include "hw/registerfields.h"
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 51e49e03dec..556eda57e94 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -24,6 +24,7 @@
 #include "hw/registerfields.h"
 #include "hw/qdev-properties.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "exec/gdbstub.h"
 #include "qemu/cpu-float.h"
 #include "qom/object.h"
diff --git a/target/rx/cpu.h b/target/rx/cpu.h
index 349d61c4e40..5f2fcb66563 100644
--- a/target/rx/cpu.h
+++ b/target/rx/cpu.h
@@ -24,6 +24,7 @@
 #include "cpu-qom.h"
 
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
 
 #ifdef CONFIG_USER_ONLY
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 5b7992deda6..0a32ad4c613 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -28,6 +28,7 @@
 #include "cpu-qom.h"
 #include "cpu_models.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
 #include "qapi/qapi-types-machine-common.h"
 
diff --git a/target/sh4/cpu.h b/target/sh4/cpu.h
index d536d5d7154..18557d8c386 100644
--- a/target/sh4/cpu.h
+++ b/target/sh4/cpu.h
@@ -22,6 +22,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
 
 /* CPU Subtypes */
diff --git a/target/sparc/cpu.h b/target/sparc/cpu.h
index 462bcb6c0e6..923836f47c8 100644
--- a/target/sparc/cpu.h
+++ b/target/sparc/cpu.h
@@ -4,6 +4,7 @@
 #include "qemu/bswap.h"
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
 
 #if !defined(TARGET_SPARC64)
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index 8d70bfc0cd4..66846314786 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -31,6 +31,7 @@
 #include "cpu-qom.h"
 #include "qemu/cpu-float.h"
 #include "exec/cpu-defs.h"
+#include "exec/cpu-interrupt.h"
 #include "hw/clock.h"
 #include "xtensa-isa.h"
 
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 034c2ded6b1..207416e0212 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -26,6 +26,7 @@
 #include "trace.h"
 #include "disas/disas.h"
 #include "exec/cpu-common.h"
+#include "exec/cpu-interrupt.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
 #include "exec/translation-block.h"
diff --git a/hw/alpha/typhoon.c b/hw/alpha/typhoon.c
index e8711ae16a3..9718e1a579c 100644
--- a/hw/alpha/typhoon.c
+++ b/hw/alpha/typhoon.c
@@ -9,6 +9,7 @@
 #include "qemu/osdep.h"
 #include "qemu/module.h"
 #include "qemu/units.h"
+#include "exec/cpu-interrupt.h"
 #include "qapi/error.h"
 #include "hw/pci/pci_host.h"
 #include "cpu.h"
diff --git a/hw/m68k/next-cube.c b/hw/m68k/next-cube.c
index 0570e4a76f1..4ae5668331b 100644
--- a/hw/m68k/next-cube.c
+++ b/hw/m68k/next-cube.c
@@ -12,6 +12,7 @@
 
 #include "qemu/osdep.h"
 #include "exec/hwaddr.h"
+#include "exec/cpu-interrupt.h"
 #include "system/system.h"
 #include "system/qtest.h"
 #include "hw/irq.h"
diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index 3a80931538f..43d0d0e7553 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -27,6 +27,7 @@
 #include "hw/ppc/ppc.h"
 #include "hw/ppc/ppc_e500.h"
 #include "qemu/timer.h"
+#include "exec/cpu-interrupt.h"
 #include "system/cpus.h"
 #include "qemu/log.h"
 #include "qemu/main-loop.h"
diff --git a/hw/xtensa/pic_cpu.c b/hw/xtensa/pic_cpu.c
index 8cef88c61bc..e3885316106 100644
--- a/hw/xtensa/pic_cpu.c
+++ b/hw/xtensa/pic_cpu.c
@@ -27,6 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "exec/cpu-interrupt.h"
 #include "hw/irq.h"
 #include "qemu/log.h"
 #include "qemu/timer.h"
-- 
2.39.5


