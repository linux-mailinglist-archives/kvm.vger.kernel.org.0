Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2639A6D0D38
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjC3R4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjC3R4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77341E3A4
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CB5B6212D
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC4EC433EF;
        Thu, 30 Mar 2023 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198972;
        bh=QRyxZd3kuRZn9Zwyzbsn+hIyGisXVKNfe1Ejb0E1Q5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPNdiUT2gNYX7tU6dbQrwOzS2K890oGzgYwZhJoN0lANhvWEJ/6/XsA463mPapOE/
         nwGkrj6uEcuTpR6n0FqP1U6KRfOZB7QhQv7K4fiut/z0BffyeNMuw/xT5T+HnqprLT
         T4xY8yZyHXrbiAABitArfx7NCJEmLmNIt0f6Zx8fn+pXqBWbe9D3f619zfBrPyeqvY
         vLtSqTWTYz8ykdps+gEyT7Fo8a/lQE7P9M13AtkJD/sOEkK2NPyKT62fDSqfW7jOWf
         MTickDGtkRvdkaeiUor10XHwUVcAC4vjphKrMlfDKWcWUid+5k9aOLZG7+KonRFrx+
         jBMw19oWrZ98A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1phwNa-004Rpa-Rt;
        Thu, 30 Mar 2023 18:48:06 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v4 12/20] KVM: arm64: Elide kern_hyp_va() in VHE-specific parts of the hypervisor
Date:   Thu, 30 Mar 2023 18:47:52 +0100
Message-Id: <20230330174800.2677007-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330174800.2677007-1-maz@kernel.org>
References: <20230330174800.2677007-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For VHE-specific hypervisor code, kern_hyp_va() is a NOP.

Actually, it is a whole range of NOPs. It'd be much better if
this code simply didn't exist. Let's just do that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 083cc47dca08..27e63c111f78 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -63,6 +63,7 @@
  * specific registers encoded in the instructions).
  */
 .macro kern_hyp_va	reg
+#ifndef __KVM_VHE_HYPERVISOR__
 alternative_cb ARM64_ALWAYS_SYSTEM, kvm_update_va_mask
 	and     \reg, \reg, #1		/* mask with va_mask */
 	ror	\reg, \reg, #1		/* rotate to the first tag bit */
@@ -70,6 +71,7 @@ alternative_cb ARM64_ALWAYS_SYSTEM, kvm_update_va_mask
 	add	\reg, \reg, #0, lsl 12	/* insert the top 12 bits of the tag */
 	ror	\reg, \reg, #63		/* rotate back */
 alternative_cb_end
+#endif
 .endm
 
 /*
@@ -127,6 +129,7 @@ void kvm_apply_hyp_relocations(void);
 
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
+#ifndef __KVM_VHE_HYPERVISOR__
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
 				    "ror %0, %0, #1\n"
 				    "add %0, %0, #0\n"
@@ -135,6 +138,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 				    ARM64_ALWAYS_SYSTEM,
 				    kvm_update_va_mask)
 		     : "+r" (v));
+#endif
 	return v;
 }
 
-- 
2.34.1

