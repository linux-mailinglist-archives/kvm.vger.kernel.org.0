Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822DA2DD2B4
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgLQOOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:14:55 -0500
Received: from foss.arm.com ([217.140.110.172]:38384 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgLQOOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 09:14:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C53D30E;
        Thu, 17 Dec 2020 06:14:09 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D1DB3F66B;
        Thu, 17 Dec 2020 06:14:08 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, eric.auger@redhat.com, yuzenghui@huawei.com
Subject: [kvm-unit-tests PATCH v2 00/12] GIC fixes and improvements
Date:   Thu, 17 Dec 2020 14:13:48 +0000
Message-Id: <20201217141400.106137-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

What started this series is Andre's SPI and group interrupts tests [1],
which prompted me to attempt to rewrite check_acked() so it's more flexible
and not so complicated to review. When I was doing that I noticed that the
message passing pattern for accesses to the acked, bad_irq and bad_sender
arrays didn't look quite right, and that turned into the first 7 patches of
the series. Even though the diffs are relatively small, they are not
trivial and the reviewer can skip them for the more palatable patches that
follow. I would still appreciate someone having a look at the memory
ordering fixes.

Patch #8 ("Split check_acked() into two functions") is where check_acked()
is reworked with an eye towards supporting different timeout values or
silent reporting without adding too many arguments to check_acked().

After changing the IPI tests, I turned my attention to the LPI tests, which
followed the same memory synchronization patterns, but invented their own
interrupt handler and testing functions. Instead of redoing the work that I
did for the IPI tests, I decided to convert the LPI tests to use the same
infrastructure.

I ran tests on the following machines:

- Ampere EMAG: all arm64 tests 10,000+ times (combined) under qemu and
  kvmtool.

- rockpro64: the arm GICv2 and GICv3 tests 10,000+ times under kvmtool (I
  chose kvmtool because it's faster than qemu); the arm64 gic tests (GICv2
  and GICv3) 5000+ times with qemu (didn't realize that ./run_tests.sh -g
  gic doesn't include the its tests); the arm64 GICv2 and GICv3 and ITS
  tests under kvmtool 13,000+ times.

I  didn't see any issues.

Changes in v2:

* Gathered Reviewed-by tags, thank you for the feedback!

* Modified code comments in #1 ("lib: arm/arm64: gicv3: Add missing barrier
  when sending IPIs") as per review suggestions.

* Moved the barrier() in gicv2_ipi_send_self() from #3 ("arm/arm64: gic:
  Remove memory synchronization from ipi_clear_active_handler()") to #2
  ("lib: arm/arm64: gicv2: Add missing barrier when sending IPIs").

* Renamed #3, changed "[..] Remove memory synchronization [..]" to
  "[..] Remove SMP synchronization [..]".

* Moved the removal of smp_rmb() from check_spurious() from #5 ("arm/arm64:
  gic: Use correct memory ordering for the IPI test") to patch #7
  ("arm/arm64: gic: Wait for writes to acked or spurious to complete").

* Fixed typos in #8 ("arm/arm64: gic: Split check_acked() into two
  functions").

* Patch #10 ("arm64: gic: its-trigger: Don't trigger the LPI while it is
  pending") is new. It was added to fix an issue found in v1 [2].

* Patch #11 ("lib: arm64: gic-v3-its: Add wmb() barrier before INT
  command") is also new; it was split from #12 ("arm64: gic: Use IPI test
  checking for the LPI tests") following review comments.

* Removed the now redundant call to stats_reset() from its_prerequisites()
  in #12 ("arm64: gic: Use IPI test checking for the LPI tests").

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-November/037853.html
[2] https://www.spinics.net/lists/kvm-arm/msg43628.html

Alexandru Elisei (12):
  lib: arm/arm64: gicv3: Add missing barrier when sending IPIs
  lib: arm/arm64: gicv2: Add missing barrier when sending IPIs
  arm/arm64: gic: Remove SMP synchronization from
    ipi_clear_active_handler()
  arm/arm64: gic: Remove unnecessary synchronization with stats_reset()
  arm/arm64: gic: Use correct memory ordering for the IPI test
  arm/arm64: gic: Check spurious and bad_sender in the active test
  arm/arm64: gic: Wait for writes to acked or spurious to complete
  arm/arm64: gic: Split check_acked() into two functions
  arm/arm64: gic: Make check_acked() more generic
  arm64: gic: its-trigger: Don't trigger the LPI while it is pending
  lib: arm64: gic-v3-its: Add wmb() barrier before INT command
  arm64: gic: Use IPI test checking for the LPI tests

 lib/arm/gic-v2.c           |   4 +
 lib/arm/gic-v3.c           |   6 +
 lib/arm64/gic-v3-its-cmd.c |   6 +
 arm/gic.c                  | 341 ++++++++++++++++++++-----------------
 4 files changed, 197 insertions(+), 160 deletions(-)

-- 
2.29.2

