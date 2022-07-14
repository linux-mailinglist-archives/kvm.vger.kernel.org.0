Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E335751E4
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiGNPf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiGNPfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:35:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2697481EA
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F55661F20
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2861C34114;
        Thu, 14 Jul 2022 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812917;
        bh=bBG924KVyJUwRHMyuhmbScrP414tCR87a3kG7GuD7qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ersbDI7GKEG37eVtLcs7yNeC7X+RiDxjjYOVWv91WR75czORRc+gxci/sFwWnG2CS
         MGDbFVuMsI0bWaM1O5Oo87t/So6j2+6RdZixHUYuv3eJUfTfMssUCnd+HIB1cB1u9B
         ZQ2DhDjci7j+WAGe2EPcu1NR460TaBXZ5N01J7IRqTQeixQYT/r/wob7hFYqLLs5Lx
         6DsYVkRvq+LkR7KEhAih/+QOVyOVeKoW+VwNyr92Nqveo2KgRyaGswG7Cf/KaIEVcd
         QdlRIYWCeQ3D9FdFqNQ+ZszK0amwbIm3D2e5mCqTtxyzGUudCKHxz2Fu0Mt9QXKP+l
         p6EBw5W5bY9uw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dj-007UVL-Go;
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
Subject: [PATCH v2 12/20] KVM: arm64: vgic-v3: Consolidate userspace access for MMIO registers
Date:   Thu, 14 Jul 2022 16:20:16 +0100
Message-Id: <20220714152024.1673368-13-maz@kernel.org>
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

For userspace accesses to GICv3 MMIO registers (and related data),
vgic_v3_{get,set}_attr are littered with {get,put}_user() calls,
making it hard to audit and reason about.

Consolidate all userspace accesses in vgic_v3_attr_regs_access(),
making the code far simpler to audit.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 103 +++++++++-----------------
 1 file changed, 37 insertions(+), 66 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f02294b9aef1..e9db6795fb90 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -512,18 +512,18 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
  *
  * @dev:      kvm device handle
  * @attr:     kvm device attribute
- * @reg:      address the value is read or written, NULL for sysregs
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
@@ -591,6 +592,12 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
+
+	if (!ret && uaccess && !is_write) {
+		u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
+		ret = put_user(val, uaddr);
+	}
+
 	return ret;
 }
 
@@ -605,30 +612,12 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 
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
 
@@ -662,30 +651,12 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 
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

