Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC71461EDC7
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 09:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKGIzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 03:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKGIzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 03:55:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A3D2C3
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 00:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EAD160F63
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729DCC43470;
        Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811298;
        bh=K2X563RbVS1OM58x/YhfoVroBF5xoDrdh5uLOVn7/T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TR0yIl/LFFyE3wKUCV9B/fHzss/UE1NTWBE4HCRC+NWtD8N9882quA/WbgFqs7yPx
         xHS2Xup1XIiVfVCe10ATcu3PmfcS6NNMv5GlYmtcuRVkJQhbIZJel8YWt0PPCx+/pP
         q2IR8rdeQeWLC6gjeulcSc090w9pcuhisHccttXESHM+fRR82097I/TEMthmYCfAob
         HEPvpOSm7lZC5J3d0CIj3NvS+YS4IB9HDOtc6kGS2aGjp8xZaaoJFzuVsqmwzbMX6E
         13AuM8LzpfLpPsA38urM51skQKEc9Zo8rFYibXWKWu3uCcYWcWebKfWHtbD4vmCwX+
         OYScwJqBMn/Zg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1orxuC-004KxX-Fl;
        Mon, 07 Nov 2022 08:54:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v3 05/14] KVM: arm64: PMU: Narrow the overflow checking when required
Date:   Mon,  7 Nov 2022 08:54:26 +0000
Message-Id: <20221107085435.2581641-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For 64bit counters that overflow on a 32bit boundary, make
sure we only check the bottom 32bit to generate a CHAIN event.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3724acefc07b..39a04ae424d1 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -419,7 +419,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
 
-		if (reg) /* No overflow? move on */
+		/* No overflow? move on */
+		if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
 			continue;
 
 		/* Mark overflow */
-- 
2.34.1

