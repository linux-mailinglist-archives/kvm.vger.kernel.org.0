Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB13A40BC0A
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhINXKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 19:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbhINXKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 19:10:33 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFE2C0613BD
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:08:49 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y185-20020a3764c20000b02903d2c78226ceso1478125qkb.6
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=V3qpi0lvczNO7KTgWpP693fuTWR6dQFfp5JLcqmi85Y=;
        b=HUsuOM2QFG1ysMczr03r0k4uGkPR5xD5g2w31QLhwVBWtoIwdtyHxXVqcsFKZCIvIe
         eVhLPwZ5tohR4H5VdcNcWKQRndgZbcdhynzD8Q01zaZo8WtvQRRDEmFhBLD60uxIb0rR
         5Bhmjub99aC8sPdXlMXFZDnmg6k45YK2ymk2vkZQu73fHrNvSiE7S+l2rRs100G0JQNV
         XDPlmS69F8jT1FCRce1hSbWDrjAkVW9LPTWYG2R+AIJjHb27bcn3bMOszuDZhOA8klX/
         65Auw/w5W9ND+HbxE7dQA0RdeAmxlTJALQvpjGcuoN3sixKR2jKHBIK/yaqlTjTX0yHk
         OaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=V3qpi0lvczNO7KTgWpP693fuTWR6dQFfp5JLcqmi85Y=;
        b=aAFL3mpCRtqLA3ffvBIzEETLsqOaaZAtzjoLERKBO2A3hXOVJgiBNdvOp6lzaDzqMu
         uW/KVEbGIGvc594Y6sITfdIwZVyKyCaEHUlLPE4grfkFvSKTHXpD8OoLqD/fFMM8wu0B
         5FLdyd7vMSMn3ArtvhhesFb8pgCdcriaSwpM6k3hJgqDo8yMzLzm7DeqAbKl2lagUG2G
         Z3UyOZI5R3K/EmS0DNqCL7Cmy39e+lDbXNC5O2AP1XrFdAVXXDSDrWJq7XMmokqDBs6J
         QvUzbvArCYh7GMgkchFF3RudkWVNKP+5UcLknsfmyADeAldUAvkxlFIQfxg5alJjXIJ2
         QaNw==
X-Gm-Message-State: AOAM530LsWviX+r986ge/EF2LvKRHT9q3xZozl9sb7fdvq4bsTknTMTk
        MTyD1AGsRlUZdBEJvax/5kjeqSW1xVo=
X-Google-Smtp-Source: ABdhPJxH4EAWoOBfpEAWM9+c8IctCJ6uHzy2P7PMurrVUTglZ93ryVeAe8b2W9qA56AUelRdEnaKQqrzX2c=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:d59f:9874:e5e5:256b])
 (user=seanjc job=sendgmr) by 2002:a0c:f38b:: with SMTP id i11mr8055073qvk.42.1631660928472;
 Tue, 14 Sep 2021 16:08:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Sep 2021 16:08:39 -0700
In-Reply-To: <20210914230840.3030620-1-seanjc@google.com>
Message-Id: <20210914230840.3030620-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210914230840.3030620-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 2/3] KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
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
index dc274b4c9912..629427cf8f4e 100644
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
 
@@ -6797,7 +6822,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
-	int i, cpu, err;
+	int i, err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
@@ -6856,12 +6881,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
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
@@ -6874,25 +6894,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
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
2.33.0.309.g3052b89438-goog

