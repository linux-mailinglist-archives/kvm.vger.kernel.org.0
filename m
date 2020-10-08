Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB350286C35
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 02:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgJHApF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 20:45:05 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1211 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgJHAow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 20:44:52 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7e60960000>; Wed, 07 Oct 2020 17:43:02 -0700
Received: from [10.2.85.86] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 00:44:46 +0000
Subject: Re: [PATCH 07/13] mm: close race in generic_access_phys
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Rik van Riel <riel@redhat.com>,
        Benjamin Herrensmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@linux.ie>,
        Hugh Dickins <hugh@veritas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-8-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <852a74ec-339b-4c7f-9e29-b9736111849a@nvidia.com>
Date:   Wed, 7 Oct 2020 17:44:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007164426.1812530-8-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602117782; bh=5uceI5LiOq5+y7CKrEdS7/p/1zSG6F9z/ywEQqsl+0Q=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=bOv1zchIGPZ4VmVobYy9ouKvwkK5z2iFx0tCygQStaL5H7jfVh0290LObbayaaJdS
         WHEwgcF93dN/WBuw358p5ASUvd7jq2UVbYaEsfmxxLYQKm9SIHpvw1Azpcdj8EvlkO
         +h0jsBZCIPOWXbnWZglvtlNPQ9RozMAAGu9n2l/aM37dTFHaW2PBaPyNHrvz3GBICy
         9TRkHD5naSV5XLswp6NmgWYjti6DfG9Id8SNalhueNWQcUu+7yGRlg+spys2z8hb56
         zeyo4ufqohIWRiSETZ13zhAJ7qYzaQsz7j6WHTgK/Hmqk/WB97CYrfy3hYU2QFR/25
         OfakNOpxWk5cA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/20 9:44 AM, Daniel Vetter wrote:
> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
> 
> - gpu drivers dynamically manage their memory nowadays, invalidating
>    ptes with unmap_mapping_range when buffers get moved
> 
> - contiguous dma allocations have moved from dedicated carvetouts to

s/carvetouts/carveouts/

>    cma regions. This means if we miss the unmap the pfn might contain
>    pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> 
> - even /dev/mem now invalidates mappings when the kernel requests that
>    iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
>    ("/dev/mem: Revoke mappings when a driver claims the region")

Thanks for putting these references into the log, it's very helpful.
...
> diff --git a/mm/memory.c b/mm/memory.c
> index fcfc4ca36eba..8d467e23b44e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4873,28 +4873,68 @@ int follow_phys(struct vm_area_struct *vma,
>   	return ret;
>   }
>   
> +/**
> + * generic_access_phys - generic implementation for iomem mmap access
> + * @vma: the vma to access
> + * @addr: userspace addres, not relative offset within @vma
> + * @buf: buffer to read/write
> + * @len: length of transfer
> + * @write: set to FOLL_WRITE when writing, otherwise reading
> + *
> + * This is a generic implementation for &vm_operations_struct.access for an
> + * iomem mapping. This callback is used by access_process_vm() when the @vma is
> + * not page based.
> + */
>   int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>   			void *buf, int len, int write)
>   {
>   	resource_size_t phys_addr;
>   	unsigned long prot = 0;
>   	void __iomem *maddr;
> +	pte_t *ptep, pte;
> +	spinlock_t *ptl;
>   	int offset = addr & (PAGE_SIZE-1);
> +	int ret = -EINVAL;
> +
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		return -EINVAL;
> +
> +retry:
> +	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
> +		return -EINVAL;
> +	pte = *ptep;
> +	pte_unmap_unlock(ptep, ptl);
>   
> -	if (follow_phys(vma, addr, write, &prot, &phys_addr))
> +	prot = pgprot_val(pte_pgprot(pte));
> +	phys_addr = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
> +
> +	if ((write & FOLL_WRITE) && !pte_write(pte))
>   		return -EINVAL;
>   
>   	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
>   	if (!maddr)
>   		return -ENOMEM;
>   
> +	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
> +		goto out_unmap;
> +
> +	if (pte_same(pte, *ptep)) {


The ioremap area is something I'm sorta new to, so a newbie question:
is it possible for the same pte to already be there, ever? If so, we
be stuck in an infinite loop here.  I'm sure that's not the case, but
it's not yet obvious to me why it's impossible. Resource reservations
maybe?


thanks,
-- 
John Hubbard
NVIDIA
