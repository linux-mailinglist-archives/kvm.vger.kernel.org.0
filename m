Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0FE97EEF
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfHUPhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 11:37:14 -0400
Received: from foss.arm.com ([217.140.110.172]:60322 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbfHUPhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 11:37:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C3FB337;
        Wed, 21 Aug 2019 08:37:13 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 609123F718;
        Wed, 21 Aug 2019 08:37:11 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/10] arm64: Stolen time support
Date:   Wed, 21 Aug 2019 16:36:46 +0100
Message-Id: <20190821153656.33429-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series add support for paravirtualized time for arm64 guests and
KVM hosts following the specification in Arm's document DEN 0057A:

https://developer.arm.com/docs/den0057/a

It implements support for stolen time, allowing the guest to
identify time when it is forcibly not executing.

It doesn't implement support for Live Physical Time (LPT) as there are
some concerns about the overheads and approach in the above
specification, and I expect an updated version of the specification to
be released soon with just the stolen time parts.

NOTE: Patches 8 and 9 will conflict with Mark Rutland's series[1] cleaning
up the SMCCC conduit. I do feel that the addition of an _invoke() call
makes a number of call sites cleaner and it should be possible to
integrate both this and Mark's other cleanups.

[1] https://lore.kernel.org/linux-arm-kernel/20190809132245.43505-1-mark.rutland@arm.com/

Also available as a git tree:
git://linux-arm.org/linux-sp.git stolen_time/v3

Changes from v2:
https://lore.kernel.org/lkml/20190819140436.12207-1-steven.price@arm.com/
 * Switched from using gfn_to_hva_cache to a new macro kvm_put_guest()
   that can provide the single-copy atomicity required (on arm64). This
   macro is added in patch 4.
 * Tidied up the locking for kvm_update_stolen_time().
   pagefault_disable() was unnecessary and the caller didn't need to
   take kvm->srcu as the function does it itself.
 * Removed struct kvm_arch_pvtime from the arm implementation, replaced
   instead with inline static functions which are empty for arm.
 * Fixed a few checkpatch --strict warnings.

Changes from v1:
https://lore.kernel.org/lkml/20190802145017.42543-1-steven.price@arm.com/
 * Host kernel no longer allocates the stolen time structure, instead it
   is allocated by user space. This means the save/restore functionality
   can be removed.
 * Refactored the code so arm has stub implementations and to avoid
   initcall
 * Rebased to pick up Documentation/{virt->virtual} change
 * Bunch of typo fixes

Christoffer Dall (1):
  KVM: arm/arm64: Factor out hypercall handling from PSCI code

Steven Price (9):
  KVM: arm64: Document PV-time interface
  KVM: arm64: Implement PV_FEATURES call
  KVM: Implement kvm_put_guest()
  KVM: arm64: Support stolen time reporting via shared structure
  KVM: Allow kvm_device_ops to be const
  KVM: arm64: Provide a PV_TIME device to user space
  arm/arm64: Provide a wrapper for SMCCC 1.1 calls
  arm/arm64: Make use of the SMCCC 1.1 wrapper
  arm64: Retrieve stolen time as paravirtualized guest

 Documentation/virt/kvm/arm/pvtime.txt | 100 ++++++++++++++
 arch/arm/include/asm/kvm_host.h       |  30 +++++
 arch/arm/kvm/Makefile                 |   2 +-
 arch/arm/kvm/handle_exit.c            |   2 +-
 arch/arm/mm/proc-v7-bugs.c            |  13 +-
 arch/arm64/include/asm/kvm_host.h     |  28 +++-
 arch/arm64/include/asm/paravirt.h     |   9 +-
 arch/arm64/include/asm/pvclock-abi.h  |  17 +++
 arch/arm64/include/uapi/asm/kvm.h     |   8 ++
 arch/arm64/kernel/cpu_errata.c        |  80 ++++-------
 arch/arm64/kernel/paravirt.c          | 148 +++++++++++++++++++++
 arch/arm64/kernel/time.c              |   3 +
 arch/arm64/kvm/Kconfig                |   1 +
 arch/arm64/kvm/Makefile               |   2 +
 arch/arm64/kvm/handle_exit.c          |   4 +-
 include/kvm/arm_hypercalls.h          |  43 ++++++
 include/kvm/arm_psci.h                |   2 +-
 include/linux/arm-smccc.h             |  58 ++++++++
 include/linux/cpuhotplug.h            |   1 +
 include/linux/kvm_host.h              |  28 +++-
 include/linux/kvm_types.h             |   2 +
 include/uapi/linux/kvm.h              |   2 +
 virt/kvm/arm/arm.c                    |  11 ++
 virt/kvm/arm/hypercalls.c             |  68 ++++++++++
 virt/kvm/arm/psci.c                   |  84 +-----------
 virt/kvm/arm/pvtime.c                 | 182 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                   |   6 +-
 27 files changed, 780 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 virt/kvm/arm/hypercalls.c
 create mode 100644 virt/kvm/arm/pvtime.c

-- 
2.20.1

