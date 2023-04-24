Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E5E6D67B7
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjDDPl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbjDDPlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:41:50 -0400
Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2EA5FD6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:41:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680622875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eh9wd48ohN+FzWNYjVMpazX+yjNyuvvGeo+Fsv9LqwU=;
        b=QtHB0YLmxgJK47d6DKzmivi2uvxc0fgHbWinh3/n9vmSY5SRfZY/p8lecm0daa+yc00Dq2
        nIgd3BRYm0tzgocVFYb54WaStB49ADKnooAHgrSpPXgXGefni2P24nBP0ew+1npXFmSUTd
        bnZxRviGIcoG6k9akeUngDq73NAyQ2E=
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
Subject: [PATCH v3 04/13] KVM: arm64: Rename SMC/HVC call handler to reflect reality
Date:   Tue,  4 Apr 2023 15:40:41 +0000
Message-Id: <20230404154050.2270077-5-oliver.upton@linux.dev>
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

KVM handles SMCCC calls from virtual EL2 that use the SMC instruction
since commit bd36b1a9eb5a ("KVM: arm64: nv: Handle SMCs taken from
virtual EL2"). Thus, the function name of the handler no longer reflects
reality.

Normalize the name on SMCCC, since that's the only hypercall interface
KVM supports in the first place. No fuctional change intended.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/handle_exit.c | 4 ++--
 arch/arm64/kvm/hypercalls.c  | 2 +-
 include/kvm/arm_hypercalls.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a798c0b4d717..5e4f9737cbd5 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -52,7 +52,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	ret = kvm_hvc_call_handler(vcpu);
+	ret = kvm_smccc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
@@ -89,7 +89,7 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
 	 * being treated as UNDEFINED.
 	 */
-	ret = kvm_hvc_call_handler(vcpu);
+	ret = kvm_smccc_call_handler(vcpu);
 	if (ret < 0)
 		vcpu_set_reg(vcpu, 0, ~0UL);
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index a09a526a7d7c..5ead6c6afff0 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -121,7 +121,7 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	u32 func_id = smccc_get_function(vcpu);
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 1188f116cf4e..8f4e33bc43e8 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -6,7 +6,7 @@
 
 #include <asm/kvm_emulate.h>
 
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+int kvm_smccc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
 {
-- 
2.40.0.348.gf938b09366-goog

