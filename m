Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B977C904C
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 00:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjJMWdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 18:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJMWde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 18:33:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB50B7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 15:33:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5E0C433C8;
        Fri, 13 Oct 2023 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697236413;
        bh=7BvCsjOXzSIuiTVhxAa4FCwixp30E6v8qtXuZnmwQ9c=;
        h=From:To:Cc:Subject:Date:From;
        b=gQXDZm3s0d5AOZM7tXtu6OSdWKpqUwP1MqPsQIrLUCu9QOesSS/kGjRdKI+b/LsP2
         dcc7bjuWivl5DaAGdetXdUuJN33ZU6iMBsRhVT0S7ncbF5lRAxjKgp9w1YCe5+Odba
         AeYzXlyY8e+bFs6Bws2yqIpAN0uZpx7JiWHXRNBwW9WWxEmKaIv2qG/H4FUVmMPj9w
         panJ3F11S8wvwW0pQJo0a3KvpVolKGe+glzR8ax1whvcMuNUCVCZa3uBjQ9FVv1RKc
         OPbp/0IHns7FFFOepo0oUh501eNwXpJ88dQORwKnMxJIfUPsi1HQ5f3NLOepdHE5pM
         3A87QFckjcWyQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qrQio-00410F-94;
        Fri, 13 Oct 2023 23:33:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the *32_EL2 sysregs
Date:   Fri, 13 Oct 2023 23:33:11 +0100
Message-Id: <20231013223311.3950585-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
UNDEF when AArch32 isn't implemented, which is definitely the case when
running NV.

Given that this is the only case where these registers can trap,
unconditionally inject an UNDEF exception.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0afd6136e275..0071ccccaf00 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	// DBGDTR[TR]X_EL0 share the same encoding
 	{ SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
 
-	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
+	{ SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
@@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
 	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
 
-	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
 	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
-	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
-	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
+	{ SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 },
 
 	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
-- 
2.34.1

