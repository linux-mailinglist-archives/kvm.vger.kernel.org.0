Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039A387368
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405809AbfHIHs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:48:59 -0400
Received: from foss.arm.com ([217.140.110.172]:42742 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405737AbfHIHs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:48:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7897344;
        Fri,  9 Aug 2019 00:48:58 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 290EE3F706;
        Fri,  9 Aug 2019 00:48:57 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm updates for 5.3-rc4
Date:   Fri,  9 Aug 2019 08:48:28 +0100
Message-Id: <20190809074832.13283-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Here's a set of update for -rc4. Yet another reset fix, and two subtle
VGIC fixes for issues that can be observed in interesting corner cases.

Note that this is on top of kvmarm-fixes-for-5.3[1], which hasn't been
pulled yet. Hopefully you can pull both at the same time!

Thanks,

	M.

[1] https://lore.kernel.org/kvmarm/20190731173650.12627-1-maz@kernel.org

The following changes since commit cdb2d3ee0436d74fa9092f2df46aaa6f9e03c969:

  arm64: KVM: hyp: debug-sr: Mark expected switch fall-through (2019-07-29 11:01:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3-2

for you to fetch changes up to 16e604a437c89751dc626c9e90cf88ba93c5be64:

  KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable (2019-08-09 08:07:26 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.3, take #2

- Fix our system register reset so that we stop writing
  non-sensical values to them, and track which registers
  get reset instead.
- Sync VMCR back from the GIC on WFI so that KVM has an
  exact vue of PMR.
- Reevaluate state of HW-mapped, level triggered interrupts
  on enable.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable

Marc Zyngier (3):
      KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
      KVM: arm64: Don't write junk to sysregs on reset
      KVM: arm: Don't write junk to CP15 registers on reset

 arch/arm/kvm/coproc.c         | 23 +++++++++++++++--------
 arch/arm64/kvm/sys_regs.c     | 32 ++++++++++++++++++--------------
 include/kvm/arm_vgic.h        |  1 +
 virt/kvm/arm/arm.c            | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-v3.c   |  7 ++++++-
 virt/kvm/arm/vgic/vgic.c      | 11 +++++++++++
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 9 files changed, 88 insertions(+), 24 deletions(-)
