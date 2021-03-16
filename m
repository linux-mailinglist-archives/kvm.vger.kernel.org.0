Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F8333DB4D
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhCPRqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239087AbhCPRql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:46:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DDE65120;
        Tue, 16 Mar 2021 17:46:40 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmA-0021ao-ST; Tue, 16 Mar 2021 17:46:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 00/11] KVM: arm64: Initial host support for the Apple M1
Date:   Tue, 16 Mar 2021 17:46:05 +0000
Message-Id: <20210316174617.173033-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've spent the past few weekends trying to see how I could support the
M1 as a KVM host. It started by being pretty ugly, but the end result
is actually not too horrible.

Just a wee bit horrible.

The M1 has no GIC. And as everybody know, "KVM" stands for "The GIC
Emulator". Yes, Avi got the TLA wrong. Blame him.

It has no GIC, but it has a *partial* implementation of a vGICv3.
Which is not advertised by the CPU, because you can't have one without
the other. And it is partial because it cannot implement the automatic
HW interrupt deactivation trick (no GIC, remember?). But despite its
flaws, this gives us a fighting chance to expose something standard to
the guests.

"But how will the timers work?", I hear someone asking.

Well, that's a very good question. We rely on the GIC active state and
the HW-based deactivation to make the whole thing work, preventing a
pending timer interrupt from kicking us out of the guest, and
transparently re-enabling the interrupt when the guest EOIs it.

None of that can work on the M1, because (/all together now/) *it
doesn't have a GIC*!

What we can do instead is to fallback to regular masking on guest
entry, and rely on an exit on EOI to unmask the timer. Is that free?
No. Does it work? Yes! The trick is to make this as transparent as
possible to the rest of KVM so that the overhead is squarely on the M1
side. And my (very limited) testing indicates that this overhead is
pretty small.

Note that there is another way to implement the virtual timer: it
appears that this timer can be directly injected thanks to an IMPDEF
mechanism (HACR_EL2[20] + S3_5_15_1_2). It works fine, but:

- it is IMPDEF
- it is massively invasive for the GIC state machine
- it bloats the entry/exit fast path
- it forbids the implementation of GICR_ISPENDR0
- it doesn't work the physical timer
- it is IMPDEF

So scratch that, it doesn't work. I've kept the code for posterity,
but I don't think it is worth it. "Cute Embedded Nonsense Hack", to
quote someone.

This series is on top of Hector's latest drop[1], itself on top of the
FIQ enablement code gathered by Mark[2], plus 5.12-rc3 (which is
needed because this machine lacks an architectural PMU).

You will also need a bleeding edge userspace (qemu[3], kvmtool[4])
that configures the VM with a tiny IPA space (as the HW supports at
most 36 bits while KVM defaults to 40...).

[1] https://lore.kernel.org/r/20210304213902.83903-1-marcan@marcan.st
[2] https://lore.kernel.org/r/20210315115629.57191-1-mark.rutland@arm.com
[3] https://lore.kernel.org/r/20210310135218.255205-1-drjones@redhat.com
[4] https://lore.kernel.org/r/20210309163909.822149-1-maz@kernel.org

Marc Zyngier (11):
  irqchip/gic: Split vGIC probing information from the GIC code
  KVM: arm64: Handle physical FIQ as an IRQ while running a guest
  KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt
  KVM: arm64: vgic: Let an interrupt controller advertise lack of HW
    deactivation
  KVM: arm64: vgic: move irq->get_input_level into an ops structure
  KVM: arm64: vgic: Implement SW-driven deactivation
  KVM: arm64: timer: Refactor IRQ configuration
  KVM: arm64: timer: Add support for SW-based deactivation
  irqchip/apple-aic: Fix [un]masking of guest timers
  irqchip/apple-aic: Initialise SYS_APL_VM_TMR_FIQ_ENA_EL1 at boot time
  irqchip/apple-aic: Advertise some level of vGICv3 compatibility

 arch/arm64/kvm/arch_timer.c            | 153 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S         |   6 +-
 arch/arm64/kvm/vgic/vgic-init.c        |  33 +++++-
 arch/arm64/kvm/vgic/vgic-v2.c          |  19 ++-
 arch/arm64/kvm/vgic/vgic-v3.c          |  19 ++-
 arch/arm64/kvm/vgic/vgic.c             |  14 +--
 drivers/irqchip/irq-apple-aic.c        |  18 ++-
 drivers/irqchip/irq-gic-common.c       |  13 ---
 drivers/irqchip/irq-gic-common.h       |   2 -
 drivers/irqchip/irq-gic-v3.c           |   6 +-
 drivers/irqchip/irq-gic.c              |   6 +-
 include/kvm/arm_vgic.h                 |  41 +++++--
 include/linux/irqchip/arm-gic-common.h |  25 +---
 include/linux/irqchip/arm-vgic-info.h  |  43 +++++++
 14 files changed, 290 insertions(+), 108 deletions(-)
 create mode 100644 include/linux/irqchip/arm-vgic-info.h

-- 
2.29.2

