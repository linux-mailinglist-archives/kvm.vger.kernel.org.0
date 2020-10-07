Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC22869EF
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 23:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgJGVNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 17:13:52 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16238 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgJGVNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 17:13:52 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7e2f220008>; Wed, 07 Oct 2020 14:12:02 -0700
Received: from [10.2.85.86] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 21:13:42 +0000
Subject: Re: [PATCH 05/13] mm/frame-vector: Use FOLL_LONGTERM
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-6-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <fc0ac3fb-2758-bef1-76b4-8ac2449f5743@nvidia.com>
Date:   Wed, 7 Oct 2020 14:13:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007164426.1812530-6-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602105122; bh=sdL9dWr71OcitQ1QN+LtvleGwHLKlRCYjfX+GmsKdT8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=UczOXY9to1LCj5AA/vWDFIZSxYcptbOuWof8ytMtikifjWBiV7WFE1SZd1H0LH0fv
         kOKJobR115WCn/yjDIJFRQ+hkcq+2dAKR1e6FJj4MkEmdDzg6N2N4gslr80UJRaZgX
         Lkk41XeM43UGThQQOFlbMX+h/b39dMZd63P9UIGH6zBsVqei7Fx18bJACRBf9osCOy
         57RN8QfMM60XFWH7HJJ2PGtXfTOLsVy5u8w4Kq70u1hUdIgK44rQsExvKhmLL+DdpK
         oxBJseYzqWkzebOA0vrS2YNSZyf8rdAgfIOjGviz66fazstOfGqMqtR5VpaT1zywo3
         jmYuc2NJXDq1A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/20 9:44 AM, Daniel Vetter wrote:
> This is used by media/videbuf2 for persistent dma mappings, not just
> for a single dma operation and then freed again, so needs
> FOLL_LONGTERM.
>=20
> Unfortunately current pup_locked doesn't support FOLL_LONGTERM due to
> locking issues. Rework the code to pull the pup path out from the
> mmap_sem critical section as suggested by Jason.
>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
>   mm/frame_vector.c | 36 +++++++++++-------------------------
>   1 file changed, 11 insertions(+), 25 deletions(-)
>=20
> diff --git a/mm/frame_vector.c b/mm/frame_vector.c
> index 10f82d5643b6..39db520a51dc 100644
> --- a/mm/frame_vector.c
> +++ b/mm/frame_vector.c
> @@ -38,7 +38,6 @@ int get_vaddr_frames(unsigned long start, unsigned int =
nr_frames,
>   	struct vm_area_struct *vma;
>   	int ret =3D 0;
>   	int err;
> -	int locked;
>  =20
>   	if (nr_frames =3D=3D 0)
>   		return 0;
> @@ -48,35 +47,22 @@ int get_vaddr_frames(unsigned long start, unsigned in=
t nr_frames,
>  =20
>   	start =3D untagged_addr(start);
>  =20
> +	ret =3D pin_user_pages_fast(start, nr_frames,
> +				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
> +				  (struct page **)(vec->ptrs));
> +	if (ret > 0) {
> +		vec->got_ref =3D true;
> +		vec->is_pfns =3D false;
> +		goto out_unlocked;
> +	}

This part looks good, and changing to _fast is a potential performance impr=
ovement,
too.

> +
>   	mmap_read_lock(mm);
> -	locked =3D 1;
>   	vma =3D find_vma_intersection(mm, start, start + 1);
>   	if (!vma) {
>   		ret =3D -EFAULT;
>   		goto out;
>   	}
>  =20
> -	/*
> -	 * While get_vaddr_frames() could be used for transient (kernel
> -	 * controlled lifetime) pinning of memory pages all current
> -	 * users establish long term (userspace controlled lifetime)
> -	 * page pinning. Treat get_vaddr_frames() like
> -	 * get_user_pages_longterm() and disallow it for filesystem-dax
> -	 * mappings.
> -	 */
> -	if (vma_is_fsdax(vma)) {
> -		ret =3D -EOPNOTSUPP;
> -		goto out;
> -	}

Are you sure we don't need to check vma_is_fsdax() anymore?

> -
> -	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> -		vec->got_ref =3D true;
> -		vec->is_pfns =3D false;
> -		ret =3D pin_user_pages_locked(start, nr_frames,
> -			gup_flags, (struct page **)(vec->ptrs), &locked);
> -		goto out;
> -	}
> -
>   	vec->got_ref =3D false;
>   	vec->is_pfns =3D true;
>   	do {
> @@ -101,8 +87,8 @@ int get_vaddr_frames(unsigned long start, unsigned int=
 nr_frames,
>   		vma =3D find_vma_intersection(mm, start, start + 1);
>   	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
>   out:
> -	if (locked)
> -		mmap_read_unlock(mm);
> +	mmap_read_unlock(mm);
> +out_unlocked:
>   	if (!ret)
>   		ret =3D -EFAULT;
>   	if (ret > 0)
>=20

All of the error handling still looks accurate there.

thanks,
--=20
John Hubbard
NVIDIA
