Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5452D4C1
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbiESNqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbiESNpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5987A5B3F0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 198E3B824AA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633BCC34115;
        Thu, 19 May 2022 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967915;
        bh=NfURsrYW4h19F3WtHdQkYC/dH7t8OmUGfRpzGnNJnCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8CE1dB72f2xw7zuWqcSJwBuXFyA8DJKPJRmNTFu5MMnncefdQvH44S7N0U1mB9Zc
         ltLAoKsJukAnREAop57PfnCskiIzNHdCzq3VrvaaDi5HSEiG1O3LYAEQKg9LTzqyMJ
         jhaNiN+GUuxos+/jHZyFfxDfYMgM6mxlabIuj8N7wT/wDz928AScV3Zp5V/6vhNnaH
         g6qjSBqWMkvTW4b8Sp+O4eXKMhz5/NuR4xPxSQqt9j+Yc0IzJNUvluddSX1bRjO3sK
         0DgQsZntMcDT4vYQ+Zv0jsXgGqvSdgwffsIBbH3ABN83srItSWA4LM6em6bcJkfJzZ
         k431H+QX4noLw==
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
Subject: [PATCH 43/89] KVM: arm64: Add the {flush,sync}_vgic_state() primitives
Date:   Thu, 19 May 2022 14:41:18 +0100
Message-Id: <20220519134204.5379-44-will@kernel.org>
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

Rather than blindly copying the vGIC state to/from the host at EL2,
introduce a couple of helpers to copy only what is needed and to
sanitise untrusted data passed by the host kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 50 +++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5b46742d9f9b..58515e5d24ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -18,10 +18,51 @@
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void flush_vgic_state(struct kvm_vcpu *host_vcpu,
+			     struct kvm_vcpu *shadow_vcpu)
+{
+	struct vgic_v3_cpu_if *host_cpu_if, *shadow_cpu_if;
+	unsigned int used_lrs, max_lrs, i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	shadow_cpu_if	= &shadow_vcpu->arch.vgic_cpu.vgic_v3;
+
+	max_lrs = (read_gicreg(ICH_VTR_EL2) & 0xf) + 1;
+	used_lrs = READ_ONCE(host_cpu_if->used_lrs);
+	used_lrs = min(used_lrs, max_lrs);
+
+	shadow_cpu_if->vgic_hcr	= READ_ONCE(host_cpu_if->vgic_hcr);
+	/* Should be a one-off */
+	shadow_cpu_if->vgic_sre = (ICC_SRE_EL1_DIB |
+				   ICC_SRE_EL1_DFB |
+				   ICC_SRE_EL1_SRE);
+	shadow_cpu_if->used_lrs	= used_lrs;
+
+	for (i = 0; i < used_lrs; i++)
+		shadow_cpu_if->vgic_lr[i] = READ_ONCE(host_cpu_if->vgic_lr[i]);
+}
+
+static void sync_vgic_state(struct kvm_vcpu *host_vcpu,
+			    struct kvm_vcpu *shadow_vcpu)
+{
+	struct vgic_v3_cpu_if *host_cpu_if, *shadow_cpu_if;
+	unsigned int i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	shadow_cpu_if	= &shadow_vcpu->arch.vgic_cpu.vgic_v3;
+
+	WRITE_ONCE(host_cpu_if->vgic_hcr, shadow_cpu_if->vgic_hcr);
+
+	for (i = 0; i < shadow_cpu_if->used_lrs; i++)
+		WRITE_ONCE(host_cpu_if->vgic_lr[i], shadow_cpu_if->vgic_lr[i]);
+}
+
 static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 {
 	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
@@ -43,16 +84,13 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 
 	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
-	shadow_vcpu->arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+	flush_vgic_state(host_vcpu, shadow_vcpu);
 }
 
 static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 {
 	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
 	struct kvm_vcpu *host_vcpu = shadow_state->host_vcpu;
-	struct vgic_v3_cpu_if *shadow_cpu_if = &shadow_vcpu->arch.vgic_cpu.vgic_v3;
-	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
-	unsigned int i;
 
 	host_vcpu->arch.ctxt		= shadow_vcpu->arch.ctxt;
 
@@ -63,9 +101,7 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 
 	host_vcpu->arch.flags		= shadow_vcpu->arch.flags;
 
-	host_cpu_if->vgic_hcr		= shadow_cpu_if->vgic_hcr;
-	for (i = 0; i < shadow_cpu_if->used_lrs; ++i)
-		host_cpu_if->vgic_lr[i] = shadow_cpu_if->vgic_lr[i];
+	sync_vgic_state(host_vcpu, shadow_vcpu);
 }
 
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

