Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD64C4F6C25
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiDFVJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiDFVJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:09:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F3B1E8CF3
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 12:48:28 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b15so3425036pfm.5
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 12:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ivY7gPzhCgTPb85y1ArAKDyYkjWGtkQUuxuGGpkRaB4=;
        b=VvB/mS82pqmKMl7KSQBIAG2cz/OPBPDhEpi43Dh6W74+CSb3UnqLDmrhyfYy1ZrHfK
         qhQchnHgWM+MWNjqXDTtA/tWHN3xsSQtKfHirf5Wb9GYA/GYSvNu9nuowSMuVQLMssxJ
         JMRkb4iJo5rz646ajP+Y5tViG2WW+ZfZg5BCujD1ZcnY8dwqqA4fvWA08IrZPlMMwGzE
         34fyvuqWo292jtJEsmn/htAVeLM9UwH1hnQWdGZOLBMjbuAzajSi3bdxQcW+iAcJxOqH
         3TE/kAanMwYLNvjPdAyQsqY8/BwdE+RKGzPDrNEsb2Q8PG34u72F1zjmPsAh4l3InMYd
         xYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ivY7gPzhCgTPb85y1ArAKDyYkjWGtkQUuxuGGpkRaB4=;
        b=VhcflKJThoOCY9jWhmKtSnrjwvcvHz7Rx1Sk4O06P70MadBhyXyy9fcZOAHMr+0u2q
         cV3HH4bUAndyAgsLFOG5ug/ToavFU9eWheQ1cnQld4r+TnMnAjbEbTMPC4BeeAyXZkXU
         aGY8gk4rN3P2J5qykaYz+V9kJitphSK/rKLioo4+OvRVcgjHN0AA0teZhCOkj0ovukzp
         +lRX+AiL+6o5ygqKcCSOlCf+ExuEOgVTealFj9zJ6y3FoCvJ9IMlLCN9lnmYH3wWl7aH
         Lffkzi/Ya0eKtJ1/09oCcVzAe1OuJ/iKa+LLGGIQL2VZOCtOmBlN5IdL557TVS0H4lYw
         g9GA==
X-Gm-Message-State: AOAM532LmAT/OrtEM2QfKlam065lCLUFMFF4W4S6kuZ4bx8VdkAWUX+D
        GjJ/cNAj6heVwNIOwuoJPJLFXQ==
X-Google-Smtp-Source: ABdhPJxVp7ccl3nSue9FWuysUOekRnmu5STmGGspjwZDhaJlXmHWwGHr+WuuT+iuISJHS0oB3AzSag==
X-Received: by 2002:a63:204a:0:b0:399:5905:37ab with SMTP id r10-20020a63204a000000b00399590537abmr8377689pgm.229.1649274507577;
        Wed, 06 Apr 2022 12:48:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i2-20020a625402000000b004fdf66ab35fsm12737270pfb.21.2022.04.06.12.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 12:48:26 -0700 (PDT)
Date:   Wed, 6 Apr 2022 19:48:23 +0000
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
Message-ID: <Yk3uh6f+0nOdybd3@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
 <Yk3Jd6xAfgVoFgLc@google.com>
 <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
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
> On 6.04.2022 19:10, Sean Christopherson wrote:
> > On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
> And what if it's L0 that is trying to inject a NMI into L2?
> In this case is_guest_mode() is true, but the full NMI injection machinery
> should be used.

Gah, you're right, I got misled by a benign bug in nested_vmx_l1_wants_exit() and
was thinking that NMIs always exit.  The "L1 wants" part should be conditioned on
NMI exiting being enabled.  It's benign because KVM always wants "real" NMIs, and
so the path is never encountered.

@@ -5980,7 +6005,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
        switch ((u16)exit_reason.basic) {
        case EXIT_REASON_EXCEPTION_NMI:
                intr_info = vmx_get_intr_info(vcpu);
-               if (is_nmi(intr_info))
+               if (is_nmi(intr_info) && nested_cpu_has_nmi_exiting(vmcs12))
                        return true;
                else if (is_page_fault(intr_info))
                        return true;


> > > Also, *L2* being the target of such injection definitely should not block
> > > further NMIs for *L1*.
> > 
> > Actually, it should block NMIs for L1.  From L1's perspective, the injection is
> > part of VM-Entry.  That's a single gigantic instruction, thus there is no NMI window
> > until VM-Entry completes from L1's perspetive.  Any exit that occurs on vectoring
> > an injected event and is handled by L0 should not be visible to L1, because from
> > L1's perspective it's all part of VMRUN/VMLAUNCH/VMRESUME.  So blocking new events
> > because an NMI (or any event) needs to be reinjected for L2 is correct.
> 
> I think this kind of NMI blocking will be already handled by having
> the pending new NMI in vcpu->arch.nmi_pending but the one that needs
> re-injecting in vcpu->arch.nmi_injected.
> 
> The pending new NMI in vcpu->arch.nmi_pending won't be handled until
> vcpu->arch.nmi_injected gets cleared (that is, until re-injection is
> successful).

Yep.

> It is incorrect however, to wait for L2 to execute IRET to unblock
> L0 -> L1 NMIs or L1 -> L2 NMIs, in these two cases we (L0) just need the CPU
> to vector that L2 NMI so it no longer shows in EXITINTINFO.

Yep, and the pending NMI should cause KVM to request an "immediate" exit that
occurs after vectoring completes.

> It is also incorrect to block L1 -> L2 NMI injection because either L1
> or L2 is currently under NMI blocking: the first case is obvious,
> the second because it's L1 that is supposed to take care of proper NMI
> blocking for L2 when injecting an NMI there.

Yep, but I don't think there's a bug here.  At least not for nVMX.

> > > * When re-injecting a *hardware* IRQ into L2 GIF is checked (previously
> > > even on the BUG_ON() level), while L1 should be able to inject even when
> > > L2 GIF is off,
> > 
> > Isn't that just a matter of tweaking the assertion to ignore GIF if L2 is
> > active?  Hmm, or deleting the assertion altogether, it's likely doing more harm
> > than good at this point.
> 
> I assume this assertion is meant to catch the case when KVM itself (L0) is
> trying to erroneously inject a hardware interrupt into L1 or L2, so it will
> need to be skipped only for L1 -> L2 event injection.

Yeah, that's what my git archeaology came up with too.

> Whether this assertion benefits outweigh its costs is debatable - don't have
> a strong opinion here (BUG_ON() is for sure too strong, but WARN_ON_ONCE()
> might make sense to catch latent bugs).
> 
> > > With the code in my previous patch set I planned to use
> > > exit_during_event_injection() to detect such case, but if we implement
> > > VMCB12 EVENTINJ parsing we can simply add a flag that the relevant event
> > > comes from L1, so its normal injection side-effects should be skipped.
> > 
> > Do we still need a flag based on the above?  Honest question... I've been staring
> > at all this for the better part of an hour and may have lost track of things.
> 
> If checking just is_guest_mode() is not enough due to reasons I described
> above then we need to somehow determine in the NMI / IRQ injection handler
> whether the event to be injected into L2 comes from L0 or L1.
> For this (assuming we do VMCB12 EVENTINJ parsing) I think we need an extra flag.

Yes :-(  And I believe the extra flag would need to be handled by KVM_{G,S}ET_VCPU_EVENTS.
 
> > > By the way, the relevant VMX code also looks rather suspicious,
> > > especially for the !enable_vnmi case.
> > 
> > I think it's safe to say we can ignore edge cases for !enable_vnmi.  It might even
> > be worth trying to remove that support again (Paolo tried years ago), IIRC the
> > only Intel CPUs that don't support virtual NMIs are some funky Yonah SKUs.
> 
> Ack, we could at least disable nested on !enable_vnmi.
> 
> BTW, I think that besides Yonah cores very early Core 2 CPUs also lacked
> vNMI support, that's why !enable_vnmi support was reinstated.
> But that's hardware even older than !nrips AMD parts.
