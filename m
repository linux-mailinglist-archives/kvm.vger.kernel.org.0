Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3E341CD9
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 13:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCSMY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 08:24:57 -0400
Received: from foss.arm.com ([217.140.110.172]:48398 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229927AbhCSMYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 08:24:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AC5BED1;
        Fri, 19 Mar 2021 05:24:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FEA73F70D;
        Fri, 19 Mar 2021 05:24:30 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 0/4] RFC: Minor arm/arm64 MMU fixes and checks
Date:   Fri, 19 Mar 2021 12:24:10 +0000
Message-Id: <20210319122414.129364-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prior to this set of fixes, the code in setup() which we call to
initialize the system has a circular dependency. cpu_init()
(eventually) calls spin_lock() and __mmu_enabled(). However, at this
point, __mmu_enabled() may have undefined behavior as we haven't
initialized the current thread_info (cpu field). Moving
thread_info_init() above cpu_init() is not possible as it relies on
mpidr_to_cpu() which won't return the right results before cpu_init().
In addition, mem_init() also calls __mmu_enabled() and therefore
suffers from the same problem. Right now, everything works as
thread_info maps to memory which is implicitly initialized to 0 (cpu =
0) and makes the assumption that the cpu that runs setup() will be the
first cpu in the DT.

This set of patches changes the code slightly and avoids this
assumptions. In addition, it adds assertions to catch problems like
the above. The current solution relies on the thread_info() of the cpu
that setup() run to be initialized to zero (should we make it
explicit?).

There are a couple of options I considered in addressing this issue
which didn't seem satisfactory:

- Change the mmu_disabled_count global variable to mmu_enabled_count
  to count the number of active mmu's and bypass __mmu_enabled() when
  it's 0. This is a global variable and at the momement all write to
  it are protected by a lock but it's rather fragile and could easily
  cause issues in the future.
- Explicitly initialize current_thread_info()->cpu = 0 in setup()
  before anything else or make the first call of thread_info_init() a
  special case and avoid looking up mpidr_to_cpu(). This way we can
  move thread_info_init() to the top of setup(). If the CPU setup is
  running on is not the first that appears in the DT then this
  solution won't work.

Thanks,

Nikos

Nikos Nikoleris (4):
  arm/arm64: Avoid calling cpumask_test_cpu for CPUs above nr_cpu
  arm/arm64: Read system registers to get the state of the MMU
  arm/arm64: Track whether thread_info has been initialized
  arm/arm64: Add sanity checks to the cpumask API

 lib/arm/asm/cpumask.h     |  7 ++++++-
 lib/arm/asm/mmu-api.h     |  7 +------
 lib/arm/asm/processor.h   |  7 +++++++
 lib/arm/asm/thread_info.h |  1 +
 lib/arm64/asm/processor.h |  1 +
 lib/arm/mmu.c             | 16 ++++++++--------
 lib/arm/processor.c       | 10 ++++++++--
 lib/arm64/processor.c     | 10 ++++++++--
 8 files changed, 40 insertions(+), 19 deletions(-)

-- 
2.25.1

