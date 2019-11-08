Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA5F4E67
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKHOmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:42:51 -0500
Received: from foss.arm.com ([217.140.110.172]:44510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHOmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 877E546A;
        Fri,  8 Nov 2019 06:42:50 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68F193F719;
        Fri,  8 Nov 2019 06:42:49 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 00/17] arm: gic: Test SPIs and interrupt groups
Date:   Fri,  8 Nov 2019 14:42:23 +0000
Message-Id: <20191108144240.204202-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far the GIC testing was limited: we were only testing some MMIO
properties on a GICv2 and some IPI behaviour.
This series extends this to cover SPIs as well, also testing the
behaviour with the two interrupt groups the emulated GIC provides to us.

The first patch is an easy extension to allow some distributor MMIO
tests on GICv3 guests as well.
Patch 2 - 5 prepare the GIC testing framework to handle SPIs, also to
be able to check for interrupts *not* firing.
This is used in patch 6, which adds an IRQ test by using a software
triggered SPI. This also tests whether interrupt masking works, at least
using one of the many masking methods.
Patch 8 adds a test to cover multiple cores, to test the interrupt
target settings. Patch 7 avoids unneccesary output when triggering one IRQ
multiple times.
The remainder of the patches add code to differentiate the two interrupt
groups that the GIC provides. On bare-metal machines, typically having
some secure world code running, and using the typical dual-security-state
GIC configuration, we only ever have one group (group 1) available, so
Linux won't use this feature.
However our emulated GIC does not have a secure side (as we are running
in at most EL2), so both interrupt groups are available to a guest.
So the patches add support to program interrupts to belong to one or
another group, also program the virtual GIC to deliver group 0
interrupts as FIQs, and group 1 interrupts as IRQs.
We then do some tests to see whether this setup works as expected.

At the moment only QEMU using TCG passes these tests, the KVM VGIC
emulation fails to handle the group enable bits properly. Patches for
the kernel will be send shortly, this series acts as a verification test
for this feature (as normal world OSes won't probably use two groups).

Please have a look and comment. I am not particularly happy with patch
16, thrilled to hear any suggestions on how to handle this better.

Tested on arm/GICv2, arm64/GICv2 and arm64/GICv3, with and without the
corresponding KVM patches to fix the dual-group behaviour.

Cheers,
Andre

Andre Przywara (17):
  arm: gic: Enable GIC MMIO tests for GICv3 as well
  arm: gic: Generalise function names
  arm: gic: Provide per-IRQ helper functions
  arm: gic: Support no IRQs test case
  arm: gic: Prepare IRQ handler for handling SPIs
  arm: gic: Add simple shared IRQ test
  arm: gic: Extend check_acked() to allow silent call
  arm: gic: Add simple SPI MP test
  arm: gic: Add test for flipping GICD_CTLR.DS
  arm: gic: Check for writable IGROUPR registers
  arm: gic: Check for validity of both group enable bits
  arm: gic: Change gic_read_iar() to take group parameter
  arm: gic: Change write_eoir() to take group parameter
  arm: gic: Prepare for receiving GIC group 0 interrupts via FIQs
  arm: gic: Provide FIQ handler
  arm: gic: Prepare interrupt statistics for both groups
  arm: gic: Test Group0 SPIs

 arm/gic.c                  | 468 ++++++++++++++++++++++++++++++++-----
 arm/micro-bench.c          |   6 +-
 arm/pl031.c                |   4 +-
 arm/timer.c                |   4 +-
 arm/unittests.cfg          |  38 ++-
 lib/arm/asm/arch_gicv3.h   |  26 ++-
 lib/arm/asm/gic-v2.h       |  11 +-
 lib/arm/asm/gic-v3.h       |  12 +-
 lib/arm/asm/gic.h          |  13 +-
 lib/arm/asm/processor.h    |  10 +
 lib/arm/gic-v2.c           |  39 +++-
 lib/arm/gic-v3.c           |   2 +-
 lib/arm/gic.c              | 102 +++++++-
 lib/arm64/asm/arch_gicv3.h |  29 ++-
 lib/arm64/asm/processor.h  |  10 +
 lib/arm64/processor.c      |   2 +
 16 files changed, 685 insertions(+), 91 deletions(-)

-- 
2.17.1

