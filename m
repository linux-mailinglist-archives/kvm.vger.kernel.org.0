Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9142E184DF2
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCMRt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 13:49:58 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36186 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgCMRt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 13:49:57 -0400
Received: by mail-ot1-f66.google.com with SMTP id j14so11021780otq.3;
        Fri, 13 Mar 2020 10:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ikJY8jL+WwN9m0h/0ly8EPxlXvIn8mr2TN/3Ad+1Sjw=;
        b=so5fYZSoCwaFwWyqYnzVHGf7R/BRTOLM0pxs/dR3qdTZ6zLyvss4/5eIoDD+FTJNin
         9y0AnkjYIoZb+chMW7BbRXnVfr9Z2ca1NP30yrHHAtbTXAgk9dNOoKzW63lQc4yeI5WQ
         zSs7Pmgq8NoKeneJPe1rSMv9j3oImG4Z/lEskFJpRChMmb3oqZ1GU+JAYFnzcKcwtoq5
         bjkQSt6g/nZyyDEVnDx9C1XDmcQOJJqYHWFXFOuUArR5xWPIcMi5egEvCD//IVrH/EbG
         9UqcLjpK63Q173FzarBGGR1Hs2ZpqkNqILmCMN9BjIUbeh0nQi+CxyIlJi5VYwVJSgRH
         lSsw==
X-Gm-Message-State: ANhLgQ0XrmWrh2NkhUjAVUv6E7z5iHQBiAjaHHK1bJT15f9AMOsts64G
        Ecb1pmiAlwj5u/ricw7X6Blh/tDVIUyi6Cmi09U=
X-Google-Smtp-Source: ADFU+vscUcNl0XqoPtGNKufJ6d5QVPnoK1rJaGUBAwvppGXXEvwIKjNWZWqU+cwx4LdvkSpguWD67ibiRm73DRPkOAE=
X-Received: by 2002:a9d:67d7:: with SMTP id c23mr12349631otn.262.1584121796924;
 Fri, 13 Mar 2020 10:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200304113248.1143057-1-mail@maciej.szmigiero.name> <20200312161751.GA5245@fuller.cnet>
In-Reply-To: <20200312161751.GA5245@fuller.cnet>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 13 Mar 2020 18:49:45 +0100
Message-ID: <CAJZ5v0jLOKj5LN5Kmredixomer4BKdBPNwP7gOf7A0tS_WMbDQ@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle-haltpoll: allow force loading on hosts without
 the REALTIME hint
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 12, 2020 at 5:36 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Wed, Mar 04, 2020 at 12:32:48PM +0100, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> >
> > Before commit 1328edca4a14 ("cpuidle-haltpoll: Enable kvm guest polling
> > when dedicated physical CPUs are available") the cpuidle-haltpoll driver
> > could also be used in scenarios when the host does not advertise the
> > KVM_HINTS_REALTIME hint.
> >
> > While the behavior introduced by the aforementioned commit makes sense as
> > the default there are cases where the old behavior is desired, for example,
> > when other kernel changes triggered by presence by this hint are unwanted,
> > for some workloads where the latency benefit from polling overweights the
> > loss from idle CPU capacity that otherwise would be available, or just when
> > running under older Qemu versions that lack this hint.
> >
> > Let's provide a typical "force" module parameter that allows restoring the
> > old behavior.
> >
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > ---
> >  drivers/cpuidle/cpuidle-haltpoll.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > Changes from v1:
> > Make the module parameter description more general, don't unnecessarily
> > break a line in haltpoll_init().
> >
> > diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> > index b0ce9bc78113..db124bc1ca2c 100644
> > --- a/drivers/cpuidle/cpuidle-haltpoll.c
> > +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> > @@ -18,6 +18,10 @@
> >  #include <linux/kvm_para.h>
> >  #include <linux/cpuidle_haltpoll.h>
> >
> > +static bool force __read_mostly;
> > +module_param(force, bool, 0444);
> > +MODULE_PARM_DESC(force, "Load unconditionally");
> > +
> >  static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
> >  static enum cpuhp_state haltpoll_hp_state;
> >
> > @@ -90,6 +94,11 @@ static void haltpoll_uninit(void)
> >       haltpoll_cpuidle_devices = NULL;
> >  }
> >
> > +static bool haltpool_want(void)
> > +{
> > +     return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> > +}
> > +
> >  static int __init haltpoll_init(void)
> >  {
> >       int ret;
> > @@ -101,8 +110,7 @@ static int __init haltpoll_init(void)
> >
> >       cpuidle_poll_state_init(drv);
> >
> > -     if (!kvm_para_available() ||
> > -             !kvm_para_has_hint(KVM_HINTS_REALTIME))
> > +     if (!kvm_para_available() || !haltpool_want())
> >               return -ENODEV;
> >
> >       ret = cpuidle_register_driver(drv);
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

I'm taking this as a Reviewed-by, thanks!
