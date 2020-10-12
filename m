Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFDA28B9D8
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbgJLOEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 10:04:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403767AbgJLODw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Oct 2020 10:03:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CE17Ne018109;
        Mon, 12 Oct 2020 10:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9XZVPCzxR7io9Yrm5bz2pZhnBT0B6bmEzvhzPr5tu+k=;
 b=lM6Lq1hxDAVbJy/T/9DGSzvJGB/1tT6cuVQtMb6COlj6rIfR/a9hYwvFChI1USLqQirz
 fNaHBlYt4yxmdR2LZk39peXNUpw0iBDbS2UZObEvi5gEjbJqs4LA7VRt3BsrkBf5Pc4s
 FqlfeBb7+NH70qz1nKV2Wv+mO3iv3xvbzNrv1CT6KHgNV4sBVrNvkeS98IfstwwJ2okx
 stPGOZeyzURa8zgX/NVPdt35+W3+sskKlYR2sugwCuMGF1lj3qQdUtd3tHQRsM5sNWiu
 UHWKGlTA3uwkcS2SFZbM7C6UEDpnKqh4O4KG8y6hutCho2WBIMuPOydex3vIfRDRvSz9 WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 344qdaahcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 10:03:35 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09CE1ukg021820;
        Mon, 12 Oct 2020 10:03:34 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 344qdaahb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 10:03:34 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09CE3Wk4004006;
        Mon, 12 Oct 2020 14:03:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 34347h12ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 14:03:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09CE3TKb28115244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 14:03:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC61A42045;
        Mon, 12 Oct 2020 14:03:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECCA342042;
        Mon, 12 Oct 2020 14:03:28 +0000 (GMT)
Received: from [9.145.9.103] (unknown [9.145.9.103])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Oct 2020 14:03:28 +0000 (GMT)
Subject: Re: [PATCH v2 08/17] s390/pci: Remove races against pte updates
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
        Jan Kara <jack@suse.cz>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-9-daniel.vetter@ffwll.ch>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <6deb08dd-46f3-bf26-5362-fdc696f6fd74@linux.ibm.com>
Date:   Mon, 12 Oct 2020 16:03:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009075934.3509076-9-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_09:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 clxscore=1011 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Daniel,

freshly back from my vacation I've just taken a look at your patch.
First thanks for this fix and the detailed commit description.
Definitely makes sense to fix this and you can add my

Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>

Content wise it all looks sane and clear and since Gerald did the testing,
I would have applied it to our tree already, but I got some trivial
checkpatch violations that probably apply to the whole series.
I've commented them inline below.
If you confirm there I can do the fixups when applying or you can resend.

On 10/9/20 9:59 AM, Daniel Vetter wrote:
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
> iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87

The above commit mention should use the format
'commit 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims the region")'
otherwise this results in a checkpatch ERROR.

> ("/dev/mem: Revoke mappings when a driver claims the region")
> 
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea. Fix this.
> 
> Since zpci_memcpy_from|toio seems to not do anything nefarious with
> locks we just need to open code get_pfn and follow_pfn and make sure
> we drop the locks only after we've done. The write function also needs

just a typo but just saw it "we're" instead of "we've"

> the copy_from_user move, since we can't take userspace faults while
> holding the mmap sem.
> 
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> 
No empty line after the Revied-by tag.

> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

Your Signed-off-by mail address does not match the one you're sending from,
this yields a checkpatch warning when using git am with your mail.
This is probably just a silly misconfiguration but since Signed-offs
are signatures should I change this to 
"Daniel Vetter <daniel.vetter@ffwll.ch>" which is the one you're
sending from and also in the MAINTAINERS file?


> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>

The above Cc: line for Dan Williams is a duplicate

> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> --
> v2: Move VM_IO | VM_PFNMAP checks around so they keep returning EINVAL
> like before (Gerard)

I think the above should go before the CC/Signed-off/Reviewev block.

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

With checkpatch.pl --strict the above yields a complained
"CHECK: spinlock_t definition without comment" but I think
that's really okay since your commit description is very clear.
Same oin line 277.

... snip ...
