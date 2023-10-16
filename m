Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EFE7CAF2D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjJPQ2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbjJPQ2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:28:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDAE3864
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:27:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5b62a669d61so674809a12.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697473651; x=1698078451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7SHGWla937Gcko2x/41+5jRftwU3dSxNbVqbwIDpdSk=;
        b=Y4Ng5Jx8MLjdA5jGRNSM3q9dvcZWfuJaTvYFqgh3Y6vJVgUdzf0db0T7UUq6U2tkuB
         0RGv93/Q3ZP4JzcsjHEYU5BZWOPuRcwrnnnc4lPqZ9hTvP4PBtpsrUPYH2bQdRgxVGFJ
         JYANEP3ckwDiYrvZPLmUJDmnZXdd3rmJl6GgTZBJiYNodpJHLJBGKDrH+drwm1JU3JR9
         a1SmYadVy4SsuJXQd3P8rEeAB4pbRDKqtboPNPA1Y2ti804kv+D+DiwuHJGTm9ZM9F2u
         ltRCEx92TcFN6UlhCVLvL7MjVw55U9/I3hXm9xvRn1Xp7k0lQLGZS6TJCnC+1DpW3Hj+
         +nBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697473651; x=1698078451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7SHGWla937Gcko2x/41+5jRftwU3dSxNbVqbwIDpdSk=;
        b=aNfZL1qbzJIUn9/wY5sysxiMm+Tfw3vTeOh4RWVlDYsIef0XqibAlVy3OzVZgqf+7F
         QBprSeYyunNdz6mQwXjSyGhKzVGwW/hEBKq5MIHcXcfLvas3oGdTd4TQUxZGKC+NuLqb
         IUmHfwyZoKy7o6bXvC31sJCkSkZv9t17u/OW5xNQr6IEc+To+IZAsDdDA9DRYU7RTNCq
         OE6VRTFwgfxP1LIARKsNBSQhsI/w+mpwst0IT8jPfteO4/pr2LXVrpiymMV97LeBPTQZ
         gtUiqwD0lSDrKm2mtcXWJmBHAmpb5cnXeDvNkEmqrx5dbJqxgcUJX5kpCZjgIl2aic1i
         rEBg==
X-Gm-Message-State: AOJu0YwiolOg4LysXTSg9gkuJh8yrw33ITytqto7ALDsG2GcLZ1NH4vj
        wCnx9BAZ3TI9k1lKOI9voC1MFoThQRA=
X-Google-Smtp-Source: AGHT+IF7mH1dtOpFOpDv49wIOH8cgkPw8jWX+jo+fS29M2x6+4uh7pQe2x6ZGLJbUWaT5EVlxXzdc7NJUww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce89:b0:1c9:bee2:e20b with SMTP id
 f9-20020a170902ce8900b001c9bee2e20bmr392224plg.11.1697473650686; Mon, 16 Oct
 2023 09:27:30 -0700 (PDT)
Date:   Mon, 16 Oct 2023 09:27:29 -0700
In-Reply-To: <CW9VEIPFLJJA.3OI6RJQVQU7ZN@amazon.com>
Mime-Version: 1.0
References: <20231016095217.37574-1-nsaenz@amazon.com> <87sf6a9335.fsf@redhat.com>
 <CW9VEIPFLJJA.3OI6RJQVQU7ZN@amazon.com>
Message-ID: <ZS1kcXuGqO3O7yAq@google.com>
Subject: Re: [PATCH] KVM: x86: hyper-v: Don't auto-enable stimer during deserialization
From:   Sean Christopherson <seanjc@google.com>
To:     Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, graf@amazon.de, rkagan@amazon.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'd prefer the shortlog be more explicit about the write coming from userspace, e.g.

  KVM: x86: hyper-v: Don't auto-enable stimer on write from userspace

A non-zero number of KVM's "deserialization" ioctls are used to stuff state
without a paired "serialization".  I doubt anyone is doing that with the Hyper-V
ioctls, but keeping things consistent is helpful for readers.

On Mon, Oct 16, 2023, Nicolas Saenz Julienne wrote:
> Hi Vitaly,
> 
> On Mon Oct 16, 2023 at 12:14 PM UTC, Vitaly Kuznetsov wrote:
> > Nicolas Saenz Julienne <nsaenz@amazon.com> writes:
> >
> > > By not honoring the 'stimer->config.enable' state during stimer
> > > deserialization we might introduce spurious timer interrupts. For

Avoid pronouns please.

> > > example through the following events:
> > >  - The stimer is configured in auto-enable mode.
> > >  - The stimer's count is set and the timer enabled.
> > >  - The stimer expires, an interrupt is injected.
> > >  - We live migrate the VM.

Same here.  "We" is already ambiguous, because the first usage is largely about
KVM, and the second usage here is much more about userspace and/or the actual
user.

> > >  - The stimer config and count are deserialized, auto-enable is ON, the
> > >    stimer is re-enabled.
> > >  - The stimer expires right away, and injects an unwarranted interrupt.
> > >
> > > So let's not change the stimer's enable state if the MSR write comes
> > > from user-space.

Don't hedge, firmly state what the patch does and why the change is necessary
and correct.  If it turns out the change is wrong, then the follow-up patch can
explain the situation.  But in the happy case where the change is correct, using
language that isn't assertive can result in 

> > > Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")

Does this need a?

  Cc: stable@vger.kernel

> > > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > > ---
> > >  arch/x86/kvm/hyperv.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > > index 7c2dac6824e2..9f1deb6aa131 100644
> > > --- a/arch/x86/kvm/hyperv.c
> > > +++ b/arch/x86/kvm/hyperv.c
> > > @@ -729,7 +729,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
> > >       stimer->count = count;
> > >       if (stimer->count == 0)
> > >               stimer->config.enable = 0;
> >
> > Can this branch be problematic too? E.g. if STIMER[X]_CONFIG is
> > deserialized after STIMER[X]_COUNT we may erroneously reset 'enable' to
> > 0, right? In fact, when MSRs are ordered like this:
> >
> > #define HV_X64_MSR_STIMER0_CONFIG               0x400000B0
> > #define HV_X64_MSR_STIMER0_COUNT                0x400000B1
> >
> > I would guess that we always de-serialize 'config' first. With
> > auto-enable, the timer will get enabled when writing 'count' but what
> > happens in other cases?
> >
> > Maybe the whole block needs to go under 'if (!host)' instead?
> 
> In either case, with 'enable == 1' && 'count == 0' we'll reset the timer
> in 'kvm_hv_process_stimers()'. So it's unlikely to cause any weirdness.
> That said, I think covering both cases is more correct. Will send a v2.

Agreed, I think it needs to be all or nothing, i.e. either process all side effects
of writing the count, or don't process any.
