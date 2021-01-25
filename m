Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76165304A0F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbhAZFRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728179AbhAYMkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:40:37 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D6D22597;
        Mon, 25 Jan 2021 12:26:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l40x7-009sBu-G0; Mon, 25 Jan 2021 12:26:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH v2 0/7] KVM: arm64: More PMU/debug ID register fixes
Date:   Mon, 25 Jan 2021 12:26:31 +0000
Message-Id: <20210125122638.2947058-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a respin of a series I posted in the 5.7 time frame, and
completely forgot about it until I noticed again that a few things
where not what I remembered... Given how long it has been, I'm
pretending this is all new work.

Anyway, this covers a few gaps in our ID register handling for PMU and
Debug, plus the upgrade of the PMU support to 8.4 when possible.

I don't plan to take this into 5.11, but this is a likely candidate
for 5.12. Note that this conflicts with fixes that are on their way to
5.11. I'll probably end-up dragging the fixes into 5.12 to solve it.

* From v1 [1]:
  - Upgrade AArch32 to PMUv8.4 if possible
  - Don't advertise STALL_SLOT when advertising PMU 8.4
  - Add an extra patch replacing raw values for the PMU version with
    the already existing symbolaic values

[1] https://lore.kernel.org/r/20210114105633.2558739-1-maz@kernel.org

Marc Zyngier (7):
  KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
  KVM: arm64: Fix AArch32 PMUv3 capping
  KVM: arm64: Add handling of AArch32 PCMEID{2,3} PMUv3 registers
  KVM: arm64: Refactor filtering of ID registers
  KVM: arm64: Limit the debug architecture to ARMv8.0
  KVM: arm64: Upgrade PMU support to ARMv8.4
  KVM: arm64: Use symbolic names for the PMU versions

 arch/arm64/include/asm/sysreg.h |  3 ++
 arch/arm64/kvm/pmu-emul.c       | 14 ++++--
 arch/arm64/kvm/sys_regs.c       | 79 ++++++++++++++++++++-------------
 3 files changed, 61 insertions(+), 35 deletions(-)

-- 
2.29.2

