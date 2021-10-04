Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953D642155D
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhJDRu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhJDRuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:50:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F2F61154;
        Mon,  4 Oct 2021 17:49:00 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5C-00EhBv-PZ; Mon, 04 Oct 2021 18:48:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 00/16]  KVM: arm64: MMIO guard PV services
Date:   Mon,  4 Oct 2021 18:48:33 +0100
Message-Id: <20211004174849.2831548-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the second version of this series initially posted at [1] that
aims at letting a guest express what it considers as MMIO, and only
let this through to userspace. Together with the guest memory made
(mostly) inaccessible to the host kernel and userspace, this allows an
implementation of a hardened IO subsystem.

A lot has been fixed/revamped/improved since the initial posting,
although I am still not pleased with the ioremap plugging on the guest
side. I'll take any idea to get rid of it!

The series is based on 5.15-rc3.

[1] https://lore.kernel.org/kvmarm/20210715163159.1480168-1-maz@kernel.org

Marc Zyngier (16):
  KVM: arm64: Generalise VM features into a set of flags
  KVM: arm64: Check for PTE valitity when checking for
    executable/cacheable
  KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
    kvm_pgtable_stage2_annotate
  KVM: arm64: Add MMIO checking infrastructure
  KVM: arm64: Plumb MMIO checking into the fault handling
  KVM: arm64: Force a full unmap on vpcu reinit
  KVM: arm64: Wire MMIO guard hypercalls
  KVM: arm64: Add tracepoint for failed MMIO guard check
  KVM: arm64: Advertise a capability for MMIO guard
  KVM: arm64: Add some documentation for the MMIO guard feature
  firmware/smccc: Call arch-specific hook on discovering KVM services
  mm/vmalloc: Add arch-specific callbacks to track io{remap,unmap}
    physical pages
  arm64: Implement ioremap/iounmap hooks calling into KVM's MMIO guard
  arm64: Enroll into KVM's MMIO guard if required
  arm64: Add a helper to retrieve the PTE of a fixmap
  arm64: Register earlycon fixmap with the MMIO guard

 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/mmio-guard.rst     |  74 ++++++++
 arch/arm/include/asm/hypervisor.h             |   1 +
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/fixmap.h               |   2 +
 arch/arm64/include/asm/hypervisor.h           |   2 +
 arch/arm64/include/asm/kvm_host.h             |  14 +-
 arch/arm64/include/asm/kvm_mmu.h              |   5 +
 arch/arm64/include/asm/kvm_pgtable.h          |  12 +-
 arch/arm64/kernel/setup.c                     |   6 +
 arch/arm64/kvm/arm.c                          |  30 ++--
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  11 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  10 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  29 ++--
 arch/arm64/kvm/hypercalls.c                   |  38 ++++
 arch/arm64/kvm/mmio.c                         |  20 ++-
 arch/arm64/kvm/mmu.c                          | 111 ++++++++++++
 arch/arm64/kvm/psci.c                         |   8 +
 arch/arm64/kvm/trace_arm.h                    |  17 ++
 arch/arm64/mm/ioremap.c                       | 162 ++++++++++++++++++
 arch/arm64/mm/mmu.c                           |  15 ++
 drivers/firmware/smccc/kvm_guest.c            |   4 +
 include/linux/arm-smccc.h                     |  28 +++
 include/linux/io.h                            |   2 +
 include/uapi/linux/kvm.h                      |   1 +
 mm/Kconfig                                    |   5 +
 mm/vmalloc.c                                  |  12 +-
 29 files changed, 575 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst

-- 
2.30.2

