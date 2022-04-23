Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1B850C667
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiDWCRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiDWCRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3AA218AD5
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:15 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i18-20020a056a00225200b0050abac0449bso6443985pfu.20
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WvYNbXCHSub5KkMALa85GDZKJJrB7zWtW+x8WTGBVkU=;
        b=IaXui+tsgGzP2B1ZAiifgEXK1LwLvFAo7dQbWGK1/kUsopw7JzrPTq/XaY/sraoP+9
         Bvn7wl6jamlohzVvEulLZAh99z0PPVeZyAmPTK3Ivg/X2gXRg/qP2JdItQ4jtoukSOMn
         PduoYkBt8LCyWj05UZPWBhYr+jq5mijbSJ57KHgKDkUdWGCL9riUs3Pi+jiVVISUOLod
         R8PYEu4WrzKdjlEVZWPLKkuNbSlRxb71Jy7qVsuNf/OUUiYVn1RkHIl0QGsT/21l2A0M
         eNc+tB8rH2+1AsxUKyCq0GYaokxW9Dht6pkFLupuD6eRN92BEYBs2hM7/ZQz4CBFmIK3
         sVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WvYNbXCHSub5KkMALa85GDZKJJrB7zWtW+x8WTGBVkU=;
        b=mAPYjxt/nDpb7EwFZnXxGh1HJCMA8K0WBRdqSCigPHCjkoZCEFVSVwbi97CA/4W03v
         z/w0RTW0mossa8xGmgfBOz5Tc7XaA+oKnIfK6v6Kg6UCKmCPc0xlYSzhyXB1EnIt8xPh
         k+4PiXHNNJZC/YSopbmwbUtCjoBy+ZDeOQbZCIq2J/nBNMS8XTDRNXdj0uqmoxhMVptM
         P7ZCmn44U6bw3ylDH/s/qOMky98Ms+e3+/omjCiLV+IEQHG51HEGE4vGY0AyrrG4BxSU
         Pa0XyDXhZs/56z2587SjQLmfPVsVM2KvcQQ1+Jtzd38+piWXBZETtt3ZcBNxgXsffpsK
         fgWA==
X-Gm-Message-State: AOAM533jSa4U2sI31vJSsKdVRYk+jcm7G1qNhKkMMPTMFhG/2dnXboCI
        K2/4LWJrNDCf0vkidv6HyP6hYFeZyZ8=
X-Google-Smtp-Source: ABdhPJzwtxGab+SWqq/nXEKXlT078e4hr6toJXE1iOhNPI6d699PB1AKdLAEBkjzPn0YhMl4kVkzs5NYF7Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf05:b0:156:2aa:6e13 with SMTP id
 i5-20020a170902cf0500b0015602aa6e13mr7472391plg.137.1650680054612; Fri, 22
 Apr 2022 19:14:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:01 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 01/11] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++---
 arch/x86/kvm/svm/svm.h    |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bed5e1692cef..461c5f247801 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -371,6 +371,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->nested_ctl          = from->nested_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
+	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
 	to->virt_ext            = from->virt_ext;
 	to->pause_filter_count  = from->pause_filter_count;
@@ -608,7 +609,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 }
 
-static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
+static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
+					  unsigned long vmcb12_rip)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
@@ -662,6 +664,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
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
@@ -745,7 +760,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1418,6 +1433,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->nested_ctl           = from->nested_ctl;
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
+	dst->next_rip             = from->next_rip;
 	dst->nested_cr3           = from->nested_cr3;
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
@@ -1602,7 +1618,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_control(svm, save->rip);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 32220a1b0ea2..7d97e4d18c8b 100644
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
2.36.0.rc2.479.g8af0fa9b8e-goog

