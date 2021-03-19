Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EEE342379
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 18:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhCSRhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 13:37:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229926AbhCSRgw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 13:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616175411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XvK0V0qzHhIii8GbFFuNd+vQ7faSsEtxcOA7tbbvbKQ=;
        b=jGdAhyB4T3ZzsoTw1s2bxaePEuo96qHdWz6ltD7J8astTT9z1H4Ix7zzutxfMWuBd/d2Qe
        LYS7wvticANZ8Lnbo2deuGSOSGAO3szBbrOTtzOfoNoj0TeoGa9NYAYhdY2RYY6BZXnNhc
        GtG8ogDrO8IfZVTmQXCuZBX7CtlrqJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-_igWD4-vM_2pE7XfVsgbcw-1; Fri, 19 Mar 2021 13:36:47 -0400
X-MC-Unique: _igWD4-vM_2pE7XfVsgbcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B74B2800D53;
        Fri, 19 Mar 2021 17:36:44 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E0611C936;
        Fri, 19 Mar 2021 17:36:43 +0000 (UTC)
Date:   Fri, 19 Mar 2021 11:36:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319113642.4a9b0be1@omen.home.shazbot.org>
In-Reply-To: <20210319163449.GA19186@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
        <20210309083357.65467-9-mgurtovoy@nvidia.com>
        <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
        <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
        <20210319092341.14bb179a@omen.home.shazbot.org>
        <20210319161722.GY2356281@nvidia.com>
        <20210319162033.GA18218@lst.de>
        <20210319162848.GZ2356281@nvidia.com>
        <20210319163449.GA19186@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Mar 2021 17:34:49 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Mar 19, 2021 at 01:28:48PM -0300, Jason Gunthorpe wrote:
> > The wrinkle I don't yet have an easy answer to is how to load vfio_pci
> > as a universal "default" within the driver core lazy bind scheme and
> > still have working module autoloading... I'm hoping to get some
> > research into this..  

What about using MODULE_SOFTDEP("pre: ...") in the vfio-pci base
driver, which would load all the known variants in order to influence
the match, and therefore probe ordering?

If we coupled that with wildcard support in driver_override, ex.
"vfio_pci*", and used consistent module naming, I think we'd only need
to teach userspace about this wildcard and binding to a specific module
would come for free.  This assumes we drop the per-variant id_table and
use the probe function to skip devices without the necessary
requirements, either wrong device or missing the tables we expect to
expose.

> Should we even load it by default?  One answer would be that the sysfs
> file to switch to vfio mode goes into the core PCI layer, and that core
> PCI code would contain a hack^H^H^H^Hhook to first load and bind vfio_pci
> for that device.

Generally we don't want to be the default driver for anything (I think
mdev devices are the exception).  Assignment to userspace or VM is a
niche use case.  Thanks,

Alex

