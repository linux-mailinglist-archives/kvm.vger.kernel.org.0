Return-Path: <kvm+bounces-41619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6FDA6B0DA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F41734A30AB
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F25E22D781;
	Thu, 20 Mar 2025 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CoxJiifo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B9022A7E5
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509831; cv=none; b=DRGBVFz25koKWOYnFuKFglYcSZJMMnl7dPQJQDav71Usuz4YMpd/nmyMU2zcBVq1QV6dwpWoM20gbKL40d9hiMJhteuV4FHiYA4D+ulfdFMSKpyvjkJwXIMEtT7uVHWIwgws5zvaAAB2XbIgj3NatFdAdoShLRDWyMJ6STvASjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509831; c=relaxed/simple;
	bh=3Da8s6NqH3SGrL/CeVe9MGN9ozhxfo+4k1+DwfrjaiE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UFoZbVq57quHWQ9oncBGgm9h8y9jksyXd6jeqhTRjxs6+QOy0+rcRkDn/yXLHs1vaIz6kUB/qW52JGdU8Y0786zr2CiS1DyCjC8GYIo47+ash4jAyfk8Mrb3figruOHWRbXr9uCUiIhaPeVzLMYIenJl1ZYJuar9/XcdgHzA9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CoxJiifo; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-224341bbc1dso26818805ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509829; x=1743114629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFF+NYrYXWsc9S3KVINiHUQFgkktsnSRwhMv3CDMXjs=;
        b=CoxJiifoR47OVbgZ8NX4pecaBaBe4/B8j0LgC44LjglE+NuB3STloDf2+XW40HIGPm
         F4X/RG3wyDmtKZvOJR9TuWEiSXzPO3aboOp2UVGQWJs/QEsnv+ekFIKYJwDwed8Wqt8/
         ue6TnvpvU4bHRaYUEUWaNIMLU1/SNNyYSEfcws4jcSZO5gVTxN2r7cgBOrhwM6zHwhOo
         1b0461/P0s3jD0R1Upu0Qkc39RlS+pjwKi5C3iIbu/S3gn40KvToGd0T3nSuLwArf9Nx
         v9kkdrdoWGpIXiLMuHbn7qwMAG5X3YI68ZJUV3Nk3D4eIer5aOrue9jbKjRY964uRZCe
         4W1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509829; x=1743114629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFF+NYrYXWsc9S3KVINiHUQFgkktsnSRwhMv3CDMXjs=;
        b=GHG6vaxwzQ7SGfBwB+Lbr0rsuieIlLFCjMBunFccsaLJ7AtouedEDK/S6h5Wm6/I7U
         c/HM2Z2+XgfDK+1J4Qn7XSfdQkA2wJSF5hmh3tPovxzEZZZaR14Sb/sNtUsnDusyEee3
         fQLXrqG8jE1NOChO8dprVJbCTfG+KPshguFbnCwB2CxdYnDGkFSIGEcG8sBiz5MtC3s/
         AgI425aEKxMSrNYTqdwn8/MiuxqhuJqWe8wclP3Jjb7vgMYPYbiIL3gvM5u8FVUQV9Cq
         07BnmnB/h+/CMo3itgYq6TNYHYrGZiAp+1W5qUZJJgAJYqY1sdra8TJOZcq1HiaT7uoe
         L4Jw==
X-Gm-Message-State: AOJu0Yz2jQIx+zaF3NROXD21jjIBzrbMYEwMH6seqVrx7tti5MHXFdVL
	eU8Nvf+fB6f/w7tFTUQj5/b58dViOJCwECqgVyeGuybcKw/cC7ug04hK5ZsUmQE=
X-Gm-Gg: ASbGncu043XtoNIIoIk6wY3X8Db8pJ7325bcPtC42OuByhNdtboWS03rdRMg/ImWGUy
	MxvRi9cN3DdjkBbUL+sY/DxrZzSc1lDHHlS7sCwKsAS8eP7jheKuiTNH2NQ6eax2qCuLuDLqWlu
	RnitmTyX4j0fyZKK3hBAFdQrRBjFiOymMPTkk0z+1VeTt0c48kQx89kyMRr2NBSKnhokZSdgXsZ
	UmDrivPwHv/peSCbkomnph6+ZFa05AcSnEoXYpnzORe5kbKmBrSny41gDG9wmvQeF0Ptvhxlo5s
	zxHI/g0+EYxXVW5en+qb++tXAjDBeb3apFvbqMGbCpqx
X-Google-Smtp-Source: AGHT+IHI2nEX6msxhRPw5n9qYD8wACyZAw03ttb0c3rKMPbYLh7fgEilSZocGUOHknppw57YVOo3mw==
X-Received: by 2002:a17:903:1c2:b0:224:1220:7f40 with SMTP id d9443c01a7336-22780c68906mr12439865ad.3.1742509828516;
        Thu, 20 Mar 2025 15:30:28 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:28 -0700 (PDT)
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
Subject: [PATCH v2 16/30] exec/cpu-all: remove this header
Date: Thu, 20 Mar 2025 15:29:48 -0700
Message-Id: <20250320223002.2915728-17-pierrick.bouvier@linaro.org>
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
 accel/tcg/tb-internal.h |  1 -
 include/exec/cpu-all.h  | 22 ----------------------
 include/hw/core/cpu.h   |  2 +-
 include/qemu/bswap.h    |  2 +-
 target/alpha/cpu.h      |  2 --
 target/arm/cpu.h        |  2 --
 target/avr/cpu.h        |  2 --
 target/hexagon/cpu.h    |  2 --
 target/hppa/cpu.h       |  2 --
 target/i386/cpu.h       |  1 -
 target/loongarch/cpu.h  |  2 --
 target/m68k/cpu.h       |  2 --
 target/microblaze/cpu.h |  2 --
 target/mips/cpu.h       |  2 --
 target/openrisc/cpu.h   |  2 --
 target/ppc/cpu.h        |  2 --
 target/riscv/cpu.h      |  2 --
 target/rx/cpu.h         |  2 --
 target/s390x/cpu.h      |  2 --
 target/sh4/cpu.h        |  2 --
 target/sparc/cpu.h      |  2 --
 target/tricore/cpu.h    |  2 --
 target/xtensa/cpu.h     |  2 --
 accel/tcg/cpu-exec.c    |  1 -
 semihosting/uaccess.c   |  1 -
 tcg/tcg-op-ldst.c       |  2 +-
 26 files changed, 3 insertions(+), 65 deletions(-)
 delete mode 100644 include/exec/cpu-all.h

diff --git a/accel/tcg/tb-internal.h b/accel/tcg/tb-internal.h
index 68aa8d17f41..67e721585cf 100644
--- a/accel/tcg/tb-internal.h
+++ b/accel/tcg/tb-internal.h
@@ -9,7 +9,6 @@
 #ifndef ACCEL_TCG_TB_INTERNAL_TARGET_H
 #define ACCEL_TCG_TB_INTERNAL_TARGET_H
 
-#include "exec/cpu-all.h"
 #include "exec/exec-all.h"
 #include "exec/translation-block.h"
 
diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
deleted file mode 100644
index b488e6b7c0b..00000000000
--- a/include/exec/cpu-all.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * defines common to all virtual CPUs
- *
- *  Copyright (c) 2003 Fabrice Bellard
- *
- * This library is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation; either
- * version 2.1 of the License, or (at your option) any later version.
- *
- * This library is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this library; if not, see <http://www.gnu.org/licenses/>.
- */
-#ifndef CPU_ALL_H
-#define CPU_ALL_H
-
-#endif /* CPU_ALL_H */
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 1c63266f072..76a9b2c37db 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -582,7 +582,7 @@ QEMU_BUILD_BUG_ON(offsetof(CPUState, neg) !=
 
 static inline CPUArchState *cpu_env(CPUState *cpu)
 {
-    /* We validate that CPUArchState follows CPUState in cpu-all.h. */
+    /* We validate that CPUArchState follows CPUState in cpu-target.c */
     return (CPUArchState *)(cpu + 1);
 }
 
diff --git a/include/qemu/bswap.h b/include/qemu/bswap.h
index b915835bead..8782056ae48 100644
--- a/include/qemu/bswap.h
+++ b/include/qemu/bswap.h
@@ -206,7 +206,7 @@ CPU_CONVERT(le, 64, uint64_t)
  * (except for byte accesses, which have no endian infix).
  *
  * The target endian accessors are obviously only available to source
- * files which are built per-target; they are defined in cpu-all.h.
+ * files which are built per-target; they are defined in system/memory.h.
  *
  * In all cases these functions take a host pointer.
  * For accessors that take a guest address rather than a
diff --git a/target/alpha/cpu.h b/target/alpha/cpu.h
index fb1d63527ef..849f6734894 100644
--- a/target/alpha/cpu.h
+++ b/target/alpha/cpu.h
@@ -289,8 +289,6 @@ void alpha_cpu_dump_state(CPUState *cs, FILE *f, int flags);
 int alpha_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
 int alpha_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
 
-#include "exec/cpu-all.h"
-
 enum {
     FEATURE_ASN    = 0x00000001,
     FEATURE_SPS    = 0x00000002,
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ee92476814c..ea9956395ca 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -2968,8 +2968,6 @@ static inline bool arm_sctlr_b(CPUARMState *env)
 
 uint64_t arm_sctlr(CPUARMState *env, int el);
 
-#include "exec/cpu-all.h"
-
 /*
  * We have more than 32-bits worth of state per TB, so we split the data
  * between tb->flags and tb->cs_base, which is otherwise unused for ARM.
diff --git a/target/avr/cpu.h b/target/avr/cpu.h
index f56462912b9..b12059ee089 100644
--- a/target/avr/cpu.h
+++ b/target/avr/cpu.h
@@ -246,6 +246,4 @@ bool avr_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                       MMUAccessType access_type, int mmu_idx,
                       bool probe, uintptr_t retaddr);
 
-#include "exec/cpu-all.h"
-
 #endif /* QEMU_AVR_CPU_H */
diff --git a/target/hexagon/cpu.h b/target/hexagon/cpu.h
index e4fc35b112d..c065fa8ddcf 100644
--- a/target/hexagon/cpu.h
+++ b/target/hexagon/cpu.h
@@ -158,6 +158,4 @@ void hexagon_translate_init(void);
 void hexagon_translate_code(CPUState *cs, TranslationBlock *tb,
                             int *max_insns, vaddr pc, void *host_pc);
 
-#include "exec/cpu-all.h"
-
 #endif /* HEXAGON_CPU_H */
diff --git a/target/hppa/cpu.h b/target/hppa/cpu.h
index 5b6cd2ae7fe..2269d1c1064 100644
--- a/target/hppa/cpu.h
+++ b/target/hppa/cpu.h
@@ -306,8 +306,6 @@ struct HPPACPUClass {
     ResettablePhases parent_phases;
 };
 
-#include "exec/cpu-all.h"
-
 static inline bool hppa_is_pa20(const CPUHPPAState *env)
 {
     return env->is_pa20;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 38ec99ee29c..049bdd1a893 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2607,7 +2607,6 @@ int cpu_mmu_index_kernel(CPUX86State *env);
 #define CC_SRC2 (env->cc_src2)
 #define CC_OP   (env->cc_op)
 
-#include "exec/cpu-all.h"
 #include "svm.h"
 
 #if !defined(CONFIG_USER_ONLY)
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index 167989ca7fe..a7d6c809cf4 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -503,8 +503,6 @@ static inline void cpu_get_tb_cpu_state(CPULoongArchState *env, vaddr *pc,
     *flags |= is_va32(env) * HW_FLAGS_VA32;
 }
 
-#include "exec/cpu-all.h"
-
 #define CPU_RESOLVING_TYPE TYPE_LOONGARCH_CPU
 
 void loongarch_cpu_post_init(Object *obj);
diff --git a/target/m68k/cpu.h b/target/m68k/cpu.h
index 5347fbe3975..0b70e8c6ab6 100644
--- a/target/m68k/cpu.h
+++ b/target/m68k/cpu.h
@@ -596,8 +596,6 @@ void m68k_cpu_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
                                  MemTxResult response, uintptr_t retaddr);
 #endif
 
-#include "exec/cpu-all.h"
-
 /* TB flags */
 #define TB_FLAGS_MACSR          0x0f
 #define TB_FLAGS_MSR_S_BIT      13
diff --git a/target/microblaze/cpu.h b/target/microblaze/cpu.h
index 90d820b90c7..2bfa396c96d 100644
--- a/target/microblaze/cpu.h
+++ b/target/microblaze/cpu.h
@@ -411,8 +411,6 @@ void mb_translate_code(CPUState *cs, TranslationBlock *tb,
 #define MMU_USER_IDX    2
 /* See NB_MMU_MODES in cpu-defs.h. */
 
-#include "exec/cpu-all.h"
-
 /* Ensure there is no overlap between the two masks. */
 QEMU_BUILD_BUG_ON(MSR_TB_MASK & IFLAGS_TB_MASK);
 
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 79f8041ced4..20f31370bcb 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1258,8 +1258,6 @@ static inline int mips_env_mmu_index(CPUMIPSState *env)
     return hflags_mmu_index(env->hflags);
 }
 
-#include "exec/cpu-all.h"
-
 /* Exceptions */
 enum {
     EXCP_NONE          = -1,
diff --git a/target/openrisc/cpu.h b/target/openrisc/cpu.h
index f16a070ef6c..19ee85ff5a0 100644
--- a/target/openrisc/cpu.h
+++ b/target/openrisc/cpu.h
@@ -334,8 +334,6 @@ void cpu_openrisc_count_stop(OpenRISCCPU *cpu);
 
 #define CPU_RESOLVING_TYPE TYPE_OPENRISC_CPU
 
-#include "exec/cpu-all.h"
-
 #define TB_FLAGS_SM    SR_SM
 #define TB_FLAGS_DME   SR_DME
 #define TB_FLAGS_IME   SR_IME
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index c6d52204d71..3a895636e18 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1693,8 +1693,6 @@ void ppc_compat_add_property(Object *obj, const char *name,
                              uint32_t *compat_pvr, const char *basedesc);
 #endif /* defined(TARGET_PPC64) */
 
-#include "exec/cpu-all.h"
-
 /*****************************************************************************/
 /* CRF definitions */
 #define CRF_LT_BIT    3
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index da0d35a19f6..e3526241d24 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -634,8 +634,6 @@ G_NORETURN void riscv_raise_exception(CPURISCVState *env,
 target_ulong riscv_cpu_get_fflags(CPURISCVState *env);
 void riscv_cpu_set_fflags(CPURISCVState *env, target_ulong);
 
-#include "exec/cpu-all.h"
-
 FIELD(TB_FLAGS, MEM_IDX, 0, 3)
 FIELD(TB_FLAGS, FS, 3, 2)
 /* Vector flags */
diff --git a/target/rx/cpu.h b/target/rx/cpu.h
index e2ec78835e4..5c19c832194 100644
--- a/target/rx/cpu.h
+++ b/target/rx/cpu.h
@@ -147,8 +147,6 @@ void rx_translate_code(CPUState *cs, TranslationBlock *tb,
                        int *max_insns, vaddr pc, void *host_pc);
 void rx_cpu_unpack_psw(CPURXState *env, uint32_t psw, int rte);
 
-#include "exec/cpu-all.h"
-
 #define CPU_INTERRUPT_SOFT CPU_INTERRUPT_TGT_INT_0
 #define CPU_INTERRUPT_FIR  CPU_INTERRUPT_TGT_INT_1
 
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 83d01d5c4e1..940eda8dd12 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -948,6 +948,4 @@ uint64_t s390_cpu_get_psw_mask(CPUS390XState *env);
 /* outside of target/s390x/ */
 S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
 
-#include "exec/cpu-all.h"
-
 #endif
diff --git a/target/sh4/cpu.h b/target/sh4/cpu.h
index 7581f5eecb7..7752a0c2e1a 100644
--- a/target/sh4/cpu.h
+++ b/target/sh4/cpu.h
@@ -288,8 +288,6 @@ void cpu_load_tlb(CPUSH4State * env);
 /* MMU modes definitions */
 #define MMU_USER_IDX 1
 
-#include "exec/cpu-all.h"
-
 /* MMU control register */
 #define MMUCR    0x1F000010
 #define MMUCR_AT (1<<0)
diff --git a/target/sparc/cpu.h b/target/sparc/cpu.h
index 5dc5dc49475..71e112d8474 100644
--- a/target/sparc/cpu.h
+++ b/target/sparc/cpu.h
@@ -729,8 +729,6 @@ static inline int cpu_pil_allowed(CPUSPARCState *env1, int pil)
 #endif
 }
 
-#include "exec/cpu-all.h"
-
 #ifdef TARGET_SPARC64
 /* sun4u.c */
 void cpu_tick_set_count(CPUTimer *timer, uint64_t count);
diff --git a/target/tricore/cpu.h b/target/tricore/cpu.h
index abb9cba136d..c76e65f8185 100644
--- a/target/tricore/cpu.h
+++ b/target/tricore/cpu.h
@@ -251,8 +251,6 @@ void fpu_set_state(CPUTriCoreState *env);
 
 #define MMU_USER_IDX 2
 
-#include "exec/cpu-all.h"
-
 FIELD(TB_FLAGS, PRIV, 0, 2)
 
 void cpu_state_reset(CPUTriCoreState *s);
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index c5d2042de14..c03ed71c945 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -733,8 +733,6 @@ static inline uint32_t xtensa_replicate_windowstart(CPUXtensaState *env)
 #define XTENSA_CSBASE_LBEG_OFF_MASK 0x00ff0000
 #define XTENSA_CSBASE_LBEG_OFF_SHIFT 16
 
-#include "exec/cpu-all.h"
-
 static inline void cpu_get_tb_cpu_state(CPUXtensaState *env, vaddr *pc,
                                         uint64_t *cs_base, uint32_t *flags)
 {
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 813113c51ea..6c6098955f0 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -35,7 +35,6 @@
 #include "qemu/rcu.h"
 #include "exec/log.h"
 #include "qemu/main-loop.h"
-#include "exec/cpu-all.h"
 #include "cpu.h"
 #include "exec/icount.h"
 #include "exec/replay-core.h"
diff --git a/semihosting/uaccess.c b/semihosting/uaccess.c
index cb64725a37c..c4c4c7a8d03 100644
--- a/semihosting/uaccess.c
+++ b/semihosting/uaccess.c
@@ -8,7 +8,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/cpu-all.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/exec-all.h"
 #include "exec/tlb-flags.h"
diff --git a/tcg/tcg-op-ldst.c b/tcg/tcg-op-ldst.c
index 73838e27015..3b073b4ce0c 100644
--- a/tcg/tcg-op-ldst.c
+++ b/tcg/tcg-op-ldst.c
@@ -37,7 +37,7 @@ static void check_max_alignment(unsigned a_bits)
 {
     /*
      * The requested alignment cannot overlap the TLB flags.
-     * FIXME: Must keep the count up-to-date with "exec/cpu-all.h".
+     * FIXME: Must keep the count up-to-date with "exec/tlb-flags.h".
      */
     if (tcg_use_softmmu) {
         tcg_debug_assert(a_bits + 5 <= tcg_ctx->page_bits);
-- 
2.39.5


