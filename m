Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988323448B8
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhCVPGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:06:54 -0400
Received: from foss.arm.com ([217.140.110.172]:33478 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhCVPGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:06:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A97F91042;
        Mon, 22 Mar 2021 08:06:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E73293F719;
        Mon, 22 Mar 2021 08:06:18 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 0/6] Misc assembly fixes and cleanups
Date:   Mon, 22 Mar 2021 15:06:35 +0000
Message-Id: <20210322150641.58878-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is mostly fixes and cleanups for things I found when playing
with EFI support. Most of them I hope are fairly self-explanatory.

What is clearly aimed at running on baremetal is patch #2 ("arm/arm64:
Remove dcache_line_size global variable"), which is needed because the
startup environment is different for EFI apps and we're going to need to do
cache maintenance before setup() is run.

Patch #4 ("lib: arm64: Consolidate register definitions to sysreg.h") is
there to make importing register definitions and other header files from
Linux (like el2_setup.h) easier by switching to the same layout. And arm
is already using sysreg.h for SCTLR fields.

Changes in v2:
* Gathered Reviewed-by tags, thank you!
* For patch #2 ("arm/arm64: Remove dcache_line_size global variable"), I've
  modified the commit message to mention the change in parameters for
  dcache_by_line_op, I've added the proper header guards to
  lib/arm/asm/assembler.h and I've changed raw_dcache_line_size to use ubfx
  instead of ubfm.

Alexandru Elisei (6):
  arm64: Remove unnecessary ISB when writing to SPSel
  arm/arm64: Remove dcache_line_size global variable
  arm/arm64: Remove unnecessary ISB when doing dcache maintenance
  lib: arm64: Consolidate register definitions to sysreg.h
  arm64: Configure SCTLR_EL1 at boot
  arm64: Disable TTBR1_EL1 translation table walks

 lib/arm/asm/assembler.h       | 53 ++++++++++++++++++++++++++++++++++
 lib/arm/asm/processor.h       |  7 -----
 lib/arm64/asm/arch_gicv3.h    |  6 ----
 lib/arm64/asm/assembler.h     | 54 +++++++++++++++++++++++++++++++++++
 lib/arm64/asm/pgtable-hwdef.h |  1 +
 lib/arm64/asm/processor.h     | 17 -----------
 lib/arm64/asm/sysreg.h        | 24 ++++++++++++++++
 lib/arm/setup.c               |  7 -----
 arm/cstart.S                  | 19 ++----------
 arm/cstart64.S                | 28 +++++++-----------
 10 files changed, 145 insertions(+), 71 deletions(-)
 create mode 100644 lib/arm/asm/assembler.h
 create mode 100644 lib/arm64/asm/assembler.h

-- 
2.31.0

