Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE15751F5
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiGNPff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240339AbiGNPfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:35:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0325548CA8
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7424561F42
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25C0C34114;
        Thu, 14 Jul 2022 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812927;
        bh=a5fxg1hLUdYodaw2rlD+TJsGx9o54mh3SudXII6uJD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTloMO1ih35sC0DIKOjFMZiOGXUDtK9ilL/riTn6Dh7AVL1LD8FeJ2f0Im7R16tYb
         maLJatS5y34BUND+V3sSX1Laii3G6hYKuA0Uqe3WHO/b7iY7d8j24fqBCNEaO83TnU
         1vDxlJc5zS/6Yjho+cr2Nyg/YClCXTjX+1cjmqSmGMcnb4PrOlepKZdwhNmpwAB7du
         wcPFWW0XeD2+KhvtTV8EmKsSf9QCxpeZNNL/Gzrg2EZ85DObxBjrmh7iAk34W7tEY0
         NPFYLxbbssAaLFJLowh+5ERLtNdQirhh+SPlAVQF3cLDf3dHcC3tvnaZsDfPfWlV+c
         KGHVOUsR4yJQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dj-007UVL-Og;
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
Subject: [PATCH v2 13/20] KVM: arm64: vgic-v2: Consolidate userspace access for MMIO registers
Date:   Thu, 14 Jul 2022 16:20:17 +0100
Message-Id: <20220714152024.1673368-14-maz@kernel.org>
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

Align the GICv2 MMIO accesses from userspace with the way the GICv3
code is now structured.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 39 ++++++++++++---------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index e9db6795fb90..066b95d606fd 100644
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
@@ -393,6 +398,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
+
+	if (!ret && !is_write)
+		ret = put_user(val, uaddr);
+
 	return ret;
 }
 
@@ -407,15 +416,8 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 
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
@@ -432,15 +434,8 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 
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

