Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A7233E15F
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 23:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCPW16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 18:27:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231219AbhCPW1Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 18:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615933644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nop42kpobMjELNjGlRqvIgg2b6GxMFDnMzFltwGkEHM=;
        b=D/q6onN10E47u/oPf/dMwzAQAF78WmkoWvKX9EHrepp7R4LKKNmVsc7mouIW4HDnek57hn
        eFuR7SgPZb0BuUKuw9+GHrFpXf0LLzJqY3hyhm81EpBJ+QlZ3IAAQLUwdX25MDUHOFku34
        IVD6+vtBm44S9cg/DOt8bHN6NIusYX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-mqxddXayOTyyJTc7l8MbEw-1; Tue, 16 Mar 2021 18:27:20 -0400
X-MC-Unique: mqxddXayOTyyJTc7l8MbEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA743107ACCA;
        Tue, 16 Mar 2021 22:27:18 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA8F6189A4;
        Tue, 16 Mar 2021 22:27:14 +0000 (UTC)
Date:   Tue, 16 Mar 2021 16:27:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Message-ID: <20210316162713.6dff86bf@omen.home.shazbot.org>
In-Reply-To: <20210316132058.GK2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <MWHPR11MB1886D4C304FD9C599FD7A8848C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210316132058.GK2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 10:20:58 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 16, 2021 at 08:04:55AM +0000, Tian, Kevin wrote:
> > > @@ -2060,15 +2056,20 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> > > const struct pci_device_id *id)
> > >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> > >  	}
> > > 
> > > -	return ret;
> > > +	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> > > +	if (ret)
> > > +		goto out_power;
> > > +	return 0;
> > > 
> > > +out_power:
> > > +	if (!disable_idle_d3)
> > > +		vfio_pci_set_power_state(vdev, PCI_D0);  
> > 
> > Just curious whether the power state must be recovered upon failure here.
> > From the comment several lines above, the power state is set to an unknown
> > state before doing D3 transaction. From this point it looks fine if leaving the
> > device in D3 since there is no expected state to be recovered?  
> 
> I don't know, this is what the remove function does, so I can't see a
> reason why remove should do it but not here.

I'm not sure it matters in either case, we're just trying to be most
similar to expected driver behavior.  pci_enable_device() puts the
device in D0 but pci_disable_device() doesn't touch the power state, so
the device would typically be released from a PCI driver in D0 afaict.
Thanks,

Alex

