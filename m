Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3559E682935
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjAaJmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbjAaJmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:42:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC31367EF
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E72B6147C
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81361C433EF;
        Tue, 31 Jan 2023 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158111;
        bh=YcShdA+tKDmSUCRb0tpq6I2td/HqIONC//0886kHbTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=morjQ+tG9sde25Llo9Lz9zE6bCYM0OyRnuS5c2K7rtRsVRY3B5iYhn8fDesHV2ppG
         Uwgfg+PYxu1ulx7wniIq/F7opK2bYxYExcOssjrc/SXvEB32uAqjWwnziBpTeJ4EeE
         jAxxm+BTVj7DnD6UU+5E4DPjZriMUArSlqtqSZPxTiXfCn8QZ6hyx+rYDronSiieBE
         bfvL0N7kqDkTGwmLJX0OTxaMsuldda2vPsJFuhOVMZ2ZQSoKDUmmoEYHT5hceFEs+t
         CIS9/kF+GnGFKQ13nu2JzFIsUCmnzRjzbN8CDtXlG/XcrOAnQh/kDKhoh8g4TeEdYT
         w4jhfwFF+dg6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtW-0067U2-1g;
        Tue, 31 Jan 2023 09:25:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 31/69] KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
Date:   Tue, 31 Jan 2023 09:24:26 +0000
Message-Id: <20230131092504.2880505-32-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

From: Jintack Lim <jintack.lim@linaro.org>

We enable nested virtualization by setting the HCR NV and NV1 bit.

When the virtual E2H bit is set, we can support EL2 register accesses
via EL1 registers from the virtual EL2 by doing trap-and-emulate. A
better alternative, however, is to allow the virtual EL2 to access EL2
register states without trap. This can be easily achieved by not traping
EL1 registers since those registers already have EL2 register states.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/hyp/vhe/switch.c  | 38 +++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8e2b0bf1f484..1ea71d26823c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -89,6 +89,7 @@
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID2)
+#define HCR_GUEST_NV_FILTER_FLAGS (HCR_ATA | HCR_API | HCR_APK | HCR_FIEN)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 41385bb02d6b..36b50e315504 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -38,9 +38,41 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	u64 hcr = vcpu->arch.hcr_el2;
 	u64 val;
 
-	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
-	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
-		hcr |= HCR_TVM | HCR_TRVM;
+	if (is_hyp_ctxt(vcpu)) {
+		hcr |= HCR_NV;
+
+		if (!vcpu_el2_e2h_is_set(vcpu)) {
+			/*
+			 * For a guest hypervisor on v8.0, trap and emulate
+			 * the EL1 virtual memory control register accesses.
+			 */
+			hcr |= HCR_TVM | HCR_TRVM | HCR_NV1;
+		} else {
+			/*
+			 * For a guest hypervisor on v8.1 (VHE), allow to
+			 * access the EL1 virtual memory control registers
+			 * natively. These accesses are to access EL2 register
+			 * states.
+			 * Note that we still need to respect the virtual
+			 * HCR_EL2 state.
+			 */
+			u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+			vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
+
+			/*
+			 * We already set TVM to handle set/way cache maint
+			 * ops traps, this somewhat collides with the nested
+			 * virt trapping for nVHE. So turn this off for now
+			 * here, in the hope that VHE guests won't ever do this.
+			 * TODO: find out whether it's worth to support both
+			 * cases at the same time.
+			 */
+			hcr &= ~HCR_TVM;
+
+			hcr |= vhcr_el2 & (HCR_TVM | HCR_TRVM);
+		}
+	}
 
 	___activate_traps(vcpu, hcr);
 
-- 
2.34.1

