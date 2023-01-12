Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E13667F54
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbjALT3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbjALT2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:28:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDC93C70B
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8224B82016
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6CAC433EF;
        Thu, 12 Jan 2023 19:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551321;
        bh=HsN037LfeuyfMRmeB8Br5r4HgPUnJHbRpc4tZpWUniw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvBvpCWWZ2Em86efUN2bNzDiMtHm9oOGSbWYq6J/fDJ+DLj9mmDzraX2EMDx4rHt/
         pzjOisYfsi8Zz37tMeNPpq0o710G+lBqXkXEHKniUqALDKVfZqRCSPpGNov05kKiBp
         wAbPbdOS889BQMoL6w+XKgQlqfq3TapYh2zqW8F4vPbo16bCBOOOVARMbuUz09lTXD
         f03WuCEICKhvMwCC2+Zo8++Votp63iqsUHq3dWl9oZ4bUvcWkfAEQNZeFcRum8wks9
         CY5iui4aaKpR2eHu6oZTXa6FIam7Se6lNWvL2dxEs1okroAwZYmFU/GalPaML+IPJ7
         zWDt2BI5mUyRA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG374-001IWu-TR;
        Thu, 12 Jan 2023 19:19:46 +0000
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
Subject: [PATCH v7 30/68] KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
Date:   Thu, 12 Jan 2023 19:18:49 +0000
Message-Id: <20230112191927.1814989-31-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 8425ef64d31a..5a9df623af94 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -88,6 +88,7 @@
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 )
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

