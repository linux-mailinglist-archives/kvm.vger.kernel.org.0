Return-Path: <kvm+bounces-21486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7709D92F712
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0161C221EF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CF6143727;
	Fri, 12 Jul 2024 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="SmeADkoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3559D13DDB9
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773552; cv=none; b=lYPQF8ptw9qa4n904rZHrkwJspnAz1qPX+DteLPuuy/AFh9J3WA7Vq9SSgcEnNqDnJAAk8/TRRDFHCdSxgZijLiWFI+fkw8OifmfGd76/N4hwOSrKZEqUQ9NN90wg2D+X74nhtqrvOT6j+0ApsWMfLLNOi2bIj/wS5tcv3jJEFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773552; c=relaxed/simple;
	bh=jgJLTxGXPrChjpov/CnTXn4AWGI9w4XWVBN+DHBh0xg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Zaetd+YH2T/jZeVxsragVHbvtjBGYI2jjiua3tSFQatU/QjQbB99YHl/jHkwHra4kU40KiC9bPt8OVasizQXM8i7n5vxoIapd80GGy3u5m73KWiFR9fCaiIxsuP5L8DnP+u+bddqkAhgf6vivtC3edBjL5ujyPaC+7cwdUQInpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=SmeADkoO; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c9cc681ee4so898361b6e.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 01:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1720773548; x=1721378348; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NoYP43ZgdyLcgRKntnfdP6muemOL2yUyMByTZlsLQGs=;
        b=SmeADkoOU9OiwI8eUymbnmKuXh8a3X1ksrsKcLF0rx70W80TR2pf19b4PR3NYqopLv
         gSjgIt71xZ3xmWCZcMaXFaTrpuyySXW5EgcUcrjFzc6UgbNrVxntwGJi/h0WP2cKF10O
         LAN8VM3kpu/uHXMmHcNjKdeEnqv0TtyXk/KjatokzCSVkjeFAK4jAXnynwHacQrZBUtU
         1vl7k0hrVl4GtnYZokRLvZs/DICr0FaNkikXrXEeF4cNtB51dsa2Dm6RVWu9z95s8fkx
         pE0bu9iV5hAo0oH4PF565xp6az/oiSAtTqG95n+DvezkAaaprmCqTYFbDEyoWP/+dlCg
         n4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720773548; x=1721378348;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NoYP43ZgdyLcgRKntnfdP6muemOL2yUyMByTZlsLQGs=;
        b=gfhRIOTyJWBBlsmBnGvjEGHGp9VVPU0tfHZC3fDs4C58KWU9uph6f0v38VqdUBF1Q/
         U4pXsUyhXbrPMCwSNyiMw5+vpiT1T+65wvzD1bp6y/7pKwhjMMXmqyM/MpKgMlFt/I0V
         5ED8DDrI1HSBicQiFVOjJtZEEJmB6OWnFKiG5yTVja17Ni8Vor7x+QTdCmuwxTqiwn20
         T4wh9p/fLk3Kj1bN/g/vjRx/aiqjo+V969pPjLejYz59V9TPBPgsR8shpSPFHaNjDBF/
         w6DhkmL6WFIJwFoO5i2VydWXws7+JKVIXYQLbEwczwVQH2/MwnJ8K199VBCIVG8BRC/l
         Qs4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUX/wp0kFImhywvCZ8ybLBIm5947JSEz3bdBHL2aPHyGJeFI+mFWVKhmQ7zetznnhIlD7QBOHwzApfQrLJascIQ3PSF
X-Gm-Message-State: AOJu0YxrgUdVYYOqBeFE25wRoYduOJhaoqZZ7Zetd8RqFQgitfyGruAJ
	SvdseHfMID7rsd+FZLisaTTfFj4xa+mWHdVhd8n2CdFI8EC71B3PNIyX/dKVG0E=
X-Google-Smtp-Source: AGHT+IFvHBbmqbAuR3HIaTkO4x6lvhZ0ISwrkTRlVQ6l2auVT/ORD0WyzAIWLSQFoMZSchMNJnl+UQ==
X-Received: by 2002:a05:6808:309b:b0:3da:ae17:50c0 with SMTP id 5614622812f47-3daae17540emr713772b6e.1.1720773548053;
        Fri, 12 Jul 2024 01:39:08 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b438c7099sm6894194b3a.84.2024.07.12.01.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 01:39:07 -0700 (PDT)
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
	Samuel Ortiz <sameo@rivosinc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Evan Green <evan@rivosinc.com>,
	Xiao Wang <xiao.w.wang@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Leonardo Bras <leobras@redhat.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH v7 1/4] RISC-V: Add Svade and Svadu Extensions Support
Date: Fri, 12 Jul 2024 16:38:45 +0800
Message-Id: <20240712083850.4242-2-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240712083850.4242-1-yongxuan.wang@sifive.com>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
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
index 5ef48cb20ee1..b2c3fe945e89 100644
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
+			 test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
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
+			 test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
+			clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
+
 		/*
 		 * All "okay" harts should have same isa. Set HWCAP based on
 		 * common capabilities of every "okay" hart, in case they don't.
-- 
2.17.1


