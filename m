Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D857AFF77
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjI0JJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjI0JJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84101C0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145D5C433CB;
        Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805759;
        bh=PNIfqUPI0AsOj+2xhVTNUahDYUrMKnXrOYsL7+Ia8Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIAOBL7+yFx9V0R42QjK7XCG5c9iCXFHFR1/slB/Knv+mfL4O2NLqoKhBd/JfCDT7
         kmtuvJGA5cJTz5Y/ecQ98Y/vd9GHQxepbkhU+z3OaLSvOdHiOCjlq0Acg1Lunlg5sQ
         pnSOpNJZ/voV7LvGlmd6eOn11frFZPxJqtiMqfa6iKHcI38/ux3Zb3k0b9vZO7WVSI
         +y8Mj/tThe7yZ/pyhk4D1Y+RSNXhYCnRNmrVW+kkY5UQXafQN1OjIumkIWOhTq3QYi
         AHX1FNJarGccSvQ8Y2LUMgwnibyKqfocOnaknudLMnZPIO5+qLBdAbgZDCr+pclBc6
         RttiEnyVCftuA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXl-00GaLb-5U;
        Wed, 27 Sep 2023 10:09:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 04/11] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
Date:   Wed, 27 Sep 2023 10:09:04 +0100
Message-Id: <20230927090911.3355209-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When parsing a GICv2 attribute that contains a cpuid, handle this
as the vcpu_id, not a vcpu_idx, as userspace cannot really know
the mapping between the two. For this, use kvm_get_vcpu_by_id()
instead of kvm_get_vcpu().

Take this opportunity to get rid of the pointless check against
online_vcpus, which doesn't make much sense either, and switch
to FIELD_GET as a way to extract the vcpu_id.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 212b73a715c1..c11962f901e0 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -339,13 +339,9 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 {
 	int cpuid;
 
-	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
-		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+	cpuid = FIELD_GET(KVM_DEV_ARM_VGIC_CPUID_MASK, attr->attr);
 
-	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
-		return -EINVAL;
-
-	reg_attr->vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
 	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 
 	return 0;
-- 
2.34.1

