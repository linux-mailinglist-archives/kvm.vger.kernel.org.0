Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2379E5751F6
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbiGNPfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239033AbiGNPfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB07357240
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 083A761F32
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68483C34115;
        Thu, 14 Jul 2022 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812935;
        bh=ZYt+0ERx294azpe4PSev7OqokFs/fdNlq0xi8F7g1mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6WxJhOa+asFGqORZ8uu44nBebKWCkVgF9Oshsmt9ZDybYIvjW7xB/uBLSFfUUMKg
         LzWaBa4p8nQC3/0MDNt4hqbY29IwD0zH7AWwdhk8+3UxjABjv5GoaqladBCH/5eY1P
         u7wrm/AzTu2ko/O7vHetaPRSqeoilf6Z72fWXJXxTQBTjsxjutedoELHeB+iPDm8b5
         uD2wnwEPIVDVE8NnxGMDiaGzyOCedTqYcPCZAYkXZdqlLEnnS57ajT648EwFn92e8f
         sd12/5FOBUT/tc7VqXmnWeDyuDApdP1eczmFt0h0Q2/kGBtKEKRdbCKfx2/MBllgxx
         8GOXS2LbuqCNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dj-007UVL-8y;
        Thu, 14 Jul 2022 16:20:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 11/20] KVM: arm64: vgic-v3: Use u32 to manage the line level from userspace
Date:   Thu, 14 Jul 2022 16:20:15 +0100
Message-Id: <20220714152024.1673368-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Despite the userspace ABI clearly defining the bits dealt with by
KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO as a __u32, the kernel uses a u64.

Use a u32 to match the userspace ABI, which will subsequently lead
to some simplifications.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 6 +++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       | 6 +++---
 arch/arm64/kvm/vgic/vgic-mmio.h       | 4 ++--
 arch/arm64/kvm/vgic/vgic.h            | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index bf745c6ab2ea..f02294b9aef1 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -570,10 +570,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
 			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
 		if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
+			if (is_write)
+				tmp32 = *reg;
 			intid = attr->attr &
 				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
 			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
-							      intid, reg);
+							      intid, &tmp32);
+			if (!is_write)
+				*reg = tmp32;
 		} else {
 			ret = -EINVAL;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a2ff73899976..91201f743033 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -1154,7 +1154,7 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 }
 
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-				    u32 intid, u64 *val)
+				    u32 intid, u32 *val)
 {
 	if (intid % 32)
 		return -EINVAL;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 997d0fce2088..b32d434c1d4a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -775,10 +775,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 	}
 }
 
-u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
+u32 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
 {
 	int i;
-	u64 val = 0;
+	u32 val = 0;
 	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
 
 	for (i = 0; i < 32; i++) {
@@ -798,7 +798,7 @@ u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
 }
 
 void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
-				    const u64 val)
+				    const u32 val)
 {
 	int i;
 	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 6082d4b66d39..5b490a4dfa5e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -207,10 +207,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
 		 bool is_write, int offset, u32 *val);
 
-u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
+u32 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
 
 void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
-				    const u64 val);
+				    const u32 val);
 
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c23118467a35..0c8da72953f0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -249,7 +249,7 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-				    u32 intid, u64 *val);
+				    u32 intid, u32 *val);
 int kvm_register_vgic_device(unsigned long type);
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-- 
2.34.1

