Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A23A4F6E39
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiDFXFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiDFXFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:05:25 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D6411CF5F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:03:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 125so3405779pgc.11
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tsvlof6FPejAIMTXX6OMYR8u1wWfyFACALvOuNHJncA=;
        b=A+/7G6K8eTFnu4PMRYz0QUP5GVp6FFnb1AZdQbOMps7YfiTuOaHT3bvnrHx9/9cJme
         Y4kNfVP3q4DcHnFOLRDZxbN/SAtUitkkErqmkCUWaU9mSv722O9otxiHIb4lRSn3GyXw
         Q0zcY3EjRlSMsBQ12dUWRfLObEdUMX2xDNUzeIzlpr1wb6anMkwR7L9atxyB9HTdN6uu
         txOzEV6Ly9lh7mQHDZy8C4Gow0t/B6RrAO0/ihuzYeZdAQIqdiuGVot6JNxB8GOXQXyX
         iGs+bl80jdzr0m7SplBoLOi3B5AQGHihdffEDLAHByL9//QgCVy7SXyY985S7o6RVQcX
         HcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tsvlof6FPejAIMTXX6OMYR8u1wWfyFACALvOuNHJncA=;
        b=W12t6wh1a/g3NHXYwHRys9/M+Cv/5+Aor5T3FjGRZNGS/DFfq5WabeuNH7LeD+S1oz
         cD4/5ZSy2Afrn+8qz5YccynLMjWfOQ0AS6Edqu1L+3IgEGlEwbQdtqQv+jgRKNTF0yZ3
         dSr43t7JX9/BPUwv4NsiPM6VjvX4DSsKo+SoB11UdjO4D3FP4BiNRUXbvrxf5XAwY5mX
         3mOGjhGJNl1X1VNgXW5l2wBEsA/5R4wvVIioo17ar8SstnoC40VMSX+EccF8fC03sl7F
         Ty8zisAISrO5Y1PZSWIX+k0VDUGS7eFJzUPlcpGLA9hqPMG+KujFYFViOdTrDKt7PHQY
         DfUA==
X-Gm-Message-State: AOAM531OUKeV0U0uRyAdv8CrP5OU65voiN7mN3PKx5mQ6ZFKKg+tBc+I
        Ek74onnqShG0KE9xEJTHduxrSg==
X-Google-Smtp-Source: ABdhPJzVikFTDdNywBy6s+xfQqG/MGuqigLUM9aGH0aUuVMGX9x4KNUTrgDUaoI/qXpaiciPozTS6g==
X-Received: by 2002:a05:6a00:138a:b0:4fd:a7ec:6131 with SMTP id t10-20020a056a00138a00b004fda7ec6131mr11161020pfg.10.1649286204132;
        Wed, 06 Apr 2022 16:03:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pi2-20020a17090b1e4200b001c7b15928e0sm6597611pjb.23.2022.04.06.16.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:03:23 -0700 (PDT)
Date:   Wed, 6 Apr 2022 23:03:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying
 the instruction
Message-ID: <Yk4cOGC5/B6fKoJD@google.com>
References: <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
 <Yk3Jd6xAfgVoFgLc@google.com>
 <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
 <Yk3uh6f+0nOdybd3@google.com>
 <cd348e77-cb40-a64c-6b82-24e9a9158946@maciej.szmigiero.name>
 <Yk39j8f81+iDOsDG@google.com>
 <7e8f558d-c00a-7170-f671-bd10c0a56557@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e8f558d-c00a-7170-f671-bd10c0a56557@maciej.szmigiero.name>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Maciej S. Szmigiero wrote:
> On 6.04.2022 22:52, Sean Christopherson wrote:
> > On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
> > > Another option for saving and restoring a VM would be to add it to
> > > KVM_{GET,SET}_NESTED_STATE somewhere (maybe as a part of the saved VMCB12
> > > control area?).
> > 
> > Ooh.  What if we keep nested_run_pending=true until the injection completes?  Then
> > we don't even need an extra flag because nested_run_pending effectively says that
> > any and all injected events are for L1=>L2.  In KVM_GET_NESTED_STATE, shove the
> > to-be-injected event into the normal vmc*12 injection field, and ignore all
> > to-be-injected events in KVM_GET_VCPU_EVENTS if nested_run_pending=true.
> > 
> > That should work even for migrating to an older KVM, as keeping nested_run_pending
> > will cause the target to reprocess the event injection as if it were from nested
> > VM-Enter, which it technically is.
> 
> I guess here by "ignore all to-be-injected events in KVM_GET_VCPU_EVENTS" you
> mean *moving* back the L1 -> L2 event to be injected from KVM internal data
> structures like arch.nmi_injected (and so on) to the KVM_GET_NESTED_STATE-returned
> VMCB12 EVENTINJ field (or its VMX equivalent).
> 
> But then the VMM will need to first call KVM_GET_NESTED_STATE (which will do
> the moving), only then KVM_GET_VCPU_EVENTS (which will then no longer show
> these events as pending).
> And their setters in the opposite order when restoring the VM.

I wasn't thinking of actually moving things in the source VM, only ignoring events
in KVM_GET_VCPU_EVENTS.  Getting state shouldn't be destructive, e.g. the source VM
should still be able to continue running.

Ahahahaha, and actually looking at the code, there's this gem in KVM_GET_VCPU_EVENTS

	/*
	 * The API doesn't provide the instruction length for software
	 * exceptions, so don't report them. As long as the guest RIP
	 * isn't advanced, we should expect to encounter the exception
	 * again.
	 */
	if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
		events->exception.injected = 0;
		events->exception.pending = 0;
	}

and again for soft interrupts

	events->interrupt.injected =
		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;

so through KVM's own incompetency, it's already doing half the work.

This is roughly what I had in mind.  It will "require" moving nested_run_pending
to kvm_vcpu_arch, but I've been itching for an excuse to do that anyways.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb71727acecb..62c48f6a0815 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4846,6 +4846,8 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
                                               struct kvm_vcpu_events *events)
 {
+       bool drop_injected_events = vcpu->arch.nested_run_pending;
+
        process_nmi(vcpu);

        if (kvm_check_request(KVM_REQ_SMI, vcpu))
@@ -4872,7 +4874,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
         * isn't advanced, we should expect to encounter the exception
         * again.
         */
-       if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
+       if (drop_injected_events ||
+           kvm_exception_is_soft(vcpu->arch.exception.nr)) {
                events->exception.injected = 0;
                events->exception.pending = 0;
        } else {
@@ -4893,13 +4896,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
        events->exception_has_payload = vcpu->arch.exception.has_payload;
        events->exception_payload = vcpu->arch.exception.payload;

-       events->interrupt.injected =
-               vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
+       events->interrupt.injected = vcpu->arch.interrupt.injected &&
+                                    !vcpu->arch.interrupt.soft &&
+                                    !drop_injected_events;
        events->interrupt.nr = vcpu->arch.interrupt.nr;
        events->interrupt.soft = 0;
        events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);

-       events->nmi.injected = vcpu->arch.nmi_injected;
+       events->nmi.injected = vcpu->arch.nmi_injected && !drop_injected_events;
        events->nmi.pending = vcpu->arch.nmi_pending != 0;
        events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
        events->nmi.pad = 0;

