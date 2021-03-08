Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319CE331598
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 19:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCHSMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 13:12:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230124AbhCHSMS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 13:12:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615227138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JymZ/eannDMSHux1hDp4UDnEgNzTAe9TkygPp/BpQdM=;
        b=GkQxiFkP4jBytcyc/5fgqlOvFKv9syBGWzWX8RIRWzN7EpGwAZYcuggnEElgVk8w3Ui0Fi
        +AV8bxcLJcuAystkXlbOdh7ILDkTTgvsYzFTaAfuSw6PqpsfqNJKARwytzvx6HkkEtl1hj
        hzVZQBD7SRyUTekePZAtt8fnyVj+9cY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-XM2UNrN0N06yzX5cQHVE8w-1; Mon, 08 Mar 2021 13:12:16 -0500
X-MC-Unique: XM2UNrN0N06yzX5cQHVE8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 030DD1005D4A;
        Mon,  8 Mar 2021 18:12:16 +0000 (UTC)
Received: from gondolin (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 290A25D9D3;
        Mon,  8 Mar 2021 18:12:11 +0000 (UTC)
Date:   Mon, 8 Mar 2021 19:12:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: Depend on MMU
Message-ID: <20210308191209.6a355b90.cohuck@redhat.com>
In-Reply-To: <20210308105913.6f5f4ac7@omen.home.shazbot.org>
References: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
        <20210305094649.25991311.cohuck@redhat.com>
        <20210308105913.6f5f4ac7@omen.home.shazbot.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Mar 2021 10:59:13 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Fri, 5 Mar 2021 09:46:49 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Thu, 4 Mar 2021 21:30:03 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > VFIO_IOMMU_TYPE1 does not compile with !MMU:
> > > 
> > > ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> > > ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> > > 
> > > So require it.
> > > 
> > > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/vfio/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > index 90c0525b1e0cf4..67d0bf4efa1606 100644
> > > --- a/drivers/vfio/Kconfig
> > > +++ b/drivers/vfio/Kconfig
> > > @@ -22,7 +22,7 @@ config VFIO_VIRQFD
> > >  menuconfig VFIO
> > >  	tristate "VFIO Non-Privileged userspace driver framework"
> > >  	select IOMMU_API
> > > -	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> > > +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> > >  	help
> > >  	  VFIO provides a framework for secure userspace device drivers.
> > >  	  See Documentation/driver-api/vfio.rst for more details.    
> > 
> > Actually, I'm wondering how much sense vfio makes on !MMU at all? (And
> > maybe just merge this with your patch that switches IOMMU_API from a
> > depend to a select, because that is the change that makes the MMU
> > dependency required?)  
> 
> We do have the no-iommu code in vfio, potentially it's useful for !MMU,
> I guess.  It seems a little arbitrary to remove it without a known
> breakage at this point.  Thanks,
> 
> Alex

Well, in practice, I think we had an implicit dependency on MMU before
(everything selecting IOMMU_API depended on MMU.) If we think !MMU
would be useful for the no-iommu use case, we can certainly restrict
the dependency to VFIO_IOMMU_TYPE1.

