Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58171C4E12
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 08:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgEEGJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 02:09:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22308 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEGJv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 02:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588658990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7LlKBGs5CgTE1OyD7RL3R2uC0X6yz7gneyPxwwVA04=;
        b=Wvn6sDD7Ru6EKEzriVHn8xqQ7gGxTHrk02QrZRdP4mYizOdSL9VR/dGnbuEEGBJbH69W07
        NKPeK3S11uOUvOrTYwI36myOiI9l2juOp2z5DYJnc+vPpMwsgqxo0IAWgkoKPBZga/NOp7
        IxcQJEKckoUAA4tPgoioyxkhkiQvr1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-OIVSgUQ2PoyaDxWxIHVoKg-1; Tue, 05 May 2020 02:09:46 -0400
X-MC-Unique: OIVSgUQ2PoyaDxWxIHVoKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 764EE80B713;
        Tue,  5 May 2020 06:09:45 +0000 (UTC)
Received: from gondolin (ovpn-112-219.ams2.redhat.com [10.36.112.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66B7363F84;
        Tue,  5 May 2020 06:09:41 +0000 (UTC)
Date:   Tue, 5 May 2020 08:09:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Neo Jia <cjia@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci: Mask cap zero
Message-ID: <20200505080939.1e5a224a.cohuck@redhat.com>
In-Reply-To: <20200504170354.3b49d07b@x1.home>
References: <158836927527.9272.16785800801999547009.stgit@gimli.home>
        <20200504180916.0e90cad9.cohuck@redhat.com>
        <20200504125253.3d5f9cbf@x1.home>
        <20200504220804.GA22939@nvidia.com>
        <20200504170354.3b49d07b@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 17:03:54 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 4 May 2020 15:08:08 -0700
> Neo Jia <cjia@nvidia.com> wrote:
>=20
> > On Mon, May 04, 2020 at 12:52:53PM -0600, Alex Williamson wrote: =20
> > > External email: Use caution opening links or attachments
> > >=20
> > >=20
> > > On Mon, 4 May 2020 18:09:16 +0200
> > > Cornelia Huck <cohuck@redhat.com> wrote:
> > >    =20
> > > > On Fri, 01 May 2020 15:41:24 -0600
> > > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > >   =20
> > > > > There is no PCI spec defined capability with ID 0, therefore we d=
on't
> > > > > expect to find it in a capability chain and we use this index in =
an
> > > > > internal array for tracking the sizes of various capabilities to =
handle
> > > > > standard config space.  Therefore if a device does present us wit=
h a
> > > > > capability ID 0, we mark our capability map with nonsense that can
> > > > > trigger conflicts with other capabilities in the chain.  Ignore I=
D 0
> > > > > when walking the capability chain, handling it as a hidden capabi=
lity.
> > > > >
> > > > > Seen on an NVIDIA Tesla T4.
> > > > >
> > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > ---
> > > > >  drivers/vfio/pci/vfio_pci_config.c |    2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pc=
i/vfio_pci_config.c
> > > > > index 87d0cc8c86ad..5935a804cb88 100644
> > > > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > > > @@ -1487,7 +1487,7 @@ static int vfio_cap_init(struct vfio_pci_de=
vice *vdev)
> > > > >             if (ret)
> > > > >                     return ret;
> > > > >
> > > > > -           if (cap <=3D PCI_CAP_ID_MAX) {   =20
> > > >
> > > > Maybe add a comment:
> > > >
> > > > /* no PCI spec defined capability with ID 0: hide it */   =20
> >=20
> > Hi Alex,
> >=20
> > I think this is NULL Capability defined in Codes and IDs spec, probably=
 we
> > should just add a new enum to represent that? =20
>=20
> Yes, it looks like the 1.1 version of that specification from June 2015
> changed ID 0 from reserved to a NULL capability.  So my description and
> this comment are wrong, but I wonder if we should did anything
> different with the handling of this capability.  It's specified to
> contain only the ID and next pointer, so I'd expect it's primarily a
> mechanism for hardware vendors to blow fuses in config space to
> maintain a capability chain while maybe hiding a feature not supported
> by the product sku.  Hiding the capability in vfio is trivial, exposing
> it implies some changes to our config space map that might be more
> subtle.  I'm inclined to stick with this solution for now.  Thanks,
>=20
> Alex

=46rom this description, I also think that we should simply hide these
NULL capabilities.

