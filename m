Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6C569044
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiGFRFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiGFRFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487882A700
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07ADCB81E35
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B272FC3411C;
        Wed,  6 Jul 2022 17:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127133;
        bh=aPUbRbuyMKOM6tSVaqezS0ZQ1mgggxrI72X+stVeMYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd3zEkORSAQsehUkOuuhz5vGmPzey91T4ZcaZ1HNYA897deM6K48R+Ceoo2VoVSPw
         rKykwTpCSTtKA4+0UyoDtvbVAw/VgOXtMIIHrbCcbgy86OeYoXwueisDyBvD9eNwB1
         lXXgSP0wQ6x3wn2iOjZmZumR3WkKPcDNX03BhleupoKMrbgJLJ6RzU5RLhx5rJDlSu
         vpcomNhaVVT1HD4zMZvvZn2GiJCByW+1VKRWga0PrqT6OcI+Ny95jkO67REo3LkeU/
         D8ZUZqUMF+RF9eqDpTJn6bAc9ZzQ9I24mT4mBXsYM5OVvzEkfl24dSgRFuPYfO3n0H
         ORPnDfi993QAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987O-005h9i-66;
        Wed, 06 Jul 2022 17:43:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 16/19] KVM: arm64: vgic: Consolidate userspace access for base address setting
Date:   Wed,  6 Jul 2022 17:43:01 +0100
Message-Id: <20220706164304.1582687-17-maz@kernel.org>
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

Align kvm_vgic_addr() with the rest of the code by moving the
userspace accesses into it. kvm_vgic_addr() is also made static.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 70 ++++++++++++---------------
 include/kvm/arm_vgic.h                |  1 -
 2 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 0dfd277b9058..00ce7fca78dd 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -76,8 +76,7 @@ int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev
 /**
  * kvm_vgic_addr - set or get vgic VM base addresses
  * @kvm:   pointer to the vm struct
- * @type:  the VGIC addr type, one of KVM_VGIC_V[23]_ADDR_TYPE_XXX
- * @addr:  pointer to address value
+ * @attr:  pointer to the attribute being retrieved/updated
  * @write: if true set the address in the VM address space, if false read the
  *          address
  *
@@ -89,15 +88,22 @@ int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev
  * overlapping regions in case of a virtual GICv3 here, since we don't know
  * the number of VCPUs yet, so we defer this check to map_resources().
  */
-int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
+static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool write)
 {
-	int r = 0;
+	u64 __user *uaddr = (u64 __user *)attr->addr;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	phys_addr_t *addr_ptr, alignment, size;
 	u64 undef_value = VGIC_ADDR_UNDEF;
+	u64 addr;
+	int r;
+
+	/* Reading a redistributor region addr implies getting the index */
+	if (write || attr->attr == KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION)
+		if (get_user(addr, uaddr))
+			return -EFAULT;
 
 	mutex_lock(&kvm->lock);
-	switch (type) {
+	switch (attr->attr) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_dist_base;
@@ -123,7 +129,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		if (r)
 			break;
 		if (write) {
-			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
+			r = vgic_v3_set_redist_base(kvm, 0, addr, 0);
 			goto out;
 		}
 		rdreg = list_first_entry_or_null(&vgic->rd_regions,
@@ -143,14 +149,12 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		if (r)
 			break;
 
-		index = *addr & KVM_VGIC_V3_RDIST_INDEX_MASK;
+		index = addr & KVM_VGIC_V3_RDIST_INDEX_MASK;
 
 		if (write) {
-			gpa_t base = *addr & KVM_VGIC_V3_RDIST_BASE_MASK;
-			u32 count = (*addr & KVM_VGIC_V3_RDIST_COUNT_MASK)
-					>> KVM_VGIC_V3_RDIST_COUNT_SHIFT;
-			u8 flags = (*addr & KVM_VGIC_V3_RDIST_FLAGS_MASK)
-					>> KVM_VGIC_V3_RDIST_FLAGS_SHIFT;
+			gpa_t base = addr & KVM_VGIC_V3_RDIST_BASE_MASK;
+			u32 count = FIELD_GET(KVM_VGIC_V3_RDIST_COUNT_MASK, addr);
+			u8 flags = FIELD_GET(KVM_VGIC_V3_RDIST_FLAGS_MASK, addr);
 
 			if (!count || flags)
 				r = -EINVAL;
@@ -166,9 +170,9 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 			goto out;
 		}
 
-		*addr = index;
-		*addr |= rdreg->base;
-		*addr |= (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
+		addr = index;
+		addr |= rdreg->base;
+		addr |= (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
 	default:
@@ -179,15 +183,20 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		goto out;
 
 	if (write) {
-		r = vgic_check_iorange(kvm, *addr_ptr, *addr, alignment, size);
+		r = vgic_check_iorange(kvm, *addr_ptr, addr, alignment, size);
 		if (!r)
-			*addr_ptr = *addr;
+			*addr_ptr = addr;
 	} else {
-		*addr = *addr_ptr;
+		addr = *addr_ptr;
 	}
 
 out:
 	mutex_unlock(&kvm->lock);
+
+	if (!r && !write)
+		if (put_user(addr, uaddr))
+			return -EFAULT;
+
 	return r;
 }
 
@@ -198,14 +207,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
-		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-		u64 addr;
-		unsigned long type = (unsigned long)attr->attr;
-
-		if (get_user(addr, uaddr))
-			return -EFAULT;
-
-		r = kvm_vgic_addr(dev->kvm, type, &addr, true);
+		r = kvm_vgic_addr(dev->kvm, attr, true);
 		return (r == -ENODEV) ? -ENXIO : r;
 	}
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
@@ -261,20 +263,8 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
-		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-		u64 addr;
-		unsigned long type = (unsigned long)attr->attr;
-
-		if (get_user(addr, uaddr))
-			return -EFAULT;
-
-		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
-		if (r)
-			return (r == -ENODEV) ? -ENXIO : r;
-
-		if (put_user(addr, uaddr))
-			return -EFAULT;
-		break;
+		r = kvm_vgic_addr(dev->kvm, attr, false);
+		return (r == -ENODEV) ? -ENXIO : r;
 	}
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f79cce67563e..4df9e73a8bb5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -364,7 +364,6 @@ struct vgic_cpu {
 extern struct static_key_false vgic_v2_cpuif_trap;
 extern struct static_key_false vgic_v3_cpuif_trap;
 
-int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
 int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
 void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
-- 
2.34.1

