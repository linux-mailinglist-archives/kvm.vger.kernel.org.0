Return-Path: <kvm+bounces-18110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADFD8CE43D
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 12:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 123282820A8
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2ED85926;
	Fri, 24 May 2024 10:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="lMyjVast"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFC439ADD
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 10:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546804; cv=none; b=iEPfyyTD7FsheJwb1iJtf34QBdApm08RHPsll6huzpo1Kud7vZqaC9D1E62dIgaPPmoRDVPentdegjEC0rwjFbMWC60kpFenrbUr9AoTsFJ7c1waDJBKt1D7bTHudJVPQ5slPMEyQ6gmyrRJc+PgUL+401JcH8JDw0HIyYrcheg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546804; c=relaxed/simple;
	bh=XpfArSK4JOfwihieXqJhzCafcap7mnaqPeGAkpz9WIU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=uYmeVuTM3uEJprocY9kYWD1ODo6cueKCQIR02IbJqZdnEIJTiMJbo3jgJ/nivvs18xksskyjijPI5ly4ELpzL/mNuQvTRyU/EHMFbYL7zwLhXJZjSIqK270iD2eb/rBnc/TP5da0x1hm/Mxtpm94I0j2VDA/CL8SolSOBXkbzcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=lMyjVast; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f082d92864so129932145ad.1
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 03:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716546802; x=1717151602; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MoFwl5jgI9P4wERx21aewJa37413Jz2hjVnsLA6GlCk=;
        b=lMyjVastwK/kq/svfjDLdhnnQKUKLuLAPnrHXDit/LKhjJDlcqh+J6t0gMC3jxPeG9
         ZlkvgUrOBSyr2EvJufZNndutP1GHwOjyu7dqhpmmaY+bI/I+mEa2YI/ZZm5PPKe+uMxp
         b0eeCZMzc3usOWCqRTDn7Fe79TCV+HiRvHJyb0Zctu+fZPcW0Ky40qlPYaz+i4+tSv1P
         OOwicXPLc8mRbTuXU8HSImHSt9u5t0kGI6txguy53lxKnxFsXxqhda0yqPsZXNfX98D/
         UxWoca0gJHxs0lq8MBhInh8m33BYcilSFNiZg386u7GZxNOA8LvvHG4HaFBDbzeM0gFe
         MnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716546802; x=1717151602;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MoFwl5jgI9P4wERx21aewJa37413Jz2hjVnsLA6GlCk=;
        b=gzp2MzuAqVEoRjdlPDPrPnNaGK4o1+eQzbsxSMH5O/PIYIJ6qTC2MxEt3R1+J7/7ii
         Vf63J5PyKorbJsIgRIOXUJVc1hi/MuYNTLIXRROb1ZcdFYJNGToNVYgvLz8VkRhaXLKs
         5ZEby0u9BPhMFHGSd+oUhV+H8YOSaX0UdurqkNy5APUYmF0A+2nD9CNftGlmnHvM6mWK
         thsDdfC5uATBT5V3PxdFNCBNuWnAl9UWWH/HZInMhgs/BMbasMn6mwYIbw/yvsAsDD+B
         tyXaiBE7KBDY8GiPeIgQbJLvAPDF6no4X0LZBvOgdKkbLvK4thS1q3vb7oCHPw+7ff9s
         RNCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmv7HX4DO3MyOf1nGYGq6zeAkq8nL2UGzNlEZ+Ojio7o7T8wy8uBNL7XmrUuBEVr2Xyy6NmOqqAVMCiJfpn4miTxEs
X-Gm-Message-State: AOJu0YwkaSuotmd3IfUFStbu3Fwi1TFj7R7HSITxVlraESOnxmCMCmv2
	XecSADGrIhwhojNkcBeJu8sHpEVLS9BZX/8Jq0yQpf1MymyEonK9Un0um3HC9yk=
X-Google-Smtp-Source: AGHT+IGZkHk0hDAkw/PomhjO7YSvVfqM6r0xCi5DIf8SQK5AaolNvn3ev2WmhcaqHjcHFZYozsTycQ==
X-Received: by 2002:a17:902:ce87:b0:1f3:91c:740e with SMTP id d9443c01a7336-1f44883ba5cmr21287595ad.40.1716546802214;
        Fri, 24 May 2024 03:33:22 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c756996sm10936625ad.8.2024.05.24.03.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 03:33:21 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	cleger@rivosinc.com,
	alex@ghiti.fr,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Jinyu Tang <tjytimi@163.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Evan Green <evan@rivosinc.com>,
	Xiao Wang <xiao.w.wang@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Leonardo Bras <leobras@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension Support
Date: Fri, 24 May 2024 18:33:01 +0800
Message-Id: <20240524103307.2684-2-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240524103307.2684-1-yongxuan.wang@sifive.com>
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Svadu is a RISC-V extension for hardware updating of PTE A/D bits.

In this patch we detect Svadu extension support from DTB and enable it
with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enable
optimization in MGLRU and __wp_page_copy_user() if Svadu extension is
available.

Co-developed-by: Jinyu Tang <tjytimi@163.com>
Signed-off-by: Jinyu Tang <tjytimi@163.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/Kconfig               |  1 +
 arch/riscv/include/asm/csr.h     |  1 +
 arch/riscv/include/asm/hwcap.h   |  1 +
 arch/riscv/include/asm/pgtable.h |  8 +++++++-
 arch/riscv/kernel/cpufeature.c   | 11 +++++++++++
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index be09c8836d56..30fa558ee284 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -34,6 +34,7 @@ config RISCV
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
 	select ARCH_HAS_SET_MEMORY if MMU
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 2468c55933cd..2ac270ad4acd 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -194,6 +194,7 @@
 /* xENVCFG flags */
 #define ENVCFG_STCE			(_AC(1, ULL) << 63)
 #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
+#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
 #define ENVCFG_CBZE			(_AC(1, UL) << 7)
 #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
 #define ENVCFG_CBIE_SHIFT		4
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index e17d0078a651..8d539e3f4e11 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -81,6 +81,7 @@
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
+#define RISCV_ISA_EXT_SVADU		75
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 9f8ea0e33eb1..1f1b326ccf63 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -117,6 +117,7 @@
 #include <asm/tlbflush.h>
 #include <linux/mm_types.h>
 #include <asm/compat.h>
+#include <asm/cpufeature.h>
 
 #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
 
@@ -285,7 +286,6 @@ static inline pte_t pud_pte(pud_t pud)
 }
 
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
-#include <asm/cpufeature.h>
 
 static __always_inline bool has_svnapot(void)
 {
@@ -621,6 +621,12 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
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
index 3ed2359eae35..b023908c5932 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -93,6 +93,16 @@ static bool riscv_isa_extension_check(int id)
 			return false;
 		}
 		return true;
+	case RISCV_ISA_EXT_SVADU:
+		if (sbi_probe_extension(SBI_EXT_FWFT) > 0) {
+			struct sbiret ret;
+
+			ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, SBI_FWFT_PTE_AD_HW_UPDATING,
+					1, 0, 0, 0, 0);
+
+			return ret.error == SBI_SUCCESS;
+		}
+		return false;
 	case RISCV_ISA_EXT_INVALID:
 		return false;
 	}
@@ -301,6 +311,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
+	__RISCV_ISA_EXT_SUPERSET(svadu, RISCV_ISA_EXT_SVADU, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
-- 
2.17.1


