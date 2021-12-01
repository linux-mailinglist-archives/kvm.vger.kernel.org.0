Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20277464D73
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349165AbhLAMII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 07:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349152AbhLAMIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 07:08:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB56C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 04:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7C0DCE1D64
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD91EC53FAD;
        Wed,  1 Dec 2021 12:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638360282;
        bh=5MhqnIB1XSHPqXNEmYeYObQT+YqlISKY2zSWAv8TRas=;
        h=From:To:Cc:Subject:Date:From;
        b=Vuf/v4PFWfbpapmWrmZhmE/ykvBqKJd8goiPC7Pny2rtmcHlA+0B2S9f3s15Pnz7H
         If5BWmarlxLLnc4e7Wv+88dKDThqHDZMpe+XAjAmvgSSWfdFz+RGVLfBX5FgAdyloY
         LLMLIZCLBxiE3wWcXk3T2k6p4NUWIZ/VqnRKls9ruI6sbsGlGJxvUD31A3yOoPoEKJ
         qn0rajdxx4bbYluACkVBcv+/xt2p/VT7f7Mq691eiPzdmp0Tgxs4j1sjZF2jmpF5jz
         WSBE9E2qBV9UGWvsMCrff1mwxnyFZgYKhwLIhgCwdOpyGqBrxj2q8mU88IOWanPIH6
         8grwYWvyz6yTA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1msOLo-0097Ab-SI; Wed, 01 Dec 2021 12:04:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
Subject: [PATCH v3 0/6] KVM: arm64: Rework FPSIMD/SVE tracking
Date:   Wed,  1 Dec 2021 12:04:30 +0000
Message-Id: <20211201120436.389756-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v3 of this series aiming at simplifying the FP handling.

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

I plan to take this series for a spin in -next immediately.

* From v2 [2]:
  - Removed obsolete comments
  - Removed __sve_save_state which is now unused

* From v1 [1]:
  - New patch getting rid of the host SVE save code
  - Reworded the documentation update patch

[1] https://lore.kernel.org/r/20211021151124.3098113-1-maz@kernel.org
[2] https://lore.kernel.org/r/20211028111640.3663631-1-maz@kernel.org

Marc Zyngier (6):
  KVM: arm64: Reorder vcpu flag definitions
  KVM: arm64: Get rid of host SVE tracking/saving
  KVM: arm64: Remove unused __sve_save_state
  KVM: arm64: Introduce flag shadowing TIF_FOREIGN_FPSTATE
  KVM: arm64: Stop mapping current thread_info at EL2
  arm64/fpsimd: Document the use of TIF_FOREIGN_FPSTATE by KVM

 arch/arm64/include/asm/kvm_host.h       | 29 +++++++++---------
 arch/arm64/include/asm/kvm_hyp.h        |  1 -
 arch/arm64/kernel/fpsimd.c              |  6 +++-
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/fpsimd.c                 | 40 +++++++++----------------
 arch/arm64/kvm/hyp/fpsimd.S             |  6 ----
 arch/arm64/kvm/hyp/include/hyp/switch.h | 30 +++----------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  1 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  1 -
 9 files changed, 38 insertions(+), 77 deletions(-)

-- 
2.30.2

