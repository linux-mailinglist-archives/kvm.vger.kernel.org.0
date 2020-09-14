Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045E32698E5
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgINWdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:33:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725953AbgINWdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 18:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600122809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjaf02v1R3x1zDA9n+pIS+ZUb4zwiX61GOvGB/O1OBA=;
        b=WyMKX09wRNBdthoDkvYvI29Bc20Iij4r5lU+4PBMeEFiK4rzByH4H7ZOw/J7vfTGCkbysh
        tN9syK/7xaVaRzQCuwixHVpDxqxX+7bwVp8GQoAktYQEKwKlGi+DvcKCxu4bJxpA2XfdoS
        U3ttZfJZdMfB+3c0151+9zX3liqzE2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-22uIGfMvN6uZMXtGoh0XvA-1; Mon, 14 Sep 2020 18:33:24 -0400
X-MC-Unique: 22uIGfMvN6uZMXtGoh0XvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67628802B70;
        Mon, 14 Sep 2020 22:33:22 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D97E7B7B5;
        Mon, 14 Sep 2020 22:33:10 +0000 (UTC)
Date:   Mon, 14 Sep 2020 16:33:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jacob.jun.pan@linux.intel.com>,
        <jun.j.tian@intel.com>, <yi.y.sun@intel.com>, <peterx@redhat.com>,
        <hao.wu@intel.com>, <stefanha@gmail.com>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200914163310.450c8d6e@x1.home>
In-Reply-To: <20200914190057.GM904879@nvidia.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
        <20200914133113.GB1375106@myrica>
        <20200914134738.GX904879@nvidia.com>
        <20200914162247.GA63399@otc-nc-03>
        <20200914163354.GG904879@nvidia.com>
        <20200914105857.3f88a271@x1.home>
        <20200914174121.GI904879@nvidia.com>
        <20200914122328.0a262a7b@x1.home>
        <20200914190057.GM904879@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Sep 2020 16:00:57 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 14, 2020 at 12:23:28PM -0600, Alex Williamson wrote:
> > On Mon, 14 Sep 2020 14:41:21 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Sep 14, 2020 at 10:58:57AM -0600, Alex Williamson wrote:
> > >    
> > > > "its own special way" is arguable, VFIO is just making use of what's
> > > > being proposed as the uapi via its existing IOMMU interface.    
> > > 
> > > I mean, if we have a /dev/sva then it makes no sense to extend the
> > > VFIO interfaces with the same stuff. VFIO should simply accept a PASID
> > > created from /dev/sva and use it just like any other user-DMA driver
> > > would.  
> > 
> > I don't think that's absolutely true.  By the same logic, we could say
> > that pci-sysfs provides access to PCI BAR and config space
> > resources,  
> 
> No, it is the reverse, VFIO is a better version of pci-sysfs, so
> pci-sysfs is the one that is obsoleted by VFIO. Similarly a /dev/sva
> would be the superset interface for PASID, so whatver VFIO has would
> be obsoleted.
> 
> It would be very unusual for the kernel to have to 'preferred'
> interfaces for the same thing, IMHO. The review process for uAPI
> should really prevent that by allowing all interests to be served
> while the uAPI is designed.
> 
> > the VFIO device interface duplicates part of that interface therefore it
> > should be abandoned.  But in reality, VFIO providing access to those
> > resources puts those accesses within the scope and control of the VFIO
> > interface.  
> 
> Not clear to my why VFIO needs that. PASID seems quite orthogonal from
> VFIO to me.


Can you explain that further, or spit-ball what you think this /dev/sva
interface looks like and how a user might interact between vfio and
this new interface?  The interface proposed here definitely does not
seem orthogonal to the vfio IOMMU interface, ie. selecting a specific
IOMMU domain mode during vfio setup, allocating pasids and associating
them with page tables for that two-stage IOMMU setup, performing cache
invalidations based on page table updates, etc.  How does it make more
sense for a vIOMMU to setup some aspects of the IOMMU through vfio and
others through a TBD interface?


> > > This has already happened, the SVA patches generally allow unpriv user
> > > space to allocate a PASID for their process.
> > > 
> > > If a device implements a mdev shared with a kernel driver (like IDXD)
> > > then it will be sharing that PASID pool across both drivers. In this
> > > case it makes no sense that VFIO has PASID quota logic because it has
> > > an incomplete view. It could only make sense if VFIO is the exclusive
> > > owner of the bus/device/function.
> > > 
> > > The tracking logic needs to be global.. Most probably in some kind of
> > > PASID cgroup controller?  
> > 
> > AIUI, that doesn't exist yet, so it makes sense that VFIO, as the
> > mechanism through which a user would allocate a PASID,   
> 
> VFIO is not the exclusive user interface for PASID. Other SVA drivers
> will allocate PASIDs. Any quota has to be implemented by the IOMMU
> layer, and shared across all drivers.


The IOMMU needs to allocate PASIDs, so in that sense it enforces a
quota via the architectural limits, but is the IOMMU layer going to
distinguish in-kernel versus user limits?  A cgroup limit seems like a
good idea, but that's not really at the IOMMU layer either and I don't
see that a /dev/sva and vfio interface couldn't both support a cgroup
type quota.

 
> > space.  Also, "unprivileged user" is a bit of a misnomer in this
> > context as the VFIO user must be privileged with ownership of a device
> > before they can even participate in PASID allocation.  Is truly
> > unprivileged access reasonable for a limited resource?  
> 
> I'm not talking about VFIO, I'm talking about the other SVA drivers. I
> expect some of them will be unpriv safe, like IDXD, for
> instance.
> 
> Some way to manage the limited PASID resource will be necessary beyond
> just VFIO.

And it's not clear that they'll have compatible requirements.  A
userspace idxd driver might have limited needs versus a vIOMMU backend.
Does a single quota model adequately support both or are we back to the
differences between access to a device and ownership of a device?
Maybe a single pasid per user makes sense in the former.  If we could
bring this discussion to some sort of more concrete proposal it might
be easier to weigh the choices.
 
> > QEMU typically runs in a sandbox with limited access, when a device or
> > mdev is assigned to a VM, file permissions are configured to allow that
> > access.  QEMU doesn't get to poke at any random dev file it likes,
> > that's part of how userspace reduces the potential attack surface.  
> 
> Plumbing the exact same APIs through VFIO's uAPI vs /dev/sva doesn't
> reduce the attack surface. qemu can simply include /dev/sva in the
> sandbox when using VFIO with no increase in attack surface from this
> proposed series.

APIs confined to the ownership model that vfio already enforces might
absolutely present a more limited attack surface than some new
interface intended to provide universal sva resource access.  We don't
know until we see it.  The real argument would be whether we have a
more hardened interface due to more review from more users.

 
> > This series is a blueprint within the context of the ownership and
> > permission model that VFIO already provides.  It doesn't seem like we
> > can pluck that out on its own, nor is it necessarily the case that VFIO
> > wouldn't want to provide PASID services within its own API even if we
> > did have this undefined /dev/sva interface.  
> 
> I don't see what you do - VFIO does not own PASID, and in this
> vfio-mdev mode it does not own the PCI device/IOMMU either. So why
> would this need to be part of the VFIO owernship and permission model?

Doesn't the PASID model essentially just augment the requester ID IOMMU
model so as to manage the IOVAs for a subdevice of a RID?  The vfio
model builds on a user's access to a vfio group to entitle them to
allocate IOMMU resources, or in this case PASIDs.  What elevates a user
to be able to allocate such resources in this new proposal?  Do they
need a device at all?  It's not clear to me why RID based IOMMU
management fits within vfio's scope, but PASID based does not.  Seems
like that would chip away at aux domains in general.  Thanks,

Alex

