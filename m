Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30871F6463
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 11:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgFKJKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 05:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgFKJKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 05:10:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A390420760;
        Thu, 11 Jun 2020 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591866608;
        bh=LEb0TmHs9BwF0am32RadcRA4RU0L0oWhcV5wOopAYI8=;
        h=From:To:Cc:Subject:Date:From;
        b=q1kTyCd8T/68YBv3CRIYzkVpMPW1eVFfsQhmwQGWah+mz+QtZQFif1Ws68NKb1Ewv
         5h33hP+50DG851IfhM3j8LD838jhq44IXS+5sTXtxTnDJ4e+bh7XESwG8QuHZGDUJE
         zliMhna5ReRYb8SpviD876yx5zB7YHXzQKgvvrPE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjJDr-0022ZT-4w; Thu, 11 Jun 2020 10:10:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.8, take #1
Date:   Thu, 11 Jun 2020 10:09:45 +0100
Message-Id: <20200611090956.1537104-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, james.morse@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's a bunch of fixes that cropped up during the merge window,
mostly falling into two categories: 32bit system register accesses,
and 64bit pointer authentication handling.

Please pull,

	M.

The following changes since commit 8f7f4fe756bd5cfef73cf8234445081385bdbf7d:

  KVM: arm64: Drop obsolete comment about sys_reg ordering (2020-05-28 13:16:57 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-1

for you to fetch changes up to 15c99816ed9396c548eed2e84f30c14caccad1f4:

  Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next (2020-06-10 19:10:40 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for Linux 5.8, take #1

* 32bit VM fixes:
  - Fix embarassing mapping issue between AArch32 CSSELR and AArch64
    ACTLR
  - Add ACTLR2 support for AArch32
  - Get rid of the useless ACTLR_EL1 save/restore
  - Fix CP14/15 accesses for AArch32 guests on BE hosts
  - Ensure that we don't loose any state when injecting a 32bit
    exception when running on a VHE host

* 64bit VM fixes:
  - Fix PtrAuth host saving happening in preemptible contexts
  - Optimize PtrAuth lazy enable
  - Drop vcpu to cpu context pointer
  - Fix sparse warnings for HYP per-CPU accesses

----------------------------------------------------------------
James Morse (3):
      KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
      KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
      KVM: arm64: Stop save/restoring ACTLR_EL1

Marc Zyngier (9):
      KVM: arm64: Flush the instruction cache if not unmapping the VM on reboot
      KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
      KVM: arm64: Handle PtrAuth traps early
      KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
      KVM: arm64: Remove host_cpu_context member from vcpu structure
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
      KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
      KVM: arm64: Move hyp_symbol_addr() to kvm_asm.h
      Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next

 arch/arm64/include/asm/kvm_asm.h     | 33 ++++++++++++++++--
 arch/arm64/include/asm/kvm_emulate.h |  6 ----
 arch/arm64/include/asm/kvm_host.h    |  9 +++--
 arch/arm64/include/asm/kvm_mmu.h     | 20 -----------
 arch/arm64/kvm/aarch32.c             | 28 ++++++++++++++++
 arch/arm64/kvm/arm.c                 | 20 ++++++-----
 arch/arm64/kvm/handle_exit.c         | 32 ++----------------
 arch/arm64/kvm/hyp/debug-sr.c        |  4 +--
 arch/arm64/kvm/hyp/switch.c          | 65 ++++++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/sysreg-sr.c       |  8 ++---
 arch/arm64/kvm/pmu.c                 |  8 ++---
 arch/arm64/kvm/sys_regs.c            | 25 +++++++-------
 arch/arm64/kvm/sys_regs_generic_v8.c | 10 ++++++
 13 files changed, 171 insertions(+), 97 deletions(-)
