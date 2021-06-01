Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952C63971A4
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhFAKly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 06:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhFAKlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 06:41:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A08E613A9;
        Tue,  1 Jun 2021 10:40:12 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo1og-004nNs-9f; Tue, 01 Jun 2021 11:40:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v4 0/9] KVM: arm64: Initial host support for the Apple M1
Date:   Tue,  1 Jun 2021 11:39:56 +0100
Message-Id: <20210601104005.81332-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a new version of the series previously posted at [3], reworking
the vGIC and timer code to cope with the M1 braindead^Wamusing nature.

Hardly any change this time around, mostly rebased on top of upstream
now that the dependencies have made it in.

Tested with multiple concurrent VMs running from an initramfs.

Until someone shouts loudly now, I'll take this into 5.14 (and in
-next from tomorrow).

* From v3 [3]:
  - Rebased on 5.13-rc4 to match the kvmarm/next base
  - Moved stuff from patch #7 to its logical spot in patch #8
  - Changed the include/linux/irqchip/arm-vgic-info.h guard
  - Collected RBs from Alex, with thanks

* From v2 [2]:
  - Rebased on 5.13-rc1
  - Fixed a couple of nits in the GIC registration code

* From v1 [1]:
  - Rebased on Hector's v4 posting[0]
  - Dropped a couple of patches that have been merged in the above series
  - Fixed irq_ack callback on the timer path

[0] https://lore.kernel.org/r/20210402090542.131194-1-marcan@marcan.st
[1] https://lore.kernel.org/r/20210316174617.173033-1-maz@kernel.org
[2] https://lore.kernel.org/r/20210403112931.1043452-1-maz@kernel.org
[3] https://lore.kernel.org/r/20210510134824.1910399-1-maz@kernel.org

Marc Zyngier (9):
  irqchip/gic: Split vGIC probing information from the GIC code
  KVM: arm64: Handle physical FIQ as an IRQ while running a guest
  KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt
    masking
  KVM: arm64: vgic: Let an interrupt controller advertise lack of HW
    deactivation
  KVM: arm64: vgic: move irq->get_input_level into an ops structure
  KVM: arm64: vgic: Implement SW-driven deactivation
  KVM: arm64: timer: Refactor IRQ configuration
  KVM: arm64: timer: Add support for SW-based deactivation
  irqchip/apple-aic: Advertise some level of vGICv3 compatibility

 arch/arm64/kvm/arch_timer.c            | 162 +++++++++++++++++++++----
 arch/arm64/kvm/hyp/hyp-entry.S         |   6 +-
 arch/arm64/kvm/vgic/vgic-init.c        |  36 +++++-
 arch/arm64/kvm/vgic/vgic-v2.c          |  19 ++-
 arch/arm64/kvm/vgic/vgic-v3.c          |  19 ++-
 arch/arm64/kvm/vgic/vgic.c             |  14 +--
 drivers/irqchip/irq-apple-aic.c        |   9 ++
 drivers/irqchip/irq-gic-common.c       |  13 --
 drivers/irqchip/irq-gic-common.h       |   2 -
 drivers/irqchip/irq-gic-v3.c           |   6 +-
 drivers/irqchip/irq-gic.c              |   6 +-
 include/kvm/arm_vgic.h                 |  41 +++++--
 include/linux/irqchip/arm-gic-common.h |  25 +---
 include/linux/irqchip/arm-vgic-info.h  |  45 +++++++
 14 files changed, 299 insertions(+), 104 deletions(-)
 create mode 100644 include/linux/irqchip/arm-vgic-info.h

-- 
2.30.2

