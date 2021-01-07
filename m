Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFD72ED4EA
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbhAGRA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAGRAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 12:00:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84413C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 09:00:15 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id f14so1796390pju.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 09:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D7wKWCdzDkP6avteBtNODYaQ3hJF6WSzmKpZXhol000=;
        b=br0Co3s3wCez6wcwkJkRxtFcH8mIbALLsoNyBzPVpkq60hgnLg4DP0ZEKkNgmGvebF
         LUyEKhggcr5oJkCDf2YOc/hj6v/UiSiBapxJCRKL38XV1WmRJbWFaU0q/BnmF2SKZ9D8
         Qm/IRL2zJCggNlnUHLmgsu5yJ6zc7aC4IAbfVhhbDSr/Yy7medypNSxHBBVOxzNFS383
         pzIt6AvNKBD93VfHSMJngDqpb8E/4l9m9QQVu9Fq1Fd2G6CsBtQi8uDrrGN0WZB0XZXh
         Aby97oUGtEScr9eZhNCzVCYKRpiwjW0ojR47osJziitpZ/Cdjhm0NCduYMtL4Sc3ByeV
         zhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D7wKWCdzDkP6avteBtNODYaQ3hJF6WSzmKpZXhol000=;
        b=khptq9TB2MiRJaloqNVFVUCWphnoMp9KIwd6SUIvS0hZX/1f5GKHrqgQniNlgQXhDD
         4pdU0nDYNWIGRjBhR7o/wuukoc2+XPi4lKXLPKvSf9SAd035Hz1ObX8NSGwpinWxJuN0
         nAsRqYKH6qMv9gHIpkwR/3ENCv3I2qGHq+MbK8Ylod8hMcooqpzIAhUTq/Y+tHxMJ7Vd
         CFzhJJQeu47iU7Ubpl22CgK4zb2Uphf4qu/yGOYSU+B1hy/ndglL3Tfx0z1Y2c7EiHJH
         aqyR46/PZEMU1fnHY9PrdP4ymK7088QxIka29RA12rkwm80B92iZYFWcGrzENLTqskKo
         GPcw==
X-Gm-Message-State: AOAM5328xsfYcR+d3MJi3uZ4pGE0qy7jODZWuiaabrUeQwCQft5frRjp
        uAOYt+6nDliIZEk4QnibyR9j0w==
X-Google-Smtp-Source: ABdhPJxXorQFds5f78UyOO27dMRfrfPi2SQrpP2RJPuDPsrQXzy3BggA+1r02tq6yv/FuAixTgJU/w==
X-Received: by 2002:a17:90a:f0c5:: with SMTP id fa5mr5737484pjb.174.1610038814826;
        Thu, 07 Jan 2021 09:00:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w63sm6202426pfc.20.2021.01.07.09.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:00:14 -0800 (PST)
Date:   Thu, 7 Jan 2021 09:00:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
 on nested vmexit
Message-ID: <X/c+FzXGfk/3LUC2@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107093854.882483-2-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Maxim Levitsky wrote:
> It is possible to exit the nested guest mode, entered by
> svm_set_nested_state prior to first vm entry to it (e.g due to pending event)
> if the nested run was not pending during the migration.

Ugh, I assume this is due to one of the "premature" nested_ops->check_events()
calls that are necessitated by the event mess?  I'm guessing kvm_vcpu_running()
is the culprit?

If my assumption is correct, this bug affects nVMX as well.  Rather than clear
the request blindly on any nested VM-Exit, what about something like the
following?  IMO, KVM really shouldn't be synthesizing a nested VM-Exit before it
processes pending requests, but unfortunately the nested_ops->check_events()
mess isn't easily fixed.  This will at least limit the mess, e.g. with this we'd
get a WARN if KVM_REQ_GET_NESTED_STATE_PAGES is set after some other VM-Exit.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3136e05831cf..f44e6f7a0c9b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2857,17 +2857,15 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
        if (!pe)
                return;

-       if (is_guest_mode(vcpu)) {
-               r = kvm_x86_ops.nested_ops->check_events(vcpu);
-               if (r < 0)
-                       return;
-               /*
-                * If an event has happened and caused a vmexit,
-                * we know INITs are latched and therefore
-                * we will not incorrectly deliver an APIC
-                * event instead of a vmexit.
-                */
-       }
+       r = kvm_nested_check_events(vcpu);
+       if (r < 0)
+               return;
+
+       /*
+        * If an event has happened and caused a vmexit, we know INITs are
+        * latched and therefore we will not incorrectly deliver an APIC
+        * event instead of a vmexit.
+        */

        /*
         * INITs are latched while CPU is in specific states
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..b0f172d13cab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8223,6 +8223,25 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
        kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }

+int kvm_nested_check_events(struct kvm_vcpu *vcpu)
+{
+       int r;
+
+       if (!is_guest_mode(vcpu))
+               return 0;
+
+       r = kvm_x86_ops.nested_ops->check_events(vcpu);
+
+       /*
+        * Clear nested-specific requests if checking nested events triggered a
+        * VM-Exit, they'll be re-requested on nested VM-Enter (if necessary).
+        */
+       if (!is_guest_mode(vcpu))
+               kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
+       return r;
+}
+
 static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
        int r;
@@ -8267,11 +8286,9 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
         * from L2 to L1 due to pending L1 events which require exit
         * from L2 to L1.
         */
-       if (is_guest_mode(vcpu)) {
-               r = kvm_x86_ops.nested_ops->check_events(vcpu);
-               if (r < 0)
-                       goto busy;
-       }
+       r = kvm_nested_check_events(vcpu);
+       if (r < 0)
+               goto busy;

        /* try to inject new event if pending */
        if (vcpu->arch.exception.pending) {
@@ -8789,7 +8806,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)

        if (kvm_request_pending(vcpu)) {
                if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-                       if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+                       if (!WARN_ON(!is_guest_mode(vcpu) &&
+                           unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu)))) {
                                r = 0;
                                goto out;
                        }
@@ -9111,8 +9129,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)

 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-       if (is_guest_mode(vcpu))
-               kvm_x86_ops.nested_ops->check_events(vcpu);
+       (void)kvm_nested_check_events(vcpu);

        return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
                !vcpu->arch.apf.halted);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..dce61fda9c5e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -247,6 +247,8 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
        return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
 }

+int kvm_nested_check_events(struct kvm_vcpu *vcpu);
+
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);

 void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);


> In this case we must not switch to the nested msr permission bitmap.
> Also add a warning to catch similar cases in the future.
> 
> Fixes: a7d5c7ce41ac1 ("KVM: nSVM: delay MSR permission processing to first nested VM run")
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index b0b667456b2e7..ee4f2082ad1bd 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -199,6 +199,10 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (WARN_ON_ONCE(!is_guest_mode(&svm->vcpu)))
> +		return false;
> +
>  	if (!nested_svm_vmrun_msrpm(svm)) {
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		vcpu->run->internal.suberror =
> @@ -595,6 +599,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	svm->nested.vmcb12_gpa = 0;
>  	WARN_ON_ONCE(svm->nested.nested_run_pending);
>  
> +	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
> +
>  	/* in case we halted in L2 */
>  	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  
> -- 
> 2.26.2
> 
