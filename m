Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAF132E3E6
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 09:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEIr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 03:47:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhCEIq7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 03:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614934019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HV3ItQLm5tYg4/TrRKsm8TOTKMBNo0KLEUWPMy4IQL0=;
        b=cI22V3R/HWnBOmYJI1AYxCymlumOeRI+X6G7yHf/hvoEcxISomLB87MWoanlmctJkb3LCO
        Ufym4PDKevxC9ecM34ra1p+fFXc8SdyZLoe8aaIGlojJ3NkMATUaoBL5QLpo0cta7gvHB7
        bwHxtFLg1iXVWbKAi/+XU4Ibdq9rwmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-1BYAXFX0N5KqlqVKN7dJBw-1; Fri, 05 Mar 2021 03:46:57 -0500
X-MC-Unique: 1BYAXFX0N5KqlqVKN7dJBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 402A61084D6C;
        Fri,  5 Mar 2021 08:46:56 +0000 (UTC)
Received: from gondolin (ovpn-112-55.ams2.redhat.com [10.36.112.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 256E960C43;
        Fri,  5 Mar 2021 08:46:51 +0000 (UTC)
Date:   Fri, 5 Mar 2021 09:46:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: Depend on MMU
Message-ID: <20210305094649.25991311.cohuck@redhat.com>
In-Reply-To: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
References: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 4 Mar 2021 21:30:03 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> VFIO_IOMMU_TYPE1 does not compile with !MMU:
> 
> ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> 
> So require it.
> 
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 90c0525b1e0cf4..67d0bf4efa1606 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -22,7 +22,7 @@ config VFIO_VIRQFD
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	select IOMMU_API
> -	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/driver-api/vfio.rst for more details.

Actually, I'm wondering how much sense vfio makes on !MMU at all? (And
maybe just merge this with your patch that switches IOMMU_API from a
depend to a select, because that is the change that makes the MMU
dependency required?)

