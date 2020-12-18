Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1062DE270
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 13:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgLRMKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 07:10:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbgLRMKW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 07:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608293335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qyhBcJSscLXt03rN/wlqP36IM0VuLCvIcf32trO8ph0=;
        b=XU+q6UnS2CszvKzjmHZwDAebsZ3wKYySz0OUJB3phVEuzRAfzX7dxZyzeYPHnEEr+iW/XQ
        v3F/aoNI9ABRhc+9hohRqMH56fVtJULz44H/LV9L1kwvMyfbCpkIsQhWO3P/qq23sIr/d4
        /3E51m5+HNImvsGjI7PEwzKm9agrNms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-EKwJsLpENtmXHXyBkdaN5w-1; Fri, 18 Dec 2020 07:08:53 -0500
X-MC-Unique: EKwJsLpENtmXHXyBkdaN5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A4A01006C88;
        Fri, 18 Dec 2020 12:08:51 +0000 (UTC)
Received: from work-vm (ovpn-114-200.ams2.redhat.com [10.36.114.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D362260C43;
        Fri, 18 Dec 2020 12:08:38 +0000 (UTC)
Date:   Fri, 18 Dec 2020 12:08:36 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Greg Kurz <groug@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, berrange@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        thuth@redhat.com, pbonzini@redhat.com, rth@twiddle.net,
        mdroth@linux.vnet.ibm.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20201218120836.GA2956@work-vm>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-12-david@gibson.dropbear.id.au>
 <20201214182240.2abd85eb.cohuck@redhat.com>
 <20201217054736.GH310465@yekko.fritz.box>
 <20201217123842.51063918.cohuck@redhat.com>
 <20201217151530.54431f0e@bahia.lan>
 <20201218124111.4957eb50.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218124111.4957eb50.cohuck@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Cornelia Huck (cohuck@redhat.com) wrote:
> On Thu, 17 Dec 2020 15:15:30 +0100
> Greg Kurz <groug@kaod.org> wrote:
> 
> > On Thu, 17 Dec 2020 12:38:42 +0100
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > On Thu, 17 Dec 2020 16:47:36 +1100
> > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > >   
> > > > On Mon, Dec 14, 2020 at 06:22:40PM +0100, Cornelia Huck wrote:  
> > > > > On Fri,  4 Dec 2020 16:44:13 +1100
> > > > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > > > >     
> > > > > > We haven't yet implemented the fairly involved handshaking that will be
> > > > > > needed to migrate PEF protected guests.  For now, just use a migration
> > > > > > blocker so we get a meaningful error if someone attempts this (this is the
> > > > > > same approach used by AMD SEV).
> > > > > > 
> > > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > > > > ---
> > > > > >  hw/ppc/pef.c | 9 +++++++++
> > > > > >  1 file changed, 9 insertions(+)
> > > > > > 
> > > > > > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > > > > > index 3ae3059cfe..edc3e744ba 100644
> > > > > > --- a/hw/ppc/pef.c
> > > > > > +++ b/hw/ppc/pef.c
> > > > > > @@ -38,7 +38,11 @@ struct PefGuestState {
> > > > > >  };
> > > > > >  
> > > > > >  #ifdef CONFIG_KVM
> > > > > > +static Error *pef_mig_blocker;
> > > > > > +
> > > > > >  static int kvmppc_svm_init(Error **errp)    
> > > > > 
> > > > > This looks weird?    
> > > > 
> > > > Oops.  Not sure how that made it past even my rudimentary compile
> > > > testing.
> > > >   
> > > > > > +
> > > > > > +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
> > > > > >  {
> > > > > >      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
> > > > > >          error_setg(errp,
> > > > > > @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
> > > > > >          }
> > > > > >      }
> > > > > >  
> > > > > > +    /* add migration blocker */
> > > > > > +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
> > > > > > +    /* NB: This can fail if --only-migratable is used */
> > > > > > +    migrate_add_blocker(pef_mig_blocker, &error_fatal);    
> > > > > 
> > > > > Just so that I understand: is PEF something that is enabled by the host
> > > > > (and the guest is either secured or doesn't start), or is it using a
> > > > > model like s390x PV where the guest initiates the transition into
> > > > > secured mode?    
> > > > 
> > > > Like s390x PV it's initiated by the guest.
> > > >   
> > > > > Asking because s390x adds the migration blocker only when the
> > > > > transition is actually happening (i.e. guests that do not transition
> > > > > into secure mode remain migratable.) This has the side effect that you
> > > > > might be able to start a machine with --only-migratable that
> > > > > transitions into a non-migratable machine via a guest action, if I'm
> > > > > not mistaken. Without the new object, I don't see a way to block with
> > > > > --only-migratable; with it, we should be able to do that. Not sure what
> > > > > the desirable behaviour is here.    
> > > >   
> > 
> > The purpose of --only-migratable is specifically to prevent the machine
> > to transition to a non-migrate state IIUC. The guest transition to
> > secure mode should be nacked in this case.
> 
> Yes, that's what happens for s390x: The guest tries to transition, QEMU
> can't add a migration blocker and fails the instruction used for
> transitioning, the guest sees the error.
> 
> The drawback is that we see the failure only when we already launched
> the machine and the guest tries to transition. If I start QEMU with
> --only-migratable, it will refuse to start when non-migratable devices
> are configured in the command line, so I see the issue right from the
> start. (For s390x, that would possibly mean that we should not even
> present the cpu feature bit when only_migratable is set?)

I see --only-migratable as refusing to start if you've enabled anything
that would stop migration.
So I'd expect:
  a) Allow the cpu flag to be turned on/off somehow
     
  b) If you ask for it (-cpu ...,_confidentialcomp or whatever) and
you've got --only-migratable then you'd fail before startup.

Dave

> > 
> > > > Hm, I'm not sure what the best option is here either.  
> > > 
> > > If we agree on anything, it should be as consistent across
> > > architectures as possible :)
> > > 
> > > If we want to add the migration blocker to s390x even before the guest
> > > transitions, it needs to be tied to the new object; if we'd make it
> > > dependent on the cpu feature bit, we'd block migration of all machines
> > > on hardware with SE and a recent kernel.
> > > 
> > > Is there a convenient point in time when PEF guests transition where
> > > QEMU can add a blocker?
> > >   
> > > >   
> > > > >     
> > > > > > +
> > > > > >      return 0;
> > > > > >  }
> > > > > >      
> > > > >     
> > > >   
> > >   
> > 
> 


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

