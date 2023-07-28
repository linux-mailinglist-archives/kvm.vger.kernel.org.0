Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808427667A4
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbjG1Irh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbjG1IrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:47:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5114E26A0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D696C62066
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4753CC433C8;
        Fri, 28 Jul 2023 08:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690534033;
        bh=zdcR96TxLDhslVFfMwlWSUvltXrwsh/CR3m9k5IspEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNY4P1o5euiLkI3CHLw84FBeF0bVcxt4JhJ12Nw6GmyK+qwJVqNNMjv53fdVgFGvM
         /lVL1t3beh1TzGII8Tk2sOphtqGzBU6fswfTdtNLvPRAOqRwsNW1YTkc+EnjcldLXl
         92Cnq0furERoe4JScG02D5lvQYe4B/Jlnv8sIE/94ujdAinLE7YOTHqfPkRu56Xdee
         0NoVje2IeSdQSH2vHxZP/fxXt+0seaXDwF+OJneM0WAp4PKREhNyHHUwe+IVS1N3n3
         cr9adwvcgOBTlVoUQMrQLf/Vn0S5yswYVxgVn2anCwjzMvJR9zQ57Uxp4UAbiCBI7y
         aZbQQK8Hr0TMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrN-0000EO-S1;
        Fri, 28 Jul 2023 09:30:06 +0100
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
Subject: [PATCH v2 23/26] KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
Date:   Fri, 28 Jul 2023 09:29:49 +0100
Message-Id: <20230728082952.959212-24-maz@kernel.org>
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

Now that we can evaluate the FGT registers, allow them to be merged
with the hypervisor's own configuration (in the case of HFG{RW}TR_EL2)
or simply set for HFGITR_EL2, HDGFRTR_EL2 and HDFGWTR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 48 +++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 966295178aee..ad9c730b7d1a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -70,6 +70,13 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
+#define compute_clr_set(vcpu, reg, clr, set)				\
+	do {								\
+		u64 hfg;						\
+		hfg = __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0;	\
+		set |= hfg & __ ## reg ## _MASK; 			\
+		clr |= ~hfg & __ ## reg ## _nMASK; 			\
+	} while(0)
 
 
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
@@ -97,6 +104,10 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
 		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
 
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
+		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
+	}
 
 	/* The default is not to trap amything but ACCDATA_EL1 */
 	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
@@ -109,6 +120,38 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
 	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
+
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		return;
+
+	ctxt_sys_reg(hctxt, HFGITR_EL2) = read_sysreg_s(SYS_HFGITR_EL2);
+
+	r_set = r_clr = 0;
+	compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
+	r_val = __HFGITR_EL2_nMASK;
+	r_val |= r_set;
+	r_val &= ~r_clr;
+
+	write_sysreg_s(r_val, SYS_HFGITR_EL2);
+
+	ctxt_sys_reg(hctxt, HDFGRTR_EL2) = read_sysreg_s(SYS_HDFGRTR_EL2);
+	ctxt_sys_reg(hctxt, HDFGWTR_EL2) = read_sysreg_s(SYS_HDFGWTR_EL2);
+
+	r_clr = r_set = w_clr = w_set = 0;
+
+	compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
+	compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
+
+	r_val = __HDFGRTR_EL2_nMASK;
+	r_val |= r_set;
+	r_val &= ~r_clr;
+
+	w_val = __HDFGWTR_EL2_nMASK;
+	w_val |= w_set;
+	w_val &= ~w_clr;
+
+	write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
+	write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
 }
 
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
@@ -121,7 +164,12 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
 	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
 
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		return;
 
+	write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
+	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
+	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
 }
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
-- 
2.34.1

