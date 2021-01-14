Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB72F62E9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 15:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbhANORZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 09:17:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726244AbhANORY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 09:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610633757;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TcTwBcIclivUrNjEotPay4dduGvbIasDHp0fZI+G4HQ=;
        b=NBWpDROsZr6Q0rQNDsdbHUZhB+H8RdnbegTE9FKQ3Wq3OzLpX0FDblQLBlbcqNvduHd3lt
        ONBELhRcRTqBR6oLteF4CtRtzJnYLyPm+WvUTnM711tmlmSafG0wihsyxqkSW8/ckRJPIs
        gpo21aQYgMKT2LrHzmr4ojPwfpog7og=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-SRsokBvQPcufAsImlpJ3vg-1; Thu, 14 Jan 2021 09:15:52 -0500
X-MC-Unique: SRsokBvQPcufAsImlpJ3vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAD9D1005E40;
        Thu, 14 Jan 2021 14:15:49 +0000 (UTC)
Received: from redhat.com (ovpn-115-77.ams2.redhat.com [10.36.115.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD3F35C1BD;
        Thu, 14 Jan 2021 14:15:38 +0000 (UTC)
Date:   Thu, 14 Jan 2021 14:15:35 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, pair@us.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>, brijesh.singh@amd.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        david@redhat.com, Ram Pai <linuxram@us.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, pbonzini@redhat.com, thuth@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210114141535.GJ1643043@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210113124226.GH2938@work-vm>
 <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
 <20210114103643.GD2905@work-vm>
 <db2295ce-333f-2a3e-8219-bfa4853b256f@de.ibm.com>
 <20210114120531.3c7f350e.cohuck@redhat.com>
 <20210114114533.GF2905@work-vm>
 <b791406c-fde2-89db-4186-e1660f14418c@de.ibm.com>
 <20210114122048.GG1643043@redhat.com>
 <20210114150422.5f74ca41.cohuck@redhat.com>
 <b0084527-97b3-3174-d988-bf0f6d6221fd@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0084527-97b3-3174-d988-bf0f6d6221fd@de.ibm.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 03:09:01PM +0100, Christian Borntraeger wrote:
> 
> 
> On 14.01.21 15:04, Cornelia Huck wrote:
> > On Thu, 14 Jan 2021 12:20:48 +0000
> > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > 
> >> On Thu, Jan 14, 2021 at 12:50:12PM +0100, Christian Borntraeger wrote:
> >>>
> >>>
> >>> On 14.01.21 12:45, Dr. David Alan Gilbert wrote:  
> >>>> * Cornelia Huck (cohuck@redhat.com) wrote:  
> >>>>> On Thu, 14 Jan 2021 11:52:11 +0100
> >>>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >>>>>  
> >>>>>> On 14.01.21 11:36, Dr. David Alan Gilbert wrote:  
> >>>>>>> * Christian Borntraeger (borntraeger@de.ibm.com) wrote:    
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 13.01.21 13:42, Dr. David Alan Gilbert wrote:    
> >>>>>>>>> * Cornelia Huck (cohuck@redhat.com) wrote:    
> >>>>>>>>>> On Tue, 5 Jan 2021 12:41:25 -0800
> >>>>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:
> >>>>>>>>>>    
> >>>>>>>>>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:    
> >>>>>>>>>>>> On Mon, 4 Jan 2021 10:40:26 -0800
> >>>>>>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:    
> >>>>>>>>>>    
> >>>>>>>>>>>>> The main difference between my proposal and the other proposal is...
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>   In my proposal the guest makes the compatibility decision and acts
> >>>>>>>>>>>>>   accordingly.  In the other proposal QEMU makes the compatibility
> >>>>>>>>>>>>>   decision and acts accordingly. I argue that QEMU cannot make a good
> >>>>>>>>>>>>>   compatibility decision, because it wont know in advance, if the guest
> >>>>>>>>>>>>>   will or will-not switch-to-secure.
> >>>>>>>>>>>>>       
> >>>>>>>>>>>>
> >>>>>>>>>>>> You have a point there when you say that QEMU does not know in advance,
> >>>>>>>>>>>> if the guest will or will-not switch-to-secure. I made that argument
> >>>>>>>>>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
> >>>>>>>>>>>> was to flip that property on demand when the conversion occurs. David
> >>>>>>>>>>>> explained to me that this is not possible for ppc, and that having the
> >>>>>>>>>>>> "securable-guest-memory" property (or whatever the name will be)
> >>>>>>>>>>>> specified is a strong indication, that the VM is intended to be used as
> >>>>>>>>>>>> a secure VM (thus it is OK to hurt the case where the guest does not
> >>>>>>>>>>>> try to transition). That argument applies here as well.      
> >>>>>>>>>>>
> >>>>>>>>>>> As suggested by Cornelia Huck, what if QEMU disabled the
> >>>>>>>>>>> "securable-guest-memory" property if 'must-support-migrate' is enabled?
> >>>>>>>>>>> Offcourse; this has to be done with a big fat warning stating
> >>>>>>>>>>> "secure-guest-memory" feature is disabled on the machine.
> >>>>>>>>>>> Doing so, will continue to support guest that do not try to transition.
> >>>>>>>>>>> Guest that try to transition will fail and terminate themselves.    
> >>>>>>>>>>
> >>>>>>>>>> Just to recap the s390x situation:
> >>>>>>>>>>
> >>>>>>>>>> - We currently offer a cpu feature that indicates secure execution to
> >>>>>>>>>>   be available to the guest if the host supports it.
> >>>>>>>>>> - When we introduce the secure object, we still need to support
> >>>>>>>>>>   previous configurations and continue to offer the cpu feature, even
> >>>>>>>>>>   if the secure object is not specified.
> >>>>>>>>>> - As migration is currently not supported for secured guests, we add a
> >>>>>>>>>>   blocker once the guest actually transitions. That means that
> >>>>>>>>>>   transition fails if --only-migratable was specified on the command
> >>>>>>>>>>   line. (Guests not transitioning will obviously not notice anything.)
> >>>>>>>>>> - With the secure object, we will already fail starting QEMU if
> >>>>>>>>>>   --only-migratable was specified.
> >>>>>>>>>>
> >>>>>>>>>> My suggestion is now that we don't even offer the cpu feature if
> >>>>>>>>>> --only-migratable has been specified. For a guest that does not want to
> >>>>>>>>>> transition to secure mode, nothing changes; a guest that wants to
> >>>>>>>>>> transition to secure mode will notice that the feature is not available
> >>>>>>>>>> and fail appropriately (or ultimately, when the ultravisor call fails).
> >>>>>>>>>> We'd still fail starting QEMU for the secure object + --only-migratable
> >>>>>>>>>> combination.
> >>>>>>>>>>
> >>>>>>>>>> Does that make sense?    
> >>>>>>>>>
> >>>>>>>>> It's a little unusual; I don't think we have any other cases where
> >>>>>>>>> --only-migratable changes the behaviour; I think it normally only stops
> >>>>>>>>> you doing something that would have made it unmigratable or causes
> >>>>>>>>> an operation that would make it unmigratable to fail.    
> >>>>>>>>
> >>>>>>>> I would like to NOT block this feature with --only-migrateable. A guest
> >>>>>>>> can startup unprotected (and then is is migrateable). the migration blocker
> >>>>>>>> is really a dynamic aspect during runtime.     
> >>>>>>>
> >>>>>>> But the point of --only-migratable is to turn things that would have
> >>>>>>> blocked migration into failures, so that a VM started with
> >>>>>>> --only-migratable is *always* migratable.    
> >>>>>>
> >>>>>> Hmmm, fair enough. How do we do this with host-model? The constructed model
> >>>>>> would contain unpack, but then it will fail to startup? Or do we silently 
> >>>>>> drop unpack in that case? Both variants do not feel completely right.   
> >>>>>
> >>>>> Failing if you explicitly specified unpacked feels right, but failing
> >>>>> if you just used the host model feels odd. Removing unpack also is a
> >>>>> bit odd, but I think the better option if we want to do anything about
> >>>>> it at all.  
> >>>>
> >>>> 'host-model' feels a bit special; but breaking the rule that
> >>>> only-migratable doesn't change behaviour is weird
> >>>> Can you do host,-unpack   to make that work explicitly?  
> >>>
> >>> I guess that should work. But it means that we need to add logic in libvirt
> >>> to disable unpack for host-passthru and host-model. Next problem is then,
> >>> that a future version might implement migration of such guests, which means
> >>> that libvirt must then stop fencing unpack.  
> >>
> >> The "host-model" is supposed to always be migratable, so we should
> >> fence the feature there.
> >>
> >> host-passthrough is "undefined" whether it is migratable - it may or may
> >> not work, no guarantees made by libvirt.
> >>
> >> Ultimately I think the problem is that there ought to be an explicit
> >> config to enable the feature for s390, as there is for SEV, and will
> >> also presumably be needed for ppc. 
> > 
> > Yes, an explicit config is what we want; unfortunately, we have to deal
> > with existing setups as well...
> > 
> > The options I see are
> > - leave things for existing setups as they are now (i.e. might become
> >   unmigratable when the guest transitions), and make sure we're doing
> >   the right thing with the new object
> > - always make the unpack feature conflict with migration requirements;
> >   this is a guest-visible change
> > 
> > The first option might be less hairy, all considered?
> 
> What about a libvirt change that removes the unpack from the host-model as 
> soon as  only-migrateable is used. When that is in place, QEMU can reject
> the combination of only-migrateable + unpack.

I think libvirt needs to just unconditionally remove unpack from host-model
regardless, and require an explicit opt in. We can do that in libvirt
without compat problems, because we track the expansion of "host-model"
for existing running guests.

QEMU could introduce a deprecation warning right now, and then turn it into
an error after the deprecation cycle is complete.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

