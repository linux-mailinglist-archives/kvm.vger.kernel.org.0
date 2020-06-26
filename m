Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1962020AF10
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 11:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgFZJdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 05:33:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725280AbgFZJdq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 05:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593164024;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=JwInyFqPNq+XPB0DyOjAdFbK431fsG1hPSaA2tOyD8Y=;
        b=HaqNEuhIoO5K7mvWqyWxf+gBPF4h8vcJ4SKEA6azjsO8xroP4xacYLR+TLAMZDUo56OgIa
        KrKHSBCw1fekvY4XUMl4fPa6oFek3dunG7k6vt72CHKXxpgJtxSGpGXLa+56RN/r6DnsYo
        mZljUHDt8UDFaxim63HtiSyT9NsBntY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-WIhMDPZHNTSGNwJ0sarg7g-1; Fri, 26 Jun 2020 05:33:15 -0400
X-MC-Unique: WIhMDPZHNTSGNwJ0sarg7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD159193F561;
        Fri, 26 Jun 2020 09:33:13 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61D6B1011396;
        Fri, 26 Jun 2020 09:33:00 +0000 (UTC)
Date:   Fri, 26 Jun 2020 10:32:57 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        brijesh.singh@amd.com, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, mst@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
        dgilbert@redhat.com, pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, pbonzini@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200626093257.GC1028934@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200619114526.6a6f70c6.cohuck@redhat.com>
 <79890826-f67c-2228-e98d-25d2168be3da@redhat.com>
 <20200619120530.256c36cb.cohuck@redhat.com>
 <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
 <20200622140254.0dbe5d8c.cohuck@redhat.com>
 <20200625052518.GD172395@umbus.fritz.box>
 <025fb54b-60b7-a58b-e3d7-1bbaad152c5c@redhat.com>
 <20200626044259.GK172395@umbus.fritz.box>
 <892533f8-cd3c-e282-58c2-4212eb3a84b8@redhat.com>
 <a3c05575-6fb2-8d1b-f6d9-2eabf3f4082d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3c05575-6fb2-8d1b-f6d9-2eabf3f4082d@linux.ibm.com>
User-Agent: Mutt/1.14.0 (2020-05-02)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 26, 2020 at 11:01:58AM +0200, Janosch Frank wrote:
> On 6/26/20 8:53 AM, David Hildenbrand wrote:
> >>>>> Does this have any implications when probing with the 'none' machine?
> >>>>
> >>>> I'm not sure.  In your case, I guess the cpu bit would still show up
> >>>> as before, so it would tell you base feature availability, but not
> >>>> whether you can use the new configuration option.
> >>>>
> >>>> Since the HTL option is generic, you could still set it on the "none"
> >>>> machine, though it wouldn't really have any effect.  That is, if you
> >>>> could create a suitable object to point it at, which would depend on
> >>>> ... details.
> >>>>
> >>>
> >>> The important point is that we never want the (expanded) host cpu model
> >>> look different when either specifying or not specifying the HTL
> >>> property.
> >>
> >> Ah, yes, I see your point.  So my current suggestion will satisfy
> >> that, basically it is:
> >>
> >> cpu has unpack (inc. by default) && htl specified
> >> 	=> works (allowing secure), as expected
> > 
> > ack
> > 
> >>
> >> !cpu has unpack && htl specified
> >> 	=> bails out with an error
> > 
> > ack
> > 
> >>
> >> !cpu has unpack && !htl specified
> >> 	=> works for a non-secure guest, as expected
> >> 	=> guest will fail if it attempts to go secure
> > 
> > ack, behavior just like running on older hw without unpack
> > 
> >>
> >> cpu has unpack && !htl specified
> >> 	=> works as expected for a non-secure guest (unpack feature is
> >> 	   present, but unused)
> >> 	=> secure guest may work "by accident", but only if all virtio
> >> 	   properties have the right values, which is the user's
> >> 	   problem
> >>
> >> That last case is kinda ugly, but I think it's tolerable.
> > 
> > Right, we must not affect non-secure guests, and existing secure setups
> > (e.g., older qemu machines). Will have to think about this some more,
> > but does not sound too crazy.
> 
> I severely dislike having to specify things to make PV work.
> The IOMMU is already a thorn in our side and we're working on making the
> whole ordeal completely transparent so the only requirement to make this
> work is the right machine, kernel, qemu and kernel cmd line option
> "prot_virt=1". That's why we do the reboot into PV mode in the first place.
> 
> I.e. the goal is that if customers convert compatible guests into
> protected ones and start them up on a z15 on a distro with PV support
> they can just use the guest without having to change XML or command line
> parameters.

If you're exposing new features to the guest machine, then it is usually
to be expected that XML and QEMU command line will change. Some simple
things might be hidable behind a new QEMU machine type or CPU model, but
there's a limit to how much should be hidden that way while staying sane.

I'd really expect the configuration to change when switching a guest to
a new hardware platform and wanting major new functionality to be enabled.
The XML / QEMU config is a low level instantiation of a particular feature
set, optimized for a specific machine, rather than a high level description
of ideal "best" config independent of host machine.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

