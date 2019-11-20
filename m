Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B510410E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbfKTQnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:43:08 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:36603 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732847AbfKTQnH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:43:07 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXT49-0007RI-KJ; Wed, 20 Nov 2019 17:42:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] KVM/arm updates for 5.5
Date:   Wed, 20 Nov 2019 16:42:14 +0000
Message-Id: <20191120164236.29359-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com, drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com, eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com, mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com, tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Here's the bulk of KVM/arm updates for 5.5. On the menu, two new features:
- Stolen time is finally exposed to guests. Yay!
- We can report (and potentially emulate) instructions that KVM cannot
  handle in kernel space to userspace. Yay again!

Apart from that, a fairly mundane bag of perf optimization, cleanup and
bug fixes.

Note that this series is based on a shared branch with the arm64 tree,
avoiding a potential delicate merge.

Please pull,

	M.

The following changes since commit e6ea46511b1ae8c4491904c79411fcd29139af14:

  firmware: arm_sdei: use common SMCCC_CONDUIT_* (2019-10-14 10:55:14 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.5

for you to fetch changes up to cd7056ae34af0e9424da97bbc7d2b38246ba8a2c:

  Merge remote-tracking branch 'kvmarm/misc-5.5' into kvmarm/next (2019-11-08 11:27:29 +0000)

----------------------------------------------------------------
KVM/arm updates for Linux 5.5:

- Allow non-ISV data aborts to be reported to userspace
- Allow injection of data aborts from userspace
- Expose stolen time to guests
- GICv4 performance improvements
- vgic ITS emulation fixes
- Simplify FWB handling
- Enable halt pool counters
- Make the emulated timer PREEMPT_RT compliant

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: arm/arm64: Show halt poll counters in debugfs

Christoffer Dall (4):
      KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace
      KVM: arm/arm64: Allow user injection of external data aborts
      KVM: arm/arm64: Factor out hypercall handling from PSCI code
      KVM: arm64: Don't set HCR_EL2.TVM when S2FWB is supported

Marc Zyngier (6):
      Merge remote-tracking branch 'arm64/for-next/smccc-conduit-cleanup' into kvm-arm64/stolen-time
      Merge remote-tracking branch 'kvmarm/kvm-arm64/stolen-time' into kvmarm-master/next
      KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put
      KVM: vgic-v4: Track the number of VLPIs per vcpu
      KVM: arm64: Opportunistically turn off WFI trapping when using direct LPI injection
      Merge remote-tracking branch 'kvmarm/misc-5.5' into kvmarm/next

Steven Price (10):
      KVM: arm64: Document PV-time interface
      KVM: arm64: Implement PV_TIME_FEATURES call
      KVM: Implement kvm_put_guest()
      KVM: arm64: Support stolen time reporting via shared structure
      KVM: Allow kvm_device_ops to be const
      KVM: arm64: Provide VCPU attributes for stolen time
      arm/arm64: Provide a wrapper for SMCCC 1.1 calls
      arm/arm64: Make use of the SMCCC 1.1 wrapper
      arm64: Retrieve stolen time as paravirtualized guest
      KVM: arm64: Select TASK_DELAY_ACCT+TASKSTATS rather than SCHEDSTATS

Thomas Gleixner (1):
      KVM: arm/arm64: Let the timer expire in hardirq context on RT

Zenghui Yu (3):
      KVM: arm/arm64: vgic: Remove the declaration of kvm_send_userspace_msi()
      KVM: arm/arm64: vgic: Fix some comments typo
      KVM: arm/arm64: vgic: Don't rely on the wrong pending table

 Documentation/admin-guide/kernel-parameters.txt |   6 +-
 Documentation/virt/kvm/api.txt                  |  55 +++++++++-
 Documentation/virt/kvm/arm/pvtime.rst           |  80 ++++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt         |  14 +++
 arch/arm/include/asm/kvm_arm.h                  |   1 +
 arch/arm/include/asm/kvm_emulate.h              |   9 +-
 arch/arm/include/asm/kvm_host.h                 |  33 ++++++
 arch/arm/include/uapi/asm/kvm.h                 |   3 +-
 arch/arm/kvm/Makefile                           |   2 +-
 arch/arm/kvm/guest.c                            |  14 +++
 arch/arm/kvm/handle_exit.c                      |   2 +-
 arch/arm/mm/proc-v7-bugs.c                      |  13 +--
 arch/arm64/include/asm/kvm_arm.h                |   3 +-
 arch/arm64/include/asm/kvm_emulate.h            |  26 ++++-
 arch/arm64/include/asm/kvm_host.h               |  37 +++++++
 arch/arm64/include/asm/paravirt.h               |   9 +-
 arch/arm64/include/asm/pvclock-abi.h            |  17 +++
 arch/arm64/include/uapi/asm/kvm.h               |   5 +-
 arch/arm64/kernel/cpu_errata.c                  |  81 +++++---------
 arch/arm64/kernel/paravirt.c                    | 140 ++++++++++++++++++++++++
 arch/arm64/kernel/time.c                        |   3 +
 arch/arm64/kvm/Kconfig                          |   4 +
 arch/arm64/kvm/Makefile                         |   2 +
 arch/arm64/kvm/guest.c                          |  23 ++++
 arch/arm64/kvm/handle_exit.c                    |   4 +-
 arch/arm64/kvm/inject_fault.c                   |   4 +-
 drivers/irqchip/irq-gic-v4.c                    |   7 +-
 include/Kbuild                                  |   2 +
 include/kvm/arm_hypercalls.h                    |  43 ++++++++
 include/kvm/arm_psci.h                          |   2 +-
 include/kvm/arm_vgic.h                          |   8 +-
 include/linux/arm-smccc.h                       |  59 ++++++++++
 include/linux/cpuhotplug.h                      |   1 +
 include/linux/irqchip/arm-gic-v4.h              |   4 +
 include/linux/kvm_host.h                        |  26 ++++-
 include/linux/kvm_types.h                       |   2 +
 include/uapi/linux/kvm.h                        |  10 ++
 virt/kvm/arm/arch_timer.c                       |   8 +-
 virt/kvm/arm/arm.c                              |  49 ++++++++-
 virt/kvm/arm/hypercalls.c                       |  71 ++++++++++++
 virt/kvm/arm/mmio.c                             |   9 +-
 virt/kvm/arm/psci.c                             |  84 +-------------
 virt/kvm/arm/pvtime.c                           | 131 ++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-init.c                   |   1 +
 virt/kvm/arm/vgic/vgic-its.c                    |   3 +
 virt/kvm/arm/vgic/vgic-v3.c                     |  12 +-
 virt/kvm/arm/vgic/vgic-v4.c                     |  59 +++++-----
 virt/kvm/arm/vgic/vgic.c                        |   4 -
 virt/kvm/arm/vgic/vgic.h                        |   2 -
 virt/kvm/kvm_main.c                             |   6 +-
 50 files changed, 968 insertions(+), 225 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvtime.rst
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 virt/kvm/arm/hypercalls.c
 create mode 100644 virt/kvm/arm/pvtime.c
