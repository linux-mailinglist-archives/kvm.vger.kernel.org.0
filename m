Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7075433A9E4
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 04:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhCODSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 23:18:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:13924 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhCODRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 23:17:49 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DzM596d3szjJZc;
        Mon, 15 Mar 2021 11:16:13 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 11:17:42 +0800
Subject: Re: [PATCH] vfio/type1: fix vaddr_get_pfns() return in
 vfio_pin_page_external()
To:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20210308172452.38864-1-daniel.m.jordan@oracle.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <5a0f3949-2643-51b2-20f9-e6b6983e223e@huawei.com>
Date:   Mon, 15 Mar 2021 11:17:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210308172452.38864-1-daniel.m.jordan@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Daniel,

[+Cc iommu mail list]

This patch looks good to me. (but I don't test it too.)

Thanks,
Keqian

On 2021/3/9 1:24, Daniel Jordan wrote:
> vaddr_get_pfns() now returns the positive number of pfns successfully
> gotten instead of zero.  vfio_pin_page_external() might return 1 to
> vfio_iommu_type1_pin_pages(), which will treat it as an error, if
> vaddr_get_pfns() is successful but vfio_pin_page_external() doesn't
> reach vfio_lock_acct().
> 
> Fix it up in vfio_pin_page_external().  Found by inspection.
> 
> Fixes: be16c1fd99f4 ("vfio/type1: Change success value of vaddr_get_pfn()")
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> I couldn't test this due to lack of hardware.
> 
>  drivers/vfio/vfio_iommu_type1.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 4bb162c1d649..2a0e3b3ce206 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -785,7 +785,12 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>  		return -ENODEV;
>  
>  	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
> -	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
> +	if (ret != 1)
> +		goto out;
> +
> +	ret = 0;
> +
> +	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
>  		ret = vfio_lock_acct(dma, 1, true);
>  		if (ret) {
>  			put_pfn(*pfn_base, dma->prot);
> @@ -797,6 +802,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>  		}
>  	}
>  
> +out:
>  	mmput(mm);
>  	return ret;
>  }
> 
> base-commit: 144c79ef33536b4ecb4951e07dbc1f2b7fa99d32
> 
