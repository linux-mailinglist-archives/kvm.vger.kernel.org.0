Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865502A2FFB
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgKBQlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:41:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgKBQlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:41:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E3922268;
        Mon,  2 Nov 2020 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604335266;
        bh=AKPTmBGR7HuRbCkpQNhVUn0IRnXZ4Ipp9VnCLd/kbeU=;
        h=From:To:Cc:Subject:Date:From;
        b=Qj/OZTxAc30QiBiKK/EZhveb4AH0QEhPqr4AgVDoped/9mrL2fy4eoZIP9V1JWlJ0
         tD6uttPP/+96AoGx9aIKoD1voLp09oBoeBYbnSOiCW1j3xcJegIFOu90YQS6292v/t
         4Po2VAKF5dYsR7qgf1nOF1j3Mxdql6uEMpcHp4DM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZctD-006jJf-VL; Mon, 02 Nov 2020 16:41:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH v2 00/11] KVM: arm64: Move PC/ELR/SPSR/PSTATE updatess to EL2
Date:   Mon,  2 Nov 2020 16:40:34 +0000
Message-Id: <20201102164045.264512-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, mark.rutland@arm.com, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we progress towards being able to keep the guest state private to
the nVHE hypervisor, this series aims at moving anything that touches
the registers involved into an exception to EL2.

The general idea is that any update to these registers is driven by a
set of flags passed from EL1 to EL2, and EL2 will deal with the
register update itself, removing the need for EL1 to see the guest
state. It also results in a bunch of cleanup, mostly in the 32bit
department (negative diffstat, yay!).

Of course, none of that has any real effect on security yet. It is
only once we start having a private VCPU structure at EL2 that we can
enforce the isolation. Similarly, there is no policy enforcement, and
a malicious EL1 can still inject exceptions at random points. It can
also give bogus ESR values to the guest. Baby steps.

        M.

* From v1 [1]
  - Fix __kvm_skip_instr() unexpected recursion
  - Fix HVC fixup updating the in-memory state instead of the guest's
  - Dropped facilities for IRQ/FIQ/SError exception injection
  - Simplified VHE/nVHE differences in exception injection
  - Moved AArch32 exception injection over to AArch64 sysregs
  - Use compat_lr_* instead of hardcoded registers
  - Schpelling fyxes

[1] https://lore.kernel.org/r/20201026133450.73304-1-maz@kernel.org

Marc Zyngier (11):
  KVM: arm64: Don't adjust PC on SError during SMC trap
  KVM: arm64: Move kvm_vcpu_trap_il_is32bit into kvm_skip_instr32()
  KVM: arm64: Make kvm_skip_instr() and co private to HYP
  KVM: arm64: Move PC rollback on SError to HYP
  KVM: arm64: Move VHE direct sysreg accessors into kvm_host.h
  KVM: arm64: Add basic hooks for injecting exceptions from EL2
  KVM: arm64: Inject AArch64 exceptions from HYP
  KVM: arm64: Inject AArch32 exceptions from HYP
  KVM: arm64: Remove SPSR manipulation primitives
  KVM: arm64: Consolidate exception injection
  KVM: arm64: Get rid of the AArch32 register mapping code

 arch/arm64/include/asm/kvm_emulate.h       |  70 +----
 arch/arm64/include/asm/kvm_host.h          | 118 +++++++-
 arch/arm64/kvm/Makefile                    |   4 +-
 arch/arm64/kvm/aarch32.c                   | 232 ---------------
 arch/arm64/kvm/guest.c                     |  28 +-
 arch/arm64/kvm/handle_exit.c               |  23 +-
 arch/arm64/kvm/hyp/aarch32.c               |   4 +-
 arch/arm64/kvm/hyp/exception.c             | 331 +++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  62 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  17 ++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |   3 +
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |   2 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c            |   2 +
 arch/arm64/kvm/hyp/vhe/Makefile            |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |   3 +
 arch/arm64/kvm/inject_fault.c              | 189 +++++-------
 arch/arm64/kvm/mmio.c                      |   2 +-
 arch/arm64/kvm/mmu.c                       |   2 +-
 arch/arm64/kvm/regmap.c                    | 224 --------------
 arch/arm64/kvm/sys_regs.c                  |  83 +-----
 21 files changed, 666 insertions(+), 737 deletions(-)
 delete mode 100644 arch/arm64/kvm/aarch32.c
 create mode 100644 arch/arm64/kvm/hyp/exception.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
 delete mode 100644 arch/arm64/kvm/regmap.c

-- 
2.28.0

