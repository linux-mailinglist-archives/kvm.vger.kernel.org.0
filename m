Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C764F91F8
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 11:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiDHJ0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 05:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiDHJ0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 05:26:31 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7127719322C;
        Fri,  8 Apr 2022 02:24:23 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1nckqq-0002JW-3F; Fri, 08 Apr 2022 11:24:20 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     anup@brainfault.org, atishp@atishpatra.org
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH] RISC-V: KVM: include missing hwcap.h into vcpu_fp
Date:   Fri,  8 Apr 2022 11:24:15 +0200
Message-Id: <20220408092415.1603661-1-heiko@sntech.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_fp uses the riscv_isa_extension mechanism which gets
defined in hwcap.h but doesn't include that head file.

While it seems to work in most cases, in certain conditions
this can lead to build failures like

../arch/riscv/kvm/vcpu_fp.c: In function ‘kvm_riscv_vcpu_fp_reset’:
../arch/riscv/kvm/vcpu_fp.c:22:13: error: implicit declaration of function ‘riscv_isa_extension_available’ [-Werror=implicit-function-declaration]
   22 |         if (riscv_isa_extension_available(&isa, f) ||
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../arch/riscv/kvm/vcpu_fp.c:22:49: error: ‘f’ undeclared (first use in this function)
   22 |         if (riscv_isa_extension_available(&isa, f) ||

Fix this by simply including the necessary header.

Fixes: 0a86512dc113 ("RISC-V: KVM: Factor-out FP virtualization into separate sources")
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/riscv/kvm/vcpu_fp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
index 4449a976e5a6..d4308c512007 100644
--- a/arch/riscv/kvm/vcpu_fp.c
+++ b/arch/riscv/kvm/vcpu_fp.c
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
+#include <asm/hwcap.h>
 
 #ifdef CONFIG_FPU
 void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
-- 
2.35.1

