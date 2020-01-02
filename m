Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CCB12E6E2
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgABNrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:47:04 -0500
Received: from foss.arm.com ([217.140.110.172]:47272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgABNrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:47:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1C641FB;
        Thu,  2 Jan 2020 05:47:03 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.9.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 88C243F68F;
        Thu,  2 Jan 2020 05:47:02 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH v3 0/7] arm64: Run at EL2
Date:   Thu,  2 Jan 2020 13:46:39 +0000
Message-Id: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARMv8.3 added support for nested virtualization, which makes it possible
for a hypervisor to run another hypervisor as a guest. Support for nested
virtualization is being worked on in KVM [1].

This patch series aims to make it possible for kvm-unit-tests to run at EL2
under KVM. The focus has been on having all the infrastructure in place to
run at EL2, and not on adding comprehensive tests for this Exception Level.
All existing tests that fulfill KVM's requirements for a nested guest (the
architecture is arm64 and they use GICv3) will be able to be run at EL2.

To keep the changes minimal, kvm-unit-tests will run with VHE enabled when
it detects that has been booted at EL2. Functions for enabling and
disabling VHE have been added, with the aim to let the user specify to
disable VHE for a given test via command-line parameters. At the moment,
only the timer test has been modified to run with VHE disabled.

The series are firmly an RFC because:
* The patches that implement KVM nested support are themselves in the RFC
  phase.
* Some tests don't complete because of bugs in the current version of the
  KVM patches. Where appropriate, I will provide fixes to allow the tests
  to finish, however those fixes are my own and have not been reviewed in
  any way. Use at your own risk.

To run the tests, one obviously needs KVM with nested virtualization
support from [2]. These patches have been tested from commit
78c66132035c ("arm64: KVM: nv: Allow userspace to request
KVM_ARM_VCPU_NESTED_VIRT"), on top of which the following patches have been
cherry-picked from upstream Linux:
* b4a1583abc83 ("KVM: arm/arm64: Fix emulated ptimer irq injection")
* 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
  interrupts on enable")

Without those two patches some timer tests will fail.

A version of kvmtool that knows about nested virtualization is also
needed [3]. The kvmtool --nested parameter is required for releasing a
guest at EL2. For example, to run the newly added selftest-el2 test:

lkvm -f selftest.flat -c 2 -m 128 -p el2 --nested --irqchip gicv3

The patches have been lightly tested on FVP by running the 64 bit tests at
EL1 and EL2, under kvmtool and with GICv3.

Changes in v3:
* Removed patches 1-12 and sent them as a separate series (currently at v3
  [4]). This series have been modified to apply on top of them. Hopefully,
  this split will make reviewing easier and help get the fixes merged
  sooner rather than later.
* Minor changes here and there, mostly cosmetical.

Changes in v2:
* Gathered Reviewed-by tags.
* Implemented review comments (more details in the specific patches).
* Patch #1 was remove and I've added 4 new patches: #1 removes the obsolete
  CPU_OFF parameter; #4 implements a TODO from arm's flush_tlb_all; #10
  fixes asm_mmu_enable; #11 replaces an expensive and unnecessary TLBI with
  the correct one.

Summary of the patches:
* Patch 1 is a trivial enhancement.
* Patches 2-4 add support for running at EL2. A basic selftest-el2 test
  is added that targets EL2.
* Patches 5-7 add support for disabling VHE. The timer and selftest-el2
  tests are modified to use this feature.

[1] https://www.spinics.net/lists/arm-kernel/msg736687.html
[2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-wip-5.2-rc5
[3] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5
[4] https://www.spinics.net/lists/kvm/msg203477.html

Alexandru Elisei (7):
  lib: Add _UL and _ULL definitions to linux/const.h
  lib: arm64: Run existing tests at EL2
  arm64: timer: Add test for EL2 timers
  arm64: selftest: Add basic test for EL2
  lib: arm64: Add support for disabling and re-enabling VHE
  arm64: selftest: Expand EL2 test to disable and re-enable VHE
  arm64: timer: Run tests with VHE disabled

 lib/linux/const.h             |   7 +-
 lib/asm-generic/page.h        |   2 +-
 lib/arm/asm/page.h            |   2 +-
 lib/arm/asm/pgtable-hwdef.h   |  22 +--
 lib/arm/asm/psci.h            |   1 +
 lib/arm/asm/thread_info.h     |   3 +-
 lib/arm64/asm/esr.h           |   2 +
 lib/arm64/asm/mmu.h           |  11 +-
 lib/arm64/asm/page.h          |   2 +-
 lib/arm64/asm/pgtable-hwdef.h |  79 +++++++----
 lib/arm64/asm/processor.h     |  28 ++++
 lib/arm64/asm/sysreg.h        |  28 ++++
 lib/x86/asm/page.h            |   2 +-
 lib/arm/psci.c                |  43 +++++-
 lib/arm/setup.c               |   4 +
 lib/arm64/processor.c         |  39 +++++-
 arm/cstart64.S                | 232 +++++++++++++++++++++++++++++++-
 arm/micro-bench.c             |  17 ++-
 arm/selftest.c                |  79 ++++++++++-
 arm/timer.c                   | 302 +++++++++++++++++++++++++++++++++++++++---
 arm/unittests.cfg             |   8 ++
 21 files changed, 830 insertions(+), 83 deletions(-)

-- 
2.7.4

