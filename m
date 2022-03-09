Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD0B4D27B3
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 05:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiCIBiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 20:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiCIBiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 20:38:01 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE10BABB9;
        Tue,  8 Mar 2022 17:37:01 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g1so1371090ybe.4;
        Tue, 08 Mar 2022 17:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O0sfGtZZs/DCXFYwja5rvdRYEUrfDeT/e0HTIIylfkg=;
        b=l4rVX7J5aBaez9SIxbPd0e7Jjd3gHLMAN0Wc6zzGVSMOeK42ZvHs4Bc6lPiS3ZUbcP
         UGfCmxnSojCAZ7N33msSaTo1U/B3GcMw/aU5OW1WbFaHZV4Kfqz8d5pj05HQ6p1mlBKy
         pP18JcugAEvOPH3EYM6mjWtlQlZQUiR/CY9JQLvd5d5h/vE916blcoH3puN20a64FRTo
         moYha8UiaO0SM4KXzK+aIJQtJ6e4dm+iQTFrrPDmBI5c+Aai4QH42R3nEqYGo7JjxQp1
         dt1vhyW91fdU0yaxlC5qTRgj9jwdMqXPjqcyheLeIWhTRaLL2dnFYqm6ZjyElb2KEfg+
         0mVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O0sfGtZZs/DCXFYwja5rvdRYEUrfDeT/e0HTIIylfkg=;
        b=vq00slQHt/ogoQgrtUVrJgQEwUeyyEua9Ptk51LhGQbi3l2vyknoaPTyw7xUadJ170
         t+MgdyknYSbi91Bz2Nv10q/7gCu7gZGsy4aT+NSmOz+aCPz/ya8fePaTJbi6aEJOwEBv
         4NP+K6kEA6/BXiRrVb203i7GlSYS9qo8B/Ba3uV8AFISZCQdmLsPvgAh3stOQs+tPypy
         mpub7g+1fyl8SE4Ahz17RrAIJ/FG+rcTuki97wmpucxsekNbm7vv1U8W0Wn3YfP2cYc3
         fZVTUM4AcHXUZBqog5fKmSguSGawKQamEwabFQ4QjcCNsTJTzXOwbIHTWMpg37GMU1Gl
         FMxA==
X-Gm-Message-State: AOAM531lcvJqSseyAE3TJtAca5m63iUz0QBG+5H4h42B4DUB4Iigxa9W
        MJp6ypD+jUsyA6CuMzkMo1xvAn9EvP6g5eTy1xo=
X-Google-Smtp-Source: ABdhPJxMIyvION8ePOZdB98YZI9JKX8ZRb3j37BxlHfi1wJE3Bb7ujT/4fdLL51UsvBXV+Elqab/qhiDOZQARSNnIps=
X-Received: by 2002:a25:1b45:0:b0:628:833c:f3af with SMTP id
 b66-20020a251b45000000b00628833cf3afmr14352135ybb.138.1646789821221; Tue, 08
 Mar 2022 17:37:01 -0800 (PST)
MIME-Version: 1.0
References: <1646727529-11774-1-git-send-email-wanpengli@tencent.com> <6e57aad6-1322-8a3d-6dfa-ff010a61a9a9@redhat.com>
In-Reply-To: <6e57aad6-1322-8a3d-6dfa-ff010a61a9a9@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Mar 2022 09:36:50 +0800
Message-ID: <CANRm+Cw9m81HQN-kFYSiaoXOaaJHEQS77D-wwVv=hzmkOLpZ7g@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Don't waste kvmclock memory if there is nopv parameter
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Mar 2022 at 20:13, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/8/22 09:18, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > When the "nopv" command line parameter is used, it should not waste
> > memory for kvmclock.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >   arch/x86/kernel/kvmclock.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index c5caa73..16333ba 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -239,7 +239,7 @@ static void __init kvmclock_init_mem(void)
> >
> >   static int __init kvm_setup_vsyscall_timeinfo(void)
> >   {
> > -     if (!kvm_para_available() || !kvmclock)
> > +     if (!kvm_para_available() || !kvmclock || nopv)
> >               return 0;
> >
> >       kvmclock_init_mem();
>
> Perhaps instead !kvm_para_available() && nopv should clear the kvmclock
> variable?

Do you mean if (!kvm_para_available() && nopv) return 0? I
misunderstand why they are the same. :)

    Wanpeng
