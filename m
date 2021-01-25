Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977A93049EA
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732003AbhAZFUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730334AbhAYPok (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 10:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611589382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwUrudT149MlYBAjlrkqwTg7VCY0+Yq9+gSFRKaR80s=;
        b=R0MG4Vl5xYyFXu7s01yRws16Mc0TIihwk5LcxupJJ3P4bZrai0zKZhHn0Fqh0aeJ3KvyzU
        uPJ1HioP5Dl6Xb+zoSn17/B9oCb4O3EDxiHl1mFLqoV8h0vrbAGUi8ApCHd6GCc+d33MkB
        M05eYHzapTHF2mKeAF2Yzp2q8IRUFqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-wFt5wxUKNkKXGw7gDZYURA-1; Mon, 25 Jan 2021 10:42:58 -0500
X-MC-Unique: wFt5wxUKNkKXGw7gDZYURA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1765809DC9;
        Mon, 25 Jan 2021 15:42:56 +0000 (UTC)
Received: from gondolin (ovpn-113-161.ams2.redhat.com [10.36.113.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9017D5E1A4;
        Mon, 25 Jan 2021 15:42:54 +0000 (UTC)
Date:   Mon, 25 Jan 2021 16:42:52 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
Message-ID: <20210125164252.1d1af6cd.cohuck@redhat.com>
In-Reply-To: <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
        <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
        <20210122164843.269f806c@omen.home.shazbot.org>
        <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

I'm also wondering about device specific vs architecture/platform
specific handling.

If we're trying to support ISM devices, that's device specific
handling; but if we're trying to add more generic things like the large
payload support, that's not necessarily tied to a device, is it? For
example, could a device support large payload if plugged into a z, but
not if plugged into another machine?

