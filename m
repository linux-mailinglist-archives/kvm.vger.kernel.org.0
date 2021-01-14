Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41972F607B
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbhANLrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:47:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbhANLrT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 06:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610624752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/v3H4Y1dgMiWDMdKL4Cn+sCUriko+UGoLRQTZJENYkU=;
        b=MLo9eJU4yubqa4yhqWu3k6kYL7zefyi3Xv0OMAWVyUU38NAPhQ0x7+Y3MctYrEt/AuFmZg
        K/1J/QVukIPzB6gqiC45vYedr5YHFje2/xFIRrXgRp0hbevLqwW9i8V2Fuh5Yk+0lROPqD
        dS9kjbThKz1o2/SR7eru3O+DxQcKXMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-FzKYKq9oPHK-pP_fkGxNxA-1; Thu, 14 Jan 2021 06:45:48 -0500
X-MC-Unique: FzKYKq9oPHK-pP_fkGxNxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B489915722;
        Thu, 14 Jan 2021 11:45:46 +0000 (UTC)
Received: from work-vm (ovpn-115-29.ams2.redhat.com [10.36.115.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AEBB10016F4;
        Thu, 14 Jan 2021 11:45:36 +0000 (UTC)
Date:   Thu, 14 Jan 2021 11:45:33 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, Greg Kurz <groug@kaod.org>,
        pair@us.ibm.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>, thuth@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, rth@twiddle.net, berrange@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        pbonzini@redhat.com
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210114114533.GF2905@work-vm>
References: <20210104134629.49997b53.pasic@linux.ibm.com>
 <20210104184026.GD4102@ram-ibm-com.ibm.com>
 <20210105115614.7daaadd6.pasic@linux.ibm.com>
 <20210105204125.GE4102@ram-ibm-com.ibm.com>
 <20210111175914.13adfa2e.cohuck@redhat.com>
 <20210113124226.GH2938@work-vm>
 <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
 <20210114103643.GD2905@work-vm>
 <db2295ce-333f-2a3e-8219-bfa4853b256f@de.ibm.com>
 <20210114120531.3c7f350e.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114120531.3c7f350e.cohuck@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Cornelia Huck (cohuck@redhat.com) wrote:
> On Thu, 14 Jan 2021 11:52:11 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > On 14.01.21 11:36, Dr. David Alan Gilbert wrote:
> > > * Christian Borntraeger (borntraeger@de.ibm.com) wrote:  
> > >>
> > >>
> > >> On 13.01.21 13:42, Dr. David Alan Gilbert wrote:  
> > >>> * Cornelia Huck (cohuck@redhat.com) wrote:  
> > >>>> On Tue, 5 Jan 2021 12:41:25 -0800
> > >>>> Ram Pai <linuxram@us.ibm.com> wrote:
> > >>>>  
> > >>>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:  
> > >>>>>> On Mon, 4 Jan 2021 10:40:26 -0800
> > >>>>>> Ram Pai <linuxram@us.ibm.com> wrote:  
> > >>>>  
> > >>>>>>> The main difference between my proposal and the other proposal is...
> > >>>>>>>
> > >>>>>>>   In my proposal the guest makes the compatibility decision and acts
> > >>>>>>>   accordingly.  In the other proposal QEMU makes the compatibility
> > >>>>>>>   decision and acts accordingly. I argue that QEMU cannot make a good
> > >>>>>>>   compatibility decision, because it wont know in advance, if the guest
> > >>>>>>>   will or will-not switch-to-secure.
> > >>>>>>>     
> > >>>>>>
> > >>>>>> You have a point there when you say that QEMU does not know in advance,
> > >>>>>> if the guest will or will-not switch-to-secure. I made that argument
> > >>>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
> > >>>>>> was to flip that property on demand when the conversion occurs. David
> > >>>>>> explained to me that this is not possible for ppc, and that having the
> > >>>>>> "securable-guest-memory" property (or whatever the name will be)
> > >>>>>> specified is a strong indication, that the VM is intended to be used as
> > >>>>>> a secure VM (thus it is OK to hurt the case where the guest does not
> > >>>>>> try to transition). That argument applies here as well.    
> > >>>>>
> > >>>>> As suggested by Cornelia Huck, what if QEMU disabled the
> > >>>>> "securable-guest-memory" property if 'must-support-migrate' is enabled?
> > >>>>> Offcourse; this has to be done with a big fat warning stating
> > >>>>> "secure-guest-memory" feature is disabled on the machine.
> > >>>>> Doing so, will continue to support guest that do not try to transition.
> > >>>>> Guest that try to transition will fail and terminate themselves.  
> > >>>>
> > >>>> Just to recap the s390x situation:
> > >>>>
> > >>>> - We currently offer a cpu feature that indicates secure execution to
> > >>>>   be available to the guest if the host supports it.
> > >>>> - When we introduce the secure object, we still need to support
> > >>>>   previous configurations and continue to offer the cpu feature, even
> > >>>>   if the secure object is not specified.
> > >>>> - As migration is currently not supported for secured guests, we add a
> > >>>>   blocker once the guest actually transitions. That means that
> > >>>>   transition fails if --only-migratable was specified on the command
> > >>>>   line. (Guests not transitioning will obviously not notice anything.)
> > >>>> - With the secure object, we will already fail starting QEMU if
> > >>>>   --only-migratable was specified.
> > >>>>
> > >>>> My suggestion is now that we don't even offer the cpu feature if
> > >>>> --only-migratable has been specified. For a guest that does not want to
> > >>>> transition to secure mode, nothing changes; a guest that wants to
> > >>>> transition to secure mode will notice that the feature is not available
> > >>>> and fail appropriately (or ultimately, when the ultravisor call fails).
> > >>>> We'd still fail starting QEMU for the secure object + --only-migratable
> > >>>> combination.
> > >>>>
> > >>>> Does that make sense?  
> > >>>
> > >>> It's a little unusual; I don't think we have any other cases where
> > >>> --only-migratable changes the behaviour; I think it normally only stops
> > >>> you doing something that would have made it unmigratable or causes
> > >>> an operation that would make it unmigratable to fail.  
> > >>
> > >> I would like to NOT block this feature with --only-migrateable. A guest
> > >> can startup unprotected (and then is is migrateable). the migration blocker
> > >> is really a dynamic aspect during runtime.   
> > > 
> > > But the point of --only-migratable is to turn things that would have
> > > blocked migration into failures, so that a VM started with
> > > --only-migratable is *always* migratable.  
> > 
> > Hmmm, fair enough. How do we do this with host-model? The constructed model
> > would contain unpack, but then it will fail to startup? Or do we silently 
> > drop unpack in that case? Both variants do not feel completely right. 
> 
> Failing if you explicitly specified unpacked feels right, but failing
> if you just used the host model feels odd. Removing unpack also is a
> bit odd, but I think the better option if we want to do anything about
> it at all.

'host-model' feels a bit special; but breaking the rule that
only-migratable doesn't change behaviour is weird.
Can you do host,-unpack   to make that work explicitly?

But hang on; why is 'unpack' the name of a secure guest facility - is
it really a feature for secure guest or something else?

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

