Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839E44EFD9E
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353584AbiDBBLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiDBBK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:10:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD848A30A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mw8-20020a17090b4d0800b001c717bb058eso4962207pjb.0
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QQuySiCRGCJ6RvPIQ/BSFIhGVMRh766oWZ6w5lwsmv4=;
        b=HBsk46CaOocW/1oIhQTdaU2YWrEICiKdWGKu4ZKgs7qvpVBmvildZd/bEgCiEKbqiO
         RPYXO+Ret09cI0WIspij5+anNJWHBVMruj+veU56AX1l7pHRbJl1bt6hq3X3C0yk8ema
         pZAj0YysYkR4F/fSdoGF1rC94qijWnVQ1PiDiZWrmBZXbPY3EBGGf7NW1p2KdGsDZ/ez
         uyRWg0eY1nOvK7E2k2YRd5M8lCQUg8gzdcwrjmlJ4snsL21qUAOrq63TrmrrOyo0uc/2
         uKIur0FCevxRs4x5oT4sgQLPIxFvx9EdHiA93RdQY1sdz7SWnnl66RBxDPWlvVGVPNbq
         aZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QQuySiCRGCJ6RvPIQ/BSFIhGVMRh766oWZ6w5lwsmv4=;
        b=Jjq+6/Z7JTOjk19cMGEdAjLRmLDDHs6FxEwro3IfqDap1C/7/0dgHdh6yF+VlS62lr
         yWintbgsZpQfF7ezHQ135bNz61O9I3CGWcwMqyrmvUWgCx1DrO/KWtnmB6FL0Q02u40Y
         3CigYK6/kqqrZLfdoR+UEUBKpAY3T3p+PsF5F9JB6LopPrEqq2fr5f8DMYaZdO8Knf7i
         6aCaHIUg5DU/V96mXg0DpjfyBrjpJKOQjpqnsAOQoMXzBi1su393I/qgYy3RrEN717bi
         3DdKryM7tKHKZYdxKkNARYpbeHTtPaedDtWrkE8gUj8prkrtAF1YJpl/OXBcn6QrpIiv
         woig==
X-Gm-Message-State: AOAM530RfuFhDfpuP2oN5YEOjijssMuxdubn9b+8OrJ2mGQvyqm7eyqk
        RuXrBNUkLivAONNnTsLW37PYUE+uYEQ=
X-Google-Smtp-Source: ABdhPJxcxwbjgBmS5S7Od5qo4C/vjgUz/Mr0NzGn5XnSKA7RaYrosjsr0mT7mv79D4saIgkrMnnPAakU9Zc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24c6:b0:4fd:9038:74f0 with SMTP id
 d6-20020a056a0024c600b004fd903874f0mr13594229pfv.63.1648861747326; Fri, 01
 Apr 2022 18:09:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:08:56 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

The next_rip field of a VMCB is *not* an output-only field for a VMRUN.
This field value (instead of the saved guest RIP) in used by the CPU for
the return address pushed on stack when injecting a software interrupt or
INT3 or INTO exception.

Make sure this field gets synced from vmcb12 to vmcb02 when entering L2 or
loading a nested state and NRIPS is exposed to L1.  If NRIPS is supported
in hardware but not exposed to L1 (nrips=0 or hidden by userspace), stuff
vmcb02's next_rip from the new L2 RIP to emulate a !NRIPS CPU (which
saves RIP on the stack as-is).

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++---
 arch/x86/kvm/svm/svm.h    |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 73b545278f5f..9a6dc2b38fcf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -369,6 +369,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->nested_ctl          = from->nested_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
+	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
 	to->virt_ext            = from->virt_ext;
 	to->pause_filter_count  = from->pause_filter_count;
@@ -606,7 +607,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 }
 
-static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
+static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
+					  unsigned long vmcb12_rip)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
@@ -660,6 +662,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
+	/*
+	 * next_rip is consumed on VMRUN as the return address pushed on the
+	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
+	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
+	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
+	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
+	 * prior to injecting the event).
+	 */
+	if (svm->nrips_enabled)
+		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
+	else if (boot_cpu_has(X86_FEATURE_NRIPS))
+		vmcb02->control.next_rip    = vmcb12_rip;
+
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
 	if (svm->lbrv_enabled)
@@ -743,7 +758,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1422,6 +1437,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->nested_ctl           = from->nested_ctl;
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
+	dst->next_rip             = from->next_rip;
 	dst->nested_cr3           = from->nested_cr3;
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
@@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_control(svm, save->rip);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e246793cbeae..47e7427d0395 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -139,6 +139,7 @@ struct vmcb_ctrl_area_cached {
 	u64 nested_ctl;
 	u32 event_inj;
 	u32 event_inj_err;
+	u64 next_rip;
 	u64 nested_cr3;
 	u64 virt_ext;
 	u32 clean;
-- 
2.35.1.1094.g7c7d902a7c-goog

