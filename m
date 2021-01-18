Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70A92FA583
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 17:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406296AbhARQCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 11:02:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405918AbhARQBw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 11:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610985625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wsCcOHm/bKwKnbDgL3pf9OMqbHY1rGQPJlyY38AlX1k=;
        b=BDOhEKuvUBsBdYGDBFnKO2hCttQZozrf/RhioonUuib/g0uyjMDfphRSSHVAmbkSfPWNTG
        qxonwGIjALpKU/P+aWTbQDBfj5xeWo61nJxiCCGgdKXfxSPOQXU1axNPl2U2SYFgsmkLzS
        SQInRNhVHww5U2qBvCziMvREz8lMfPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-kbpOINRdPXWaUHtO1_aIBA-1; Mon, 18 Jan 2021 11:00:21 -0500
X-MC-Unique: kbpOINRdPXWaUHtO1_aIBA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3527A190B2AB;
        Mon, 18 Jan 2021 16:00:19 +0000 (UTC)
Received: from gondolin (ovpn-114-2.ams2.redhat.com [10.36.114.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B2C1F051;
        Mon, 18 Jan 2021 16:00:11 +0000 (UTC)
Date:   Mon, 18 Jan 2021 17:00:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210118170009.058c8c52.cohuck@redhat.com>
In-Reply-To: <20210118151020.GJ4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210118143806.036c8dbc.cohuck@redhat.com>
        <20210118151020.GJ4147@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 11:10:20 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jan 18, 2021 at 02:38:06PM +0100, Cornelia Huck wrote:
> 
> > > These devices will be seen on the Auxiliary bus as:
> > > mlx5_core.vfio_pci.2048 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.0/mlx5_core.vfio_pci.2048
> > > mlx5_core.vfio_pci.2304 -> ../../../devices/pci0000:00/0000:00:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.1/mlx5_core.vfio_pci.2304
> > > 
> > > 2048 represents BDF 08:00.0 and 2304 represents BDF 09:00.0 in decimal
> > > view. In this manner, the administrator will be able to locate the
> > > correct vfio-pci module it should bind the desired BDF to (by finding
> > > the pointer to the module according to the Auxiliary driver of that
> > > BDF).  
> > 
> > I'm not familiar with that auxiliary framework (it seems to be fairly
> > new?);   
> 
> Auxillary bus is for connecting two parts of the same driver that
> reside in different modules/subystems. Here it is connecting the vfio
> part to the core part of mlx5 (running on the PF).

Yes, that's also what I understood so far; still need to do more reading up.

> 
> > but can you maybe create an auxiliary device unconditionally and
> > contain all hardware-specific things inside a driver for it? Or is
> > that not flexible enough?  
> 
> The goal is to make a vfio device, auxiliary bus is only in the
> picture because a VF device under vfio needs to interact with the PF
> mlx5_core driver, auxiliary bus provides that connection.

Nod.

> 
> You can say that all the HW specific things are in the mlx5_vfio_pci
> driver. It is an unusual driver because it must bind to both the PCI
> VF with a pci_driver and to the mlx5_core PF using an
> auxiliary_driver. This is needed for the object lifetimes to be
> correct.

Hm... I might be confused about the usage of the term 'driver' here.
IIUC, there are two drivers, one on the pci bus and one on the
auxiliary bus. Is the 'driver' you're talking about here more the
module you load (and not a driver in the driver core sense?)

> 
> The PF is providing services to control a full VF which mlx5_vfio_pci
> converts into VFIO API.
> 
> > >  drivers/vfio/pci/Kconfig            |   22 +-
> > >  drivers/vfio/pci/Makefile           |   16 +-
> > >  drivers/vfio/pci/mlx5_vfio_pci.c    |  253 +++
> > >  drivers/vfio/pci/vfio_pci.c         | 2386 +--------------------------
> > >  drivers/vfio/pci/vfio_pci_core.c    | 2311 ++++++++++++++++++++++++++  
> > 
> > Especially regarding this diffstat...   
> 
> It is a bit misleading because it doesn't show the rename

Yes, sure. But it also shows that mlx5_vfio_pci aka the device-specific
code is rather small in comparison to the common vfio-pci code.
Therefore my question whether it will gain more specific changes (that
cannot be covered via the auxiliary driver.)

