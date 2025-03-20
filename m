Return-Path: <kvm+bounces-41608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3458A6B0CE
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA8899828B5
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABBA22B5A8;
	Thu, 20 Mar 2025 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SW+JvrEc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE62229B12
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509821; cv=none; b=unzT1AbVUCHIqvZykiLE7kuf7iQ8Fi+FGefXYNCVinCXoQpgh1oVvm05LEPG+GDTZqkLsIiXFCXdGxKpP6nhdRpkbI0rHSK9tWtBdKxBeSNoIybE9w6tGek4H43avpc2DF+Tx96M/rf9i03EUAqYJTDBcJbApjp0/Jaq4z8dGxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509821; c=relaxed/simple;
	bh=KwhuHopPohHdTpQG4dJcU3sFnrgQqytK0bh+Nkrz/jE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cZfXoRZNgZPzk6a7scG/Qv+X4Dx3oVIBLWRMY0TZqPP52UYWSjHio840YVOq91Xmd2tVJF9SAKCUyKjamWO+ckFbZwVve81iW+epTdF2M4X0W/XtKmcuK9jnyt9VF1FfWvCOzmNpcINnOq/02rbArm06LhF/UeRx3fziZXgHXE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SW+JvrEc; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2264aefc45dso37717915ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509819; x=1743114619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L67JWKUSXROFYdtx0JJFWcEyH0Rce6fQuUWLWkYcbSM=;
        b=SW+JvrEci4I1ZpN6aaGUmh+f9YEVAM4IPkY8QvwUaXP40bxmV/JmhzDkeuyZsSHfZy
         dGEtrgXN6K01PoT9pvu8ZhumtN88qxd1C8Sr0PO+lyf8DeJ3reONi/16g1gemLaxZJ6L
         FEqpEboxpwwrBGqRnX8m6HgsIY3GbAV4G0onJ0NwUhWy2HY2SFRpaGuoNG9NVebVEcrd
         PNmdG9kXXuEtGvd1XdnbkhAm9Pq3dMOQvpKTziv5tf4DK3C1WY4SsEjtsK6WN+zGQRwC
         X8m0u2KhdNZ5yrXEgrR5s2U5CBRNynLyV8aIFqZk9f0xlG0K+dapOovByE19cuOunwL4
         +EOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509819; x=1743114619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L67JWKUSXROFYdtx0JJFWcEyH0Rce6fQuUWLWkYcbSM=;
        b=OBQ3Z75cwikNDKviQlgNGw6e1v4Eh3pPf4pIsBTC09BsJpaReTranrMpaAnWN2Oh4c
         R5chhn6CufvSOk89DeEDR5dk0mf6osfNh5/EAt3W5UO293njg22aqNXxW6drAY9dpwcd
         FD8fBxi1W+W6gvvoFHN40IOyAjgZLtOv7qiWvHah06XX0eJE72+Ueif+dBSikzcDlyaV
         Cl0zjYlm6tx0KRZpGTYsHgvizJKofBB3y4VN6lYuR9BAOoLu8QVSLWw876sYaESEhpzl
         NVV+TNTSF/4e+DKUFy/dE+sZCWbdiYVHYo1ZtsTj3CAKSmmr0UiINVFdg88TgZrpIufR
         wD6g==
X-Gm-Message-State: AOJu0YzCbnwWp7Am8V8UZWkvo6IQQXSPFx8jg1MxvY5uvhjOFTGgGkm8
	qOLTPVuS3I/gyRBkivjgCi7bULodguB4oUEdRgCLb5sxu7uk1HG6hR/iLkD9glk=
X-Gm-Gg: ASbGncvUEnQ2cZDSqlbJ/bzUcvajGb5E82elNlYSQx1cFlGZNleLd57vDVf3wF0vDnP
	rS1lW6+waBGDMenpRh3EjxAd2QMIFLICWnTHf2iIP6TiHsUEw1VlDTNuI0n9G2Wki25veTY0c9O
	XpG9S3ouHcE/dlPrlmNM6jNebM69cYKn/1NSLCSo8bt3VmCY0ubOthozhhbcuriqRo1kwUCDi0t
	pVuIjLpCU1XvROsb495xvEghJpdu72jInmx1egMT5r92rq3tgmycmz8Fg2zjCEqQsMebdLLltAR
	1Je3c7e7IfWbcaOhblSxlyYnzDBgZNy4BJQ9h0Empxf0
X-Google-Smtp-Source: AGHT+IGpP6s+cuDhlrsumYbzxqxXH4hCEx5EdUEKMCwNguE6R8G0z2Llcwdd8JctqX19mKxhAEzdzQ==
X-Received: by 2002:a17:902:d58b:b0:215:6e01:ad07 with SMTP id d9443c01a7336-22780c551d0mr15664475ad.6.1742509818778;
        Thu, 20 Mar 2025 15:30:18 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:18 -0700 (PDT)
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
Subject: [PATCH v2 05/30] exec/cpu-all: remove system/memory include
Date: Thu, 20 Mar 2025 15:29:37 -0700
Message-Id: <20250320223002.2915728-6-pierrick.bouvier@linaro.org>
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

We include this header where needed. When includes set already have
ifdef CONFIG_USER_ONLY, we add it here, else, we don't condition the
include.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/s390x/ipl.h                       | 1 +
 include/exec/cpu-all.h               | 3 ---
 target/arm/internals.h               | 1 +
 target/hppa/cpu.h                    | 1 +
 target/i386/hvf/vmx.h                | 1 +
 target/ppc/mmu-hash32.h              | 2 ++
 hw/ppc/spapr_ovec.c                  | 1 +
 target/alpha/helper.c                | 1 +
 target/arm/hvf/hvf.c                 | 1 +
 target/avr/helper.c                  | 1 +
 target/i386/arch_memory_mapping.c    | 1 +
 target/i386/helper.c                 | 1 +
 target/i386/tcg/system/misc_helper.c | 1 +
 target/i386/tcg/system/tcg-cpu.c     | 1 +
 target/m68k/helper.c                 | 1 +
 target/ppc/excp_helper.c             | 1 +
 target/ppc/mmu-book3s-v3.c           | 1 +
 target/ppc/mmu-hash64.c              | 1 +
 target/ppc/mmu-radix64.c             | 1 +
 target/riscv/cpu_helper.c            | 1 +
 target/sparc/ldst_helper.c           | 1 +
 target/sparc/mmu_helper.c            | 1 +
 target/xtensa/mmu_helper.c           | 1 +
 target/xtensa/op_helper.c            | 1 +
 24 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/hw/s390x/ipl.h b/hw/s390x/ipl.h
index c6ecb3433cc..6557ac3be5b 100644
--- a/hw/s390x/ipl.h
+++ b/hw/s390x/ipl.h
@@ -15,6 +15,7 @@
 
 #include "cpu.h"
 #include "system/address-spaces.h"
+#include "system/memory.h"
 #include "hw/qdev-core.h"
 #include "hw/s390x/ipl/qipl.h"
 #include "qom/object.h"
diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index b1067259e6b..eb029b65552 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -24,9 +24,6 @@
 #include "exec/cpu-interrupt.h"
 #include "exec/tswap.h"
 #include "hw/core/cpu.h"
-#ifndef CONFIG_USER_ONLY
-#include "system/memory.h"
-#endif
 
 /* page related stuff */
 #include "exec/cpu-defs.h"
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 28585c07555..895d60218e3 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -28,6 +28,7 @@
 #include "exec/breakpoint.h"
 #include "hw/registerfields.h"
 #include "tcg/tcg-gvec-desc.h"
+#include "system/memory.h"
 #include "syndrome.h"
 #include "cpu-features.h"
 
diff --git a/target/hppa/cpu.h b/target/hppa/cpu.h
index 7be4a1d3800..bb997d07516 100644
--- a/target/hppa/cpu.h
+++ b/target/hppa/cpu.h
@@ -22,6 +22,7 @@
 
 #include "cpu-qom.h"
 #include "exec/cpu-defs.h"
+#include "system/memory.h"
 #include "qemu/cpu-float.h"
 #include "qemu/interval-tree.h"
 #include "hw/registerfields.h"
diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index 87a478f7fde..3ddf7982ff3 100644
--- a/target/i386/hvf/vmx.h
+++ b/target/i386/hvf/vmx.h
@@ -34,6 +34,7 @@
 #include "system/hvf_int.h"
 
 #include "system/address-spaces.h"
+#include "system/memory.h"
 
 static inline uint64_t rreg(hv_vcpuid_t vcpu, hv_x86_reg_t reg)
 {
diff --git a/target/ppc/mmu-hash32.h b/target/ppc/mmu-hash32.h
index 2838de031c7..04c23ea75ed 100644
--- a/target/ppc/mmu-hash32.h
+++ b/target/ppc/mmu-hash32.h
@@ -3,6 +3,8 @@
 
 #ifndef CONFIG_USER_ONLY
 
+#include "system/memory.h"
+
 bool ppc_hash32_xlate(PowerPCCPU *cpu, vaddr eaddr, MMUAccessType access_type,
                       hwaddr *raddrp, int *psizep, int *protp, int mmu_idx,
                       bool guest_visible);
diff --git a/hw/ppc/spapr_ovec.c b/hw/ppc/spapr_ovec.c
index 6d6eaf67cba..75ab4fe2623 100644
--- a/hw/ppc/spapr_ovec.c
+++ b/hw/ppc/spapr_ovec.c
@@ -16,6 +16,7 @@
 #include "migration/vmstate.h"
 #include "qemu/bitmap.h"
 #include "system/address-spaces.h"
+#include "system/memory.h"
 #include "qemu/error-report.h"
 #include "trace.h"
 #include <libfdt.h>
diff --git a/target/alpha/helper.c b/target/alpha/helper.c
index 57cefcba144..f6261a3a53c 100644
--- a/target/alpha/helper.c
+++ b/target/alpha/helper.c
@@ -25,6 +25,7 @@
 #include "fpu/softfloat-types.h"
 #include "exec/helper-proto.h"
 #include "qemu/qemu-print.h"
+#include "system/memory.h"
 
 
 #define CONVERT_BIT(X, SRC, DST) \
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 93a3f9b53d4..34ca36fab55 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -23,6 +23,7 @@
 #include <mach/mach_time.h>
 
 #include "system/address-spaces.h"
+#include "system/memory.h"
 #include "hw/boards.h"
 #include "hw/irq.h"
 #include "qemu/main-loop.h"
diff --git a/target/avr/helper.c b/target/avr/helper.c
index 6b90fa82c3d..64781bbf826 100644
--- a/target/avr/helper.c
+++ b/target/avr/helper.c
@@ -27,6 +27,7 @@
 #include "exec/page-protection.h"
 #include "exec/cpu_ldst.h"
 #include "system/address-spaces.h"
+#include "system/memory.h"
 #include "exec/helper-proto.h"
 #include "qemu/plugin.h"
 
diff --git a/target/i386/arch_memory_mapping.c b/target/i386/arch_memory_mapping.c
index ced199862dd..a2398c21732 100644
--- a/target/i386/arch_memory_mapping.c
+++ b/target/i386/arch_memory_mapping.c
@@ -14,6 +14,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "system/memory_mapping.h"
+#include "system/memory.h"
 
 /* PAE Paging or IA-32e Paging */
 static void walk_pte(MemoryMappingList *list, AddressSpace *as,
diff --git a/target/i386/helper.c b/target/i386/helper.c
index c07b1b16ea1..64d9e8ab9c4 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -25,6 +25,7 @@
 #include "system/runstate.h"
 #ifndef CONFIG_USER_ONLY
 #include "system/hw_accel.h"
+#include "system/memory.h"
 #include "monitor/monitor.h"
 #include "kvm/kvm_i386.h"
 #endif
diff --git a/target/i386/tcg/system/misc_helper.c b/target/i386/tcg/system/misc_helper.c
index 0555cf26041..67896c8c875 100644
--- a/target/i386/tcg/system/misc_helper.c
+++ b/target/i386/tcg/system/misc_helper.c
@@ -23,6 +23,7 @@
 #include "exec/helper-proto.h"
 #include "exec/cpu_ldst.h"
 #include "system/address-spaces.h"
+#include "system/memory.h"
 #include "exec/cputlb.h"
 #include "tcg/helper-tcg.h"
 #include "hw/i386/apic.h"
diff --git a/target/i386/tcg/system/tcg-cpu.c b/target/i386/tcg/system/tcg-cpu.c
index ab1f3c7c595..0538a4fd51a 100644
--- a/target/i386/tcg/system/tcg-cpu.c
+++ b/target/i386/tcg/system/tcg-cpu.c
@@ -24,6 +24,7 @@
 #include "system/system.h"
 #include "qemu/units.h"
 #include "system/address-spaces.h"
+#include "system/memory.h"
 
 #include "tcg/tcg-cpu.h"
 
diff --git a/target/m68k/helper.c b/target/m68k/helper.c
index 0bf574830f9..82512722191 100644
--- a/target/m68k/helper.c
+++ b/target/m68k/helper.c
@@ -25,6 +25,7 @@
 #include "exec/page-protection.h"
 #include "exec/gdbstub.h"
 #include "exec/helper-proto.h"
+#include "system/memory.h"
 #include "gdbstub/helpers.h"
 #include "fpu/softfloat.h"
 #include "qemu/qemu-print.h"
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index 44e19aacd8d..1b1e37729e1 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -19,6 +19,7 @@
 #include "qemu/osdep.h"
 #include "qemu/main-loop.h"
 #include "qemu/log.h"
+#include "system/memory.h"
 #include "system/tcg.h"
 #include "system/system.h"
 #include "system/runstate.h"
diff --git a/target/ppc/mmu-book3s-v3.c b/target/ppc/mmu-book3s-v3.c
index a812cb51139..38655563105 100644
--- a/target/ppc/mmu-book3s-v3.c
+++ b/target/ppc/mmu-book3s-v3.c
@@ -18,6 +18,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "system/memory.h"
 #include "cpu.h"
 #include "mmu-hash64.h"
 #include "mmu-book3s-v3.h"
diff --git a/target/ppc/mmu-hash64.c b/target/ppc/mmu-hash64.c
index 5ca4faee2ab..3ba4810497e 100644
--- a/target/ppc/mmu-hash64.c
+++ b/target/ppc/mmu-hash64.c
@@ -25,6 +25,7 @@
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "system/hw_accel.h"
+#include "system/memory.h"
 #include "kvm_ppc.h"
 #include "mmu-hash64.h"
 #include "exec/log.h"
diff --git a/target/ppc/mmu-radix64.c b/target/ppc/mmu-radix64.c
index 461eda4a3dc..4ab5f3bb920 100644
--- a/target/ppc/mmu-radix64.c
+++ b/target/ppc/mmu-radix64.c
@@ -23,6 +23,7 @@
 #include "exec/page-protection.h"
 #include "qemu/error-report.h"
 #include "system/kvm.h"
+#include "system/memory.h"
 #include "kvm_ppc.h"
 #include "exec/log.h"
 #include "internal.h"
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 0dd8645994d..ca58094fb54 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -26,6 +26,7 @@
 #include "exec/cputlb.h"
 #include "exec/exec-all.h"
 #include "exec/page-protection.h"
+#include "system/memory.h"
 #include "instmap.h"
 #include "tcg/tcg-op.h"
 #include "accel/tcg/cpu-ops.h"
diff --git a/target/sparc/ldst_helper.c b/target/sparc/ldst_helper.c
index b559afc9a94..eda5f103f10 100644
--- a/target/sparc/ldst_helper.c
+++ b/target/sparc/ldst_helper.c
@@ -27,6 +27,7 @@
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/cpu_ldst.h"
+#include "system/memory.h"
 #ifdef CONFIG_USER_ONLY
 #include "user/page-protection.h"
 #endif
diff --git a/target/sparc/mmu_helper.c b/target/sparc/mmu_helper.c
index cce3046b694..48fb2179b2d 100644
--- a/target/sparc/mmu_helper.c
+++ b/target/sparc/mmu_helper.c
@@ -24,6 +24,7 @@
 #include "exec/cpu-mmu-index.h"
 #include "exec/page-protection.h"
 #include "exec/tlb-flags.h"
+#include "system/memory.h"
 #include "qemu/qemu-print.h"
 #include "trace.h"
 
diff --git a/target/xtensa/mmu_helper.c b/target/xtensa/mmu_helper.c
index 96140c89c76..72910fb1c80 100644
--- a/target/xtensa/mmu_helper.c
+++ b/target/xtensa/mmu_helper.c
@@ -36,6 +36,7 @@
 #include "exec/cpu-mmu-index.h"
 #include "exec/exec-all.h"
 #include "exec/page-protection.h"
+#include "system/memory.h"
 
 #define XTENSA_MPU_SEGMENT_MASK 0x0000001f
 #define XTENSA_MPU_ACC_RIGHTS_MASK 0x00000f00
diff --git a/target/xtensa/op_helper.c b/target/xtensa/op_helper.c
index 028d4e0a1c7..c125fa49464 100644
--- a/target/xtensa/op_helper.c
+++ b/target/xtensa/op_helper.c
@@ -31,6 +31,7 @@
 #include "exec/page-protection.h"
 #include "qemu/host-utils.h"
 #include "exec/exec-all.h"
+#include "system/memory.h"
 #include "qemu/atomic.h"
 #include "qemu/timer.h"
 
-- 
2.39.5


