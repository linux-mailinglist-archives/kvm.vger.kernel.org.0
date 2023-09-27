Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753467AFF80
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjI0JJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjI0JJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282C1E5
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D10C433C8;
        Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805760;
        bh=v9+KEyVmL3Rbtezk0wEMGxYSOO0hSxuVwlPLKtF01uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiM/R4s+zfsdAtSNUPTVLifroK77J5ahCZ/K/BeQX0GtwbFapEFC5yu0NYQzV9Jd7
         lP4jR1DCJVohzQEvV3ck8oRJq3QHLgCJDbyQXJ8nazFj3R9DpKhiJe+FaPrEsKbOZf
         CbHTghi6WnGoB974I5qrO2ZQf4GHyT/zOn4Qr6SZkRTuQj8SE6QVSLTNeR/vLHK5s+
         cMK6wME8WnxJ1wu6Eg2U9CC9TPZvgFF9n5QHbSaBair5nPrkXXc73Edpb+K4EYYR6z
         uYusCYgFfpgybqxkfbbCb0RR+sxOSkUpFizlk8pLDlpGV4T4YFJIyQLqIHkM7yuZFF
         XYZC1fhu9OBhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXm-00GaLb-9d;
        Wed, 27 Sep 2023 10:09:18 +0100
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
Subject: [PATCH v3 09/11] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
Date:   Wed, 27 Sep 2023 10:09:09 +0100
Message-Id: <20230927090911.3355209-10-maz@kernel.org>
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

If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
use it to recover the corresponding vcpu.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b02e28f76083..e3d667feecaf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2388,6 +2388,18 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	unsigned long i;
 
 	mpidr &= MPIDR_HWID_BITMASK;
+
+	if (kvm->arch.mpidr_data) {
+		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
+
+		vcpu = kvm_get_vcpu(kvm,
+				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
+		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
+			vcpu = NULL;
+
+		return vcpu;
+	}
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
 			return vcpu;
-- 
2.34.1

