Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E88733EE56
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhCQKcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhCQKcZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615977144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjQypPxm2stMGdffCdELwhKvCRoRLFjgfm/bTiUDhNE=;
        b=XOKk8AaTWmJmJQulT5gmTD+stlXkQ8VaIA7bag/OIrlilW2VDsEETRiflEw310PWF5POTz
        gQcn/S4pi5ICCyqVhexhjpnba5G3MB0ZStlV0k18BOUN8KQ3vb/PYXMBEiBiJqqp5eQImt
        2lbOTSU39PY88vHpyFGS9GT5CzCX8d0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-zjpDsgOnN7u6-Gi5EaqtRg-1; Wed, 17 Mar 2021 06:32:20 -0400
X-MC-Unique: zjpDsgOnN7u6-Gi5EaqtRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 755D1190A7A0;
        Wed, 17 Mar 2021 10:32:18 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42EDD690F4;
        Wed, 17 Mar 2021 10:32:09 +0000 (UTC)
Date:   Wed, 17 Mar 2021 11:32:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Message-ID: <20210317113206.2db4a57e.cohuck@redhat.com>
In-Reply-To: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:00 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
> 
> For instance vfio_pci_reflck_attach() sets vdev->reflck and
> vfio_pci_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
> 
> Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

