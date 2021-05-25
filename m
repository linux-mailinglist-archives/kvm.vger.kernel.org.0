Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83FB390602
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 17:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhEYP76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 11:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhEYP7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 11:59:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF952C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 08:58:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z4so14382217plg.8
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 08:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GrNYyp8yFCM3OjtEgwsRlPYZghJBZxh+aIazEW9zPPY=;
        b=klmzJr10Hwz5hESiRxrs9bZ1OQdihS5xP7/1ioX/BAEl9X+FVsytvGtpEQeT/LFhib
         1Hw1QsKmh359WG2XCkq2Jx7wI1a/v4IW1Evv80o5coZNSG+x8BKn4BSTgYgFgb7i1bDu
         S8IM4beVYZBZUiI0SQZetFVL85X80t/HBxEguuLG4DDRMbhZKJ+gGRr/jx5oscaKy1Tg
         w7sQb3jKYO0ctxlGLms6S8w8lZr46IomCP+dmOEI/oc1ilfdP0xECj5O1CoKW/K11fYO
         smhwW7vIH8aQUUmcXk/ai2wyYi1spgw5u5k369EskIXHhV92VSB70DvpoLvsh/4eSEtv
         ybnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GrNYyp8yFCM3OjtEgwsRlPYZghJBZxh+aIazEW9zPPY=;
        b=pRHWjGW3Q2/YBOre6rkdSZLOlUzpvwjD7CePYnmJykBlphYoxCLcAjP7+yhkowW+Zi
         PQjGBsO+C0LutY9zjHZJX3D3I6DxLq5HVVZxiRVd3u9tEW9NPcDZKV4vJx5uZWrY3eW9
         lMyaMni9hgf9wklHri681X1+nioqfPARRlZx4Az4jZF4QFpZg1+0kjZYCn8g9ZPOIs/V
         DHmWHFU9sE3kJRMm2mLtD6X4WTHXwZd9C2uweMewsxeutGgFHCb5YI7rdV9XwNze+1X+
         L1VLkhw9PQR9ViXQwfT/8J54H5Jv6WAP1gg22MoLN5Zb9DXzF8M1UA57WjnRrZlFbPRZ
         AHgw==
X-Gm-Message-State: AOAM532znKXSp5hrP3VFzUdX4uVVxUVGxq9bU+/Wp+mAZM/JDlvgFWFN
        vySb/TsIH2h+LvbACzGZVCDsag==
X-Google-Smtp-Source: ABdhPJxiTE1MXZy29GZ6ygzEV+/Xn203KaZ2CJKzl3TAXPY1HaIedzMdVsdUpKrSioL1WSB6gvqKsg==
X-Received: by 2002:a17:90a:ab90:: with SMTP id n16mr5389652pjq.223.1621958302021;
        Tue, 25 May 2021 08:58:22 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x22sm2340419pjp.42.2021.05.25.08.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 08:58:21 -0700 (PDT)
Date:   Tue, 25 May 2021 15:58:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>
Cc:     "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Message-ID: <YK0emU2NjWZWBovh@google.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-10-ilstam@amazon.com>
 <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
 <YKv0KA+wJNCbfc/M@google.com>
 <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, Stamatis, Ilias wrote:
> On Mon, 2021-05-24 at 18:44 +0000, Sean Christopherson wrote:
> > Yes, but its existence is a complete hack.  vmx->current_tsc_ratio has the same
> > scope as vcpu->arch.tsc_scaling_ratio, i.e. vmx == vcpu == vcpu->arch.  Unlike
> > per-VMCS tracking, it should not be useful, keyword "should".
> > 
> > What I meant by my earlier comment:
> > 
> >   Its use in vmx_vcpu_load_vmcs() is basically "write the VMCS if we forgot to
> >   earlier", which is all kinds of wrong.
> > 
> > is that vmx_vcpu_load_vmcs() should never write vmcs.TSC_MULTIPLIER.  The correct
> > behavior is to set the field at VMCS initialization, and then immediately set it
> > whenever the ratio is changed, e.g. on nested transition, from userspace, etc...
> > In other words, my unclear feedback was to make it obsolete (and drop it) by
> > fixing the underlying mess, not to just drop the optimization hack.
> 
> I understood this and replied earlier. The right place for the hw multiplier
> field to be updated is inside set_tsc_khz() in common code when the ratio
> changes. However, this requires adding another vendor callback etc. As all
> this is further refactoring I believe it's better to leave this series as is -
> ie only touching code that is directly related to nested TSC scaling and not
> try to do everything as part of the same series.

But it directly impacts your code, e.g. the nested enter/exit flows would need
to dance around the decache silliness.  And I believe it even more directly
impacts this series: kvm_set_tsc_khz() fails to handle the case where userspace
invokes KVM_SET_TSC_KHZ while L2 is active.

> This makes testing easier too.

Hmm, sort of.  Yes, the fewer patches/modifications in a series definitely makes
the series itself easier to test.  But stepping back and looking at the total
cost of testing, I would argue that punting related changes to a later time
increases the overall cost.  E.g. if someone else picks up the clean up work,
then they have to redo most, if not all, of the testing that you are already
doing, including getting access to the proper hardware, understanding what tests
to prioritize, etc...  Whereas adding one more patch to your series is an
incremental cost since you already have the hardware setup, know which tests to
run, etc...

> We can still implement these changes later.

We can, but we shouldn't.  Simply dropping vmx->current_tsc_ratio is not an
option; it knowingly introduces a (minor) performance regression, for no reason
other than wanting to avoid code churn.  Piling more stuff on top of the flawed
decache logic is impolite, as it adds more work for the person that ends up
doing the cleanup.  I would 100% agree if this were a significant cleanup and/or
completely unrelated, but IMO that's not the case.

Compile tested only...


diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 029c9615378f..34ad7a17458a 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -90,6 +90,7 @@ KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
+KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f099277b993d..a334ce7741ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1308,6 +1308,7 @@ struct kvm_x86_ops {
        u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
        u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
        void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
+       void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);

        /*
         * Retrieve somewhat arbitrary exit information.  Intended to be used
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b18f60463073..914afcceb46d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1103,6 +1103,14 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
        vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }

+static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
+{
+       /*
+        * Handled when loading guest state since the ratio is programmed via
+        * MSR_AMD64_TSC_RATIO, not a field in the VMCB.
+        */
+}
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
                                              struct vcpu_svm *svm)
@@ -4528,6 +4536,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
        .get_l2_tsc_offset = svm_get_l2_tsc_offset,
        .get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
        .write_tsc_offset = svm_write_tsc_offset,
+       .write_tsc_multiplier = svm_write_tsc_multiplier,

        .load_mmu_pgd = svm_load_mmu_pgd,

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..712190493926 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2535,7 +2535,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
        vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);

        if (kvm_has_tsc_control)
-               decache_tsc_multiplier(vmx);
+               vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_scaling_ratio);

        nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);

@@ -4505,7 +4505,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
                vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);

        if (kvm_has_tsc_control)
-               decache_tsc_multiplier(vmx);
+               vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_scaling_ratio);

        if (vmx->nested.change_vmcs01_virtual_apic_mode) {
                vmx->nested.change_vmcs01_virtual_apic_mode = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4b70431c2edd..bf845a08995e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1390,11 +1390,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,

                vmx->loaded_vmcs->cpu = cpu;
        }
-
-       /* Setup TSC multiplier */
-       if (kvm_has_tsc_control &&
-           vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
-               decache_tsc_multiplier(vmx);
 }

 /*
@@ -1813,6 +1808,11 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
        vmcs_write64(TSC_OFFSET, offset);
...skipping...
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -322,8 +322,6 @@ struct vcpu_vmx {
        /* apic deadline value in host tsc */
        u64 hv_deadline_tsc;

-       u64 current_tsc_ratio;
-
        unsigned long host_debugctlmsr;

        /*
@@ -532,12 +530,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
                              GFP_KERNEL_ACCOUNT);
 }

-static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
-{
-       vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
-       vmcs_write64(TSC_MULTIPLIER, vmx->current_tsc_ratio);
-}
-
 static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 {
        return vmx->secondary_exec_control &
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b61b54cea495..690de1868873 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2179,14 +2179,16 @@ static u32 adjust_tsc_khz(u32 khz, s32 ppm)
        return v;
 }

+static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu,
+                                         u64 l1_multiplier);
+
 static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 {
        u64 ratio;

        /* Guest TSC same frequency as host TSC? */
        if (!scale) {
-               vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
-               vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
+               kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
                return 0;
        }

@@ -2212,7 +2214,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
                return -1;
        }

-       vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
+       kvm_vcpu_write_tsc_multiplier(vcpu, ratio);
        return 0;
 }

@@ -2224,8 +2226,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
        /* tsc_khz can be zero if TSC calibration fails */
        if (user_tsc_khz == 0) {
                /* set tsc_scaling_ratio to a safe value */
-               vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
-               vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
+               kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
                return -1;
        }

@@ -2383,6 +2384,25 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
        static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
 }

+static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu,
+                                         u64 l1_multiplier)
+{
+       if (!kvm_has_tsc_control)
+               return;
+
+       vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
+
+       /* Userspace is changing the multiplier while L2 is active... */
+       if (is_guest_mode(vcpu))
+               vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
+                       l1_multiplier,
+                       static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu));
+       else
+               vcpu->arch.tsc_scaling_ratio = l1_multiplier;
+
+       static_call(kvm_x86_write_tsc_multiplier)(vcpu, vcpu->arch.tsc_scaling_ratio);
+}
+
 static inline bool kvm_check_tsc_unstable(void)
 {
 #ifdef CONFIG_X86_64
