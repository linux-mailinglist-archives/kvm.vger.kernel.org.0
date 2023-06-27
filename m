Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF87A73FD57
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 16:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjF0OGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 10:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjF0OGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 10:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4779211B;
        Tue, 27 Jun 2023 07:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7BF611AA;
        Tue, 27 Jun 2023 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6ECC433C0;
        Tue, 27 Jun 2023 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687874772;
        bh=gdCzgZa5ZO1KjKZiWh8H9VlbmneP5crniKuqd9ftXpA=;
        h=From:To:Cc:Subject:Date:From;
        b=JqLTHeB9AMvnOWFw5aeGpHjDGpwjIdN0SoZoj1GjiIQt4WcSML2TQuki3WZ84FCuv
         GoPtFRULJguonwIqOZ5TQL7kl8EvNrSAaqUouy64vBc/lYwBV2tZJv/JN3lpwe/71s
         8azeJiy+YP0VG4ukxI4RcIS4/8aEWPxVu2UknWjEQ8GGzIafxMvFMPh5vgyJAOGkcs
         PB6YakR+Nu+a8mTMKdGOL6APGVKbgMXtG6FGIewhGtoMQsj+PLoqQNDamTdreGlWNE
         HPQiGtpWKFSp6G49Yz9LM9wcn5REaOF1LtQJtD2nj5q3YGCeG8dsD3fvygj5Iak4H0
         mJ/b+/zCgBttA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qE9Kc-008oTQ-Ju;
        Tue, 27 Jun 2023 15:06:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
Date:   Tue, 27 Jun 2023 15:05:57 +0100
Message-Id: <20230627140557.544885-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
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

It recently appeared that, whien running VHE, there is a notable
difference between using CNTKCTL_EL1 and CNTHCTL_EL2, despite what
the architecture documents:

- When accessed from EL2, bits [19:18] and [16:10] same bits have
  the same assignment as CNTHCTL_EL2
- When accessed from EL1, bits [19:18] and [16:10] are RES0

It is all OK, until you factor in NV, where the EL2 guest runs at EL1.
In this configuration, CNTKCTL_EL11 doesn't trap, nor ends up in
the VNCR page. This means that any write from the guest affecting
CNTHCTL_EL2 using CNTKCTL_EL1 ends up losing some state. Not good.

The fix it obvious: don't use CNTKCTL_EL1 if you want to change bits
that are not part of the EL1 definition of CNTKCTL_EL1, and use
CNTHCTL_EL2 instead. This doesn't change anything for a bare-metal OS,
and fixes it when running under NV. The NV hypervisor will itself
have to work harder to merge the two accessors.

Note that there is a pending update to the architecture to address
this issue by making the affected bits UNKNOWN when CNTKCTL_EL1 is
user from EL2 with VHE enabled.

Fixes: c605ee245097 ("KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # v6.4
---
 arch/arm64/kvm/arch_timer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 0696732fa38c..6dcdae4d38cb 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -827,8 +827,8 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
 	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
 
-	/* This only happens on VHE, so use the CNTKCTL_EL1 accessor */
-	sysreg_clear_set(cntkctl_el1, clr, set);
+	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
+	sysreg_clear_set(cnthctl_el2, clr, set);
 }
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
@@ -1563,7 +1563,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 void kvm_timer_init_vhe(void)
 {
 	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
-		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
+		sysreg_clear_set(cnthctl_el2, 0, CNTHCTL_ECV);
 }
 
 int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-- 
2.34.1

