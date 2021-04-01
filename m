Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DD53521E4
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhDAVtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 17:49:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233974AbhDAVtn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 17:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617313783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jP0nlzEEVR13Z7R8FOMceHzyBDcyUqQjSA6O6JQqCF4=;
        b=h06DBE9YlqBO+b+5LKBuTDNOgTAdiTukDiAbqXXzzvv4zmJuq+TG2EFx3jz7AupFWml3Gt
        h3jCrhR5+eIJWRgX8VNmqgRE4UlkQJlf0WsCmYA568cM72kdluwFqLSpIwwl4lHsnMPIAp
        UPdfh/6EndqSK456L+WbUTebByrfME0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-dLOsyKQwMtGDIuTFn3fZmg-1; Thu, 01 Apr 2021 17:49:39 -0400
X-MC-Unique: dLOsyKQwMtGDIuTFn3fZmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68AAE180FCA4;
        Thu,  1 Apr 2021 21:49:36 +0000 (UTC)
Received: from omen (ovpn-112-85.phx2.redhat.com [10.3.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 372C85D9CC;
        Thu,  1 Apr 2021 21:49:34 +0000 (UTC)
Date:   Thu, 1 Apr 2021 15:49:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210401154933.544f8fec@omen>
In-Reply-To: <20210401131227.GC1463678@nvidia.com>
References: <20210319163449.GA19186@lst.de>
        <20210319113642.4a9b0be1@omen.home.shazbot.org>
        <20210319200749.GB2356281@nvidia.com>
        <20210319150809.31bcd292@omen.home.shazbot.org>
        <20210319225943.GH2356281@nvidia.com>
        <20210319224028.51b01435@x1.home.shazbot.org>
        <20210321125818.GM2356281@nvidia.com>
        <20210322104016.36eb3c1f@omen.home.shazbot.org>
        <20210323193213.GM2356281@nvidia.com>
        <20210329171053.7a2ebce3@omen.home.shazbot.org>
        <20210401131227.GC1463678@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Apr 2021 10:12:27 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Mar 29, 2021 at 05:10:53PM -0600, Alex Williamson wrote:
> > On Tue, 23 Mar 2021 16:32:13 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Mar 22, 2021 at 10:40:16AM -0600, Alex Williamson wrote:
> > >   
> > > > Of course if you start looking at features like migration support,
> > > > that's more than likely not simply an additional region with optional
> > > > information, it would need to interact with the actual state of the
> > > > device.  For those, I would very much support use of a specific
> > > > id_table.  That's not these.    
> > > 
> > > What I don't understand is why do we need two different ways of
> > > inserting vendor code?  
> > 
> > Because a PCI id table only identifies the device, these drivers are
> > looking for a device in the context of firmware dependencies.  
> 
> The firmware dependencies only exist for a defined list of ID's, so I
> don't entirely agree with this statement. I agree with below though,
> so lets leave it be.
> 
> > > I understood he ment that NVIDI GPUs *without* NVLINK can exist, but
> > > the ID table we have here is supposed to be the NVLINK compatible
> > > ID's.  
> > 
> > Those IDs are just for the SXM2 variants of the device that can
> > exist on a variety of platforms, only one of which includes the
> > firmware tables to activate the vfio support.  
> 
> AFAIK, SXM2 is a special physical form factor that has the nvlink
> physical connection - it is only for this specific generation of power
> servers that can accept the specific nvlink those cards have.

SXM2 is not unique to Power, there are various x86 systems that support
the interface, everything from NVIDIA's own line of DGX systems,
various vendor systems, all the way to VARs like Super Micro and
Gigabyte.

> > I think you're looking for a significant inflection in vendor's stated
> > support for vfio use cases, beyond the "best-effort, give it a try",
> > that we currently have.  
> 
> I see, so they don't want to. Lets leave it then.
> 
> Though if Xe breaks everything they need to add/maintain a proper ID
> table, not more hackery.

e4eccb853664 ("vfio/pci: Bypass IGD init in case of -ENODEV") is
supposed to enable Xe, where the IGD code is expected to return -ENODEV
and we go on with the base vfio-pci support.
 
> > > And again, I feel this is all a big tangent, especially now that
> > > HCH wants to delete the nvlink stuff we should just leave igd
> > > alone.  
> > 
> > Determining which things stay in vfio-pci-core and which things are
> > split to variant drivers and how those variant drivers can match the
> > devices they intend to support seems very inline with this series.
> >   
> 
> IMHO, the main litmus test for core is if variant drivers will need it
> or not.
> 
> No variant driver should be stacked on an igd device, or if it someday
> is, it should implement the special igd hackery internally (and have a
> proper ID table). So when we split it up igd goes into vfio_pci.ko as
> some special behavior vfio_pci.ko's universal driver provides for IGD.
> 
> Every variant driver will still need the zdev data to be exposed to
> userspace, and every PCI device on s390 has that extra information. So
> vdev goes to vfio_pci_core.ko
> 
> Future things going into vfio_pci.ko need a really good reason why
> they can't be varian drivers instead.

That sounds fair.  Thanks,

Alex

