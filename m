Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0BF67F9FA
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 18:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbjA1Rkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 12:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbjA1Rk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 12:40:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9462A990;
        Sat, 28 Jan 2023 09:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4CF60B40;
        Sat, 28 Jan 2023 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765F2C433EF;
        Sat, 28 Jan 2023 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674927587;
        bh=xns7aXEDFfAuJusdRE+rDCll5I8rYO5SpKHZOS1DEIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUx+idFX2Ddn8y39dLpOYIR3uwySlB380yNZKygJJdk2Z7Qcef0UUqrgaWnHi7yce
         t1VuaVAJ0w67kvofeP2LysFz6WSpGaUTnN2Cq4rD40JE+brZ6VDA0yguWGCI4KGt76
         OhpNk3k0i2WyOFV2hL058F733HRfkDzyu55HL1/PvEd80e1l3VviiBZb87tjNnqMEB
         6+aZPwFBCmzS0oj4mX+Vw6r/WLZh2MVYOmI52NY4l3+GgPkeTZsT8mZKlIfJq14MgL
         T3XBH6L29NLW5AH4j5l0k78adQV0BgTMcCUA5Ms49SkKJsKOJFAs7QxN4IXLRfgnGK
         KYzLRE7PUjVjw==
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
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v5 08/13] riscv: module: Add ADD16 and SUB16 rela types
Date:   Sun, 29 Jan 2023 01:28:51 +0800
Message-Id: <20230128172856.3814-9-jszhang@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230128172856.3814-1-jszhang@kernel.org>
References: <20230128172856.3814-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <ajones@ventanamicro.com>

To prepare for 16-bit relocation types to be emitted in alternatives
add support for ADD16 and SUB16.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/module.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 76f4b9c2ec5b..7c651d55fcbd 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -268,6 +268,13 @@ static int apply_r_riscv_align_rela(struct module *me, u32 *location,
 	return -EINVAL;
 }
 
+static int apply_r_riscv_add16_rela(struct module *me, u32 *location,
+				    Elf_Addr v)
+{
+	*(u16 *)location += (u16)v;
+	return 0;
+}
+
 static int apply_r_riscv_add32_rela(struct module *me, u32 *location,
 				    Elf_Addr v)
 {
@@ -282,6 +289,13 @@ static int apply_r_riscv_add64_rela(struct module *me, u32 *location,
 	return 0;
 }
 
+static int apply_r_riscv_sub16_rela(struct module *me, u32 *location,
+				    Elf_Addr v)
+{
+	*(u16 *)location -= (u16)v;
+	return 0;
+}
+
 static int apply_r_riscv_sub32_rela(struct module *me, u32 *location,
 				    Elf_Addr v)
 {
@@ -315,8 +329,10 @@ static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
 	[R_RISCV_CALL]			= apply_r_riscv_call_rela,
 	[R_RISCV_RELAX]			= apply_r_riscv_relax_rela,
 	[R_RISCV_ALIGN]			= apply_r_riscv_align_rela,
+	[R_RISCV_ADD16]			= apply_r_riscv_add16_rela,
 	[R_RISCV_ADD32]			= apply_r_riscv_add32_rela,
 	[R_RISCV_ADD64]			= apply_r_riscv_add64_rela,
+	[R_RISCV_SUB16]			= apply_r_riscv_sub16_rela,
 	[R_RISCV_SUB32]			= apply_r_riscv_sub32_rela,
 	[R_RISCV_SUB64]			= apply_r_riscv_sub64_rela,
 };
-- 
2.38.1

