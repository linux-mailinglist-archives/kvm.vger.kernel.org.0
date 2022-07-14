Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C671F57519F
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiGNPUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbiGNPUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8495F10B
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C2961F03
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391BAC341D1;
        Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812031;
        bh=qdwEm1Fk1ddI5UR0rpwtWcnv1VCRor61IzJ72T3BtnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5QAOZaGgcy/8CFvNp08u6czPrDxBYOqy8o4GENmbJGEDvxn/nCYvikhDH2LmdYnn
         k/yz1a62WWbS475QwvaCAtbGr05iegmN6A6CLo9OeHW1RH5Wwh1FqbP2JgPWqSkYYg
         Z7QJqhv6ecPqH49AhZrDKfPKvzqBGfUM9/CQiBaQyabEsTaWqJW7GDIL9KukGrzi+N
         L3U76bh83nC2lKNKnih/LEXOxEqvRK02gDo6At8unh+KOUOAX99PgD2W2pLi6lukMp
         8bf6QMJwwjpCPPcog4dAGrVGtyqnqZfy3UIf0O1rbgAv2AJjLhyRLbz3p6+t9FuNBX
         1iy+MnBfD0yMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dh-007UVL-DS;
        Thu, 14 Jul 2022 16:20:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 08/20] KVM: arm64: vgic-v3: Push user access into vgic_v3_cpu_sysregs_uaccess()
Date:   Thu, 14 Jul 2022 16:20:12 +0100
Message-Id: <20220714152024.1673368-9-maz@kernel.org>
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

In order to start making the vgic sysreg access from userspace
similar to all the other sysregs, push the userspace memory
access one level down into vgic_v3_cpu_sysregs_uaccess().

The next step will be to rely on the sysreg infrastructure
to perform this task.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c      | 22 ++++++++++++------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 33 ++++++---------------------
 arch/arm64/kvm/vgic/vgic.h            |  4 ++--
 3 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 85a5e1d15e9f..88eb5b049c2c 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -278,15 +278,21 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
 	return -ENXIO;
 }
 
-int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
-				u64 *reg)
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr,
+				bool is_write)
 {
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
-	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
+	u64 sysreg;
 
-	if (is_write)
-		params.regval = *reg;
+	sysreg = attr_to_id(attr->attr);
+
+	if (is_write) {
+		if (get_user(params.regval, uaddr))
+			return -EFAULT;
+	}
 	params.is_write = is_write;
 
 	r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
@@ -297,8 +303,10 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 	if (!r->access(vcpu, &params, r))
 		return -EINVAL;
 
-	if (!is_write)
-		*reg = params.regval;
+	if (!is_write) {
+		if (put_user(params.regval, uaddr))
+			return -EFAULT;
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index c6d52a1fd9c8..bf745c6ab2ea 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -512,7 +512,7 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
  *
  * @dev:      kvm device handle
  * @attr:     kvm device attribute
- * @reg:      address the value is read or written
+ * @reg:      address the value is read or written, NULL for sysregs
  * @is_write: true if userspace is writing a register
  */
 static int vgic_v3_attr_regs_access(struct kvm_device *dev,
@@ -561,14 +561,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		if (!is_write)
 			*reg = tmp32;
 		break;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 regid;
-
-		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
-		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
-						  regid, reg);
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
-	}
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		unsigned int info, intid;
 
@@ -617,15 +612,8 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		reg = tmp32;
 		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-		u64 reg;
-
-		if (get_user(reg, uaddr))
-			return -EFAULT;
-
-		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v3_attr_regs_access(dev, attr, NULL, true);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u64 reg;
@@ -681,15 +669,8 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		tmp32 = reg;
 		return put_user(tmp32, uaddr);
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-		u64 reg;
-
-		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		return put_user(reg, uaddr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v3_attr_regs_access(dev, attr, NULL, false);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u64 reg;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index ffc2d3c81b28..c23118467a35 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -245,8 +245,8 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
-int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-			 u64 id, u64 *val);
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr, bool is_write);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
-- 
2.34.1

