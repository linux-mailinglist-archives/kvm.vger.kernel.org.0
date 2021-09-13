Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79B40A15D
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349726AbhIMXMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349316AbhIMXL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD8CC061762
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 131-20020a251489000000b0059bdeb10a84so15050801ybu.15
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AejLs9aVC/boLaGWx5dhQOuvfu5QcQg2e7Q1Pv3t0nk=;
        b=VYfO//Mv8fz7BeCUQSwXaZE3kTuDgbr/8p68/Pa6AGtZ5fOIxOa8DU9XaGK6I9HAJo
         YO6qnkmbY7FCXeD7lnjLFbsSUNlvScES3rwNo5eOUtkrJZTWUheXzsCLfiPV+IiLY+fU
         ozoGyNMvoBSrICQ7jb395jtYeNDPQVL50L7RmJigo/3m3FwFmNn3zFgO7aF5+iF7m8xm
         XENhy2+kUK0NhwFN6y+NUJzk/sHe6vSBJdwH1QiM1GecHQZmcJq02DhO759580A0KIrq
         HDFJcaAFtUqV8/Sc0FB0oWooKdna0c4X1At2Uk5jVOUN7PH416a76ns/Z+fCfB4wWJjR
         +7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AejLs9aVC/boLaGWx5dhQOuvfu5QcQg2e7Q1Pv3t0nk=;
        b=Yhu/tvHdf5gwPYQAaXUqpp2ZbcTrIgRBS4Mi8T5o0whlkKAVIo3JwLV4iKqhHzDtUg
         ao0ErwOqT8WJUT2SjZitn6WAZydx1b/FzNbZmbu8D9aYc2RURjlBIg9/vS3liNH8+tYz
         TZvxJRBzocZ214onVEsOfo5WQIXmkRp1fEZpAz7lJ/w1m/USYPMGU0CnbtgaeYHYNDHi
         H3VXfq4gC68J5Do38XQd1CodCWMOMY/L4lTvPw2iblkNpFtkCLJR8GBhi9uIEkS+q4BO
         4RmVp5NfoH3iY/7s0OGxnkJXXdMLiXePAmWdNTfqBRrGLsphPN3q2unkjd+M7GPNyO0N
         4k5g==
X-Gm-Message-State: AOAM530Cg3gpSVzhXinhNioT+XifNQHxNZkYzkkyi/yKX92F/vO0EVFa
        MSnyLbBT3pQ/eI2keG7bbCNfNodnslyR
X-Google-Smtp-Source: ABdhPJx87pW9Ied8bxMGtkKpQrFGORk9JFZeLQcy/JswJuk8sx2ITO8wKRoc9NocnvcEVCEdYo5L20q+qd9s
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c88:: with SMTP id 130mr18342376ybm.176.1631574599765;
 Mon, 13 Sep 2021 16:09:59 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:41 +0000
Message-Id: <20210913230955.156323-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 00/14] KVM: arm64: selftests: Introduce arch_timer selftest
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The patch series adds a KVM selftest to validate the behavior of
ARM's generic timer (patch-13). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Patch-14 adds an option to randomly migrate the vCPUs to different
physical CPUs across the system. The bug for the fix provided by
Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
pending state on deactivation") was discovered using arch_timer
test with vCPU migrations.

Since the test heavily depends on interrupts, patch-12 adds a host
library to setup ARM Generic Interrupt Controller v3 (GICv3). This
includes creating a vGIC device, setting up distributor and
redistributor attributes, and mapping the guest physical addresses.
Symmetrical to this, patch-11 adds a guest library to talk to the vGIC,
which includes initializing the controller, enabling/disabling the
interrupts, and so on.

The following patches are utility patches that the above ones make use
of:
Patch-1 adds readl/writel support for guests to access MMIO space.

Patch-2 imports arch/arm64/include/asm/sysreg.h into
tools/arch/arm64/include/asm/ to make use of the register encodings
and read/write definitions.

Patch-3 is not directly related to the test, but makes
aarch64/debug-exceptions.c use the read/write definitions from the
imported sysreg.h and remove the existing definitions of read_sysreg()
and write_sysreg().

Patch-4 introduces ARM64_SYS_KVM_REG, that helps convert the SYS_*
register encodings in sysreg.h to be acceptable by get_reg() and set_reg().
It further replaces the users of ARM64_SYS_REG to use the new macro.

Patch-5 adds the support for cpu_relax().

Patch-6 adds basic arch_timer framework.

Patch-7 adds udelay() support for the guests to utilize.

Patch-8 adds local_irq_enable() and local_irq_disable() for the guests
to enable/disable interrupts.

Patch-9 adds the support to get the vcpuid for the guests. This allows
them to access any cpu-centric private data in the upcoming patches.

Patch-10 adds a light-weight support for spinlocks for the guests to
use.

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v5 -> v6:

- Corrected the syntax for write_sysreg_s in gic_v3.c (11/14) so that
  the file can be compiled with the unmodified
  arch/arm64/include/asm/sysreg.h that's imported into tools/.

v4 -> v5:

Addressed the comments by Andrew, Oliver, and Reiji (Thanks, again):
- Squashed patches 17/18 and 18/18 into 3/18 and 14/18, respectively.
- Dropped patches to keep track kvm_utils of nr_vcpus (12/18) and
  vm_get_mode() (13/18) as they were no longer needed.
- Instead of creating the a map, exporting the vcpuid to the guest
  is done by using the TPIDR_EL1 register.
- Just to be on the safer side, gic.c's gic_dist_init() explicitly
  checks if gic_ops is NULL.
- Move sysreg.h from within selftests to tool/arch/arm64/include/asm/.
- Rename ARM64_SYS_KVM_REG to KVM_ARM64_SYS_REG to improve readability.
- Use the GIC regions' sizes from asm/kvm.h instead of re-defining it
  in the vgic host support.
- Get the timer IRQ numbers via timer's device attributes
  (KVM_ARM_VCPU_TIMER_IRQ_PTIMER, KVM_ARM_VCPU_TIMER_IRQ_VTIMER) instead
  of depending on default numbers to be safe.
- Add check to see if the vCPU migrations are in fact enabled, before
  looking for at least two online physical CPUs for the test.
- Add missing blank lines in the arch_timer test.

v3 -> v4:

Addressed the comments by Andrew, Oliver, and Ricardo (Thank you):
- Reimplemented get_vcpuid() by exporting a map of vcpuid:mpidr to the
  guest.
- Import sysreg.h from arch/arm64/include/asm/sysreg.h to get the system
  register encodings and its read/write support. As a result, delete the
  existing definitions in processor.h.
- Introduce ARM64_SYS_KVM_REG that converts SYS_* register definitions
  from sysreg.h into the encodings accepted by get_reg() and set_reg().
- Hence, remove the existing encodings of system registers (CPACR_EL1,
  TCR_EL1, and friends) and replace all the its consumers throughout
  the selftests with ARM64_SYS_KVM_REG.
- Keep track of number of vCPUs in 'struct kvm_vm'.
- Add a helper method to get the KVM VM's mode.
- Modify the vGIC host function vgic_v3_setup to make use of the above
  two helper methods, which prevents it from accepting nr_vcpus as
  an argument.
- Move the definition of REDIST_REGION_ATTR_ADDR from lib/aarch64/vgic.c
  to include/aarch64/vgic.h.
- Make the selftest, vgic_init.c, use the definition of REDIST_REGION_ATTR_ADDR
  from include/aarch64/vgic.h.
- Turn ON vCPU migration by default (-m 2).
- Add pr_debug() to log vCPU migrations. Helpful for diagnosis.
- Change TEST_ASSERT(false,...) to TEST_FAIL() in the base arch_timer
  test.
- Include linux/types.h for __force definitions.
- Change the type of 'val' to 'int' in spin_lock() to match the lock
  value type.
- Fix typos in code files and comments.

v2 -> v3:

- Addressed the comments from Ricardo regarding moving the vGIC host
  support for selftests to its own library.
- Added an option (-m) to migrate the guest vCPUs to physical CPUs
  in the system.

v1 -> v2:

Addressed comments from Zenghui in include/aarch64/arch_timer.h:
- Correct the header description
- Remove unnecessary inclusion of linux/sizes.h
- Re-arrange CTL_ defines in ascending order
- Remove inappropriate 'return' from timer_set_* functions, which
  returns 'void'.

v1: https://lore.kernel.org/kvmarm/20210813211211.2983293-1-rananta@google.com/
v2: https://lore.kernel.org/kvmarm/20210818184311.517295-1-rananta@google.com/
v3: https://lore.kernel.org/kvmarm/20210901211412.4171835-1-rananta@google.com/
v4: https://lore.kernel.org/kvmarm/20210909013818.1191270-1-rananta@google.com/
v5: https://lore.kernel.org/kvmarm/20210913204930.130715-1-rananta@google.com/

Raghavendra Rao Ananta (14):
  KVM: arm64: selftests: Add MMIO readl/writel support
  tools: arm64: Import sysreg.h
  KVM: arm64: selftests: Use read/write definitions from sysreg.h
  KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add guest support to get the vcpuid
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add host support for vGIC
  KVM: arm64: selftests: Add arch_timer test
  KVM: arm64: selftests: arch_timer: Support vCPU migration

 tools/arch/arm64/include/asm/sysreg.h         | 1278 +++++++++++++++++
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/arch_timer.c        |  479 ++++++
 .../selftests/kvm/aarch64/debug-exceptions.c  |   30 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |    2 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c |    3 +-
 .../kvm/include/aarch64/arch_timer.h          |  142 ++
 .../selftests/kvm/include/aarch64/delay.h     |   25 +
 .../selftests/kvm/include/aarch64/gic.h       |   21 +
 .../selftests/kvm/include/aarch64/processor.h |   88 +-
 .../selftests/kvm/include/aarch64/spinlock.h  |   13 +
 .../selftests/kvm/include/aarch64/vgic.h      |   20 +
 .../testing/selftests/kvm/include/kvm_util.h  |    2 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   95 ++
 .../selftests/kvm/lib/aarch64/gic_private.h   |   21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  240 ++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |   70 +
 .../selftests/kvm/lib/aarch64/processor.c     |   22 +-
 .../selftests/kvm/lib/aarch64/spinlock.c      |   27 +
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   70 +
 21 files changed, 2606 insertions(+), 46 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/sysreg.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

-- 
2.33.0.309.g3052b89438-goog

