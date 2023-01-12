Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F46667A1A
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjALP6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbjALP6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:58:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D992A17887
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C248B81E72
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 15:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598CBC433D2;
        Thu, 12 Jan 2023 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673538525;
        bh=tT7XB6M2BGozhIHF+kdI15sy1eTDsUnElWCzbvSqSKw=;
        h=From:To:Cc:Subject:Date:From;
        b=lwOJfrDnjY+HLzvqKiM8JuOBTB0I4BYes+DnYBgGJY0KaBOONGlbqjT++jQKiz0AU
         UPtz+18QPFwIhgvlYuBaFdz+QfsjUVSEAbXgzGryq5KvzRSKcSgvW60cnn2/VBKvpQ
         FwZmPteauog/aaZ7llOK4YOGBxdj8HCfJddECeK/AfNdaJH2pqodQXn+ajtzHVR8Ny
         gEVk7mSe+YLQzLkpAQjhMHGW44XCZG2FS+CdQWDr6+3cupzQbBbJLBbkA1g6tmW1b/
         wolpgMx7QUp5RhQIgnOKs4LkHgDYfjHlz8BoFoOU+KdbKcgedNBOegQiBM66lGalWX
         oIzRCvkNOnwrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pFzop-001Ecv-4p;
        Thu, 12 Jan 2023 15:48:43 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH] KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
Date:   Thu, 12 Jan 2023 15:48:40 +0000
Message-Id: <20230112154840.1808595-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, gankulkarni@os.amperecomputing.com
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

When a vcpu is accessing *its own* redistributor's SGIs/PPIs, there
is no point in doing a stop-the-world operation. Instead, we can
just let the access occur as we do with GICv2.

This is a very minor optimisation for a non-nesting guest, but
a potentially major one for a nesting L1 hypervisor which is
likely to access the emulated registers pretty often (on each
vcpu switch, at the very least).

Reported-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b32d434c1d4a..e67b3b2c8044 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
  * active state can be overwritten when the VCPU's state is synced coming back
  * from the guest.
  *
- * For shared interrupts as well as GICv3 private interrupts, we have to
- * stop all the VCPUs because interrupts can be migrated while we don't hold
- * the IRQ locks and we don't want to be chasing moving targets.
+ * For shared interrupts as well as GICv3 private interrupts accessed from the
+ * non-owning CPU, we have to stop all the VCPUs because interrupts can be
+ * migrated while we don't hold the IRQ locks and we don't want to be chasing
+ * moving targets.
  *
  * For GICv2 private interrupts we don't have to do anything because
  * userspace accesses to the VGIC state already require all VCPUs to be
@@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
  */
 static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	     vcpu != kvm_get_running_vcpu()) ||
 	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_halt_guest(vcpu->kvm);
 }
@@ -492,7 +494,8 @@ static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 /* See vgic_access_active_prepare */
 static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	     vcpu != kvm_get_running_vcpu()) ||
 	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
-- 
2.34.1

