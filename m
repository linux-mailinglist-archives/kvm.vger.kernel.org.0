Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E642531CCD
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbiEWRaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241891AbiEWR1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:27:19 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0F878901
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:22:23 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id a23-20020a4ad5d7000000b0035ee70da7a9so2850572oot.1
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jyra7hAVNbxUBiQeSeny3J1iXMJn4cpxNxDSkBqSwwc=;
        b=VHi49t2yJ8XZt3l4544whGRcgSG9/chQbJzw/Wb+5ioQ+fsmX3cRpBx6OQxRGk/Ap+
         wPsNDHmdeGfiSYG4yhVoaP8kdesRh7Z3VHHegl8q1JSEQj0W1/AxEFXVJe2KlCYoWN13
         25ePZeus2t/0M9W2csYI07b8jnWviHlnRWgHzXP6/J5XohAxHvEmdaxSNcoc7lfQnDsr
         8T4k7IU1HI2NNx9aZZvGD+J0Egdg5hSd6Pb1Fq4vl+wFkF6Jrauch0gNhrXAGtT7m/+u
         B9nF1ndDN2ey4SNsqLm4DJPsUNy/pqBr0mrYuds8wBJOa6h5x0I5D1XD3LaQVxke7Z+C
         zY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jyra7hAVNbxUBiQeSeny3J1iXMJn4cpxNxDSkBqSwwc=;
        b=uUEsn7zpPJ0uN5BnoB+SEXu2RLN7NVnDMPRjfspl5xoI7kB16u2ObvzBTn0+PxpVAa
         1fWkE6VtdFLCKqUsd3a0IymbAOqqQTtRqCe/jZV/zQ1e9HfiK9tcIxb0QEApGiYKNeza
         xvcXJwLAIGosRvzchyMlsoBD8r2Xf5ZkyePfC0CSwPA0LedjOkEcfcpH5pKzJ6X7klFt
         L1N/Yfa6fNnfsEqDkrn0SDQPblr0Ybfe4VtxiwlnlRzHOAIzubC7W1t1VhN15hj2fX/Z
         Jrlb7m6Rijg6tSC1DXHd6+k07G3r+snr3a0SucTn4k240tBwrzAPDexc/BCXz9S6sVRG
         Fjuw==
X-Gm-Message-State: AOAM530ndg9PRffIswdDNwY0xXcU1Pn+o4wOxz4eBKlJ/7gUOJuVkPUe
        IM9fwPBhXJf2eGHcDR6RQ73dt+cLyC1R4q6ZYsVVZQ==
X-Google-Smtp-Source: ABdhPJzHh/9qmSDYM9XAg5E0fgrqqHi95efq7cL0KZAg+w4CMPYF3qt7r4C+naxClkSjib2q5Q/h0H1EBI7lu9EI0tU=
X-Received: by 2002:a4a:c90a:0:b0:40e:95bf:268d with SMTP id
 v10-20020a4ac90a000000b0040e95bf268dmr1156358ooq.85.1653326540061; Mon, 23
 May 2022 10:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220427200314.276673-1-mlevitsk@redhat.com> <20220427200314.276673-3-mlevitsk@redhat.com>
 <YoZrG3n5fgMp4LQl@google.com> <e32f6c904c92e9e9efabcc697917a232f5e88881.camel@redhat.com>
 <CALMp9eSVji2CPW1AjFoSbWZ_b-r3y67HyatgdqXEqSyUaD1_BQ@mail.gmail.com> <65991ac329a32cf4128400b643d5b5ccf3918cfe.camel@redhat.com>
In-Reply-To: <65991ac329a32cf4128400b643d5b5ccf3918cfe.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 23 May 2022 10:22:09 -0700
Message-ID: <CALMp9eTS4MZPh4fwTPkNxnWgjT-xiqpxhMyVfdP8TZD0x81CMg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the guest
 and/or host changes apic id/base from the defaults.
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
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

On Sun, May 22, 2022 at 11:50 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Sun, 2022-05-22 at 07:47 -0700, Jim Mattson wrote:
> > On Sun, May 22, 2022 at 2:03 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > On Thu, 2022-05-19 at 16:06 +0000, Sean Christopherson wrote:
> > > > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > > > Neither of these settings should be changed by the guest and it is
> > > > > a burden to support it in the acceleration code, so just inhibit
> > > > > it instead.
> > > > >
> > > > > Also add a boolean 'apic_id_changed' to indicate if apic id ever changed.
> > > > >
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > > > +           return;
> > > > > +
> > > > > +   pr_warn_once("APIC ID change is unsupported by KVM");
> > > >
> > > > It's supported (modulo x2APIC shenanigans), otherwise KVM wouldn't need to disable
> > > > APICv.
> > >
> > > Here, as I said, it would be nice to see that warning if someone complains.
> > > Fact is that AVIC code was totally broken in this regard, and there are probably more,
> > > so it would be nice to see if anybody complains.
> > >
> > > If you insist, I'll remove this warning.
> >
> > This may be fine for a hobbyist, but it's a terrible API in an
> > enterprise environment. To be honest, I have no way of propagating
> > this warning from /var/log/messages on a particular host to a
> > potentially impacted customer. Worse, if they're not the first
> > impacted customer since the last host reboot, there's no warning to
> > propagate. I suppose I could just tell every later customer, "Your VM
> > was scheduled to run on a host that previously reported, 'APIC ID
> > change is unsupported by KVM.' If you notice any unusual behavior,
> > that might be the reason for it," but that isn't going to inspire
> > confidence. I could schedule a drain and reboot of the host, but that
> > defeats the whole point of the "_once" suffix.
>
> Mostly agree, and I read alrady few discussions about exactly this,
> those warnings are mostly useless, but they are used in the
> cases where we don't have the courage to just exit with KVM_EXIT_INTERNAL_ERROR.
>
> I do not thing though that the warning is completely useless,
> as we often have the kernel log of the target machine when things go wrong,
> so *we* can notice it.
> In other words a kernel warning is mostly useless but better that nothing.

I don't know how this works for you, but *we* are rarely involved when
things go wrong. :-(

> About KVM_EXIT_WARNING, this is IMHO a very good idea, probably combined
> with some form of taint flag, which could be read by qemu and then shown
> over hmp/qmp interfaces.
>
> Best regards,
>         Maxim levitsky
>
>
> >
> > I know that there's a long history of doing this in KVM, but I'd like
> > to ask that we:
> > a) stop piling on
> > b) start fixing the existing uses
> >
> > If KVM cannot emulate a perfectly valid operation, an exit to
> > userspace with KVM_EXIT_INTERNAL_ERROR is warranted. Perhaps for
> > operations that we suspect KVM might get wrong, we should have a new
> > userspace exit: KVM_EXIT_WARNING?
> >
> > I'm not saying that you should remove the warning. I'm just asking
> > that it be augmented with a direct signal to userspace that KVM may no
> > longer be reliable.
> >
>
>
