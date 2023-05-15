Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2316E703A1C
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbjEORtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244731AbjEORsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:48:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272BF4C9E1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED6262EFB
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1162C433D2;
        Mon, 15 May 2023 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172813;
        bh=psrHzuctoY4A00LSQJnXXY7988BD9rN0ECYit6Zxphc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQSiSyh0YzweA7D4m+8zi9oMj7TRTDJkUxtZ0vaKzRX+s2aDt31qjIvxPRZgLhF2D
         3mceAGB8h10A5S56fbz5SQLXwmeWOrYCvvsWn54BZI+k2Y/Oa1n59BoE8W/GW01/m0
         Klqk9m3mwye5TmSMG/W4hJVleDff9VSKNZca2O3zYe6jHZcsSAPirY+aEj965hafsQ
         UZ05PgeNr7dg+uCZPsZdqROxaPeGy997XIAJBJYkJ3YiIN2If7yGm4/8l28aL1g6kt
         cMTMqQGCUOjCReffUDFjVQy2rPOiZhindEyqaNLZcpgBFVD8Y5wkroebku/xvgxheM
         QV/ftQB0gcl2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2h-00FJAF-0B;
        Mon, 15 May 2023 18:31:27 +0100
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
Subject: [PATCH v10 14/59] KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
Date:   Mon, 15 May 2023 18:30:18 +0100
Message-Id: <20230515173103.1017669-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some EL2 system registers immediately affect the current execution
of the system, so we need to use their respective EL1 counterparts.
For this we need to define a mapping between the two. In general,
this only affects non-VHE guest hypervisors, as VHE system registers
are compatible with the EL1 counterparts.

These helpers will get used in subsequent patches.

Co-developed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 48 +++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index fa23cc9c2adc..9099df57037d 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -2,6 +2,7 @@
 #ifndef __ARM64_KVM_NESTED_H
 #define __ARM64_KVM_NESTED_H
 
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
 static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
@@ -11,6 +12,53 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+/* Translation helpers from non-VHE EL2 to EL1 */
+static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
+{
+	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
+}
+
+static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
+{
+	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
+	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+	       tcr_el2_ps_to_tcr_el1_ips(tcr) |
+	       (tcr & TCR_EL2_TG0_MASK) |
+	       (tcr & TCR_EL2_ORGN0_MASK) |
+	       (tcr & TCR_EL2_IRGN0_MASK) |
+	       (tcr & TCR_EL2_T0SZ_MASK);
+}
+
+static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
+{
+	u64 cpacr_el1 = 0;
+
+	if (cptr_el2 & CPTR_EL2_TTA)
+		cpacr_el1 |= CPACR_ELx_TTA;
+	if (!(cptr_el2 & CPTR_EL2_TFP))
+		cpacr_el1 |= CPACR_ELx_FPEN;
+	if (!(cptr_el2 & CPTR_EL2_TZ))
+		cpacr_el1 |= CPACR_ELx_ZEN;
+
+	return cpacr_el1;
+}
+
+static inline u64 translate_sctlr_el2_to_sctlr_el1(u64 val)
+{
+	/* Only preserve the minimal set of bits we support */
+	val &= (SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | SCTLR_ELx_SA |
+		SCTLR_ELx_I | SCTLR_ELx_IESB | SCTLR_ELx_WXN | SCTLR_ELx_EE);
+	val |= SCTLR_EL1_RES1;
+
+	return val;
+}
+
+static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
+{
+	/* Clear the ASID field */
+	return ttbr0 & ~GENMASK_ULL(63, 48);
+}
+
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
 
 struct sys_reg_params;
-- 
2.34.1

