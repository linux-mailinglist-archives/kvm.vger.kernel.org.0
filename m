Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F1F77D270
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbjHOSu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239412AbjHOStu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40EE212A
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFFF362DE0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47431C433D9;
        Tue, 15 Aug 2023 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692125260;
        bh=5ooKHnxOdvFBDiSzo9bxLUNHxcb2gylQRwAInopqJ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtiO7TuHY0gI7MewwBj7dPHspO6iK6muQtsR1vnu2W5YGlMgvIUDwJDCqOag6fF+1
         iOcwKZNAsQsydRjmJ8ATt2gaavHw+T+6uSiPdEc8ritqwWyK6HGkL6TapAnh4v5p7x
         6wP0m7Q0dSby4VB8uyvdtmbsKkrY+y8mJp7eLRTKxp6logAl1P9I0Kq0TcHO4TCF0T
         1tTSBeaXR3Pzyy9rbdwOiWJ2MY6HoZjq2scG7c04+SSZwiJBOwq0S3K4lXh3EK9+dl
         zqmfLSKg6Ix+h1aX1wVRNoLkphL1aZdUaP2j/BwOdngMpA4iulo+OGAo+oPYK402+1
         X1L53tH8LNYKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywr-0055Sd-Vx;
        Tue, 15 Aug 2023 19:39:22 +0100
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
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 25/28] KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
Date:   Tue, 15 Aug 2023 19:38:59 +0100
Message-Id: <20230815183903.2735724-26-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Now that we can evaluate the FGT registers, allow them to be merged
with the hypervisor's own configuration (in the case of HFG{RW}TR_EL2)
or simply set for HFGITR_EL2, HDGFRTR_EL2 and HDFGWTR_EL2.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 48 +++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e096b16e85fd..a4750070563f 100644
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
 
 	/* The default is not to trap anything but ACCDATA_EL1 */
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

