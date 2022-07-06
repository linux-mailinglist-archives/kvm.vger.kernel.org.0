Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7307C569043
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiGFRF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiGFRFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADEC2A700
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDFD961E7B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AACDC341CE;
        Wed,  6 Jul 2022 17:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127124;
        bh=SzPjuICUXJCvp7Vyuk4xgoPaa1J68WeSY55X5c3s7E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNmdlYOPGWqMPt6F0RNswucx/WjxxHsiS7b6Vrmn7juUr+L1KYydfabS7maWs72TH
         ShptmKAtYryxigs0+2TE2+SqHz3I5QYtpOo2Vc4oO6lylpkYgCAH2+lDXubdkk8ssA
         CUWa0M1BxY21VES/03yqMbTEQyReLBKU/slhFZDml9kVnJY86qoThEYWULoCkwdRUy
         TSFrRrEWcppu1sx6n0bf+AXTy8riBDvz6oIyKgSRw0RydO19w+QpmSHHYYIF6l4uDe
         NX9Addy1mDAxSpo8ho9Gki0VjHwfX51LPTi/YTBKsSo64K8O1QQnw4laDpf+TPOfxY
         iLwRDlMMP2XKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987N-005h9i-G0;
        Wed, 06 Jul 2022 17:43:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 13/19] KVM: arm64: vgic-v2: Consolidate userspace access for MMIO registers
Date:   Wed,  6 Jul 2022 17:42:58 +0100
Message-Id: <20220706164304.1582687-14-maz@kernel.org>
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

Align the GICv2 MMIO accesses from userspace with the way the GICv3
code is now structured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 40 ++++++++++++---------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 925875722027..ddead333c232 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -348,17 +348,18 @@ bool lock_all_vcpus(struct kvm *kvm)
  *
  * @dev:      kvm device handle
  * @attr:     kvm device attribute
- * @reg:      address the value is read or written
  * @is_write: true if userspace is writing a register
  */
 static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 				    struct kvm_device_attr *attr,
-				    u32 *reg, bool is_write)
+				    bool is_write)
 {
+	u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
 	int ret;
+	u32 val;
 
 	ret = vgic_v2_parse_attr(dev, attr, &reg_attr);
 	if (ret)
@@ -367,6 +368,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	vcpu = reg_attr.vcpu;
 	addr = reg_attr.addr;
 
+	if (is_write)
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
 	mutex_lock(&dev->kvm->lock);
 
 	ret = vgic_init(dev->kvm);
@@ -380,10 +385,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &val);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &val);
 		break;
 	default:
 		ret = -EINVAL;
@@ -393,6 +398,11 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
+
+	if (!ret && !is_write)
+		if (put_user(val, uaddr))
+			ret = -EFAULT;
+
 	return ret;
 }
 
@@ -407,15 +417,8 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg;
-
-		if (get_user(reg, uaddr))
-			return -EFAULT;
-
-		return vgic_v2_attr_regs_access(dev, attr, &reg, true);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v2_attr_regs_access(dev, attr, true);
 	}
 
 	return -ENXIO;
@@ -432,15 +435,8 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg = 0;
-
-		ret = vgic_v2_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		return put_user(reg, uaddr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v2_attr_regs_access(dev, attr, false);
 	}
 
 	return -ENXIO;
-- 
2.34.1

