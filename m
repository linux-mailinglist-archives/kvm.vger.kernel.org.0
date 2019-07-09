Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487466358F
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfGIMZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:21 -0400
Received: from foss.arm.com ([217.140.110.172]:42632 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfGIMZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29AE52B;
        Tue,  9 Jul 2019 05:25:20 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CA153F59C;
        Tue,  9 Jul 2019 05:25:18 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm updates for Linux 5.3
Date:   Tue,  9 Jul 2019 13:24:49 +0100
Message-Id: <20190709122507.214494-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Radim, Paolo,

This is the (slightly delayed) KVM/arm updates for 5.3. This time
around, some PMU emulation improvements, the ability to save/restore
the Spectre mitigation state, better SError handling that double as
the workaround for a N1 erratum, a 32bit fix for a corrupted MPIDR,
and yet another pre-NV cleanup.

Please pull,

	M.

The following changes since commit 4b972a01a7da614b4796475f933094751a295a2f:

  Linux 5.2-rc6 (2019-06-22 16:01:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-5.3

for you to fetch changes up to 1e0cf16cdad1ba53e9eeee8746fe57de42f20c97:

  KVM: arm/arm64: Initialise host's MPIDRs by reading the actual register (2019-07-08 16:29:48 +0100)

----------------------------------------------------------------
KVM/arm updates for 5.3

- Add support for chained PMU counters in guests
- Improve SError handling
- Handle Neoverse N1 erratum #1349291
- Allow side-channel mitigation status to be migrated
- Standardise most AArch64 system register accesses to msr_s/mrs_s
- Fix host MPIDR corruption on 32bit

----------------------------------------------------------------
Andre Przywara (3):
      arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests
      KVM: arm/arm64: Add save/restore support for firmware workaround state
      KVM: doc: Add API documentation on the KVM_REG_ARM_WORKAROUNDS register

Andrew Murray (5):
      KVM: arm/arm64: Rename kvm_pmu_{enable/disable}_counter functions
      KVM: arm/arm64: Extract duplicated code to own function
      KVM: arm/arm64: Re-create event when setting counter value
      KVM: arm/arm64: Remove pmc->bitmask
      KVM: arm/arm64: Support chained PMU counters

Dave Martin (1):
      KVM: arm64: Migrate _elx sysreg accessors to msr_s/mrs_s

James Morse (8):
      arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS
      KVM: arm64: Abstract the size of the HYP vectors pre-amble
      KVM: arm64: Make indirect vectors preamble behaviour symmetric
      KVM: arm64: Consume pending SError as early as possible
      KVM: arm64: Defer guest entry when an asynchronous exception is pending
      arm64: Update silicon-errata.txt for Neoverse-N1 #1349291
      KVM: arm64: Re-mask SError after the one instruction window
      KVM: arm64: Skip more of the SError vaxorcism

Marc Zyngier (1):
      KVM: arm/arm64: Initialise host's MPIDRs by reading the actual register

 Documentation/arm64/silicon-errata.txt   |   1 +
 Documentation/virtual/kvm/arm/psci.txt   |  31 +++
 arch/arm/include/asm/kvm_emulate.h       |  10 +
 arch/arm/include/asm/kvm_host.h          |  18 +-
 arch/arm/include/asm/kvm_hyp.h           |  13 +-
 arch/arm/include/uapi/asm/kvm.h          |  12 ++
 arch/arm64/include/asm/assembler.h       |   4 +
 arch/arm64/include/asm/cpufeature.h      |   6 +
 arch/arm64/include/asm/kvm_asm.h         |   6 +
 arch/arm64/include/asm/kvm_emulate.h     |  30 ++-
 arch/arm64/include/asm/kvm_host.h        |  23 +-
 arch/arm64/include/asm/kvm_hyp.h         |  50 +----
 arch/arm64/include/asm/sysreg.h          |  35 +++-
 arch/arm64/include/uapi/asm/kvm.h        |  10 +
 arch/arm64/kernel/cpu_errata.c           |  23 +-
 arch/arm64/kernel/traps.c                |   4 +
 arch/arm64/kvm/hyp/entry.S               |  36 +++-
 arch/arm64/kvm/hyp/hyp-entry.S           |  30 ++-
 arch/arm64/kvm/hyp/switch.c              |  14 +-
 arch/arm64/kvm/hyp/sysreg-sr.c           |  78 +++----
 arch/arm64/kvm/hyp/tlb.c                 |  12 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/regmap.c                  |   4 +-
 arch/arm64/kvm/sys_regs.c                |  60 +++---
 arch/arm64/kvm/va_layout.c               |   7 +-
 include/kvm/arm_pmu.h                    |  11 +-
 virt/kvm/arm/arch_timer.c                |  24 +--
 virt/kvm/arm/arm.c                       |   3 +-
 virt/kvm/arm/pmu.c                       | 350 +++++++++++++++++++++++++------
 virt/kvm/arm/psci.c                      | 149 +++++++++++--
 30 files changed, 775 insertions(+), 281 deletions(-)
