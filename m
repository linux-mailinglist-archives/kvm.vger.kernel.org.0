Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8631799F4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgCDUel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:34:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgCDUel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:34:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0590F2146E;
        Wed,  4 Mar 2020 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354080;
        bh=EccRIJfqWszlojINoiDMmQQnsb0+rQyVI2xUVh/plgk=;
        h=From:To:Cc:Subject:Date:From;
        b=fMndKntSxrYcdIzHDf5W7dfxHX7dqrNrLDlG2f+x9yUL2diG3BWQOKaiiVgxGe50h
         fLicNAlpoKOsdxImuN6PZ5YKOB6t+hq5olmAvhEADhkqm2GLPousO7zHr+K0fQnHK8
         MYX+oVMUXX8qMT9N57gTTg233z6EuIl0rgDmxVeg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9aiz-00A59R-EB; Wed, 04 Mar 2020 20:34:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 00/23] irqchip/gic-v4: GICv4.1 architecture support
Date:   Wed,  4 Mar 2020 20:33:07 +0000
Message-Id: <20200304203330.4967-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This (now shorter) series expands the existing GICv4 support to deal
with the new GICv4.1 architecture, which comes with a set of major
improvements compared to v4.0:

- One architectural doorbell per vcpu, instead of one doorbell per VLPI

- Doorbell entirely managed by the HW, with an "at most once" delivery
  guarantee per non-residency phase and only when requested by the
  hypervisor

- A shared memory scheme between ITSs and redistributors, allowing for an
  optimised residency sequence (the use of VMOVP becomes less frequent)

- Support for direct virtual SGI delivery (the injection path still involves
  the hypervisor), at the cost of losing the active state on SGIs. It
  shouldn't be a big deal, but some guest operating systems might notice
  (Linux definitely won't care).

On the other hand, public documentation is not available yet, so that's a
bit annoying...

The series is roughly organised in 3 parts:

(0) Fixes
(1) v4.1 doorbell management
(2) Virtual SGI support
(3) Plumbing of virtual SGIs in KVM

Notes:

  - The whole thing is tested on a FVP model, which can be obtained
    free of charge on ARM's developer website. It requires you to
    create an account, unfortunately... You'll need a fix for the
    devicetree that is in the kernel tree (should be merged before
    the 5.6 release).

  - This series has uncovered a behaviour that looks like a HW bug on
    the Cavium ThunderX (aka TX1) platform. I'd very much welcome some
    clarification from the Marvell/Cavium folks on Cc, as well as an
    official erratum number if this happens to be an actual bug.

    [v3 update]
    People have ignored for two months now, and it is fairly obvious
    that support for this machine is slowly bit-rotting. Maybe I'll
    drop the patch and instead start the process of removing all TX1
    support from the kernel (we'd certainly be better off without it).

    [v4 update]
    TX1 is now broken in mainline, and nobody cares. Make of this what
    you want.

  - I'm extremely grateful for Zenghui Yu's huge effort in carefully
    reviewing this rather difficult series (if we ever get to meet
    face to face, drinks are definitely on me!).

  - Unless someone cries wolf, I plan to take this into 5.7.

* From v4 [4]
  - Rebased on v5.6-rc4
  - Fixed locking all over the shop now that we can bypass the ITS
  - Wait on INVALL at the RD level
  - Plentu of cleanups/fixes thanks to Zenghui's careful review effort

* From v3 [3]:
  - Rebased on v5.6-rc1
  - Considerably smaller thanks to the initial patches being merged
  - Small bug fix after the v5.6 merge window

* From v2 [2]:
  - Another bunch of fixes thanks to Zenghui Yu's very careful review
  - HW-accelerated SGIs are now optional thanks to new architected
    discovery/selection bits exposed by KVM and used by the guest kernel
  - Rebased on v5.5-rc2

* From v1 [1]:
  - A bunch of minor reworks after Zenghui Yu's review
  - A workaround for what looks like a new and unexpected TX1 bug
  - A subtle reorder of the series so that some patches can go in early

[1] https://lore.kernel.org/lkml/20190923182606.32100-1-maz@kernel.org/
[2] https://lore.kernel.org/lkml/20191027144234.8395-1-maz@kernel.org/
[3] https://lore.kernel.org/r/20191224111055.11836-1-maz@kernel.org/
[4] https://lore.kernel.org/r/20200214145736.18550-1-maz@kernel.org/

Marc Zyngier (22):
  irqchip/gic-v3: Use SGIs without active state if offered
  irqchip/gic-v4.1: Skip absent CPUs while iterating over redistributors
  irqchip/gic-v4.1: Ensure mutual exclusion between vPE affinity change
    and RD access
  irqchip/gic-v4.1: Ensure mutual exclusion betwen invalidations on the
    same RD
  irqchip/gic-v4.1: Advertise support v4.1 to KVM
  irqchip/gic-v4.1: Map the ITS SGIR register page
  irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
  irqchip/gic-v4.1: Add initial SGI configuration
  irqchip/gic-v4.1: Plumb mask/unmask SGI callbacks
  irqchip/gic-v4.1: Plumb get/set_irqchip_state SGI callbacks
  irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI callbacks
  irqchip/gic-v4.1: Move doorbell management to the GICv4 abstraction
    layer
  irqchip/gic-v4.1: Add VSGI allocation/teardown
  irqchip/gic-v4.1: Add VSGI property setup
  irqchip/gic-v4.1: Eagerly vmap vPEs
  KVM: arm64: GICv4.1: Let doorbells be auto-enabled
  KVM: arm64: GICv4.1: Add direct injection capability to SGI registers
  KVM: arm64: GICv4.1: Allow SGIs to switch between HW and SW interrupts
  KVM: arm64: GICv4.1: Plumb SGI implementation selection in the
    distributor
  KVM: arm64: GICv4.1: Reload VLPI configuration on distributor
    enable/disable
  KVM: arm64: GICv4.1: Allow non-trapping WFI when using HW SGIs
  KVM: arm64: GICv4.1: Expose HW-based SGIs in debugfs

Zenghui Yu (1):
  irqchip/gic-v4.1: Wait for completion of redistributor's INVALL
    operation

 arch/arm/include/asm/kvm_host.h        |   1 +
 arch/arm64/include/asm/kvm_emulate.h   |   3 +-
 arch/arm64/include/asm/kvm_host.h      |   1 +
 drivers/irqchip/irq-gic-v3-its.c       | 385 +++++++++++++++++++++++--
 drivers/irqchip/irq-gic-v3.c           |  13 +-
 drivers/irqchip/irq-gic-v4.c           | 134 ++++++++-
 include/kvm/arm_vgic.h                 |   4 +
 include/linux/irqchip/arm-gic-common.h |   2 +
 include/linux/irqchip/arm-gic-v3.h     |  20 +-
 include/linux/irqchip/arm-gic-v4.h     |  25 +-
 virt/kvm/arm/arm.c                     |   8 +
 virt/kvm/arm/vgic/vgic-debug.c         |  14 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c       |  68 ++++-
 virt/kvm/arm/vgic/vgic-mmio.c          |  88 +++++-
 virt/kvm/arm/vgic/vgic-v3.c            |   6 +-
 virt/kvm/arm/vgic/vgic-v4.c            | 137 +++++++--
 virt/kvm/arm/vgic/vgic.h               |   1 +
 17 files changed, 844 insertions(+), 66 deletions(-)

-- 
2.20.1

