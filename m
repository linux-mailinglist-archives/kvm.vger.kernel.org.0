Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0987A1C6389
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgEEV6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:58:13 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10549 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgEEV6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:58:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb1e12d0002>; Tue, 05 May 2020 14:57:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 May 2020 14:58:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 May 2020 14:58:11 -0700
Received: from nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 May 2020 21:58:11
 +0000
Date:   Tue, 5 May 2020 14:58:10 -0700
From:   Neo Jia <cjia@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci: Mask cap zero
Message-ID: <20200505215810.GB7633@nvidia.com>
References: <158836927527.9272.16785800801999547009.stgit@gimli.home>
 <20200504180916.0e90cad9.cohuck@redhat.com>
 <20200504125253.3d5f9cbf@x1.home>
 <20200504220804.GA22939@nvidia.com>
 <20200504170354.3b49d07b@x1.home>
 <20200505080939.1e5a224a.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200505080939.1e5a224a.cohuck@redhat.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.6.2 (2016-07-01)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588715821; bh=P41elko9IrlOm144HCO8E+rJooi/jmvfumqPzFrywJ4=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-NVConfidentiality:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=OAJCUqL6qHSYb+ULNtTgItqmX+75YAnB0BsliYNfheCY0vfZ9yJ2LzZ1acvoFji6V
         t42thWvwtd2/epCaf5Oc22e3YSBVKMxZOfHHE1sALj8AINJIqlmnM/V1REzcPjqcH1
         wjtWp1C40Fkrm/yqXbGzu0rK5szvDyf80HDgoovmnIY03M0fOpTaj+7Sa1A1eQGOHG
         7SHpIarvW8YpT0x5NieVYz6erHUkE2/+JwPMzX5ELqtdWIe/41WYdcNp6WSDOflOzU
         u6R0oECRwHAtbi7FUrB3Cl4i8aPqNFgGxH3BROxbrWnTa7a71UEnK7Z79Q4i58bKGV
         5T+krrl39Um7A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 08:09:39AM +0200, Cornelia Huck wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, 4 May 2020 17:03:54 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Mon, 4 May 2020 15:08:08 -0700
> > Neo Jia <cjia@nvidia.com> wrote:
> >
> > > On Mon, May 04, 2020 at 12:52:53PM -0600, Alex Williamson wrote:
> > > > External email: Use caution opening links or attachments
> > > >
> > > >
> > > > On Mon, 4 May 2020 18:09:16 +0200
> > > > Cornelia Huck <cohuck@redhat.com> wrote:
> > > >
> > > > > On Fri, 01 May 2020 15:41:24 -0600
> > > > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > > >
> > > > > > There is no PCI spec defined capability with ID 0, therefore we don't
> > > > > > expect to find it in a capability chain and we use this index in an
> > > > > > internal array for tracking the sizes of various capabilities to handle
> > > > > > standard config space.  Therefore if a device does present us with a
> > > > > > capability ID 0, we mark our capability map with nonsense that can
> > > > > > trigger conflicts with other capabilities in the chain.  Ignore ID 0
> > > > > > when walking the capability chain, handling it as a hidden capability.
> > > > > >
> > > > > > Seen on an NVIDIA Tesla T4.
> > > > > >
> > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > ---
> > > > > >  drivers/vfio/pci/vfio_pci_config.c |    2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > > > > > index 87d0cc8c86ad..5935a804cb88 100644
> > > > > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > > > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > > > > @@ -1487,7 +1487,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
> > > > > >             if (ret)
> > > > > >                     return ret;
> > > > > >
> > > > > > -           if (cap <= PCI_CAP_ID_MAX) {
> > > > >
> > > > > Maybe add a comment:
> > > > >
> > > > > /* no PCI spec defined capability with ID 0: hide it */
> > >
> > > Hi Alex,
> > >
> > > I think this is NULL Capability defined in Codes and IDs spec, probably we
> > > should just add a new enum to represent that?
> >
> > Yes, it looks like the 1.1 version of that specification from June 2015
> > changed ID 0 from reserved to a NULL capability.  So my description and
> > this comment are wrong, but I wonder if we should did anything
> > different with the handling of this capability.  It's specified to
> > contain only the ID and next pointer, so I'd expect it's primarily a
> > mechanism for hardware vendors to blow fuses in config space to
> > maintain a capability chain while maybe hiding a feature not supported
> > by the product sku.  Hiding the capability in vfio is trivial, exposing
> > it implies some changes to our config space map that might be more
> > subtle.  I'm inclined to stick with this solution for now.  Thanks,
> >
> > Alex
> 
> From this description, I also think that we should simply hide these
> NULL capabilities.

I don't have a strong preference either way, the current implementation looks
fine.

Thanks,
Neo

> 
