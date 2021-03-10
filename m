Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0581E334176
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 16:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhCJP0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 10:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhCJP02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 10:26:28 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019CE64F6A;
        Wed, 10 Mar 2021 15:26:28 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lK0jB-000n2m-Ot; Wed, 10 Mar 2021 15:26:26 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, qperret@google.com,
        kernel-team@android.com
Subject: [PATCH 0/4] KVM: arm64: Running the EL2 nVHE code with WXN
Date:   Wed, 10 Mar 2021 15:26:12 +0000
Message-Id: <20210310152612.3821182-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we use distinct permissions when mapping things at EL2 depending
on whether they are text or data, we are already using a W^X setup
with nVHE.

This trivial series aims to enforce it by setting SCTLR_EL2.WXN at all
times. It just cleans up a couple of code paths so that
SCTLR_ELx_FLAGS is only used by the KVM setup code, and finally sets
the WXN flag permanently.

Lightly tested on an A53 system with 4KB and 64KB pages.

Thanks,

	M.

Marc Zyngier (4):
  arm64: Use INIT_SCTLR_EL1_MMU_OFF to disable the MMU on CPU restart
  KVM: arm64: Use INIT_SCTLR_EL2_MMU_OFF to disable the MMU on KVM
    teardown
  KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
  KVM: arm64: Force SCTLR_EL2.WXN when running nVHE

 arch/arm64/include/asm/sysreg.h    | 5 +++--
 arch/arm64/kernel/cpu-reset.S      | 5 +----
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 6 ++----
 3 files changed, 6 insertions(+), 10 deletions(-)

-- 
2.29.2

