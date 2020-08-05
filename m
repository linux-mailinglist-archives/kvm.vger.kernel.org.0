Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B48223CDF1
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 19:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgHER7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 13:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728935AbgHER63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:58:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4851022D05;
        Wed,  5 Aug 2020 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596650241;
        bh=vdT2zEXntyWq9LjC/EBegpSbUib6Cx9T2XnUgvEDcGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aclcxQunFMLh6x4Kml2GdHrbx+xTMSvoVl6jFZvPn/Ckqe7xsmSFYaAwDWrPTQy5
         eHLfKqTo1OZBSCvdeqRPfGv9HKJXjYM+2mdvVprWPbnOCzsTmmEeS8UD2E2pz6yryR
         QuSZc2s2q8CRIB5bFgABE33Edyo8ja7g+m34An1E=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfD-0004w9-Go; Wed, 05 Aug 2020 18:57:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 09/56] KVM: arm64: Tolerate an empty target_table list
Date:   Wed,  5 Aug 2020 18:56:13 +0100
Message-Id: <20200805175700.62775-10-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

Before emptying the target_table lists, and then removing their
infrastructure, add some tolerance to an empty list.

Instead of bugging-out on an empty list, pretend we already
reached the end in the two-list-walk.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622113317.20477-3-james.morse@arm.com
---
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6333a7cd92d3..fb448bfc83ec 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2809,7 +2809,10 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 	i2 = sys_reg_descs;
 	end2 = sys_reg_descs + ARRAY_SIZE(sys_reg_descs);
 
-	BUG_ON(i1 == end1 || i2 == end2);
+	if (i1 == end1)
+		i1 = NULL;
+
+	BUG_ON(i2 == end2);
 
 	/* Walk carefully, as both tables may refer to the same register. */
 	while (i1 || i2) {
-- 
2.27.0

