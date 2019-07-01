Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E1227ACB
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbfEWKfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:21 -0400
Received: from foss.arm.com ([217.140.101.70]:42996 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbfEWKfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3737341;
        Thu, 23 May 2019 03:35:20 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CECA73F718;
        Thu, 23 May 2019 03:35:18 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH 00/15] arm64: KVM: add SPE profiling support for guest
Date:   Thu, 23 May 2019 11:34:47 +0100
Message-Id: <20190523103502.25925-1-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series implements support for allowing KVM guests to use the Arm
Statistical Profiling Extension (SPE).

The patches are also available on a branch[1]. The last two extra
patches are for the kvmtool if someone wants to play with it.

Regards,
Sudeep

v1->v2:
	- Rebased on v5.2-rc1
	- Adjusted sysreg_elx_s macros with merged clang build support

[1] git://git.kernel.org/pub/scm/linux/kernel/git/sudeep.holla/linux.git kvm_spe

Sudeep Holla (15):
  KVM: arm64: add {read,write}_sysreg_elx_s versions for new registers
  dt-bindings: ARM SPE: highlight the need for PPI partitions on
    heterogeneous systems
  arm64: KVM: reset E2PB correctly in MDCR_EL2 when exiting the
    guest(VHE)
  arm64: KVM: define SPE data structure for each vcpu
  arm64: KVM: add access handler for SPE system registers
  arm64: KVM/VHE: enable the use PMSCR_EL12 on VHE systems
  arm64: KVM: split debug save restore across vm/traps activation
  arm64: KVM/debug: drop pmscr_el1 and use sys_regs[PMSCR_EL1] in
    kvm_cpu_context
  arm64: KVM: add support to save/restore SPE profiling buffer controls
  arm64: KVM: enable conditional save/restore full SPE profiling buffer
    controls
  arm64: KVM/debug: trap all accesses to SPE controls at EL1
  KVM: arm64: add a new vcpu device control group for SPEv1
  KVM: arm64: enable SPE support
  KVMTOOL: update_headers: Sync kvm UAPI headers with linux v5.2-rc1
  KVMTOOL: kvm: add a vcpu feature for SPEv1 support

 .../devicetree/bindings/arm/spe-pmu.txt       |   5 +-
 Documentation/virtual/kvm/devices/vcpu.txt    |  28 +++
 arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts    | 185 +++++++++++-------
 arch/arm64/configs/defconfig                  |   6 +
 arch/arm64/include/asm/kvm_host.h             |  19 +-
 arch/arm64/include/asm/kvm_hyp.h              |  26 ++-
 arch/arm64/include/uapi/asm/kvm.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   7 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/guest.c                        |   9 +
 arch/arm64/kvm/hyp/debug-sr.c                 |  98 +++++++---
 arch/arm64/kvm/hyp/switch.c                   |  18 +-
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     |  35 ++++
 include/kvm/arm_spe.h                         |  71 +++++++
 include/uapi/linux/kvm.h                      |   1 +
 virt/kvm/arm/arm.c                            |   5 +
 virt/kvm/arm/spe.c                            | 163 +++++++++++++++
 18 files changed, 570 insertions(+), 114 deletions(-)
 create mode 100644 include/kvm/arm_spe.h
 create mode 100644 virt/kvm/arm/spe.c

--
2.17.1

