Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70116621BFB
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 19:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiKHSf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 13:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiKHSf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 13:35:27 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BB92CC9C
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 10:35:26 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 6so5987143pgm.6
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 10:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RnyS3dwzu63wm+TBBKa4ksB7XTmDC722z2f6RyUHWPs=;
        b=UNWTdZX009UhqhJ6UQ4R4+hp8SiQhxnMLXohooc/noo36cuTVOTPYeiHbI6l/If5If
         J99V6SvhqOUJdXGP1USoU7SQ4UsQc0kDpJnivKhYJ1Gb1/UnIQFqmdMGK7+nTTT+MRSJ
         vQAXN6CX7nJMHdk7l5MQFGieiB1Zx2apAH0MHUHKHnrjfzbpWmhVg9F9nCjWzW+8XYOU
         SBv/FsmQOASl+XIqep9c2B037c8W8HTTwUNLVCWmGH8stGR96ZExj8ipESF8GjxhIevV
         tdt7PlrDh92QBIH3Y28a8olvDACYlXbPkSwNq87XUXh94gRzQ+koxl8E3v5eQ1QW+pGb
         XQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RnyS3dwzu63wm+TBBKa4ksB7XTmDC722z2f6RyUHWPs=;
        b=AdquQFKS1HERKC+yDpDxV7ghY4T6GzLBMUPLg4gLX8ZgxGOuByf8Lqu7WX0X74Rh2m
         Zb7FNzSWVKskRwgnYClOrvkJqllUEcp4FgIMTnz1XT/jLkI2g0Lwb1c3myEsxtxtgn2D
         X+xFtr6BaNgA+hYVZcyStJaBGfhsFnoo2LiSQJ5/mpg8hHKCwwi4pYQjXJvGUYVGhZDd
         mxmE59vfU+oHqmYwIjz8kI7SbKbMCPNL/SDhVouwt95a6/qPMTUQU4KynA/eL90Y9QF/
         st98kSy1k21I0qdAIZhTJ2scVZasFbFFbYP8I/a9PX+KrE7qxCsUXhNn5IAaN1f0lUOP
         URRQ==
X-Gm-Message-State: ACrzQf3YbdThJvWrbhYhFjR5cSrlN3iiknUIh9lgf7aIzsEeXK9N4+RD
        D36Ukby44PKJ5EYKFCDLqhzW+A==
X-Google-Smtp-Source: AMsMyM5Qg8YfT/bsoUeJb0OK8RxgGNg/b35ucvUXf02E9o8w0JO152nFj4Gk4WJt4CUR2YrbDzSCfA==
X-Received: by 2002:a63:84c6:0:b0:46f:f8b0:ba09 with SMTP id k189-20020a6384c6000000b0046ff8b0ba09mr33082105pgd.192.1667932525661;
        Tue, 08 Nov 2022 10:35:25 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902d2cf00b0018544ad1e8esm7324982plc.238.2022.11.08.10.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:35:24 -0800 (PST)
Date:   Tue, 8 Nov 2022 18:35:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Liu Jingqi <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <Y2qhaSr/d2ds+nqD@google.com>
References: <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
 <Y2Px90RQydMUoiRH@google.com>
 <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
 <Y2kfCz02tQSUkMKS@google.com>
 <20221108102120.qdlgqlgvdi6wi22u@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108102120.qdlgqlgvdi6wi22u@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022, Yu Zhang wrote:
> On Mon, Nov 07, 2022 at 03:06:51PM +0000, Sean Christopherson wrote:
> > On Mon, Nov 07, 2022, Yu Zhang wrote:
> > > On Thu, Nov 03, 2022 at 04:53:11PM +0000, Sean Christopherson wrote:
> > > > Ideally, KVM should NEVER manipulate VMX MSRs in response to guest CPUID changes.
> > > > That's what I was referring to earlier by commits:
> > 
> > ...
> > 
> > > Thanks Sean. Let me try to rephrase my understandings of your statement(
> > > and pls feel free to correct me):
> > > 
> > > 1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
> > > disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes.
> > > 2> What makes sense is, if a feature is 
> > > 	a. disabled by guest CPUID, it shall not be exposed in guest VMX MSR;
> > > 	b. enabled by guest CPUID, it could be either exposed or hidden in
> > > 	guest VMX MSR.
> > > 3> So your previous change is to guarantee 2.a, and userspace VMM can choose
> > > to follow follow either choices in 2.b(depending on whether it believes this
> > > feature is correctly supported by KVM in nested). 
> > > 
> > > Is above understanding correct? 
> > 
> > Not quite.  Again, in an ideal world, KVM would not modify the VMX MSRs based on
> > guest CPUID.  But it's possible userspace is relying on KVM to hide a feature from
> > L2 if it's hidden from L1, so to avoid breaking an otherwise valide userspace config,
> > it's worth enforcing that in KVM.
> > 
> 
> Sorry, maybe I should understand this way:
> 
> In theroy, KVM shall not modify guest VMX MSRs in response to the guest CPUID
> updates. Therefore we shall not enforce the exposure of a feature in guest VMX
> MSR, just because it is enabled in guest CPUID (e.g., userspace VMM can choose
> to hide such feature so long as it believes KVM can not provide correct nested
> support for this feature). 
> 
> But in reverse, it is not reasonable for userspace VMM to expose a feature in
> guest VMX MSR settings, if such feature is disabled in this guest's CPUID. So
> KVM shall help to make sure such feature is hidden when guest CPUID changes.

No.  Again, KVM _should never_ manipulate VMX MSRs in response to CPUID changes.
Keeping the existing behavior would be done purely to maintain backwards
compability with existing userspace, not because it's strictly the right thing to do.

E.g. as a strawman, a weird userspace could do KVM_SET_MSRS => KVM_SET_CPUID =>
KVM_SET_CPUID, where the first KVM_SET_CPUID reset to a base config and the second
KVM_SET_CPUID incorporates "optional" features.  In that case, clearing bits in
the VMX MSRs on the first KVM_SET_CPUID would do the wrong thing if the second
KVM_SET_CPUID enabled the relevant features.

AFAIK, no userspace actually does something odd like that, whereas there are VMMs
that do KVM_SET_MSRS before KVM_SET_CPUID, e.g. disable a feature in VMX MSRs but
later enable the feature in CPUID for L1.  And so disabling features is likely
safe-ish, but enabling feature most definitely can cause problems for userspace.

Hrm, actually, there are likely older VMMs that never set VMX MSRs, and so dropping
the "enable features" code might not be safe either.  Grr.  The obvious solution
would be to add a quirk, but maybe we can avoid a quirk by skipping KVM's
misguided updates if userspace has set the MSR.  That should work for a userspace
that deliberately sets the MSR during setup, and for a userspace that blindly
migrates the MSR since the migrated value should already be correct/sane.

E.g.

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..671479cd7721 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -51,6 +51,7 @@ struct nested_vmx_msrs {
        u64 cr4_fixed1;
        u64 vmcs_enum;
        u64 vmfunc_controls;
+       bool secondary_set_by_userspace;
 };
 
 struct vmcs_config {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 62e3967cf131..3f691ed169d8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1257,6 +1257,9 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
        if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
                return -EINVAL;
 
+       if (msr_index == MSR_IA32_VMX_PROCBASED_CTLS2)
+               vmx->nested.msrs.secondary_set_by_userspace = true;
+
        vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
        *lowp = data;
        *highp = data >> 32;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab89755dce66..8aadaae5b81e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4523,7 +4523,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
         * Update the nested MSR settings so that a nested VMM can/can't set
         * controls for features that are/aren't exposed to the guest.
         */
-       if (nested) {
+       if (nested && !vmx->nested.msrs.secondary_set_by_userspace) {
                if (enabled)
                        vmx->nested.msrs.secondary_ctls_high |= control;
                else


> BTW, I found my previous understanding of what vmx_adjust_secondary_exec_control()
> currently does was also wrong. It could also be used for EXITING controls. And
> for such flags(e.g., SECONDARY_EXEC_RDRAND_EXITING), values for the nested settings
> (vmx->nested.msrs.secondary_ctls_high) and for the L1 execution controls(*exec_control)
> could be opposite. So the statement:
> 	"1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
> 	 disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes."
> is wrong.

No, it's correct.  The EXITING controls are just inverted feature flags.  E.g. if
RDRAND is disabled in CPUID, KVM sets the EXITING control so that KVM intercepts
RDRAND in order to inject #UD.

	[EXIT_REASON_RDRAND]                  = kvm_handle_invalid_op,
