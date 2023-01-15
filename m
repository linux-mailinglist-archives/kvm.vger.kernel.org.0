Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246AD66B249
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 17:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjAOQA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 11:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjAOQAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 11:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A0510422;
        Sun, 15 Jan 2023 08:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEFA660C8F;
        Sun, 15 Jan 2023 16:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F7AC433EF;
        Sun, 15 Jan 2023 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673798421;
        bh=tkPW10BOmVwQ+xf9drtAfQkSUj0eKN05rtZPJxt7gQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIRTBx0mtsJkAfSfFtiNpRCg91ubwV9z5K1d0x3hbV9QVR42yCOauFr/dot6B5n/5
         F/qd1qvvkGSgWAtCcGOpt99tj1iGb/bT6q3SjktwDYGpJCzcr+4nS8qjwHcuLNS04b
         Rm82cc6JA7L+Yzah+Waxbk7Gf1g6ds3KP4Lk0sR+Z4AzN3ItIGOdkdEEY2QOCegh2s
         pY13oaVowNUcgkLyhsfxpiPrJ8wL5dFV9UPbUOxUYcRKpK7JnjCjkO45te6UGF5dbQ
         u85uKCB+2AYGqGp9jCwbYg4BZefL5PCt8d2e3slKA7+qCKpcCaqn6ty+nC1ewAGW7N
         fqfprqKQPeyxQ==
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
Subject: [PATCH v4 03/13] riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
Date:   Sun, 15 Jan 2023 23:49:43 +0800
Message-Id: <20230115154953.831-4-jszhang@kernel.org>
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

Currently riscv_cpufeature_patch_func() does nothing at the
RISCV_ALTERNATIVES_EARLY_BOOT stage. Add a check to detect whether we
are in this stage and exit early. This will allow us to use
riscv_cpufeature_patch_func() for scanning of all ISA extensions.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
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

