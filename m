Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F04D77477D
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjHHTPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbjHHTOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE5A145A2
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7529962506
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2C9C433C9;
        Tue,  8 Aug 2023 11:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495294;
        bh=bkqdsGvWZEL+aXwypUST1zeGFbuvnyz5un6wBijD0pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9bcdnAHCWYgpDvv4jdJQNa5itJT9GWP50mcZa6d2FPUFwq0i2N80Z035tAX++lZu
         7fsyc8QF26Emlo9hRwvDgoKGJbSALtHF+i7M9HtnwMWaESKRf0GeeyhdJohlSKWY2O
         s653EF+a1nmXUWfQtYToQpTf1WI4Lz2buhC1qGi+MfDNal+ALwRF89C+X9az49n4D5
         jF2KDg2iPS/SF2kuEM4toM86u+Iyeiv7jSvIlVNlkFAoxNU5XomVIgt70wjl3jYrnj
         Wr8dizDuKeyaw5R69MkrU4Ob3kN+Jiw/V0K508bmwDwn3r1tl6+F3r3nhaCppu3N7t
         DB//X81iWS+Cg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBJ-0037Ph-LM;
        Tue, 08 Aug 2023 12:47:21 +0100
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
Subject: [PATCH v3 20/27] KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
Date:   Tue,  8 Aug 2023 12:47:04 +0100
Message-Id: <20230808114711.2013842-21-maz@kernel.org>
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
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the trap forwarding for traps described by HFGxTR_EL2,
reusing the Fine Grained Traps infrastructure previously implemented.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 71 +++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index af75c2775638..4c0a264ec2b2 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -930,6 +930,7 @@ static DEFINE_XARRAY(sr_forward_xa);
 
 enum fgt_group_id {
 	__NO_FGT_GROUP__,
+	HFGxTR_GROUP,
 
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -947,6 +948,69 @@ enum fgt_group_id {
 	}
 
 static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
+	/* HFGRTR_EL2, HFGWTR_EL2 */
+	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
+	SR_FGT(SYS_SMPRI_EL1,		HFGxTR, nSMPRI_EL1, 0),
+	SR_FGT(SYS_ACCDATA_EL1,		HFGxTR, nACCDATA_EL1, 0),
+	SR_FGT(SYS_ERXADDR_EL1,		HFGxTR, ERXADDR_EL1, 1),
+	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGxTR, ERXPFGCDN_EL1, 1),
+	SR_FGT(SYS_ERXPFGCTL_EL1,	HFGxTR, ERXPFGCTL_EL1, 1),
+	SR_FGT(SYS_ERXPFGF_EL1,		HFGxTR, ERXPFGF_EL1, 1),
+	SR_FGT(SYS_ERXMISC0_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXMISC1_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXMISC2_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXMISC3_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXSTATUS_EL1,	HFGxTR, ERXSTATUS_EL1, 1),
+	SR_FGT(SYS_ERXCTLR_EL1,		HFGxTR, ERXCTLR_EL1, 1),
+	SR_FGT(SYS_ERXFR_EL1,		HFGxTR, ERXFR_EL1, 1),
+	SR_FGT(SYS_ERRSELR_EL1,		HFGxTR, ERRSELR_EL1, 1),
+	SR_FGT(SYS_ERRIDR_EL1,		HFGxTR, ERRIDR_EL1, 1),
+	SR_FGT(SYS_ICC_IGRPEN0_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
+	SR_FGT(SYS_ICC_IGRPEN1_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
+	SR_FGT(SYS_VBAR_EL1,		HFGxTR, VBAR_EL1, 1),
+	SR_FGT(SYS_TTBR1_EL1,		HFGxTR, TTBR1_EL1, 1),
+	SR_FGT(SYS_TTBR0_EL1,		HFGxTR, TTBR0_EL1, 1),
+	SR_FGT(SYS_TPIDR_EL0,		HFGxTR, TPIDR_EL0, 1),
+	SR_FGT(SYS_TPIDRRO_EL0,		HFGxTR, TPIDRRO_EL0, 1),
+	SR_FGT(SYS_TPIDR_EL1,		HFGxTR, TPIDR_EL1, 1),
+	SR_FGT(SYS_TCR_EL1,		HFGxTR, TCR_EL1, 1),
+	SR_FGT(SYS_SCXTNUM_EL0,		HFGxTR, SCXTNUM_EL0, 1),
+	SR_FGT(SYS_SCXTNUM_EL1, 	HFGxTR, SCXTNUM_EL1, 1),
+	SR_FGT(SYS_SCTLR_EL1, 		HFGxTR, SCTLR_EL1, 1),
+	SR_FGT(SYS_REVIDR_EL1, 		HFGxTR, REVIDR_EL1, 1),
+	SR_FGT(SYS_PAR_EL1, 		HFGxTR, PAR_EL1, 1),
+	SR_FGT(SYS_MPIDR_EL1, 		HFGxTR, MPIDR_EL1, 1),
+	SR_FGT(SYS_MIDR_EL1, 		HFGxTR, MIDR_EL1, 1),
+	SR_FGT(SYS_MAIR_EL1, 		HFGxTR, MAIR_EL1, 1),
+	SR_FGT(SYS_LORSA_EL1, 		HFGxTR, LORSA_EL1, 1),
+	SR_FGT(SYS_LORN_EL1, 		HFGxTR, LORN_EL1, 1),
+	SR_FGT(SYS_LORID_EL1, 		HFGxTR, LORID_EL1, 1),
+	SR_FGT(SYS_LOREA_EL1, 		HFGxTR, LOREA_EL1, 1),
+	SR_FGT(SYS_LORC_EL1, 		HFGxTR, LORC_EL1, 1),
+	SR_FGT(SYS_ISR_EL1, 		HFGxTR, ISR_EL1, 1),
+	SR_FGT(SYS_FAR_EL1, 		HFGxTR, FAR_EL1, 1),
+	SR_FGT(SYS_ESR_EL1, 		HFGxTR, ESR_EL1, 1),
+	SR_FGT(SYS_DCZID_EL0, 		HFGxTR, DCZID_EL0, 1),
+	SR_FGT(SYS_CTR_EL0, 		HFGxTR, CTR_EL0, 1),
+	SR_FGT(SYS_CSSELR_EL1, 		HFGxTR, CSSELR_EL1, 1),
+	SR_FGT(SYS_CPACR_EL1, 		HFGxTR, CPACR_EL1, 1),
+	SR_FGT(SYS_CONTEXTIDR_EL1, 	HFGxTR, CONTEXTIDR_EL1, 1),
+	SR_FGT(SYS_CLIDR_EL1, 		HFGxTR, CLIDR_EL1, 1),
+	SR_FGT(SYS_CCSIDR_EL1, 		HFGxTR, CCSIDR_EL1, 1),
+	SR_FGT(SYS_APIBKEYLO_EL1, 	HFGxTR, APIBKey, 1),
+	SR_FGT(SYS_APIBKEYHI_EL1, 	HFGxTR, APIBKey, 1),
+	SR_FGT(SYS_APIAKEYLO_EL1, 	HFGxTR, APIAKey, 1),
+	SR_FGT(SYS_APIAKEYHI_EL1, 	HFGxTR, APIAKey, 1),
+	SR_FGT(SYS_APGAKEYLO_EL1, 	HFGxTR, APGAKey, 1),
+	SR_FGT(SYS_APGAKEYHI_EL1, 	HFGxTR, APGAKey, 1),
+	SR_FGT(SYS_APDBKEYLO_EL1, 	HFGxTR, APDBKey, 1),
+	SR_FGT(SYS_APDBKEYHI_EL1, 	HFGxTR, APDBKey, 1),
+	SR_FGT(SYS_APDAKEYLO_EL1, 	HFGxTR, APDAKey, 1),
+	SR_FGT(SYS_APDAKEYHI_EL1, 	HFGxTR, APDAKey, 1),
+	SR_FGT(SYS_AMAIR_EL1, 		HFGxTR, AMAIR_EL1, 1),
+	SR_FGT(SYS_AIDR_EL1, 		HFGxTR, AIDR_EL1, 1),
+	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
+	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
@@ -1127,6 +1191,13 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	case __NO_FGT_GROUP__:
 		break;
 
+	case HFGxTR_GROUP:
+		if (is_read)
+			val = sanitised_sys_reg(vcpu, HFGRTR_EL2);
+		else
+			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
+		break;
+
 	case __NR_FGT_GROUP_IDS__:
 		/* Something is really wrong, bail out */
 		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
-- 
2.34.1

