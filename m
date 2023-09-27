Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF477AFF78
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjI0JJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjI0JJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50337D6
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B578BC433D9;
        Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805759;
        bh=kU23CEv+nBYaQuElLBiPmIVf/MmSLfglEUFHhMry2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ+qf0JaaWsBigV0QttbNQRLOaGqMly2id3+fWaRZhxx5e+dJfpnpAOUtK9FZKB2Q
         adNiindodX1FgdVLvCFCL+ROsssQtqwjmLiIr4ViEGh6zE3BX2L6CBPMGxbGCWU4EQ
         GFNkp42WOGLK36QRtqMk9F0ANUAsU8ChvzRmtSPXwje3yTg3fdmtLuI1ArsNtIxwp2
         fCj77hr0N1hsMdX7HDE4qEqrd5rIRr5m4nSzr1yB41UkGegn2f1x4MzMeo2REa/Uyi
         7jqmsuWT9FEjGxHfS8RD2g79vy1RRGoU85bq3ABHK1il6IASjW+lT/+tBKhQw/+TVL
         twhW9LiC+vXaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXl-00GaLb-KP;
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
Subject: [PATCH v3 06/11] KVM: arm64: Use vcpu_idx for invalidation tracking
Date:   Wed, 27 Sep 2023 10:09:06 +0100
Message-Id: <20230927090911.3355209-7-maz@kernel.org>
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

While vcpu_id isn't necessarily a bad choice as an identifier for
the currently running vcpu, it is provided by userspace, and there
is close to no guarantee that it would be unique.

Switch it to vcpu_idx instead, for which we have much stronger
guarantees.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fa21fb15e927..9379a1227501 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -438,9 +438,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
-	if (*last_ran != vcpu->vcpu_id) {
+	if (*last_ran != vcpu->vcpu_idx) {
 		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
-		*last_ran = vcpu->vcpu_id;
+		*last_ran = vcpu->vcpu_idx;
 	}
 
 	vcpu->cpu = cpu;
-- 
2.34.1

