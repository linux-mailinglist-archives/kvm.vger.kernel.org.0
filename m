Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D34641E66
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiLDR44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiLDR4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:56:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1994D140CD;
        Sun,  4 Dec 2022 09:56:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A909660DEB;
        Sun,  4 Dec 2022 17:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC64C433D6;
        Sun,  4 Dec 2022 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176597;
        bh=3s4zw9FUbpvcvaIrDkMgw4j/arxcyKwTzaA9Yi50abg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAlh9b2i+JZ2ERHbdxOsdG4Hn4RklDiaqzlP1NAa2p1TtwTD/T3S48w+97vzyBMnC
         kLuDLORO6TwtcT/igy8awF+4+wQkbvZTgdZAdSP/rolXNn3nXaXcu7gbPJjdx80j9L
         xQICvqBMZ9As2pe/gkhltiMEox4aXp9Sjkhw/GlgqFH4Cb4InSMUMhrLRlnVfplBa6
         wXJxgLBcnJC16Azl02dsmIg/DYCrTof4qfvsbf5vsP6jSwbVm16qJyE6sgbZNMP6FZ
         9iOBDh5UxwPV1ESX+U7uw4LaMSJTB4E//x4e35tiaMUKhpc5MXwu57ly28J28J0gfK
         EzfUGwUWKbf2Q==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 03/13] riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
Date:   Mon,  5 Dec 2022 01:46:22 +0800
Message-Id: <20221204174632.3677-4-jszhang@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221204174632.3677-1-jszhang@kernel.org>
References: <20221204174632.3677-1-jszhang@kernel.org>
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

Now, the riscv_cpufeature_patch_func() do nothing in the stage of
RISCV_ALTERNATIVES_EARLY_BOOT. We can move the detection of "early
boot" stage earlier.

In following patch, we will make riscv_cpufeature_patch_func() scans
all ISA extensions.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/riscv/kernel/cpufeature.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 364d1fe86bea..a4d2af67e05c 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -305,6 +305,9 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 	struct alt_entry *alt;
 	u32 tmp;
 
+	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
+		return;
+
 	for (alt = begin; alt < end; alt++) {
 		if (alt->vendor_id != 0)
 			continue;
-- 
2.37.2

