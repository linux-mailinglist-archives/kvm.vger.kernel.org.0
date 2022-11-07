Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47D761EDCA
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 09:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKGIzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 03:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiKGIzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 03:55:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80525F6C
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 00:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D34DB80E70
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0108DC433D6;
        Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811298;
        bh=7DPVNhiI7e1H2rXRI4KKeHqneAlTPa1uIRZNpUo176c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XntbvzAdAajcxaf72wgefnCfBuLh11LAXu4AeSKuiiYYNpsPAnIaSGqLNiSpTH8/F
         toq1XEPrO9W+6x9YPXRB6p8stq+rzwAIQ+YpijCiyzL/fTVLU1XQ49J9zxISNeczhZ
         23gEQjLvhWI80QUERufiCbdUysDaamOYv1Ul5IZboqbc8SY4K4KVIUwOlVU/FFEKpO
         G6kNj4ACzXhpQp7qhLOfk+P0iwrtDyTXwwBFroMZrNXDa6Ue2KAwaOghd9ZzUvvErh
         ycGk/X3sxSD6nbx1ymTGnQ7MQdp0TsKk3viaDx89FYo8ux3L0oOogS2vRUAO0+RRKe
         eN78PPvzutJyg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1orxuC-004KxX-0f;
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
Subject: [PATCH v3 03/14] KVM: arm64: PMU: Always advertise the CHAIN event
Date:   Mon,  7 Nov 2022 08:54:24 +0000
Message-Id: <20221107085435.2581641-4-maz@kernel.org>
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

Even when the underlying HW doesn't offer the CHAIN event
(which happens with QEMU), we can always support it as we're
in control of the counter overflow.

Always advertise the event via PMCEID0_EL0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a38b3127f649..e63ed0c71a37 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -703,6 +703,8 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
+		/* always support CHAIN */
+		val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
 		base = 0;
 	} else {
 		val = read_sysreg(pmceid1_el0);
-- 
2.34.1

