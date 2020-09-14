Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D762694BE
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 20:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgINSXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 14:23:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbgINSXp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 14:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600107823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XVFp4dOY4OmtedIBdixRuoU2VCcjztEW+AfQ5IJDBU=;
        b=IRI7nRxvbgeEp/UkW/nx8+aqLrO0+cVWA3qB0sQLNOF/DErb59ms/69BLHk78kQcYwrykR
        2AWqLa1ClTuWxUXqJQqYCNS6Lx9EajFHbJNWT54zNhRj7tKDHXtKjIO/hNQSig2XP6uaxl
        6KigxQAoSFrx6OVpF8afZxt1AbbJ11E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-Jcb3zBWPMMy61XbVCvtLcg-1; Mon, 14 Sep 2020 14:23:41 -0400
X-MC-Unique: Jcb3zBWPMMy61XbVCvtLcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58BE8800C78;
        Mon, 14 Sep 2020 18:23:39 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 217F75C1BB;
        Mon, 14 Sep 2020 18:23:29 +0000 (UTC)
Date:   Mon, 14 Sep 2020 12:23:28 -0600
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
Message-ID: <20200914122328.0a262a7b@x1.home>
In-Reply-To: <20200914174121.GI904879@nvidia.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
        <20200914133113.GB1375106@myrica>
        <20200914134738.GX904879@nvidia.com>
        <20200914162247.GA63399@otc-nc-03>
        <20200914163354.GG904879@nvidia.com>
        <20200914105857.3f88a271@x1.home>
        <20200914174121.GI904879@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Sep 2020 14:41:21 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 14, 2020 at 10:58:57AM -0600, Alex Williamson wrote:
>  
> > "its own special way" is arguable, VFIO is just making use of what's
> > being proposed as the uapi via its existing IOMMU interface.  
> 
> I mean, if we have a /dev/sva then it makes no sense to extend the
> VFIO interfaces with the same stuff. VFIO should simply accept a PASID
> created from /dev/sva and use it just like any other user-DMA driver
> would.

I don't think that's absolutely true.  By the same logic, we could say
that pci-sysfs provides access to PCI BAR and config space resources,
the VFIO device interface duplicates part of that interface therefore it
should be abandoned.  But in reality, VFIO providing access to those
resources puts those accesses within the scope and control of the VFIO
interface.  Ownership of a device through vfio is provided by allowing
the user access to the vfio group dev file, not by the group file, plus
some number of resource files, and the config file, and running with
admin permissions to see the full extent of config space.  Reserved
ranges for the IOMMU are also provided via sysfs, but VFIO includes a
capability on the IOMMU get_info ioctl for the user to learn about
available IOVA ranges w/o scraping through sysfs.

> > are also a system resource, so we require some degree of access control
> > and quotas for management of PASIDs.    
> 
> This has already happened, the SVA patches generally allow unpriv user
> space to allocate a PASID for their process.
> 
> If a device implements a mdev shared with a kernel driver (like IDXD)
> then it will be sharing that PASID pool across both drivers. In this
> case it makes no sense that VFIO has PASID quota logic because it has
> an incomplete view. It could only make sense if VFIO is the exclusive
> owner of the bus/device/function.
> 
> The tracking logic needs to be global.. Most probably in some kind of
> PASID cgroup controller?

AIUI, that doesn't exist yet, so it makes sense that VFIO, as the
mechanism through which a user would allocate a PASID, implements a
reasonable quota to avoid an unprivileged user exhausting the address
space.  Also, "unprivileged user" is a bit of a misnomer in this
context as the VFIO user must be privileged with ownership of a device
before they can even participate in PASID allocation.  Is truly
unprivileged access reasonable for a limited resource?
 
> > know whether an assigned device requires PASIDs such that access to
> > this dev file is provided to QEMU?  
> 
> Wouldn't QEMU just open /dev/sva if it needs it? Like other dev files?
> Why would it need something special?

QEMU typically runs in a sandbox with limited access, when a device or
mdev is assigned to a VM, file permissions are configured to allow that
access.  QEMU doesn't get to poke at any random dev file it likes,
that's part of how userspace reduces the potential attack surface.
 
> > would be an obvious DoS path if any user can create arbitrary
> > allocations.  If we can move code out of VFIO, I'm all for it, but I
> > think it needs to be better defined than "implement magic universal sva
> > uapi interface" before we can really consider it.  Thanks,  
> 
> Jason began by saying VDPA will need this too, I agree with him.
> 
> I'm not sure why it would be "magic"? This series already gives a
> pretty solid blueprint for what the interface would need to
> have. Interested folks need to sit down and talk about it not just
> default everything to being built inside VFIO.

This series is a blueprint within the context of the ownership and
permission model that VFIO already provides.  It doesn't seem like we
can pluck that out on its own, nor is it necessarily the case that VFIO
wouldn't want to provide PASID services within its own API even if we
did have this undefined /dev/sva interface.  Thanks,

Alex

