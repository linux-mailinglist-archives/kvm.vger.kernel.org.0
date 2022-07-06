Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56ADB569046
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiGFRFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiGFRFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7C22A700
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF4FB81DA3
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A7C341CB;
        Wed,  6 Jul 2022 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127137;
        bh=P3kpZG27EOyzbwnUFwH5BLDPgYgJ78A4FsqFCISXKZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vqu5DalMdRnEDhgbuskmb6WmTuIgFlmTrPC46S/MqAVFP0alUHkC5DabEui53L97O
         B5+efJst85W36SgIBUmJYtAhYgLf7McMaEYMwwpCFdvzpU7k6erywFpw0dhpcaESE5
         J0bSVBfOO99ILmANESFiM8/Vl9koa3LP3BSziV0CbkwPIqllYMfHdD1xkaev2gcDfV
         SZpOMmc3XuobZUgoMJzmUgadVBU+2bNxpxc5+Oyzy+L+mP/ZAyr38y3qpkCDMKQJyU
         pMPmvgy0q6f2aXuoUefVbbIHxGx2ZodSrv/UL1TZNERV/5H4xE15jU41PEU4s+GdRd
         zY5jtvJdwtGCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987N-005h9i-8D;
        Wed, 06 Jul 2022 17:43:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 12/19] KVM: arm64: vgic-v3: Consolidate userspace access for MMIO registers
Date:   Wed,  6 Jul 2022 17:42:57 +0100
Message-Id: <20220706164304.1582687-13-maz@kernel.org>
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

For userspace accesses to GICv3 MMIO registers (and related data),
vgic_v3_{get,set}_attr are littered with {get,put}_user() calls,
making it hard to audit and reason about.

Consolidate all userspace accesses in vgic_v3_attr_regs_access(),
makeing the code far simpler to audit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 104 ++++++++++----------------
 1 file changed, 38 insertions(+), 66 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 01285ee5cdf0..925875722027 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -512,18 +512,18 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
  *
  * @dev:      kvm device handle
  * @attr:     kvm device attribute
- * @reg:      address the value is read or written
  * @is_write: true if userspace is writing a register
  */
 static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 				    struct kvm_device_attr *attr,
-				    u64 *reg, bool is_write)
+				    bool is_write)
 {
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u32 val;
 	int ret;
-	u32 tmp32;
 
 	ret = vgic_v3_parse_attr(dev, attr, &reg_attr);
 	if (ret)
@@ -532,6 +532,21 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	vcpu = reg_attr.vcpu;
 	addr = reg_attr.addr;
 
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess = false;
+		break;
+	default:
+		uaccess = true;
+	}
+
+	if (uaccess && is_write) {
+		u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
+
 	mutex_lock(&dev->kvm->lock);
 
 	if (unlikely(!vgic_initialized(dev->kvm))) {
@@ -546,20 +561,10 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		if (is_write)
-			tmp32 = *reg;
-
-		ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &tmp32);
-		if (!is_write)
-			*reg = tmp32;
+		ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &val);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
-		if (is_write)
-			tmp32 = *reg;
-
-		ret = vgic_v3_redist_uaccess(vcpu, is_write, addr, &tmp32);
-		if (!is_write)
-			*reg = tmp32;
+		ret = vgic_v3_redist_uaccess(vcpu, is_write, addr, &val);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, attr, is_write);
@@ -570,14 +575,10 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
 			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
 		if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
-			if (is_write)
-				tmp32 = *reg;
 			intid = attr->attr &
 				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
 			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
-							      intid, &tmp32);
-			if (!is_write)
-				*reg = tmp32;
+							      intid, &val);
 		} else {
 			ret = -EINVAL;
 		}
@@ -591,6 +592,13 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
+
+	if (!ret && uaccess && !is_write) {
+		u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
+		if (put_user(val, uaddr))
+			ret = -EFAULT;
+	}
+
 	return ret;
 }
 
@@ -605,30 +613,12 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 tmp32;
-		u64 reg;
-
-		if (get_user(tmp32, uaddr))
-			return -EFAULT;
-
-		reg = tmp32;
-		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		return vgic_v3_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return vgic_v3_attr_regs_access(dev, attr, NULL, true);
-	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u64 reg;
-		u32 tmp32;
-
-		if (get_user(tmp32, uaddr))
-			return -EFAULT;
-
-		reg = tmp32;
-		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
-	}
+		return vgic_v3_attr_regs_access(dev, attr, true);
+	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
+		return vgic_v3_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
 		int ret;
 
@@ -662,30 +652,12 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u64 reg;
-		u32 tmp32;
-
-		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		tmp32 = reg;
-		return put_user(tmp32, uaddr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		return vgic_v3_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return vgic_v3_attr_regs_access(dev, attr, NULL, false);
-	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u64 reg;
-		u32 tmp32;
-
-		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		tmp32 = reg;
-		return put_user(tmp32, uaddr);
-	}
+		return vgic_v3_attr_regs_access(dev, attr, false);
+	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
+		return vgic_v3_attr_regs_access(dev, attr, false);
 	}
 	return -ENXIO;
 }
-- 
2.34.1

