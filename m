Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7A6661AD
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbjAKRVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbjAKRVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:21:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3306B164B7;
        Wed, 11 Jan 2023 09:21:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9B88B81C8B;
        Wed, 11 Jan 2023 17:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29E1C433D2;
        Wed, 11 Jan 2023 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457670;
        bh=W6NwJoOq7fauyX3aaR9QaMpoEnd1BqGf85SXKRegHDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D75d/A9S64ANT2vjpZ+W99c0WJYeqx+r15lfor+IxsMitzgTgU10xNLFTWpmbRDLN
         6jW2Zr/fM9GV0/5QYkLSMvxupgVx2erpfOTVicmDa1psTbljVBz6d1ZubDKPL2L3Rp
         1YkkbIU+r1h7nk+TRby5FwlbSvTAM53aQfl4c5+TMePgndziOABuxLgyWxYe6p0NDs
         l6Qg4Ec0UoJyjAcMDJQwV4IwhBUzd2EKU6AO7tthfq0ke9ieI9+UJdAHz7SK6dXpkq
         SuYQEe190aAoWRm+S9Uc1ehFjUUZBp94uClqma9e3x5GghUChM9yD2tR/xHMoXT6rF
         +zcLfe4WuD1kw==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 08/13] riscv: module: move find_section to module.h
Date:   Thu, 12 Jan 2023 01:10:22 +0800
Message-Id: <20230111171027.2392-9-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230111171027.2392-1-jszhang@kernel.org>
References: <20230111171027.2392-1-jszhang@kernel.org>
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

Move find_section() to module.h so that the implementation can be shared
by the alternatives code. This will allow us to use alternatives in
the vdso.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/module.h | 16 ++++++++++++++++
 arch/riscv/kernel/module.c      | 15 ---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/include/asm/module.h b/arch/riscv/include/asm/module.h
index 76aa96a9fc08..0f3baaa6a9a8 100644
--- a/arch/riscv/include/asm/module.h
+++ b/arch/riscv/include/asm/module.h
@@ -5,6 +5,7 @@
 #define _ASM_RISCV_MODULE_H
 
 #include <asm-generic/module.h>
+#include <linux/elf.h>
 
 struct module;
 unsigned long module_emit_got_entry(struct module *mod, unsigned long val);
@@ -111,4 +112,19 @@ static inline struct plt_entry *get_plt_entry(unsigned long val,
 
 #endif /* CONFIG_MODULE_SECTIONS */
 
+static inline const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
+					   const Elf_Shdr *sechdrs,
+					   const char *name)
+{
+	const Elf_Shdr *s, *se;
+	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (s = sechdrs, se = sechdrs + hdr->e_shnum; s < se; s++) {
+		if (strcmp(name, secstrs + s->sh_name) == 0)
+			return s;
+	}
+
+	return NULL;
+}
+
 #endif /* _ASM_RISCV_MODULE_H */
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 91fe16bfaa07..76f4b9c2ec5b 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -429,21 +429,6 @@ void *module_alloc(unsigned long size)
 }
 #endif
 
-static const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
-				    const Elf_Shdr *sechdrs,
-				    const char *name)
-{
-	const Elf_Shdr *s, *se;
-	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (s = sechdrs, se = sechdrs + hdr->e_shnum; s < se; s++) {
-		if (strcmp(name, secstrs + s->sh_name) == 0)
-			return s;
-	}
-
-	return NULL;
-}
-
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
-- 
2.38.1

