Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA60A751959
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 09:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbjGMHIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 03:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbjGMHH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 03:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDE3272B;
        Thu, 13 Jul 2023 00:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702AC61A35;
        Thu, 13 Jul 2023 07:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DCCC433C7;
        Thu, 13 Jul 2023 07:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689232053;
        bh=c0yEUSYW3jDU+Bip/M9LxYAfyMmi3Ngn1ODIWEjnvyo=;
        h=From:To:Cc:Subject:Date:From;
        b=b6gUMZiiVCVDYqCvJtHwcRPdNqvPw153scobiJcGpIWJO0rBAdLU76aKtG4eyI+IW
         70eDzeBntwwiCX7DYQHuqGO6vfhd1m0c3IPbZMEdlptwRTGNO2TQg9TqRFtyZOleoL
         lVcvtz/sYHew6bMRrJl+j9n5sqCuylffp5WQomxaj+R8MSBU/FrxrXtaKYAeaA2eWq
         B9w9IKubQWlmoC3KiqqmxuZbz6cCwJl5aZ6087wTqG6Rf791LKDK7ryUuGqtFrgrLo
         4Oc+ZIp6ZQczEhLtb9IyZavqVNR2sT8MEJvX8sO+v9rTN+KAQ23+mUU/cHrfhONIOd
         GKkQiaSOyk1lA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJqQF-00ChZk-JE;
        Thu, 13 Jul 2023 08:07:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption
Date:   Thu, 13 Jul 2023 08:06:57 +0100
Message-Id: <20230713070657.3873244-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org, chenxiang66@hisilicon.com
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

Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
running a preemptible kernel, as it is possible that a vCPU is blocked
without requesting a doorbell interrupt.

The issue is that any preemption that occurs between vgic_v4_put() and
schedule() on the block path will mark the vPE as nonresident and *not*
request a doorbell irq. This occurs because when the vcpu thread is
resumed on its way to block, vcpu_load() will make the vPE resident
again. Once the vcpu actually blocks, we don't request a doorbell
anymore, and the vcpu won't be woken up on interrupt delivery.

Fix it by tracking that we're entering WFI, and key the doorbell
request on that flag. This allows us not to make the vPE resident
when going through a preempt/schedule cycle, meaning we don't lose
any state.

Cc: stable@vger.kernel.org
Fixes: 8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/arm.c              | 6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c     | 2 +-
 arch/arm64/kvm/vgic/vgic-v4.c     | 7 +++++--
 include/kvm/arm_vgic.h            | 2 +-
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1e768481f62f..914fc9c26e40 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -817,6 +817,8 @@ struct kvm_vcpu_arch {
 #define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
 /* PMUSERENR for the guest EL0 is on physical CPU */
 #define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(6))
+/* WFI instruction trapped */
+#define IN_WFI			__vcpu_single_flag(sflags, BIT(7))
 
 /* vcpu entered with HCR_EL2.E2H set */
 #define VCPU_HCR_E2H		__vcpu_single_flag(oflags, BIT(0))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 236c5f1c9090..cf208d30a9ea 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -725,13 +725,15 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	 */
 	preempt_disable();
 	kvm_vgic_vmcr_sync(vcpu);
-	vgic_v4_put(vcpu, true);
+	vcpu_set_flag(vcpu, IN_WFI);
+	vgic_v4_put(vcpu);
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
 	vcpu_clear_flag(vcpu, IN_WFIT);
 
 	preempt_disable();
+	vcpu_clear_flag(vcpu, IN_WFI);
 	vgic_v4_load(vcpu);
 	preempt_enable();
 }
@@ -799,7 +801,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_RELOAD_GICv4, vcpu)) {
 			/* The distributor enable bits were changed */
 			preempt_disable();
-			vgic_v4_put(vcpu, false);
+			vgic_v4_put(vcpu);
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 49d35618d576..df61ead7c757 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -780,7 +780,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 	 * done a vgic_v4_put) and when running a nested guest (the
 	 * vPE was never resident in order to generate a doorbell).
 	 */
-	WARN_ON(vgic_v4_put(vcpu, false));
+	WARN_ON(vgic_v4_put(vcpu));
 
 	vgic_v3_vmcr_sync(vcpu);
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c1c28fe680ba..339a55194b2c 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -336,14 +336,14 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
-int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
+int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	return its_make_vpe_non_resident(vpe, need_db);
+	return its_make_vpe_non_resident(vpe, !!vcpu_get_flag(vcpu, IN_WFI));
 }
 
 int vgic_v4_load(struct kvm_vcpu *vcpu)
@@ -354,6 +354,9 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
 		return 0;
 
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		return 0;
+
 	/*
 	 * Before making the VPE resident, make sure the redistributor
 	 * corresponding to our current CPU expects us here. See the
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9b91a8135dac..765d801d1ddc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -446,7 +446,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 
 int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
-int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
+int vgic_v4_put(struct kvm_vcpu *vcpu);
 
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
 
-- 
2.34.1

