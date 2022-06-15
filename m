Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB454D1EF
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347398AbiFOTsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345960AbiFOTsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:48:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2879C248D1
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:48:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id n28so17686511edb.9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=snEag1wbHHFhilRmxjm0lrtfrz/YdBZTKsq0P0chyu8=;
        b=AeNDTKELT0jmqGGepGHolVzyfu6wYNfd2zjPumESIaQBHE6C6B1/xKwWgifxyuA1mh
         vDPnqfL0/RhnDztObZFQ52v8dn1iQwa7MUtGnqJMefPBSQnGwOHFI48+qJ+b+3TissuD
         QQXW4p0va2VSLt5W1GDfkBvhbxAtdCAv17MAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=snEag1wbHHFhilRmxjm0lrtfrz/YdBZTKsq0P0chyu8=;
        b=CeR5tERuvyslMs0ZKVQvHGJ/4IiCQmu7FgT4zbsy5H1ONh3iqu/qG7kx2G1SFSkhun
         DqalW0FRe3v5EaNFprTHVvhHuq9lgce5LSI4pCdy9rTCRPAYnpgW4IT6m04vqTjrvjmh
         /2IwzMxlLrkeCMS5xevx633DEMXsCN2hLBqFLDqC1yi+nmMnPF7J4k5Sx1Kt4LZnQkrh
         haB21gNttltxPfiWHWalSFvxZSKxU5wTBoNpT4WBX3CGHkiAPKpJzNIFxv6oM4nD3Bk9
         gy1RS6ZwQWFdGjFGqJLXUdxFLnXjdNAa1GGhD250bxLstB1vr6i4vIEMYjcO65i5reYz
         T/HA==
X-Gm-Message-State: AJIora+vZ8m/EqbBhfhSI7U0CC0uXN37I6Y7kRingkTYFI49svsZUH8B
        v4OdPGeQ9cCZA5fSbJbxKZoK4NjreudtQ2scS9o9LA==
X-Google-Smtp-Source: AGRyM1vp2nUfha22ATh4PxxvDfe2ri7n8CzEF22XTrCLA+Xez6lPNSYK7Bg+0hvEA0vi+HjO00/d55Kq9whXz5sUUWk=
X-Received: by 2002:a05:6402:2399:b0:42e:1400:818b with SMTP id
 j25-20020a056402239900b0042e1400818bmr1773955eda.159.1655322488696; Wed, 15
 Jun 2022 12:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220615171410.ab537c7af3691a0d91171a76@virtuozzo.com> <Yqn0GofIXFOHk6k4@google.com>
In-Reply-To: <Yqn0GofIXFOHk6k4@google.com>
From:   Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date:   Wed, 15 Jun 2022 22:47:57 +0300
Message-ID: <CAJqdLrrM7ttxM-psdLG0rLydS+HBPX3Yqi_TEtxizni4a4eySA@mail.gmail.com>
Subject: Re: [Question] debugging VM cpu hotplug (#GP -> #DF) which results in reset
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, den@virtuozzo.com,
        ptikhomirov@virtuozzo.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sean,

Thanks a lot for your answer!

On Wed, Jun 15, 2022 at 6:00 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jun 15, 2022, Alexander Mikhalitsyn wrote:
> > Dear friends,
> >
> > I'm sorry for disturbing you but I've getting stuck with debugging KVM
> > problem and looking for an advice. I'm working mostly on kernel
> > containers/CRIU and am newbie with KVM so, I believe that I'm missing
> > something very simple.
> >
> > My case:
> > - AMD EPYC 7443P 24-Core Processor (Milan family processor)
> > - OpenVZ kernel (based on RHEL7 3.10.0-1160.53.1) on the Host Node (HN)
> > - Qemu/KVM VM (8 vCPU assigned) with many different kernels from 3.10.0-1160 RHEL7 to mainline 5.18
> >
> > Reproducer (run inside VM):
> > echo 0 > /sys/devices/system/cpu/cpu3/online
> > echo 1 > /sys/devices/system/cpu/cpu3/online <- got reset here
> >
> > *Not* reproducible on:
> > - any Intel which we tried
> > - AMD EPYC 7261 (Rome family)
>
> Hmm, given that Milan is problematic but Rome isn't, that implies the bug is related
> to a feature that's new in Milan.  PCID is the one that comes to mind, and IIRC there
> were issues with PCID (or INVCPID?) in various kernels when running on Milan.
>
> Can you try hiding PCID and INVPCID from the guest?

Yep, I've tried to disable PCID and INVPCID features by nopcid and
noinvpcid kernel cmdline flags.
noinvpcid not effects on the problem, but nopcid does! Fantastic!

Of course, masking CPU feature from qemu side is also works:
  <cpu mode='host-model' check='partial'>
    <feature policy='disable' name='pcid'/>
  </cpu>

Now, thanks to your advice, I will try to understand why the PCID
feature breaks VMs. I see
that we've some support for this feature in our host kernel (based on
RHEL7 3.10.0-1160.53.1), probably
We have some bugs or are not handling something PCID-related from the KVM side.

Thanks again, I couldn't have pulled this off without your advice, Sean.

>
> > - without KVM (on Host)
>
> ...
>
> > ==== trace-cmd record -b 20000 -e kvm:kvm_cr -e kvm:kvm_userspace_exit -e probe:* =====
> >
> >              CPU-1834  [003] 69194.833364: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
> >              CPU-1838  [000] 69194.834177: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
> >              CPU-1838  [000] 69194.834180: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0xd000001 has_error=0x0 nr=0xd error_code=0x0 has_payload=0x0
> >              CPU-1838  [000] 69194.834195: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
> >              CPU-1838  [000] 69194.834196: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0x8000100 has_error=0x0 nr=0x8 error_code=0x0 has_payload=0x0
> >              CPU-1838  [000] 69194.834200: shutdown_interception_L8: (ffffffff8146e4a0)
>
> If you can modify the host kernel, throwing a WARN in kvm_multiple_exception() should
> pinpoint the source of the #GP.  Though you may get unlucky and find that KVM is just
> reflecting an intercepted a #GP that was first "injected" by hardware.  Note that this
> could spam the log if KVM is injecting a large number of #GPs.
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9cea051ca62e..19d959bf97cc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -612,6 +612,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>         u32 prev_nr;
>         int class1, class2;
>
> +       WARN_ON(nr == GP_VECTOR);
> +
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
>
>         if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
>

Thanks! I'll try to play with that.

Best regards,
Alex
