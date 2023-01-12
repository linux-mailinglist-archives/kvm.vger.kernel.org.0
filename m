Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E33D667F1E
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbjALT1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240500AbjALT1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:27:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15C82F7AE
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF9262086
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624AFC433D2;
        Thu, 12 Jan 2023 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551274;
        bh=ITfwjvL0S3gE00JRlFGIpEAas7Z3sYDkpINzgiBIE1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZr8HnX9Ed/maGas1H2S/WMPVMi5UNEI3v5ulFrRpgFfFQcuOV9J+TaGd426fi/V0
         6ElahqA29pkiZwOLUIcq1LEBOkiZri4u955MA6QGWFPyo6UI5VksJg2HPLn71C3dF1
         3wNU3kx8Q96PtN51WuEE+Zc6EapgiiLxlferSr8MGzAm96/Nii4ov1KV+L2iw8GjqQ
         mO74kH/a4NBGqxj9uyfvpXh1W8hBiBJJgGmfi4TEymKrMc+wLWC1QeYZOtdeNvhcyc
         FXpdihaLCAlKe1FwnM13n4zVTuycj/TN/L3u6Xv/pRT8Jn8y61QWrgaUmId4rccEiG
         YEhlLaJgKwgZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG37T-001IWu-5a;
        Thu, 12 Jan 2023 19:20:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 62/68] KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
Date:   Thu, 12 Jan 2023 19:19:21 +0000
Message-Id: <20230112191927.1814989-63-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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
index c01277e8bd4a..71d2f1902de9 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -450,6 +450,25 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
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
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
 				   timer_ctx->irq.level);
-- 
2.34.1

