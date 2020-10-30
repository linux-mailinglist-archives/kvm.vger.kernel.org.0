Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088712A0B5B
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgJ3Qk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgJ3Qk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:40:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 692BA20756;
        Fri, 30 Oct 2020 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076025;
        bh=5IdJB+vSy9WtqFoTUhuMK/Ne2TdAtmbDZodcpICYmnU=;
        h=From:To:Cc:Subject:Date:From;
        b=mY2QczB+bo87U8fMn7qv4VHllqSccKIUuhsW02/aX4Yuj8hqMHxzWIpI/pbvM9juv
         TIJ34uxNPzi5eMZdtSGLXP7Rq5BKtOojZdB/xkk1SA9Aoe32WIxPEu2mkS0OK998DC
         PcLczwkdcqVxVXvgyHHQBRK9HdIjhMRqE5f0cSfs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXRu-005noK-96; Fri, 30 Oct 2020 16:40:22 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.10, take #1
Date:   Fri, 30 Oct 2020 16:40:05 +0000
Message-Id: <20201030164017.244287-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Apologies for the spam, I appear to have forgotten to Cc the lists in
 my initial posting]

Hi Paolo,

It was good to see you (and everyone else) at KVM Forum this week!

And to celebrate, here's a first batch of fixes for KVM/arm64. A bunch
of them are addressing issues introduced by the invasive changes that
took place in the 5.10 merge window (MM, nVHE host entry). A few
others are addressing some older bugs (VFIO PTE mappings, AArch32
debug, composite huge pages), and a couple of improvements
(HYP-visible capabilities are made more robust).

Please pull,

	M.

The following changes since commit 4e5dc64c43192b4fd4c96ac150a8f013065f5f5b:

  Merge branches 'kvm-arm64/pt-new' and 'kvm-arm64/pmu-5.9' into kvmarm-master/next (2020-10-02 09:25:55 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-1

for you to fetch changes up to 22f553842b14a1289c088a79a67fb479d3fa2a4e:

  KVM: arm64: Handle Asymmetric AArch32 systems (2020-10-30 16:06:22 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.10, take #1

- Force PTE mapping on device pages provided via VFIO
- Fix detection of cacheable mapping at S2
- Fallback to PMD/PTE mappings for composite huge pages
- Fix accounting of Stage-2 PGD allocation
- Fix AArch32 handling of some of the debug registers
- Simplify host HYP entry
- Fix stray pointer conversion on nVHE TLB invalidation
- Fix initialization of the nVHE code
- Simplify handling of capabilities exposed to HYP
- Nuke VCPUs caught using a forbidden AArch32 EL0

----------------------------------------------------------------
Gavin Shan (1):
      KVM: arm64: Use fallback mapping sizes for contiguous huge page sizes

Marc Zyngier (4):
      KVM: arm64: Don't corrupt tpidr_el2 on failed HVC call
      KVM: arm64: Remove leftover kern_hyp_va() in nVHE TLB invalidation
      KVM: arm64: Drop useless PAN setting on host EL1 to EL2 transition
      KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR

Mark Rutland (3):
      KVM: arm64: Factor out is_{vhe,nvhe}_hyp_code()
      arm64: cpufeature: reorder cpus_have_{const, final}_cap()
      arm64: cpufeature: upgrade hyp caps to final

Qais Yousef (1):
      KVM: arm64: Handle Asymmetric AArch32 systems

Santosh Shukla (1):
      KVM: arm64: Force PTE mapping on fault resulting in a device mapping

Will Deacon (2):
      KVM: arm64: Allocate stage-2 pgd pages with GFP_KERNEL_ACCOUNT
      KVM: arm64: Fix masks in stage2_pte_cacheable()

 arch/arm64/include/asm/cpufeature.h | 40 ++++++++++++++++++++++++++++---------
 arch/arm64/include/asm/kvm_host.h   |  1 +
 arch/arm64/include/asm/virt.h       |  9 ++++-----
 arch/arm64/kernel/image-vars.h      |  1 -
 arch/arm64/kvm/arm.c                | 19 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S      |  2 --
 arch/arm64/kvm/hyp/nvhe/hyp-init.S  | 23 ++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/tlb.c       |  1 -
 arch/arm64/kvm/hyp/pgtable.c        |  4 ++--
 arch/arm64/kvm/mmu.c                | 27 ++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.c           |  6 +++---
 11 files changed, 96 insertions(+), 37 deletions(-)
