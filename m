Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF656661AA
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 18:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbjAKRV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 12:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238284AbjAKRVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 12:21:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47D3164B7;
        Wed, 11 Jan 2023 09:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85B1AB81B79;
        Wed, 11 Jan 2023 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C764EC433F1;
        Wed, 11 Jan 2023 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457667;
        bh=ZZbNK1MSY8P4rukKkUHVGmvzf9kfXc1zq+8A+JZHFy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1gsJ0ZpyP7xSdrHXOtzajlWsoeDRdoq0kC7WCc/j084lmL33+LWIDjc8kZ+DBFAv
         7V7nETI9PWsBz6XDcxxpXogkfBxx4BXKXdSuUV8R2mGo5RzRfucP5qxNl5xl5SKDbU
         AfKARehtE7S77bev8DMfOL5Q367VEFp2vXobvBxiRTVyM+5fvgExVytYF6gVj99vFM
         wIVEcf2E7iGhjtxCfzW7Hbqvi1Aw8dKOHgz8o9H1N5X9IU+xpz2M89sxgPfAI4oCHv
         ny6h3H9ejIT1bKEDqADSEYemvJkq/HGJuVSUfTZzyPcFnfQ9U/wxXA3OYLUiv29dRM
         GfCO2qYI7uyVw==
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
Subject: [PATCH v3 07/13] riscv: fpu: switch has_fpu() to riscv_has_extension_likely()
Date:   Thu, 12 Jan 2023 01:10:21 +0800
Message-Id: <20230111171027.2392-8-jszhang@kernel.org>
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

Switch has_fpu() from statich branch to the new helper
riscv_has_extension_likely().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/riscv/include/asm/switch_to.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 11463489fec6..60f8ca01d36e 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -59,7 +59,8 @@ static inline void __switch_to_aux(struct task_struct *prev,
 
 static __always_inline bool has_fpu(void)
 {
-	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_FPU]);
+	return riscv_has_extension_likely(RISCV_ISA_EXT_f) ||
+		riscv_has_extension_likely(RISCV_ISA_EXT_d);
 }
 #else
 static __always_inline bool has_fpu(void) { return false; }
-- 
2.38.1

