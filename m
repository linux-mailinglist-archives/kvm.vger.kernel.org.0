Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD2569041
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiGFRFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiGFRFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4712A700
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C6B61E42
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED0C3411C;
        Wed,  6 Jul 2022 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127117;
        bh=jV4zco2Mv+ssvf7rVfcuruh/1SYjZXldlxUh9uZ7GiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+Ky/ANoR24yHkJgSUkzPccZamvEc1zzCrzHH2Nw5Nn6a4lDF6AZvFpCnGYFEoB5R
         JTZnMAsoJFizyr4iMgZ33Majtr7u/+WpvA4aCnsLNzm0x+8kuk0X1yaDeSVf5s2Z/g
         0g8JrthsW9Q+h7jT2ssdmYk4x5Yn0AARBd2xRnwKwzC82AKKAx6WlsaAKt5BhmuyVM
         YA45rjdzqJiGNvxDCm/tJCR0GihKI3ODEFvTpd5u9vg+5Hsev+Z2mGKIZaZTn0UedQ
         URJM0ArcpceQnv2U4O+e9j2HNeezY/2yrKDCGQr08tFzJnh7AztorW1ufz1ywdt8NS
         XAWmwlMPQSBXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987N-005h9i-Uo;
        Wed, 06 Jul 2022 17:43:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 15/19] KVM: arm64: vgic-v2: Add helper for legacy dist/cpuif base address setting
Date:   Wed,  6 Jul 2022 17:43:00 +0100
Message-Id: <20220706164304.1582687-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We carry a legacy interface to set the base addresses for GICv2.
As this is currently plumbed into the same handling code as
the modern interface, it limits the evolution we can make there.

Add a helper dedicated to this handling, with a view of maybe
removing this in the future.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c                  | 11 ++-------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 32 +++++++++++++++++++++++++++
 include/kvm/arm_vgic.h                |  1 +
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 83a7f61354d3..bf39570c0aef 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1414,18 +1414,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 					struct kvm_arm_device_addr *dev_addr)
 {
-	unsigned long dev_id, type;
-
-	dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
-		KVM_ARM_DEVICE_ID_SHIFT;
-	type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
-		KVM_ARM_DEVICE_TYPE_SHIFT;
-
-	switch (dev_id) {
+	switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
 	case KVM_ARM_DEVICE_VGIC_V2:
 		if (!vgic_present)
 			return -ENXIO;
-		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
+		return kvm_set_legacy_vgic_v2_addr(kvm, dev_addr);
 	default:
 		return -ENODEV;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index fbbd0338c782..0dfd277b9058 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -41,6 +41,38 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
 		return 0;
 }
 
+int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr)
+{
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	int r;
+
+	mutex_lock(&kvm->lock);
+	switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
+	case KVM_VGIC_V2_ADDR_TYPE_DIST:
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
+		if (!r)
+			r = vgic_check_iorange(kvm, vgic->vgic_dist_base, dev_addr->addr,
+					       SZ_4K, KVM_VGIC_V2_DIST_SIZE);
+		if (!r)
+			vgic->vgic_dist_base = dev_addr->addr;
+		break;
+	case KVM_VGIC_V2_ADDR_TYPE_CPU:
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
+		if (!r)
+			r = vgic_check_iorange(kvm, vgic->vgic_cpu_base, dev_addr->addr,
+					       SZ_4K, KVM_VGIC_V2_CPU_SIZE);
+		if (!r)
+			vgic->vgic_cpu_base = dev_addr->addr;
+		break;
+	default:
+		r = -ENODEV;
+	}
+
+	mutex_unlock(&kvm->lock);
+
+	return r;
+}
+
 /**
  * kvm_vgic_addr - set or get vgic VM base addresses
  * @kvm:   pointer to the vm struct
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2d8f2e90edc2..f79cce67563e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -365,6 +365,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
 extern struct static_key_false vgic_v3_cpuif_trap;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
 void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
-- 
2.34.1

