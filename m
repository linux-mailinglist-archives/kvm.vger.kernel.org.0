Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63756925EF
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 16:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfHSOEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 10:04:45 -0400
Received: from foss.arm.com ([217.140.110.172]:54904 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfHSOEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 10:04:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E064628;
        Mon, 19 Aug 2019 07:04:43 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD9BC3F718;
        Mon, 19 Aug 2019 07:04:41 -0700 (PDT)
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
Subject: [PATCH v2 0/9] arm64: Stolen time support
Date:   Mon, 19 Aug 2019 15:04:27 +0100
Message-Id: <20190819140436.12207-1-steven.price@arm.com>
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

NOTE: Patches 7 and 8 will conflict with Mark Rutland's series[1] cleaning
up the SMCCC conduit. I do feel that the addition of an _invoke() call
makes a number of call sites cleaner and it should be possible to
integrate both this and Mark's other cleanups.

[1] https://lore.kernel.org/linux-arm-kernel/20190809132245.43505-1-mark.rutland@arm.com/

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

Steven Price (8):
  KVM: arm64: Document PV-time interface
  KVM: arm64: Implement PV_FEATURES call
  KVM: arm64: Support stolen time reporting via shared structure
  KVM: Allow kvm_device_ops to be const
  KVM: arm64: Provide a PV_TIME device to user space
  arm/arm64: Provide a wrapper for SMCCC 1.1 calls
  arm/arm64: Make use of the SMCCC 1.1 wrapper
  arm64: Retrieve stolen time as paravirtualized guest

 Documentation/virt/kvm/arm/pvtime.txt | 100 +++++++++++++
 arch/arm/include/asm/kvm_host.h       |  21 +++
 arch/arm/kvm/Makefile                 |   2 +-
 arch/arm/kvm/handle_exit.c            |   2 +-
 arch/arm/mm/proc-v7-bugs.c            |  13 +-
 arch/arm64/include/asm/kvm_host.h     |  19 ++-
 arch/arm64/include/asm/paravirt.h     |   9 +-
 arch/arm64/include/asm/pvclock-abi.h  |  17 +++
 arch/arm64/include/uapi/asm/kvm.h     |   8 ++
 arch/arm64/kernel/cpu_errata.c        |  80 ++++-------
 arch/arm64/kernel/paravirt.c          | 147 +++++++++++++++++++
 arch/arm64/kernel/time.c              |   3 +
 arch/arm64/kvm/Kconfig                |   1 +
 arch/arm64/kvm/Makefile               |   2 +
 arch/arm64/kvm/handle_exit.c          |   4 +-
 include/kvm/arm_hypercalls.h          |  43 ++++++
 include/kvm/arm_psci.h                |   2 +-
 include/linux/arm-smccc.h             |  58 ++++++++
 include/linux/cpuhotplug.h            |   1 +
 include/linux/kvm_host.h              |   4 +-
 include/linux/kvm_types.h             |   2 +
 include/uapi/linux/kvm.h              |   2 +
 virt/kvm/arm/arm.c                    |  20 +++
 virt/kvm/arm/hypercalls.c             |  68 +++++++++
 virt/kvm/arm/psci.c                   |  84 +----------
 virt/kvm/arm/pvtime.c                 | 194 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                   |   6 +-
 27 files changed, 758 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 virt/kvm/arm/hypercalls.c
 create mode 100644 virt/kvm/arm/pvtime.c

-- 
2.20.1

