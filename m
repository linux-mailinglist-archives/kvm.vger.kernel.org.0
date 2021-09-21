Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F479412AF7
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbhIUCCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238114AbhIUB5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:06 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF6FC06B67B
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:24 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h4-20020a05620a244400b004334ede5036so29417852qkn.13
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CnNPJOOHLdEH0uSRA/zE8hyQR18W/wEq+D5Ix6C/XUI=;
        b=UGEANJMsHlyIq30Jpx4g3LT/2OzgMaDjXvKooU3r/xj1SESSAe0VF3fDzJdmm+iuuX
         B//euM/aFcgnLiYI+sgnvseCIoQPiIIw0wvftn2MSIRmmZ3mhUHoUDOti5zD0bpme9RV
         4mzyIsIz0S6S7r3/VqMXPswfd3/tvA5228AOLnsPrTIKNht+WdomEWFYRWg7AUJKD6qi
         5QjNa7EYRX60kuKFDODSFKJ8Oi/qjuSFx3FqCPTLUABAsAvShP8t/xfwgfKIWovQvbkC
         74jaGN46rqJO95zl1rgbWXO5wp4Td0g3P4SkHQORHg2yIut0vtbpAUw9XcQm9tsZjPcW
         3ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CnNPJOOHLdEH0uSRA/zE8hyQR18W/wEq+D5Ix6C/XUI=;
        b=NeEZoW6B1iRMUGBRe76kP4RnWFZFN0cjntoiXzjNKz3jllStWOTTfg9bYVTfvgkejx
         FZMVYjOMA0PD9D87BLr64wjxh+N8ZPY0+2nq70by9ijjNj/oDtNM8iXMUaVrPRxwv63j
         zKopDlFqy4YXRsgcWRpPf7WW7g53Q84ERO/mASDZ07wHdLD/zTFxvEhgiSSKWl+yuhPH
         Iow/fneKy/3DfjEn2DKbJUyzLr+wR9O4JWGageecxXOxtC4hsgVgVx1KthzC1bfA+83J
         sCjYdqCgZSHFhsa1MhdZ5MzcE+ji2MoiKZ9W8nUHISM0wv4RjJU7kEkoBrxEtct3rTbM
         S2kA==
X-Gm-Message-State: AOAM533fbUolqoAqzuQ76Kf5i82GPTvJi+R5NP6w34/Dx7MbqlZqR78/
        Fuukmroby5uDaBvCiNusmA4ZXlvFXK8=
X-Google-Smtp-Source: ABdhPJwO9TMWtNR0AczjO5Hm6WUE378jqJkD+nUfPkO3eS6Ej/IQ2SQqv3Y2uy8cGASvxoeaEnFb+68tvhs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a5b:28b:: with SMTP id x11mr33704486ybl.9.1632182603329;
 Mon, 20 Sep 2021 17:03:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:03:01 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 08/10] KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vCPU RESET emulation, including initializating of select VMCS state,
to vmx_vcpu_reset().  Drop the open coded "vCPU load" sequence, as
->vcpu_reset() is invoked while the vCPU is properly loaded (which is
kind of the point of ->vcpu_reset()...).  Hopefully KVM will someday
expose a dedicated RESET ioctl(), and in the meantime separating "create"
from "RESET" is a nice cleanup.

Deferring VMCS initialization is effectively a nop as it's impossible to
safely access the VMCS between the current call site and its new home, as
both the vCPU and the pCPU are put immediately after init_vmcs(), i.e.
the VMCS isn't guaranteed to be loaded.

Note, task preemption is not a problem as vmx_sched_in() _can't_ touch
the VMCS as ->sched_in() is invoked before the vCPU, and thus VMCS, is
reloaded.  I.e. the preemption path also can't consume VMCS state.

Cc: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 61 +++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8d14066db3ea..dc0831054319 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4327,10 +4327,6 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 
 #define VMX_XSS_EXIT_BITMAP 0
 
-/*
- * Noting that the initialization of Guest-state Area of VMCS is in
- * vmx_vcpu_reset().
- */
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
 	if (nested)
@@ -4435,10 +4431,39 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	vmx_setup_uret_msrs(vmx);
 }
 
+static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	init_vmcs(vmx);
+
+	if (nested)
+		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
+
+	vcpu_setup_sgx_lepubkeyhash(vcpu);
+
+	vmx->nested.posted_intr_nv = -1;
+	vmx->nested.current_vmptr = -1ull;
+	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
+
+	vcpu->arch.microcode_version = 0x100000000ULL;
+	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
+
+	/*
+	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
+	 * or POSTED_INTR_WAKEUP_VECTOR.
+	 */
+	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
+	vmx->pi_desc.sn = 1;
+}
+
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (!init_event)
+		__vmx_vcpu_reset(vcpu);
+
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
 
@@ -6798,7 +6823,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
-	int i, cpu, err;
+	int i, err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
@@ -6857,12 +6882,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
-	cpu = get_cpu();
-	vmx_vcpu_load(vcpu, cpu);
-	vcpu->cpu = cpu;
-	init_vmcs(vmx);
-	vmx_vcpu_put(vcpu);
-	put_cpu();
+
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
 		err = alloc_apic_access_page(vcpu->kvm);
 		if (err)
@@ -6875,25 +6895,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}
 
-	if (nested)
-		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
-
-	vcpu_setup_sgx_lepubkeyhash(vcpu);
-
-	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.current_vmptr = -1ull;
-	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
-
-	vcpu->arch.microcode_version = 0x100000000ULL;
-	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
-
-	/*
-	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
-	 * or POSTED_INTR_WAKEUP_VECTOR.
-	 */
-	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
-	vmx->pi_desc.sn = 1;
-
 	return 0;
 
 free_vmcs:
-- 
2.33.0.464.g1972c5931b-goog

