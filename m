Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56922321F46
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 19:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhBVSlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 13:41:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231452AbhBVSky (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 13:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614019168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vTDJEhb85J67AdQAHgz7f5oACpIbuhttKKGtn62KUTU=;
        b=JmlGlkz9UwKphqZX811+QZP/3pC3W3H54Ztz2S2MnJsJa5pRHQS/q6qvMtd+ggGB8zGvGX
        sy8lJZQPqKKYDG0xRemS4XjUA3BItCjetT90x9cUHkE3ys6vyA7CYt15LP0H7OvTjb7C2A
        yz8tMlgClj3ekgJ2NdHUIfV+3OpOrRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-O_GYt-tGMt-lFkSYootDsQ-1; Mon, 22 Feb 2021 13:39:26 -0500
X-MC-Unique: O_GYt-tGMt-lFkSYootDsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CD811020C22;
        Mon, 22 Feb 2021 18:39:25 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8ED25D9D3;
        Mon, 22 Feb 2021 18:39:12 +0000 (UTC)
Date:   Mon, 22 Feb 2021 11:39:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, jgg@nvidia.com,
        peterx@redhat.com
Subject: Re: [PATCH v2] vfio/type1: Use follow_pte()
Message-ID: <20210222113911.0ec8a4e5@omen.home.shazbot.org>
In-Reply-To: <161351571186.15573.5602248562129684350.stgit@gimli.home>
References: <161351571186.15573.5602248562129684350.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Feb 2021 15:49:34 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> follow_pfn() doesn't make sure that we're using the correct page
> protections, get the pte with follow_pte() so that we can test
> protections and get the pfn from the pte.
> 
> Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> v2: Update to current follow_pte() API, add Reviews
> 
>  drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ec9fd95a138b..ae4fd2295c95 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -463,9 +463,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  			    unsigned long vaddr, unsigned long *pfn,
>  			    bool write_fault)
>  {
> +	pte_t *ptep;
> +	spinlock_t *ptl;
>  	int ret;
>  
> -	ret = follow_pfn(vma, vaddr, pfn);
> +	ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
>  	if (ret) {
>  		bool unlocked = false;
>  
> @@ -479,9 +481,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  		if (ret)
>  			return ret;
>  
> -		ret = follow_pfn(vma, vaddr, pfn);
> +		ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
> +		if (ret)
> +			return ret;
>  	}
>  
> +	if (write_fault && !pte_write(*ptep))
> +		ret = -EFAULT;
> +	else
> +		*pfn = pte_pfn(*ptep);
> +
> +	pte_unmap_unlock(ptep, ptl);
>  	return ret;
>  }
>  
> 

Adding the following to resolve 32-bit build:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8a777250764a..ed03f3fcb07e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -24,6 +24,7 @@
 #include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/fs.h>
+#include <linux/highmem.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>

