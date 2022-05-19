Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4358F52D4EF
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbiESNsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239109AbiESNr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6C737A34
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30644B8235B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0CAC36AE3;
        Thu, 19 May 2022 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968015;
        bh=B946jQuS7j2fg5L+Q7AQunEposbhc2Gy7MExnPSIXp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGG5z1aIipXv0PgYjivZS0279gWmC483ak3c4hspl9DEisL8KMsLBYHK6z5b2wkJQ
         s/CT8WKOT1SEbFndyiC4kMsf3wzWDoY8yrauyMY2H7ZtKffnWx8epydJch3i7QDGs7
         LCxBvmpl4gLsOVYi5qGlNn92OcrXV8b3GMjSlFQZ8Q57d6/C6nwofGd8la8SRDF8w7
         xPfb5lTMyJqwCCBxvZ8uSzT6AnXXLmJNPaWpFcJWwwDGGZgzjCpJI9gqtkDt2Rq237
         JDnKZ2vrORNFe3304WUJcsI2qvBu20TSaXU6fzc+hy9FMe2GrahlfSoHgVy7+gG129
         Xc9pMYrSkrFBw==
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
Subject: [PATCH 68/89] KVM: arm64: Move vgic state between host and shadow vcpu structures
Date:   Thu, 19 May 2022 14:41:43 +0100
Message-Id: <20220519134204.5379-69-will@kernel.org>
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

Since the world switch vgic code operates on the shadow data
structure, move the state back and forth between the host and
shadow vcpu.

This is currently limited to the VMCR and APR registers, but further
patches will deal with the rest of the state.

Note that some of the scontrol settings (such as SRE) are always
set to the same value. This will eventually be moved to the shadow
initialisation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 65 ++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 692576497ed9..5d6cee7436f4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -619,6 +619,17 @@ static struct kvm_vcpu *__get_current_vcpu(struct kvm_vcpu *vcpu,
 		__get_current_vcpu(__vcpu, statepp);			\
 	})
 
+#define get_current_vcpu_from_cpu_if(ctxt, regnr, statepp)		\
+	({								\
+		DECLARE_REG(struct vgic_v3_cpu_if *, cif, ctxt, regnr); \
+		struct kvm_vcpu *__vcpu;				\
+		__vcpu = container_of(cif,				\
+				      struct kvm_vcpu,			\
+				      arch.vgic_cpu.vgic_v3);		\
+									\
+		__get_current_vcpu(__vcpu, statepp);			\
+	})
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_shadow_vcpu_state *shadow_state;
@@ -778,16 +789,62 @@ static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
 
 static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = get_current_vcpu_from_cpu_if(host_ctxt, 1, &shadow_state);
+	if (!vcpu)
+		return;
+
+	if (shadow_state) {
+		struct vgic_v3_cpu_if *shadow_cpu_if, *cpu_if;
+		int i;
+
+		shadow_cpu_if = &shadow_state->shadow_vcpu.arch.vgic_cpu.vgic_v3;
+		__vgic_v3_save_vmcr_aprs(shadow_cpu_if);
+
+		cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	__vgic_v3_save_vmcr_aprs(kern_hyp_va(cpu_if));
+		cpu_if->vgic_vmcr = shadow_cpu_if->vgic_vmcr;
+		for (i = 0; i < ARRAY_SIZE(cpu_if->vgic_ap0r); i++) {
+			cpu_if->vgic_ap0r[i] = shadow_cpu_if->vgic_ap0r[i];
+			cpu_if->vgic_ap1r[i] = shadow_cpu_if->vgic_ap1r[i];
+		}
+	} else {
+		__vgic_v3_save_vmcr_aprs(&vcpu->arch.vgic_cpu.vgic_v3);
+	}
 }
 
 static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
 
-	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
+	vcpu = get_current_vcpu_from_cpu_if(host_ctxt, 1, &shadow_state);
+	if (!vcpu)
+		return;
+
+	if (shadow_state) {
+		struct vgic_v3_cpu_if *shadow_cpu_if, *cpu_if;
+		int i;
+
+		shadow_cpu_if = &shadow_state->shadow_vcpu.arch.vgic_cpu.vgic_v3;
+		cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+		shadow_cpu_if->vgic_vmcr = cpu_if->vgic_vmcr;
+		/* Should be a one-off */
+		shadow_cpu_if->vgic_sre = (ICC_SRE_EL1_DIB |
+					   ICC_SRE_EL1_DFB |
+					   ICC_SRE_EL1_SRE);
+		for (i = 0; i < ARRAY_SIZE(cpu_if->vgic_ap0r); i++) {
+			shadow_cpu_if->vgic_ap0r[i] = cpu_if->vgic_ap0r[i];
+			shadow_cpu_if->vgic_ap1r[i] = cpu_if->vgic_ap1r[i];
+		}
+
+		__vgic_v3_restore_vmcr_aprs(shadow_cpu_if);
+	} else {
+		__vgic_v3_restore_vmcr_aprs(&vcpu->arch.vgic_cpu.vgic_v3);
+	}
 }
 
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

