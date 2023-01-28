Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A1267F9FE
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 18:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbjA1Rkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 12:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbjA1Rkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 12:40:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B672BED6;
        Sat, 28 Jan 2023 09:39:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE0C160C39;
        Sat, 28 Jan 2023 17:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEB3C433EF;
        Sat, 28 Jan 2023 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674927593;
        bh=6Eu0jHWRD+88REC096NM3n9cVsx1NdyvP+EwuRbaOno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJtR3mFHUnd6Nzjw7zzK2ULqOkpFgciNQYxaXhPOziEFL0Em4hdMdoKt/m9O8E8kp
         GLnLWWn5iuBPgP6ZSme34AR8+yKtPd0DD/ewhzATnaAqQR1AUQNz9DTYs9E6DR2c0Q
         qoPGG/pCgXypdQKfsuef2jiqQjujI4GHS60Boc0rjR4BWHwikX6nKNz2Irce/LkpFZ
         huhckckGlJ5OPmOVna3ihhUqOtqbl0ctb1zW33K5+68iOfvQosBVf/TjJ/N1kcBIXr
         pRLd91jagGirah6LKHAE7OFOEKc9SEjDaAzP4l+vocfaodv7SOK6A5FMVc7MxcEtT9
         y3az2hesgvK0A==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH v5 10/13] riscv: alternative: patch alternatives in the vDSO
Date:   Sun, 29 Jan 2023 01:28:53 +0800
Message-Id: <20230128172856.3814-11-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230128172856.3814-1-jszhang@kernel.org>
References: <20230128172856.3814-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it possible to use alternatives in the vDSO, so that better
implementations can be used if possible.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/vdso.h     |  4 ++++
 arch/riscv/kernel/alternative.c   | 29 +++++++++++++++++++++++++++++
 arch/riscv/kernel/vdso.c          |  5 -----
 arch/riscv/kernel/vdso/vdso.lds.S |  7 +++++++
 4 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
index a7644f46d0e5..f891478829a5 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -28,8 +28,12 @@
 #define COMPAT_VDSO_SYMBOL(base, name)						\
 	(void __user *)((unsigned long)(base) + compat__vdso_##name##_offset)
 
+extern char compat_vdso_start[], compat_vdso_end[];
+
 #endif /* CONFIG_COMPAT */
 
+extern char vdso_start[], vdso_end[];
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* CONFIG_MMU */
diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 3d4f1f32c7f6..fc341b69bf62 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -11,7 +11,9 @@
 #include <linux/cpu.h>
 #include <linux/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/module.h>
 #include <asm/sections.h>
+#include <asm/vdso.h>
 #include <asm/vendorid_list.h>
 #include <asm/sbi.h>
 #include <asm/csr.h>
@@ -160,6 +162,31 @@ static void __init_or_module _apply_alternatives(struct alt_entry *begin,
 				stage);
 }
 
+#ifdef CONFIG_MMU
+static void __init apply_vdso_alternatives(void)
+{
+	const Elf_Ehdr *hdr;
+	const Elf_Shdr *shdr;
+	const Elf_Shdr *alt;
+	struct alt_entry *begin, *end;
+
+	hdr = (Elf_Ehdr *)vdso_start;
+	shdr = (void *)hdr + hdr->e_shoff;
+	alt = find_section(hdr, shdr, ".alternative");
+	if (!alt)
+		return;
+
+	begin = (void *)hdr + alt->sh_offset,
+	end = (void *)hdr + alt->sh_offset + alt->sh_size,
+
+	_apply_alternatives((struct alt_entry *)begin,
+			    (struct alt_entry *)end,
+			    RISCV_ALTERNATIVES_BOOT);
+}
+#else
+static void __init apply_vdso_alternatives(void) { }
+#endif
+
 void __init apply_boot_alternatives(void)
 {
 	/* If called on non-boot cpu things could go wrong */
@@ -168,6 +195,8 @@ void __init apply_boot_alternatives(void)
 	_apply_alternatives((struct alt_entry *)__alt_start,
 			    (struct alt_entry *)__alt_end,
 			    RISCV_ALTERNATIVES_BOOT);
+
+	apply_vdso_alternatives();
 }
 
 /*
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index e410275918ac..4e631c098f4d 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -22,11 +22,6 @@ struct vdso_data {
 };
 #endif
 
-extern char vdso_start[], vdso_end[];
-#ifdef CONFIG_COMPAT
-extern char compat_vdso_start[], compat_vdso_end[];
-#endif
-
 enum vvar_pages {
 	VVAR_DATA_PAGE_OFFSET,
 	VVAR_TIMENS_PAGE_OFFSET,
diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index 150b1a572e61..4a0606633290 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -40,6 +40,13 @@ SECTIONS
 	. = 0x800;
 	.text		: { *(.text .text.*) }		:text
 
+	. = ALIGN(4);
+	.alternative : {
+		__alt_start = .;
+		*(.alternative)
+		__alt_end = .;
+	}
+
 	.data		: {
 		*(.got.plt) *(.got)
 		*(.data .data.* .gnu.linkonce.d.*)
-- 
2.38.1

