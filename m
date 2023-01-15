Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85DF66B25E
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 17:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjAOQDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 11:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjAOQCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 11:02:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4B4113D9;
        Sun, 15 Jan 2023 08:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB75A60DB4;
        Sun, 15 Jan 2023 16:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734EEC433F2;
        Sun, 15 Jan 2023 16:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673798450;
        bh=iakCU13SXpMb3pcvjfiiLXGeB5RnCPEYfg/spzK7YxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFsX2798RH2/WfNI9HHQCYXHNW1bUf1ArkkBSr69Rr2lJJvWGOiPDtVLiO1odYcFI
         FiRlgOJJT+O3oSBPJ0I6r1UGoc11hDm4rE0KR/E09DmoKqrEr431OKEhw7gc7TdqLE
         I+8EUgZEsz+2n/Fy1K+47j4wdpGdf3R3GIGQcEBmI5mUSKnqgll3HNaoritJ2htdTs
         smqYlOT8WyotGQQDOC0I95gTulbUA63Tybo2OrIMd/dmjJdqTay9YPa5H9wwI5sTOe
         J4BBsV4XlnNSpCaPkijrjtGIrRyaXWOcNa4JZ4p8HZggjQr6u7OvDiW90QeLe2aCur
         CqHDyLBzZgEcA==
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
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH v4 12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
Date:   Sun, 15 Jan 2023 23:49:52 +0800
Message-Id: <20230115154953.831-13-jszhang@kernel.org>
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

From: Andrew Jones <ajones@ventanamicro.com>

Switch has_svinval() from static branch to the new helper
riscv_has_extension_unlikely().

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
---
 arch/riscv/kvm/tlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 309d79b3e5cd..aa3da18ad873 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -15,8 +15,7 @@
 #include <asm/hwcap.h>
 #include <asm/insn-def.h>
 
-#define has_svinval()	\
-	static_branch_unlikely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_SVINVAL])
+#define has_svinval()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVINVAL)
 
 void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
 					  gpa_t gpa, gpa_t gpsz,
-- 
2.38.1

