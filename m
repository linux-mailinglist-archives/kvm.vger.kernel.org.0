Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A13E3C71A8
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhGMOB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236548AbhGMOB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 10:01:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FFF61288;
        Tue, 13 Jul 2021 13:59:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3IwC-00D5p8-Qf; Tue, 13 Jul 2021 14:59:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
Subject: [PATCH 0/3] kvm-arm64: Fix PMU reset values (and more)
Date:   Tue, 13 Jul 2021 14:58:57 +0100
Message-Id: <20210713135900.1473057-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

After some back and forth with Alexandre about patch #3 of this
series, it became apparent that some of the PMU code paths perform
some unnecessary masking, only to hide the fact that some of the PMU
register reset values are not architecturally compliant (RES0 bits get
set, among other things).

The first patch of this series addresses the reset value problem, the
second one rids us of the pointless masking, and Alexandre's patch
(which depends on the first two) is slapped on top, with a small
cosmetic change.

Thanks,

	M.

Alexandre Chartre (1):
  KVM: arm64: Disabling disabled PMU counters wastes a lot of time

Marc Zyngier (2):
  KVM: arm64: Narrow PMU sysreg reset values to architectural
    requirements
  KVM: arm64: Drop unnecessary masking of PMU registers

 arch/arm64/kvm/pmu-emul.c |  8 +++---
 arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 10 deletions(-)

-- 
2.30.2

