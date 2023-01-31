Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6285C682937
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjAaJm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjAaJmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:42:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46804673D
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC00C6148B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D56FC433D2;
        Tue, 31 Jan 2023 09:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158134;
        bh=dcYEQCrt9haLJXBiQNsjtFOMISpjMi07IsrJjrtHAqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRgR/570L1+GLMCCW5xYqIiPLMhgaxUBzMs61uW2Q9VEANE42oSUC56MwWMNen13/
         yPmNRGNQsLtEDTbDyJs1l71s1QAURMZpRwn/x45HSwqhCOldxStQRMTBRDdpddmi9w
         SDBRrRwjnhEffYMqYUGo4PajZQnZ4oy340d/AHA9Ewq5ze1TozW4+vjwGzVHpugR4P
         ct+irbaheFNL0rRgAsMqWng/qsaraezLGWYHMFLGyNxiFsW8hXuyjCJh0/LKeDTP1o
         e+hoyD9nbbJbh5PkE7idla7HYUAzlvwsEVWCiOs3S4vRLXv+RvV3jcT0zM08emZGYi
         Ki9sYVFJtE/EA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtr-0067U2-SC;
        Tue, 31 Jan 2023 09:25:59 +0000
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
Subject: [PATCH v8 48/69] KVM: arm64: nv: Don't load the GICv4 context on entering a nested guest
Date:   Tue, 31 Jan 2023 09:24:43 +0000
Message-Id: <20230131092504.2880505-49-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
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

When entering a nested guest (vgic_state_is_nested() == true),
special care must be taken *not* to make the vPE resident, as
these are interrupts targetting the L1 guest, and not any
nested guest.

By not making the vPE resident, we guarantee that the delivery
of an vLPI will result in a doorbell, forcing an exit from the
nested guest and a switch to the L1 guest to handle the interrupt.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 911bfd80f72c..3a1ade1b592e 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -753,8 +753,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 
 	if (vgic_state_is_nested(vcpu))
 		vgic_v3_load_nested(vcpu);
-
-	WARN_ON(vgic_v4_load(vcpu));
+	else
+		WARN_ON(vgic_v4_load(vcpu));
 }
 
 void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
@@ -772,6 +772,12 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	/*
+	 * vgic_v4_put will do nothing if we were not resident. This
+	 * covers both the cases where we've blocked (we already have
+	 * done a vgic_v4_put) and when running a nested guest (the
+	 * vPE was never resident in order to generate a doorbell).
+	 */
 	WARN_ON(vgic_v4_put(vcpu, false));
 
 	vgic_v3_vmcr_sync(vcpu);
-- 
2.34.1

