Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6330F641E73
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiLDR5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiLDR4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:56:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC26F140CD;
        Sun,  4 Dec 2022 09:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6760AB80B8A;
        Sun,  4 Dec 2022 17:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79EAC43470;
        Sun,  4 Dec 2022 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176608;
        bh=uEKJhhgHCKJ7NSPCvUP5nG/FZvTkFiItAP+4wfYfYcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJOZO3NO1uDmT5GdJSBeotpSi20fraJXpovQHlLsu8QZF2o0SKZWO+W+1BMYSn+2j
         uvAeVbl1wU75EIAvTsQF4TgXmLdgz0g0lCEiHvHDy6TiP5h/dzH3Y7tm5ttS7J0IR8
         PUXlQLni9pnrW60WMi94AcU0K+vzwh6/ogAV6VaKqMNCGrc2orB589dNlmJjFDnC6p
         BDGn1JVlym5H0LSoSLfI59CAxaGP8q47kWLKdgMmXAcEI293b2F3bCK75nk9JeTtPg
         DNOU4fBixtz5OKa6xqoWSErEm6WTTn2LQSABqeb8BG36qwmwcbakPHpSzCaf7unDsv
         jpOnfDNNxO/iw==
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
Subject: [PATCH v2 07/13] riscv: fpu: switch has_fpu() to riscv_has_extension_likely()
Date:   Mon,  5 Dec 2022 01:46:26 +0800
Message-Id: <20221204174632.3677-8-jszhang@kernel.org>
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
2.37.2

