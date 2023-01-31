Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A06828BF
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjAaJZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjAaJZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:25:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B673D1CF6B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 177806147B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7348FC4339C;
        Tue, 31 Jan 2023 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675157132;
        bh=IN38zzqmT51zPoMDhWxwQcjhiI4SC5y83JbwCGL5vQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBTIrytTLVVZhPJULkNoMwTIUOXNaFJRsDu+00XQSQIfniD+sduAb3eprXo3+Py8K
         mFnuAT+2wPTu7B+owO1swQfcCtuaAlWkhvIRjZX0KyAtQDd875eha21vK59k1wZVGe
         zcNct7YvGcY5fYtdb4HpenaWwiLVTA9Z5KJ7tyoesl/bBgBabJuheo8srTnayFi2HX
         agPcDdReJEWvEez7QZElM3gvcplUlTVmuCbOWoZB0k6XpYVVhjkckTrcAxNFr2r5LP
         pHtpTZ0BUcDC2HbAO8m7JgmLpL4wTbLqhUimuW9zurG2QxvF5R9+F96LaAK4TzFtcz
         ON641OcH+HWbg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtO-0067U2-MB;
        Tue, 31 Jan 2023 09:25:30 +0000
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
Subject: [PATCH v8 04/69] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
Date:   Tue, 31 Jan 2023 09:23:59 +0000
Message-Id: <20230131092504.2880505-5-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
feature is enabled on the VCPU.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: rework register reset not to use empty data structures]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 4a39da302b88..49a3257dec46 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
@@ -38,6 +39,9 @@ static u32 __ro_after_init kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
 				 PSR_F_BIT | PSR_D_BIT)
 
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
@@ -221,6 +225,10 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
 	if (kvm_has_mte(kvm) && is32bit)
 		return -EINVAL;
 
+	/* NV is incompatible with AArch32 */
+	if (vcpu_has_nv(vcpu) && is32bit)
+		return -EINVAL;
+
 	if (is32bit)
 		set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
 
@@ -273,6 +281,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
+	/* Disallow NV+SVE for the time being */
+	if (vcpu_has_nv(vcpu) && vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
 		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
 			ret = kvm_vcpu_enable_sve(vcpu);
@@ -295,6 +309,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	default:
 		if (vcpu_el1_is_32bit(vcpu)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
+		} else if (vcpu_has_nv(vcpu)) {
+			pstate = VCPU_RESET_PSTATE_EL2;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
-- 
2.34.1

