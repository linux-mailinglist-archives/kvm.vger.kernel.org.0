Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA814AD924
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353688AbiBHNQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357847AbiBHMhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:37:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A0FC03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:37:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ADF7B81AEF
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EC3C004E1;
        Tue,  8 Feb 2022 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644323868;
        bh=Vdzv6/VbCUfmB9ltCSpCmrJCAknBa748GpfXsqv7SuY=;
        h=From:To:Cc:Subject:Date:From;
        b=qmuMJ8idnULy1JeLdMTOgVlGQSy4iea+9UUHi3D6DoiEFoAwTCsKJarkGnh9C8wo7
         gcj0hZDWqxCqcCNqL7X0jPIs2CSHx70b28Pl7WjXfQPXKpx3QYWWHDFRGZjv/WnhXn
         yb05l0jB8K01IncTERH7mbpugILidG2rkvR+MtOBfw5dloXjf/j7DT1qIRmGvdE6w3
         t7xVPTQRwgb/w+1CbKnl6OW9W3MowN94jibzF+H6rt8y1vcpLZ9RFA0gsLc4KGOPt0
         pgKp9oKyidHeDeU5Jt98QpteNPQu+R9TsYFC2x83S2aablvzLPxIk09kYWByQWrzLU
         t9b1sUe5dcFYw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nHPkg-006FuE-2W; Tue, 08 Feb 2022 12:37:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Ricardo Koller <ricarkol@google.com>
Subject: [PATCH] KVM: arm64: vgic: Read HW interrupt pending state from the HW
Date:   Tue,  8 Feb 2022 12:37:26 +0000
Message-Id: <20220208123726.3604198-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, ricarkol@google.com
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

It appears that a read access to GIC[DR]_I[CS]PENDRn doesn't always
result in the pending interrupts being accurately reported if they are
mapped to a HW interrupt. This is particularily visible when acking
the timer interrupt and reading the GICR_ISPENDR1 register immediately
after, for example (the interrupt appears as not-pending while it really
is...).

This is because a HW interrupt has its 'active and pending state' kept
in the *physical* distributor, and not in the virtual one, as mandated
by the spec (this is what allows the direct deactivation). The virtual
distributor only caries the pending and active *states* (note the
plural, as these are two independent and non-overlapping states).

Fix it by reading the HW state back, either from the timer itself or
from the distributor if necessary.

Reported-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 7068da080799..49837d3a3ef5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -248,6 +248,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+		} else if (vgic_irq_is_mapped_level(irq)) {
+			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
 		}
-- 
2.34.1

