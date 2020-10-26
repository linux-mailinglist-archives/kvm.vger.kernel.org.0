Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66422989D1
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 10:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768644AbgJZJvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 05:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737072AbgJZJvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 05:51:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83DC223AC;
        Mon, 26 Oct 2020 09:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705892;
        bh=I0emVrpU4FQs/PK2I8FmbykSgA6RGwyV5X+pSjq779w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNjWIzS0outAIK5FsrLNToH0cVil4Ze33kejCmpoJH5YnmKU9K+AlEV2gwhP4b62Q
         ZXFus2f1g4MhTpwmus9y7hEmNRCnEkV8v/ryIQhOTbg1/3DUqG5F3aRVns1+VkqzQv
         uypJoJhaxVk7HAdphDITx2rrf+iVr0uDxBZv8Y4Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kWzA2-004HZn-T3; Mon, 26 Oct 2020 09:51:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: [PATCH 3/8] KVM: arm64: Drop useless PAN setting on host EL1 to EL2 transition
Date:   Mon, 26 Oct 2020 09:51:11 +0000
Message-Id: <20201026095116.72051-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026095116.72051-1-maz@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, kernel-team@android.com
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

