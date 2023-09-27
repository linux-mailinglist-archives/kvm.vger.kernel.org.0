Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6675F7AFF81
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjI0JJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjI0JJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F1FE6
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BBDC43395;
        Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805760;
        bh=JypXsHJ4InnnDaRcHTXpCOmOh/qZk14zMN+csAv3sVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0sOSEmCli0cv5bClWusW9jpAKHZEyVWze2Jj+KM4gc5M5ew3sgoPGWnK95US7FtV
         wl98R6DE7BJNax8X9JpwkvzqB0MhoG+MU5qdjDAdjqVzlnZz7xU9ELRPzHhlFOJSpS
         Gvgvv7nvXtCTibHiFR7URTIGzFK+uJxl2416Wd4gVAEZ4hYvvu4dxzoeDO52YVRtiA
         FJxHpSiQnemXPvRn65IbInEnzBSPRGZxqy1ij5PjjSej7fHRDdorJjMFBHMs6eqKb0
         B8sTbWFtQTHSoZmrLolKwkTKdaVV7uYza6fh96tv8c84Xmpv+kX7NpHEHCYm3q0FBp
         xUqmwK0P44V2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXm-00GaLb-ND;
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
Subject: [PATCH v3 11/11] KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
Date:   Wed, 27 Sep 2023 10:09:11 +0100
Message-Id: <20230927090911.3355209-12-maz@kernel.org>
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

It goes without saying, but it is probably better to spell it out:

If userspace tries to restore and VM, but creates vcpus and/or RDs
in a different order, the vcpu/RD mapping will be different. Yes,
our API is an ugly piece of crap and I can't believe that we missed
this.

If we want to relax the above, we'll need to define a new userspace
API that allows the mapping to be specified, rather than relying
on the kernel to perform the mapping on its own.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 51e5e5762571..5817edb4e046 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -59,6 +59,13 @@ Groups:
   It is invalid to mix calls with KVM_VGIC_V3_ADDR_TYPE_REDIST and
   KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attributes.
 
+  Note that to obtain reproducible results (the same VCPU being associated
+  with the same redistributor across a save/restore operation), VCPU creation
+  order, redistributor region creation order as well as the respective
+  interleaves of VCPU and region creation MUST be preserved.  Any change in
+  either ordering may result in a different vcpu_id/redistributor association,
+  resulting in a VM that will fail to run at restore time.
+
   Errors:
 
     =======  =============================================================
-- 
2.34.1

