Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61557A8B7C
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjITSRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjITSRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A29CDC
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10623C433D9;
        Wed, 20 Sep 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233860;
        bh=0lCI9vVo+XFWhmo/qM09sP7BePJ3MPGwh8pEm0Qjxe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GB/KZ7jg5DLjhVEOyC1ctv3v9Cumof6TcXeDB+UU8xXl9Pfvbv+yUWpJSwxJsNdo4
         bcekAoh95pVT2MD6VCSOrnuf4XsGbiEMRYhuDEOScD0Wdp1jQrw/ov6mYlc14FF/q0
         Hc8e4MG2habd0zIABq4neUtOw1h9oRVOoMmvZuYFxlGg1hpGKUjbdmxdZvZkobTGQY
         9hkUUAQBxbN4yaDc7p5wrGZlfpyIjbcATq/oDeK8B5/5tG37E1t/T5IUYmAalAEbhd
         l83ffN9FKvECgggA2WSsITETHgUXKn1CFK7+N0me6K2Y4Ex0lFylyA4DbYvPEs4lBy
         5GAecXdhaT38w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1la-00Ejx0-6h;
        Wed, 20 Sep 2023 19:17:38 +0100
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
Subject: [PATCH v2 06/11] KVM: arm64: Use vcpu_idx for invalidation tracking
Date:   Wed, 20 Sep 2023 19:17:26 +0100
Message-Id: <20230920181731.2232453-7-maz@kernel.org>
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
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 872679a0cbd7..23c22dbd1969 100644
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

