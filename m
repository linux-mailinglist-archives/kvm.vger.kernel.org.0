Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBFA6661A1
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbjAKRVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbjAKRUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:20:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE1C214;
        Wed, 11 Jan 2023 09:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D3A61D9E;
        Wed, 11 Jan 2023 17:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06EEC433D2;
        Wed, 11 Jan 2023 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457650;
        bh=srRoyMhEcGCbVrLyfi/YwhTea+Yq+TgoCP9PTzDvRWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8P7e3DgoRR0f4oVsM+IeXcbwq+Pqj2apye5Vlha8rab1w4XjqQnU9RjsHt9Il2HT
         1l5sHlkLlVGjvYBulYoUKJwazR6wsDqPDSwbN8J9SLgy1UYo7pVch6Rm3IuBr2itiS
         d/7dfcPo1RDjT73MkOeGwINvd3XOHxbUZAZRQQPg/en1zdBbQefOoNjGD57CBsubS9
         DGwO1N5+tWkIwRzUHgqJhTcy4Rma0Z7xjiwE7HjqDDIdVdd3K+cNwUU3xpLcqdHj6p
         8fqp1VpToe81uoDdi2ZqRZQiL91Heaqoe0l1mEMnE9JBg2E2kuDUKytBfyvdm/fHbJ
         ZhisnXHbdLewA==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 02/13] riscv: move riscv_noncoherent_supported() out of ZICBOM probe
Date:   Thu, 12 Jan 2023 01:10:16 +0800
Message-Id: <20230111171027.2392-3-jszhang@kernel.org>
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

It's a bit weird to call riscv_noncoherent_supported() each time when
insmoding a module. Move the calling out of feature patch func.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/cpufeature.c | 1 -
 arch/riscv/kernel/setup.c      | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 205bbd6b1fce..421b3d9578cc 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -297,7 +297,6 @@ static bool __init_or_module cpufeature_probe_zicbom(unsigned int stage)
 	if (!riscv_isa_extension_available(NULL, ZICBOM))
 		return false;
 
-	riscv_noncoherent_supported();
 	return true;
 }
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 86acd690d529..376d2827e736 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -300,6 +300,9 @@ void __init setup_arch(char **cmdline_p)
 	riscv_init_cbom_blocksize();
 	riscv_fill_hwcap();
 	apply_boot_alternatives();
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
+	    riscv_isa_extension_available(NULL, ZICBOM))
+		riscv_noncoherent_supported();
 }
 
 static int __init topology_init(void)
-- 
2.38.1

