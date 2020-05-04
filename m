Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623571C4A00
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgEDXEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:04:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728182AbgEDXD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 19:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588633438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QSlf+Qz/0aXB5FUlpmtAof2u7cyHXWyIIR1U62jjyo0=;
        b=Uvt80dJfN9GT/IlmGV9+eMcT0FZHpmu5y7LwTc/wUYHw7MY3arDpZeUAQ6UOP+UxhgS0ca
        /XyMk9F/EkEehvhWprwkpD9ta5ho7nN1iItX4D+4rTTKBX7DfEEXeCtcg7k57/z9gjv+l9
        yQ/DF5f1R6Shh/C9p0TGI8vF5bop7KM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-qYJNbqg_Nj-8HSHHSTy4JQ-1; Mon, 04 May 2020 19:03:55 -0400
X-MC-Unique: qYJNbqg_Nj-8HSHHSTy4JQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F22011005510;
        Mon,  4 May 2020 23:03:54 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A163763F81;
        Mon,  4 May 2020 23:03:54 +0000 (UTC)
Date:   Mon, 4 May 2020 17:03:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Neo Jia <cjia@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci: Mask cap zero
Message-ID: <20200504170354.3b49d07b@x1.home>
In-Reply-To: <20200504220804.GA22939@nvidia.com>
References: <158836927527.9272.16785800801999547009.stgit@gimli.home>
        <20200504180916.0e90cad9.cohuck@redhat.com>
        <20200504125253.3d5f9cbf@x1.home>
        <20200504220804.GA22939@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 15:08:08 -0700
Neo Jia <cjia@nvidia.com> wrote:

> On Mon, May 04, 2020 at 12:52:53PM -0600, Alex Williamson wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Mon, 4 May 2020 18:09:16 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Fri, 01 May 2020 15:41:24 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > >  
> > > > There is no PCI spec defined capability with ID 0, therefore we don't
> > > > expect to find it in a capability chain and we use this index in an
> > > > internal array for tracking the sizes of various capabilities to handle
> > > > standard config space.  Therefore if a device does present us with a
> > > > capability ID 0, we mark our capability map with nonsense that can
> > > > trigger conflicts with other capabilities in the chain.  Ignore ID 0
> > > > when walking the capability chain, handling it as a hidden capability.
> > > >
> > > > Seen on an NVIDIA Tesla T4.
> > > >
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > >  drivers/vfio/pci/vfio_pci_config.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > > > index 87d0cc8c86ad..5935a804cb88 100644
> > > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > > @@ -1487,7 +1487,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
> > > >             if (ret)
> > > >                     return ret;
> > > >
> > > > -           if (cap <= PCI_CAP_ID_MAX) {  
> > >
> > > Maybe add a comment:
> > >
> > > /* no PCI spec defined capability with ID 0: hide it */  
> 
> Hi Alex,
> 
> I think this is NULL Capability defined in Codes and IDs spec, probably we
> should just add a new enum to represent that?

Yes, it looks like the 1.1 version of that specification from June 2015
changed ID 0 from reserved to a NULL capability.  So my description and
this comment are wrong, but I wonder if we should did anything
different with the handling of this capability.  It's specified to
contain only the ID and next pointer, so I'd expect it's primarily a
mechanism for hardware vendors to blow fuses in config space to
maintain a capability chain while maybe hiding a feature not supported
by the product sku.  Hiding the capability in vfio is trivial, exposing
it implies some changes to our config space map that might be more
subtle.  I'm inclined to stick with this solution for now.  Thanks,

Alex

> > 
> > Sure.
> >   
> > >  
> > > > +           if (cap && cap <= PCI_CAP_ID_MAX) {
> > > >                     len = pci_cap_length[cap];
> > > >                     if (len == 0xFF) { /* Variable length */
> > > >                             len = vfio_cap_len(vdev, cap, pos);
> > > >  
> > >
> > > Is there a requirement for caps to be strictly ordered? If not, could
> > > len hold a residual value from a previous iteration?  
> > 
> > There is no ordering requirement for capabilities, but len is declared
> > non-static with an initial value within the scope of the loop, it's
> > reset every iteration.  Thanks,
> > 
> > Alex
> >   
> 

