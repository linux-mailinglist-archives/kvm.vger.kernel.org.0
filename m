Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3E26925C
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 19:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgINRAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 13:00:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33553 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgINQ7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 12:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600102753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1tkEtnAMzbXyUWN1Kd3VSWr/ao1qWSMw1ylDPJkGR9o=;
        b=DFyjJX9g8K2+69VCXRnTpZbSOK4zRai1vPVgY56QrsWCO44ymo0DLK44ju1xwHC/WaW2iV
        qKg/n8+52YcxWPfFNjp4sjm8Z1ejL2+uzPRhvBgrFlgEFgwTWtn6v2rxI4Rv2e3+qwrU6X
        EvXy6dX3921XFB6GF3XWgdK4NmsuJtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-Vbaak6A8P1mJweCqqa3Yjg-1; Mon, 14 Sep 2020 12:59:11 -0400
X-MC-Unique: Vbaak6A8P1mJweCqqa3Yjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F0F5107466B;
        Mon, 14 Sep 2020 16:59:09 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14D5627C21;
        Mon, 14 Sep 2020 16:58:58 +0000 (UTC)
Date:   Mon, 14 Sep 2020 10:58:57 -0600
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
Message-ID: <20200914105857.3f88a271@x1.home>
In-Reply-To: <20200914163354.GG904879@nvidia.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
        <20200914133113.GB1375106@myrica>
        <20200914134738.GX904879@nvidia.com>
        <20200914162247.GA63399@otc-nc-03>
        <20200914163354.GG904879@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Sep 2020 13:33:54 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 14, 2020 at 09:22:47AM -0700, Raj, Ashok wrote:
> > Hi Jason,
> > 
> > On Mon, Sep 14, 2020 at 10:47:38AM -0300, Jason Gunthorpe wrote:  
> > > On Mon, Sep 14, 2020 at 03:31:13PM +0200, Jean-Philippe Brucker wrote:
> > >   
> > > > > Jason suggest something like /dev/sva. There will be a lot of other
> > > > > subsystems that could benefit from this (e.g vDPA).  
> > > > 
> > > > Do you have a more precise idea of the interface /dev/sva would provide,
> > > > how it would interact with VFIO and others?  vDPA could transport the
> > > > generic iommu.h structures via its own uAPI, and call the IOMMU API
> > > > directly without going through an intermediate /dev/sva handle.  
> > > 
> > > Prior to PASID IOMMU really only makes sense as part of vfio-pci
> > > because the iommu can only key on the BDF. That can't work unless the
> > > whole PCI function can be assigned. It is hard to see how a shared PCI
> > > device can work with IOMMU like this, so may as well use vfio.
> > > 
> > > SVA and various vIOMMU models change this, a shared PCI driver can
> > > absoultely work with a PASID that is assigned to a VM safely, and
> > > actually don't need to know if their PASID maps a mm_struct or
> > > something else.  
> > 
> > Well, IOMMU does care if its a native mm_struct or something that belongs
> > to guest. Because you need ability to forward page-requests and pickup
> > page-responses from guest. Since there is just one PRQ on the IOMMU and
> > responses can't be sent directly. You have to depend on vIOMMU type
> > interface in guest to make all of this magic work right?  
> 
> Yes, IOMMU cares, but not the PCI Driver. It just knows it has a
> PASID. Details on how page faultings is handled or how the mapping is
> setup is abstracted by the PASID.
> 
> > > This new PASID allocator would match the guest memory layout and  
> > 
> > Not sure what you mean by "match guest memory layout"? 
> > Probably, meaning first level is gVA or gIOVA?   
> 
> It means whatever the qemu/viommu/guest/etc needs across all the
> IOMMU/arch implementations.
> 
> Basically, there should only be two ways to get a PASID
>  - From mm_struct that mirrors the creating process
>  - Via '/dev/sva' which has an complete interface to create and
>    control a PASID suitable for virtualization and more
> 
> VFIO should not have its own special way to get a PASID.

"its own special way" is arguable, VFIO is just making use of what's
being proposed as the uapi via its existing IOMMU interface.  PASIDs
are also a system resource, so we require some degree of access control
and quotas for management of PASIDs.  Does libvirt now get involved to
know whether an assigned device requires PASIDs such that access to
this dev file is provided to QEMU?  How does the kernel validate usage
or implement quotas when disconnected from device ownership?  PASIDs
would be an obvious DoS path if any user can create arbitrary
allocations.  If we can move code out of VFIO, I'm all for it, but I
think it needs to be better defined than "implement magic universal sva
uapi interface" before we can really consider it.  Thanks,

Alex

