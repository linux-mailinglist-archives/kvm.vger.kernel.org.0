Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0932017C687
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCFTwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 14:52:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726083AbgCFTwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 14:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583524335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wshUEfGJ0oCbRrCm+psHycgVdvMv8N6eiO1mp9WFHQ=;
        b=K0J4Fj875O1K8xDURpjSaDB+NNNWgB35W5dA+RRKec/DZjhiJAeLRvMbc8hHcCqGaXJqrn
        fvgYKGbNUeGMecJmbGzQQVYAeLg3tN5Mw2QJUnnpvYVOVczo8Kn/lZEqurR8pCNUoCfOg6
        GnmQwijqUGUa9CvKaPL9l7MddGY/UD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-ZbozAVvCPia2fE25-rWBtQ-1; Fri, 06 Mar 2020 14:52:13 -0500
X-MC-Unique: ZbozAVvCPia2fE25-rWBtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2F7F800053;
        Fri,  6 Mar 2020 19:52:11 +0000 (UTC)
Received: from fuller.cnet (ovpn-116-16.gru2.redhat.com [10.97.116.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6295B10027AB;
        Fri,  6 Mar 2020 19:52:11 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 2562842FE410; Fri,  6 Mar 2020 06:56:17 -0300 (-03)
Date:   Fri, 6 Mar 2020 06:56:17 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] cpuidle-haltpoll: allow force loading on hosts without
 the REALTIME hint
Message-ID: <20200306095617.GD32190@fuller.cnet>
References: <20200221174331.1480468-1-mail@maciej.szmigiero.name>
 <114f7b8d-6f88-222a-d1fa-abcfc0e6a1f2@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <114f7b8d-6f88-222a-d1fa-abcfc0e6a1f2@maciej.szmigiero.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 09:10:18PM +0100, Maciej S. Szmigiero wrote:
> (CC'ing also Marcelo as the cpuidle-haltpoll driver author and the KVM ML).

Hi Maciej,

> On 21.02.2020 18:43, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > 
> > Before commit 1328edca4a14 ("cpuidle-haltpoll: Enable kvm guest polling
> > when dedicated physical CPUs are available") the cpuidle-haltpoll driver
> > could also be used in scenarios when the host does not advertise the
> > KVM_HINTS_REALTIME hint.
> > 
> > While the behavior introduced by the aforementioned commit makes sense as
> > the default 

It makes sense for the pCPU overcommitted case only.

> > there are cases where the old behavior is desired, for example,
> > when other kernel changes triggered by presence by this hint are unwanted,
> > for some workloads where the latency benefit from polling overweights the
> > loss from idle CPU capacity that otherwise would be available, or just when
> > running under older Qemu versions that lack this hint.
> > 
> > Let's provide a typical "force" module parameter that allows restoring the
> > old behavior.
> > 
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

I would rather: 

1) Switch back to the default non-overcommitted case.

or even better (but requires more investment)

2) Make on the flight dynamic configuration (after all pCPU
overcommitment=true/false is a property that changes during
the day, depending on system load).

But its up to Paolo to decide, really.

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
> >  		return -ENODEV;
> >  
> >  	ret = cpuidle_register_driver(drv);
> > 

