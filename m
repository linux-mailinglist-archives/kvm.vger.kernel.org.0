Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479AD67204D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjAROzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjAROzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:55:09 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 055C462D0D
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:49:27 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6B8B169C;
        Wed, 18 Jan 2023 06:50:09 -0800 (PST)
Received: from e121798.cambridge.arm.com (e121798.cambridge.arm.com [10.1.196.158])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0458B3F67D;
        Wed, 18 Jan 2023 06:49:26 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v4 0/2] arm: Add PSCI CPU_OFF test
Date:   Wed, 18 Jan 2023 14:49:10 +0000
Message-Id: <20230118144912.32049-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series adds a test for the PSCI function CPU_OFF. The test is
implemented in patch #2, "arm/psci: Add PSCI CPU_OFF test case".  Patch #1,
"arm/psci: Test that CPU 1 has been successfully brought online" is a
preparatory patch to allow the CPU_OFF test to run after the CPU_ON test.
Executing the CPU_OFF test after the CPU_ON test makes the most sense,
since CPU_OFF requires all the CPUs to be brought online before the test
can execute, and this is exactly what the CPU_ON test does.

I believe that proving that a CPU has been successfully offlined is an
undecidable problem - it might just be that the CPU is stuck at a higher
exception level doing something else entirely, and if the test were to wait
long enough, the CPU would return from the CPU_OFF call and start executing
code, thus failing to be offlined. Right now, the test waits for 1 second
before checking that all the other CPUs are offline. I thought this was a
good balance between making the test fast and being reasonably sure that
the offline succeeded. I'm open to suggestions here if anyone thinks
otherwise.

Tested for both the arm and arm64 architectures: on an x86 machine (qemu
with TCG), and an ampere emag (qemu and kvmtool).

And Nikita is not longer at Arm, and I don't have a new email address where
she can be reached, so I didn't CC her.

Changelog:

v3 -> v4:
- Moved ownership of the series to Alexandru Elisei. All bugs are mine.
- Moved the timeout for the CPU_ON test to patch #1.
- Changed the include order for arm/psic.c in patch #1 to order the headers
  alphabetically.
- Run the CPU_OFF test only if CPU_ON succeeds, because CPU_OFF expects all
  CPUs to be online, the test would otherwise hang forever.
- Minor style changes here and there.

v2 -> v3:
- Add timeout so that test does not hang if CPU1 fails to come online
- Remove unnecessary call of on_cpus() in the condition where target CPU is not online.

v1 -> v2:
- Modify PSCI CPU_ON test to ensure CPU 1 remains online after the execution of the test.
- Addition of PSCI CPU_OFF test and calling it after PSCI CPU_ON test has been executed.

Alexandru Elisei (1):
  arm/psci: Test that CPU 1 has been successfully brought online

Nikita Venkatesh (1):
  arm/psci: Add PSCI CPU_OFF test case

 arm/psci.c        | 132 +++++++++++++++++++++++++++++++++++++++-------
 lib/arm/asm/smp.h |   1 +
 lib/arm/smp.c     |  12 +++--
 lib/errata.h      |   2 +
 4 files changed, 125 insertions(+), 22 deletions(-)


base-commit: 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
-- 
2.25.1

