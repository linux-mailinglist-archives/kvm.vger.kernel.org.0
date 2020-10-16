Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF3228FF87
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 09:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404892AbgJPHy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 03:54:29 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11276 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404799AbgJPHy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Oct 2020 03:54:28 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8951870000>; Fri, 16 Oct 2020 00:53:43 -0700
Received: from [10.2.49.77] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 07:54:19 +0000
Subject: Re: [PATCH v2 05/17] mm/frame-vector: Use FOLL_LONGTERM
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
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-6-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <4685181e-8306-0d96-8be6-592b3c563cbf@nvidia.com>
Date:   Fri, 16 Oct 2020 00:54:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009075934.3509076-6-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602834823; bh=x8+KhcjN/0jeBmkHwcjBNjUK8qbDE0ZVZJYKZ9Z6VGs=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=OPXG7m+swcryyW3+1c3mxRCD9ELJ64r6RX1Dgjsv/DxKINT3TrWkfzRvFH5oOjwQ9
         kbmWxE8cjt++1sfq9zZBm7pAsjxLHRKxIkJrIYBO5d5BHLfs1GBTG4uNWzgJwAYEib
         a0tpEVj2BXEbDUUj0WNA08KLGk0UpBLrh6Q4zl4oRKuwi2vFzQU7IWPvzl60U5doRa
         9Sx7wqrwS1T6lY56FeeLMgq9fZLnJB5MNWWrmUCdHStngTzwSQOW6ZGYVnKoe93gas
         pNw8s4iejdBCZ9jkBUIDbZgPpbSPLosjj5nPK4785xOzYYi5NQgwhH2Nz6WyvBj4Gr
         OGagG2GGGM95w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/9/20 12:59 AM, Daniel Vetter wrote:
...
> @@ -48,40 +47,25 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>   
>   	start = untagged_addr(start);
>   
> -	mmap_read_lock(mm);
> -	locked = 1;
> -	vma = find_vma_intersection(mm, start, start + 1);
> -	if (!vma) {
> -		ret = -EFAULT;
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
> -		ret = -EOPNOTSUPP;
> -		goto out;
> -	}
> -
> -	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> +	ret = pin_user_pages_fast(start, nr_frames,
> +				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
> +				  (struct page **)(vec->ptrs));
> +	if (ret > 0) {

None of the callers that we have today will accept anything less than
ret == nr_frames. And the whole partially pinned region idea turns out
to be just not useful for almost everyone, from what I recall of the gup/pup
call sites. So I wonder if we should just have get_vaddr_frames do the
cleanup here and return -EFAULT, if ret != nr_frames ?

thanks,
-- 
John Hubbard
NVIDIA
