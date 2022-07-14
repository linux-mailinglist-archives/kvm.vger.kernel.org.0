Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1262B5751EC
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbiGNPfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240316AbiGNPfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12673CBFD
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D36761F32
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC62C3411C;
        Thu, 14 Jul 2022 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812923;
        bh=ewFZDRbbTUSr1/RjHEhxuF5bx6bfhbtmusxOWTcVpCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsGdmmQxlag22n9+IC2c7Vq7/1EoxwUJ1bOrfTn1a7X5UfCaZlnu2y/H10lLUInnX
         YnIOt/dwIH9eHngc9UzTfmczDy7SFq2/hq14uC8syglUevYXLUeMKigSlfAKnwIZoU
         vWgVbKsc0saFqR4wWSgOkPcVolefTHP7of2+WDI75tP8e+wseBBDHz628QP9ockhDd
         kBSTMAyP5nJhLnxkZJrzmLpvG6Zi3vVjv7c/WnqOnhP7pxbTD/a/K20kFSUitECXUc
         NcryuXUnlX4I34KoiP4LH72quXV0pqZvRhNMqOfjJZ4domzY1Mp4VcQcfza6nvVf2G
         Xw4ixWVe+Y/HA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dk-007UVL-LK;
        Thu, 14 Jul 2022 16:20:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 17/20] KVM: arm64: vgic: Tidy-up calls to vgic_{get,set}_common_attr()
Date:   Thu, 14 Jul 2022 16:20:21 +0100
Message-Id: <20220714152024.1673368-18-maz@kernel.org>
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

The userspace accessors have an early call to vgic_{get,set}_common_attr()
that makes the code hard to follow. Move it to the default: clause of
the decoding switch statement, which results in a nice cleanup.

This requires us to move the handling of the pending table into the
common handling, even if it is strictly a GICv3 feature (it has the
benefit of keeping the whole control group handling in the same
function).

Also cleanup vgic_v3_{get,set}_attr() while we're at it, deduplicating
the calls to vgic_v3_attr_regs_access().

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 78 +++++++++------------------
 1 file changed, 26 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 011171dc41c5..edeac2380591 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -246,6 +246,24 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			r = vgic_init(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
+			/*
+			 * OK, this one isn't common at all, but we
+			 * want to handle all control group attributes
+			 * in a single place.
+			 */
+			if (vgic_check_type(dev->kvm, KVM_DEV_TYPE_ARM_VGIC_V3))
+				return -ENXIO;
+			mutex_lock(&dev->kvm->lock);
+
+			if (!lock_all_vcpus(dev->kvm)) {
+				mutex_unlock(&dev->kvm->lock);
+				return -EBUSY;
+			}
+			r = vgic_v3_save_pending_tables(dev->kvm);
+			unlock_all_vcpus(dev->kvm);
+			mutex_unlock(&dev->kvm->lock);
+			return r;
 		}
 		break;
 	}
@@ -427,37 +445,25 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 static int vgic_v2_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_set_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		return vgic_v2_attr_regs_access(dev, attr, true);
+	default:
+		return vgic_set_common_attr(dev, attr);
 	}
-
-	return -ENXIO;
 }
 
 static int vgic_v2_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_get_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		return vgic_v2_attr_regs_access(dev, attr, false);
+	default:
+		return vgic_get_common_attr(dev, attr);
 	}
-
-	return -ENXIO;
 }
 
 static int vgic_v2_has_attr(struct kvm_device *dev,
@@ -618,61 +624,29 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_set_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
-		return vgic_v3_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return vgic_v3_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
 		return vgic_v3_attr_regs_access(dev, attr, true);
-	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
-		int ret;
-
-		switch (attr->attr) {
-		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
-			mutex_lock(&dev->kvm->lock);
-
-			if (!lock_all_vcpus(dev->kvm)) {
-				mutex_unlock(&dev->kvm->lock);
-				return -EBUSY;
-			}
-			ret = vgic_v3_save_pending_tables(dev->kvm);
-			unlock_all_vcpus(dev->kvm);
-			mutex_unlock(&dev->kvm->lock);
-			return ret;
-		}
-		break;
-	}
+	default:
+		return vgic_set_common_attr(dev, attr);
 	}
-	return -ENXIO;
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
-
-	ret = vgic_get_common_attr(dev, attr);
-	if (ret != -ENXIO)
-		return ret;
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
-		return vgic_v3_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return vgic_v3_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
 		return vgic_v3_attr_regs_access(dev, attr, false);
+	default:
+		return vgic_get_common_attr(dev, attr);
 	}
-	return -ENXIO;
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
-- 
2.34.1

