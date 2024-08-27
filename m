Return-Path: <kvm+bounces-25150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 313C0960B70
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 862BD1F218D4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 13:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2752A1C8FBE;
	Tue, 27 Aug 2024 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fm9LmITs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739E1C57AC
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 13:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764118; cv=none; b=dtcJjmD+qwkVPcbPhQj273JlFAcNGKueBeNF80uFcada8wn/HG2jgrPre9eSl4iEvymDjOfm1MDEp2wMRhi+vTMhfx4slfT9+riNuWSIAMBuagMksRditqAuuc3b/QZc8pyenh/jiprqITdwLyz/0fCyshJZhfx8LucMIb08eBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764118; c=relaxed/simple;
	bh=LUcRncYkstw7segiyPcylSfJ5R32kGx71z17VxE4yG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUjCXEXGxXItQkata70G6iGdrXBVHrRI+npKEwLJ4l2FzfUwa7gEMCyeILr4dU382zqaWJNu8cZLuuuoKWzhgujTpe1o3ud634ILZIVvApE5RwKG73UzcOdn5wCZDoQUAUbNSpwZ50amxL2LeKVFAuQ1fl7fWF7SF6NJ8GwCrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Fm9LmITs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-428141be2ddso46892985e9.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724764113; x=1725368913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MD8wc4g8KI9rh8uybWL5vkhuXQ1ZDf9pDxd792jHps=;
        b=Fm9LmITsuiwXlUV3dLoMz3wZeQVZgnkz0DGpetUG/yT2TV3BQN4I8JvgHJEALvKsuX
         J2MLUG51Zsd28v7JQP2YTEgq5729sW1A9BMDuqgPTawWErqA7g+XuZNG12hrts+n9joD
         41feg5IUwVjXApKvvCbYEhJhMVH0qZtdnTDtnmweV9Dt6+JL4ez9q31AbM3284Fg6JyF
         +II6Koc5pWDqKBC/K1OANOTsjrjLJJHXIbXGLRorgJ/NdFbZRSPG4Vyfl9HYO+THVqTJ
         QzNQh6BCwmh8LiShRjvaCIoBw1QtksdBBI0QsYyQjuLDALN9BC2zzLPpIczhBdE8gyLY
         jTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724764113; x=1725368913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MD8wc4g8KI9rh8uybWL5vkhuXQ1ZDf9pDxd792jHps=;
        b=BZzOE4ZqQNzfyraOqDjXn/UIgAeFBM1bxj8ecIYB2scl9eUUkS24Ta98vNxMY+/aRx
         VkGi5pjPRRac3FDBIefK8Cvdy417BxPtR1Mud/dbWJd9l3RGQPtHRXBmjkqyZMjcvmOW
         PhoHowKZGXwi8j0RTwWnQoD2jTENIMZhkt0ziO45dwU78/nBNtV5I5IfqkDW2ylSbyOr
         c0tQGQkLOyFbgGJaMm/3UNLYfJZYHVWim3WIucFj1pYqwQWTy9CpuGzy7NaVX/+/JVG2
         7MCFW4MJC2f6C+lc43gk5OztGuj1zjL9LeNhPzWNUcIE4zuNkD1H7Rb/QJTi81IA0B4Y
         4tMw==
X-Gm-Message-State: AOJu0YwVP8jeSziu0KtpjqpuvmQ7vGI3KCam+GZPGn/nVJ+t0saryXlC
	SF89f1Fobj0BF4vdEyldTHOr/QZu9gR7SfSCwdt2cPSRsj5FdCw+gW69OV+RrmP7gN76AxCr9bf
	3
X-Google-Smtp-Source: AGHT+IGf25+bx2RIunIzXYD7ZgDC8cl0SkQ9RTsMDgpu1jLvGJSLbOebGk8UXVEvEVDEuniRA+7y/w==
X-Received: by 2002:a05:600c:524f:b0:425:80d5:b8b2 with SMTP id 5b1f17b1804b1-42acd55df54mr82544845e9.16.1724764112183;
        Tue, 27 Aug 2024 06:08:32 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abeff8e28sm222633065e9.40.2024.08.27.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 06:08:30 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1BC295F9EB;
	Tue, 27 Aug 2024 14:08:30 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	arnd@linaro.org,
	D Scott Phillips <scott@os.amperecomputing.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 1/3] ampere/arm64: Add a fixup handler for alignment faults in aarch64 code
Date: Tue, 27 Aug 2024 14:08:27 +0100
Message-Id: <20240827130829.43632-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827130829.43632-1-alex.bennee@linaro.org>
References: <20240827130829.43632-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: D Scott Phillips <scott@os.amperecomputing.com>

A later patch will hand out Device memory in some cases to code
which expects a Normal memory type, as an errata workaround.
Unaligned accesses to Device memory will fault though, so here we
add a fixup handler to emulate faulting accesses, at a performance
penalty.

Many of the instructions in the Loads and Stores group are supported,
but these groups are not handled here:

 * Advanced SIMD load/store multiple structures
 * Advanced SIMD load/store multiple structures (post-indexed)
 * Advanced SIMD load/store single structure
 * Advanced SIMD load/store single structure (post-indexed)
 * Load/store memory tags
 * Load/store exclusive
 * LDAPR/STLR (unscaled immediate)
 * Load register (literal) [cannot Alignment fault]
 * Load/store register (unprivileged)
 * Atomic memory operations
 * Load/store register (pac)

Instruction implementations are translated from the Exploration tools'
ASL specifications.

Upstream-Status: Pending
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
[AJB: fix align_ldst_regoff_simdfp]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - fix handling of some registers
vAJB:
  - fix align_ldst_regoff_simdfp
    - fix scale calculation (ternary instead of |)
    - don't skip n == t && n != 31 (not relevant to simd/fp)
    - check for invalid option<1>
    - expand opc & 0x2 check to include size
  - add failure pr_warn to fixup_alignment
---
 arch/arm64/include/asm/insn.h |   1 +
 arch/arm64/mm/Makefile        |   3 +-
 arch/arm64/mm/fault.c         | 721 ++++++++++++++++++++++++++++++++++
 arch/arm64/mm/fault_neon.c    |  59 +++
 4 files changed, 783 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/mm/fault_neon.c

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 8c0a36f72d6fc..d6e926b5046c1 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -431,6 +431,7 @@ __AARCH64_INSN_FUNCS(clrex,	0xFFFFF0FF, 0xD503305F)
 __AARCH64_INSN_FUNCS(ssbb,	0xFFFFFFFF, 0xD503309F)
 __AARCH64_INSN_FUNCS(pssbb,	0xFFFFFFFF, 0xD503349F)
 __AARCH64_INSN_FUNCS(bti,	0xFFFFFF3F, 0xD503241f)
+__AARCH64_INSN_FUNCS(dc_zva,	0xFFFFFFE0, 0xD50B7420)
 
 #undef	__AARCH64_INSN_FUNCS
 
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index 60454256945b8..05f1ac75e315c 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y				:= dma-mapping.o extable.o fault.o init.o \
+obj-y				:= dma-mapping.o extable.o fault.o fault_neon.o init.o \
 				   cache.o copypage.o flush.o \
 				   ioremap.o mmap.o pgd.o mmu.o \
 				   context.o proc.o pageattr.o fixmap.o
@@ -13,5 +13,6 @@ obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 obj-$(CONFIG_ARM64_MTE)		+= mteswap.o
 KASAN_SANITIZE_physaddr.o	+= n
 
++CFLAGS_REMOVE_fault_neon.o += -mgeneral-regs-only
 obj-$(CONFIG_KASAN)		+= kasan_init.o
 KASAN_SANITIZE_kasan_init.o	:= n
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 451ba7cbd5adb..744e7b1664b1c 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -5,6 +5,7 @@
  * Copyright (C) 1995  Linus Torvalds
  * Copyright (C) 1995-2004 Russell King
  * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2020 Ampere Computing LLC
  */
 
 #include <linux/acpi.h>
@@ -42,8 +43,10 @@
 #include <asm/system_misc.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
+#include <asm/patching.h>
 
 struct fault_info {
+	/* fault handler, return 0 on successful handling */
 	int	(*fn)(unsigned long far, unsigned long esr,
 		      struct pt_regs *regs);
 	int	sig;
@@ -693,9 +696,727 @@ static int __kprobes do_translation_fault(unsigned long far,
 	return 0;
 }
 
+static int copy_from_user_io(void *to, const void __user *from, unsigned long n)
+{
+	const u8 __user *src = from;
+	u8 *dest = to;
+
+	for (; n; n--)
+		if (get_user(*dest++, src++))
+			break;
+	return n;
+}
+
+static int copy_to_user_io(void __user *to, const void *from, unsigned long n)
+{
+	const u8 *src = from;
+	u8 __user *dest = to;
+
+	for (; n; n--)
+		if (put_user(*src++, dest++))
+			break;
+	return n;
+}
+
+static int align_load(unsigned long addr, int sz, u64 *out)
+{
+	union {
+		u8 d8;
+		u16 d16;
+		u32 d32;
+		u64 d64;
+		char c[8];
+	} data;
+
+	if (sz != 1 && sz != 2 && sz != 4 && sz != 8)
+		return 1;
+	if (is_ttbr0_addr(addr)) {
+		if (copy_from_user_io(data.c, (const void __user *)addr, sz))
+			return 1;
+	} else
+		memcpy_fromio(data.c, (const void __iomem *)addr, sz);
+	switch (sz) {
+	case 1:
+		*out = data.d8;
+		break;
+	case 2:
+		*out = data.d16;
+		break;
+	case 4:
+		*out = data.d32;
+		break;
+	case 8:
+		*out = data.d64;
+		break;
+	default:
+		return 1;
+	}
+	return 0;
+}
+
+static int align_store(unsigned long addr, int sz, u64 val)
+{
+	union {
+		u8 d8;
+		u16 d16;
+		u32 d32;
+		u64 d64;
+		char c[8];
+	} data;
+
+	switch (sz) {
+	case 1:
+		data.d8 = val;
+		break;
+	case 2:
+		data.d16 = val;
+		break;
+	case 4:
+		data.d32 = val;
+		break;
+	case 8:
+		data.d64 = val;
+		break;
+	default:
+		return 1;
+	}
+	if (is_ttbr0_addr(addr)) {
+		if (copy_to_user_io((void __user *)addr, data.c, sz))
+			return 1;
+	} else
+		memcpy_toio((void __iomem *)addr, data.c, sz);
+	return 0;
+}
+
+static int align_dc_zva(unsigned long addr, struct pt_regs *regs)
+{
+	int bs = read_cpuid(DCZID_EL0) & 0xf;
+	int sz = 1 << (bs + 2);
+
+	addr &= ~(sz - 1);
+	if (is_ttbr0_addr(addr)) {
+		for (; sz; sz--) {
+			if (align_store(addr, 1, 0))
+				return 1;
+		}
+	} else
+		memset_io((void *)addr, 0, sz);
+	return 0;
+}
+
+extern u64 __arm64_get_vn_dt(int n, int t);
+extern void __arm64_set_vn_dt(int n, int t, u64 val);
+
+#define get_vn_dt __arm64_get_vn_dt
+#define set_vn_dt __arm64_set_vn_dt
+
+static int align_ldst_pair(u32 insn, struct pt_regs *regs)
+{
+	const u32 OPC = GENMASK(31, 30);
+	const u32 L_MASK = BIT(22);
+
+	int opc = FIELD_GET(OPC, insn);
+	int L = FIELD_GET(L_MASK, insn);
+
+	bool wback = !!(insn & BIT(23));
+	bool postindex = !(insn & BIT(24));
+
+	int n = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, insn);
+	int t = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
+	int t2 = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT2, insn);
+	bool is_store = !L;
+	bool is_signed = !!(opc & 1);
+	int scale = 2 + (opc >> 1);
+	int datasize = 8 << scale;
+	u64 uoffset = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_7, insn);
+	s64 offset = sign_extend64(uoffset, 6) << scale;
+	u64 address;
+	u64 data1, data2;
+	u64 dbytes;
+
+	if ((is_store && (opc & 1)) || opc == 3)
+		return 1;
+
+	if (wback && (t == n || t2 == n) && n != 31)
+		return 1;
+
+	if (!is_store && t == t2)
+		return 1;
+
+	dbytes = datasize / 8;
+
+	address = regs_get_register(regs, n << 3);
+
+	if (!postindex)
+		address += offset;
+
+	if (is_store) {
+		data1 = pt_regs_read_reg(regs, t);
+		data2 = pt_regs_read_reg(regs, t2);
+		if (align_store(address, dbytes, data1) ||
+		    align_store(address + dbytes, dbytes, data2))
+			return 1;
+	} else {
+		if (align_load(address, dbytes, &data1) ||
+		    align_load(address + dbytes, dbytes, &data2))
+			return 1;
+		if (is_signed) {
+			data1 = sign_extend64(data1, datasize - 1);
+			data2 = sign_extend64(data2, datasize - 1);
+		}
+		pt_regs_write_reg(regs, t, data1);
+		pt_regs_write_reg(regs, t2, data2);
+	}
+
+	if (wback) {
+		if (postindex)
+			address += offset;
+		if (n == 31)
+			regs->sp = address;
+		else
+			pt_regs_write_reg(regs, n, address);
+	}
+
+	return 0;
+}
+
+static int align_ldst_pair_simdfp(u32 insn, struct pt_regs *regs)
+{
+	const u32 OPC = GENMASK(31, 30);
+	const u32 L_MASK = BIT(22);
+
+	int opc = FIELD_GET(OPC, insn);
+	int L = FIELD_GET(L_MASK, insn);
+
+	bool wback = !!(insn & BIT(23));
+	bool postindex = !(insn & BIT(24));
+
+	int n = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, insn);
+	int t = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
+	int t2 = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT2, insn);
+	bool is_store = !L;
+	int scale = 2 + opc;
+	int datasize = 8 << scale;
+	u64 uoffset = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_7, insn);
+	s64 offset = sign_extend64(uoffset, 6) << scale;
+	u64 address;
+	u64 data1_d0, data1_d1, data2_d0, data2_d1;
+	u64 dbytes;
+
+	if (opc == 0x3)
+		return 1;
+
+	if (!is_store && t == t2)
+		return 1;
+
+	dbytes = datasize / 8;
+
+	address = regs_get_register(regs, n << 3);
+
+	if (!postindex)
+		address += offset;
+
+	if (is_store) {
+		data1_d0 = get_vn_dt(t, 0);
+		data2_d0 = get_vn_dt(t2, 0);
+		if (datasize == 128) {
+			data1_d1 = get_vn_dt(t, 1);
+			data2_d1 = get_vn_dt(t2, 1);
+			if (align_store(address, 8, data1_d0) ||
+			    align_store(address + 8, 8, data1_d1) ||
+			    align_store(address + 16, 8, data2_d0) ||
+			    align_store(address + 24, 8, data2_d1))
+				return 1;
+		} else {
+			if (align_store(address, dbytes, data1_d0) ||
+			    align_store(address + dbytes, dbytes, data2_d0))
+				return 1;
+		}
+	} else {
+		if (datasize == 128) {
+			if (align_load(address, 8, &data1_d0) ||
+			    align_load(address + 8, 8, &data1_d1) ||
+			    align_load(address + 16, 8, &data2_d0) ||
+			    align_load(address + 24, 8, &data2_d1))
+				return 1;
+		} else {
+			if (align_load(address, dbytes, &data1_d0) ||
+			    align_load(address + dbytes, dbytes, &data2_d0))
+				return 1;
+			data1_d1 = data2_d1 = 0;
+		}
+		set_vn_dt(t, 0, data1_d0);
+		set_vn_dt(t, 1, data1_d1);
+		set_vn_dt(t2, 0, data2_d0);
+		set_vn_dt(t2, 1, data2_d1);
+	}
+
+	if (wback) {
+		if (postindex)
+			address += offset;
+		if (n == 31)
+			regs->sp = address;
+		else
+			pt_regs_write_reg(regs, n, address);
+	}
+
+	return 0;
+}
+
+static int align_ldst_regoff(u32 insn, struct pt_regs *regs)
+{
+	const u32 SIZE = GENMASK(31, 30);
+	const u32 OPC = GENMASK(23, 22);
+	const u32 OPTION = GENMASK(15, 13);
+	const u32 S = BIT(12);
+
+	u32 size = FIELD_GET(SIZE, insn);
+	u32 opc = FIELD_GET(OPC, insn);
+	u32 option = FIELD_GET(OPTION, insn);
+	u32 s = FIELD_GET(S, insn);
+	int scale = size;
+	int extend_len = (option & 0x1) ? 64 : 32;
+	bool extend_unsigned = !(option & 0x4);
+	int shift = s ? scale : 0;
+
+	int n = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, insn);
+	int t = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
+	int m = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RM, insn);
+	bool is_store;
+	bool is_signed;
+	int regsize;
+	int datasize;
+	u64 offset;
+	u64 address;
+	u64 data;
+
+	if ((opc & 0x2) == 0) {
+		/* store or zero-extending load */
+		is_store = !(opc & 0x1);
+		regsize = size == 0x3 ? 64 : 32;
+		is_signed = false;
+	} else {
+		if (size == 0x3) {
+			if ((opc & 0x1) == 0) {
+				/* prefetch */
+				return 0;
+			} else {
+				/* undefined */
+				return 1;
+			}
+		} else {
+			/* sign-extending load */
+			is_store = false;
+			if (size == 0x2 && (opc & 0x1) == 0x1) {
+				/* undefined */
+				return 1;
+			}
+			regsize = (opc & 0x1) == 0x1 ? 32 : 64;
+			is_signed = true;
+		}
+	}
+
+	datasize = 8 << scale;
+
+	if (n == t && n != 31)
+		return 1;
+
+	offset = pt_regs_read_reg(regs, m);
+	if (extend_len == 32) {
+		offset &= (u32)~0;
+		if (!extend_unsigned)
+			sign_extend64(offset, 31);
+	}
+	offset <<= shift;
+
+	address = regs_get_register(regs, n << 3) + offset;
+
+	if (is_store) {
+		data = pt_regs_read_reg(regs, t);
+		if (align_store(address, datasize / 8, data))
+			return 1;
+	} else {
+		if (align_load(address, datasize / 8, &data))
+			return 1;
+		if (is_signed) {
+			if (regsize == 32)
+				data = sign_extend32(data, datasize - 1);
+			else
+				data = sign_extend64(data, datasize - 1);
+		}
+	}
+
+	return 0;
+}
+
+static int align_ldst_regoff_simdfp(u32 insn, struct pt_regs *regs)
+{
+	const u32 SIZE = GENMASK(31, 30);
+	const u32 OPC = GENMASK(23, 22);
+	const u32 OPTION = GENMASK(15, 13);
+	const u32 S = BIT(12);
+
+	u32 size = FIELD_GET(SIZE, insn);
+	u32 opc = FIELD_GET(OPC, insn);
+	u32 option = FIELD_GET(OPTION, insn);
+	u32 s = FIELD_GET(S, insn);
+	/* this elides the 8/16 bit sign extensions */
+	int extend_len = (option & 0x1) ? 64 : 32;
+	bool extend_unsigned = !(option & 0x4);
+
+	int n = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, insn);
+	int t = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
+	int m = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RM, insn);
+	bool is_store = !(opc & BIT(0));
+	int scale;
+	int shift;
+	int datasize;
+	u64 offset;
+	u64 address;
+	u64 data_d0, data_d1;
+
+	/* if option<1> == '0' then UNDEFINED; // sub-word index */
+	if ((option & 0x2) == 0) {
+		pr_warn("option<1> == 0 is UNDEFINED");
+		return 1;
+	}
+
+	/* if opc<1> == '1' && size != '00' then UNDEFINED;*/
+	if ((opc & 0x2) && size != 0b00) {
+		pr_warn("opc<1> == '1' && size != '00' is UNDEFINED\n");
+		return 1;
+	}
+
+	/*
+	 * constant integer scale = if opc<1> == '1' then 4 else UInt(size);
+	 */
+	scale = opc & 0x2 ? 4 : size;
+	shift = s ? scale : 0;
+
+	datasize = 8 << scale;
+
+	offset = pt_regs_read_reg(regs, m);
+	if (extend_len == 32) {
+		offset &= (u32)~0;
+		if (!extend_unsigned)
+			sign_extend64(offset, 31);
+	}
+	offset <<= shift;
+
+	address = regs_get_register(regs, n << 3) + offset;
+
+	if (is_store) {
+		data_d0 = get_vn_dt(t, 0);
+		if (datasize == 128) {
+			data_d1 = get_vn_dt(t, 1);
+			if (align_store(address, 8, data_d0) ||
+			    align_store(address + 8, 8, data_d1))
+				return 1;
+		} else {
+			if (align_store(address, datasize / 8, data_d0))
+				return 1;
+		}
+	} else {
+		if (datasize == 128) {
+			if (align_load(address, 8, &data_d0) ||
+			    align_load(address + 8, 8, &data_d1))
+				return 1;
+		} else {
+			if (align_load(address, datasize / 8, &data_d0))
+				return 1;
+			data_d1 = 0;
+		}
+		set_vn_dt(t, 0, data_d0);
+		set_vn_dt(t, 1, data_d1);
+	}
+
+	return 0;
+}
+
+static int align_ldst_imm(u32 insn, struct pt_regs *regs)
+{
+	const u32 SIZE = GENMASK(31, 30);
+	const u32 OPC = GENMASK(23, 22);
+
+	u32 size = FIELD_GET(SIZE, insn);
+	u32 opc = FIELD_GET(OPC, insn);
+	bool wback = !(insn & BIT(24)) && !!(insn & BIT(10));
+	bool postindex = wback && !(insn & BIT(11));
+	int scale = size;
+	u64 offset;
+
+	int n = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, insn);
+	int t = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
+	bool is_store;
+	bool is_signed;
+	int regsize;
+	int datasize;
+	u64 address;
+	u64 data;
+
+	if (!(insn & BIT(24))) {
+		u64 uoffset =
+			aarch64_insn_decode_immediate(AARCH64_INSN_IMM_9, insn);
+		offset = sign_extend64(uoffset, 8);
+	} else {
+		offset = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_12, insn);
+		offset <<= scale;
+	}
+
+	if ((opc & 0x2) == 0) {
+		/* store or zero-extending load */
+		is_store = !(opc & 0x1);
+		regsize = size == 0x3 ? 64 : 32;
+		is_signed = false;
+	} else {
+		if (size == 0x3) {
+			if (FIELD_GET(GENMASK(11, 10), insn) == 0 && (opc & 0x1) == 0) {
+				/* prefetch */
+				return 0;
+			} else {
+				/* undefined */
+				return 1;
+			}
+		} else {
+			/* sign-extending load */
+			is_store = false;
+			if (size == 0x2 && (opc & 0x1) == 0x1) {
+				/* undefined */
+				return 1;
+			}
+			regsize = (opc & 0x1) == 0x1 ? 32 : 64;
+			is_signed = true;
+		}
+	}
+
+	datasize = 8 << scale;
+
+	if (n == t && n != 31)
+		return 1;
+
+	address = regs_get_register(regs, n << 3);
+
+	if (!postindex)
+		address += offset;
+
+	if (is_store) {
+		data = pt_regs_read_reg(regs, t);
+		if (align_store(address, datasize / 8, data))
+			return 1;
+	} else {
+		if (align_load(address, datasize / 8, &data))
+			return 1;
+		if (is_signed) {
+			if (regsize == 32)
+				data = sign_extend32(data, datasize - 1);
+			else
+				data = sign_extend64(data, datasize - 1);
+		}
+		pt_regs_write_reg(regs, t, data);
+	}
+
+	if (wback) {
+		if (postindex)
+			address += offset;
+		if (n == 31)
+			regs->sp = address;
+		else
+			pt_regs_write_reg(regs, n, address);
+	}
+
+	return 0;
+}
+
+static int align_ldst_imm_simdfp(u32 insn, struct pt_regs *regs)
+{
+	const u32 SIZE = GENMASK(31, 30);
+	const u32 OPC = GENMASK(23, 22);
+
+	u32 size = FIELD_GET(SIZE, insn);
+	u32 opc = FIELD_GET(OPC, insn);
+	bool wback = !(insn & BIT(24)) && !!(insn & BIT(10));
+	bool postindex = wback && !(insn & BIT(11));
+	int scale = (opc & 0x2) << 1 | size;
+	u64 offset;
+
+	int n = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, insn);
+	int t = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RT, insn);
+	bool is_store = !(opc & BIT(0)) ;
+	int datasize;
+	u64 address;
+	u64 data_d0, data_d1;
+
+	if (scale > 4)
+		return 1;
+
+	if (!(insn & BIT(24))) {
+		u64 uoffset =
+			aarch64_insn_decode_immediate(AARCH64_INSN_IMM_9, insn);
+		offset = sign_extend64(uoffset, 8);
+	} else {
+		offset = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_12, insn);
+		offset <<= scale;
+	}
+
+	datasize = 8 << scale;
+
+	address = regs_get_register(regs, n << 3);
+
+	if (!postindex)
+		address += offset;
+
+	if (is_store) {
+		data_d0 = get_vn_dt(t, 0);
+		if (datasize == 128) {
+			data_d1 = get_vn_dt(t, 1);
+			if (align_store(address, 8, data_d0) ||
+			    align_store(address + 8, 8, data_d1))
+				return 1;
+		} else {
+			if (align_store(address, datasize / 8, data_d0))
+				return 1;
+		}
+	} else {
+		if (datasize == 128) {
+			if (align_load(address, 8, &data_d0) ||
+			    align_load(address + 8, 8, &data_d1))
+				return 1;
+		} else {
+			if (align_load(address, datasize / 8, &data_d0))
+				return 1;
+			data_d1 = 0;
+		}
+		set_vn_dt(t, 0, data_d0);
+		set_vn_dt(t, 1, data_d1);
+	}
+
+	if (wback) {
+		if (postindex)
+			address += offset;
+		if (n == 31)
+			regs->sp = address;
+		else
+			pt_regs_write_reg(regs, n, address);
+	}
+
+	return 0;
+}
+
+static int align_ldst(u32 insn, struct pt_regs *regs)
+{
+	const u32 op0 = FIELD_GET(GENMASK(31, 28), insn);
+	const u32 op1 = FIELD_GET(BIT(26), insn);
+	const u32 op2 = FIELD_GET(GENMASK(24, 23), insn);
+	const u32 op3 = FIELD_GET(GENMASK(21, 16), insn);
+	const u32 op4 = FIELD_GET(GENMASK(11, 10), insn);
+
+	if ((op0 & 0x3) == 0x2) {
+		/*
+		 * |------+-----+-----+-----+-----+-----------------------------------------|
+		 * | op0  | op1 | op2 | op3 | op4 | Decode group                            |
+		 * |------+-----+-----+-----+-----+-----------------------------------------|
+		 * | xx10 | -   |  00 | -   | -   | Load/store no-allocate pair (offset)    |
+		 * | xx10 | -   |  01 | -   | -   | Load/store register pair (post-indexed) |
+		 * | xx10 | -   |  10 | -   | -   | Load/store register pair (offset)       |
+		 * | xx10 | -   |  11 | -   | -   | Load/store register pair (pre-indexed)  |
+		 * |------+-----+-----+-----+-----+-----------------------------------------|
+		 */
+
+		if (op1 == 0) { /* V == 0 */
+			/* general */
+			return align_ldst_pair(insn, regs);
+		} else {
+			/* simdfp */
+			return align_ldst_pair_simdfp(insn, regs);
+		}
+	} else if ((op0 & 0x3) == 0x3 &&
+		   (((op2 & 0x2) == 0 && (op3 & 0x20) == 0 && op4 != 0x2) ||
+		    ((op2 & 0x2) == 0x2))) {
+		/*
+		 * |------+-----+-----+--------+-----+----------------------------------------------|
+		 * | op0  | op1 | op2 |    op3 | op4 | Decode group                                 |
+		 * |------+-----+-----+--------+-----+----------------------------------------------|
+		 * | xx11 | -   |  0x | 0xxxxx |  00 | Load/store register (unscaled immediate)     |
+		 * | xx11 | -   |  0x | 0xxxxx |  01 | Load/store register (immediate post-indexed) |
+		 * | xx11 | -   |  0x | 0xxxxx |  11 | Load/store register (immediate pre-indexed)  |
+		 * | xx11 | -   |  1x |      - |   - | Load/store register (unsigned immediate)     |
+		 * |------+-----+-----+--------+-----+----------------------------------------------|
+		 */
+
+		if (op1 == 0) {  /* V == 0 */
+			/* general */
+			return align_ldst_imm(insn, regs);
+		} else {
+			/* simdfp */
+			return align_ldst_imm_simdfp(insn, regs);
+		}
+	} else if ((op0 & 0x3) == 0x3 && (op2 & 0x2) == 0 &&
+		   (op3 & 0x20) == 0x20 && op4 == 0x2) {
+		/*
+		 * |------+-----+-----+--------+-----+---------------------------------------|
+		 * | op0  | op1 | op2 |    op3 | op4 |                                       |
+		 * |------+-----+-----+--------+-----+---------------------------------------|
+		 * | xx11 | -   |  0x | 1xxxxx |  10 | Load/store register (register offset) |
+		 * |------+-----+-----+--------+-----+---------------------------------------|
+		 */
+		if (op1 == 0) { /* V == 0 */
+			/* general */
+			return align_ldst_regoff(insn, regs);
+		} else {
+			/* simdfp */
+			return align_ldst_regoff_simdfp(insn, regs);
+		}
+	} else
+		return 1;
+}
+
+static int fixup_alignment(unsigned long addr, unsigned int esr,
+			   struct pt_regs *regs)
+{
+	u32 insn;
+	int res;
+
+	if (user_mode(regs)) {
+		__le32 insn_le;
+
+		if (!is_ttbr0_addr(addr))
+			return 1;
+
+		if (get_user(insn_le,
+			     (__le32 __user *)instruction_pointer(regs)))
+			return 1;
+		insn = le32_to_cpu(insn_le);
+	} else {
+		if (aarch64_insn_read((void *)instruction_pointer(regs), &insn))
+			return 1;
+	}
+
+	if (aarch64_insn_is_class_branch_sys(insn)) {
+		if (aarch64_insn_is_dc_zva(insn))
+			res = align_dc_zva(addr, regs);
+		else
+			res = 1;
+	} else if (((insn >> 25) & 0x5) == 0x4) {
+		res = align_ldst(insn, regs);
+	} else {
+		res = 1;
+	}
+
+	if (!res)
+		instruction_pointer_set(regs, instruction_pointer(regs) + 4);
+	else
+		pr_warn("%s: failed to fixup 0x%04x", __func__, insn);
+
+	return res;
+}
+
 static int do_alignment_fault(unsigned long far, unsigned long esr,
 			      struct pt_regs *regs)
 {
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+	 if (!fixup_alignment(far, esr, regs))
+	 return 0;
+#endif
 	if (IS_ENABLED(CONFIG_COMPAT_ALIGNMENT_FIXUPS) &&
 	    compat_user_mode(regs))
 		return do_compat_alignment_fixup(far, regs);
diff --git a/arch/arm64/mm/fault_neon.c b/arch/arm64/mm/fault_neon.c
new file mode 100644
index 0000000000000..d5319ed07d89b
--- /dev/null
+++ b/arch/arm64/mm/fault_neon.c
@@ -0,0 +1,59 @@
+/*
+ * These functions require asimd, which is not accepted by Clang in normal
+ * kernel code, which is compiled with -mgeneral-regs-only. GCC will somehow
+ * eat it regardless, but we want it to be portable, so move these in their
+ * own translation unit. This allows us to turn off -mgeneral-regs-only for
+ * these (where it should be harmless) without risking the compiler doing
+ * wrong things in places where we don't want it to.
+ *
+ * Otherwise this is identical to the original patch.
+ *
+ * -- q66 <q66@chimera-linux.org>
+ *
+ */
+
+#include <linux/types.h>
+
+u64 __arm64_get_vn_dt(int n, int t) {
+	u64 res;
+
+	switch (n) {
+#define V(n)						\
+	case n:						\
+		asm("cbnz %w1, 1f\n\t"			\
+		    "mov %0, v"#n".d[0]\n\t"		\
+		    "b 2f\n\t"				\
+		    "1: mov %0, v"#n".d[1]\n\t"		\
+		    "2:" : "=r" (res) : "r" (t));	\
+		break
+	V( 0); V( 1); V( 2); V( 3); V( 4); V( 5); V( 6); V( 7);
+	V( 8); V( 9); V(10); V(11); V(12); V(13); V(14); V(15);
+	V(16); V(17); V(18); V(19); V(20); V(21); V(22); V(23);
+	V(24); V(25); V(26); V(27); V(28); V(29); V(30); V(31);
+#undef V
+	default:
+		res = 0;
+		break;
+	}
+	return res;
+}
+
+void __arm64_set_vn_dt(int n, int t, u64 val) {
+	switch (n) {
+#define V(n)						\
+	case n:						\
+		asm("cbnz %w1, 1f\n\t"			\
+		    "mov v"#n".d[0], %0\n\t"		\
+		    "b 2f\n\t"				\
+		    "1: mov v"#n".d[1], %0\n\t"		\
+		    "2:" :: "r" (val), "r" (t));	\
+		break
+	V( 0); V( 1); V( 2); V( 3); V( 4); V( 5); V( 6); V( 7);
+	V( 8); V( 9); V(10); V(11); V(12); V(13); V(14); V(15);
+	V(16); V(17); V(18); V(19); V(20); V(21); V(22); V(23);
+	V(24); V(25); V(26); V(27); V(28); V(29); V(30); V(31);
+#undef Q
+	default:
+		break;
+	}
+}
-- 
2.39.2


