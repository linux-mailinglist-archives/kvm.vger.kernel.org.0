Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3C3D87B3
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 08:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhG1GMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 02:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhG1GMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 02:12:37 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00251C061757
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 23:12:34 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id z3so1598568ile.12
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 23:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c53hsG8GEpSG06OUOceJPWB/ScZfz6JpWinXcUaw2oo=;
        b=bIuwafch4kiSIS+Q3fKctcGPdRLTUEzayYwy98ULR4MAezBNv0NdQgpsGVDdtrnflB
         +ZXK5cwDiLUhsFzpu4hvvtzrPx+Ik7CBaI+pTlr9jed/vzbRzVMjGOkFlVhH9ooy2C1v
         Nx4SexpnYsB8sI+0skTO+MnQkABzifvJFVaJWmIbYEF3q5DuR3YcQw1xTOIUcmO2tzwc
         QC8bNdPOgNHPlUeqdG4Sg5bkTtmkdOE5xdZ1ZpHrZo+DPeEj8pDBbCN4GR7wCoVaYKSt
         /vkClgjJ63VetJYB3iDm6wNc8c/KvH9eS74NElBOA3HjKOhde9LoYc/SMqAipKDhTEv7
         MUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c53hsG8GEpSG06OUOceJPWB/ScZfz6JpWinXcUaw2oo=;
        b=kY1Xq2VBC139RzC4CkCGjtSjldOsZ+8QFG/SMjc+R5I4dCc0hYFHos4YktGbGhX8B1
         MPxGgn6j52ctcymELbn9jL01LUurDDXbsWASyPqyil8KX2jGXunaeuxs5NYBAXDOn5cH
         4A79sfMw1/aY5uWYJLgDslwi9tZKmU9IIcfjMQeNQAYsN6tOuScUxYEq/XI4mLMqGlDj
         7v69qiEfEckfqaCxW7oxMkIvGixqtz7rodb6izrU4sry1mIGd1EEib0NNs39Mhil9HE8
         z4jmbenBh2hf4MWbdAnrEdvZHEMpK5X06gbxF7NF+hC3mvWH7IfMcN9sLP1vALUdWuR5
         ZRpA==
X-Gm-Message-State: AOAM533RWhDsiuhvd5eInpcNqG9ypeKPaDpjAMva0D3G6YMi1ffDoagA
        LSxOI93KRh/Lu1ByzQo1khgfOrOQwyB9g3aEDRk=
X-Google-Smtp-Source: ABdhPJybFv1ydcbur8ENOFBNe1ODRied5mOXgmsVVHcF4d77n+/77gJXvdOjDgOxJXYMP0uqVivL0KHCeQ0VGbekNBw=
X-Received: by 2002:a92:b50d:: with SMTP id f13mr19507716ile.253.1627452754407;
 Tue, 27 Jul 2021 23:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210727111247.55510-1-lirongqing@baidu.com> <CAM9Jb+hWS5=Oib-NuKWTL=sfg=BQ-usdRV-H-mj6hLFVF6NYnQ@mail.gmail.com>
 <fe516f0a191d4c6e9fbd10b380c87f19@baidu.com>
In-Reply-To: <fe516f0a191d4c6e9fbd10b380c87f19@baidu.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 28 Jul 2021 08:12:23 +0200
Message-ID: <CAM9Jb+iuhexGnwhp_zNCWBLO5dGainBUitObyTDRubjV_nq-HA@mail.gmail.com>
Subject: Re: [PATCH][v2] KVM: use cpu_relax when halt polling
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'
> > > "Rather than disallowing halt-polling entirely, on x86 it should be
> > > sufficient to simply have the hardware thread yield to its sibling(s)
> > > via PAUSE.  It probably won't get back all performance, but I would
> > > expect it to be close.
> > > This compiles on all KVM architectures, and AFAICT the intended usage
> > > of cpu_relax() is identical for all architectures."
> >
> > For sure change to cpu_relax() is better.
> > Was just curious to know if you got descent performance improvement
> > compared to previously reported with Unixbench.
> >
> > Thanks,
> > Pankaj
>
> The test as below:
>
> 1. run unixbench dhry2reg:  ./Run -c 1 dhry2reg -i 1
> without SMT disturbance, the score is 3172
> with a  {while(1)i++} SMT disturbance,  the score is 1583
> with a  {while(1)(rep nop/pause)} SMT disturbance,  the score is 1729.4
>
> seems cpu_relax can not get back all performance , what wrong?

Maybe because of pause intercept filtering, comparatively Mayless VM Exits?

>
>
> 2. back to haltpoll
> run unixbench dhry2reg ./Run -c 1 dhry2reg -i 1
> without SMT disturbance, the score is 3172
>
> with redis-benchmark SMT disturbance, redis-benchmark takes 90%cpu:
> without patch, the score is 1776.9
> with my first patch, the score is 1782.3
> with cpu_relax patch, the score is 1778
>
> with redis-benchmark SMT disturbance, redis-benchmark takes 33%cpu:
> without patch, the score is 1929.9
> with my first patch, the score is 2294.6
> with cpu_relax patch, the score is 2005.3
>
>
> cpu_relax give less than stop halt polling, but it should have little effect for redis-benchmark which get benefit from halt polling

We are seeing improvement with cpu_relax() though not to the level of
stopping the halt polling when sibling
CPU running redis workload. For 90% case I think its expected to have
similar performance.

For 33% stopping halt poll gives better result because of the
workload. Overall I think this patch helps and not impact
performance in normal cases.

Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>

Best regards,
Pankaj


>
>
> -Li
>
> > >
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > ---
> > > diff v1: using cpu_relax, rather that stop halt-polling
> > >
> > >  virt/kvm/kvm_main.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > > 7d95126..1679728 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3110,6 +3110,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> > >
> > ++vcpu->stat.generic.halt_poll_invalid;
> > >                                 goto out;
> > >                         }
> > > +                       cpu_relax();
> > >                         poll_end = cur = ktime_get();
> > >                 } while (kvm_vcpu_can_poll(cur, stop));
> > >         }
> > > --
> > > 2.9.4
> > >
