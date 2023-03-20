Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D146C2442
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCTWKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCTWKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:41 -0400
Received: from out-31.mta1.migadu.com (out-31.mta1.migadu.com [IPv6:2001:41d0:203:375::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AB1DBD4
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:10:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0haxp6s2bYWowZcKEhtPBXhXLDzpCeO4GHkIg/q7VQ=;
        b=lUKHBMXQMmD1aEkp7IyA1vbFMul8WWHgx+g4YxY3Nz/wIqaKzONe6lrosYx56aBmLJYgTh
        hkCOgTcm5Fkq7VK3XY/cJeD/IBf8TPUuLYihbLZi01YK9Zv7in8EM3wtwmCmwkJEok9CHG
        Lyn0Jm2pjsAbU/H84DNRsXu30I9FcH4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/11] KVM: arm64: Start handling SMCs from EL1
Date:   Mon, 20 Mar 2023 22:09:56 +0000
Message-Id: <20230320221002.4191007-6-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whelp, the architecture gods have spoken and confirmed that the function
ID space is common between SMCs and HVCs. Not only that, the expectation
is that hypervisors handle calls to both SMC and HVC conduits. KVM
recently picked up support for SMCCCs in commit bd36b1a9eb5a ("KVM:
arm64: nv: Handle SMCs taken from virtual EL2") but scoped it only to a
nested hypervisor.

Let's just open the floodgates and let EL1 access our SMCCC
implementation with the SMC instruction as well.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/handle_exit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5e4f9737cbd5..68f95dcd41a1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -72,13 +72,15 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 *
 	 * We need to advance the PC after the trap, as it would
 	 * otherwise return to the same address...
-	 *
-	 * Only handle SMCs from the virtual EL2 with an immediate of zero and
-	 * skip it otherwise.
 	 */
-	if (!vcpu_is_el2(vcpu) || kvm_vcpu_hvc_get_imm(vcpu)) {
+	kvm_incr_pc(vcpu);
+
+	/*
+	 * SMCs with a nonzero immediate are reserved according to DEN0028E 2.9
+	 * "SMC and HVC immediate value".
+	 */
+	if (kvm_vcpu_hvc_get_imm(vcpu)) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
-		kvm_incr_pc(vcpu);
 		return 1;
 	}
 
@@ -93,8 +95,6 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	if (ret < 0)
 		vcpu_set_reg(vcpu, 0, ~0UL);
 
-	kvm_incr_pc(vcpu);
-
 	return ret;
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

