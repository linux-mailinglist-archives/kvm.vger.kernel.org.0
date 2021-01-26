Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C737130343F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbhAZFUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732216AbhAZDgK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 22:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611632083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02N5Vo1eCr9M++YAgPuzvjZrS1xRN+i5oD141ner4dg=;
        b=RPZTl+xiZUpSkcYXf+jKXl21iaXkEoVV/XADlGeEVfjvh/ByB5+uDUk8eZyhzC/g4EBPz7
        jL7f+gbtHN0Da0GB2vAErp5pYjd7KWE9Tz8/Qk0gBiFWpvLSOyNiYO/LJm5doFBT9uE2uX
        LKFeSBmq9LZSNs8JwG6zuN2PKLqc4+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-7XZ1YnDwPgm3HZwk074elA-1; Mon, 25 Jan 2021 22:34:38 -0500
X-MC-Unique: 7XZ1YnDwPgm3HZwk074elA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 885A059;
        Tue, 26 Jan 2021 03:34:36 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EBDB10013C1;
        Tue, 26 Jan 2021 03:34:35 +0000 (UTC)
Date:   Mon, 25 Jan 2021 20:34:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210125203429.587c20fd@x1.home.shazbot.org>
In-Reply-To: <20210126004522.GD4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210122122503.4e492b96@omen.home.shazbot.org>
        <20210122200421.GH4147@nvidia.com>
        <20210125172035.3b61b91b.cohuck@redhat.com>
        <20210125180440.GR4147@nvidia.com>
        <20210125163151.5e0aeecb@omen.home.shazbot.org>
        <20210126004522.GD4147@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 20:45:22 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:
> 
> > We're supposed to be enlightened by a vendor driver that does nothing
> > more than pass the opaque device_data through to the core functions,
> > but in reality this is exactly the point of concern above.  At a
> > minimum that vendor driver needs to look at the vdev to get the
> > pdev,  
> 
> The end driver already havs the pdev, the RFC doesn't go enough into
> those bits, it is a good comment.
> 
> The dd_data pased to the vfio_create_pci_device() will be retrieved
> from the ops to get back to the end drivers data. This can cleanly
> include everything: the VF pci_device, PF pci_device, mlx5_core
> pointer, vfio_device and vfio_pci_device.
> 
> This is why the example passes in the mvadev:
> 
> +	vdev = vfio_create_pci_device(pdev, &mlx5_vfio_pci_ops, mvadev);
> 
> The mvadev has the PF, VF, and mlx5 core driver pointer.
> 
> Getting that back out during the ops is enough to do what the mlx5
> driver needs to do, which is relay migration related IOCTLs to the PF
> function via the mlx5_core driver so the device can execute them on
> behalf of the VF.
> 
> > but then what else does it look at, consume, or modify.  Now we have
> > vendor drivers misusing the core because it's not clear which fields
> > are private and how public fields can be used safely,  
> 
> The kernel has never followed rigid rules for data isolation, it is
> normal to have whole private structs exposed in headers so that
> container_of can be used to properly compose data structures.

I reject this assertion, there are plenty of structs that clearly
indicate private vs public data or, as we've done in mdev, clearly
marking the private data in a "private" header and provide access
functions for public fields.  Including a "private" header to make use
of a "library" is just wrong.  In the example above, there's no way for
the mlx vendor driver to get back dd_data without extracting it from
struct vfio_pci_device itself.

> Look at struct device, for instance. Most of that is private to the
> driver core.
> 
> A few 'private to vfio-pci-core' comments would help, it is good
> feedback to make that more clear.
> 
> > extensions potentially break vendor drivers, etc.  We're only even hand
> > waving that existing device specific support could be farmed out to new
> > device specific drivers without even going to the effort to prove that.  
> 
> This is a RFC, not a complete patch series. The RFC is to get feedback
> on the general design before everyone comits alot of resources and
> positions get dug in.
> 
> Do you really think the existing device specific support would be a
> problem to lift? It already looks pretty clean with the
> vfio_pci_regops, looks easy enough to lift to the parent.
> 
> > So far the TODOs rather mask the dirty little secrets of the
> > extension rather than showing how a vendor derived driver needs to
> > root around in struct vfio_pci_device to do something useful, so
> > probably porting actual device specific support rather than further
> > hand waving would be more helpful.   
> 
> It would be helpful to get actual feedback on the high level design -
> someting like this was already tried in May and didn't go anywhere -
> are you surprised that we are reluctant to commit alot of resources
> doing a complete job just to have it go nowhere again?

That's not really what I'm getting from your feedback, indicating
vfio-pci is essentially done, the mlx stub driver should be enough to
see the direction, and additional concerns can be handled with TODO
comments.  Sorry if this is not construed as actual feedback, I think
both Connie and I are making an effort to understand this and being
hampered by lack of a clear api or a vendor driver that's anything more
than vfio-pci plus an aux bus interface.  Thanks,

Alex

