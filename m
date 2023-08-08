Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76743774750
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjHHTOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbjHHTNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114D736013
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43A0A624F2
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4343C433C7;
        Tue,  8 Aug 2023 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495279;
        bh=wxocUCw9UXZABS62au2oXQEt+hOWznw5U/tSAAqxwXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOJEO5wfb7oyHA8zjbKGDB+k6ZfnFiF5mmC6MkK2aOwIwdB1IGf6/VuhmxN6hl6XM
         rjyxGR2YbTZJTKe0npYrGYWeYyHoEp5amwnH8g8mkentsdoAuXWq5Nbjv2rOKdN/rH
         lNj/2IYXdXhHjkc1jif/beweY7JeUVmec7tvZyenDpo6eduNUlUDPtUm2TAaLGI90F
         pdzIrXh3cqJzkaMP8rCnkbRnxSayGu2Cqqd4u5bCsjtCuE78RexLxKv87AkfhHLmWi
         VpACLHOKOxyrLQJ/OzmRcmvPqeVrDDUoK7fJNenecfInwp0WOw1mYuAjCX5qwoV/mW
         JNQhGqAa3frvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBG-0037Ph-NY;
        Tue, 08 Aug 2023 12:47:18 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 12/27] KVM: arm64: nv: Add FGT registers
Date:   Tue,  8 Aug 2023 12:46:56 +0100
Message-Id: <20230808114711.2013842-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the 5 registers covering FEAT_FGT. The AMU-related registers
are currently left out as we don't have a plan for them. Yet.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 arch/arm64/kvm/sys_regs.c         | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..721680da1011 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -400,6 +400,11 @@ enum vcpu_sysreg {
 	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
+	HFGRTR_EL2,
+	HFGWTR_EL2,
+	HFGITR_EL2,
+	HDFGRTR_EL2,
+	HDFGWTR_EL2,
 	CNTHP_CTL_EL2,
 	CNTHP_CVAL_EL2,
 	CNTHV_CTL_EL2,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 38f221f9fc98..f5baaa508926 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2367,6 +2367,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HFGRTR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HFGWTR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
@@ -2376,6 +2379,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
-- 
2.34.1

