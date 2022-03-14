Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B3B4D89FD
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 17:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243337AbiCNQmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 12:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242178AbiCNQmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 12:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A1143ACF
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA619B80E7F
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 16:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80008C340EE;
        Mon, 14 Mar 2022 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647276056;
        bh=uxi3l7XD1dsCHWv/V+37GxYxDWy+/GagQ9LpcOEAld8=;
        h=From:To:Cc:Subject:Date:From;
        b=b3vju7KpuxWzL0Th0rFVIMLGLVXfrMn1gh6R1Pj0ixRO1tGY+nPicps9FSyfvANQv
         16mvkgpfof8s5XJEjSpnkhr/xnHeP5yvKqFUpQUAaGXUG8jWNoUlmXhjbxO6b+phFo
         n7bQvKCwaYNyfX1otXWgwbQCkpUK9cB8qYr5HSJT5357Z7w/obIrvYhSx7EYFvgFZ2
         Ox4WCruGxd97TldBZ333a5tSlPKcngAO5TgSuTajGlPMpYyjOWeFNPKC8KFbcjiB76
         gLutIMup/bRuovq+HgsrOAyycIFC3sT93I5CR1e4dHqz6wNT7lAsvbSCsgp9Muo8Ax
         jT6fpX78oUWMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nTnkb-00EPS0-6D; Mon, 14 Mar 2022 16:40:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 0/4] KVM: arm64: vgic-v3: MMIO-based LPI invalidation and co
Date:   Mon, 14 Mar 2022 16:40:40 +0000
Message-Id: <20220314164044.772709-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since revision IHI0069G of the GICv3 spec, an implementation is
allowed to implement MMIO-based LPI invalidation, without having to
support RVPEI (which is essentially a GICv4.1 feature).

This has the potential to make workloads using heavy LPI invalidation
fare a bit better, as they don't need to lock the access to the
command queue.

Similarly, an implementation can now expose that it allows LPIs to be
turned off, something that we always supported.

This series implements both these features, exposing the new
GICR_{INVLPIR,INVALLR,SYNCR} registers, transitions of the
GICR_CTLR.RWP bit on LPI disabling, and finally exposes these to
userspace and the guest with a new GICD_IIDR revision (and the ability
to save/restore it).

This series has been extremely useful to debug related GIC features,
and will be complemented by a few GIC patches.

Patches on top of 5.17-rc3.

	M.

Marc Zyngier (4):
  irqchip/gic-v3: Exposes bit values for GICR_CTLR.{IR,CES}
  KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation
  KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
  KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR,CES} as a new GICD_IIDR
    revision

 arch/arm64/kvm/vgic/vgic-init.c    |   7 +-
 arch/arm64/kvm/vgic/vgic-its.c     |  64 ++++++++++------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  18 ++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 119 ++++++++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.h         |   5 ++
 include/kvm/arm_vgic.h             |   8 +-
 include/linux/irqchip/arm-gic-v3.h |   2 +
 7 files changed, 184 insertions(+), 39 deletions(-)

-- 
2.34.1

