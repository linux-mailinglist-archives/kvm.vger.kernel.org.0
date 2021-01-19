Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8E42FBF99
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbhASS6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:58:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731769AbhASS6C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 13:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611082586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=USIJV7ocAqDOCberXRvY/8K18emSXxgvsqV2iaD7hJA=;
        b=d6GgJSw/5UJ9hsAvdUvOtOLgLvfbmjo3PPNnDImL4W4sLPNe2S+wwNiBov/WbTK+B0EMGw
        L/k3gs2MbpyeoklZcGn+uh4O5/7qexsw6c1m0d22j3WzrvUv2g2N/6zDu85x+RB/DU44pn
        QGiH2oi+G8qXF950JWg+twoh6vvKWAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-oSXhdUFTOCWgwZgH13Pj2w-1; Tue, 19 Jan 2021 13:56:22 -0500
X-MC-Unique: oSXhdUFTOCWgwZgH13Pj2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FBA0800D62;
        Tue, 19 Jan 2021 18:56:19 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53AD218796;
        Tue, 19 Jan 2021 18:56:13 +0000 (UTC)
Date:   Tue, 19 Jan 2021 19:56:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210119195610.18da1e78.cohuck@redhat.com>
In-Reply-To: <20210118181626.GL4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210118143806.036c8dbc.cohuck@redhat.com>
        <20210118151020.GJ4147@nvidia.com>
        <20210118170009.058c8c52.cohuck@redhat.com>
        <20210118181626.GL4147@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 14:16:26 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jan 18, 2021 at 05:00:09PM +0100, Cornelia Huck wrote:
> 
> > > You can say that all the HW specific things are in the mlx5_vfio_pci
> > > driver. It is an unusual driver because it must bind to both the PCI
> > > VF with a pci_driver and to the mlx5_core PF using an
> > > auxiliary_driver. This is needed for the object lifetimes to be
> > > correct.  
> > 
> > Hm... I might be confused about the usage of the term 'driver' here.
> > IIUC, there are two drivers, one on the pci bus and one on the
> > auxiliary bus. Is the 'driver' you're talking about here more the
> > module you load (and not a driver in the driver core sense?)  
> 
> Here "driver" would be the common term meaning the code that realizes
> a subsytem for HW - so mlx5_vfio_pci is a VFIO driver because it
> ultimately creates a /dev/vfio* through the vfio subsystem.
> 
> The same way we usually call something like mlx5_en an "ethernet
> driver" not just a "pci driver"
> 
> > Yes, sure. But it also shows that mlx5_vfio_pci aka the device-specific
> > code is rather small in comparison to the common vfio-pci code.
> > Therefore my question whether it will gain more specific changes (that
> > cannot be covered via the auxiliary driver.)  
> 
> I'm not sure what you mean "via the auxiliary driver" - there is only
> one mlx5_vfio_pci, and the non-RFC version with all the migration code
> is fairly big.
> 
> The pci_driver contributes a 'struct pci_device *' and the
> auxiliary_driver contributes a 'struct mlx5_core_dev *'. mlx5_vfio_pci
> fuses them together into a VFIO device. Depending on the VFIO
> callback, it may use an API from the pci_device or from the
> mlx5_core_dev device, or both.

Let's rephrase my question a bit:

This proposal splits the existing vfio-pci driver into a "core"
component and code actually implementing the "driver" part. For mlx5,
an alternative "driver" is introduced that reuses the "core" component
and also hooks into mlx5-specific code parts via the auxiliary device
framework. (IIUC, the plan is to make existing special cases for
devices follow mlx5's lead later.)

I've been thinking of an alternative split: Keep vfio-pci as it is now,
but add an auxiliary device. For mlx5, an auxiliary device_driver can
match to that device and implement mlx5-specific things. From the code
in this RFC, it is not clear to me whether this would be feasible: most
callbacks seem to simply forward to the core component, and that might
be possible to be done by a purely auxiliary device_driver; but this
may or may not work well for additional functionality.

I guess my question is: into which callbacks will the additional
functionality hook? If there's no good way to do what they need to do
without manipulating the vfio-pci calls, my proposal will not work, and
this proposal looks like the better way. But it's hard to tell without
seeing the code, which is why I'm asking :)

