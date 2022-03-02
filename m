Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBEB4CA189
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbiCBJ6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 04:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240762AbiCBJ6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 04:58:18 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F62A181
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 01:57:21 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u11so1487978lju.4
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 01:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aKuyfSIYmSlG46+Z3eVPpfXvTwAhmEo9kXpqu0l3v6Y=;
        b=A8u395OXpOi6TkdoibjC+Wuttx3LnpW2WXCr2Oo0LNHP2OSPniYGjR39jifoZa9qZ+
         LaqceycIJH+ghxlUWaBH+fPhfgkgqP/GsUlnijw3YnqePC5ObkYIfPAfgpHQ9yEH1EcF
         4ho0q0Ck1DxPVmB6jf1Loy4WhCSwoi/UgPZY2tHTINtoFRzFlDSNaw6xP1pffpGAwvoa
         ohQjlWdxFX2MBDkbfvRgUaLlQ1BMahM4MRwoUbdHS523yGn4CRtmHXEu6eZC4Xq6jbZ7
         IlbVdkDI6/w5FisYJOijzdnuqb1C5PGu8FVSmhdV+T5pV++on2//8hnwhvlEjDIetzGL
         N0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aKuyfSIYmSlG46+Z3eVPpfXvTwAhmEo9kXpqu0l3v6Y=;
        b=OXu6qkP72g/SQ12vS4wWefPp9fU3ywt79Arl4eMxg9dE7P/f9UcfYZJxvzi9CNUFQf
         ga2SBgZee+YXwYfjZEQS2tXFscO2Wd1R7wu79PMwOyCs3lsbORW18kdMjgSLiiS/80EG
         xeQThCzyD5aRqQaIeUbVd1eau1ED0D8A/dc6iHgOWjoeT30SO40SlPvsczEZZqtx9jjQ
         TtUoM5tfoeP2B5sR4f6vco10T3bLsiMvGUu6TjI+EEXPeTShUdMCiMV159DUyIGCsmpI
         KFYgQtov4R1S1RyR1Z27toyfDCYo1mdk+ZqqbehsuWPsv6neGf9iOsiJ/wzbcsrXHkcm
         WHKw==
X-Gm-Message-State: AOAM530iBMEgeE4QVvPfbhPUP6bHRojRzhrU44AJ09QREphl53tt3sJQ
        9+fpNQtTJgCq9qk9sQZizhVf699DAfZOtH1iR028lg==
X-Google-Smtp-Source: ABdhPJwYdrHqTN7+CaZOAynhxMqmxut3XkZa7AgLknNJcuy8LukxF4yCQ0mB4d4CiA3XB4hytqtOmmabhkrAtpIB/tY=
X-Received: by 2002:a2e:b16e:0:b0:244:d368:57e with SMTP id
 a14-20020a2eb16e000000b00244d368057emr20011637ljm.251.1646215039693; Wed, 02
 Mar 2022 01:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-14-oupton@google.com>
 <87sfs82rz4.wl-maz@kernel.org> <YhflJ74nF2N+u1i4@google.com>
 <8735k57tnx.wl-maz@kernel.org> <CAOQ_Qsi1n2PTGe3F5BAhy3yHS4ar_0n0tru7smAfwAFWGY3Jug@mail.gmail.com>
 <87a6e83cme.wl-maz@kernel.org>
In-Reply-To: <87a6e83cme.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 2 Mar 2022 01:57:08 -0800
Message-ID: <CAOQ_QsiEM_O4oY_R3VasaiaGSMwJxAa=uBx6fi9yM9oYjWc_WQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/19] KVM: arm64: Add support KVM_SYSTEM_EVENT_SUSPEND
 to PSCI SYSTEM_SUSPEND
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 2, 2022 at 1:52 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 26 Feb 2022 18:28:21 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > On Sat, Feb 26, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 24 Feb 2022 20:05:59 +0000,
> > > Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Thu, Feb 24, 2022 at 03:40:15PM +0000, Marc Zyngier wrote:
> > > > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > > > index 2bb8d047cde4..a7de84cec2e4 100644
> > > > > > --- a/arch/arm64/kvm/psci.c
> > > > > > +++ b/arch/arm64/kvm/psci.c
> > > > > > @@ -245,6 +245,11 @@ static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > > > > >           return 1;
> > > > > >   }
> > > > > >
> > > > > > + if (kvm->arch.system_suspend_exits) {
> > > > > > +         kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND);
> > > > > > +         return 0;
> > > > > > + }
> > > > > > +
> > > > >
> > > > > So there really is a difference in behaviour here. Userspace sees the
> > > > > WFI behaviour before reset (it implements it), while when not using
> > > > > the SUSPEND event, reset occurs before anything else.
> > > > >
> > > > > They really should behave in a similar way (WFI first, reset next).
> > > >
> > > > I mentioned this on the other patch, but I think the conversation should
> > > > continue here as UAPI context is in this one.
> > > >
> > > > If SUSPEND exits are disabled and SYSTEM_SUSPEND is implemented in the
> > > > kernel, userspace cannot observe any intermediate state. I think it is
> > > > necessary for migration, otherwise if userspace were to save the vCPU
> > > > post-WFI, pre-reset the pending reset would get lost along the way.
> > > >
> > > > As far as userspace is concerned, I think the WFI+reset operation is
> > > > atomic. SUSPEND exits just allow userspace to intervene before said
> > > > atomic operation.
> > > >
> > > > Perhaps I'm missing something: assuming SUSPEND exits are disabled, what
> > > > value is provided to userspace if it can see WFI behavior before the
> > > > reset?
> > >
> > > Signals get in the way, and break the notion of atomicity. Userspace
> > > *will* observe this.
> > >
> > > I agree that save/restore is an important point, and that snapshoting
> > > the guest at this stage should capture the reset value. But it is the
> > > asymmetry of the behaviours that I find jarring:
> > >
> > > - if you ask for userspace exit, no reset value is applied and you
> > >   need to implement the reset in userspace
> > >
> > > - if you *don't* ask for a userspace exit, the reset values are
> > >   applied, and a signal while in WFI will result in this reset being
> > >   observed
> > >
> > > Why can't the userspace exit path also apply the reset values *before*
> > > exiting? After all, you can model this exit to userspace as
> > > reset+WFI+'spurious exit from WFI'. This would at least unify the two
> > > behaviours.
> >
> > I hesitated applying the reset context to the CPU before the userspace
> > exit because that would be wildly different from the other system
> > events. Userspace wouldn't have much choice but to comply with the
> > guest request at that point.
> >
> > What about adopting the following:
> >
> >  - Drop the in-kernel SYSTEM_SUSPEND emulation. I think you were
> > getting at this point in [1], and I'd certainly be open to it. Without
> > a userspace exit, I don't think there is anything meaningfully
> > different between this call and a WFI instruction.
>
> The only difference is the reset part. And I agree, it only makes the
> kernel part more complicated than we strictly need it to be. It also
> slightly clashes with the rest of the system events, in the sense that
> it is the only one that would have an in-kernel implementation (both
> reboot and power-off are entirely implemented in userspace).
>
> So I definitely agree about dropping this.
>
> >
> >  - Add data to the kvm_run structure to convey the reset state for a
> > SYSTEM_SUSPEND exit. There's plenty of room left in the structure for
> > more, and can be done generically (just an array of data) for future
> > expansion. We already are going to need a code change in userspace to
> > do this right, so may as well update its view of kvm_run along the
> > way.
>
> The reset state is already available in the guest registers, which are
> available to userspace. What else do we need to expose?

Nothing. It is just a slight nitnoid thing for me where
KVM_EXIT_SYSTEM_SUSPEND behaves a bit differently than the others. If
a VMM wants to reject the call, it needs to manually set up the SMCCC
return value, whereas on the others a naive call to KVM_RUN will do
the job since KVM already sets up the failure value.

Unsure if this warrants a kvm_run change, leaning towards no if it is
well documented.

> >  - Exit to userspace with PSCI_RET_INTERNAL_FAILURE queued up for the
> > guest. Doing so keeps the exits consistent with the other system
> > exits, and affords userspace the ability to deny the call when it
> > wants to.
>
> Yup, that's what I like about pushing this completely to userspace.
>
> >
> > [1]: http://lore.kernel.org/r/87fso63ha2.wl-maz@kernel.org
> >
> > > I still dislike the reset state being applied early, but consistency
> > > (and save/restore) trumps taste here. I know I'm being pedantic here,
> > > but we've been burned with loosely defined semantics in the past, and
> > > I want to get this right. Or less wrong.
> >
> > I completely agree with you. The semantics are a bit funky, and I
> > really do wonder if the easiest way around that is to just make the
> > implementation a userspace problem.
>
> We're in violent agreement.

Lol

> It means that we only need the MP_STATE
> part to implement WFI from userspace.
>
> Could you try and respin this? Also, it'd be good to see a prototype
> of userspace code using this, as this is a new API.

Sure thing. I'll keep it to kvmtool, since that's the most familiar to
me. Also, I think I had an RFC for kvmtool many moons ago...

--
Oliver
