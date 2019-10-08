Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF885CFE63
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfJHQB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 12:01:57 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:54549 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727970AbfJHQB5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Oct 2019 12:01:57 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iHrvs-0001rs-DQ; Tue, 08 Oct 2019 18:01:52 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v2 0/5] KVM: arm64: Assorted PMU emulation fixes
Date:   Tue,  8 Oct 2019 17:01:23 +0100
Message-Id: <20191008160128.8872-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, andrew.murray@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I recently came across a number of PMU emulation bugs, all which can
result in unexpected behaviours in an unsuspecting guest. The first
two patches already have been discussed on the list, but I'm including
them here as part of a slightly longer series.

The third patch is new as of v2, and fixes a bug preventing chained
events from ever being used.

The fourth patch is also new as of v2, and is an arm64 PMU change for
which I clearly don't know what I'm doing. I'd appreciate some
guidance from Will or Mark.

The last patch fixes an issue that has been here from day one, where
we confuse architectural overflow of a counter and perf sampling
period, and uses patch #4 to fix the issue.

I'l planning to send patches 1 through to 3 as fixes shortly, but I
expect the last two patches to require more discussions.

Marc Zyngier (5):
  KVM: arm64: pmu: Fix cycle counter truncation
  arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
  KVM: arm64: pmu: Set the CHAINED attribute before creating the
    in-kernel event
  arm64: perf: Add reload-on-overflow capability
  KVM: arm64: pmu: Reset sample period on overflow handling

 arch/arm64/include/asm/perf_event.h |  4 +++
 arch/arm64/kernel/perf_event.c      |  8 ++++-
 arch/arm64/kvm/sys_regs.c           |  4 +++
 virt/kvm/arm/pmu.c                  | 45 +++++++++++++++++++----------
 4 files changed, 45 insertions(+), 16 deletions(-)

-- 
2.20.1

