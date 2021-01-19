Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2262FB3F0
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbhASIWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 03:22:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728690AbhASIV7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 03:21:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611044431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FVk+dgxlEVOpaEFM6NUNwLFA1530NxzYd7Gc5WzY9pU=;
        b=XUm8SxOSa5qi7Lc/wsrjKXOe4WPdE8SOTd2KXTGF/PMRIgkM852dkfoUXfqDvYRteSDl3t
        5p1vTNcS9UraDlGCvhqITlXHDvwfYmk2boGJUGR/1i/Q18SfMM5Mwg43gS6JlPHZdg0Kpn
        kTMekA+wpKCfWvtQQIAW1+jdYvTuXOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-fX8BVZnnMW27Ck-fLdrujQ-1; Tue, 19 Jan 2021 03:20:27 -0500
X-MC-Unique: fX8BVZnnMW27Ck-fLdrujQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C52C8BAF85;
        Tue, 19 Jan 2021 08:19:58 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8B676062F;
        Tue, 19 Jan 2021 08:19:53 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:19:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Greg Kurz <groug@kaod.org>,
        pair@us.ibm.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        thuth@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        dgilbert@redhat.com, qemu-s390x@nongnu.org, rth@twiddle.net,
        berrange@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-ppc@nongnu.org, pbonzini@redhat.com
Subject: Re:  Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210119091950.4a27a615.cohuck@redhat.com>
In-Reply-To: <20210115185514.GB24076@ram-ibm-com.ibm.com>
References: <20210104071550.GA22585@ram-ibm-com.ibm.com>
        <20210104134629.49997b53.pasic@linux.ibm.com>
        <20210104184026.GD4102@ram-ibm-com.ibm.com>
        <20210105115614.7daaadd6.pasic@linux.ibm.com>
        <20210105204125.GE4102@ram-ibm-com.ibm.com>
        <20210111175914.13adfa2e.cohuck@redhat.com>
        <20210111195830.GA23898@ram-ibm-com.ibm.com>
        <20210112091943.095c3b29.cohuck@redhat.com>
        <20210112185511.GB23898@ram-ibm-com.ibm.com>
        <20210113090629.2f41a9d3.cohuck@redhat.com>
        <20210115185514.GB24076@ram-ibm-com.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Jan 2021 10:55:14 -0800
Ram Pai <linuxram@us.ibm.com> wrote:

> On Wed, Jan 13, 2021 at 09:06:29AM +0100, Cornelia Huck wrote:
> > On Tue, 12 Jan 2021 10:55:11 -0800
> > Ram Pai <linuxram@us.ibm.com> wrote:
> >   
> > > On Tue, Jan 12, 2021 at 09:19:43AM +0100, Cornelia Huck wrote:  
> > > > On Mon, 11 Jan 2021 11:58:30 -0800
> > > > Ram Pai <linuxram@us.ibm.com> wrote:
> > > >     
> > > > > On Mon, Jan 11, 2021 at 05:59:14PM +0100, Cornelia Huck wrote:    
> > > > > > On Tue, 5 Jan 2021 12:41:25 -0800
> > > > > > Ram Pai <linuxram@us.ibm.com> wrote:
> > > > > >       
> > > > > > > On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:      
> > > > > > > > On Mon, 4 Jan 2021 10:40:26 -0800
> > > > > > > > Ram Pai <linuxram@us.ibm.com> wrote:      
> > > > > >       
> > > > > > > > > The main difference between my proposal and the other proposal is...
> > > > > > > > > 
> > > > > > > > >   In my proposal the guest makes the compatibility decision and acts
> > > > > > > > >   accordingly.  In the other proposal QEMU makes the compatibility
> > > > > > > > >   decision and acts accordingly. I argue that QEMU cannot make a good
> > > > > > > > >   compatibility decision, because it wont know in advance, if the guest
> > > > > > > > >   will or will-not switch-to-secure.
> > > > > > > > >         
> > > > > > > > 
> > > > > > > > You have a point there when you say that QEMU does not know in advance,
> > > > > > > > if the guest will or will-not switch-to-secure. I made that argument
> > > > > > > > regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
> > > > > > > > was to flip that property on demand when the conversion occurs. David
> > > > > > > > explained to me that this is not possible for ppc, and that having the
> > > > > > > > "securable-guest-memory" property (or whatever the name will be)
> > > > > > > > specified is a strong indication, that the VM is intended to be used as
> > > > > > > > a secure VM (thus it is OK to hurt the case where the guest does not
> > > > > > > > try to transition). That argument applies here as well.        
> > > > > > > 
> > > > > > > As suggested by Cornelia Huck, what if QEMU disabled the
> > > > > > > "securable-guest-memory" property if 'must-support-migrate' is enabled?
> > > > > > > Offcourse; this has to be done with a big fat warning stating
> > > > > > > "secure-guest-memory" feature is disabled on the machine.
> > > > > > > Doing so, will continue to support guest that do not try to transition.
> > > > > > > Guest that try to transition will fail and terminate themselves.      
> > > > > > 
> > > > > > Just to recap the s390x situation:
> > > > > > 
> > > > > > - We currently offer a cpu feature that indicates secure execution to
> > > > > >   be available to the guest if the host supports it.
> > > > > > - When we introduce the secure object, we still need to support
> > > > > >   previous configurations and continue to offer the cpu feature, even
> > > > > >   if the secure object is not specified.
> > > > > > - As migration is currently not supported for secured guests, we add a
> > > > > >   blocker once the guest actually transitions. That means that
> > > > > >   transition fails if --only-migratable was specified on the command
> > > > > >   line. (Guests not transitioning will obviously not notice anything.)
> > > > > > - With the secure object, we will already fail starting QEMU if
> > > > > >   --only-migratable was specified.
> > > > > > 
> > > > > > My suggestion is now that we don't even offer the cpu feature if
> > > > > > --only-migratable has been specified. For a guest that does not want to
> > > > > > transition to secure mode, nothing changes; a guest that wants to
> > > > > > transition to secure mode will notice that the feature is not available
> > > > > > and fail appropriately (or ultimately, when the ultravisor call fails).      
> > > > > 
> > > > > 
> > > > > On POWER, secure-execution is not **automatically** enabled even when
> > > > > the host supports it.  The feature is enabled only if the secure-object
> > > > > is configured, and the host supports it.    
> > > > 
> > > > Yes, the cpu feature on s390x is simply pre-existing.
> > > >     
> > > > > 
> > > > > However the behavior proposed above will be consistent on POWER and
> > > > > on s390x,  when '--only-migratable' is specified and 'secure-object'
> > > > > is NOT specified.
> > > > > 
> > > > > So I am in agreement till now. 
> > > > > 
> > > > >     
> > > > > > We'd still fail starting QEMU for the secure object + --only-migratable
> > > > > > combination.      
> > > > > 
> > > > > Why fail? 
> > > > > 
> > > > > Instead, print a warning and  disable the secure-object; which will
> > > > > disable your cpu-feature. Guests that do not transition to secure, will
> > > > > continue to operate, and guests that transition to secure, will fail.    
> > > > 
> > > > But that would be consistent with how other non-migratable objects are
> > > > handled, no? It's simply a case of incompatible options on the command
> > > > line.    
> > > 
> > > Actually the two options are inherently NOT incompatible.  Halil also
> > > mentioned this in one of his replies.
> > > 
> > > Its just that the current implementation is lacking, which will be fixed
> > > in the near future. 
> > > 
> > > We can design it upfront, with the assumption that they both are compatible.
> > > In the short term  disable one; preferrably the secure-object, if both 
> > > options are specified. In the long term, remove the restriction, when
> > > the implemetation is complete.  
> > 
> > Can't we simply mark the object as non-migratable now, and then remove
> > that later? I don't see what is so special about it.  
> 
> This is fine too. 
> 
> However I am told that libvirt has some assumptions, where it assumes
> that the VM is guaranteed to be migratable if '--only-migratable' is
> specified. Silently turning off that option can be bad.
> 

I meant "later" as in "when support for live migration has been added".
Mucking around with the options does not sound like a good idea.

