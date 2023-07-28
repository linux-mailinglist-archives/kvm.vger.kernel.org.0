Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C7D766799
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbjG1IrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbjG1Iqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8DE2113
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F50F62059
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC96C433C8;
        Fri, 28 Jul 2023 08:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690534012;
        bh=z/Gz4yTqgIBBae0C04bTnFtXUegBkPgPUJ1g21Q6xjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHvzLXb3ucUIqaQWd0MBlQcIMD6RGy5irB7HzVzyTO2YQao6YnWWNh6zVgWV1CNIo
         4HDqbFt74/SPhrxpKiOvg4oqC6LrN4rVfv9DfTZGjX501adPO+MAsyCVxE4aKazFSh
         JawiFOIJcnohxlTPH4fjUw4wmAdBpPh6jtisIFP7WKSBs0pTn0z4hA44nTyBPrIOMK
         U93/CoElY3C3hpkhpts02p34ob2iwz6u9n956GdJfxk2eW5+N14e6OM6F+KFkWaVTS
         U++jaau3mXmXsExuUMDAPqIDnsBAs9+4svx6ro6MErWaU4UsQMWn3jzgH56jfq8SDT
         HlYqm8D9chuRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrK-0000EO-5O;
        Fri, 28 Jul 2023 09:30:02 +0100
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
Subject: [PATCH v2 12/26] KVM: arm64: nv: Add FGT registers
Date:   Fri, 28 Jul 2023 09:29:38 +0100
Message-Id: <20230728082952.959212-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728082952.959212-1-maz@kernel.org>
References: <20230728082952.959212-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

