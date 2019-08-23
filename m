Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5B99B7CF
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 22:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392546AbfHWUoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 16:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388903AbfHWUop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 16:44:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D268A2892A;
        Fri, 23 Aug 2019 20:44:45 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D08B5D6B2;
        Fri, 23 Aug 2019 20:44:44 +0000 (UTC)
Date:   Fri, 23 Aug 2019 14:44:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>
Subject: Re: [PATCH kernel] vfio/spapr_tce: Fix incorrect tce_iommu_group
 memory free
Message-ID: <20190823144438.03238f16@x1.home>
In-Reply-To: <20190819015117.94878-1-aik@ozlabs.ru>
References: <20190819015117.94878-1-aik@ozlabs.ru>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Fri, 23 Aug 2019 20:44:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Aug 2019 11:51:17 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> The @tcegrp variable is used in 1) a loop over attached groups
> 2) it stores a pointer to a newly allocated tce_iommu_group if 1) found
> nothing. However the error handler does not distinguish how we got there
> and incorrectly releases memory for a found+incompatible group.
> 
> This fixes it by adding another error handling case.
> 
> Fixes: 0bd971676e68 ("powerpc/powernv/npu: Add compound IOMMU groups")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---

Applied to vfio next branch with Paul's R-b.  Thanks,

Alex

> 
> The bug is there since 2157e7b82f3b but it would not appear in practice
> before 0bd971676e68, hence that "Fixes". Or it still should be
> 157e7b82f3b ("vfio: powerpc/spapr: Register memory and define IOMMU v2")
> ?
> 
> Found it when tried adding a "compound PE" (GPU + NPUs) to a container
> with a passed through xHCI host. The compatibility test (->create_table
> should be equal) treats them as incompatible which might a bug (or
> we are just suboptimal here) on its own.
> 
> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 8ce9ad21129f..babef8b00daf 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -1234,7 +1234,7 @@ static long tce_iommu_take_ownership_ddw(struct tce_container *container,
>  static int tce_iommu_attach_group(void *iommu_data,
>  		struct iommu_group *iommu_group)
>  {
> -	int ret;
> +	int ret = 0;
>  	struct tce_container *container = iommu_data;
>  	struct iommu_table_group *table_group;
>  	struct tce_iommu_group *tcegrp = NULL;
> @@ -1287,13 +1287,13 @@ static int tce_iommu_attach_group(void *iommu_data,
>  			!table_group->ops->release_ownership) {
>  		if (container->v2) {
>  			ret = -EPERM;
> -			goto unlock_exit;
> +			goto free_exit;
>  		}
>  		ret = tce_iommu_take_ownership(container, table_group);
>  	} else {
>  		if (!container->v2) {
>  			ret = -EPERM;
> -			goto unlock_exit;
> +			goto free_exit;
>  		}
>  		ret = tce_iommu_take_ownership_ddw(container, table_group);
>  		if (!tce_groups_attached(container) && !container->tables[0])
> @@ -1305,10 +1305,11 @@ static int tce_iommu_attach_group(void *iommu_data,
>  		list_add(&tcegrp->next, &container->group_list);
>  	}
>  
> -unlock_exit:
> +free_exit:
>  	if (ret && tcegrp)
>  		kfree(tcegrp);
>  
> +unlock_exit:
>  	mutex_unlock(&container->lock);
>  
>  	return ret;

