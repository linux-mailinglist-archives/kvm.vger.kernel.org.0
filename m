Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116FD6D8231
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238966AbjDEPlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbjDEPlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB34A65A8
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9742F63EE6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B25CC433EF;
        Wed,  5 Apr 2023 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709270;
        bh=RpayedqqXPrcFY7vhwa6lg8OwX/4EFZH0OkzYWmR8Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv5Qnfr2AH+ZtYQT0U09dw7qDW+1ryK4/mEPzbr0wmAyuDgSVTzm0ZV0s46NM4DaC
         2dMAkwnWZtBkomWP0PA4fhS+ogLIoomEVmzYYJnEOEOErXThsrVFj6ANxf/bFUCXiv
         Ox6KE7YGMt0XXEAh0lmWxrzXijlkYbicmv+OeA0dmggSmgHmeiLXIj3tMHYEBYo0Wf
         2ZC5Ck5FmMQADor9/2EsX8tnw21b4HOA2genNyvKxccZPkSaZqWVacLX+YnNeVrY7A
         azY5Cov0fhUxyjIyXAF9uGEPPl9Q6kLE33MyU2jVX+us3xEBPLdSy8zTH+Hu3ErnaV
         RAbA8zVwBkCdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5FS-0062PV-Aw;
        Wed, 05 Apr 2023 16:40:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 26/50] KVM: arm64: nv: Forward timer traps to nested EL2
Date:   Wed,  5 Apr 2023 16:39:44 +0100
Message-Id: <20230405154008.3552854-27-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 96fee2a39859..9bd852d16f70 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1459,6 +1459,35 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu) && tmr == TIMER_PTIMER) {
+		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+		bool trap;
+
+		if (!vcpu_el2_e2h_is_set(vcpu))
+			val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
+
+		switch (treg) {
+		case TIMER_REG_CVAL:
+		case TIMER_REG_CTL:
+		case TIMER_REG_TVAL:
+			trap = !(val & (CNTHCTL_EL1PCEN << 10));
+			break;
+
+		case TIMER_REG_CNT:
+			trap = !(val & (CNTHCTL_EL1PCTEN << 10));
+			break;
+
+		default:
+			trap = false;
+			break;
+		}
+
+		if (trap) {
+			kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+			return false;
+		}
+	}
+
 	if (p->is_write)
 		kvm_arm_timer_write_sysreg(vcpu, tmr, treg, p->regval);
 	else
-- 
2.34.1

