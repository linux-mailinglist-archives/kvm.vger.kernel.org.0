Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85E42B4B42
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 17:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgKPQd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 11:33:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgKPQd4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 11:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605544434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SjxdMqwSyKAGv9WhgJGc+WE1T/pJc/aXptB9FUvKLQ=;
        b=AnFuIj8FmBbqfvxtc/HnqaIUj8IumIZFGfCyxIB+9bedX3LWWonWrJos4sMOdd9w5Z/dSI
        W/d5Ay/+ixrCQ/SyVCNzWEU0XM7eYv/i67mjG7JXJZKjKm8T14zthiPS/V/vDd6OT0WrJ1
        aO4Uo6fGr1NjtXD/gwgKGE7mEAY1wMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-EaP2LlGaNCiaRdnSElqrug-1; Mon, 16 Nov 2020 11:33:52 -0500
X-MC-Unique: EaP2LlGaNCiaRdnSElqrug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A3EC90542D;
        Mon, 16 Nov 2020 16:33:51 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C2AF5C1D0;
        Mon, 16 Nov 2020 16:33:50 +0000 (UTC)
Date:   Mon, 16 Nov 2020 09:33:49 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>
Subject: Re: [PATCH] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
Message-ID: <20201116093349.19fb84c1@w520.home>
In-Reply-To: <f55c48b5-d315-ab36-90e4-690362a15cc2@huawei.com>
References: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
        <20201113094417.51d73615@w520.home>
        <f55c48b5-d315-ab36-90e4-690362a15cc2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Nov 2020 21:47:33 +0800
"xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:

> On 2020/11/14 0:44, Alex Williamson wrote:
> > On Tue, 10 Nov 2020 21:42:33 +0800
> > "xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:
> >  =20
> >> vfio_iommu_type1_pin_pages is very inefficient because
> >> it is processed page by page when calling vfio_pin_page_external.
> >> Added contiguous_vaddr_get_pfn to process continuous pages
> >> to reduce the number of loops, thereby improving performance.
> >>
> >> Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 241 ++++++++++++++++++++++++++++----
> >>  1 file changed, 214 insertions(+), 27 deletions(-) =20
> >=20
> > Sorry for my previous misunderstanding of the logic here.  Still, this
> > adds a lot of complexity, can you quantify the performance improvement
> > you're seeing?  Would it instead be more worthwhile to support an
> > interface that pins based on an iova and range?  Further comments below.
> >  =20
> Thank you for your reply.  I have a set of performance test data for refe=
rence.
> The host kernel version of my test environment is 4.19.36, and the test c=
ases
> are for pin one page and 512 pages.  When pin 512pages, the input is a
> continuous iova address.  At the same time increase the measurement facto=
r of
> whether the mem backend uses large pages.  The following is the average of
> multiple tests.
>=20
> The patch was not applied
>                     1 page           512 pages
> no huge pages=EF=BC=9A     1638ns           223651ns
> THP=EF=BC=9A               1668ns           222330ns
> HugeTLB=EF=BC=9A           1526ns           208151ns
>=20
> The patch was applied
>                     1 page           512 pages
> no huge pages       1735ns           167286ns
> THP=EF=BC=9A               1934ns           126900ns
> HugeTLB=EF=BC=9A           1713ns           102188ns
>=20
> The performance will be reduced when the page is fixed with a single pin,
> while the page time of continuous pins can be reduced to half of the orig=
inal.
> If you have other suggestions for testing methods, please let me know.

These are artificial test results, which in fact show a performance
decrease for the single page use cases.  What do we see in typical real
world scenarios?  Do those real world scenarios tend more towards large
arrays of contiguous IOVAs or single pages, or large arrays of
discontiguous IOVAs?  What's the resulting change in device
performance?  Are pages pinned at a high enough frequency that pinning
latency results in a measurable benefit at the device or to the
overhead on the host?

> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu=
_type1.c
> >> index 67e827638995..935f80807527 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -628,6 +628,206 @@ static int vfio_unpin_page_external(struct vfio_=
dma *dma, dma_addr_t iova,
> >>  	return unlocked;
> >>  }
> >>
> >> +static int contiguous_vaddr_get_pfn(struct mm_struct *mm, unsigned lo=
ng vaddr,
> >> +				    int prot, long npage, unsigned long *phys_pfn)
> >> +{
> >> +	struct page **pages =3D NULL;
> >> +	unsigned int flags =3D 0;
> >> +	int i, ret;
> >> +
> >> +	pages =3D kvmalloc_array(npage, sizeof(struct page *), GFP_KERNEL);
> >> +	if (!pages)
> >> +		return -ENOMEM;
> >> +
> >> +	if (prot & IOMMU_WRITE)
> >> +		flags |=3D FOLL_WRITE;
> >> +
> >> +	mmap_read_lock(mm);
> >> +	ret =3D pin_user_pages_remote(mm, vaddr, npage, flags | FOLL_LONGTER=
M,
> >> +				    pages, NULL, NULL); =20
> >=20
> > This is essentially the root of the performance improvement claim,
> > right?  ie. we're pinning a range of pages rather than individually.
> > Unfortunately it means we also add a dynamic memory allocation even
> > when npage=3D1.
> >  =20
> Yes, when npage =3D 1, I should keep the previous scheme of the scene
> and use local variables to save time in allocated memory
> >  =20
> >> +	mmap_read_unlock(mm);
> >> +
> >> +	for (i =3D 0; i < ret; i++)
> >> +		*(phys_pfn + i) =3D page_to_pfn(pages[i]);
> >> +
> >> +	kvfree(pages);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int vfio_pin_contiguous_pages_external(struct vfio_iommu *iomm=
u,
> >> +				    struct vfio_dma *dma,
> >> +				    unsigned long *user_pfn,
> >> +				    int npage, unsigned long *phys_pfn,
> >> +				    bool do_accounting)
> >> +{
> >> +	int ret, i, j, lock_acct =3D 0;
> >> +	unsigned long remote_vaddr;
> >> +	dma_addr_t iova;
> >> +	struct mm_struct *mm;
> >> +	struct vfio_pfn *vpfn;
> >> +
> >> +	mm =3D get_task_mm(dma->task);
> >> +	if (!mm)
> >> +		return -ENODEV;
> >> +
> >> +	iova =3D user_pfn[0] << PAGE_SHIFT;
> >> +	remote_vaddr =3D dma->vaddr + iova - dma->iova;
> >> +	ret =3D contiguous_vaddr_get_pfn(mm, remote_vaddr, dma->prot,
> >> +					    npage, phys_pfn);
> >> +	mmput(mm);
> >> +	if (ret <=3D 0)
> >> +		return ret;
> >> +
> >> +	npage =3D ret;
> >> +	for (i =3D 0; i < npage; i++) {
> >> +		iova =3D user_pfn[i] << PAGE_SHIFT;
> >> +		ret =3D vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >> +		if (ret)
> >> +			goto unwind;
> >> +
> >> +		if (!is_invalid_reserved_pfn(phys_pfn[i]))
> >> +			lock_acct++;
> >> +
> >> +		if (iommu->dirty_page_tracking) {
> >> +			unsigned long pgshift =3D __ffs(iommu->pgsize_bitmap);
> >> +
> >> +			/*
> >> +			 * Bitmap populated with the smallest supported page
> >> +			 * size
> >> +			 */
> >> +			bitmap_set(dma->bitmap,
> >> +				   (iova - dma->iova) >> pgshift, 1);
> >> +		} =20
> >=20
> > It doesn't make sense that we wouldn't also optimize this to simply set
> > npage bits.  There's also no unwind for this.
> >  =20
> Thank you for your correction, I should set npage to simplify.
> There is no unwind process on the current master branch.  Is this a bug?

It's a bit tricky to know when it's ok to clear a bit in the dirty
bitmap, it's much, much worse to accidentally clear a bit to
incorrectly report a page a clean than it is to fail to unwind and
leave pages marked as dirty.  Given that this is an error path, we
might be willing to incorrectly leave pages marked dirty rather than
risk the alternative.

> >> +	}
> >> +
> >> +	if (do_accounting) {
> >> +		ret =3D vfio_lock_acct(dma, lock_acct, true);
> >> +		if (ret) {
> >> +			if (ret =3D=3D -ENOMEM)
> >> +				pr_warn("%s: Task %s (%d) RLIMIT_MEMLOCK (%ld) exceeded\n",
> >> +					__func__, dma->task->comm, task_pid_nr(dma->task),
> >> +					task_rlimit(dma->task, RLIMIT_MEMLOCK));
> >> +			goto unwind;
> >> +		}
> >> +	} =20
> >=20
> > This algorithm allows pinning many more pages in advance of testing
> > whether we've exceeded the task locked memory limit than the per page
> > approach.
> >  =20
> More than 1~VFIO_PIN_PAGES_MAX_ENTRIES. But after failure, all pinned
> pages will be released. Is there a big impact here?
> >  =20
> >> +
> >> +	return i;
> >> +unwind:
> >> +	for (j =3D 0; j < npage; j++) {
> >> +		put_pfn(phys_pfn[j], dma->prot);
> >> +		phys_pfn[j] =3D 0;
> >> +	}
> >> +
> >> +	for (j =3D 0; j < i; j++) {
> >> +		iova =3D user_pfn[j] << PAGE_SHIFT;
> >> +		vpfn =3D vfio_find_vpfn(dma, iova);
> >> +		if (vpfn) =20
> >=20
> > Seems like not finding a vpfn would be an error.
> >  =20
> I think the above process can ensure that vpfn is not NULL
> and delete this judgment.
> >> +			vfio_remove_from_pfn_list(dma, vpfn); =20
> >=20
> > It seems poor form not to use vfio_iova_put_vfio_pfn() here even if we
> > know we hold the only reference.
> >  =20
> The logic here can be reduced to a loop.
> When j < i, call vfio_iova_put_vfio_pfn.
> >  =20
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int vfio_iommu_type1_pin_contiguous_pages(struct vfio_iommu *i=
ommu,
> >> +					    struct vfio_dma *dma,
> >> +					    unsigned long *user_pfn,
> >> +					    int npage, unsigned long *phys_pfn,
> >> +					    bool do_accounting)
> >> +{
> >> +	int ret, i, j;
> >> +	unsigned long remote_vaddr;
> >> +	dma_addr_t iova;
> >> +
> >> +	ret =3D vfio_pin_contiguous_pages_external(iommu, dma, user_pfn, npa=
ge,
> >> +				phys_pfn, do_accounting);
> >> +	if (ret =3D=3D npage)
> >> +		return ret;
> >> +
> >> +	if (ret < 0)
> >> +		ret =3D 0; =20
> >=20
> >=20
> > I'm lost, why do we need the single page iteration below??
> >  =20
> Since there is no retry in contiguous_vaddr_get_pfn, oncean error occurs,
> the remaining pages will be processed in a single page.
> Is it better to increase retry in contiguous_vaddr_get_pfn?

Do we expect it to work if we call it again?  Do we expect the below
single page iteration to work if the npage pinning failed?  Why?


> >> +	for (i =3D ret; i < npage; i++) {
> >> +		iova =3D user_pfn[i] << PAGE_SHIFT;
> >> +		remote_vaddr =3D dma->vaddr + iova - dma->iova;
> >> +
> >> +		ret =3D vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
> >> +			    do_accounting);
> >> +		if (ret)
> >> +			goto pin_unwind;
> >> +
> >> +		ret =3D vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >> +		if (ret) {
> >> +			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
> >> +				vfio_lock_acct(dma, -1, true);
> >> +			goto pin_unwind;
> >> +		}
> >> +
> >> +		if (iommu->dirty_page_tracking) {
> >> +			unsigned long pgshift =3D __ffs(iommu->pgsize_bitmap);
> >> +
> >> +			/*
> >> +			 * Bitmap populated with the smallest supported page
> >> +			 * size
> >> +			 */
> >> +			bitmap_set(dma->bitmap,
> >> +					   (iova - dma->iova) >> pgshift, 1);
> >> +		}
> >> +	}
> >> +
> >> +	return i;
> >> +
> >> +pin_unwind:
> >> +	phys_pfn[i] =3D 0;
> >> +	for (j =3D 0; j < i; j++) {
> >> +		dma_addr_t iova;
> >> +
> >> +		iova =3D user_pfn[j] << PAGE_SHIFT;
> >> +		vfio_unpin_page_external(dma, iova, do_accounting);
> >> +		phys_pfn[j] =3D 0;
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int vfio_iommu_type1_get_contiguous_pages_length(struct vfio_i=
ommu *iommu,
> >> +				    unsigned long *user_pfn, int npage, int prot)
> >> +{
> >> +	struct vfio_dma *dma_base;
> >> +	int i;
> >> +	dma_addr_t iova;
> >> +	struct vfio_pfn *vpfn;
> >> +
> >> +	if (npage <=3D 1)
> >> +		return npage;
> >> +
> >> +	iova =3D user_pfn[0] << PAGE_SHIFT;
> >> +	dma_base =3D vfio_find_dma(iommu, iova, PAGE_SIZE);
> >> +	if (!dma_base)
> >> +		return -EINVAL;
> >> +
> >> +	if ((dma_base->prot & prot) !=3D prot)
> >> +		return -EPERM;
> >> +
> >> +	for (i =3D 1; i < npage; i++) {
> >> +		iova =3D user_pfn[i] << PAGE_SHIFT;
> >> +
> >> +		if (iova >=3D dma_base->iova + dma_base->size ||
> >> +				iova + PAGE_SIZE <=3D dma_base->iova)
> >> +			break;
> >> +
> >> +		vpfn =3D vfio_iova_get_vfio_pfn(dma_base, iova);
> >> +		if (vpfn) {
> >> +			vfio_iova_put_vfio_pfn(dma_base, vpfn); =20
> >=20
> > Why not just use vfio_find_vpfn() rather than get+put?
> >  =20
> Thank you for your correction, I should use vfio_find_vpfn here.
> >> +			break;
> >> +		}
> >> +
> >> +		if (user_pfn[i] !=3D user_pfn[0] + i) =20
> >=20
> > Shouldn't this be the first test?
> >  =20
> Thank you for your correction, the least costly judgment should be
> the first test.
> >> +			break;
> >> +	}
> >> +	return i;
> >> +}
> >> +
> >>  static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>  				      struct iommu_group *iommu_group,
> >>  				      unsigned long *user_pfn,
> >> @@ -637,9 +837,9 @@ static int vfio_iommu_type1_pin_pages(void *iommu_=
data,
> >>  	struct vfio_iommu *iommu =3D iommu_data;
> >>  	struct vfio_group *group;
> >>  	int i, j, ret;
> >> -	unsigned long remote_vaddr;
> >>  	struct vfio_dma *dma;
> >>  	bool do_accounting;
> >> +	int contiguous_npage;
> >>
> >>  	if (!iommu || !user_pfn || !phys_pfn)
> >>  		return -EINVAL;
> >> @@ -663,7 +863,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_=
data,
> >>  	 */
> >>  	do_accounting =3D !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
> >>
> >> -	for (i =3D 0; i < npage; i++) {
> >> +	for (i =3D 0; i < npage; i +=3D contiguous_npage) {
> >>  		dma_addr_t iova;
> >>  		struct vfio_pfn *vpfn;
> >>
> >> @@ -682,31 +882,18 @@ static int vfio_iommu_type1_pin_pages(void *iomm=
u_data,
> >>  		vpfn =3D vfio_iova_get_vfio_pfn(dma, iova);
> >>  		if (vpfn) {
> >>  			phys_pfn[i] =3D vpfn->pfn;
> >> -			continue;
> >> -		}
> >> -
> >> -		remote_vaddr =3D dma->vaddr + (iova - dma->iova);
> >> -		ret =3D vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
> >> -					     do_accounting);
> >> -		if (ret)
> >> -			goto pin_unwind;
> >> -
> >> -		ret =3D vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >> -		if (ret) {
> >> -			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
> >> -				vfio_lock_acct(dma, -1, true);
> >> -			goto pin_unwind;
> >> -		}
> >> -
> >> -		if (iommu->dirty_page_tracking) {
> >> -			unsigned long pgshift =3D __ffs(iommu->pgsize_bitmap);
> >> -
> >> -			/*
> >> -			 * Bitmap populated with the smallest supported page
> >> -			 * size
> >> -			 */
> >> -			bitmap_set(dma->bitmap,
> >> -				   (iova - dma->iova) >> pgshift, 1);
> >> +			contiguous_npage =3D 1;
> >> +		} else {
> >> +			ret =3D vfio_iommu_type1_get_contiguous_pages_length(iommu,
> >> +					&user_pfn[i], npage - i, prot); =20
> >=20
> >=20
> > It doesn't make a lot of sense to me that this isn't more integrated
> > into the base function.  For example, we're passing &user_pfn[i] for
> > which we've already converted to an iova, found the vfio_dma associated
> > to that iova, and checked the protection.  This callout does all of
> > that again on the same.
> >  =20
> Thanks for your correction, I will delete the redundant check in
> vfio_iommu_type1_get_contiguous_pages_length and simplify the function to
> static int vfio_get_contiguous_pages_length (struct vfio_dma * dma,
> unsigned long * user_pfn, int npage)
> >> +			if (ret < 0)
> >> +				goto pin_unwind;
> >> +
> >> +			ret =3D vfio_iommu_type1_pin_contiguous_pages(iommu,
> >> +					dma, &user_pfn[i], ret, &phys_pfn[i], do_accounting);
> >> +			if (ret < 0)
> >> +				goto pin_unwind;
> >> +			contiguous_npage =3D ret;
> >>  		}
> >>  	}
> >>  	ret =3D i; =20
> >=20
> >=20
> > This all seems _way_ more complicated than it needs to be, there are
> > too many different ways to flow through this code and claims of a
> > performance improvement are not substantiated with evidence.  The type1
> > code is already too fragile.  Please simplify and justify.  Thanks,
> >=20
> > Alex
> >=20
> > .
> >  =20
> The main issue is the balance between performance and complexity.
> The test data has been given above, please tell me your opinion.

I think the implementation here is overly complicated, there are too
many code paths and it's not clear what real world improvement to
expect.  The test data only shows us the theoretical best case
improvement of optimizing for a specific use case, without indicating
how prevalent or frequent that use case occurs in operation of an
actual device.  I suspect that it's possible to make the optimization
you're trying to achieve without this degree of complexity.  Thanks,

Alex

