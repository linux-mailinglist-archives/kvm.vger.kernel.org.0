Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5BB294AA9
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438224AbgJUJiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:38:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438199AbgJUJiX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 05:38:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L9WhUY147226;
        Wed, 21 Oct 2020 05:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FF3fA7nLB7tEoc/Bpi1wO3c3onxYGCD7h+eKUEZz8Ds=;
 b=GU19uR9VrIZUkWixwDdd2C6AIvRqolByCaTwMMTWcmCYKO7AgYedqynyhDlnTPDXUobj
 obN8ZDoRsCyk8QhvkW4uGXaIqkm0kwmnZSChXPiMK5JJ6+a61EoVBv2U+ywwz0sq6XAe
 ytvECirmku7p7gJeMFPgZIXWEDzzeyawm4ylkVlTZ+kYVg1RQxDJbEv0x011QGv1vpnH
 ICO8dScC+4ShEjz5rVugDaZLm1gQizm0NgvRE5LMbwEpvM2dSLn8KFq+rakciWBQmVoJ
 Y+aViePfZ2dJln+53juX2SZOj+VsbrfsHcaTm1Z9nvG3YWmLoEWdn/wxqwUvNvovWRzh XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ahef248p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 05:38:05 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09L9WomS147554;
        Wed, 21 Oct 2020 05:38:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ahef247v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 05:38:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09L9QviX015741;
        Wed, 21 Oct 2020 09:38:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 348d5quabg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 09:38:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09L9bx5v35979708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 09:37:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D537AE05A;
        Wed, 21 Oct 2020 09:37:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A14D5AE055;
        Wed, 21 Oct 2020 09:37:58 +0000 (GMT)
Received: from [9.145.178.173] (unknown [9.145.178.173])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Oct 2020 09:37:58 +0000 (GMT)
Subject: Re: [PATCH v3 08/16] s390/pci: Remove races against pte updates
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
 <20201021085655.1192025-9-daniel.vetter@ffwll.ch>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <07557af4-32b5-7610-292c-9fd3bbfe9229@linux.ibm.com>
Date:   Wed, 21 Oct 2020 11:37:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201021085655.1192025-9-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/21/20 10:56 AM, Daniel Vetter wrote:
> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
> 
> - gpu drivers dynamically manage their memory nowadays, invalidating
> ptes with unmap_mapping_range when buffers get moved
> 
> - contiguous dma allocations have moved from dedicated carvetouts to
> cma regions. This means if we miss the unmap the pfn might contain
> pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> 
> - even /dev/mem now invalidates mappings when the kernel requests that
> iomem region when CONFIG_IO_STRICT_DEVMEM is set, see commit
> 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims the
> region")
> 
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea. Fix this.
> 
> Since zpci_memcpy_from|toio seems to not do anything nefarious with
> locks we just need to open code get_pfn and follow_pfn and make sure
> we drop the locks only after we're done. The write function also needs
> the copy_from_user move, since we can't take userspace faults while
> holding the mmap sem.
> 
> v2: Move VM_IO | VM_PFNMAP checks around so they keep returning EINVAL
> like before (Gerard)
> 
> v3: Polish commit message (Niklas)
> 
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.com>
                                                   ^^^^
This should be ".ch", but since this is clearly a typo and you also send from @ffwll.ch,
I took the liberty and fixed it for this commit and applied your patch to our internal
branch, Heiko or Vasily will then pick it up for the s390 tree.

Thanks!

> ---
>  arch/s390/pci/pci_mmio.c | 98 +++++++++++++++++++++++-----------------
>  1 file changed, 57 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> index 401cf670a243..1a6adbc68ee8 100644
> --- a/arch/s390/pci/pci_mmio.c
> +++ b/arch/s390/pci/pci_mmio.c
> @@ -119,33 +119,15 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
>  	return rc;
>  }
>  
> -static long get_pfn(unsigned long user_addr, unsigned long access,
> -		    unsigned long *pfn)
> -{
> -	struct vm_area_struct *vma;
> -	long ret;
> -
> -	mmap_read_lock(current->mm);
> -	ret = -EINVAL;
> -	vma = find_vma(current->mm, user_addr);
> -	if (!vma)
> -		goto out;
> -	ret = -EACCES;
> -	if (!(vma->vm_flags & access))
> -		goto out;
> -	ret = follow_pfn(vma, user_addr, pfn);
> -out:
> -	mmap_read_unlock(current->mm);
> -	return ret;
> -}
> -
>  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>  		const void __user *, user_buffer, size_t, length)
>  {
>  	u8 local_buf[64];
>  	void __iomem *io_addr;
>  	void *buf;
> -	unsigned long pfn;
> +	struct vm_area_struct *vma;
> +	pte_t *ptep;
> +	spinlock_t *ptl;
>  	long ret;
>  
>  	if (!zpci_is_enabled())
> @@ -158,7 +140,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>  	 * We only support write access to MIO capable devices if we are on
>  	 * a MIO enabled system. Otherwise we would have to check for every
>  	 * address if it is a special ZPCI_ADDR and would have to do
> -	 * a get_pfn() which we don't need for MIO capable devices.  Currently
> +	 * a pfn lookup which we don't need for MIO capable devices.  Currently
>  	 * ISM devices are the only devices without MIO support and there is no
>  	 * known need for accessing these from userspace.
>  	 */
> @@ -176,21 +158,37 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>  	} else
>  		buf = local_buf;
>  
> -	ret = get_pfn(mmio_addr, VM_WRITE, &pfn);
> +	ret = -EFAULT;
> +	if (copy_from_user(buf, user_buffer, length))
> +		goto out_free;
> +
> +	mmap_read_lock(current->mm);
> +	ret = -EINVAL;
> +	vma = find_vma(current->mm, mmio_addr);
> +	if (!vma)
> +		goto out_unlock_mmap;
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		goto out_unlock_mmap;
> +	ret = -EACCES;
> +	if (!(vma->vm_flags & VM_WRITE))
> +		goto out_unlock_mmap;
> +
> +	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
>  	if (ret)
> -		goto out;
> -	io_addr = (void __iomem *)((pfn << PAGE_SHIFT) |
> +		goto out_unlock_mmap;
> +
> +	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
>  			(mmio_addr & ~PAGE_MASK));
>  
> -	ret = -EFAULT;
>  	if ((unsigned long) io_addr < ZPCI_IOMAP_ADDR_BASE)
> -		goto out;
> -
> -	if (copy_from_user(buf, user_buffer, length))
> -		goto out;
> +		goto out_unlock_pt;
>  
>  	ret = zpci_memcpy_toio(io_addr, buf, length);
> -out:
> +out_unlock_pt:
> +	pte_unmap_unlock(ptep, ptl);
> +out_unlock_mmap:
> +	mmap_read_unlock(current->mm);
> +out_free:
>  	if (buf != local_buf)
>  		kfree(buf);
>  	return ret;
> @@ -274,7 +272,9 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
>  	u8 local_buf[64];
>  	void __iomem *io_addr;
>  	void *buf;
> -	unsigned long pfn;
> +	struct vm_area_struct *vma;
> +	pte_t *ptep;
> +	spinlock_t *ptl;
>  	long ret;
>  
>  	if (!zpci_is_enabled())
> @@ -287,7 +287,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
>  	 * We only support read access to MIO capable devices if we are on
>  	 * a MIO enabled system. Otherwise we would have to check for every
>  	 * address if it is a special ZPCI_ADDR and would have to do
> -	 * a get_pfn() which we don't need for MIO capable devices.  Currently
> +	 * a pfn lookup which we don't need for MIO capable devices.  Currently
>  	 * ISM devices are the only devices without MIO support and there is no
>  	 * known need for accessing these from userspace.
>  	 */
> @@ -306,22 +306,38 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
>  		buf = local_buf;
>  	}
>  
> -	ret = get_pfn(mmio_addr, VM_READ, &pfn);
> +	mmap_read_lock(current->mm);
> +	ret = -EINVAL;
> +	vma = find_vma(current->mm, mmio_addr);
> +	if (!vma)
> +		goto out_unlock_mmap;
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		goto out_unlock_mmap;
> +	ret = -EACCES;
> +	if (!(vma->vm_flags & VM_WRITE))
> +		goto out_unlock_mmap;
> +
> +	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
>  	if (ret)
> -		goto out;
> -	io_addr = (void __iomem *)((pfn << PAGE_SHIFT) | (mmio_addr & ~PAGE_MASK));
> +		goto out_unlock_mmap;
> +
> +	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
> +			(mmio_addr & ~PAGE_MASK));
>  
>  	if ((unsigned long) io_addr < ZPCI_IOMAP_ADDR_BASE) {
>  		ret = -EFAULT;
> -		goto out;
> +		goto out_unlock_pt;
>  	}
>  	ret = zpci_memcpy_fromio(buf, io_addr, length);
> -	if (ret)
> -		goto out;
> -	if (copy_to_user(user_buffer, buf, length))
> +
> +out_unlock_pt:
> +	pte_unmap_unlock(ptep, ptl);
> +out_unlock_mmap:
> +	mmap_read_unlock(current->mm);
> +
> +	if (!ret && copy_to_user(user_buffer, buf, length))
>  		ret = -EFAULT;
>  
> -out:
>  	if (buf != local_buf)
>  		kfree(buf);
>  	return ret;
> 
