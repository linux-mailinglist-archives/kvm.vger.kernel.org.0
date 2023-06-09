Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A7472A08A
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjFIQr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjFIQr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151033C16
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27BEB6164C
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED1C4339C;
        Fri,  9 Jun 2023 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686329231;
        bh=XkWyzW+sSMEWSg65caOPf/zhuNHxIwdjYYA7HpLQriM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wi0yJCh1JNMzkI2EZVWEC7w6mOyvB8mtUmtueCaBbF1qwmoK2hgxNQRobsuhE2Ppn
         rgCwB04pzTmN/Ip0Gv+K9CABH0Yb02qikj97+sPplninGfN+vGKoFMTCXhZTQdqcQx
         chTtaTR1tnTjqYlfP0ElCpN/gc69KbKT5lkViXuzEXxg1p5VWefOggD0iggNoJAw/a
         J20mMIfGANa7gM6pHBVbSwzuRl9dKZPknNBiHXP2HxlLJZqC3/71buDXMY5xe2aer8
         ExDW/g342lUHONopvc9P8k06/gpVMQJPG15npLU4wqCnO6wPHwBSaWVeOtAyaK9nOD
         cECaTrbud+SMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esM-0048L7-Ov;
        Fri, 09 Jun 2023 17:22:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 11/17] KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
Date:   Fri,  9 Jun 2023 17:21:54 +0100
Message-Id: <20230609162200.2024064-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using hVHE, we end-up with two TTBRs at EL2. That's great,
but we're not quite ready for this just yet.

Disable TTBR1_EL2 by setting TCR_EL2.EPD1 so that we only
translate via TTBR0_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c12276dd2cf4..35b32cb6faa5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1666,7 +1666,13 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 
 	params->mair_el2 = read_sysreg(mair_el1);
 
-	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
+	tcr = read_sysreg(tcr_el1);
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		tcr |= TCR_EPD1_MASK;
+	} else {
+		tcr &= TCR_EL2_MASK;
+		tcr |= TCR_EL2_RES1;
+	}
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
 	params->tcr_el2 = tcr;
-- 
2.34.1

