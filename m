Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A269F52F2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 18:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbfKHRt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 12:49:59 -0500
Received: from foss.arm.com ([217.140.110.172]:47714 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729775AbfKHRt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 12:49:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1522431B;
        Fri,  8 Nov 2019 09:49:59 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1ED93F719;
        Fri,  8 Nov 2019 09:49:57 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/3] kvm: arm: VGIC: Fix interrupt group enablement
Date:   Fri,  8 Nov 2019 17:49:49 +0000
Message-Id: <20191108174952.740-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In KVM we emulate an ARM Generic Interrupt Controller with a "single
security state", which (unlike most GICs found in silicon) provides
a non-secure operating system with *two* interrupt groups.
Since on bare metal we typically have only one group available, Linux
does not actually care about the groups and will just use the one
provided.

However we claim to support the GIC architecture, and actually have code
to support two groups, so we should aim to support this properly.

As Marc pointed out recently, we don't honour the separate group enable
bits in the GICD_CTLR register, so a guest can't separately enable or
disable the two groups.

Fixing this unfortunately requires more than just to provide storage for
a second bit: So far we were treating the "groupX enable bit" as a
global distributor enable bit, preventing interrupts from being entered
into the list registers at all if the whole thing was disabled.
Now with two separate bits we might need to block one IRQ, while needing
to forward another one, so this neat trick does not work anymore.

Instead we slightly remodel our "interrupt forwarding" mechanism, to
actually get closer to the architecture: Before adding a pending IRQ to
the ap_list, we check whether its configured interrupt group is enabled.
If it's not, we don't add it to the ap_list (yet). Now when later this
group gets enabled, we need to rescan all (pending) IRQs, to add them to
the ap_list and forward them to the guest. This is not really cheap, but
fortunately wouldn't happen too often, so we refrain from employing any
super clever algorithm, at least for now.
Another solution would be to introduce a "disabled_group_list", where
pending, but group-disabled IRQs go to, let me know if I should explore
this further.

Patch 1 prepares the VGIC code to provide storage for the two enable
bits, also extends the MMIO handling to deal with the two bits.
For this patch we still block the "other" group, as we need the
rescanning algorithm in patch 2 to allow enabling of any group later on.
Patch 3 then enables the functionality, when everything is ready.
The split-up is mostly for review purposes, since I expect some
discussion about patch 2. Happy to merge the three into one once we
agreed on the approach.

There is a corresponding kvm-unit-test series to test the FIQ
functionality, since Linux itself won't use this.
This has been tested with Linux (for regressions) and with
kvm-unit-tests, on a GICv2/arm, GICv2/arm64 and GICv3/arm64 machine.

The kvm-unit-tests patches can be found here:
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-November/037853.html
or in the following repo:
https://github.com/Andre-ARM/kvm-unit-tests/commits/gic-group0

This series here can also be found at:
git://linux-arm.org/linux-ap.git

Based on kvmarm/next, commit cd7056ae34af.

Please have a look!

Cheers,
Andre

Andre Przywara (3):
  kvm: arm: VGIC: Prepare for handling two interrupt groups
  kvm: arm: VGIC: Scan all IRQs when interrupt group gets enabled
  kvm: arm: VGIC: Enable proper Group0 handling

 include/kvm/arm_vgic.h           |   7 +-
 virt/kvm/arm/vgic/vgic-debug.c   |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  23 +++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  22 +++---
 virt/kvm/arm/vgic/vgic.c         | 130 ++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h         |   3 +
 6 files changed, 162 insertions(+), 25 deletions(-)

-- 
2.17.1

