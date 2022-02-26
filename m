Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47A44C577D
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 19:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiBZS3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Feb 2022 13:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiBZS3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Feb 2022 13:29:09 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7891915FC9A
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 10:28:34 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id v28so11744953ljv.9
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 10:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YhAgqiWLbIhprpB4PTDWt6I/fMa4rCNESBFaVBRMGDk=;
        b=eF7sTfy8PRdrb5HHtbrH1LzmyvW0DK91TGdIQim+9sPGZkTcokk57lq6AU2sC6XCtN
         KZQHn4B6exdIG2xwONt7g+IsZk613AAMSVFbZpCl1fn9dhihWlm5FkWBSWT3xyxGbrkl
         GyrDbBJIT0oSJE/NnurO9H4rgeRRdlj84EfMdP/FVKZ0hYY+YMYJ9+RA93KZUIje4RAe
         jnhJOfj0CvGUuV0OaqwQe//20t/Kn5uEC5YtjdfhCuxXqM8YoihpoFCYD1wUpRl5unmf
         d4tbH0RXyyr93hd0k50r41p8V/7Qpe7r85LPvkCUpCBLKAx6TgeqQzYs/RMw4Vns5+bc
         Tzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhAgqiWLbIhprpB4PTDWt6I/fMa4rCNESBFaVBRMGDk=;
        b=7YAaqcloLXk8SC/kHrnzx730ER0HZ6THg4vapaae+j+qAxs/wIVCnfrUBZ6kFCmvWM
         Dbl6DJKqgbRli7/2Ded5YACx7fjDu9imHnd8+5O53yy32AVA0/ptGTDLnMBqFKBGZyyK
         0DipNJkEvwLxe0eIvHDtC4lGpkwFAWkWEdp1y9/9wh4tFz8a24/mvWGl34BDyC3M+gXf
         J6NurBq/AywEsgDLq/ydDtpcsuHRWYFS6DU8ILHIuNYNIwngeKUji22EEObYGBYvgm8D
         cYCwvPHJoXn56+K5PlFVUSpdxjyhwZYSnKBSspcZqlXwR5F2zOxcpMi7RqnKNjmALLqL
         7rUg==
X-Gm-Message-State: AOAM530I7MVJ578OOD416GMt3HCrNKcJJmBQmQFwyzo6JZYzVq0gDl9w
        tDckYOeN8Ro4+EA8AyGgqf8DCBZ0EJeCRabOFPL0GQ==
X-Google-Smtp-Source: ABdhPJxKzfIa2r2T8l8vr9vzs4enUHCu5WQWCNzEzy+VRL15+oBvPXtlpfEul4sVs5zWWtJh4YRYFC3zKqUfZsh2EIs=
X-Received: by 2002:a05:651c:160c:b0:244:c704:8315 with SMTP id
 f12-20020a05651c160c00b00244c7048315mr9079489ljq.170.1645900112391; Sat, 26
 Feb 2022 10:28:32 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-14-oupton@google.com>
 <87sfs82rz4.wl-maz@kernel.org> <YhflJ74nF2N+u1i4@google.com> <8735k57tnx.wl-maz@kernel.org>
In-Reply-To: <8735k57tnx.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Sat, 26 Feb 2022 10:28:21 -0800
Message-ID: <CAOQ_Qsi1n2PTGe3F5BAhy3yHS4ar_0n0tru7smAfwAFWGY3Jug@mail.gmail.com>
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

On Sat, Feb 26, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 24 Feb 2022 20:05:59 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > On Thu, Feb 24, 2022 at 03:40:15PM +0000, Marc Zyngier wrote:
> > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > index 2bb8d047cde4..a7de84cec2e4 100644
> > > > --- a/arch/arm64/kvm/psci.c
> > > > +++ b/arch/arm64/kvm/psci.c
> > > > @@ -245,6 +245,11 @@ static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > > >           return 1;
> > > >   }
> > > >
> > > > + if (kvm->arch.system_suspend_exits) {
> > > > +         kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND);
> > > > +         return 0;
> > > > + }
> > > > +
> > >
> > > So there really is a difference in behaviour here. Userspace sees the
> > > WFI behaviour before reset (it implements it), while when not using
> > > the SUSPEND event, reset occurs before anything else.
> > >
> > > They really should behave in a similar way (WFI first, reset next).
> >
> > I mentioned this on the other patch, but I think the conversation should
> > continue here as UAPI context is in this one.
> >
> > If SUSPEND exits are disabled and SYSTEM_SUSPEND is implemented in the
> > kernel, userspace cannot observe any intermediate state. I think it is
> > necessary for migration, otherwise if userspace were to save the vCPU
> > post-WFI, pre-reset the pending reset would get lost along the way.
> >
> > As far as userspace is concerned, I think the WFI+reset operation is
> > atomic. SUSPEND exits just allow userspace to intervene before said
> > atomic operation.
> >
> > Perhaps I'm missing something: assuming SUSPEND exits are disabled, what
> > value is provided to userspace if it can see WFI behavior before the
> > reset?
>
> Signals get in the way, and break the notion of atomicity. Userspace
> *will* observe this.
>
> I agree that save/restore is an important point, and that snapshoting
> the guest at this stage should capture the reset value. But it is the
> asymmetry of the behaviours that I find jarring:
>
> - if you ask for userspace exit, no reset value is applied and you
>   need to implement the reset in userspace
>
> - if you *don't* ask for a userspace exit, the reset values are
>   applied, and a signal while in WFI will result in this reset being
>   observed
>
> Why can't the userspace exit path also apply the reset values *before*
> exiting? After all, you can model this exit to userspace as
> reset+WFI+'spurious exit from WFI'. This would at least unify the two
> behaviours.

I hesitated applying the reset context to the CPU before the userspace
exit because that would be wildly different from the other system
events. Userspace wouldn't have much choice but to comply with the
guest request at that point.

What about adopting the following:

 - Drop the in-kernel SYSTEM_SUSPEND emulation. I think you were
getting at this point in [1], and I'd certainly be open to it. Without
a userspace exit, I don't think there is anything meaningfully
different between this call and a WFI instruction.

 - Add data to the kvm_run structure to convey the reset state for a
SYSTEM_SUSPEND exit. There's plenty of room left in the structure for
more, and can be done generically (just an array of data) for future
expansion. We already are going to need a code change in userspace to
do this right, so may as well update its view of kvm_run along the
way.

 - Exit to userspace with PSCI_RET_INTERNAL_FAILURE queued up for the
guest. Doing so keeps the exits consistent with the other system
exits, and affords userspace the ability to deny the call when it
wants to.

[1]: http://lore.kernel.org/r/87fso63ha2.wl-maz@kernel.org

> I still dislike the reset state being applied early, but consistency
> (and save/restore) trumps taste here. I know I'm being pedantic here,
> but we've been burned with loosely defined semantics in the past, and
> I want to get this right. Or less wrong.

I completely agree with you. The semantics are a bit funky, and I
really do wonder if the easiest way around that is to just make the
implementation a userspace problem.

--
Oliver
