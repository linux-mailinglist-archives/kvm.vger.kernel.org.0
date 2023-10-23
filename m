Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA807D2F17
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjJWJza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjJWJzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:55:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E7170E
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:54:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46688C433CA;
        Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698054893;
        bh=1ZqVi5lYR2/pIO0fUmxQBXA2e6f805fwGTu5qVyjcAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBTlLJyxob5XO9ZSZRbwLp1959SIrvkAKWftyhj54mn3EjPM3i46vCZEIzBnAG4th
         k/npIHZlYNWKp11CDNlWw2V2US/vTeQ/li955/ZvBY/97Q8VpPChSoH3qKKLOP46uW
         BwFZG+NOYgjD15a2K8yusiH1tKVz4N5KadEuD+MG3KouwxZ1Mif8wO7s7N3o6HUYcH
         CUVCI72HbKnAszUuLvcupUP2ZRQwjwQrQwUpliELsJhj+qXxzHHSX50jWHMPwL3IX8
         B0Wiej7E0VUedT9F7WrLOgbhAeR15dVPMHS4hxO9lRi2GXjFECfPACLVPIMQFMpS/P
         771xQBfIrzZ8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qure7-006nPT-C4;
        Mon, 23 Oct 2023 10:54:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/5] KVM: arm64: Refine _EL2 system register list that require trap reinjection
Date:   Mon, 23 Oct 2023 10:54:42 +0100
Message-Id: <20231023095444.1587322-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231023095444.1587322-1-maz@kernel.org>
References: <20231023095444.1587322-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miguel Luis <miguel.luis@oracle.com>

Implement a fine grained approach in the _EL2 sysreg range instead of
the current wide cast trap. This ensures that we don't mistakenly
inject the wrong exception into the guest.

Fixes: d0fc0a2519a6 ("KVM: arm64: nv: Add trap forwarding for HCR_EL2")
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
[maz: commit message massaging, dropped secure and AArch32 registers
      from the list]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231016111743.30331-4-miguel.luis@oracle.com
---
 arch/arm64/kvm/emulate-nested.c | 77 ++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index ee902ff2a50f..06185216a297 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -648,15 +648,80 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_APGAKEYLO_EL1,	CGT_HCR_APK),
 	SR_TRAP(SYS_APGAKEYHI_EL1,	CGT_HCR_APK),
 	/* All _EL2 registers */
-	SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
-		      sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
+	SR_TRAP(SYS_BRBCR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_VPIDR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_VMPIDR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_SCTLR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_ACTLR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_SCTLR2_EL2,		CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_HCR_EL2,
+		      SYS_HCRX_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_SMPRIMAP_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_SMCR_EL2,		CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_TTBR0_EL2,
+		      SYS_TCR2_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_VTTBR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_VTCR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_VNCR_EL2,		CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_HDFGRTR_EL2,
+		      SYS_HAFGRTR_EL2,	CGT_HCR_NV),
 	/* Skip the SP_EL1 encoding... */
 	SR_TRAP(SYS_SPSR_EL2,		CGT_HCR_NV),
 	SR_TRAP(SYS_ELR_EL2,		CGT_HCR_NV),
-	SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
-		      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
-	SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
-		      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
+	/* Skip SPSR_irq, SPSR_abt, SPSR_und, SPSR_fiq */
+	SR_TRAP(SYS_AFSR0_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_AFSR1_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_ESR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_VSESR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_TFSR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_FAR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_HPFAR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_PMSCR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_MAIR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_AMAIR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_MPAMHCR_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_MPAMVPMV_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_MPAM2_EL2,		CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_MPAMVPM0_EL2,
+		      SYS_MPAMVPM7_EL2,	CGT_HCR_NV),
+	/*
+	 * Note that the spec. describes a group of MEC registers
+	 * whose access should not trap, therefore skip the following:
+	 * MECID_A0_EL2, MECID_A1_EL2, MECID_P0_EL2,
+	 * MECID_P1_EL2, MECIDR_EL2, VMECID_A_EL2,
+	 * VMECID_P_EL2.
+	 */
+	SR_RANGE_TRAP(SYS_VBAR_EL2,
+		      SYS_RMR_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_VDISR_EL2,		CGT_HCR_NV),
+	/* ICH_AP0R<m>_EL2 */
+	SR_RANGE_TRAP(SYS_ICH_AP0R0_EL2,
+		      SYS_ICH_AP0R3_EL2, CGT_HCR_NV),
+	/* ICH_AP1R<m>_EL2 */
+	SR_RANGE_TRAP(SYS_ICH_AP1R0_EL2,
+		      SYS_ICH_AP1R3_EL2, CGT_HCR_NV),
+	SR_TRAP(SYS_ICC_SRE_EL2,	CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_ICH_HCR_EL2,
+		      SYS_ICH_EISR_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_ICH_ELRSR_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_ICH_VMCR_EL2,	CGT_HCR_NV),
+	/* ICH_LR<m>_EL2 */
+	SR_RANGE_TRAP(SYS_ICH_LR0_EL2,
+		      SYS_ICH_LR15_EL2, CGT_HCR_NV),
+	SR_TRAP(SYS_CONTEXTIDR_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_TPIDR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_SCXTNUM_EL2,	CGT_HCR_NV),
+	/* AMEVCNTVOFF0<n>_EL2, AMEVCNTVOFF1<n>_EL2  */
+	SR_RANGE_TRAP(SYS_AMEVCNTVOFF0n_EL2(0),
+		      SYS_AMEVCNTVOFF1n_EL2(15), CGT_HCR_NV),
+	/* CNT*_EL2 */
+	SR_TRAP(SYS_CNTVOFF_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTPOFF_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_CNTHCTL_EL2,	CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_CNTHP_TVAL_EL2,
+		      SYS_CNTHP_CVAL_EL2, CGT_HCR_NV),
+	SR_RANGE_TRAP(SYS_CNTHV_TVAL_EL2,
+		      SYS_CNTHV_CVAL_EL2, CGT_HCR_NV),
 	/* All _EL02, _EL12 registers */
 	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
 		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
-- 
2.39.2

