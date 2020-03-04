Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C791178E73
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 11:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbgCDKbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 05:31:35 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:44817 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCDKbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 05:31:34 -0500
Received: from 79.184.237.41.ipv4.supernova.orange.pl (79.184.237.41) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.341)
 id f2ea0c19e76830b0; Wed, 4 Mar 2020 11:31:32 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] cpuidle-haltpoll: allow force loading on hosts without the REALTIME hint
Date:   Wed, 04 Mar 2020 11:31:31 +0100
Message-ID: <2118832.28snYOIflM@kreacher>
In-Reply-To: <75d483b5-8edf-efb1-9642-ca367e2f1423@maciej.szmigiero.name>
References: <20200221174331.1480468-1-mail@maciej.szmigiero.name> <75d483b5-8edf-efb1-9642-ca367e2f1423@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, February 28, 2020 6:10:18 PM CET Maciej S. Szmigiero wrote:
> A friendly ping here.
> 
> Maciej
> 
> On 21.02.2020 18:43, Maciej S. Szmigiero wrote:
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
> >  drivers/cpuidle/cpuidle-haltpoll.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> > index b0ce9bc78113..07e5b36076bb 100644
> > --- a/drivers/cpuidle/cpuidle-haltpoll.c
> > +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> > @@ -18,6 +18,11 @@
> >  #include <linux/kvm_para.h>
> >  #include <linux/cpuidle_haltpoll.h>
> >  
> > +static bool force __read_mostly;
> > +module_param(force, bool, 0444);
> > +MODULE_PARM_DESC(force,
> > +		 "Load even if the host does not provide the REALTIME hint");

Why not to say "Load unconditionally" here?

As is, one needs to know what "the REALTIME hint" is to understand it.

> > +
> >  static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
> >  static enum cpuhp_state haltpoll_hp_state;
> >  
> > @@ -90,6 +95,11 @@ static void haltpoll_uninit(void)
> >  	haltpoll_cpuidle_devices = NULL;
> >  }
> >  
> > +static bool haltpool_want(void)
> > +{
> > +	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> > +}
> > +
> >  static int __init haltpoll_init(void)
> >  {
> >  	int ret;
> > @@ -102,7 +112,7 @@ static int __init haltpoll_init(void)
> >  	cpuidle_poll_state_init(drv);
> >  
> >  	if (!kvm_para_available() ||
> > -		!kvm_para_has_hint(KVM_HINTS_REALTIME))
> > +	    !haltpool_want())

And you don't need to break this line.

> >  		return -ENODEV;
> >  
> >  	ret = cpuidle_register_driver(drv);
> > 
> 
> 

Thanks!



