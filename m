Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289F235D959
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbhDMHxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbhDMHxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 03:53:08 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6D7C061574;
        Tue, 13 Apr 2021 00:52:47 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so15353790oto.2;
        Tue, 13 Apr 2021 00:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yX8u49zcNZ6Iu+zR+ydg0GPOdjOn3tEajOW+nV/aMzc=;
        b=ZQhLDsFs43L25f7WWYrk+tpLawVbR7qw/469aBNVWWU1md8QBru5s/kqds5+zJe0TS
         nxEZGY+ajmeICT4n1E3x1tgjoarlV+t5TTC6fHz1yZ4tsTvzkoh+1qk+icVp2s8nXzuZ
         +ti+MBPzIOSyoVs7HfHz7UxxcSJ2HEJZqNEQgLXpaT7mDbX+2gGV5ygVphPlPuzEHwnm
         WJBSu2dTj8AiqerPdvaRVcSb5I5zXFPvJALRpzn0gA0j4FyQXwnI09spNraimKDhvi97
         9C8FoVAA9PPsfget5kSujnOQgENmI/IJqdIQSRGsKqmIZFgSjPe3F+EikEBa5B53yQQ6
         xSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yX8u49zcNZ6Iu+zR+ydg0GPOdjOn3tEajOW+nV/aMzc=;
        b=CZ/q8Ujs4jdURVgFR1jo2CsoO+4QxDlw2TcL5tRLyd2y1fACA7k/pQlKnkhZkNbS/s
         +mNjZEvZSz9UESXsEaOw+a8kypI5rEsBo1RmCdFR/InDaKWvx3yn9Ursj+w//dB603uc
         XUsEmE5Y2cwl64ihDZMTQtcWgU54AuJEVuYzJcASjScqJVGmnuTDcF68LrHRA27qdUTP
         ZtzgCa+GfNEjItENlXIdT1hZ1G6ipLYkTL/g1qK2HqK1wNlUNgmqFkDrxXCLsw2ghACa
         stA3AuiK5lyfyUaidEHtpUFuref2+jtnO7l6fCg9wIth4QanniaR0LCPa/f6tsaxTuUb
         HBCg==
X-Gm-Message-State: AOAM53369CZD1RjJxygfu+Cfv54he2ChHWn4llFbzrGMFT5miqsHVmsf
        qg116ve9H9K8Jim55PeGdj4XahSACMEWkE2fNHk=
X-Google-Smtp-Source: ABdhPJx1CwhqOE5ClJsf0hgFc4NTm8TPKBstmb2pivRomM+64kEcQavUr6/CftSyVG4bXfnXZBgh7mmmtHPVhyoGbiY=
X-Received: by 2002:a9d:6b13:: with SMTP id g19mr27064079otp.185.1618300367191;
 Tue, 13 Apr 2021 00:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <1618298169-3831-2-git-send-email-wanpengli@tencent.com> <81112cec-72fa-dd8c-21c8-b24f51021f43@de.ibm.com>
 <CANRm+CwNxcKPKdV4Bxr-5sWJtg_SKZEN5atGJKRyLcVnWVSKSg@mail.gmail.com> <4551632e-5584-29f6-68dd-d85fa968858b@de.ibm.com>
In-Reply-To: <4551632e-5584-29f6-68dd-d85fa968858b@de.ibm.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 13 Apr 2021 15:52:35 +0800
Message-ID: <CANRm+Cw=7kKztPFHaXrK926ve7pY3NN4O22t_QaevHnCXqX5tg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] context_tracking: Split guest_enter/exit_irqoff
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 at 15:48, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 13.04.21 09:38, Wanpeng Li wrote:
> > On Tue, 13 Apr 2021 at 15:35, Christian Borntraeger
> > <borntraeger@de.ibm.com> wrote:
> >>
> >>
> >>
> >> On 13.04.21 09:16, Wanpeng Li wrote:
> >> [...]
> >>
> >>> @@ -145,6 +155,13 @@ static __always_inline void guest_exit_irqoff(void)
> >>>    }
> >>>
> >>>    #else
> THis is the else part
>
>
> >>> +static __always_inline void context_guest_enter_irqoff(void)
> >>> +{
> >>> +     instrumentation_begin();
>
> 2nd on
> >>> +     rcu_virt_note_context_switch(smp_processor_id());
> >>> +     instrumentation_end();
> 2nd off
> >>> +}
> >>> +
> >>>    static __always_inline void guest_enter_irqoff(void)
> >>>    {
> >>>        /*
> >>> @@ -155,10 +172,13 @@ static __always_inline void guest_enter_irqoff(void)
> >>>        instrumentation_begin();
>
> first on
> >>>        vtime_account_kernel(current);
> >>>        current->flags |= PF_VCPU;
> >>> -     rcu_virt_note_context_switch(smp_processor_id());
> >>>        instrumentation_end();
>
> first off
> >>> +
> >>> +     context_guest_enter_irqoff();
> here we call the 2nd on and off.
> >>
> >> So we now do instrumentation_begin 2 times?
> >
> > Similar to context_guest_enter_irqoff() ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN.
>
> For the
> ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN part
> context_guest_enter_irqoff()
> does not have instrumentation_begin/end.
>
> Or did I miss anything.

I mean the if (!context_tracking_enabled_this_cpu()) part in the
function context_guest_enter_irqoff() ifdef
CONFIG_VIRT_CPU_ACCOUNTING_GEN. :)

    Wanpeng
