Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EC3C039B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 12:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfI0Kml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 06:42:41 -0400
Received: from foss.arm.com ([217.140.110.172]:48720 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfI0Kmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 06:42:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF95728;
        Fri, 27 Sep 2019 03:42:33 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B2FC3F534;
        Fri, 27 Sep 2019 03:42:33 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/6] arm: Use stable test output lines
Date:   Fri, 27 Sep 2019 11:42:21 +0100
Message-Id: <20190927104227.253466-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using kvm-unit-tests inside automated testing frameworks,
variable test naming becomes a problem. Some frameworks recognise tests
by their test output line and group the outputs from various runs for
statistical and reporting purposes. Having variable output like timer
values in there spoils this approach. Also the test name should be
somewhat self-explanatory, which is not true for every test.
Some examples highlighting the problem (TAP output from run-tests.sh -t):
ok 1 - selftest: setup: smp: nr_cpus = 2
ok 2 - selftest: setup: mem: size = 256 MB
ok 8 - selftest: smp: CPU(  1) mpidr=0080000001
ok 9 - selftest: smp: CPU(  2) mpidr=0080000002
ok 54 - gicv2: mmio: ITARGETSR: byte writes successful (0x1f => 0x01010001)
ok 55 - gicv2: mmio: all 3 CPUs have interrupts
ok 73 - invalid-function
ok 76 - cpu-on
ok 90 - ptimer-busy-loop: timer has expired (-8445)

This series aims to fix most of the problems, by making the actual test
report output line stable. I think this is best practises in the testing
world, at least when using TAP. We still retain the full information, by
moving every variable output into INFO: lines (which are still logged,
but typically filtered for automated processing).
The above lines now look like this:
ok 1 - selftest: setup: smp: number of CPUs matches expectation
ok 2 - selftest: setup: mem: memory size matches expectation
ok 8 - selftest: smp: MPIDR test on all CPUs
ok 49 - gicv2: mmio: ITARGETSR: byte writes successful
ok 50 - gicv2: mmio: all CPUs have interrupts
ok 68 - psci: invalid-function
ok 71 - psci: cpu-on
ok 85 - ptimer-busy-loop: timer has expired

Looks a bit more boring, but it's nicer for automated processing and
logging.

I am open for a discussion about the general approach, thus this is
dealing with ARM tests for now only.

Looking forward to any feedback!

Cheers,
Andre

Andre Przywara (6):
  arm: gic: check_acked: add test description
  arm: gic: Split variable output data from test name
  arm: timer: Split variable output data from test name
  arm: selftest: Split variable output data from test name
  arm: selftest: Make MPIDR output stable
  arm: Add missing test name prefix calls

 arm/gic.c      | 64 ++++++++++++++++++++++++++++++--------------------
 arm/pci-test.c |  2 ++
 arm/psci.c     |  2 ++
 arm/selftest.c | 23 ++++++++++++++----
 arm/timer.c    |  3 ++-
 5 files changed, 62 insertions(+), 32 deletions(-)

-- 
2.17.1

