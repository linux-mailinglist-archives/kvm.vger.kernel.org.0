Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88E8D3FB6
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 14:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfJKMkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 08:40:18 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:36326 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727589AbfJKMkS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Oct 2019 08:40:18 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iIuDO-00062U-Br; Fri, 11 Oct 2019 14:40:14 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 0/4] KVM: arm64: Assorted PMU emulation fixes
Date:   Fri, 11 Oct 2019 13:39:50 +0100
Message-Id: <20191011123954.31378-1-maz@kernel.org>
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

The last patch fixes an issue that has been here from day one, where
we confuse architectural overflow of a counter and perf sampling
period, and uses a terrible hack^W^W creative way to interact with the
underlying PMU driver so that we can reload the period when handling
the overflow.

* From v2 [1]
  - Dropped PMUv3 patch and moved the logic into the KVM code
  - Properly use UPDATE/RELOAD
  - Collected Andrew's RB

[1] https://lore.kernel.org/kvmarm/20191008160128.8872-1-maz@kernel.org/

Marc Zyngier (4):
  KVM: arm64: pmu: Fix cycle counter truncation
  arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
  KVM: arm64: pmu: Set the CHAINED attribute before creating the
    in-kernel event
  KVM: arm64: pmu: Reset sample period on overflow handling

 arch/arm64/kvm/sys_regs.c |  4 ++++
 virt/kvm/arm/pmu.c        | 48 ++++++++++++++++++++++++++++-----------
 2 files changed, 39 insertions(+), 13 deletions(-)

-- 
2.20.1

