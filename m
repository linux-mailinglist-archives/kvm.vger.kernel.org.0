Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638BC43DFD2
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 13:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhJ1LTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 07:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhJ1LTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 07:19:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D07FB610F8;
        Thu, 28 Oct 2021 11:16:45 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mg3Ol-002BtD-I6; Thu, 28 Oct 2021 12:16:43 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        kernel-team@android.com
Subject: [PATCH v2 0/5] KVM: arm64: Rework FPSIMD/SVE tracking
Date:   Thu, 28 Oct 2021 12:16:35 +0100
Message-Id: <20211028111640.3663631-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v2 of this series aiming at simplifying the FP handling.

It recently became apparent that we are mapping each vcpu thread's
thread_info structure at EL2 for the sole purpose of checking on the
TIF_FOREIGN_FPSTATE flag.

Given that this looks like a slightly over-engineered way of sharing a
single bit of information, let's move to a slightly more obvious
implementation by maintaining a vcpu-private shadow flag that
represents the same state.

In the same vein, it appears that the code that deals with saving the
host SVE state when used by the guest can never run, and that's by
construction. This is actually a good thing, because it be guaranteed
to explode on nVHE. Let's get rid of it.

I also take this opportunity to add what looks like a missing, and
nonetheless crucial piece of information to the FPSIMD code regarding
the way KVM (ab)uses the TIF_FOREIGN_FPSTATE.

Lightly tested on an A53 box with a bunch of paranoia instances
running in both host and guests, and more heavily on a FVP to check
the SVE behaviour (using the sve-test selftest running in both host
and guest at the same time).

* From v1 [1]:
  - New patch getting rid of the host SVE save code
  - Reworded the documentation update patch

[1] https://lore.kernel.org/r/20211021151124.3098113-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Reorder vcpu flag definitions
  KVM: arm64: Get rid of host SVE tracking/saving
  KVM: arm64: Introduce flag shadowing TIF_FOREIGN_FPSTATE
  KVM: arm64: Stop mapping current thread_info at EL2
  arm64/fpsimd: Document the use of TIF_FOREIGN_FPSTATE by KVM

 arch/arm64/include/asm/kvm_host.h       | 29 ++++++++++---------
 arch/arm64/kernel/fpsimd.c              |  6 +++-
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/fpsimd.c                 | 37 ++++++++++---------------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 30 +++-----------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  1 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  1 -
 7 files changed, 38 insertions(+), 67 deletions(-)

-- 
2.30.2

