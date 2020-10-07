Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4528694D
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgJGUnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:43:23 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3476 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJGUnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 16:43:22 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7e285c0000>; Wed, 07 Oct 2020 13:43:08 -0700
Received: from [10.2.85.86] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 20:43:12 +0000
Subject: Re: [PATCH 02/13] drm/exynos: Use FOLL_LONGTERM for g2d cmdlists
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
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-3-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <399490f0-7738-db0b-9ed4-2510d4ea8379@nvidia.com>
Date:   Wed, 7 Oct 2020 13:43:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007164426.1812530-3-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602103388; bh=ZH2IidqacoMSnuzYghwbg6WDl/o5t7oHmVOXu9c1F+k=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=jXusZWpBkQ1E6jLC+qdDyvRga2/qZ6wGf4TnjYxb2V9EXcRc1zvX7XvzMN/x2XmRV
         amUuUeUpijEytDz23vQicMFFvEDWq9xPU19Z/hHbG+VwmOaASLw1wXJUhec1jkmflu
         JvxzAxQeYwLjgNiZTXC2Edy+0UqxsOxdmjaWFkJug7jWAt82v682QL7yxYxxxTiqYh
         BN2Ra7ou6K3nD/FomQD0uDqVCLol8vmay1Bzkqs35TZglYx3LGw/EP4RnDtgkk8ato
         6xAqVBz0QhxejE3t4KSvuT1TRFuosStCVtPLNr9nfU343+HPTrXAP2pZOBPMrqIVbo
         ASkFmOgWvs3mw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/20 9:44 AM, Daniel Vetter wrote:
> The exynos g2d interface is very unusual, but it looks like the
> userptr objects are persistent. Hence they need FOLL_LONGTERM.
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
> ---
>   drivers/gpu/drm/exynos/exynos_drm_g2d.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/ex=
ynos/exynos_drm_g2d.c
> index c83f6faac9de..514fd000feb1 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> @@ -478,7 +478,8 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct g2=
d_data *g2d,
>   		goto err_free;
>   	}
>  =20
> -	ret =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE,
> +	ret =3D pin_user_pages_fast(start, npages,
> +				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
>   				  g2d_userptr->pages);
>   	if (ret !=3D npages) {
>   		DRM_DEV_ERROR(g2d->dev,
>=20

Looks good from a pin_user_pages_fast() point of view. I'm of course not a =
exynos
developer, so we still need a look from one of those, ideally, but:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
--=20
John Hubbard
NVIDIA
