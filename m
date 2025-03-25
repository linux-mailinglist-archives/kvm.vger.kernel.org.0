Return-Path: <kvm+bounces-41904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1C6A6E90B
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F041E7A588E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B6F1F09AF;
	Tue, 25 Mar 2025 04:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oKVGavzu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1856B1A8F60
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878777; cv=none; b=IVr8MS7SG56JpIytcs6Jva/rgCImc+iq4dLv+C7QtMfDZP6HDQ4sl1qvT7S6x1EWbkYNWuDBFzRkyAFITUvrB5A5rojxa0oNYRg7HO/nZsnrTvJh2J6vOKxTQPG8jG8zG04ZX3p6tIq/4nImte2eQZAetSrkOQ+x5BFjnc2Pc6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878777; c=relaxed/simple;
	bh=lFi7xdc7aaSmWUMdtpPZJ2zS4JcyApu5ATfhYSY4Kuo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VKZ7t4gnmlFXHhybyatpoQdq385krjCqHCwmj222rmsaW0/o2V2tTVPEjSDBvT1SLIJ6UcZAzOPFBoXapYGFb25pp2sLhnLx515NliwzbCHl0lRS0F/eENP+ogCJ1E++ADhjKozSrKGAQR8tD49LE55w+Kt6XhyPocNKzkO1N5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oKVGavzu; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-30155bbbed9so6729613a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878775; x=1743483575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=da9qCgJ+S1UaM0j+OYD82icAp+J1ucJQQo9Biij6cxI=;
        b=oKVGavzuSd1+xDDpnCJg8wcdbIjnM6AK03Gy/ppOS+TQ//0eFbKN++V8FWKiP12cr1
         8Nye7QFuvddj048uXnQ+oyvaKY9FNP1qETKv5/d/gL89CNpo+gD6UIvItwC1fvkd6Gmu
         5O9yKMDjLzDP3MTnkc2mYdES0PH8UQDxff+KC/NToTX29xoN+H07+WsJDbA1wfabj7JB
         8u1il2JoarZ/GPdkn1z3rgg/TY3u+pKjItLbzn9FMGQUc73it2OBxQpt0aI1KSEhti5S
         xgUKjl+xozPgg8mF9tulW5uTcH8Z+SFY+3IYR1vvvnuIX51N1Vl42DWV/Pskfl4icG5Y
         Wc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878775; x=1743483575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=da9qCgJ+S1UaM0j+OYD82icAp+J1ucJQQo9Biij6cxI=;
        b=sD4ldeQIp6GQ880EcTMjtaKsF6BMIWI1/Tnd4bKvcj8+36Zjh0C5KVHVgUIQtqiadZ
         M7Nls+kry/Kdl/jg40pRI7SG1n9ng71i9TZl8WtKFPWfDpPzNytdIPIMDfMbXDNjxahl
         iMBApkpb3m7sgusvdTb77HQCwlzMA61tCqPfjn5KdTrPgVzSsJ52CQm843VN2DeR6BQV
         epkWdRKy83770PmwiW28OjbcKm3ayc3Sh7r0OdmW5x6SGnczw9ZMp4ny4iTBHAzxQe1j
         IrXxmSPWfsXPFDx0ItE9B+GgOD+kVAR6WLoRztplZq3fQ7e+RzAlM5S71aEdkO9AuBz5
         EkuA==
X-Forwarded-Encrypted: i=1; AJvYcCX4yudvMeLEvNIdD7i6dD8t1zzLHs/J/BxscxPcAbhcF2IEBG8mzg+0qiCrDICo0O1Ip90=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjmEUMyAFFdU01bhdOPsbcUKpiX2s47FPVCZe7nKPPGFJ6VmqS
	wDyQLa1WTtW+t8KQ/d0i7QtQ+xGvcYRnofIoYJIMQn+GB6NASr7tzoLgNTZUNWdeZEILw2PC/s9
	l
X-Gm-Gg: ASbGnctXg7MRdESK0iI7j/WadBA/cEGv7wRzyPh5wgpxB8dupYJXkGZsnrxDWam9pQa
	sWjcED5V7B6dgFaIAYJr8GC0pkcafa9/1W3lGF479Hz2WLetwtmOkGm7kste9605FfzS7QKWdWO
	Zt7CW8cC+Dlc1xbRJn+oZLdQKRlAtZU/NlRFFul7comWkEz7VT2BdiH0o/4C1G1n6nYsQtPqDfg
	UQWl+lUYg0dPUbzXqcfzQ0k3UVRQwC9+bKtVItwwmX9x46P4poaBP5PulEkXYYxPosbst+KumXk
	fKD4oOHiR+W2fwQL5gl+EZhTVc4WvQdOCNCaaAWzI0nk
X-Google-Smtp-Source: AGHT+IEgjGxzJS/SsixkRPa7V7unRDt/oD82QlFwQaCLK26d+wtOW0DzMMqVormswycOEINYKmOvCQ==
X-Received: by 2002:a17:90b:4b8e:b0:2f9:c139:b61f with SMTP id 98e67ed59e1d1-3030fe8bdf1mr32282657a91.14.1742878775136;
        Mon, 24 Mar 2025 21:59:35 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:34 -0700 (PDT)
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
Subject: [PATCH v3 14/29] exec/cpu-all: transfer exec/cpu-common include to cpu.h headers
Date: Mon, 24 Mar 2025 21:58:59 -0700
Message-Id: <20250325045915.994760-15-pierrick.bouvier@linaro.org>
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
 include/exec/cpu-all.h  | 2 --
 include/exec/cpu_ldst.h | 1 +
 target/alpha/cpu.h      | 1 +
 target/arm/cpu.h        | 1 +
 target/avr/cpu.h        | 1 +
 target/hexagon/cpu.h    | 1 +
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
 target/tricore/cpu.h    | 1 +
 target/xtensa/cpu.h     | 1 +
 cpu-target.c            | 1 +
 22 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index da8f5dd10c5..b488e6b7c0b 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -19,6 +19,4 @@
 #ifndef CPU_ALL_H
 #define CPU_ALL_H
 
-#include "exec/cpu-common.h"
-
 #endif /* CPU_ALL_H */
diff --git a/include/exec/cpu_ldst.h b/include/exec/cpu_ldst.h
index 82e67eff682..313100fcda1 100644
--- a/include/exec/cpu_ldst.h
+++ b/include/exec/cpu_ldst.h
@@ -66,6 +66,7 @@
 #error Can only include this header with TCG
 #endif
 
+#include "exec/cpu-common.h"
 #include "exec/cpu-ldst-common.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/abi_ptr.h"
diff --git a/target/alpha/cpu.h b/target/alpha/cpu.h
index 42788a6a0bc..fb1d63527ef 100644
--- a/target/alpha/cpu.h
+++ b/target/alpha/cpu.h
@@ -21,6 +21,7 @@
 #define ALPHA_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 958a921490e..ee92476814c 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -24,6 +24,7 @@
 #include "qemu/cpu-float.h"
 #include "hw/registerfields.h"
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "exec/gdbstub.h"
diff --git a/target/avr/cpu.h b/target/avr/cpu.h
index 714c6821e2f..f56462912b9 100644
--- a/target/avr/cpu.h
+++ b/target/avr/cpu.h
@@ -22,6 +22,7 @@
 #define QEMU_AVR_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 
diff --git a/target/hexagon/cpu.h b/target/hexagon/cpu.h
index f78c8f9c2a0..e4fc35b112d 100644
--- a/target/hexagon/cpu.h
+++ b/target/hexagon/cpu.h
@@ -21,6 +21,7 @@
 #include "fpu/softfloat-types.h"
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "hex_regs.h"
 #include "mmvec/mmvec.h"
diff --git a/target/hppa/cpu.h b/target/hppa/cpu.h
index 986dc655fc1..5b6cd2ae7fe 100644
--- a/target/hppa/cpu.h
+++ b/target/hppa/cpu.h
@@ -21,6 +21,7 @@
 #define HPPA_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "system/memory.h"
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 64706bd6e5d..38ec99ee29c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -23,6 +23,7 @@
 #include "system/tcg.h"
 #include "cpu-qom.h"
 #include "kvm/hyperv-proto.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "exec/memop.h"
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index 1dba8ac6a7c..167989ca7fe 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -9,6 +9,7 @@
 #define LOONGARCH_CPU_H
 
 #include "qemu/int128.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "fpu/softfloat-types.h"
diff --git a/target/m68k/cpu.h b/target/m68k/cpu.h
index 451644a05a3..5347fbe3975 100644
--- a/target/m68k/cpu.h
+++ b/target/m68k/cpu.h
@@ -21,6 +21,7 @@
 #ifndef M68K_CPU_H
 #define M68K_CPU_H
 
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
diff --git a/target/microblaze/cpu.h b/target/microblaze/cpu.h
index d29681abed4..90d820b90c7 100644
--- a/target/microblaze/cpu.h
+++ b/target/microblaze/cpu.h
@@ -21,6 +21,7 @@
 #define MICROBLAZE_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "qemu/cpu-float.h"
 #include "exec/cpu-interrupt.h"
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 29362498ec4..79f8041ced4 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -2,6 +2,7 @@
 #define MIPS_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #ifndef CONFIG_USER_ONLY
diff --git a/target/openrisc/cpu.h b/target/openrisc/cpu.h
index c153823b629..f16a070ef6c 100644
--- a/target/openrisc/cpu.h
+++ b/target/openrisc/cpu.h
@@ -21,6 +21,7 @@
 #define OPENRISC_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "fpu/softfloat-types.h"
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index 7489ba95648..aa5df47bdaf 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -22,6 +22,7 @@
 
 #include "qemu/int128.h"
 #include "qemu/cpu-float.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "cpu-qom.h"
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 556eda57e94..14a6779b4c1 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -23,6 +23,7 @@
 #include "hw/core/cpu.h"
 #include "hw/registerfields.h"
 #include "hw/qdev-properties.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "exec/gdbstub.h"
diff --git a/target/rx/cpu.h b/target/rx/cpu.h
index 5f2fcb66563..e2ec78835e4 100644
--- a/target/rx/cpu.h
+++ b/target/rx/cpu.h
@@ -23,6 +23,7 @@
 #include "hw/registerfields.h"
 #include "cpu-qom.h"
 
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 0a32ad4c613..83d01d5c4e1 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -27,6 +27,7 @@
 
 #include "cpu-qom.h"
 #include "cpu_models.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
diff --git a/target/sh4/cpu.h b/target/sh4/cpu.h
index 18557d8c386..7581f5eecb7 100644
--- a/target/sh4/cpu.h
+++ b/target/sh4/cpu.h
@@ -21,6 +21,7 @@
 #define SH4_CPU_H
 
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
diff --git a/target/sparc/cpu.h b/target/sparc/cpu.h
index 923836f47c8..5dc5dc49475 100644
--- a/target/sparc/cpu.h
+++ b/target/sparc/cpu.h
@@ -3,6 +3,7 @@
 
 #include "qemu/bswap.h"
 #include "cpu-qom.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "qemu/cpu-float.h"
diff --git a/target/tricore/cpu.h b/target/tricore/cpu.h
index cf9dbc6df8e..abb9cba136d 100644
--- a/target/tricore/cpu.h
+++ b/target/tricore/cpu.h
@@ -22,6 +22,7 @@
 
 #include "cpu-qom.h"
 #include "hw/registerfields.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "qemu/cpu-float.h"
 #include "tricore-defs.h"
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index 66846314786..c5d2042de14 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -30,6 +30,7 @@
 
 #include "cpu-qom.h"
 #include "qemu/cpu-float.h"
+#include "exec/cpu-common.h"
 #include "exec/cpu-defs.h"
 #include "exec/cpu-interrupt.h"
 #include "hw/clock.h"
diff --git a/cpu-target.c b/cpu-target.c
index 587f24b34e5..52de33d50b0 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -23,6 +23,7 @@
 #include "qemu/qemu-print.h"
 #include "system/accel-ops.h"
 #include "system/cpus.h"
+#include "exec/cpu-common.h"
 #include "exec/tswap.h"
 #include "exec/replay-core.h"
 #include "exec/log.h"
-- 
2.39.5


