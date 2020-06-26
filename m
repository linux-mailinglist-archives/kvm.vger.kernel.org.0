Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404E820AFB1
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 12:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgFZK3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 06:29:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41862 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgFZK3V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 06:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593167359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBx707CdmAgay4vce399hRXkN2PbyvoFrb5PW9jYTBg=;
        b=cBOkzCB3S+zthtaSxth/vBAnADMoBd0a8WPd3VVPv6o9Q6p3TXP/80q84GsDP9lknGIIeL
        N5DiIotNNjy98J7uNKToUbwMuTZWZ9wOQZvi1CV1/Cf0B7VHPFaAqlCV8cgrEzsQnYGUTJ
        UhAqFfzOcoceKH5BEzZu31xEUk3fHSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-pTBMeto0P223TqazOVy8sA-1; Fri, 26 Jun 2020 06:29:17 -0400
X-MC-Unique: pTBMeto0P223TqazOVy8sA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2810B804003;
        Fri, 26 Jun 2020 10:29:15 +0000 (UTC)
Received: from work-vm (ovpn-113-27.ams2.redhat.com [10.36.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C585210023A2;
        Fri, 26 Jun 2020 10:29:05 +0000 (UTC)
Date:   Fri, 26 Jun 2020 11:29:03 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        brijesh.singh@amd.com, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, mst@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
        pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, pbonzini@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200626102903.GD3087@work-vm>
References: <20200619120530.256c36cb.cohuck@redhat.com>
 <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
 <20200622140254.0dbe5d8c.cohuck@redhat.com>
 <20200625052518.GD172395@umbus.fritz.box>
 <025fb54b-60b7-a58b-e3d7-1bbaad152c5c@redhat.com>
 <20200626044259.GK172395@umbus.fritz.box>
 <892533f8-cd3c-e282-58c2-4212eb3a84b8@redhat.com>
 <a3c05575-6fb2-8d1b-f6d9-2eabf3f4082d@linux.ibm.com>
 <20200626093257.GC1028934@redhat.com>
 <558e8978-01ba-d8e8-9986-15efbbcbca96@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <558e8978-01ba-d8e8-9986-15efbbcbca96@linux.ibm.com>
User-Agent: Mutt/1.14.3 (2020-06-14)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Janosch Frank (frankja@linux.ibm.com) wrote:
> On 6/26/20 11:32 AM, Daniel P. Berrangé wrote:
> > On Fri, Jun 26, 2020 at 11:01:58AM +0200, Janosch Frank wrote:
> >> On 6/26/20 8:53 AM, David Hildenbrand wrote:
> >>>>>>> Does this have any implications when probing with the 'none' machine?
> >>>>>>
> >>>>>> I'm not sure.  In your case, I guess the cpu bit would still show up
> >>>>>> as before, so it would tell you base feature availability, but not
> >>>>>> whether you can use the new configuration option.
> >>>>>>
> >>>>>> Since the HTL option is generic, you could still set it on the "none"
> >>>>>> machine, though it wouldn't really have any effect.  That is, if you
> >>>>>> could create a suitable object to point it at, which would depend on
> >>>>>> ... details.
> >>>>>>
> >>>>>
> >>>>> The important point is that we never want the (expanded) host cpu model
> >>>>> look different when either specifying or not specifying the HTL
> >>>>> property.
> >>>>
> >>>> Ah, yes, I see your point.  So my current suggestion will satisfy
> >>>> that, basically it is:
> >>>>
> >>>> cpu has unpack (inc. by default) && htl specified
> >>>> 	=> works (allowing secure), as expected
> >>>
> >>> ack
> >>>
> >>>>
> >>>> !cpu has unpack && htl specified
> >>>> 	=> bails out with an error
> >>>
> >>> ack
> >>>
> >>>>
> >>>> !cpu has unpack && !htl specified
> >>>> 	=> works for a non-secure guest, as expected
> >>>> 	=> guest will fail if it attempts to go secure
> >>>
> >>> ack, behavior just like running on older hw without unpack
> >>>
> >>>>
> >>>> cpu has unpack && !htl specified
> >>>> 	=> works as expected for a non-secure guest (unpack feature is
> >>>> 	   present, but unused)
> >>>> 	=> secure guest may work "by accident", but only if all virtio
> >>>> 	   properties have the right values, which is the user's
> >>>> 	   problem
> >>>>
> >>>> That last case is kinda ugly, but I think it's tolerable.
> >>>
> >>> Right, we must not affect non-secure guests, and existing secure setups
> >>> (e.g., older qemu machines). Will have to think about this some more,
> >>> but does not sound too crazy.
> >>
> >> I severely dislike having to specify things to make PV work.
> >> The IOMMU is already a thorn in our side and we're working on making the
> >> whole ordeal completely transparent so the only requirement to make this
> >> work is the right machine, kernel, qemu and kernel cmd line option
> >> "prot_virt=1". That's why we do the reboot into PV mode in the first place.
> >>
> >> I.e. the goal is that if customers convert compatible guests into
> >> protected ones and start them up on a z15 on a distro with PV support
> >> they can just use the guest without having to change XML or command line
> >> parameters.
> > 
> > If you're exposing new features to the guest machine, then it is usually
> > to be expected that XML and QEMU command line will change. Some simple
> > things might be hidable behind a new QEMU machine type or CPU model, but
> > there's a limit to how much should be hidden that way while staying sane.
> > 
> > I'd really expect the configuration to change when switching a guest to
> > a new hardware platform and wanting major new functionality to be enabled.
> > The XML / QEMU config is a low level instantiation of a particular feature
> > set, optimized for a specific machine, rather than a high level description
> > of ideal "best" config independent of host machine.
> 
> You still have to set the host command line and make sure that unpack is
> available. Currently you also have to specify the IOMMU which we like to
> drop as a requirement. Everything else is dependent on runtime
> information which tells us if we need to take a PV or non-PV branch.
> Having the unpack facility should be enough to use the unpack facility.
> 
> Keep in mind that we have no real concept of a special protected VM to
> begin with. If the VM never boots into a protected kernel it will never
> be protected. On a reboot it drops from protected into unprotected mode
> to execute the bios and boot loader and then may or may not move back
> into a protected state.

My worry isn't actually how painful adding all the iommu glue is, but
what happens when users forget; especially if they forget for one
device.

I could appreciate having a machine option to cause iommu to then get
turned on with all other devices; but I think also we could do with
something that failed with a nice error if an iommu flag was missing.
For SEV this could be done pretty early, but for power/s390 I guess
you'd have to do this when someone tried to enable secure mode, but
I'm not sure you can tell.

Dave


> > 
> > Regards,
> > Daniel
> > 
> 
> 



--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

