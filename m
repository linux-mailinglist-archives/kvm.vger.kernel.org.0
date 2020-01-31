Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D214F0A7
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgAaQiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:08 -0500
Received: from foss.arm.com ([217.140.110.172]:37306 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgAaQiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C036FFEC;
        Fri, 31 Jan 2020 08:38:07 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BCDE33F68E;
        Fri, 31 Jan 2020 08:38:06 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 00/10] arm/arm64: Various fixes
Date:   Fri, 31 Jan 2020 16:37:18 +0000
Message-Id: <20200131163728.5228-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are the patches that were left unmerged from the previous version of
the series, plus a few new patches. Patch #1 "Makefile: Use
no-stack-protector compiler options" is straightforward and came about
because of a compile error I experienced on RockPro64.

Patches #3 and #5 are the result of Andre's comments on the previous
version. When adding ISBs after register writes I noticed in the ARM ARM
that a read of the timer counter value can be reordered, and patch #4
tries to avoid that.

Patch #7 is also the result of a review comment. For the GIC tests, we wait
up to 5 seconds for the interrupt to be asserted. However, the GIC tests
can use more than one CPU, which is not the case with the timer test. And
waiting for the GIC to assert the interrupt can happen up to 6 times (8
times after patch #9), so I figured that a timeout of 10 seconds for the
test is acceptable.

Patch #8 tries to improve the way we test how the timer generates the
interrupt. If the GIC asserts the timer interrupt, but the device itself is
not generating it, that's a pretty big problem.

Ran the same tests as before:

- with kvmtool, on an arm64 host kernel: 64 and 32 bit tests, with GICv3
  (on an Ampere eMAG) and GICv2 (on a AMD Seattle box).

- with qemu, on an arm64 host kernel:
    a. with accel=kvm, 64 and 32 bit tests, with GICv3 (Ampere eMAG) and
       GICv2 (Seattle).
    b. with accel=tcg, 64 and 32 bit tests, on the Ampere eMAG machine.

Changes:
* Patches #1, #3, #4, #5, #7, #8 are new.
* For patch #2, as per Drew's suggestion, I changed the entry point to halt
  because the test is supposed to test if CPU_ON is successful.
* Removed the ISB from patch #6 because that was fixed by #3.
* Moved the architecture dependent function init_dcache_line_size to
  cpu_init in lib/arm/setup.c as per Drew's suggestion.

Alexandru Elisei (10):
  Makefile: Use no-stack-protector compiler options
  arm/arm64: psci: Don't run C code without stack or vectors
  arm64: timer: Add ISB after register writes
  arm64: timer: Add ISB before reading the counter value
  arm64: timer: Make irq_received volatile
  arm64: timer: EOIR the interrupt after masking the timer
  arm64: timer: Wait for the GIC to sample timer interrupt state
  arm64: timer: Check the timer interrupt state
  arm64: timer: Test behavior when timer disabled or masked
  arm/arm64: Perform dcache clean + invalidate after turning MMU off

 Makefile                  |  4 +-
 lib/arm/asm/processor.h   | 13 +++++++
 lib/arm64/asm/processor.h | 12 ++++++
 lib/arm/setup.c           |  8 ++++
 arm/cstart.S              | 22 +++++++++++
 arm/cstart64.S            | 23 ++++++++++++
 arm/psci.c                | 15 ++++++--
 arm/timer.c               | 79 ++++++++++++++++++++++++++++++++-------
 arm/unittests.cfg         |  2 +-
 9 files changed, 158 insertions(+), 20 deletions(-)

-- 
2.20.1

