Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A2F30552C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 09:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhA0ICE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 03:02:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S316819AbhAZXUX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 18:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611703104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4OdvhWfvpqKJBMkO76bzbcesHusgnA0tJfh2KQFq/HA=;
        b=jQHIGDYZA8AekEZCNQLOzjDf8IlXoZea4lYlxp1zjtLt0pQbMrrd0Xe1zujDfBPs9s/XXB
        bY+835q3bncXhwZU28VLG36emJ/rMbzuJneygGTdYH1V9AeLBi04ZqjvC64kg+QveNSHvB
        PmoDF3WyJurpz3RKWPjvlE79Lsw+NMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-FgtfIRLvNNC0y9WWvwFm2w-1; Tue, 26 Jan 2021 18:18:20 -0500
X-MC-Unique: FgtfIRLvNNC0y9WWvwFm2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB496107ACE3;
        Tue, 26 Jan 2021 23:18:18 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1338A5D766;
        Tue, 26 Jan 2021 23:18:18 +0000 (UTC)
Date:   Tue, 26 Jan 2021 16:18:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
Message-ID: <20210126161817.683485e0@omen.home.shazbot.org>
In-Reply-To: <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
        <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
        <20210122164843.269f806c@omen.home.shazbot.org>
        <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 09:40:38 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 1/22/21 6:48 PM, Alex Williamson wrote:
> > On Tue, 19 Jan 2021 15:02:30 -0500
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
> >> specific requirements in terms of alignment as well as the patterns in
> >> which the data is read/written. Allowing these to proceed through the
> >> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
> >> way that these requirements can't be guaranteed. In addition, ISM devices
> >> do not support the MIO codepaths that might be triggered on vfio I/O coming
> >> from userspace; we must be able to ensure that these devices use the
> >> non-MIO instructions.  To facilitate this, provide a new vfio region by
> >> which non-MIO instructions can be passed directly to the host kernel s390
> >> PCI layer, to be reliably issued as non-MIO instructions.
> >>
> >> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
> >> and implements the ability to pass PCISTB and PCILG instructions over it,
> >> as these are what is required for ISM devices.  
> > 
> > There have been various discussions about splitting vfio-pci to allow
> > more device specific drivers rather adding duct tape and bailing wire
> > for various device specific features to extend vfio-pci.  The latest
> > iteration is here[1].  Is it possible that such a solution could simply
> > provide the standard BAR region indexes, but with an implementation that
> > works on s390, rather than creating new device specific regions to
> > perform the same task?  Thanks,
> > 
> > Alex
> > 
> > [1]https://lore.kernel.org/lkml/20210117181534.65724-1-mgurtovoy@nvidia.com/
> >   
> 
> Thanks for the pointer, I'll have to keep an eye on this.  An approach 
> like this could solve some issues, but I think a main issue that still 
> remains with relying on the standard BAR region indexes (whether using 
> the current vfio-pci driver or a device-specific driver) is that QEMU 
> writes to said BAR memory region are happening in, at most, 8B chunks 
> (which then, in the current general-purpose vfio-pci code get further 
> split up into 4B iowrite operations).  The alternate approach I'm 
> proposing here is allowing for the whole payload (4K) in a single 
> operation, which is significantly faster.  So, I suspect even with a 
> device specific driver we'd want this sort of a region anyhow..

Why is this device specific behavior?  It would be a fair argument that
acceptable device access widths for MMIO are always device specific, so
we should never break them down.  Looking at the PCI spec, a TLP
requires a dword (4-byte) aligned address with a 10-bit length field
indicating the number of dwords, so up to 4K data as you suggest is the
whole payload.  It's quite possible that the reason we don't have more
access width problems is that MMIO is typically mmap'd on other
platforms.  We get away with using the x-no-mmap=on flag for debugging,
but it's not unheard of that the device also doesn't work quite
correctly with that flag, which could be due to access width or timing
difference.

So really, I don't see why we wouldn't want to maintain the guest
access width through QEMU and the kernel interface for all devices.  It
seems like that should be our default vfio-pci implementation.  I think
we chose the current width based on the QEMU implementation that was
already splitting accesses, and it (mostly) worked.  Thanks,

Alex

