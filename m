Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D438D17627
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 12:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfEHKne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 06:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfEHKne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 06:43:34 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 645F1C060200;
        Wed,  8 May 2019 10:43:33 +0000 (UTC)
Received: from gondolin (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3FD7600D4;
        Wed,  8 May 2019 10:43:31 +0000 (UTC)
Date:   Wed, 8 May 2019 12:43:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] s390/cio: Split pfn_array_alloc_pin into pieces
Message-ID: <20190508124327.5c496c8a.cohuck@redhat.com>
In-Reply-To: <20190503134912.39756-4-farman@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 08 May 2019 10:43:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 May 2019 15:49:08 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The pfn_array_alloc_pin routine is doing too much.  Today, it does the
> alloc of the pfn_array struct and its member arrays, builds the iova
> address lists out of a contiguous piece of guest memory, and asks vfio
> to pin the resulting pages.
> 
> Let's effectively revert a significant portion of commit 5c1cfb1c3948
> ("vfio: ccw: refactor and improve pfn_array_alloc_pin()") such that we
> break pfn_array_alloc_pin() into its component pieces, and have one
> routine that allocates/populates the pfn_array structs, and another
> that actually pins the memory.  In the future, we will be able to
> handle scenarios where pinning memory isn't actually appropriate.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 72 +++++++++++++++++++++++++++---------------
>  1 file changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index f86da78eaeaa..b70306c06150 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -50,28 +50,25 @@ struct ccwchain {
>  };
>  
>  /*
> - * pfn_array_alloc_pin() - alloc memory for PFNs, then pin user pages in memory
> + * pfn_array_alloc() - alloc memory for PFNs
>   * @pa: pfn_array on which to perform the operation
> - * @mdev: the mediated device to perform pin/unpin operations
>   * @iova: target guest physical address
>   * @len: number of bytes that should be pinned from @iova
>   *
> - * Attempt to allocate memory for PFNs, and pin user pages in memory.
> + * Attempt to allocate memory for PFN.

s/PFN/PFNs/

>   *
>   * Usage of pfn_array:
>   * We expect (pa_nr == 0) and (pa_iova_pfn == NULL), any field in
>   * this structure will be filled in by this function.
>   *
>   * Returns:
> - *   Number of pages pinned on success.
> - *   If @pa->pa_nr is not 0, or @pa->pa_iova_pfn is not NULL initially,
> - *   returns -EINVAL.
> - *   If no pages were pinned, returns -errno.
> + *         0 if PFNs are allocated
> + *   -EINVAL if pa->pa_nr is not initially zero, or pa->pa_iova_pfn is not NULL
> + *   -ENOMEM if alloc failed
>   */
> -static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
> -			       u64 iova, unsigned int len)
> +static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
>  {
> -	int i, ret = 0;
> +	int i;
>  
>  	if (!len)
>  		return 0;
> @@ -97,23 +94,33 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
>  	for (i = 1; i < pa->pa_nr; i++)
>  		pa->pa_iova_pfn[i] = pa->pa_iova_pfn[i - 1] + 1;
>  
> +	return 0;
> +}
> +
> +/*
> + * pfn_array_pin() - Pin user pages in memory
> + * @pa: pfn_array on which to perform the operation
> + * @mdev: the mediated device to perform pin operations
> + *
> + * Returns:
> + *   Number of pages pinned on success.
> + *   If fewer pages than requested were pinned, returns -EINVAL
> + *   If no pages were pinned, returns -errno.

I don't really like the 'returns -errno' :) It's actually the return
code of vfio_pin_pages(), and that might include -EINVAL as well.

So, what about mentioning in the function description that
pfn_array_pin() only succeeds if it coult pin all pages, and simply
stating that it returns a negative error value on failure?

> + */
> +static int pfn_array_pin(struct pfn_array *pa, struct device *mdev)
> +{
> +	int ret = 0;
> +
>  	ret = vfio_pin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr,
>  			     IOMMU_READ | IOMMU_WRITE, pa->pa_pfn);
>  
> -	if (ret < 0) {
> -		goto err_out;
> -	} else if (ret > 0 && ret != pa->pa_nr) {
> +	if (ret > 0 && ret != pa->pa_nr) {
>  		vfio_unpin_pages(mdev, pa->pa_iova_pfn, ret);
>  		ret = -EINVAL;
> -		goto err_out;
>  	}
>  
> -	return ret;
> -
> -err_out:
> -	pa->pa_nr = 0;
> -	kfree(pa->pa_iova_pfn);
> -	pa->pa_iova_pfn = NULL;
> +	if (ret < 0)
> +		pa->pa_iova = 0;
>  
>  	return ret;
>  }

(...)
