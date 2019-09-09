Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BA7AD57B
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 11:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfIIJPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 05:15:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42241 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfIIJPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 05:15:18 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so26975382iod.9
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 02:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AlAmFnU61j5SkSETlKd6vi6hw0mSXTTteBRkQOeckEA=;
        b=lA9PbGzyNXR0pwphYGjECZ2ghLwPmZ/JjyTDcurH/WhPU+Nu3CCIAFB1yHU3AeIo3u
         jGJkkkxZYJSrSf7OI8wnyAyAgzGZsr3Kb33dH4V2Keg1txHLvSQk87Xnd97tbDZK3Kli
         oqeSJ73AWLuTrhpfklL54esvoy203AiCRZnkInR7lkA0di74t53x1hCsw5Nq8N7aMCmS
         K/n3ui+9Zb0G5Kwn64m1geL7+/x30BQXgtTGRqNlsoeBXgvLWMhR+MKMKA1LqHXnmmdZ
         nHEPYekDJVr3IKiQFT8L0cCKrgMblGo/UhCiSHPUHsMco00mM5QM3RmKlcbCQ86JmmbP
         OS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AlAmFnU61j5SkSETlKd6vi6hw0mSXTTteBRkQOeckEA=;
        b=XrhJMXej+1RFbLdfX/kIPZ5JzmWdYr9WRQuWjT7YkZ9aTyJ428uHSF0UFmXXGDA+W0
         Ft2jw0i6WVrCW6XVtdurfnTQ7D5UnHRCH20532U5v4V69dFGIYWBHfeCzXp2sUSHgWOd
         BKuJTXQ6zcm3Mvi7qUnccOceoQDU1U8vl9ZZA3/3KwzTXNd/+0QFjLGL1W0NtY0uoyd3
         0LA3tFWF5qEzLDIkHgBOsKVCybdb8U+PabQ7bc1TysH0HHJQMmehCgFyescW3gAJ1mu2
         VHblmvYXmMFTtpgbztRAnagnHEr1ITH90/CK4U/MMLxTKGeBa1f+79z1Q8qXvMf+pCcO
         ToQg==
X-Gm-Message-State: APjAAAWAfTYc2d9k5SUHzLJ5IVNqK45oRa6n0baDGxC9u9KfnaNl/Fce
        e9FcVYIPUZCR5MAsaq43dlBdh3zddDn9BCtcMzQ=
X-Google-Smtp-Source: APXvYqwRQhBO9ceaFa5Nok9oBAhUweVhuXRUiz85Qck1zm5k2xco5KMibYM18WAQsk7muc+2xrY8bUn/sx+qPTmViEI=
X-Received: by 2002:a5e:8815:: with SMTP id l21mr22021032ioj.196.1568020517393;
 Mon, 09 Sep 2019 02:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <1567756159-512600-1-git-send-email-wrfsh@yandex-team.ru> <20190906162726.GC29496@linux.intel.com>
In-Reply-To: <20190906162726.GC29496@linux.intel.com>
From:   Evgeny Yakovlev <eyakovlev3@gmail.com>
Date:   Mon, 9 Sep 2019 12:15:06 +0300
Message-ID: <CAEu0wD1imJcWo2_Q4X+OYBkspoFx155GbRaCkV0OD7-tR00GRg@mail.gmail.com>
Subject: Re: [kvm-unit-tests RESEND PATCH] x86: Fix id_map buffer overflow and
 PT corruption
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        yc-core@yandex-team.ru, wrfsh@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 6, 2019 at 7:27 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 06, 2019 at 10:49:19AM +0300, Evgeny Yakovlev wrote:
> > Commit 18a34cce introduced init_apic_map. It iterates over
> > sizeof(online_cpus) * 8 items and sets APIC ids in id_map.
> > However, online_cpus is defined (in x86/cstart[64].S) as a 64-bit
> > variable. After i >= 64, init_apic_map begins to read out of bounds of
> > online_cpus. If it finds a non-zero value there enough times,
> > it then proceeds to potentially overflow id_map in assignment.
> >
> > In our test case id_map was linked close to pg_base. As a result page
> > table was corrupted and we've seen sporadic failures of ioapic test.
> >
> > Signed-off-by: Evgeny Yakovlev <wrfsh@yandex-team.ru>
> > ---
> >  lib/x86/apic.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> > index 504299e..1ed8bab 100644
> > --- a/lib/x86/apic.c
> > +++ b/lib/x86/apic.c
> > @@ -228,14 +228,17 @@ void mask_pic_interrupts(void)
> >      outb(0xff, 0xa1);
> >  }
> >
> > -extern unsigned char online_cpus[256 / 8];
>
> The immediate issue can be resolved simply by fixing this definition.
>
> > +/* Should hold MAX_TEST_CPUS bits */
> > +extern uint64_t online_cpus;
> >
> >  void init_apic_map(void)
> >  {
> >       unsigned int i, j = 0;
> >
> > -     for (i = 0; i < sizeof(online_cpus) * 8; i++) {
> > -             if ((1ul << (i % 8)) & (online_cpus[i / 8]))
> > +     assert(MAX_TEST_CPUS <= sizeof(online_cpus) * 8);
> > +
> > +     for (i = 0; i < MAX_TEST_CPUS; i++) {
> > +             if (online_cpus & ((uint64_t)1 << i))
>
> This is functionally correct, but it's just as easy to have online_cpus
> sized based on MAX_TEST_CPUS, i.e. to allow MAX_TEST_CPUS to be changed
> at will (within reason).  I'll send patches.
>
> >                       id_map[j++] = i;
> >       }
> >  }
> > --
> > 2.7.4
> >

Yeah, you can fix this declaration here as well, using MAX_TEST_CPUS.
I just don't like the definition (which is in x86/start64.S) to be
different from this declaration here. I think it is confusing.
And since actual definition does not use MAX_TEST_CPUS as well, i
think it is also quite fragile.
