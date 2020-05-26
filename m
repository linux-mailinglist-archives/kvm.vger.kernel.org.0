Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC81B43BB
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgDVMA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgDVMA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:00:57 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45B3D20780;
        Wed, 22 Apr 2020 12:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587556856;
        bh=cjNtiZiSfG8NCNGrLmoyucuhnBDcnLMQHlTpx9c+/rQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NCoygnjpF76Otji5EmVvuJDE0QdIRz2Fim66ksOD9SzJprbT6vIp/3C0kUNbb2y0G
         P9h/3TxTnhcDvtYzGc6pmq++7JXvFqDt+tJaQXnvjuTvkCcJQecQrAZYj8mqCiCZsx
         laibgAPSq3EHmqsHQ6zH+wY4BjvSqpearnncm5PY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE3i-005UI7-JR; Wed, 22 Apr 2020 13:00:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 00/26] KVM: arm64: Preliminary NV patches
Date:   Wed, 22 Apr 2020 13:00:24 +0100
Message-Id: <20200422120050.3693593-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

In order not to repeat the 90+ patch series that resulted in a
deafening silence last time, I've extracted a smaller set of patches
that form the required dependencies that allow the rest of the 65 NV
patches to be added on top. Yes, it is that bad.

The one real feature here is support for the ARMv8.4-TTL extension at
Stage-2 only. The reason to support it is that it helps the hypervisor
a lot when it comes to finding out how much to invalidate. It is thus
always "supported" with NV.

The rest doesn't contain any functionality change. Most of it reworks
existing data structures and adds new accessors for the things that
get moved around. The reason for this is that:

- With NV, we end-up with multiple Stage-2 MMU contexts per VM instead
  of a single one. This requires we divorce struct kvm from the S2 MMU
  configuration. Of course, we stick with a single MMU context for now.

- With ARMv8.4-NV, a number of system register accesses are turned
  into memory accesses into the so-called VNCR page. It is thus
  convenient to make this VNCR page part of the vcpu context and avoid
  copying data back and forth. For this to work, we need to make sure
  that all the VNCR-aware sysregs are moved into our per-vcpu sys_regs
  array instead of leaving in other data structures (the timers, for
  example). The VNCR page itself isn't introduced with these patches.

- As some of these data structures change, we need a way to isolate
  the userspace ABI from such change.

- The exception generation code is also reworked to prepare the
  addition of EL2 exceptions.

There is also a number of cleanups that were in the full fat series
that I decided to move early to get them out of the way.

The whole this is a bit of a mix of vaguely unrelated "stuff", but it
all comes together if you look at the final series[1]. This applies on
top of v5.7-rc1.

I haven't applied any of the Tested-by: tags, as the series keeps
changing. Please keep testing though!

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-5.7-rc1-WIP

Christoffer Dall (2):
  KVM: arm64: Factor out stage 2 page table data from struct kvm
  KVM: arm64: vgic-v3: Take cpu_if pointer directly instead of vcpu

Marc Zyngier (24):
  KVM: arm64: Check advertised Stage-2 page size capability
  KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
  arm64: Detect the ARMv8.4 TTL feature
  arm64: Document SW reserved PTE/PMD bits in Stage-2 descriptors
  arm64: Add level-hinted TLB invalidation helper
  KVM: arm64: Add a level hint to __kvm_tlb_flush_vmid_ipa
  KVM: arm64: Use TTL hint in when invalidating stage-2 translations
  KVM: arm64: Refactor vcpu_{read,write}_sys_reg
  KVM: arm64: Add missing reset handlers for PMU emulation
  KVM: arm64: Move sysreg reset check to boot time
  KVM: arm64: Introduce accessor for ctxt->sys_reg
  KVM: arm64: hyp: Use ctxt_sys_reg/__vcpu_sys_reg instead of raw
    sys_regs access
  KVM: arm64: sve: Use __vcpu_sys_reg() instead of raw sys_regs access
  KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw sys_regs access
  KVM: arm64: debug: Use ctxt_sys_reg() instead of raw sys_regs access
  KVM: arm64: Don't use empty structures as CPU reset state
  KVM: arm64: Make struct kvm_regs userspace-only
  KVM: arm64: Move ELR_EL1 to the system register array
  KVM: arm64: Move SP_EL1 to the system register array
  KVM: arm64: Disintegrate SPSR array
  KVM: arm64: Move SPSR_EL1 to the system register array
  KVM: arm64: timers: Rename kvm_timer_sync_hwstate to
    kvm_timer_sync_user
  KVM: arm64: timers: Move timer registers to the sys_regs file
  KVM: arm64: Parametrize exception entry with a target EL

 arch/arm64/include/asm/cpucaps.h        |   3 +-
 arch/arm64/include/asm/kvm_asm.h        |   6 +-
 arch/arm64/include/asm/kvm_emulate.h    |  37 +---
 arch/arm64/include/asm/kvm_host.h       |  71 +++++--
 arch/arm64/include/asm/kvm_hyp.h        |  30 +--
 arch/arm64/include/asm/kvm_mmu.h        |  27 ++-
 arch/arm64/include/asm/pgtable-hwdef.h  |   2 +
 arch/arm64/include/asm/stage2_pgtable.h |   9 +
 arch/arm64/include/asm/sysreg.h         |   4 +
 arch/arm64/include/asm/tlbflush.h       |  30 +++
 arch/arm64/kernel/asm-offsets.c         |   3 +-
 arch/arm64/kernel/cpufeature.c          |  19 ++
 arch/arm64/kvm/fpsimd.c                 |   6 +-
 arch/arm64/kvm/guest.c                  |  79 ++++++-
 arch/arm64/kvm/handle_exit.c            |  17 +-
 arch/arm64/kvm/hyp/debug-sr.c           |  18 +-
 arch/arm64/kvm/hyp/entry.S              |   3 +-
 arch/arm64/kvm/hyp/switch.c             |  31 ++-
 arch/arm64/kvm/hyp/sysreg-sr.c          | 160 +++++++-------
 arch/arm64/kvm/hyp/tlb.c                |  51 +++--
 arch/arm64/kvm/inject_fault.c           |  75 +++----
 arch/arm64/kvm/regmap.c                 |  37 +++-
 arch/arm64/kvm/reset.c                  |  60 ++++--
 arch/arm64/kvm/sys_regs.c               | 215 ++++++++++---------
 include/kvm/arm_arch_timer.h            |  13 +-
 include/kvm/arm_vgic.h                  |   5 +-
 virt/kvm/arm/arch_timer.c               | 157 +++++++++++---
 virt/kvm/arm/arm.c                      |  40 ++--
 virt/kvm/arm/hyp/vgic-v3-sr.c           |  33 +--
 virt/kvm/arm/mmu.c                      | 267 +++++++++++++-----------
 virt/kvm/arm/trace.h                    |   8 +-
 virt/kvm/arm/vgic/vgic-v2.c             |  10 +-
 virt/kvm/arm/vgic/vgic-v3.c             |  14 +-
 virt/kvm/arm/vgic/vgic.c                |  25 ++-
 34 files changed, 942 insertions(+), 623 deletions(-)

-- 
2.26.1

