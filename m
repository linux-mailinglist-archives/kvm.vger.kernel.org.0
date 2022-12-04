Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D57A641E85
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 18:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiLDR5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 12:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiLDR5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 12:57:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE405140CD;
        Sun,  4 Dec 2022 09:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BC90B80A3A;
        Sun,  4 Dec 2022 17:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88B1C433C1;
        Sun,  4 Dec 2022 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670176622;
        bh=qOV0A82uSGScKXzZE+xjnxD5QH+BqBXG94TMk6hBrFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qei5qnSYgp6jPx00+NjGmGdMA6LmMOzfkJZVAhQBA6SEjChCX79an5V3M4Qg0XoRp
         Z9xlnjgoQtJUBG1+40BwZEpfPZXNNjPwYBJ4D+O15zsvUMxu7k/Vavi0Tclyl5nwgz
         GIyj9w3Z+PYgDxyI0EdlF37fjD6YaceD01cn7psahs+S1ZfFv/BoNz0ymKyK4kw6pQ
         gc5441t5xL4/IRdmOWgBHOt3Lq6fOlujQrg7Ye4kVAvPZ0fXxb3svKCHJTjP8cop7c
         7awyHZNGbktkmIymvPtyRHLflRYdhmQQgazbjslMNcFml6ApxOsu8u352lOkVX0eVn
         Vm9y0yOx3EYeA==
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
Subject: [PATCH v2 12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
Date:   Mon,  5 Dec 2022 01:46:31 +0800
Message-Id: <20221204174632.3677-13-jszhang@kernel.org>
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

From: Andrew Jones <ajones@ventanamicro.com>

Switch has_svinval() from static branch to the new helper
riscv_has_extension_unlikely().

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
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
2.37.2

