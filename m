Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B68641E62
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiLDR4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiLDR4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:56:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFA3140D0;
        Sun,  4 Dec 2022 09:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13ECB80886;
        Sun,  4 Dec 2022 17:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AE3C433C1;
        Sun,  4 Dec 2022 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176594;
        bh=fe+rWTyCxIwY8YD8KSMdWS0pSxqRhYgvbXdkNjgs9OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qlkv4uXf3AD/XR9sC10WHAIjCMtDerWOO6CkKtbUWHyNS4ujHHfTJrXzdCGqnEoP7
         22hCY4ESqYcZvC3NRNNGz+NfuKXs0a2C9t0v2U5cZ1TlQ3V8kWrdjDvBd85HqzYSlz
         T3XYOuoDkl0XfFcicx+JBJy/aQg31bH9lbPmxlNApP+v1HuDafLEcr9aV71NKCdaj+
         AzELuwk7YPPY7XZ/VoYUq+0soK3cTAGA/oZH2ZuySnBPENe2w1HUlsqtqw3vE/xeNc
         6nx2wktQUufPGMOLw81Fw3zeqAW3E2TG7D43NFk9H6Vwa2ajACgm+qcc17xeVtL3K5
         112P9BeASq84g==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v2 02/13] riscv: move riscv_noncoherent_supported() out of ZICBOM probe
Date:   Mon,  5 Dec 2022 01:46:21 +0800
Message-Id: <20221204174632.3677-3-jszhang@kernel.org>
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

It's a bit weird to call riscv_noncoherent_supported() each time when
insmoding a module. Move the calling out of feature patch func.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/cpufeature.c | 1 -
 arch/riscv/kernel/setup.c      | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index c743f0adc794..364d1fe86bea 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -274,7 +274,6 @@ static bool __init_or_module cpufeature_probe_zicbom(unsigned int stage)
 	if (!riscv_isa_extension_available(NULL, ZICBOM))
 		return false;
 
-	riscv_noncoherent_supported();
 	return true;
 }
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 86acd690d529..6eea40bf8c6b 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -300,6 +300,8 @@ void __init setup_arch(char **cmdline_p)
 	riscv_init_cbom_blocksize();
 	riscv_fill_hwcap();
 	apply_boot_alternatives();
+	if (riscv_isa_extension_available(NULL, ZICBOM))
+		riscv_noncoherent_supported();
 }
 
 static int __init topology_init(void)
-- 
2.37.2

