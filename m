Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A9F28A19E
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgJJVxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731025AbgJJTxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 15:53:14 -0400
Received: from coco.lan (ip5f5ad5ce.dynamic.kabel-deutschland.de [95.90.213.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E166207CD;
        Sat, 10 Oct 2020 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602321866;
        bh=/M97QDk4dmePHLGMz8L/1LDgfweGz0LFfE/UcKJE7Us=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0WfcGZ/NRaNLmDS+jOh+NTKZmtgBMPUVlTwtRgayCgG8fNqT9ga5dKdpSd17V6cdr
         HukrmYrFiRiZHk4mzgeyyRmliXyLjN62NnFMnyCvZOm9KoAKj1aPSNb/0Gk/GRwb/0
         cnkcKxRZlgiEC0lyCm9ojQx8D9uJxVDmS5Ffiehg=
Date:   Sat, 10 Oct 2020 11:24:16 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH v2 10/17] media/videbuf1|2: Mark follow_pfn usage as
 unsafe
Message-ID: <20201010112416.4259249a@coco.lan>
In-Reply-To: <20201009075934.3509076-11-daniel.vetter@ffwll.ch>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
        <20201009075934.3509076-11-daniel.vetter@ffwll.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Fri,  9 Oct 2020 09:59:27 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> escreveu:

> The media model assumes that buffers are all preallocated, so that
> when a media pipeline is running we never miss a deadline because the
> buffers aren't allocated or available.
>=20
> This means we cannot fix the v4l follow_pfn usage through
> mmu_notifier, without breaking how this all works. The only real fix
> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> tell everyone to cut over to dma-buf memory sharing for zerocopy.
>=20
> userptr for normal memory will keep working as-is.

I won't repeat here the discussions for patch 09/17, but
just to be clear about this one:

NACK.

We need a better alternative to avoid breaking existing
media applications.

>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Michel Lespinasse <walken@google.com>
> ---
>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/medi=
a/common/videobuf2/frame_vector.c
> index 2b0b97761d15..a1b85fe9e7c1 100644
> --- a/drivers/media/common/videobuf2/frame_vector.c
> +++ b/drivers/media/common/videobuf2/frame_vector.c
> @@ -69,7 +69,7 @@ int get_vaddr_frames(unsigned long start, unsigned int =
nr_frames,
>  			break;
> =20
>  		while (ret < nr_frames && start + PAGE_SIZE <=3D vma->vm_end) {
> -			err =3D follow_pfn(vma, start, &nums[ret]);
> +			err =3D unsafe_follow_pfn(vma, start, &nums[ret]);
>  			if (err) {
>  				if (ret =3D=3D 0)
>  					ret =3D err;
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/medi=
a/v4l2-core/videobuf-dma-contig.c
> index 52312ce2ba05..821c4a76ab96 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videob=
uf_dma_contig_memory *mem,
>  	user_address =3D untagged_baddr;
> =20
>  	while (pages_done < (mem->size >> PAGE_SHIFT)) {
> -		ret =3D follow_pfn(vma, user_address, &this_pfn);
> +		ret =3D unsafe_follow_pfn(vma, user_address, &this_pfn);
>  		if (ret)
>  			break;
> =20



Thanks,
Mauro
