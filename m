Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09DC6D67C0
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbjDDPmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbjDDPmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:42:16 -0400
Received: from out-33.mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D5659D0
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:41:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680622895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c3S+IvI30dXLpUpchouZSkX43/ychYIUDrO/VQdYbMU=;
        b=CIrSYlk8OnuDzWBI8rbL8rYt4d8ADcQ+3kv880plIcrq180t1uUqC4pYuB9dbATS82mMUE
        y5k9sScV2Aiuctkom0/aVcv80sZ5RNBdPyi5DCuZ5cmePA8thdxxhVEu5yg+DKi5lGPdrI
        ao8NJNJK5QZoRp4ZELVR94vUX1CIH6Y=
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
Subject: [PATCH v3 11/13] KVM: arm64: Let errors from SMCCC emulation to reach userspace
Date:   Tue,  4 Apr 2023 15:40:48 +0000
Message-Id: <20230404154050.2270077-12-oliver.upton@linux.dev>
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

Typically a negative return from an exit handler is used to request a
return to userspace with the specified error. KVM's handling of SMCCC
emulation (i.e. both HVCs and SMCs) deviates from the trend and resumes
the guest instead.

Stop handling negative returns this way and instead let the error
percolate to userspace.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/handle_exit.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 3f43e20c48b6..6dcd6604b6bc 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -36,8 +36,6 @@ static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
 
 static int handle_hvc(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
@@ -52,19 +50,11 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	ret = kvm_smccc_call_handler(vcpu);
-	if (ret < 0) {
-		vcpu_set_reg(vcpu, 0, ~0UL);
-		return 1;
-	}
-
-	return ret;
+	return kvm_smccc_call_handler(vcpu);
 }
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
@@ -93,11 +83,7 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
 	 * being treated as UNDEFINED.
 	 */
-	ret = kvm_smccc_call_handler(vcpu);
-	if (ret < 0)
-		vcpu_set_reg(vcpu, 0, ~0UL);
-
-	return ret;
+	return kvm_smccc_call_handler(vcpu);
 }
 
 /*
-- 
2.40.0.348.gf938b09366-goog

