Return-Path: <kvm+bounces-66800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C65DDCE83B9
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 22:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5268F3015875
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 21:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66FC2D0605;
	Mon, 29 Dec 2025 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="miCNusS4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B4417A2FB
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 21:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767044416; cv=pass; b=gBX4bMN6+OPL0v5LxFfjLqVAERxzIIh4rPImQxbqwTIYVCwmQIIJd6n/WiiQebnY81+Ahn5lKB4Y/8XEXsVmaCwuT1cyG75q0x30MYEQGHghDaSTggbUIlsUdlWSgwxzN32SXpEOz87ui8XVVyYGu1p8EwDqPsIQCI3kQlAVo/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767044416; c=relaxed/simple;
	bh=9g6ZJJnUbfB2BUQiXgcVEoHjFyip0CSAvWAeyE1DniQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WjCAU9p4Inenn0kAc2RhgYgWiRhvXzLZDTAPlBuQ5gB6QxiHXb4PAmKujIpxVrugSwb7kht6ppkuOy1ETXIqCayTlfeY5UJT7nnjx8J+c5B6E+DPA3L2fOTCga++vjjO68w9tYMrvZVvsjV97WsG6uUuVRDJ7pSsgtdjtNVT5AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=miCNusS4; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee147baf7bso31371cf.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 13:40:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767044414; cv=none;
        d=google.com; s=arc-20240605;
        b=OYPkeQ/tsPy53kDVDE+MXSTyE/dg0EEh3prJ1Rkf1zOyeibnrF3uB+boLh8wJLU/y3
         o2gt6tBi8b3U0XL84Scs5xPya6Nle1OMVTrhWQC18SwK0vvnZ2yVEr2vY4T7qY1mNHy4
         BXuUcQZAeYDNpIONTAVEzFDP80xKUV1DRIsITeehd6vAkGlL3+RbgtkpqDmlneTMU2cG
         /fKBGysliBEfndu1sLj1xWLHbgQGgxAScswRsHpywj1IuHw3iNIipylkUd+VQmbLB6WK
         Y2srDdCPW+VKiZXsvRBLwH3p8s3BIH2V8SZKuOKqZDkkVHgL3rJPbdaQ5mY658VEebxW
         mT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FjH28vXaYrpZwROX8iBiNVL1uo7oPX4Tea1DG2Y6vBM=;
        fh=EFeCXK1FML2//0sI1L1pk/rd/TnXeSM7FD2l7oFQGjM=;
        b=RsU2B15d1gpSxvWHT+HbuSaJzUfCnLoGXxsOJ9sRlBIoxSsEgPEoUdyyhKACD27759
         K30NKFuPx+Wsd1mW062uf0ADeyPluF5omqMWDokPKXJHZxZz4bMT6TxqahnYfvTPM6rl
         tCZ2OFgTSm7duzB3JL/CLQtgIAU0OSnTef/rf0L2ZL494wHWvHGWcwyLQhjNGMR3brSw
         E2Jk2Eze0paH0oUbVmBir3+PO9X0nHDy6l2ENvMjg0RW6amJtU8jN6gn/qxy99XWGy2H
         UByb5kDvroyBjHJMaoQccz1TxIuFpFCKB5Pq3L/yHLtwqEtALNksx2IyIg0xr2G8OH+K
         xaAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767044414; x=1767649214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjH28vXaYrpZwROX8iBiNVL1uo7oPX4Tea1DG2Y6vBM=;
        b=miCNusS4z0njUY6MLv04Si5XSLPw/CsO7kWtKBGcZxNqXl4GLMjniO3UFwNeMgy6gV
         Eq9DPO9n+G6bBlHbM1K01AZgmGcNDwYt1nHVtmDBSuE4u9ZapSZbZFzJ4PGMkhmkRwz/
         iBdJi9nCq0lPxUBkfRMcv/D4QieT3q8mUjWxu3jv38lv7RnsJo9a26vYpw17foSyIwvF
         xOovuo9UIsZ6fu5tUjw4PhoEYI6VlRn08WxR82H0/wlrpmRZCO0kTINE2DWS3gyFBPaJ
         wJaNlt0N07Z5uWpz4zww24mE2pj71CQMLIOoLF1GWkS4vRBXteHQrApxh2qyXwDqcWBJ
         UwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767044414; x=1767649214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FjH28vXaYrpZwROX8iBiNVL1uo7oPX4Tea1DG2Y6vBM=;
        b=dSHGWuO/B7t8rzrW3W4YxOldFy1wm2d2nL1KG2usIPnOWDO8QGnNw32iki/dvSsWBk
         mxtCVwcJPSHhI6GzJlxzx6G9j4ndwFE8CsdBWmFFvMxIr/wRAAfL3779+OaX4JiYGIBr
         6Wmf7DebgViXR6Ayprd+TS5Dfw5lwlXmi45LDeQ6mY02vb4XeT+yki6bZkso9WG17m2W
         j/fA3aHOmaOC6LSZRtc7N+gxZ5aROrhYAubxxqith1YiW4gUNDpKUEJppPLrRxLeDGhl
         iVl3Qbfzrgg4TgH9IfHMFVuZWDZDKVFD9wadstjqwlZWjL8rngfCK+ZEXHmFDkzDyBGa
         3CLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWg0p7rQQEbT5U0QnMTWqlQ54jT3taWPS+/YY2ry/lyloC7U6AJffpN9qBkxop4UPybBXA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw5erC4rEQF84thbzfFN4htDo6riHvaTTxLogskteDozNYd891
	f4ej5CtzMFciKh1sGWKJbLg2t8qgLJyLkZ30OYaqcM2rif+tHcEhpMfxlteCVCPtRa/7AOvqyTI
	r1EOtLKuKKc3D+vTK9PpDB26lmPrgyrISwKAutadL
X-Gm-Gg: AY/fxX4BIm8hfS26nQTf64/+q8SmxhpjEoQOi5EOwS2dk9VUhI3gusqUjLObPm7+Yk+
	RcXhs/lcJxs4jzHuq7bVHtzydqHDt91OTs4xtlnLE06acI0WE1Z4wFgKic1Vr2iTMdJ+JMjgvi4
	biFIbpAy+m5aPxEIf1aaWOvT6+D8t/XTRZqQFSU1PkLL5aKe036EUd10RTdrvj+qtQueFUVF8ut
	s4J80jPqOEAqHNg2UEuWRnmZiC48sBISxMFrwio1a2SYtVf3ie5BK9IbSLkBTkwQQ9rwIE=
X-Google-Smtp-Source: AGHT+IE1u1nZxmCpeFmu9qgnqSujzbw35266/C7GM8gXBEmZKD1modM4mbTF+J8EhTEnruS5nmOKdQXAtCcfmqm4SwM=
X-Received: by 2002:a05:622a:1387:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-4fab5bf80b1mr164071cf.9.1767044413842; Mon, 29 Dec 2025
 13:40:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223230044.2617028-1-aaronlewis@google.com>
 <20251223230044.2617028-2-aaronlewis@google.com> <aUtLrp2smpXZPpBO@nvidia.com>
In-Reply-To: <aUtLrp2smpXZPpBO@nvidia.com>
From: Aaron Lewis <aaronlewis@google.com>
Date: Mon, 29 Dec 2025 13:40:02 -0800
X-Gm-Features: AQt7F2rdOsmH5ZDCBDCO39GaPcr7H5M4IF7gM9gJXGPzoNU8Vu4aI82ebODxZyI
Message-ID: <CAAAPnDEcAGEBexGfC92pS=t9iYQRJFyFE9yPUU916T92Y465qw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge pages
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: alex.williamson@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tried the memfd path on iommufd and it is indeed fast.  It was in
the same ballpark as the optimization I posted for VFIO_TYPE1_IOMMU.
I also tried it with a HugeTLB fd, e.g. /mnt/huge/tmp.bin, and it was
fast too.  I haven't had a chance to try it with DevDax w/ 1G pages,
though.  I noticed DevDax was quite a bit slower than HugeTLB when I
tested it on VFIO_TYPE1_IOMMU.  Have you heard how DevDax performs on
IOMMU_IOAS_MAP_FILE?  I'm curious if it has similar slowdowns compared
to HugeTLB.

I'll post an updated vfio_dma_mapping_perf_test that includes the
memfd updates in a follow up.

On Tue, Dec 23, 2025 at 6:10=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Dec 23, 2025 at 11:00:43PM +0000, Aaron Lewis wrote:
>
> > More effort will be needed to see what kind of speed ups can be achieve=
d
> > by optimizing iommufd.  Sample profiler results (below) show that it
> > isn't the GUP calls that are slowing it down like they were in the
> > "vfio_type1_iommu" case.  The majority of the slowdown is coming from
> > batch_from_pages(), and the majority of that time is being spent in
> > batch_add_pfn_num().
>
> This is probably because vfio is now using num_pages_contiguous()
> which seems to be a little bit faster than batch_add_pfn()
>
> Since that is pretty new maybe it explains the discrepancy in reports.
>
> > @@ -598,7 +600,18 @@ static long vaddr_get_pfns(struct mm_struct *mm, u=
nsigned long vaddr,
> >       ret =3D pin_user_pages_remote(mm, vaddr, pin_pages, flags | FOLL_=
LONGTERM,
> >                                   batch->pages, NULL);
> >       if (ret > 0) {
> > +             unsigned long nr_pages =3D compound_nr(batch->pages[0]);
> > +             bool override_size =3D false;
> > +
> > +             if (PageHead(batch->pages[0]) && nr_pages > pin_pages &&
> > +                 ret =3D=3D pin_pages) {
> > +                     override_size =3D true;
> > +                     ret =3D nr_pages;
> > +                     page_ref_add(batch->pages[0], nr_pages - pin_page=
s);
> > +             }
>
> This isn't right, num_pages_contiguous() is the best we can do for
> lists returns by pin_user_pages(). In a VMA context you cannot blindly
> assume the whole folio was mapped contiguously. Indeed I seem to
> recall this was already proposed and rejected and that is how we ended
> up with num_pages_contiguous().

Can't we assume a single page will be mapped contiguously?  If we are
operating on 1GB pages and the batch only covers ~30MB of that, if we
are a head page can't we assume the VA and PA will be contiguous at
least until the end of the current page?  Is the issue with the VMA
context that we have to ensure the VMA includes the entire page?  If
so, would something like this resolve that?  Instead of simply
checking:

> > +             if (PageHead(batch->pages[0]) && nr_pages > pin_pages &&
> > +                 ret =3D=3D pin_pages) {

Do this instead:

> > +             if (pin_huge_page_fast(...) {

Where pin_huge_page_fast() does this:

+/* Must hold mmap_read_lock(mm). */
+static bool pin_huge_page_fast(struct page *page, struct mm_struct *mm,
+        unsigned long vaddr, unsigned long npages,
+        unsigned long pin_pages, long npinned) {
+ unsigned long nr_pages, nr_vmas_pages, untagged_vaddr;
+ struct vm_area_struct *vma;
+
+ /* Did pin_user_pages_remote() pin as many pages as expected? */
+ if (npinned !=3D pin_pages)
+ return false;
+
+ /*
+ * Only consider head pages.  That will give the maximum
+ * benefits and simplify some of the checks below.
+ */
+ if (!PageHead(page))
+ return false;
+
+ /*
+ * Reject small pages.  Very large pages give the best benefits.
+ */
+ nr_pages =3D compound_nr(page);
+ if (nr_pages <=3D pin_pages)
+ return false;
+
+ /*
+ * Don't pin more pages than requested by VFIO_IOMMU_MAP_DMA.
+ */
+ if (nr_pages > npages)
+ return false;
+
+ untagged_vaddr =3D untagged_addr_remote(mm, vaddr);
+ vma =3D vma_lookup(mm, untagged_vaddr);
+
+ /* Does the virtual address map to a VMA? */
+ if (!vma)
+ return false;
+
+ /* Is the virtual address in the VMA? */
+ if (untagged_vaddr < vma->vm_start ||
+     untagged_vaddr >=3D vma->vm_end)
+ return false;
+
+ /*
+ * Does the VMA contain the entire very large page?  I.e. it
+ * isn't being overrun.
+ */
+ nr_vmas_pages =3D ((vma->vm_end - untagged_vaddr) >> PAGE_SHIFT);
+ if (nr_pages > nr_vmas_pages)
+ return false;
+
+ /*
+ * This is a good candidate for huge page optimizations.  The
+ * page is larger than a batch and fits in its VMA.  Therefore,
+ * pin the entire page all at once, rather than walking over
+ * each struct page in this huge page.
+ */
+ return true;
+}

>
> Again, use the memfd path which supports this optimization already.
>
> Jason

Using memfd sounds reasonable assuming DevDax w/ 1GB pages performs
well.  I guess I'm more asking about pin_huge_page_fast() as a sanity
check to make sure I'm not missing anything, though if you are not
looking to take changes for VFIO_TYPE1_IOMMU I can remove it from the
series.

Aaron

