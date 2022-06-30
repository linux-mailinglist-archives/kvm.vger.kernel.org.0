Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B889561FD0
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiF3QBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 12:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236271AbiF3QBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 12:01:06 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5673B1BE80
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 09:01:04 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-101d2e81bceso26473791fac.0
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 09:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgBbKieDiC7Mnkk7RkqR7SZbMT1idh4KZCFyw9gKf4Y=;
        b=ku3hrIfINU9Gz6j8NGGS8tEzEjIt945AWd286RiwiyhiB+M3vBwVxOO7Q7EW6jUV7m
         msAjfB8cyE2oOxPd1l/4xwbQ46dD5JhCRYdI+5ReKNcMnmvJJJ2YdoZETJ3HWJcJixHO
         2TDSuMgiixgv1nNXaQs9/wzTz1sLy6Nt0ycyUwTHa1shKUnBrsQjkGUHaznvxLFnO1+c
         RDiCatJYGDyaSiPpWJdW+6T5PZhkIPidNplRzy6W2wLGFDq124r0EyyHOicDvVdM23HM
         q8k/qthmHfmGYUvT36IIm8CJg8t+3ufupoIjfF+xk6P6Ufeg6TIBR53LucRwj0qngXN9
         zKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgBbKieDiC7Mnkk7RkqR7SZbMT1idh4KZCFyw9gKf4Y=;
        b=VJpFpkFvMM8X0QlAoYwuF4uY41UmsRcp4LyTgUED73gKH4y2RmzvXuXnjI3hllhIlO
         Ns7yEmywcOI+ii82d7OOyDK2LMxtzgGinUQEZd6lazBMVlYoOzyaihm3lxnP4FDByfX3
         vzD/MRQrPQ7WHcb7kYgackTDWJGQZVQjnnjAFVv24RXenBMH+USGJiT98nlaV0PfwL5I
         hNxrzU6s7HUSahjM9IVjwMjEJQX+CSn/tgoDdtD/6jveQ+Z8E1muYn5UKWCQH+NuuyZj
         TUIIWF9lcNFRpxD1usJXNvrilRk+SHSp+7Slp0FONzNQUb7ErtN6SnGJtttI8dbpB2BO
         6eGg==
X-Gm-Message-State: AJIora+X+46qaofnvB26PrWPeQxExFjMnTS/sWleMOiwea8vKyNOyJZJ
        ybTtsHALzrZ+AGZFhv1PraOIBNSPMW0q2+vKgW8TAA==
X-Google-Smtp-Source: AGRyM1sPtuG+qbEdcwSTIr7QZVHD2VLgcrGbMD039HjWZ04QUBaryHLGH5Ht5bVQ5Sh/0cRO7d3FPzHEJLV5PlDxpTs=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr6901331oab.112.1656604863408; Thu, 30
 Jun 2022 09:01:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220621150902.46126-1-mlevitsk@redhat.com> <20220621150902.46126-12-mlevitsk@redhat.com>
 <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com> <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
In-Reply-To: <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jun 2022 09:00:52 -0700
Message-ID: <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 11:00 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Wed, 2022-06-29 at 09:31 -0700, Jim Mattson wrote:
> > On Tue, Jun 21, 2022 at 8:09 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > When #SMI is asserted, the CPU can be in interrupt shadow
> > > due to sti or mov ss.
> > >
> > > It is not mandatory in  Intel/AMD prm to have the #SMI
> > > blocked during the shadow, and on top of
> > > that, since neither SVM nor VMX has true support for SMI
> > > window, waiting for one instruction would mean single stepping
> > > the guest.
> > >
> > > Instead, allow #SMI in this case, but both reset the interrupt
> > > window and stash its value in SMRAM to restore it on exit
> > > from SMM.
> > >
> > > This fixes rare failures seen mostly on windows guests on VMX,
> > > when #SMI falls on the sti instruction which mainfest in
> > > VM entry failure due to EFLAGS.IF not being set, but STI interrupt
> > > window still being set in the VMCS.
> >
> > I think you're just making stuff up! See Note #5 at
> > https://sandpile.org/x86/inter.htm.
> >
> > Can you reference the vendors' documentation that supports this change?
> >
>
> First of all, just to note that the actual issue here was that
> we don't clear the shadow bits in the guest interruptability field
> in the vmcb on SMM entry, that triggered a consistency check because
> we do clear EFLAGS.IF.
> Preserving the interrupt shadow is just nice to have.
>
>
> That what Intel's spec says for the 'STI':
>
> "The IF flag and the STI and CLI instructions do not prohibit the generation of exceptions and nonmaskable inter-
> rupts (NMIs). However, NMIs (and system-management interrupts) may be inhibited on the instruction boundary
> following an execution of STI that begins with IF = 0."
>
> Thus it is likely that #SMI are just blocked when in shadow, but it is easier to implement
> it this way (avoids single stepping the guest) and without any user visable difference,
> which I noted in the patch description, I noted that there are two ways to solve this,
> and preserving the int shadow in SMRAM is just more simple way.

It's not true that there is no user-visible difference. In your
implementation, the SMI handler can see that the interrupt was
delivered in the interrupt shadow.

The right fix for this problem is to block SMI in an interrupt shadow,
as is likely the case for all modern CPUs.

>
> As for CPUS that neither block SMI nor preserve the int shadaw, in theory they can, but that would
> break things, as noted in this mail
>
> https://lore.kernel.org/lkml/1284913699-14986-1-git-send-email-avi@redhat.com/
>
> It is possible though that real cpu supports HLT restart flag, which makes this a non issue,
> still. I can't rule out that a real cpu doesn't preserve the interrupt shadow on SMI, but
> I don't see why we can't do this to make things more robust.

Because, as I said, I think you're just making stuff up...unless, of
course, you have documentation to back this up.
