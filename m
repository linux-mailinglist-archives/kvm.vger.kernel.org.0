Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7926D8227
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbjDEPko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbjDEPkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:40:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA5059C0
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB6E63ED4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B65C433A7;
        Wed,  5 Apr 2023 15:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709230;
        bh=PU842ofrcMWedmXdFu0S0QmwVSfMPxO2WGHpEYZcEO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlwcTVnxkBw1sH+Xkqz8DcoE0af+YCQnkKMO2R2msKQeozqK1RNBX54wdfABIRXxE
         q9zQAU1VvSAIFYCKBAq20iiQXVf7JHbZwZHAZBzk01QDNVOBBF5hoMpoRF0c7TB555
         IcXHC7eU6YqPaAk6km1Kp7O3CK1zZw+Iy10crqwoUrjOzicOZ+WJ1I0+HBn3+QIYqq
         d/CSuXCvAQGkegbgwCxNOeBYK+WXFi2aamZt3ipWnWCe8XRTWzj0JoqwR4afRwlyVZ
         NyLmj3NaiMzbwweHb5Xynkgh/rXEwbXbqMfnJrGUvWHaTC6Olh+S/UVjjhyDdBHMks
         9x+AnT9LPdOSw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5FM-0062PV-Rc;
        Wed, 05 Apr 2023 16:40:28 +0100
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
Subject: [PATCH v9 07/50] KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
Date:   Wed,  5 Apr 2023 16:39:25 +0100
Message-Id: <20230405154008.3552854-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

For the same reason we trap virtual memory register accesses in virtual
EL2, we trap CPACR_EL1 access too; We allow the virtual EL2 mode to
access EL1 system register state instead of the virtual EL2 one.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +++
 arch/arm64/kvm/sys_regs.c       | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c8da8d350453..41385bb02d6b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -68,6 +68,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
+		val |= CPTR_EL2_TCPAC;
+	
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5dc158c39baa..cc3104167232 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2066,7 +2066,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
-	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(SYS_CPACR_EL1), access_rw, reset_val, CPACR_EL1, 0 },
 
 	MTE_REG(RGSR_EL1),
 	MTE_REG(GCR_EL1),
-- 
2.34.1

