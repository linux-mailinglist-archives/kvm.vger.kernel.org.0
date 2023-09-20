Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D5A7A8B78
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjITSRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjITSRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D0CD7
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06C4C433CC;
        Wed, 20 Sep 2023 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233859;
        bh=zwW05Zf90zWZaIrpGC3ZxgoZzeJfoKQB2bT853qaE2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZ2c2dIk7Md0Ddn7et6nW3tDk+3IQrr6mwsRlEkqMEYcRQtDgRoZ+IbsKATQba+iB
         ZQuCaowoWczd2cMFqScTxI8KjdGgp6fqoiumt84yBzLwYzBuc4bKV7LmYC2/pRW+pr
         rskzpMGYO7bnXZQl97kx51mlzlkJ9pC1dUAvDAJs5iNS+bfiSp0Oji6sI4E/cqvTnw
         4pP3Ru/SqgEe2zmJMINVXiP+3zsweQ7uiX9U1stqY1m//mzaI1OQsXE3e6yxBSzM+q
         +nYgshBJbqCbNDYyVJ0bBrQfvV/CXjJmqz0bdJb3owCyU+t0Vx3eUU3byNM2Q+MIgr
         XY6knIgAnAoKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1lZ-00Ejx0-Li;
        Wed, 20 Sep 2023 19:17:37 +0100
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
Subject: [PATCH v2 04/11] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
Date:   Wed, 20 Sep 2023 19:17:24 +0100
Message-Id: <20230920181731.2232453-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 212b73a715c1..82b264ad68c4 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -345,7 +345,7 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
 		return -EINVAL;
 
-	reg_attr->vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
 	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 
 	return 0;
-- 
2.34.1

