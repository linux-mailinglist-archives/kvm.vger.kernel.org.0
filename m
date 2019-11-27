Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D602E10B12E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfK0OZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:06 -0500
Received: from foss.arm.com ([217.140.110.172]:48170 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfK0OZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07DD831B;
        Wed, 27 Nov 2019 06:25:05 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D9FA33F68E;
        Wed, 27 Nov 2019 06:25:03 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH 00/18] Various fixes
Date:   Wed, 27 Nov 2019 14:23:52 +0000
Message-Id: <20191127142410.1994-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a combination of the fixes from my EL2 series [1] and other new
fixes.

Summary of the patches:
* Patch 1 adds coherent translation table walks for ARMv7 and removes
  unneeded dcache maintenance.
* Patches 2-4 make translation table updates more robust.
* Patches 5-6 fix a pretty serious bug in our PSCI test, which was causing
  an infinite loop of prefetch aborts.
* Patches 7-10 add a proper test for prefetch aborts. The test now uses
  mmu_clear_user.
* Patches 11-13 are fixes for the timer test.
* Patches 14-15 fix turning the MMU off.
* Patches 16-18 are small fixes to make the code more robust, and perhaps
  more important, remove unnecessary operations that might hide real bugs
  in KVM.

Patches 1-4, 9, 18 are new. The rest are taken from the EL2 series, and
I've kept the Reviewed-by tag where appropriate. There are no major
changes, only those caused by rebasing on top of the current kvm-unit-tests
version.

Please review.

[1] https://www.spinics.net/lists/kvm/msg196797.html

Alexandru Elisei (18):
  lib: arm/arm64: Remove unnecessary dcache maintenance operations
  lib: arm64: Remove barriers before TLB operations
  lib: Add WRITE_ONCE and READ_ONCE implementations in compiler.h
  lib: arm/arm64: Use WRITE_ONCE to update the translation tables
  lib: arm/arm64: Remove unused CPU_OFF parameter
  arm/arm64: psci: Don't run C code without stack or vectors
  lib: arm/arm64: Add missing include for alloc_page.h in pgtable.h
  lib: arm: Implement flush_tlb_all
  lib: arm/arm64: Teach mmu_clear_user about block mappings
  arm/arm64: selftest: Add prefetch abort test
  arm64: timer: Write to ICENABLER to disable timer IRQ
  arm64: timer: EOIR the interrupt after masking the timer
  arm64: timer: Test behavior when timer disabled or masked
  lib: arm/arm64: Refuse to disable the MMU with non-identity stack
    pointer
  arm/arm64: Perform dcache clean + invalidate after turning MMU off
  arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
  arm/arm64: Invalidate TLB before enabling MMU
  arm: cstart64.S: Remove icache invalidation from asm_mmu_enable

 lib/linux/compiler.h          | 81 +++++++++++++++++++++++++++++
 lib/arm/asm/gic-v3.h          |  1 +
 lib/arm/asm/gic.h             |  1 +
 lib/arm/asm/mmu-api.h         |  2 +-
 lib/arm/asm/mmu.h             | 11 ++--
 lib/arm/asm/pgtable-hwdef.h   | 11 ++++
 lib/arm/asm/pgtable.h         | 20 ++++++--
 lib/arm/asm/processor.h       |  6 +++
 lib/arm64/asm/esr.h           |  3 ++
 lib/arm64/asm/mmu.h           |  2 -
 lib/arm64/asm/pgtable-hwdef.h |  3 ++
 lib/arm64/asm/pgtable.h       | 15 +++++-
 lib/arm64/asm/processor.h     |  6 +++
 lib/arm/mmu.c                 | 64 ++++++++++++++---------
 lib/arm/processor.c           | 10 ++++
 lib/arm/psci.c                |  4 +-
 lib/arm/setup.c               |  2 +
 lib/arm64/processor.c         | 11 ++++
 arm/cstart.S                  | 40 ++++++++++++++-
 arm/cstart64.S                | 35 +++++++++++--
 arm/cache.c                   |  3 +-
 arm/psci.c                    |  5 +-
 arm/selftest.c                | 97 +++++++++++++++++++++++++++++++++--
 arm/timer.c                   | 38 +++++++++-----
 24 files changed, 406 insertions(+), 65 deletions(-)
 create mode 100644 lib/linux/compiler.h

-- 
2.20.1

