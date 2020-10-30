Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6937D2A0B5D
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgJ3Qk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgJ3Qk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:40:27 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5942B2076E;
        Fri, 30 Oct 2020 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076026;
        bh=C2KHtdO9bCq4PJbhH/iBlIoYeIiXNpTc5az68+9hcHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9wJff+MXWAld7WxezhIEVfGNg+0Vc5V14Xl38wuL6ordof+JXD0ysCTMiVRhWzJ0
         5fG85OCRSBTG/s/WOKdBpNNVXkZkd63tHgbutMIzCyagp0MUIWkhQ9xYFQd3iFcxiR
         Ow2ItBsgl8agM9N98sga4t1lOQ0/PvZKVvlYr5O4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXRw-005noK-I5; Fri, 30 Oct 2020 16:40:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/12] KVM: arm64: Drop useless PAN setting on host EL1 to EL2 transition
Date:   Fri, 30 Oct 2020 16:40:08 +0000
Message-Id: <20201030164017.244287-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setting PSTATE.PAN when entering EL2 on nVHE doesn't make much
sense as this bit only means something for translation regimes
that include EL0. This obviously isn't the case in the nVHE case,
so let's drop this setting.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Link: https://lore.kernel.org/r/20201026095116.72051-4-maz@kernel.org
---
 arch/arm64/kvm/hyp/nvhe/host.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ff9a0f547b9f..ed27f06a31ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -17,8 +17,6 @@ SYM_FUNC_START(__host_exit)
 
 	get_host_ctxt	x0, x1
 
-	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
-
 	/* Store the host regs x2 and x3 */
 	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
 
-- 
2.28.0

