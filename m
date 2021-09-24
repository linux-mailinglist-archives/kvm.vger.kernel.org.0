Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B7E417596
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbhIXNZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343552AbhIXNZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:17 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD2CC034023
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:57 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id s13-20020adfeccd000000b00160531902f4so286417wro.2
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nCXG0l+R9HIObQKW2P1KEyRjnYx24qX/arXoNkRGWM8=;
        b=bMETGKRZDsz/QLyWmlXkyVgIPXXIPgZPSQ+bmmIPAzzvTvXeq4PAlaA1o2khsZ2dh7
         hBNR5QqKDv2VXDgHc1rRqYT9wKChVUg2/OZHtAd6zlOm2g4HjZNM9TPWEO4bv4BxB6Qb
         g6G41+9Tk7ijHNcaP9/MxEwBz6R501wDU7EbBaGWYdJO4na0sllQa5q9OgYxpzMkfULB
         Kn/PDJ6p7qfvKukg7M9lfhYb/xfJstXcYLear6w70Opn6svw08NeeQRmTsvhtQSgF+0O
         mEr+wp8I0aGqt1vlM4lBjOLPvhgaM5zPqNPGcpptUZddXYcT+M1mGTG7Mndr5rkBZ+au
         XluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nCXG0l+R9HIObQKW2P1KEyRjnYx24qX/arXoNkRGWM8=;
        b=uC/HktOKUvJqgRWdjdzUue7+8Wya79AkXP8L2esia2ldlzXx7QDC/RzHpoiFu+JiBV
         vO4mUPSZBkTOBqjl/PaETVsGIh6x3jxGsvQ2YUHeKR95hPBfnIiapE85aNU9nJHQhsai
         DwixBGHFFvq5wv8iL2lEXkdGub2BNhrdnyNozIVa25Wsx3Sfb9dWGNoVW2+AqIWtK+8T
         bOYq+A4RMfJBebU0baCcfIGrHUxaE59cmabAhg5sDtDPXzRS4U6HVCiuA9Z49W0r2vKt
         4O3dngr3IEj2hIc+dxbWKoEGDX+tZ1m8bUKq/SzxzkJTpmGfO9S0W7RkhD7MuQ4PbqvD
         J7cw==
X-Gm-Message-State: AOAM532xlrtBJcYbgFyb1z2Im09U2XWgpI21bbxkfPtgXy+sU3hzcata
        SRxw+7nu/ex8Tru9TayC/4mXqzW8CQ==
X-Google-Smtp-Source: ABdhPJyLaWDPi72Md06wxlso8tc+C+HUsJOKyBd5N7LvM9mwCmnEhGULtENvFCUBKM2sh1nwCEuENi62Xw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:2184:: with SMTP id
 e4mr1925558wme.61.1632488096350; Fri, 24 Sep 2021 05:54:56 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:55 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-27-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 26/30] KVM: arm64: pVM activate_traps to use vcpu_ctxt
 and vcpu_hyp_state
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor protected VM activate_traps not to use vcpu. Protected
32 bit VMs are not supported, and therefore the code for setting
the floating point traps at 32 bits isn't needed for the pvm
case.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 35 +++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 9e79f97ba49e..0d654b324612 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,9 +34,10 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+/* Activate traps for protected guests */
+static void __activate_traps_pvm(struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	u64 val;
 
 	___activate_traps(vcpu_hyps);
@@ -44,26 +45,36 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
-	if (!update_fp_enabled(vcpu)) {
-		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
-		__activate_traps_fpsimd32(vcpu);
-	}
 
 	write_sysreg(val, cptr_el2);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
-
 		isb();
 		/*
 		 * At this stage, and thanks to the above isb(), S2 is
 		 * configured and enabled. We can now restore the guest's S1
 		 * configuration: SCTLR, and only then TCR.
 		 */
-		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(vcpu_ctxt, SCTLR_EL1), SYS_SCTLR);
 		isb();
-		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(vcpu_ctxt, TCR_EL1), SYS_TCR);
+	}
+}
+
+/* Activate traps for non-protected guests in nVHE */
+static void __activate_traps_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu->arch.ctxt;
+
+	__activate_traps_pvm(vcpu_ctxt, vcpu_hyps);
+
+	if (!update_fp_enabled(vcpu)) {
+		u64 val = CPTR_EL2_DEFAULT | CPTR_EL2_TTA | CPTR_EL2_TAM |
+			  CPTR_EL2_TFP | CPTR_EL2_TZ;
+		__activate_traps_fpsimd32(vcpu);
+		write_sysreg(val, cptr_el2);
 	}
 }
 
@@ -219,7 +230,7 @@ static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu);
+	__activate_traps_nvhe(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps();
@@ -321,7 +332,7 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu);
+	__activate_traps_pvm(vcpu_ctxt, vcpu_hyps);
 
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps();
-- 
2.33.0.685.g46640cef36-goog

