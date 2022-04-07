Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229A14F6F1F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiDGAZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiDGAZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:25:22 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB531404DD
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:23:24 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u32-20020a634560000000b0039940fd2020so2209893pgk.20
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Gw4AjJsA/huEQANT6E1aBllpAkZiad7BFxNLgPrG5WM=;
        b=YvIBHN/BqYeWAOxEMGtEuwiypyCUcpDjB9N+7wYo9VQKTMOX6+/C1Bp/286i2PwOL2
         1GeH5Ckgc9vXqhFlrApJLwys+ePDi3vIYQal4kGEVoOpo/KTQzeC59dM6R3hHbfAfSSD
         oI3SwtjtQRXDenZrjqgmBPyRNNlPuko6RjEA7PUY8gRdXA7WnxQhsA1QQwagDSlntOl+
         LzlupGRDorcDYzr6xgif0cTyjWO6O8RnrNBhk2kVhbJD3buzvs1SUMGIFsB5odMxHyUT
         RD3XEg9xqpVzq0S3C0Mhs33gv0Ask60oqrvpZ4e8F1HHf76q7mxAEEqARvj9lA4mFNd2
         pxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Gw4AjJsA/huEQANT6E1aBllpAkZiad7BFxNLgPrG5WM=;
        b=COoL+eAC3Wm6+QM12VkMXkvjfLW6KUbXmTNNL+aORUhDlDALaQqWwJE9Vd3nmzNZt3
         Z+UiYgfnsZKYl7z4XTlhqkN2O3SFQwX6jJDfhrjqGpOUtNLd1xwuy+R9FpM0HBOqEkLL
         3zUwFsFg24u+6AM6GYNN/uovJrepBSK6Bd7lbQ58x8NTUWjiwPgrQ84wWVJ6+NsJ5wjY
         0OFU/HHTrFzLGJ2Ms+tzYwnmSqMbXITnVlg4ixPYiUrf316XCAWSHOA0gBx7ppFWSVpI
         /KD8+2HfJXc9fw1sU2Y+1ZesVRRzvZr0CQUhF20PKmVrxI62p5ivHYTfa1gIRKIgi7HZ
         af+g==
X-Gm-Message-State: AOAM5306LIAanv+msUAlSA7blOWhuzD7ejbExYbCCivQJOeIjZpQesUD
        G1yyI9UtwXEHBoO9qY5HfMUwr43357k=
X-Google-Smtp-Source: ABdhPJzSiZkaETBojCsv7IWI0RK07JvVJU7L4qlX/g7XDi239S68bTdfNqx9nqYezPB4E0TYCCsbh9JgSgo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr253317pjn.0.1649291003322; Wed, 06 Apr
 2022 17:23:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  7 Apr 2022 00:23:15 +0000
In-Reply-To: <20220407002315.78092-1-seanjc@google.com>
Message-Id: <20220407002315.78092-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220407002315.78092-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 3/3] KVM: nVMX: Clear IDT vectoring on nested VM-Exit for
 double/triple fault
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear the IDT vectoring field in vmcs12 on next VM-Exit due to a double
or triple fault.  Per the SDM, a VM-Exit isn't considered to occur during
event delivery if the exit is due to an intercepted double fault or a
triple fault.  Opportunistically move the default clearing (no event
"pending") into the helper so that it's more obvious that KVM does indeed
handle this case.

Note, the double fault case is worded rather wierdly in the SDM:

  The original event results in a double-fault exception that causes the
  VM exit directly.

Temporarily ignoring injected events, double faults can _only_ occur if
an exception occurs while attempting to deliver a different exception,
i.e. there's _always_ an original event.  And for injected double fault,
while there's no original event, injected events are never subject to
interception.

Presumably the SDM is calling out that a the vectoring info will be valid
if a different exit occurs after a double fault, e.g. if a #PF occurs and
is intercepted while vectoring #DF, then the vectoring info will show the
double fault.  In other words, the clause can simply be read as:

  The VM exit is caused by a double-fault exception.

Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
Cc: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmcs.h   |  5 +++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9a4938955bad..a6688663da4d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3691,12 +3691,34 @@ vmcs12_guest_cr4(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 }
 
 static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
-				      struct vmcs12 *vmcs12)
+				      struct vmcs12 *vmcs12,
+				      u32 vm_exit_reason, u32 exit_intr_info)
 {
 	u32 idt_vectoring;
 	unsigned int nr;
 
-	if (vcpu->arch.exception.injected) {
+	/*
+	 * Per the SDM, VM-Exits due to double and triple faults are never
+	 * considered to occur during event delivery, even if the double/triple
+	 * fault is the result of an escalating vectoring issue.
+	 *
+	 * Note, the SDM qualifies the double fault behavior with "The original
+	 * event results in a double-fault exception".  It's unclear why the
+	 * qualification exists since exits due to double fault can occur only
+	 * while vectoring a different exception (injected events are never
+	 * subject to interception), i.e. there's _always_ an original event.
+	 *
+	 * The SDM also uses NMI as a confusing example for the "original event
+	 * causes the VM exit directly" clause.  NMI isn't special in any way,
+	 * the same rule applies to all events that cause an exit directly.
+	 * NMI is an odd choice for the example because NMIs can only occur on
+	 * instruction boundaries, i.e. they _can't_ occur during vectoring.
+	 */
+	if ((u16)vm_exit_reason == EXIT_REASON_TRIPLE_FAULT ||
+	    ((u16)vm_exit_reason == EXIT_REASON_EXCEPTION_NMI &&
+	     is_double_fault(exit_intr_info))) {
+		vmcs12->idt_vectoring_info_field = 0;
+	} else if (vcpu->arch.exception.injected) {
 		nr = vcpu->arch.exception.nr;
 		idt_vectoring = nr | VECTORING_INFO_VALID_MASK;
 
@@ -3729,6 +3751,8 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 			idt_vectoring |= INTR_TYPE_EXT_INTR;
 
 		vmcs12->idt_vectoring_info_field = idt_vectoring;
+	} else {
+		vmcs12->idt_vectoring_info_field = 0;
 	}
 }
 
@@ -4215,8 +4239,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		 * Transfer the event that L0 or L1 may wanted to inject into
 		 * L2 to IDT_VECTORING_INFO_FIELD.
 		 */
-		vmcs12->idt_vectoring_info_field = 0;
-		vmcs12_save_pending_event(vcpu, vmcs12);
+		vmcs12_save_pending_event(vcpu, vmcs12,
+					  vm_exit_reason, exit_intr_info);
 
 		vmcs12->vm_exit_intr_info = exit_intr_info;
 		vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index e325c290a816..2b9d7a7e83f7 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -104,6 +104,11 @@ static inline bool is_breakpoint(u32 intr_info)
 	return is_exception_n(intr_info, BP_VECTOR);
 }
 
+static inline bool is_double_fault(u32 intr_info)
+{
+	return is_exception_n(intr_info, DF_VECTOR);
+}
+
 static inline bool is_page_fault(u32 intr_info)
 {
 	return is_exception_n(intr_info, PF_VECTOR);
-- 
2.35.1.1094.g7c7d902a7c-goog

