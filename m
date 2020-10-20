Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FB729409C
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 18:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394711AbgJTQeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 12:34:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394705AbgJTQeY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 12:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603211662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wi4ekWyXM6YvlRg+Nj4jDYblgQENvjBZRpyYdpDJGZo=;
        b=bc8VwUVkK4g7HfqLzpHOIej5nTsIOELzyyqNLA8XmX6VFPNSoxmXQgVJzRUqSw7xqA5clG
        hqxm0pKhJYtgq8++AHejEWtWPewdzEv5s8IZT1bzmuFvXigQOXmNcgfYnPD00aGJFErXAw
        ckHBDe3Qjl4YSYBrIZMtqVXh7IbYzfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-4w9x3Ir1NkWi7jkA_47DWw-1; Tue, 20 Oct 2020 12:34:20 -0400
X-MC-Unique: 4w9x3Ir1NkWi7jkA_47DWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8483803F4E;
        Tue, 20 Oct 2020 16:34:18 +0000 (UTC)
Received: from w520.home (ovpn-112-77.phx2.redhat.com [10.3.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EDE82C31E;
        Tue, 20 Oct 2020 16:34:18 +0000 (UTC)
Date:   Tue, 20 Oct 2020 10:34:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kwankhede@nvidia.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>
Subject: Re: [PATCH] vfio iommu type1: Fix memory leak in
 vfio_iommu_type1_pin_pages
Message-ID: <20201020103417.6d2dc4a9@w520.home>
In-Reply-To: <f65f1c3c-c1bc-a44a-15ea-4cb6e43c8b4b@huawei.com>
References: <f65f1c3c-c1bc-a44a-15ea-4cb6e43c8b4b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Oct 2020 17:35:58 +0800
"xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:

> From 099744c26513e386e707faecb3f17726e236d9bc Mon Sep 17 00:00:00 2001
> From: Xiaoyang Xu <xuxiaoyang2@huawei.com>
> Date: Fri, 16 Oct 2020 15:32:02 +0800
> Subject: [PATCH] vfio iommu type1: Fix memory leak in
>  vfio_iommu_type1_pin_pages
> 
> pfn is not added to pfn_list when vfio_add_to_pfn_list fails.
> vfio_unpin_page_external will exit directly without calling
> vfio_iova_put_vfio_pfn.This will lead to a memory leak.
> 
> Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c255a6683f31..26f518b02c81 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -640,6 +640,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	unsigned long remote_vaddr;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
> +	int unlocked;
> 
>  	if (!iommu || !user_pfn || !phys_pfn)
>  		return -EINVAL;
> @@ -693,7 +694,9 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> 
>  		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
>  		if (ret) {
> -			vfio_unpin_page_external(dma, iova, do_accounting);
> +			unlocked = put_pfn(phys_pfn[i], dma->prot);
> +			if (do_accounting)
> +				vfio_lock_acct(dma, -unlocked, true);
>  			goto pin_unwind;
>  		}
> 

Thanks, this looks correct to me, but can also be simplified to:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index defd44522319..57b068abceb9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -693,7 +693,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
 		if (ret) {
-			vfio_unpin_page_external(dma, iova, do_accounting);
+			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
+				vfio_lock_acct(dma, -1, true);
 			goto pin_unwind;
 		}
 
ie. we don't need a variable to track the one page we unpin that might
be accounted and we can avoid branching to vfio_lock_acct() for -0 unlocked.

We should also add a Fixes tag so this propagates back to the relevant
stable releases:

    Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")

I've made both of these changes in my next queue, please let me know if
I've overlooked something or there's an objection.  Thanks,

Alex

