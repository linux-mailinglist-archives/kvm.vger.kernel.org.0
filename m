Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900F431316E
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhBHLxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:53:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233375AbhBHLvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 06:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612784998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oi034L7GURgKX+CmvdadFZkkujMPL28p498WwGYQ9QM=;
        b=Ee2zYhadvNHTWXpZ01I5ygelLdoqs7xN7X6EN2cWwhephxTnLk4UmcVS37hcASsugyBcLP
        xPK57SoUDHaTFWDEdvQdgNDIJCAhQm6hywPIe6h0P3pGrUY7OutQcOdJW9pv5/gw90pHrq
        3ikVProgFfT0lMYiky8R8fuhxLFt1rw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-T0kN16coPLuJRiLCOFLzMw-1; Mon, 08 Feb 2021 06:49:56 -0500
X-MC-Unique: T0kN16coPLuJRiLCOFLzMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34DAD801986;
        Mon,  8 Feb 2021 11:49:55 +0000 (UTC)
Received: from gondolin (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7E4E608DB;
        Mon,  8 Feb 2021 11:49:50 +0000 (UTC)
Date:   Mon, 8 Feb 2021 12:49:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for
 KVM_SET_IOREGION
Message-ID: <20210208124948.6e769151.cohuck@redhat.com>
In-Reply-To: <85cdd5d96b227ba64d333bff112c7900b6f14dea.camel@gmail.com>
References: <cover.1611850290.git.eafanasova@gmail.com>
        <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
        <20210204140329.5f3a49ca.cohuck@redhat.com>
        <85cdd5d96b227ba64d333bff112c7900b6f14dea.camel@gmail.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 05 Feb 2021 10:39:33 -0800
Elena Afanasova <eafanasova@gmail.com> wrote:

> On Thu, 2021-02-04 at 14:03 +0100, Cornelia Huck wrote:
> > On Fri, 29 Jan 2021 21:48:26 +0300
> > Elena Afanasova <eafanasova@gmail.com> wrote:

> > > @@ -1308,6 +1330,7 @@ struct kvm_vfio_spapr_tce {
> > >  					struct
> > > kvm_userspace_memory_region)
> > >  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> > >  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > > +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct
> > > kvm_ioregion)  
> > 
> > This new ioctl needs some documentation under
> > Documentation/virt/kvm/api.rst. (That would also make review easier.)
> >   
> Agreed. The latest version of the ioregionfd API can be found in 
> https://marc.info/?l=kvm&m=160633710708172&w=2. There are still some
> open questions like write coalescing support.  So I think API may still
> be changed during code reviews.

Understood.

> 
> > >  
> > >  /* enable ucontrol for s390 */
> > >  struct kvm_s390_ucas_mapping {  
> > 
> > (...)
> >   
> > > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > > index c2323c27a28b..aadb73903f8b 100644
> > > --- a/virt/kvm/eventfd.c
> > > +++ b/virt/kvm/eventfd.c
> > > @@ -27,6 +27,7 @@
> > >  #include <trace/events/kvm.h>
> > >  
> > >  #include <kvm/iodev.h>
> > > +#include "ioregion.h"
> > >  
> > >  #ifdef CONFIG_HAVE_KVM_IRQFD
> > >  
> > > @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops
> > > ioeventfd_ops = {
> > >  	.destructor = ioeventfd_destructor,
> > >  };
> > >  
> > > +#ifdef CONFIG_KVM_IOREGION
> > > +/* assumes kvm->slots_lock held */
> > > +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> > > +			  u64 start, u64 size)
> > > +{
> > > +	struct _ioeventfd *_p;
> > > +
> > > +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> > > +		if (_p->bus_idx == bus_idx &&
> > > +		    overlap(start, size, _p->addr,
> > > +			    !_p->length ? 8 : _p->length))  
> > 
> > Not a problem right now, as this is x86 only, but I'm not sure we can
> > define "overlap" in a meaningful way for every bus_idx. (For example,
> > the s390-only ccw notifications use addr to identify a device; as
> > long
> > as addr is unique, there will be no clash. I'm not sure yet if
> > ioregions are usable for ccw devices, and if yes, in which form, but
> > we
> > should probably keep it in mind.)
> >   
> Thank you for pointing it out. Yes, CCW bus seems to be a special case.

In any case, it needs some special care if we want to include it later,
maybe by introducing a bus-specific collision check. As long as we're
just dealing with pio/mmio, I think the function can stay this way.

