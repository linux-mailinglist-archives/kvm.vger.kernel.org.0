Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442A11859C7
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgCODkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:40:51 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37486 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgCODkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:40:51 -0400
Received: by mail-qk1-f193.google.com with SMTP id z25so15299879qkj.4;
        Sat, 14 Mar 2020 20:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWfNlXspNXP/Z3scX2GkjvDWCTPuiHmONTso2D85LQ0=;
        b=sGtaPxoOYlnTE5+b5zUoJ5Qn4z0EdmGqcfdkyzpvc+A+oNj2ctggTsHy7R5k5KZaSS
         bJmMY5PSsrpz4laFSZ4Cvu1/UjYJvYiDHDndj8EmjUyw16JFuCWraRfLM2fLieGE1rw/
         t4GXZD+7QD+JKa0naTB5pkynZPCLuLQGIggS7Itm3YqeYqhRene0PWAK7SwTR5eN9yQl
         +vJlMoXeZ6j0Q6fHxZXu9BH5N9pQBpt0VboKIs4enjv3glrDqAwo24UUnZ50iNeQXMLS
         LYpw3WcitaT3FUhFNW5aVWy/LP1RCkHJmHHxiXiFyS60KPOk0PPhc36PkRXhY7LOVeLY
         VzFA==
X-Gm-Message-State: ANhLgQ3XMB+dMlygbKdQ6riMKlTY/fWvpG4+Pa5qXNxz0mSZPa0BgrSc
        UYxcEye81dVp7IqW0xfZETMUf2fnx688Aje0f6bitg==
X-Google-Smtp-Source: ADFU+vt9NbYnSnppxGI7xOTmGfRR3RSs/QZOhkMGUVuMhiPSyyT3vdhguRYt/HjQ0hyrQs/pQ8sEHfBxb3po2QAZY0w=
X-Received: by 2002:a9d:1d07:: with SMTP id m7mr6029839otm.167.1584182450168;
 Sat, 14 Mar 2020 03:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200304113248.1143057-1-mail@maciej.szmigiero.name>
 <20200312161751.GA5245@fuller.cnet> <CAJZ5v0jLOKj5LN5Kmredixomer4BKdBPNwP7gOf7A0tS_WMbDQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0jLOKj5LN5Kmredixomer4BKdBPNwP7gOf7A0tS_WMbDQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sat, 14 Mar 2020 11:40:38 +0100
Message-ID: <CAJZ5v0gSLR+K2698rwbv0j9-sbSNX98HUFDQfTHoom+gYtHrdw@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle-haltpoll: allow force loading on hosts without
 the REALTIME hint
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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

On Fri, Mar 13, 2020 at 6:49 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Thu, Mar 12, 2020 at 5:36 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Wed, Mar 04, 2020 at 12:32:48PM +0100, Maciej S. Szmigiero wrote:
> > > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > >
> > > Before commit 1328edca4a14 ("cpuidle-haltpoll: Enable kvm guest polling
> > > when dedicated physical CPUs are available") the cpuidle-haltpoll driver
> > > could also be used in scenarios when the host does not advertise the
> > > KVM_HINTS_REALTIME hint.
> > >
> > > While the behavior introduced by the aforementioned commit makes sense as
> > > the default there are cases where the old behavior is desired, for example,
> > > when other kernel changes triggered by presence by this hint are unwanted,
> > > for some workloads where the latency benefit from polling overweights the
> > > loss from idle CPU capacity that otherwise would be available, or just when
> > > running under older Qemu versions that lack this hint.
> > >
> > > Let's provide a typical "force" module parameter that allows restoring the
> > > old behavior.
> > >
> > > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > > ---
> > >  drivers/cpuidle/cpuidle-haltpoll.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > >
> > > Changes from v1:
> > > Make the module parameter description more general, don't unnecessarily
> > > break a line in haltpoll_init().
> > >
> > > diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> > > index b0ce9bc78113..db124bc1ca2c 100644
> > > --- a/drivers/cpuidle/cpuidle-haltpoll.c
> > > +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> > > @@ -18,6 +18,10 @@
> > >  #include <linux/kvm_para.h>
> > >  #include <linux/cpuidle_haltpoll.h>
> > >
> > > +static bool force __read_mostly;
> > > +module_param(force, bool, 0444);
> > > +MODULE_PARM_DESC(force, "Load unconditionally");
> > > +
> > >  static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
> > >  static enum cpuhp_state haltpoll_hp_state;
> > >
> > > @@ -90,6 +94,11 @@ static void haltpoll_uninit(void)
> > >       haltpoll_cpuidle_devices = NULL;
> > >  }
> > >
> > > +static bool haltpool_want(void)
> > > +{
> > > +     return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> > > +}
> > > +
> > >  static int __init haltpoll_init(void)
> > >  {
> > >       int ret;
> > > @@ -101,8 +110,7 @@ static int __init haltpoll_init(void)
> > >
> > >       cpuidle_poll_state_init(drv);
> > >
> > > -     if (!kvm_para_available() ||
> > > -             !kvm_para_has_hint(KVM_HINTS_REALTIME))
> > > +     if (!kvm_para_available() || !haltpool_want())
> > >               return -ENODEV;
> > >
> > >       ret = cpuidle_register_driver(drv);
> >
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
> I'm taking this as a Reviewed-by, thanks!

Patch applied as 5.7 material, thanks!
