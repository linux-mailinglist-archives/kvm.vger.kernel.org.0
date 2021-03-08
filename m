Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213D43315AA
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 19:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCHSP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 13:15:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230475AbhCHSPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 13:15:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615227309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhXr3Aup+JoRONDG/Ll127NVHPyRKYn2FZ70r6w3RZI=;
        b=cU6xLBdU0mHGoLE5Nnv/N201fIMXk/Zag/loWjaxDBDxcDMymFY0GPcM/zq7JqxDRIGl/x
        LGOrWKda75LAmueeovjxq5OakMBUzfelFFNoclq5izVS9CS/pwG1q8hPbUUkKQERcwVfv3
        3+LRX8lAwjuwyL/zmeB6ulsfltd1M6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-h7mfrAGcMTKte-RfZHIdOg-1; Mon, 08 Mar 2021 13:15:06 -0500
X-MC-Unique: h7mfrAGcMTKte-RfZHIdOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30DF58030D1;
        Mon,  8 Mar 2021 18:14:28 +0000 (UTC)
Received: from gondolin (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB52F5D9CD;
        Mon,  8 Mar 2021 18:14:23 +0000 (UTC)
Date:   Mon, 8 Mar 2021 19:14:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: Depend on MMU
Message-ID: <20210308191421.7f823b28.cohuck@redhat.com>
In-Reply-To: <20210305231141.GS4247@nvidia.com>
References: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
        <20210305094649.25991311.cohuck@redhat.com>
        <20210305231141.GS4247@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Mar 2021 19:11:41 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 05, 2021 at 09:46:49AM +0100, Cornelia Huck wrote:
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
> > >  drivers/vfio/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > index 90c0525b1e0cf4..67d0bf4efa1606 100644
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
> Why does changing depend to select affect MMU vs !MMU? Am I missing
> something?
> 
> It looks like IOMMU_API can be turned with ARM !MMU here, for
> instance:
> 
> config MSM_IOMMU
>         bool "MSM IOMMU Support"
>         depends on ARM
>         depends on ARCH_MSM8X60 || ARCH_MSM8960 || COMPILE_TEST
>         select IOMMU_API

But that one is sitting under a menu depending on MMU, isn't it?

> 
> Generally with !MMU I try to ignore it as much as possible unless
> things don't compile, as I have no idea what people use it for :)
> 
> Jason
> 

