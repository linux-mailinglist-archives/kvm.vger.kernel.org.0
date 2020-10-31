Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097B2A132D
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 03:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgJaCz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 22:55:29 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4027 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgJaCz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 22:55:28 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9cd2220000>; Fri, 30 Oct 2020 19:55:30 -0700
Received: from [10.2.58.85] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 31 Oct
 2020 02:55:18 +0000
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Tomasz Figa" <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
 <20201030100815.2269-6-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <446b2d5b-a1a1-a408-f884-f17a04b72c18@nvidia.com>
Date:   Fri, 30 Oct 2020 19:55:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201030100815.2269-6-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604112930; bh=kIbuOrZMF2YQAWfUPs6gkqYbyNybPPlpG1DHBddVTeI=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=AtOxaAfNPVF2Y8gZFgz8BlJTCY2WnS/ll/uZOpZY6ZM3sYeZDX0wsWzg9kbJTYbtL
         uIT7SI94Nu0DAKox4tjTnJcLN8XQH4afRazJUVETQXmRDSkforw/ZyajpCSjQdhakD
         V5TkHQG1hyUHjxO5/EziqQ5QU5HsvmsdLhy0c2pJ17Ik4sdOeRb9MDZW7AgVbI6HUp
         khbiVPlvAQBqPZreVxuJwdPBCd0dFyD9l044fmdbRBxITLNtDeDmPV0I8qXzaQGtcL
         05gwU5zD1T2KQ11VFOtz4tXHAh7iSeMGU/Zo8kgIrMlYShlD2P3PVWKbYJ1hjOt5Cc
         x4G0lu6VoJy1w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/30/20 3:08 AM, Daniel Vetter wrote:
> This is used by media/videbuf2 for persistent dma mappings, not just
> for a single dma operation and then freed again, so needs
> FOLL_LONGTERM.
>=20
> Unfortunately current pup_locked doesn't support FOLL_LONGTERM due to
> locking issues. Rework the code to pull the pup path out from the
> mmap_sem critical section as suggested by Jason.
>=20
> By relying entirely on the vma checks in pin_user_pages and follow_pfn

There are vma checks in pin_user_pages(), but this patch changes things
to call pin_user_pages_fast(). And that does not have the vma checks.
More below about this:

> (for vm_flags and vma_is_fsdax) we can also streamline the code a lot.
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
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v2: Streamline the code and further simplify the loop checks (Jason)
>=20
> v5: Review from Tomasz:
> - fix page counting for the follow_pfn case by resetting ret
> - drop gup_flags paramater, now unused
> ---
>   .../media/common/videobuf2/videobuf2-memops.c |  3 +-
>   include/linux/mm.h                            |  2 +-
>   mm/frame_vector.c                             | 53 ++++++-------------
>   3 files changed, 19 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/media/common/videobuf2/videobuf2-memops.c b/drivers/=
media/common/videobuf2/videobuf2-memops.c
> index 6e9e05153f4e..9dd6c27162f4 100644
> --- a/drivers/media/common/videobuf2/videobuf2-memops.c
> +++ b/drivers/media/common/videobuf2/videobuf2-memops.c
> @@ -40,7 +40,6 @@ struct frame_vector *vb2_create_framevec(unsigned long =
start,
>   	unsigned long first, last;
>   	unsigned long nr;
>   	struct frame_vector *vec;
> -	unsigned int flags =3D FOLL_FORCE | FOLL_WRITE;
>  =20
>   	first =3D start >> PAGE_SHIFT;
>   	last =3D (start + length - 1) >> PAGE_SHIFT;
> @@ -48,7 +47,7 @@ struct frame_vector *vb2_create_framevec(unsigned long =
start,
>   	vec =3D frame_vector_create(nr);
>   	if (!vec)
>   		return ERR_PTR(-ENOMEM);
> -	ret =3D get_vaddr_frames(start & PAGE_MASK, nr, flags, vec);
> +	ret =3D get_vaddr_frames(start & PAGE_MASK, nr, vec);
>   	if (ret < 0)
>   		goto out_destroy;
>   	/* We accept only complete set of PFNs */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ef360fe70aaf..d6b8e30dce2e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1765,7 +1765,7 @@ struct frame_vector {
>   struct frame_vector *frame_vector_create(unsigned int nr_frames);
>   void frame_vector_destroy(struct frame_vector *vec);
>   int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
> -		     unsigned int gup_flags, struct frame_vector *vec);
> +		     struct frame_vector *vec);
>   void put_vaddr_frames(struct frame_vector *vec);
>   int frame_vector_to_pages(struct frame_vector *vec);
>   void frame_vector_to_pfns(struct frame_vector *vec);
> diff --git a/mm/frame_vector.c b/mm/frame_vector.c
> index 10f82d5643b6..f8c34b895c76 100644
> --- a/mm/frame_vector.c
> +++ b/mm/frame_vector.c
> @@ -32,13 +32,12 @@
>    * This function takes care of grabbing mmap_lock as necessary.
>    */
>   int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
> -		     unsigned int gup_flags, struct frame_vector *vec)
> +		     struct frame_vector *vec)
>   {
>   	struct mm_struct *mm =3D current->mm;
>   	struct vm_area_struct *vma;
>   	int ret =3D 0;
>   	int err;
> -	int locked;
>  =20
>   	if (nr_frames =3D=3D 0)
>   		return 0;
> @@ -48,40 +47,26 @@ int get_vaddr_frames(unsigned long start, unsigned in=
t nr_frames,
>  =20
>   	start =3D untagged_addr(start);
>  =20
> -	mmap_read_lock(mm);
> -	locked =3D 1;
> -	vma =3D find_vma_intersection(mm, start, start + 1);
> -	if (!vma) {
> -		ret =3D -EFAULT;
> -		goto out;
> -	}
> -
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
> -
> -	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {

By removing this check from this location, and changing from
pin_user_pages_locked() to pin_user_pages_fast(), I *think* we end up
losing the check entirely. Is that intended? If so it could use a comment
somewhere to explain why.

thanks,
--=20
John Hubbard
NVIDIA

> +	ret =3D pin_user_pages_fast(start, nr_frames,
> +				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
> +				  (struct page **)(vec->ptrs));
> +	if (ret > 0) {
>   		vec->got_ref =3D true;
>   		vec->is_pfns =3D false;
> -		ret =3D pin_user_pages_locked(start, nr_frames,
> -			gup_flags, (struct page **)(vec->ptrs), &locked);
> -		goto out;
> +		goto out_unlocked;
>   	}
>  =20
> +	mmap_read_lock(mm);
>   	vec->got_ref =3D false;
>   	vec->is_pfns =3D true;
> +	ret =3D 0;
>   	do {
>   		unsigned long *nums =3D frame_vector_pfns(vec);
>  =20
> +		vma =3D find_vma_intersection(mm, start, start + 1);
> +		if (!vma)
> +			break;
> +
>   		while (ret < nr_frames && start + PAGE_SIZE <=3D vma->vm_end) {
>   			err =3D follow_pfn(vma, start, &nums[ret]);
>   			if (err) {
> @@ -92,17 +77,13 @@ int get_vaddr_frames(unsigned long start, unsigned in=
t nr_frames,
>   			start +=3D PAGE_SIZE;
>   			ret++;
>   		}
> -		/*
> -		 * We stop if we have enough pages or if VMA doesn't completely
> -		 * cover the tail page.
> -		 */
> -		if (ret >=3D nr_frames || start < vma->vm_end)
> +		/* Bail out if VMA doesn't completely cover the tail page. */
> +		if (start < vma->vm_end)
>   			break;
> -		vma =3D find_vma_intersection(mm, start, start + 1);
> -	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
> +	} while (ret < nr_frames);
>   out:
> -	if (locked)
> -		mmap_read_unlock(mm);
> +	mmap_read_unlock(mm);
> +out_unlocked:
>   	if (!ret)
>   		ret =3D -EFAULT;
>   	if (ret > 0)
>=20


