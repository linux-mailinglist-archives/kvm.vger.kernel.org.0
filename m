Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAA849FA14
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348748AbiA1MvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348721AbiA1MvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:51:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5BCC06173B
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC2B61CAF
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB0C340E0;
        Fri, 28 Jan 2022 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643374265;
        bh=QNYfQ4nWJsQi/3DRoVVwcKktckvbvFtn7+vYhA9xY+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEbCaksIdXBWaJsSkmn2KfgiyUZ//G6xsgB69pskssWpYSo8a4Z6cTo3VyE75I20a
         4dvRuD69yoHSothHmadr27suIwwJCzsS94A3PQ0bKHt6zqGKi6AubOE8OYDkB1Uvic
         cjxSRfQlHWfdrnmNWzKSM09dAzLMJRMAYY6yyAwaGYuxyiFp/eSFQBzE/C9jnoJRgb
         uC31Bh7ngmXQxPbDRRXkc80oSB6pNdH/gL3I3fdVjxv52kBVxQNIszZn4yv/+5yEcm
         3Z49vBIxKUYJ4kW062dEP/3nlgdDnIRjys4fKOfhom0VdCAWswcok2sEWhvI5ehzxH
         3sYcW2Gd6IvXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQEF-003njR-5y; Fri, 28 Jan 2022 12:19:47 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 33/64] KVM: arm64: nv: Hide RAS from nested guests
Date:   Fri, 28 Jan 2022 12:18:41 +0000
Message-Id: <20220128121912.509006-34-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't want to expose complicated features to guests until we have
a good grasp on the basic CPU emulation. So let's pretend that RAS,
doesn't exist in a nested guest. We already hide the feature bits,
let's now make sure VDISR_EL1 will UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ebcdf2714b73..5e8876177ce6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2212,6 +2212,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
+	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
-- 
2.30.2

