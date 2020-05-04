Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D31C466E
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgEDSxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:53:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32995 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725981AbgEDSxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 14:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588618379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nL6lAvx0PZBs0tR/mUzSs6IrJPt6ZBwzzVz2VqiOHPM=;
        b=R5Ahm6BvvaQTbOeoz3iWt0O+GRZJpN1+hiuugHXp7zzqDY4kLZ7KOJOw8lZNaahuo0ZIBN
        Ei6xAICOiQD8oHIGD+OWNUVJtGwNM0TLKPI9ViXcaYRzIQ0ATnxPL07V0MvYu1S5ryDBJu
        HOVTOvq1zjq+uncjB7uStj9hro1B2UU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-c41xC3eyMaO8N3yQTQUKsA-1; Mon, 04 May 2020 14:52:55 -0400
X-MC-Unique: c41xC3eyMaO8N3yQTQUKsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BB60107ACCD;
        Mon,  4 May 2020 18:52:54 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A55A60C80;
        Mon,  4 May 2020 18:52:54 +0000 (UTC)
Date:   Mon, 4 May 2020 12:52:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio-pci: Mask cap zero
Message-ID: <20200504125253.3d5f9cbf@x1.home>
In-Reply-To: <20200504180916.0e90cad9.cohuck@redhat.com>
References: <158836927527.9272.16785800801999547009.stgit@gimli.home>
        <20200504180916.0e90cad9.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 18:09:16 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 01 May 2020 15:41:24 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > There is no PCI spec defined capability with ID 0, therefore we don't
> > expect to find it in a capability chain and we use this index in an
> > internal array for tracking the sizes of various capabilities to handle
> > standard config space.  Therefore if a device does present us with a
> > capability ID 0, we mark our capability map with nonsense that can
> > trigger conflicts with other capabilities in the chain.  Ignore ID 0
> > when walking the capability chain, handling it as a hidden capability.
> > 
> > Seen on an NVIDIA Tesla T4.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index 87d0cc8c86ad..5935a804cb88 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -1487,7 +1487,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
> >  		if (ret)
> >  			return ret;
> >  
> > -		if (cap <= PCI_CAP_ID_MAX) {  
> 
> Maybe add a comment:
> 
> /* no PCI spec defined capability with ID 0: hide it */
> 

Sure.

> 
> > +		if (cap && cap <= PCI_CAP_ID_MAX) {
> >  			len = pci_cap_length[cap];
> >  			if (len == 0xFF) { /* Variable length */
> >  				len = vfio_cap_len(vdev, cap, pos);
> >   
> 
> Is there a requirement for caps to be strictly ordered? If not, could
> len hold a residual value from a previous iteration?

There is no ordering requirement for capabilities, but len is declared
non-static with an initial value within the scope of the loop, it's
reset every iteration.  Thanks,

Alex

