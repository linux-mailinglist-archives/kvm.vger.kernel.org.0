Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25E228FF4F
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 09:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404755AbgJPHm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 03:42:27 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2632 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404710AbgJPHm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Oct 2020 03:42:27 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f894ed60000>; Fri, 16 Oct 2020 00:42:14 -0700
Received: from [10.2.49.77] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 07:42:17 +0000
Subject: Re: [PATCH v2 01/17] drm/exynos: Stop using frame_vector helpers
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "Seung-Woo Kim" <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-2-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <b1529241-a645-6e03-2031-cb2d0a6de493@nvidia.com>
Date:   Fri, 16 Oct 2020 00:42:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009075934.3509076-2-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602834134; bh=0aE9d/+DUnCDZnC0MmsV9767F6olBrZ/z/bqT8CABIE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=qafhaKQkqbDz6B1AQvEqkAlsZ2wvvxxy3liQgg/I2n/ULg20xCUiIlLAGKfOrDFbr
         ceoOhJqnaFxeEBdV9ZyHoihaNP6Y7fwttq1CADxMzc02pGDu6VhiYT4r+niYN2SgmQ
         uGmPACXn3SSz5j5dFYjRoZY/+Mrq7tjnF4FXvsh2m4wH2AH17u27/ZyvctCi5w00pi
         0KLehFCXYJ589hr30t/KynvRtlNSSPHafzdq5WTQVzdi6M+21sKkrRvffEX2wbaeq0
         VgPWKESwn1uBRAiy722SCSSUnBZPuT7/iCtsX1reQo7i7IUd5KtWfD+25tG5clM1pU
         nny43JIsIiugw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/9/20 12:59 AM, Daniel Vetter wrote:
> All we need are a pages array, pin_user_pages_fast can give us that
> directly. Plus this avoids the entire raw pfn side of get_vaddr_frames.
>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> --
> v2: Use unpin_user_pages_dirty_lock (John)
> ---
>   drivers/gpu/drm/exynos/Kconfig          |  1 -
>   drivers/gpu/drm/exynos/exynos_drm_g2d.c | 47 +++++++++++--------------
>   2 files changed, 20 insertions(+), 28 deletions(-)
>=20

Looks good.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
--=20
John Hubbard
NVIDIA

> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kcon=
fig
> index 6417f374b923..43257ef3c09d 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -88,7 +88,6 @@ comment "Sub-drivers"
>   config DRM_EXYNOS_G2D
>   	bool "G2D"
>   	depends on VIDEO_SAMSUNG_S5P_G2D=3Dn || COMPILE_TEST
> -	select FRAME_VECTOR
>   	help
>   	  Choose this option if you want to use Exynos G2D for DRM.
>  =20
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/ex=
ynos/exynos_drm_g2d.c
> index 967a5cdc120e..ecede41af9b9 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> @@ -205,7 +205,8 @@ struct g2d_cmdlist_userptr {
>   	dma_addr_t		dma_addr;
>   	unsigned long		userptr;
>   	unsigned long		size;
> -	struct frame_vector	*vec;
> +	struct page		**pages;
> +	unsigned int		npages;
>   	struct sg_table		*sgt;
>   	atomic_t		refcount;
>   	bool			in_pool;
> @@ -378,7 +379,6 @@ static void g2d_userptr_put_dma_addr(struct g2d_data =
*g2d,
>   					bool force)
>   {
>   	struct g2d_cmdlist_userptr *g2d_userptr =3D obj;
> -	struct page **pages;
>  =20
>   	if (!obj)
>   		return;
> @@ -398,15 +398,9 @@ static void g2d_userptr_put_dma_addr(struct g2d_data=
 *g2d,
>   	dma_unmap_sgtable(to_dma_dev(g2d->drm_dev), g2d_userptr->sgt,
>   			  DMA_BIDIRECTIONAL, 0);
>  =20
> -	pages =3D frame_vector_pages(g2d_userptr->vec);
> -	if (!IS_ERR(pages)) {
> -		int i;
> -
> -		for (i =3D 0; i < frame_vector_count(g2d_userptr->vec); i++)
> -			set_page_dirty_lock(pages[i]);
> -	}
> -	put_vaddr_frames(g2d_userptr->vec);
> -	frame_vector_destroy(g2d_userptr->vec);
> +	unpin_user_pages_dirty_lock(g2d_userptr->pages, g2d_userptr->npages,
> +				    true);
> +	kvfree(g2d_userptr->pages);
>  =20
>   	if (!g2d_userptr->out_of_list)
>   		list_del_init(&g2d_userptr->list);
> @@ -474,35 +468,34 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct =
g2d_data *g2d,
>   	offset =3D userptr & ~PAGE_MASK;
>   	end =3D PAGE_ALIGN(userptr + size);
>   	npages =3D (end - start) >> PAGE_SHIFT;
> -	g2d_userptr->vec =3D frame_vector_create(npages);
> -	if (!g2d_userptr->vec) {
> +	g2d_userptr->pages =3D kvmalloc_array(npages, sizeof(*g2d_userptr->page=
s),
> +					    GFP_KERNEL);
> +	if (!g2d_userptr->pages) {
>   		ret =3D -ENOMEM;
>   		goto err_free;
>   	}
>  =20
> -	ret =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
> -		g2d_userptr->vec);
> +	ret =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
> +				  g2d_userptr->pages);
>   	if (ret !=3D npages) {
>   		DRM_DEV_ERROR(g2d->dev,
>   			      "failed to get user pages from userptr.\n");
>   		if (ret < 0)
> -			goto err_destroy_framevec;
> -		ret =3D -EFAULT;
> -		goto err_put_framevec;
> -	}
> -	if (frame_vector_to_pages(g2d_userptr->vec) < 0) {
> +			goto err_destroy_pages;
> +		npages =3D ret;
>   		ret =3D -EFAULT;
> -		goto err_put_framevec;
> +		goto err_unpin_pages;
>   	}
> +	g2d_userptr->npages =3D npages;
>  =20
>   	sgt =3D kzalloc(sizeof(*sgt), GFP_KERNEL);
>   	if (!sgt) {
>   		ret =3D -ENOMEM;
> -		goto err_put_framevec;
> +		goto err_unpin_pages;
>   	}
>  =20
>   	ret =3D sg_alloc_table_from_pages(sgt,
> -					frame_vector_pages(g2d_userptr->vec),
> +					g2d_userptr->pages,
>   					npages, offset, size, GFP_KERNEL);
>   	if (ret < 0) {
>   		DRM_DEV_ERROR(g2d->dev, "failed to get sgt from pages.\n");
> @@ -538,11 +531,11 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct =
g2d_data *g2d,
>   err_free_sgt:
>   	kfree(sgt);
>  =20
> -err_put_framevec:
> -	put_vaddr_frames(g2d_userptr->vec);
> +err_unpin_pages:
> +	unpin_user_pages(g2d_userptr->pages, npages);
>  =20
> -err_destroy_framevec:
> -	frame_vector_destroy(g2d_userptr->vec);
> +err_destroy_pages:
> +	kvfree(g2d_userptr->pages);
>  =20
>   err_free:
>   	kfree(g2d_userptr);
>=20

