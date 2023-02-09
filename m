Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3502691008
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBISLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 13:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjBISLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 13:11:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE95F68AE4
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 10:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 835F3B8228C
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 18:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A597C433EF;
        Thu,  9 Feb 2023 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675966253;
        bh=qX6kFn4drXf+CIvAA1Y06km8c3x99tuygfzIwXioExs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg3gysq8fY6GKtY44yFb6b5BPzlSQsTsXkbcEZIF7zXp+s6XtUlfWVXC7D6mo2LFz
         cuRKzOPK/RjAluqAygTsyyLhzIpdyOSlj2Far3kNhBrhcn2ti+vEnuydD5hAh5h6ro
         Fuv0I7ZA4qDej0dA19gZe+dH8iS+hDPBqhk9YRpDHM20GDYg/lAoiC7cWZv0V6viZ8
         C+N2HG0nlM4kY/sluxV1VQd6XZb4KD6+FxIqS+vSNHvoK4HSByFfBUCsn2nDct4T7e
         XkFz5puJcRLEwiNm1UGrZh3MJ98B2rS9XomQ4Jyhifa8A9be03g4fEmFM5v4iBnBTc
         En4n7SocGchhQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pQBC6-0093r7-BX;
        Thu, 09 Feb 2023 17:58:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 18/18] KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2 changes
Date:   Thu,  9 Feb 2023 17:58:20 +0000
Message-Id: <20230209175820.1939006-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@linaro.org>

So far we were flushing almost the entire universe whenever a VM would
load/unload the SCTLR_EL1 and the two versions of that register had
different MMU enabled settings.  This turned out to be so slow that it
prevented forward progress for a nested VM, because a scheduler timer
tick interrupt would always be pending when we reached the nested VM.

To avoid this problem, we consider the SCTLR_EL2 when evaluating if
caches are on or off when entering virtual EL2 (because this is the
value that we end up shadowing onto the hardware EL1 register).

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4a7e6369499..2890d57bec30 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -115,6 +115,7 @@ alternative_cb_end
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
@@ -192,7 +193,15 @@ struct kvm;
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+	u64 cache_bits = SCTLR_ELx_M | SCTLR_ELx_C;
+	int reg;
+
+	if (vcpu_is_el2(vcpu))
+		reg = SCTLR_EL2;
+	else
+		reg = SCTLR_EL1;
+
+	return (vcpu_read_sys_reg(vcpu, reg) & cache_bits) == cache_bits;
 }
 
 static inline void __clean_dcache_guest_page(void *va, size_t size)
-- 
2.34.1

