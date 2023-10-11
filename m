Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2517C4CDF
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjJKIRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjJKIRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:17:17 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDA93
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:17:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697012234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4MtoeUio+QJkGABxRH9TB9eJMl3DOp+ol2TBjjaaNk=;
        b=nOGAlB2DnGpg6RE7lLGfaR1M3Nm4Ta5kiffzTkiJebyxxBPn3bjs2t1G96WeuBR6P6Zc12
        0hPCeExtmT53kw8V0DyaHUn++UpeP7zwQ/UcnAfIz8h0exp8vsdwqpQ7JLipFuUIiyw57A
        4VXFa+kMs4QF4EJzbi4jYzJe5P01Qi8=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Disallow vPMU for NV guests
Date:   Wed, 11 Oct 2023 08:16:47 +0000
Message-ID: <20231011081649.3226792-2-oliver.upton@linux.dev>
In-Reply-To: <20231011081649.3226792-1-oliver.upton@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing PMU emulation code is inadequate for use with nested
virt. Disable the feature altogether with NV until the hypervisor
controls are handled correctly.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1bfdd583b261..356b7eec3c93 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1238,9 +1238,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
-	/* Disallow NV+SVE for the time being */
+	/* Disallow PMU and SVE with NV for the time being */
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features) &&
-	    test_bit(KVM_ARM_VCPU_SVE, &features))
+	    (test_bit(KVM_ARM_VCPU_SVE, &features) ||
+	     test_bit(KVM_ARM_VCPU_PMU_V3, &features)))
 		return -EINVAL;
 
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
-- 
2.42.0.609.gbb76f46606-goog

