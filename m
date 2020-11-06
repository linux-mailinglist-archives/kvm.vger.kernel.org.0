Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FD32A8D60
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 04:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgKFDMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 22:12:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbgKFDMR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 22:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604632335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mv+dLynp8wUq7v3ImjOM3aGT1sa91HyGF6RRHk9k3M0=;
        b=LEuWal1Yuqj61X+ScmEMcIBbVRo2Mj8Rqt/I+6JBVdHcG6wLw3Wc9y7e9uFulukL0SZHGx
        LZy1cSND9GMUQzFZeXdewVfYKmXXZVAL6QPffsK+JY1ZzdHjLjEY0/jmpPLZGMPHx7bRLB
        0+0XDIxOdsA5vyc78/894zPF5dRkJaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-Pf1tyOvTPw2ub-3Qr7YOZQ-1; Thu, 05 Nov 2020 22:12:13 -0500
X-MC-Unique: Pf1tyOvTPw2ub-3Qr7YOZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 539EE107B467;
        Fri,  6 Nov 2020 03:12:12 +0000 (UTC)
Received: from x1.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 877FA1C924;
        Fri,  6 Nov 2020 03:12:08 +0000 (UTC)
Date:   Thu, 5 Nov 2020 20:12:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
Message-ID: <20201105201208.5366d71e@x1.home>
In-Reply-To: <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
        <20201105060257.35269-2-vikas.gupta@broadcom.com>
        <20201105000806.1df16656@x1.home>
        <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Nov 2020 08:24:26 +0530
Vikas Gupta <vikas.gupta@broadcom.com> wrote:

> Hi Alex,
> 
> On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Thu,  5 Nov 2020 11:32:55 +0530
> > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> >  
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 2f313a238a8f..aab051e8338d 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -203,6 +203,7 @@ struct vfio_device_info {
> > >  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
> > >  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc device */
> > >  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info supports caps */
> > > +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device supports msi */
> > >       __u32   num_regions;    /* Max region index + 1 */
> > >       __u32   num_irqs;       /* Max IRQ index + 1 */
> > >       __u32   cap_offset;     /* Offset within info struct of first cap */  
> >
> > This doesn't make any sense to me, MSIs are just edge triggered
> > interrupts to userspace, so why isn't this fully described via
> > VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe it,
> > this seems incomplete, which indexes are MSI (IRQ_INFO can describe
> > that)?  We also already support MSI with vfio-pci, so a global flag for
> > the device advertising this still seems wrong.  Thanks,
> >
> > Alex
> >  
> Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
> cannot be described using indexes.

That would be news for vfio-pci which has been describing MSIs with
sub-indexes within indexes since vfio started.

> In the patch set there is no difference between MSI and normal
> interrupt for VFIO_DEVICE_GET_IRQ_INFO.

Then what exactly is a global device flag indicating?  Does it indicate
all IRQs are MSI?

> The patch set adds MSI(s), say as an extension, to the normal
> interrupts and handled accordingly.

So we have both "normal" IRQs and MSIs?  How does the user know which
indexes are which?

> Do you see this is a violation? If

Seems pretty unclear and dubious use of a global device flag.

> yes, then we`ll think of other possible ways to support MSI for the
> platform devices.
> Macro VFIO_DEVICE_FLAGS_MSI can be changed to any other name if it
> collides with an already supported vfio-pci or if not necessary, we
> can remove this flag.

If nothing else you're using a global flag to describe a platform
device specific augmentation.  We've recently added capabilities on the
device info return that would be more appropriate for this, but
fundamentally I don't understand why the irq info isn't sufficient.
Thanks,

Alex

