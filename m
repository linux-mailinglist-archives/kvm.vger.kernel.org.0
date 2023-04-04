Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572F86D67B6
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbjDDPl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbjDDPlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:41:46 -0400
Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A993599
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:41:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680622877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RfHXSrz9XeJh/48Ywn/IhPSiWsxLjQj7NYSwCU/fNnQ=;
        b=qE3of/QDbSROy62E5dVgCJyZCHUzWtqD/HK6Yzp3Cn72BvHVLgg0PtIzIn96a9ij4Zr1yj
        HMnPAqdJneXGU3V0GAemgDi1Q5LJ8oDyJQt78K7GxaV4jpakB5APSIDWwa1RCJ9LBMW12g
        aAX+tEgTtiZJ+ItoYM6oMgK2pbK6SFI=
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
Subject: [PATCH v3 05/13] KVM: arm64: Start handling SMCs from EL1
Date:   Tue,  4 Apr 2023 15:40:42 +0000
Message-Id: <20230404154050.2270077-6-oliver.upton@linux.dev>
In-Reply-To: <20230404154050.2270077-1-oliver.upton@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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
2.40.0.348.gf938b09366-goog

