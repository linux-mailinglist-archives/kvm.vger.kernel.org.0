Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685A525C544
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgICP0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgICP0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB6642072A;
        Thu,  3 Sep 2020 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146782;
        bh=8diWhh0vQL5HYykVI49PgHaLPAgX0kRPHzqmaQWLOls=;
        h=From:To:Cc:Subject:Date:From;
        b=eFusFhxUiCVyfGJetxIodBv0tSPJaTcDRpy7v6ycgpd2p15loF0UoUChIv4AjVfyl
         E1EWwVo2fCbfwJ/7OdVnj01XzPbA8i5+AXlAKJCKpC6Ws+d/cbKNTbwo5/WRuCYFjh
         NINfTBstZUih33OaWbnO04zoCyb3pg4xfJbKKjaM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr80-008vT9-Qx; Thu, 03 Sep 2020 16:26:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 00/23] KVM: arm64: rVIC/rVID PV interrupt controller
Date:   Thu,  3 Sep 2020 16:25:47 +0100
Message-Id: <20200903152610.1078827-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anyone vaguely familiar with the ARM interrupt architecture (also
known as GIC) would certainly agree that it isn't the simplest thing
to deal with. Its features are ranging from simple, bare metal
interrupt delivery to full blown direct injection into a guest.

It is also horribly complex, full of backward[-compatibility]
features, and it is very hard to reason about what is going on in the
system at any given time. For a hypervisor such as KVM, the GIC is an
invasive beast that accounts for a large part of the privileged
software we run, as it implements the whole of the architecture with
bells and whistles as it tries to cater for all possible guests.

At the same time, we have an ongoing effort to make KVM/arm64 a more
"verifiable" hypervisor, by allowing only a small amount of code to
run at EL2. Moving most of the GIC emulation to userspace would
involve sacrificing performance (the architecture really doesn't lend
itself to a split model, despite the appearances), and proving that it
is actually completely safe is almost an impossible task (I have seen
people trying!).

Another approach is to bite the bullet, and design from the ground up
an interrupt controller that:

- works well enough for workloads that mostly deal with virtual
  interrupts (no device assignment),

- is as simple as possible for the hypervisor to implement.

Since we cannot retrospectively hack the HW, this is a paravirtualized
interrupt controller, where every single operation results in a trap.
Yes, it looks like it would be terribly expensive. Or not.

The result of the above is a specification from ARM [1] that defines
the RVIC and RVID components that make the interrupt controller. It is
an *Alpha* spec, to it is very much subject to changes (the hypercall
numbers have been redacted out to make that explicit).

The result of the above result is this patch series, which provides
Linux drivers for rVIC and rVID, as well as a KVM implementation that
can be exposed to guests. Most of the patches are a big refactor of
the KVM/arm64 code to allow a non-GIC irqchip to be exposed to the
guest, as the code that actually deals with delivering interrupts is
pretty simple. I intend to carry on refactoring this as more
structures could be made irqchip agnostic.

We have:

- Support for the rVIC/rVID PV interrupt controller architecture in a
  guest

- A large rework of the way the vgic integrates with the rest of KVM,
  mostly punching a vgic-shaped hole in the code, and replacing it with
  a set of optional callbacks that an interrupt controller
  implementation can provide, or not.

- A rVIC/rVID implementation for KVM/arm64.

This is based on my previously posted IPI-as-IRQ series

How does it fare? Well, it's not even bad. There is a bit more
overhead than with an actual GIC, but you need to squint really hard
to see a difference. Turns out that interacting with a HW interrupt
controller isn't free either... Of course, YMMV, and I'd happily look
at performance figures if someone has the guts to put them together.

What is missing:

- Patches for userspace to actually start a rVIC-equipped guest. I
  have pushed a kvmtool branch at [2]. This is just a terrible pile of
  hacks, don't trust it to do anything right. It works well enough to
  spawn a guest with virtio-pci and deliver MSIs though.

- DT bindings, which I need to write up

- ACPI? Why not...

Things that are *not* in the spec:

- MSIs. I've made them up in the driver and KVM, and I don't think we
  can do without them. I intend to feed that requirement back to ARM.

- RVID level interrupts. We need them to implement PCI INTx.

- Priorities. Not clear whether we really need those, and it would
  certainly complixify the design.

This has been lightly tested on a A55-based system running VHE, and
equipped with a GICv2, as well as a couple of nVHE systems with both
GICv2 and GICv3. VHE+GICv3 is still untested, as I lack the platform
(someone please send me an Ampere Altra box ;-).

Patches are based on v5.9-rc3 + the IPI patches, and a branch with
everything stacked together is at [3].

[1] https://developer.arm.com/architectures/system-architectures/software-standards/rvic
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/log/?h=rvic
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/rvic

Marc Zyngier (23):
  irqchip: Add Reduced Virtual Interrupt Controller driver
  irqchip/rvic: Add support for untrusted interrupt allocation
  irqchip: Add Reduced Virtual Interrupt Distributor support
  irqchip/rvid: Add PCI MSI support
  KVM: arm64: Move GIC model out of the distributor
  KVM: arm64: vgic-v3: Move early init to kvm_vgic_create()
  KVM: arm64: Add irqchip callback structure to kvm_arch
  KVM: arm64: Move kvm_vgic_destroy to kvm_irqchip_flow
  KVM: arm64: Move kvm_vgic_vcpu_init() to irqchip_flow
  KVM: arm64: Move kvm_vgic_vcpu_[un]blocking() to irqchip_flow
  KVM: arm64: Move kvm_vgic_vcpu_load/put() to irqchip_flow
  KVM: arm64: Move kvm_vgic_vcpu_pending_irq() to irqchip_flow
  KVM: arm64: Move vgic resource mapping on first run to irqchip_flow
  KVM: arm64: Move kvm_vgic_vcpu_{sync,flush}_hwstate() to irqchip_flow
  KVM: arm64: nVHE: Only save/restore GICv3 state if modeling a GIC
  KVM: arm64: Move interrupt injection to irqchip_flow
  KVM: arm64: Move mapping of HW interrupts into irqchip_flow
  KVM: arm64: Move set_owner into irqchip_flow
  KVM: arm64: Turn vgic_initialized into irqchip_finalized
  KVM: arm64: Move irqfd routing to irqchip_flow
  KVM: arm64: Tighten msis_require_devid reporting
  KVM: arm64: Add a rVIC/rVID in-kernel implementation
  KVM: arm64: Add debugfs files for the rVIC/rVID implementation

 arch/arm64/include/asm/kvm_host.h     |   11 +-
 arch/arm64/include/asm/kvm_irq.h      |  136 +++
 arch/arm64/include/uapi/asm/kvm.h     |    9 +
 arch/arm64/kvm/Makefile               |    2 +-
 arch/arm64/kvm/arch_timer.c           |   36 +-
 arch/arm64/kvm/arm.c                  |  141 ++-
 arch/arm64/kvm/hyp/nvhe/switch.c      |   12 +-
 arch/arm64/kvm/hypercalls.c           |    7 +
 arch/arm64/kvm/pmu-emul.c             |   10 +-
 arch/arm64/kvm/rvic-cpu.c             | 1213 +++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-debug.c      |    7 +-
 arch/arm64/kvm/vgic/vgic-init.c       |  133 ++-
 arch/arm64/kvm/vgic/vgic-irqfd.c      |   72 +-
 arch/arm64/kvm/vgic/vgic-its.c        |    2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |   18 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |    2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       |   10 +-
 arch/arm64/kvm/vgic/vgic-v2.c         |    5 -
 arch/arm64/kvm/vgic/vgic-v3.c         |   26 +-
 arch/arm64/kvm/vgic/vgic.c            |   55 +-
 arch/arm64/kvm/vgic/vgic.h            |   37 +
 drivers/irqchip/Kconfig               |   12 +
 drivers/irqchip/Makefile              |    2 +
 drivers/irqchip/irq-rvic.c            |  595 ++++++++++++
 drivers/irqchip/irq-rvid.c            |  441 +++++++++
 include/kvm/arm_rvic.h                |   41 +
 include/kvm/arm_vgic.h                |   33 -
 include/linux/cpuhotplug.h            |    1 +
 include/linux/irqchip/irq-rvic.h      |  100 ++
 include/uapi/linux/kvm.h              |    2 +
 30 files changed, 2907 insertions(+), 264 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_irq.h
 create mode 100644 arch/arm64/kvm/rvic-cpu.c
 create mode 100644 drivers/irqchip/irq-rvic.c
 create mode 100644 drivers/irqchip/irq-rvid.c
 create mode 100644 include/kvm/arm_rvic.h
 create mode 100644 include/linux/irqchip/irq-rvic.h

-- 
2.27.0

