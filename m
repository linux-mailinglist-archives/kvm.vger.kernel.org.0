Return-Path: <kvm+bounces-20658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4173F91BB9D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECBCA281723
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93319153519;
	Fri, 28 Jun 2024 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="mH5fZhsF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4F715253D
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567484; cv=none; b=usiVwhhKp84FduXLKKhMr2h3acQnhhxcs0E3wEo3RyRUzaSQzJIR/5a8UsYtQsHMNEuQvpxTbXbrMwNF2pqLH/GeFdNjzOR694gnmTMLOFSZ13UAsvSu/H+vApLlvF3waUbE4rB4ixd16dFknzo9EenYfY6kEX9YL2nZeMvxsZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567484; c=relaxed/simple;
	bh=RGaHQuN++47buW8KIymRZjDsqFPaO4zCn+43OWke22M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=iEjkT1ZntQsVNbymLJu+zvhwR76lrQU/q3nBBy6A9ekT/e7umBHYtbb61zaeeYoFWtIwLrBsHCWWeWagigu3dXMriOb49pAbc5YyrfAqADe4hOyrq7ICQz9dSuG9KjKnxlBs4bbF8hCF38M6ItDSLnOCzvyUMHT/yD66y2NgCv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=mH5fZhsF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f9de13d6baso2282945ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 02:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719567482; x=1720172282; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NJSNW/3/ZU4aZIGnKXL/hakX6fiWOuxkIF7mSD4tC0M=;
        b=mH5fZhsFoJnBj+jyL9+6sncn1RB4kHmZ/3IF8TqTNQaKkIG6/UaqJqDeSvOwkfVOZM
         RdaCbsQR/ra74z+GR37JDWTxxaII93r/Rg5DPrKz+lQcAUuNyR8R2slGDZBZQLaYLy8o
         sMtkVfwvYsF0uU7hOrHielWI2ltXMITCBLhoIhencTeiphdYz7SxsgfcwNk3kVbN4XMb
         xbB5LW4ZuMF51niya5YNK8UxoeHrKci56InfDHnlmiHP8AXJl/I1qmn5JJuAkWatd/jo
         rR7zUuth6NjDQagdtzPqeBFR+8JTTbA2NpeZx1X7IZCgW2PAljrQXTMFAKGxV8D9Lhea
         cj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719567482; x=1720172282;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJSNW/3/ZU4aZIGnKXL/hakX6fiWOuxkIF7mSD4tC0M=;
        b=qdxZRus3fqUiEgEQ8zGQ9cMOa/Hd1HPK7JkzfPhaMe3Qk5gfgHCyvvddw8l0eptq4L
         rEdaOJtf3eFVWjg4K/13i+T4I/Bkr4S3gZPVLREYW9vk3BKgESuwZYOeZXJI4JzCUO7u
         8ip5+f/U2Vtfi1g8Sbx60XtaVYNUV9uOgVuR8x7ZSDm+DgmQ14Gl0l+5R76xdtDI47jX
         zyCOxXsCDKhXvyY4mVIlH1izJLJDmPXoKsV8oTfeqBEgtsecL4VzvTsK7is8VXbsQEmZ
         qZYUyDTamnUyiFMJPcqO/Me0tYL+pZOfV0GgKML84dVFRRa9LKlGJGVeABu8Uer7uMmY
         7ZkA==
X-Forwarded-Encrypted: i=1; AJvYcCX8Ik+l/zZWF4E0emX1g8N3J97tfjqImuWnoaLyIvXOJAvBPLwbR5+HDGDpto/6EDtAG0/Sk5hS+ULBE7cgBo0L95ZS
X-Gm-Message-State: AOJu0YytoxCCO9hgVwoCPZt+3nCBkxr6pG0ib+NYx890j6o7o7OXqfGw
	48w4A+PeNFP/0IT+l6MnpKzjQv3rAyu+O9Z10gWuuGBYmPgdqsu3AqdtdTLaN10=
X-Google-Smtp-Source: AGHT+IGAWW4LhafPCB24jR3qgs3piip9ebKtNw6QzOeSExEsUeoGzvS4p5SzrS10lenqlKRQUIiBEA==
X-Received: by 2002:a17:902:ec86:b0:1fa:aa62:8b5c with SMTP id d9443c01a7336-1faaa628da2mr41373805ad.29.1719567482385;
        Fri, 28 Jun 2024 02:38:02 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac10c6c8dsm11087155ad.26.2024.06.28.02.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 02:38:02 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Jinyu Tang <tjytimi@163.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Evan Green <evan@rivosinc.com>,
	Xiao Wang <xiao.w.wang@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Peter Xu <peterx@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Leonardo Bras <leobras@redhat.com>
Subject: [PATCH v6 1/4] RISC-V: Add Svade and Svadu Extensions Support
Date: Fri, 28 Jun 2024 17:37:05 +0800
Message-Id: <20240628093711.11716-2-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240628093711.11716-1-yongxuan.wang@sifive.com>
References: <20240628093711.11716-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Svade and Svadu extensions represent two schemes for managing the PTE A/D
bits. When the PTE A/D bits need to be set, Svade extension intdicates
that a related page fault will be raised. In contrast, the Svadu extension
supports hardware updating of PTE A/D bits. Since the Svade extension is
mandatory and the Svadu extension is optional in RVA23 profile, by default
the M-mode firmware will enable the Svadu extension in the menvcfg CSR
when only Svadu is present in DT.

This patch detects Svade and Svadu extensions from DT and adds
arch_has_hw_pte_young() to enable optimization in MGLRU and
__wp_page_copy_user() when we have the PTE A/D bits hardware updating
support.

Co-developed-by: Jinyu Tang <tjytimi@163.com>
Signed-off-by: Jinyu Tang <tjytimi@163.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/Kconfig               |  1 +
 arch/riscv/include/asm/csr.h     |  1 +
 arch/riscv/include/asm/hwcap.h   |  2 ++
 arch/riscv/include/asm/pgtable.h | 13 ++++++++++++-
 arch/riscv/kernel/cpufeature.c   | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0525ee2d63c7..3d705e28ff85 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -36,6 +36,7 @@ config RISCV
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
 	select ARCH_HAS_SET_MEMORY if MMU
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 25966995da04..524cd4131c71 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -195,6 +195,7 @@
 /* xENVCFG flags */
 #define ENVCFG_STCE			(_AC(1, ULL) << 63)
 #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
+#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
 #define ENVCFG_CBZE			(_AC(1, UL) << 7)
 #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
 #define ENVCFG_CBIE_SHIFT		4
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index e17d0078a651..35d7aa49785d 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -81,6 +81,8 @@
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
+#define RISCV_ISA_EXT_SVADE             75
+#define RISCV_ISA_EXT_SVADU		76
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index aad8b8ca51f1..ec0cdacd7da0 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -120,6 +120,7 @@
 #include <asm/tlbflush.h>
 #include <linux/mm_types.h>
 #include <asm/compat.h>
+#include <asm/cpufeature.h>
 
 #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
 
@@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
 }
 
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
-#include <asm/cpufeature.h>
 
 static __always_inline bool has_svnapot(void)
 {
@@ -624,6 +624,17 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
+/*
+ * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
+ * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
+ * DT.
+ */
+#define arch_has_hw_pte_young arch_has_hw_pte_young
+static inline bool arch_has_hw_pte_young(void)
+{
+	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
+}
+
 /*
  * THP functions
  */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 5ef48cb20ee1..d31f79bc4daf 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
+	__RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
+	__RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
@@ -554,6 +556,21 @@ static void __init riscv_fill_hwcap_from_isa_string(unsigned long *isa2hwcap)
 			clear_bit(RISCV_ISA_EXT_v, isainfo->isa);
 		}
 
+		/*
+		 * When neither Svade nor Svadu present in DT, it is technically
+		 * unknown whether the platform uses Svade or Svadu. Supervisor may
+		 * assume Svade to be present and enabled or it can discover based
+		 * on mvendorid, marchid, and mimpid. When both Svade and Svadu present
+		 * in DT, supervisor must assume Svadu turned-off at boot time. To use
+		 * Svadu, supervisor must explicitly enable it using the SBI FWFT extension.
+		 */
+		if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
+		    !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
+			set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
+		else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
+			   test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
+			clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
+
 		/*
 		 * All "okay" hart should have same isa. Set HWCAP based on
 		 * common capabilities of every "okay" hart, in case they don't
@@ -619,6 +636,21 @@ static int __init riscv_fill_hwcap_from_ext_list(unsigned long *isa2hwcap)
 
 		of_node_put(cpu_node);
 
+		/*
+		 * When neither Svade nor Svadu present in DT, it is technically
+		 * unknown whether the platform uses Svade or Svadu. Supervisor may
+		 * assume Svade to be present and enabled or it can discover based
+		 * on mvendorid, marchid, and mimpid. When both Svade and Svadu present
+		 * in DT, supervisor must assume Svadu turned-off at boot time. To use
+		 * Svadu, supervisor must explicitly enable it using the SBI FWFT extension.
+		 */
+		if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
+		    !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
+			set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
+		else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
+			   test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
+			clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
+
 		/*
 		 * All "okay" harts should have same isa. Set HWCAP based on
 		 * common capabilities of every "okay" hart, in case they don't.
-- 
2.17.1


