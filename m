Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281EC4F6AA6
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiDFT6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiDFT62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:58:28 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7A212108E
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 10:10:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id bo5so3045247pfb.4
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 10:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7LtKSzkUnN8oqI99/lZipJjXqpkcAstNhdyBktayhLU=;
        b=szyYYejNiRJ9KPBM4F/rUVAjpTskMrE9UtUPw6chSBquxFQy2rNV4WB6FBFTREc2PM
         yCvC3xibLom8551y6ZqowtIEtDorpHSETyiAWhWBNS01oCD044+A+bm4esUo9IcMQpYK
         99qhJtMw7bRljfL8WnZqnC6QYMF1osRRMpKOdoZVQb8L4JBkhQ5lVd6jQrYU9GO3SGPS
         LEnsaDsSTG3pMbalYhqWDfFaQd1N6cEdIVPFIb3IY0W9je9D0gyb26C/6XxDat0ek2Nh
         6aasrKc3W6Y1/qfAiWCjaGNc9fdWkiYLYjCeJ9jazocZd9/j2jVEEytDBLimAiX97QCo
         GSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7LtKSzkUnN8oqI99/lZipJjXqpkcAstNhdyBktayhLU=;
        b=uxqzpp7j1KYZe+DQG7TvOhf6v9k0cgBIYHXL2JjFgX5pJWW3OaVkjOhCqWCWOx/jpb
         2ejbXfXyGQxlsfwpVOMBF2bMXBx41ttq9r88lLmMWRPndGzYHAb3DOC7KOxVS05KXkry
         eWNeDlUA5yVEbzfQvGP5JMOUkocv3oDmUzEN+duMH4eUGwFdQoGtKgvUZlpb+jhQuHNe
         KBJFzh7l+0r4Oa/NgT/07+8IDowhjEHM/wxx3jKrD8xcQRgnB+PsRmQjWfVOjAPiE+kD
         2sVqKMT5oxkjyeORPWUcbH/7XG8tw0WeDfb9pZJGdsJ5gi3Zk6OJAhkVtlQi8xSeOR5a
         r1Dg==
X-Gm-Message-State: AOAM530flMa3wTrYpiJK7uBAZonlOc2bmqh4VNlC2Iv9jhfGDdJXKTpJ
        LxW+J+u0kJ9PDy7QcFFzy/hWXA==
X-Google-Smtp-Source: ABdhPJwcnYR09PCjCTXsOMwrWEfpikUVJwf7Z7hTmU+S5NLdqIB/dPizVC6lvjacF7n4gg7NLQMtzg==
X-Received: by 2002:a63:e30a:0:b0:385:fcae:d4a9 with SMTP id f10-20020a63e30a000000b00385fcaed4a9mr8191931pgh.85.1649265019331;
        Wed, 06 Apr 2022 10:10:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z2-20020aa79902000000b004fb05c04b53sm21035334pff.103.2022.04.06.10.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 10:10:18 -0700 (PDT)
Date:   Wed, 6 Apr 2022 17:10:15 +0000
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
Message-ID: <Yk3Jd6xAfgVoFgLc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
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

On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
> On 6.04.2022 03:48, Sean Christopherson wrote:
> > On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
> (..)
> > > Also, I'm not sure that even the proposed updated code above will
> > > actually restore the L1-requested next_rip correctly on L1 -> L2
> > > re-injection (will review once the full version is available).
> > 
> > Spoiler alert, it doesn't.  Save yourself the review time.  :-)
> > 
> > The missing piece is stashing away the injected event on nested VMRUN.  Those
> > events don't get routed through the normal interrupt/exception injection code and
> > so the next_rip info is lost on the subsequent #NPF.
> > 
> > Treating soft interrupts/exceptions like they were injected by KVM (which they
> > are, technically) works and doesn't seem too gross.  E.g. when prepping vmcb02
> > 
> > 	if (svm->nrips_enabled)
> > 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> > 		vmcb02->control.next_rip    = vmcb12_rip;
> > 
> > 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
> > 		svm->soft_int_injected = true;
> > 		svm->soft_int_csbase = svm->vmcb->save.cs.base;
> > 		svm->soft_int_old_rip = vmcb12_rip;
> > 		if (svm->nrips_enabled)
> > 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> > 		else
> > 			svm->soft_int_next_rip = vmcb12_rip;
> > 	}
> > 
> > And then the VMRUN error path just needs to clear soft_int_injected.
> 
> I am also a fan of parsing EVENTINJ from VMCB12 into relevant KVM
> injection structures (much like EXITINTINFO is parsed), as I said to
> Maxim two days ago [1].
> Not only for software {interrupts,exceptions} but for all incoming
> events (again, just like EXITINTINFO).

Ahh, I saw that fly by, but somehow I managed to misread what you intended.

I like the idea of populating vcpu->arch.interrupt/exception as "injected" events.
KVM prioritizes "injected" over other nested events, so in theory it should work
without too much fuss.  I've ran through a variety of edge cases in my head and
haven't found anything that would be fundamentally broken.  I think even live
migration would work.

I think I'd prefer to do that in a follow-up series so that nVMX can be converted
at the same time?  It's a bit absurd to add the above soft int code knowing that,
at least in theory, simply populating the right software structs would automagically
fix the bug.  But manually handling the soft int case first would be safer in the
sense that we'd still have a fix for the soft int case if it turns out that populating
vcpu->arch.interrupt/exception isn't as straightfoward as it seems.

> However, there is another issue related to L1 -> L2 event re-injection
> using standard KVM event injection mechanism: it mixes the L1 injection
> state with the L2 one.
> 
> Specifically for SVM:
> * When re-injecting a NMI into L2 NMI-blocking is enabled in
> vcpu->arch.hflags (shared between L1 and L2) and IRET intercept is
> enabled.
> 
> This is incorrect, since it is L1 that is responsible for enforcing NMI
> blocking for NMIs that it injects into its L2.

Ah, I see what you're saying.  I think :-)  IIUC, we can fix this bug without any
new flags, just skip the side effects if the NMI is being injected into L2.

@@ -3420,6 +3424,10 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
        struct vcpu_svm *svm = to_svm(vcpu);

        svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
+
+       if (is_guest_mode(vcpu))
+               return;
+
        vcpu->arch.hflags |= HF_NMI_MASK;
        if (!sev_es_guest(vcpu->kvm))
                svm_set_intercept(svm, INTERCEPT_IRET);

and for nVMX:

@@ -4598,6 +4598,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
        struct vcpu_vmx *vmx = to_vmx(vcpu);

+       if (is_guest_mode(vcpu))
+               goto inject_nmi;
+
        if (!enable_vnmi) {
                /*
                 * Tracking the NMI-blocked state in software is built upon
@@ -4619,6 +4622,7 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
                return;
        }

+inject_nmi:
        vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
                        INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);


> Also, *L2* being the target of such injection definitely should not block
> further NMIs for *L1*.

Actually, it should block NMIs for L1.  From L1's perspective, the injection is
part of VM-Entry.  That's a single gigantic instruction, thus there is no NMI window
until VM-Entry completes from L1's perspetive.  Any exit that occurs on vectoring
an injected event and is handled by L0 should not be visible to L1, because from
L1's perspective it's all part of VMRUN/VMLAUNCH/VMRESUME.  So blocking new events
because an NMI (or any event) needs to be reinjected for L2 is correct.

> * When re-injecting a *hardware* IRQ into L2 GIF is checked (previously
> even on the BUG_ON() level), while L1 should be able to inject even when
> L2 GIF is off,

Isn't that just a matter of tweaking the assertion to ignore GIF if L2 is
active?  Hmm, or deleting the assertion altogether, it's likely doing more harm
than good at this point.

> With the code in my previous patch set I planned to use
> exit_during_event_injection() to detect such case, but if we implement
> VMCB12 EVENTINJ parsing we can simply add a flag that the relevant event
> comes from L1, so its normal injection side-effects should be skipped.

Do we still need a flag based on the above?  Honest question... I've been staring
at all this for the better part of an hour and may have lost track of things.

> By the way, the relevant VMX code also looks rather suspicious,
> especially for the !enable_vnmi case.

I think it's safe to say we can ignore edge cases for !enable_vnmi.  It might even
be worth trying to remove that support again (Paolo tried years ago), IIRC the
only Intel CPUs that don't support virtual NMIs are some funky Yonah SKUs.

> Thanks,
> Maciej
> 
> [1]: https://lore.kernel.org/kvm/7d67bc6f-00ac-7c07-f6c2-c41b2f0d35a1@maciej.szmigiero.name/
