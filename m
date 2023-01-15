Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2805E66B254
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 17:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjAOQCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 11:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjAOQBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 11:01:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8F4CC01;
        Sun, 15 Jan 2023 08:00:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E75B60C8F;
        Sun, 15 Jan 2023 16:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43799C433EF;
        Sun, 15 Jan 2023 16:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673798436;
        bh=W6NwJoOq7fauyX3aaR9QaMpoEnd1BqGf85SXKRegHDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3ZMopPg6BFnnBD/5+xEcZF1xa7jtVo/hap4f7i+yMP/9rH0k4HSsU6+atkMpN8jM
         p9AqMWHjyDAcF+E0e1VRvKBbiS+5qWlAxseoKQtcV534bLw0z6jQbOQ9nYD8jv8Gk6
         9n9gdac7yh1u4Ax8W/VzyB4gB/NJvh86iib1GdaO6A8WCyVz9jj/QwvNf/Mj5wT7Rz
         VvAm/zKiCz9pefMla16trqU18F4BIyaUzVdvmK9GYfjFwcEglxKd9FO/qrWRSAahvY
         6uvfm0aTgB3SouBrkc3hEErbkom1MdotO7XqXGFEDmQ4ljNrHIuiRAzljClFH988+Y
         mIRCuO/eW4IWg==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v4 08/13] riscv: module: move find_section to module.h
Date:   Sun, 15 Jan 2023 23:49:48 +0800
Message-Id: <20230115154953.831-9-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230115154953.831-1-jszhang@kernel.org>
References: <20230115154953.831-1-jszhang@kernel.org>
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

