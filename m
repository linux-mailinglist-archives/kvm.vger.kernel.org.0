Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E221C495E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 00:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEDWIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 18:08:11 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15422 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgEDWIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 18:08:10 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb092050000>; Mon, 04 May 2020 15:07:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 04 May 2020 15:08:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 04 May 2020 15:08:10 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 May
 2020 22:08:10 +0000
Received: from nvidia.com (10.124.1.5) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 May 2020 22:08:09
 +0000
Date:   Mon, 4 May 2020 15:08:08 -0700
From:   Neo Jia <cjia@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci: Mask cap zero
Message-ID: <20200504220804.GA22939@nvidia.com>
References: <158836927527.9272.16785800801999547009.stgit@gimli.home>
 <20200504180916.0e90cad9.cohuck@redhat.com>
 <20200504125253.3d5f9cbf@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200504125253.3d5f9cbf@x1.home>
X-NVConfidentiality: public
User-Agent: Mutt/1.6.2 (2016-07-01)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588630021; bh=JXAyL5A4QuiGFAr0EoNzJWVZWQesfo7f59rSLV8U+Fg=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-NVConfidentiality:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=Jfoszp2CT/oVndR4WOGkzha7sg0rSCntqcfP0FsU/ndCqiQggxXj3HNLhaPiw8GDZ
         J7XaDvBkOZvREazB9AyXQwuIusG7/cfRGkr+goxRzvX8ObtYp1XHCoCHQJBaPzFWeW
         WlnJcI7RnwMuUVEy2pqXrondCo//5rcOV3mT4Y3Frp6dt15wCYeIhxwojbWHD53F7K
         fJzucxSuBmy7o1GkzHhChS2fKJJk+LDB2B/ONQCLkcU2BWDt/qlyEjLW22OXxzuacG
         aVIaXYmEGlndcyFUfkX4n3FylAu2z7mVaBN5JC3NgRLG/yT1gW2rYHfRCx91C2rA+T
         dv2PPVaGS3ayg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 12:52:53PM -0600, Alex Williamson wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, 4 May 2020 18:09:16 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Fri, 01 May 2020 15:41:24 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >
> > > There is no PCI spec defined capability with ID 0, therefore we don't
> > > expect to find it in a capability chain and we use this index in an
> > > internal array for tracking the sizes of various capabilities to handle
> > > standard config space.  Therefore if a device does present us with a
> > > capability ID 0, we mark our capability map with nonsense that can
> > > trigger conflicts with other capabilities in the chain.  Ignore ID 0
> > > when walking the capability chain, handling it as a hidden capability.
> > >
> > > Seen on an NVIDIA Tesla T4.
> > >
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_config.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > > index 87d0cc8c86ad..5935a804cb88 100644
> > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > @@ -1487,7 +1487,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
> > >             if (ret)
> > >                     return ret;
> > >
> > > -           if (cap <= PCI_CAP_ID_MAX) {
> >
> > Maybe add a comment:
> >
> > /* no PCI spec defined capability with ID 0: hide it */

Hi Alex,

I think this is NULL Capability defined in Codes and IDs spec, probably we
should just add a new enum to represent that?

Thanks,
Neo

> >
> 
> Sure.
> 
> >
> > > +           if (cap && cap <= PCI_CAP_ID_MAX) {
> > >                     len = pci_cap_length[cap];
> > >                     if (len == 0xFF) { /* Variable length */
> > >                             len = vfio_cap_len(vdev, cap, pos);
> > >
> >
> > Is there a requirement for caps to be strictly ordered? If not, could
> > len hold a residual value from a previous iteration?
> 
> There is no ordering requirement for capabilities, but len is declared
> non-static with an initial value within the scope of the loop, it's
> reset every iteration.  Thanks,
> 
> Alex
> 
