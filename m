Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2B72ECF1
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 22:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbjFMUa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 16:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239062AbjFMUaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 16:30:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9281BC7
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:30:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25bd3b6816aso1548241a91.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686688244; x=1689280244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nhgzjrJ4PRGX7uFIL4jmdB6VsD0CAYOCqUeVAnJCyuw=;
        b=HJ9VefWMJ7lh6t668VWFhwCWP36Oo4m5sAiE2zPCBPiEnR5+TS1FxRv3DpECJ9e6O4
         whjjMVdgT+k5R6r2n75VQh0lAWXSf1712ImE1wwXz+kbCBgjAUwkw7o+ftMOkUxThkM1
         JQ6H3r3VR/XrrCXzgGulx3yu9BYHUjiGx4E71Gi88XthzMhFukc50vBFQc6ok8mAAEes
         sTFceaBbDMnkd4xn3YEKTGccGcGOfjd7dVqJ6ezBuXvGcuXS0FIJCYiL96wfdHRvckuK
         fIbMDVM13VgOJU0bPBhFcAi9i/0QLwmjYhHYEF3aza0T6OT0Iu79eCDepZdzCX2Xwm/5
         On+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686688244; x=1689280244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nhgzjrJ4PRGX7uFIL4jmdB6VsD0CAYOCqUeVAnJCyuw=;
        b=bjX+MsL4mJAHYucLNyeaaI8uyBWnSvP52fGXCJwXboF3LIE+a0aDJmHHLb+v7G5BGA
         cvLMX/h9s+UosJ25In5jbUzuZef8JBA3Lrsl5VcUkTp0B413+QmSKbfGLxbljU4VDgzv
         u4NCNRedxtCSrYSwaakFTKqByvwil6xGW7EtQv7aaYE09KLNmplxPgMuGztGsNX5PbKj
         Q4amS0JOO9SPZRcM23I97bZlrmzvVPPIZnsR4eYLADN48mJUBNU8ZdBnisbGQv7pAP5L
         acs0ChqubR7EVUbfBRg0y/IPuza78VU3v1s4FXZQ9QMYzx+6bp1H/+CW6sPmHOKSbJ3s
         jrHg==
X-Gm-Message-State: AC+VfDzc/ChVkdRIn091cjRkUDEqAB9Xviz1lvCjvoyBvNzz5zjnZPgW
        PTY6a52R4g1k+2n5f328EQ4hjXym9Ak=
X-Google-Smtp-Source: ACHHUZ46lHNcleKbOpPxw90Pn19mDpX5eRfC0XtsSFqfapY3nADuv4pCSnFN6kCe/HI64A335hwjkqG+r1E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f988:b0:25b:c272:ab34 with SMTP id
 cq8-20020a17090af98800b0025bc272ab34mr1570327pjb.7.1686688244295; Tue, 13 Jun
 2023 13:30:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jun 2023 13:30:36 -0700
In-Reply-To: <20230613203037.1968489-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230613203037.1968489-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230613203037.1968489-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: VMX: Don't fudge CR0 and CR4 for restricted L2 guest
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stuff CR0 and/or CR4 to be compliant with a restricted guest if and only
if KVM itself is not configured to utilize unrestricted guests, i.e. don't
stuff CR0/CR4 for a restricted L2 that is running as the guest of an
unrestricted L1.  Any attempt to VM-Enter a restricted guest with invalid
CR0/CR4 values should fail, i.e. in a nested scenario, KVM (as L0) should
never observe a restricted L2 with incompatible CR0/CR4, since nested
VM-Enter from L1 should have failed.

And if KVM does observe an active, restricted L2 with incompatible state,
e.g. due to a KVM bug, fudging CR0/CR4 instead of letting VM-Enter fail
does more harm than good, as KVM will often neglect to undo the side
effects, e.g. won't clear rmode.vm86_active on nested VM-Exit, and thus
the damage can easily spill over to L1.  On the other hand, letting
VM-Enter fail due to bad guest state is more likely to contain the damage
to L2 as KVM relies on hardware to perform most guest state consistency
checks, i.e. KVM needs to be able to reflect a failed nested VM-Enter into
L1 irrespective of (un)restricted guest behavior.

Cc: Jim Mattson <jmattson@google.com>
Cc: stable@vger.kernel.org
Fixes: bddd82d19e2e ("KVM: nVMX: KVM needs to unset "unrestricted guest" VM-execution control in vmcs02 if vmcs12 doesn't set it")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 355b0e8c9b00..6969a7728972 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1503,6 +1503,11 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long old_rflags;
 
+	/*
+	 * Unlike CR0 and CR4, RFLAGS handling requires checking if the vCPU
+	 * is an unrestricted guest in order to mark L2 as needing emulation
+	 * if L1 runs L2 as a restricted guest.
+	 */
 	if (is_unrestricted_guest(vcpu)) {
 		kvm_register_mark_available(vcpu, VCPU_EXREG_RFLAGS);
 		vmx->rflags = rflags;
@@ -3255,7 +3260,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	old_cr0_pg = kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 
 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
-	if (is_unrestricted_guest(vcpu))
+	if (enable_unrestricted_guest)
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else {
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
@@ -3283,7 +3288,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 
-	if (enable_ept && !is_unrestricted_guest(vcpu)) {
+	if (enable_ept && !enable_unrestricted_guest) {
 		/*
 		 * Ensure KVM has an up-to-date snapshot of the guest's CR3.  If
 		 * the below code _enables_ CR3 exiting, vmx_cache_reg() will
@@ -3414,7 +3419,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	 * this bit, even if host CR4.MCE == 0.
 	 */
 	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
-	if (is_unrestricted_guest(vcpu))
+	if (enable_unrestricted_guest)
 		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else if (vmx->rmode.vm86_active)
 		hw_cr4 |= KVM_RMODE_VM_CR4_ALWAYS_ON;
@@ -3434,7 +3439,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vcpu->arch.cr4 = cr4;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR4);
 
-	if (!is_unrestricted_guest(vcpu)) {
+	if (!enable_unrestricted_guest) {
 		if (enable_ept) {
 			if (!is_paging(vcpu)) {
 				hw_cr4 &= ~X86_CR4_PAE;
-- 
2.41.0.162.gfafddb0af9-goog

