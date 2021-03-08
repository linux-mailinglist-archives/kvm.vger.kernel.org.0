Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DD0331561
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 19:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCHR7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:59:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhCHR7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 12:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615226358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toF3fiP9oJiNOZm1d5YsNNfWtM+nbtw2kvneKB7DDe0=;
        b=VKDc/nlGU+Ue476sD2oaAfN5MWo6T8dtM3+Hrnx9f6v50GW/AnUBL3CFSonNJbPP9vpxun
        gXETfkBqv5BP0pfGeD6gMBPyf0nEm7d63ryAnisDBlLRyxe9SGLvlNcKvC3qpoG9hltv2g
        dLHrUSYF8RWUD1mxBZ6Unz+ewltQDoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-igJw2CWZOFGad0P8k0hPtw-1; Mon, 08 Mar 2021 12:59:14 -0500
X-MC-Unique: igJw2CWZOFGad0P8k0hPtw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B600B814401;
        Mon,  8 Mar 2021 17:59:13 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E9795D9DB;
        Mon,  8 Mar 2021 17:59:13 +0000 (UTC)
Date:   Mon, 8 Mar 2021 10:59:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: Depend on MMU
Message-ID: <20210308105913.6f5f4ac7@omen.home.shazbot.org>
In-Reply-To: <20210305094649.25991311.cohuck@redhat.com>
References: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
        <20210305094649.25991311.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Mar 2021 09:46:49 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 4 Mar 2021 21:30:03 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > VFIO_IOMMU_TYPE1 does not compile with !MMU:
> > 
> > ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> > ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> > 
> > So require it.
> > 
> > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 90c0525b1e0cf4..67d0bf4efa1606 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -22,7 +22,7 @@ config VFIO_VIRQFD
> >  menuconfig VFIO
> >  	tristate "VFIO Non-Privileged userspace driver framework"
> >  	select IOMMU_API
> > -	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> > +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> >  	  See Documentation/driver-api/vfio.rst for more details.  
> 
> Actually, I'm wondering how much sense vfio makes on !MMU at all? (And
> maybe just merge this with your patch that switches IOMMU_API from a
> depend to a select, because that is the change that makes the MMU
> dependency required?)

We do have the no-iommu code in vfio, potentially it's useful for !MMU,
I guess.  It seems a little arbitrary to remove it without a known
breakage at this point.  Thanks,

Alex

