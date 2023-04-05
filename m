Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9CE6D8257
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbjDEPqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbjDEPqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:46:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E782B6587
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F61D63EDC
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6343C4339B;
        Wed,  5 Apr 2023 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709560;
        bh=LnE0GKRDFVFvMCAUuZtgI4oqPODsAv/I2wvajHnGEII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eI5NqGimGJMiuIfjuyIT/zyqTKUarUjBI0TPC/e84CraQRtUhDwb57OPRE3azBRZa
         BhBPIQMsDFwW4qRoEhenwkcPz/Y4Ncs/+3hXmorXKeH8w6amkx5vCRL0W5+dAgxABh
         VoT3i6oR6N82wF6fU061bPhss+DmPbXMW4HJWHXOFoOCbnbvyF3NlZeeDY/o6s7+At
         IrFtbk5uFAd3RC56mlP+JBSYcmCs+QrNOH6FFMoYdDRkJl+Z7QrdmYJFMz7c3fWhS3
         B9NeHqkibMfaFu5AZuAqN6DHYufMKECw3bJtovNqXyIsHN5tiQetvbCoOiYgv6MhIK
         AZINPIyL3qnhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5Fv-0062PV-1y;
        Wed, 05 Apr 2023 16:41:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 44/50] KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
Date:   Wed,  5 Apr 2023 16:40:02 +0100
Message-Id: <20230405154008.3552854-45-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

With FEAT_NV2, the EL0 timer state is entirely stored in memory,
meaning that the hypervisor can only provide a very poor emulation.

The only thing we can really do is to publish the interrupt state
in the guest view of CNT{P,V}_CTL_EL0, and defer everything else
to the next exit.

Only FEAT_ECV will allow us to fix it, at the cost of extra trapping.

Suggested-by: Chase Conklin <chase.conklin@arm.com>
Suggested-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 2a1d88efada4..98fddb4a846d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -453,6 +453,25 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 {
 	int ret;
 
+	/*
+	 * Paper over NV2 brokenness by publishing the interrupt status
+	 * bit. This still results in a poor quality of emulation (guest
+	 * writes will have no effect until the next exit).
+	 *
+	 * But hey, it's fast, right?
+	 */
+	if (vcpu_has_nv2(vcpu) && is_hyp_ctxt(vcpu) &&
+	    (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == vcpu_ptimer(vcpu))) {
+		u32 ctl = timer_get_ctl(timer_ctx);
+
+		if (new_level)
+			ctl |= ARCH_TIMER_CTRL_IT_STAT;
+		else
+			ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
+
+		timer_set_ctl(timer_ctx, ctl);
+	}
+
 	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
 				   timer_ctx->irq.level);
-- 
2.34.1

