Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8A180439
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCJRCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:02:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727206AbgCJRCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 13:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583859728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s059DjlnEcczveYufFN5KML3mixHomqVeP5rihntnzg=;
        b=ZGrHpdN8j7gWr7oIcn1lefMV7GJ7jq2wf361IMF4fwgFRn3k76DY66OweP/W88yWrk+RPm
        DwbL83d4JjlEcY0SOYftdbPHAf7Qv8vIlobqVN52cS3JAPQqnfHfLw4Lusp0KsgomBeopv
        /mpbhOvdHmSn0PflZbjfxtGhAzU+/Gg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-4GdUry3_MQmA2UOKZTRSrg-1; Tue, 10 Mar 2020 13:02:02 -0400
X-MC-Unique: 4GdUry3_MQmA2UOKZTRSrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B929E1937FC1;
        Tue, 10 Mar 2020 17:02:00 +0000 (UTC)
Received: from fuller.cnet (ovpn-116-43.gru2.redhat.com [10.97.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E37E75D9CA;
        Tue, 10 Mar 2020 17:01:59 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8C1FE42FE412; Tue, 10 Mar 2020 10:50:06 -0300 (-03)
Date:   Tue, 10 Mar 2020 10:50:06 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] cpuidle-haltpoll: allow force loading on hosts without
 the REALTIME hint
Message-ID: <20200310135006.GA6397@fuller.cnet>
References: <20200221174331.1480468-1-mail@maciej.szmigiero.name>
 <75d483b5-8edf-efb1-9642-ca367e2f1423@maciej.szmigiero.name>
 <2118832.28snYOIflM@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2118832.28snYOIflM@kreacher>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 11:31:31AM +0100, Rafael J. Wysocki wrote:
> On Friday, February 28, 2020 6:10:18 PM CET Maciej S. Szmigiero wrote:
> > A friendly ping here.
> > 
> > Maciej
> > 
> > On 21.02.2020 18:43, Maciej S. Szmigiero wrote:
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
> > >  drivers/cpuidle/cpuidle-haltpoll.c | 12 +++++++++++-
> > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> > > index b0ce9bc78113..07e5b36076bb 100644
> > > --- a/drivers/cpuidle/cpuidle-haltpoll.c
> > > +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> > > @@ -18,6 +18,11 @@
> > >  #include <linux/kvm_para.h>
> > >  #include <linux/cpuidle_haltpoll.h>
> > >  
> > > +static bool force __read_mostly;
> > > +module_param(force, bool, 0444);
> > > +MODULE_PARM_DESC(force,
> > > +		 "Load even if the host does not provide the REALTIME hint");
> 
> Why not to say "Load unconditionally" here?

Makes sense to me.

> As is, one needs to know what "the REALTIME hint" is to understand it.
> 
> > > +
> > >  static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
> > >  static enum cpuhp_state haltpoll_hp_state;
> > >  
> > > @@ -90,6 +95,11 @@ static void haltpoll_uninit(void)
> > >  	haltpoll_cpuidle_devices = NULL;
> > >  }
> > >  
> > > +static bool haltpool_want(void)
> > > +{
> > > +	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> > > +}
> > > +
> > >  static int __init haltpoll_init(void)
> > >  {
> > >  	int ret;
> > > @@ -102,7 +112,7 @@ static int __init haltpoll_init(void)
> > >  	cpuidle_poll_state_init(drv);
> > >  
> > >  	if (!kvm_para_available() ||
> > > -		!kvm_para_has_hint(KVM_HINTS_REALTIME))
> > > +	    !haltpool_want())
> 
> And you don't need to break this line.
> 
> > >  		return -ENODEV;
> > >  
> > >  	ret = cpuidle_register_driver(drv);
> > > 
> > 
> > 
> 
> Thanks!
> 
> 

