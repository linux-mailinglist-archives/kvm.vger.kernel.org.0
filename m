Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C346661A2
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbjAKRVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbjAKRU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:20:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E4AE26;
        Wed, 11 Jan 2023 09:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469BC61D9E;
        Wed, 11 Jan 2023 17:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62672C433F1;
        Wed, 11 Jan 2023 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457653;
        bh=XfFLNWhAd8k4qxV8rXLEBaM1QQgAKaJ6LOhZRHyHg+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muCp1adDcrT3TviFaKXdg0Pic8fXJRdvzrirnhFO1zFdeYWn/dET9sP7d1RdUdFAp
         DWxW08xXfBBtPd1rb+d48sLNkQQPnmss5DhciXz35D4n8UHO1DE1JhNEGLkAKHE6Ah
         taBSW9mbljzQvG+6oD+fvAHKEKilx/yD8HaAvHvgMPbQAEbjKvGzZEEIvHXTQUX+EE
         GJNrEsSIE5bWQtkY0U7nD1VanPzihUX3CuDncZoPfDPiG1gtMhGXnBxxQlPtONq+r1
         5jLS2amJ5VeyhyBDjO5dH5DSMV6q4r8JBsdz9yhre14+cpSkEmEE43VsFskr8J5qEj
         wx7SU9f2rQEkg==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 03/13] riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
Date:   Thu, 12 Jan 2023 01:10:17 +0800
Message-Id: <20230111171027.2392-4-jszhang@kernel.org>
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

Currently riscv_cpufeature_patch_func() does nothing at the
RISCV_ALTERNATIVES_EARLY_BOOT stage. Add a check to detect whether we
are in this stage and exit early. This will allow us to use
riscv_cpufeature_patch_func() for scanning of all ISA extensions.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/riscv/kernel/cpufeature.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 421b3d9578cc..37e8c5e69754 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -328,6 +328,9 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
 	struct alt_entry *alt;
 	u32 tmp;
 
+	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
+		return;
+
 	for (alt = begin; alt < end; alt++) {
 		if (alt->vendor_id != 0)
 			continue;
-- 
2.38.1

