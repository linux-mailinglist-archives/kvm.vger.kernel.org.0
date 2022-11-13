Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D482A6270F8
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbiKMQqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiKMQqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:46:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C0EDEF1
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F297B60B7F
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66182C433C1;
        Sun, 13 Nov 2022 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668357990;
        bh=b34dd05lgwkbNWXSAPZPFmJHh3ULCqHSxbRsRxcEyjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOehkPP/TP616PU9K1JF5yFdC0F5c7dDNFttoIZOnwOKfL5bnHI3f3G/054N2I4j6
         epm/HX3GLfbjBftpBh/fIEBdMjgp1q0g3H53d3YwHjt0QoP8g71T4iGhb7CZPuDzvh
         Z/2WyViWx/TD7NGQkGiLWYeNrRUQE1MQQZnZqcIFXbjSnW4vbcdzI73L8fI93pH+2g
         PZ1wINDRfnMH5Py5pFk7izLXKrOEO7co22BkXLKLrqU2VyrecikYOeIXEnu/wEHP5K
         h5o4ZcdNrGhwtlowVDRx3PLMMXQC1AxrrB0GMrU8i0xFYla9e2ZSHBE8DF1/rsz8Oa
         p1Lbj8wRTKkcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0Q-005oYZ-Tt;
        Sun, 13 Nov 2022 16:38:51 +0000
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
Subject: [PATCH v4 15/16] KVM: arm64: PMU: Simplify vcpu computation on perf overflow notification
Date:   Sun, 13 Nov 2022 16:38:31 +0000
Message-Id: <20221113163832.3154370-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
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

The way we compute the target vcpu on getting an overflow is
a bit odd, as we use the PMC array as an anchor for kvm_pmc_to_vcpu,
while we could directly compute the correct address.

Get rid of the intermediate step and directly compute the target
vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b7a5f75d008d..e3d5fe260dcc 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -405,11 +405,8 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
 static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_pmu *pmu;
-
-	pmu = container_of(work, struct kvm_pmu, overflow_work);
-	vcpu = kvm_pmc_to_vcpu(pmu->pmc);
 
+	vcpu = container_of(work, struct kvm_vcpu, arch.pmu.overflow_work);
 	kvm_vcpu_kick(vcpu);
 }
 
-- 
2.34.1

