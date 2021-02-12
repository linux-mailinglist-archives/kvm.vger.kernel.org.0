Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A7631A0BF
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhBLOiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 09:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229815AbhBLOh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 09:37:56 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E7CB64DD9;
        Fri, 12 Feb 2021 14:37:15 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lAZZJ-00DqME-4c; Fri, 12 Feb 2021 14:37:13 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 updates for 5.12
Date:   Fri, 12 Feb 2021 14:36:57 +0000
Message-Id: <20210212143657.3312035-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, ardb@kernel.org, dbrazdil@google.com, eric.auger@redhat.com, qperret@google.com, will@kernel.org, wangyanan55@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the initial set of KVM/arm64 updates for 5.11.

The most notable change this time is David's work to finally build the
nVHE EL2 object as a relocatable object. This makes the code a lot
cleaner, more reliable (we don't have to assume things about code
generation), and allows... function pointers, with any ugly hack!
Progress, at last, and a huge thank you to David!

We also gained support for the new TRNG standard hypercall, and a nice
optimisation for concurrent translation faults targeting the same
page. The rest is a small batch of fixes and other cleanups.

Note that there is another bunch of changes indirectly affecting
KVM/arm64 that are routed via the arm64 tree, as we turn upside down
the way we boot Linux on a VHE system. It's all good fun.

This pull request also comes with strings attached:
- the kvmarm-fixes-5.11-2 tag in order to avoid ugly conflicts, which
  explains a sense of déjà-vu in the short-log below
- the arm64/for-next/misc branch because of dependencies

Please pull,

	M.

The following changes since commit 19c329f6808995b142b3966301f217c831e7cf31:

  Linux 5.11-rc4 (2021-01-17 16:37:05 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.12

for you to fetch changes up to c93199e93e1232b7220482dffa05b7a32a195fe8:

  Merge branch 'kvm-arm64/pmu-debug-fixes-5.11' into kvmarm-master/next (2021-02-12 14:08:41 +0000)

----------------------------------------------------------------
KVM/arm64 updates for Linux 5.12

- Make the nVHE EL2 object relocatable, resulting in much more
  maintainable code
- Handle concurrent translation faults hitting the same page
  in a more elegant way
- Support for the standard TRNG hypervisor call
- A bunch of small PMU/Debug fixes
- Allow the disabling of symbol export from assembly code
- Simplification of the early init hypercall handling

----------------------------------------------------------------
Alexandru Elisei (2):
      KVM: arm64: Use the reg_to_encoding() macro instead of sys_reg()
      KVM: arm64: Correct spelling of DBGDIDR register

Andrew Scull (1):
      KVM: arm64: Simplify __kvm_hyp_init HVC detection

Ard Biesheuvel (2):
      firmware: smccc: Add SMCCC TRNG function call IDs
      KVM: arm64: Implement the TRNG hypervisor call

David Brazdil (9):
      KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
      KVM: arm64: Rename .idmap.text in hyp linker script
      KVM: arm64: Set up .hyp.rodata ELF section
      KVM: arm64: Add symbol at the beginning of each hyp section
      KVM: arm64: Generate hyp relocation data
      KVM: arm64: Apply hyp relocations at runtime
      KVM: arm64: Fix constant-pool users in hyp
      KVM: arm64: Remove patching of fn pointers in hyp
      KVM: arm64: Remove hyp_symbol_addr

Marc Zyngier (20):
      KVM: arm64: Hide PMU registers from userspace when not available
      KVM: arm64: Simplify handling of absent PMU system registers
      arm64: Drop workaround for broken 'S' constraint with GCC 4.9
      KVM: arm64: Filter out v8.1+ events on v8.0 HW
      KVM: Forbid the use of tagged userspace addresses for memslots
      Merge branch 'arm64/for-next/misc' into kvm-arm64/hyp-reloc
      KVM: arm64: Make gen-hyprel endianness agnostic
      KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
      KVM: arm64: Fix AArch32 PMUv3 capping
      KVM: arm64: Add handling of AArch32 PCMEID{2,3} PMUv3 registers
      KVM: arm64: Refactor filtering of ID registers
      KVM: arm64: Limit the debug architecture to ARMv8.0
      KVM: arm64: Upgrade PMU support to ARMv8.4
      KVM: arm64: Use symbolic names for the PMU versions
      Merge tag 'kvmarm-fixes-5.11-2' into kvmarm-master/next
      Merge branch 'kvm-arm64/misc-5.12' into kvmarm-master/next
      Merge branch 'kvm-arm64/concurrent-translation-fault' into kvmarm-master/next
      Merge branch 'kvm-arm64/hyp-reloc' into kvmarm-master/next
      Merge branch 'kvm-arm64/rng-5.12' into kvmarm-master/next
      Merge branch 'kvm-arm64/pmu-debug-fixes-5.11' into kvmarm-master/next

Quentin Perret (2):
      asm-generic: export: Stub EXPORT_SYMBOL with __DISABLE_EXPORTS
      KVM: arm64: Stub EXPORT_SYMBOL for nVHE EL2 code

Steven Price (1):
      KVM: arm64: Compute TPIDR_EL2 ignoring MTE tag

Yanan Wang (3):
      KVM: arm64: Adjust partial code of hyp stage-1 map and guest stage-2 map
      KVM: arm64: Filter out the case of only changing permissions from stage-2 map path
      KVM: arm64: Mark the page dirty only if the fault is handled successfully

 Documentation/virt/kvm/api.rst           |   3 +
 arch/arm64/include/asm/hyp_image.h       |  29 +-
 arch/arm64/include/asm/kvm_asm.h         |  26 --
 arch/arm64/include/asm/kvm_host.h        |   2 +
 arch/arm64/include/asm/kvm_mmu.h         |  61 ++---
 arch/arm64/include/asm/kvm_pgtable.h     |   5 +
 arch/arm64/include/asm/sections.h        |   3 +-
 arch/arm64/include/asm/sysreg.h          |   3 +
 arch/arm64/kernel/image-vars.h           |   1 -
 arch/arm64/kernel/smp.c                  |   4 +-
 arch/arm64/kernel/vmlinux.lds.S          |  18 +-
 arch/arm64/kvm/Makefile                  |   2 +-
 arch/arm64/kvm/arm.c                     |  10 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h  |   4 +-
 arch/arm64/kvm/hyp/nvhe/.gitignore       |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile         |  33 ++-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c     | 438 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S           |  29 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S       |  19 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |  11 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S        |   9 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  37 ++-
 arch/arm64/kvm/hyp/pgtable.c             |  83 +++---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/hypercalls.c              |   6 +
 arch/arm64/kvm/mmu.c                     |  13 +-
 arch/arm64/kvm/pmu-emul.c                |  24 +-
 arch/arm64/kvm/sys_regs.c                | 178 ++++++++-----
 arch/arm64/kvm/trng.c                    |  85 ++++++
 arch/arm64/kvm/va_layout.c               |  34 ++-
 include/asm-generic/export.h             |   2 +-
 include/linux/arm-smccc.h                |  31 +++
 virt/kvm/kvm_main.c                      |   1 +
 34 files changed, 934 insertions(+), 278 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
 create mode 100644 arch/arm64/kvm/trng.c
