Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC3F52D4C3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbiESNqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239168AbiESNpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E527347553
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CDD2B824AB
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F4FC36AE9;
        Thu, 19 May 2022 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967931;
        bh=Lap94vFReqwzTxg/tbwg0Yft34nE9OnNIp6v3p0dx8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaBkW/HfPe0KmezeFJL4EFboOVaIrUETQBmTsWvHeWFsNovB0DsnZja5PCdhGL1c5
         voJhnaSvK6DzfziEV1XynP58XmIUR6wsJDltbTNo+dk9rPMlgF+hloxC5p87BuNwG0
         MeG13K1Ji0WX+XqFoMbo6NYc6f/i19Mkn7e4tzaR5Xhi+neV8qNzUIGFlxZSi4noaP
         kXiWL20/KlZSbohxXXrovc0M94LzPoF67UfMtV2kGTzHo2zGuQFol8p9AYiTWzZfj/
         CUQF0RIr+O9MEmRG8o4N8O1fwnnYxFymOZw08xMZ1+Nstoo+n/1/3DiiEyRYrg0myx
         mPW3FZIW7X7XA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 47/89] KVM: arm64: Add current vcpu and shadow_state lookup primitive
Date:   Thu, 19 May 2022 14:41:22 +0100
Message-Id: <20220519134204.5379-48-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

In order to be able to safely manipulate the loaded state,
add a helper that always return the vcpu as mapped in the EL2 S1
address space as well as the pointer to the shadow state.

In case of failure, both pointers are returned as NULL values.

For non-protected setups, state is always NULL, and vcpu the
EL2 mapping of the input value.

handle___kvm_vcpu_run() is converted to this helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 41 +++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9e3a2aa6f737..40cbf45800b7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -177,22 +177,51 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 	}
 }
 
+static struct kvm_vcpu *__get_current_vcpu(struct kvm_vcpu *vcpu,
+					   struct kvm_shadow_vcpu_state **state)
+{
+	struct kvm_shadow_vcpu_state *sstate = NULL;
+
+	vcpu = kern_hyp_va(vcpu);
+
+	if (unlikely(is_protected_kvm_enabled())) {
+		sstate = pkvm_loaded_shadow_vcpu_state();
+		if (!sstate || vcpu != sstate->host_vcpu) {
+			sstate = NULL;
+			vcpu = NULL;
+		}
+	}
+
+	*state = sstate;
+	return vcpu;
+}
+
+#define get_current_vcpu(ctxt, regnr, statepp)				\
+	({								\
+		DECLARE_REG(struct kvm_vcpu *, __vcpu, ctxt, regnr);	\
+		__get_current_vcpu(__vcpu, statepp);			\
+	})
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
 	int ret;
 
-	if (unlikely(is_protected_kvm_enabled())) {
-		struct kvm_shadow_vcpu_state *shadow_state = pkvm_loaded_shadow_vcpu_state();
-		struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+	vcpu = get_current_vcpu(host_ctxt, 1, &shadow_state);
+	if (!vcpu) {
+		cpu_reg(host_ctxt, 1) =  -EINVAL;
+		return;
+	}
 
+	if (unlikely(shadow_state)) {
 		flush_shadow_state(shadow_state);
 
-		ret = __kvm_vcpu_run(shadow_vcpu);
+		ret = __kvm_vcpu_run(&shadow_state->shadow_vcpu);
 
 		sync_shadow_state(shadow_state);
 	} else {
-		ret = __kvm_vcpu_run(kern_hyp_va(host_vcpu));
+		ret = __kvm_vcpu_run(vcpu);
 	}
 
 	cpu_reg(host_ctxt, 1) =  ret;
-- 
2.36.1.124.g0e6072fb45-goog

