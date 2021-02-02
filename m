Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40930D018
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 01:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhBCAA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 19:00:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230419AbhBCAA5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 19:00:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612310370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmeYCqaBeks3zBPW/X7c4mBa0R5cLv8M6DutE3inkEQ=;
        b=NNP9pAG69y8s/f3AUbU/mM9Uu1BhlqRNWvbsQoGvgSfXy8w4SPygnKYrJ/gO5ecas1z7Xm
        +rJUpcSyGdjVwN1PTm6ECaVIqU01roWAPPFC+GKD4NqnZuIYLCgCO1P7Wky2xLtX8mic1l
        cTP3FGAaoBRdJsoz3H3TpX3rnPe7JDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-DrCa99nKPjelyOtoIAG5Rg-1; Tue, 02 Feb 2021 18:59:28 -0500
X-MC-Unique: DrCa99nKPjelyOtoIAG5Rg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75CFE81621;
        Tue,  2 Feb 2021 23:59:25 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 229CDE165;
        Tue,  2 Feb 2021 23:59:24 +0000 (UTC)
Date:   Tue, 2 Feb 2021 16:59:23 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202165923.53f76901@omen.home.shazbot.org>
In-Reply-To: <20210202230604.GD4247@nvidia.com>
References: <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
        <20210201114230.37c18abd@omen.home.shazbot.org>
        <20210202170659.1c62a9e8.cohuck@redhat.com>
        <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
        <20210202105455.5a358980@omen.home.shazbot.org>
        <20210202185017.GZ4247@nvidia.com>
        <20210202123723.6cc018b8@omen.home.shazbot.org>
        <20210202204432.GC4247@nvidia.com>
        <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
        <20210202143013.06366e9d@omen.home.shazbot.org>
        <20210202230604.GD4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 19:06:04 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 02, 2021 at 02:30:13PM -0700, Alex Williamson wrote:
> 
> > The first set of users already fail this specification though, we can't
> > base it strictly on device and vendor IDs, we need wildcards, class
> > codes, revision IDs, etc., just like any other PCI drvier.  We're not
> > going to maintain a set of specific device IDs for the IGD
> > extension,  
> 
> The Intel GPU driver already has a include/drm/i915_pciids.h that
> organizes all the PCI match table entries, no reason why VFIO IGD
> couldn't include that too and use the same match table as the real GPU
> driver. Same HW right?

vfio-pci-igd support knows very little about the device, we're
effectively just exposing a firmware table and some of the host bridge
config space (read-only).  So the idea that the host kernel needs to
have updated i915 support in order to expose the device to userspace
with these extra regions is a bit silly.

> Also how sure are you that this loose detection is going to work with
> future Intel discrete GPUs that likely won't need vfio_igd?

Not at all, which is one more reason we don't want to rely on i915's
device table, which would likely support those as well.  We might only
want to bind to GPUs on the root complex, or at address 0000:00:02.0.
Our "what to reject" algorithm might need to evolve as those arrive,
but I don't think that means we need to explicitly list every device ID
either.

> > nor I suspect the NVLINK support as that would require a kernel update
> > every time a new GPU is released that makes use of the same interface.  
> 
> The nvlink device that required this special vfio code was a one
> off. Current devices do not use it. Not having an exact PCI ID match
> in this case is a bug.

AIUI, the quirk is only activated when there's a firmware table to
support it.  No firmware table, no driver bind, no need to use
explicit IDs.  Vendor and class code should be enough.
 
> > As I understand Jason's reply, these vendor drivers would have an ids
> > table and a user could look at modalias for the device to compare to
> > the driver supported aliases for a match.  Does kmod already have this
> > as a utility outside of modprobe?  
> 
> I think this is worth exploring.
> 
> One idea that fits nicely with the existing infrastructure is to add
> to driver core a 'device mode' string. It would be "default" or "vfio"
> 
> devices in vfio mode only match vfio mode device_drivers.
> 
> devices in vfio mode generate a unique modalias string that includes
> some additional 'mode=vfio' identifier
> 
> drivers that run in vfio mode generate a module table string that
> includes the same mode=vfio
> 
> The driver core can trigger driver auto loading soley based on the
> mode string, happens naturally.
> 
> All the existing udev, depmod/etc tooling will transparently work.
> 
> Like driver_override, but doesn't bypass all the ID and module loading
> parts of the driver core.
> 
> (But lets not get too far down this path until we can agree that
> embracing the driver core like the RFC contemplates is the agreed
> direction)

I'm not sure I fully follow the mechanics of this.  I'm interpreting
this as something like a sub-class of drivers where for example
vfio-pci class drivers would have a vfio-pci: alias prefix rather than
pci:.  There might be some sysfs attribute for the device that would
allow the user to write an alias prefix and would that trigger the
(ex.) pci-core to send remove uevents for the pci: modalias device and
add uevents for the vfio-pci: modalias device?  Some ordering rules
would then allow vendor/device modules to precede vfio-pci, which would
have only a wildcard id table?

I need to churn on that for a while, but if driver-core folks are
interested, maybe it could be a good idea...  Thanks,

Alex

