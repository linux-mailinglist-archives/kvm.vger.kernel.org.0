Return-Path: <kvm+bounces-41618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CC1A6B0D9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38ACB18943EA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D876622D4E2;
	Thu, 20 Mar 2025 22:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R6PFD/w2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E722CBF3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509830; cv=none; b=m616nCiXRX1dfl2AcKGLdv1bxz1RFzMyAtA3TlWIIy/U0f90zaxumOSeAeqjzMkJfd7sv7f78KoIfcKD0DRk4h50WTvqKMa3w4RazsgmZbljSkY+hX19gbid9WxXk736m1pIVIkGUT0Bgv/TSZWWyJznpa+ZeD0pC0NdCdQjCV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509830; c=relaxed/simple;
	bh=1Q2d5+QfpD0ccdSRkxrwM/D5PlQh3rNbHNEPU2rpqf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Idwt+KdVgFhcNHxzk6i/aLxnNxROLY5jWUOS/kULzS8rpRa9o9SdEp6vIo75XH8obbHxRiBeCzG+FO9QFZ000XDRHSti68g38NI99knjPmFJEBtABarE2Cfyly+4c/Y+Urb5CXGUzJ01E1Patbm43hPquqddfqCkiUtppw6P6Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=R6PFD/w2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225a28a511eso29432945ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509827; x=1743114627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ue3wMIxDRm9plhH20mUZGft0jOAkf9QSBx1Uwd6s7+c=;
        b=R6PFD/w2QvfFUPkdcOeVwQcTIlg4aG97V6d9KYs6QodZdiOGX1XUzinTezopA0g91o
         ywPpmMnZ7quPEzVLUM9vXk9eaHRL1bv6UvSkFpLwnPBhjj6bFKu4WNiMe41h2rfQhfIQ
         qw0wmAc35YTRtMOa9OfL+r4Uj6bFT5YTEnESE57YEjtaSPkJwY+qywhZ6ylhUVhk70td
         WwQK56MllJChClTZIWGaBTCZUw28PN5kUlRep06wB56//j5yKKFgaYKdn5qi8Uci4ksM
         UXkfN8oOd9vGqipA4vbzAfxGz+cABgGnMp8r6lNAf0XIZMgyeDt/syD+/qI6pMVJPXtv
         EdDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509827; x=1743114627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ue3wMIxDRm9plhH20mUZGft0jOAkf9QSBx1Uwd6s7+c=;
        b=AzguvSjmzRXUExaDK4ypotKKOJQBjDI15/Q4AlFulJ6JWU3GbBibBCuuTGYe3ZKI1e
         JyCo3NvA29kTWAc7oATsXHueFAEzq5EkRjOLUBFNa18ajJKhKb5BVtmrOtj4TuuendW6
         e3T10Kv9wMQjBn9ap3eI2rFk5++uWswJaFV+YiuAQVaaFvB6ZlZnR5XDDJh80q+/egE2
         b/Xtk4YjU58/haJaM0AlvDbnv7BQaiKDs1ERrwXu0ADnVxeAyc9XCzilS4xiCXDGGcMe
         yC181yAsikmbCPLCZo7aBIXuW9D8JLgcB8sMglb1yeCVveiGzP07MljXqhhg8k62CqOz
         v5yg==
X-Gm-Message-State: AOJu0Yxj77bvf3Wgy4ByEtgCAno8uLyigbzxt9CsTa2UFj9VHgoq7gOG
	1Hf3yyr62j9D4wWXUXX2OR+pMtQZckhfwHHeJ42RCP5Ur9bWlYIvC8I7+q8GtYcyzZSnALQWiNl
	y
X-Gm-Gg: ASbGnctunIkEvWpP26RieFQ/gdoiPrlx5zDuoTkB/9GYNVK+aWlTMkhdlcYPoAhiNrI
	t1mW8xCm0RTZm/9XCdg2EuYp4DEoBgZf0pY85fg3gpFfspM4qJUk7lJHIecGTeUC9FnxNTfpJ7z
	9GTMkNim5gGaW3knjvj++8XMwRuUN2OncQyFooIvRZpIdwu0OW/Ho/1vye/2yy/en1oZ3C054jJ
	jlL54MDXqrwXy8QtN4itYaSPp4Q8Kj2sSNux+Ys5cZtRibqHOniTjgPOf0JJC4mwFkBZs54hGAN
	4hGutfDP8dF9DSf84BgP9UntZ5hy9hOa6w0u5twp8Sr7
X-Google-Smtp-Source: AGHT+IGbr7eJUBWi5cLi1feYMh8IML173g1e+43Vd3AZzYyfFYPqUOI0pk8pEl7jV3DBBp7qfgr7ow==
X-Received: by 2002:a17:902:ce82:b0:224:abb:92c with SMTP id d9443c01a7336-22780e35eeamr11909485ad.50.1742509827607;
        Thu, 20 Mar 2025 15:30:27 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:27 -0700 (PDT)
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
Subject: [PATCH v2 15/30] exec/cpu-all: transfer exec/cpu-common include to cpu.h headers
Date: Thu, 20 Mar 2025 15:29:47 -0700
Message-Id: <20250320223002.2915728-16-pierrick.bouvier@linaro.org>
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
index dd339907f1f..c6d52204d71 100644
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
index df37198897c..da0d35a19f6 100644
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


