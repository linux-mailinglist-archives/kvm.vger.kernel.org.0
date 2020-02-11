Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1511594D2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgBKQYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:24:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47844 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgBKQYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 11:24:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BG2W58169327;
        Tue, 11 Feb 2020 16:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8KhVmZwN6F4dWziVKrI4JGlNBaP+UKS7RCQREi4lP3Y=;
 b=vPR3la4evpb6xFLxXnrf6AxxpvMDgqC2MpU/cJeQB2RB8oWbP1ffdeJc6aTHVXA3oeu+
 ns9iNJiKTybifTyME+VGkg7bYJpKUDRfk9t50XHlG86ULqDEvyBCMYnqe8nkuhIYVR3G
 LrCz9dViuid8Qu6a9XoAnIH8N1jKET4XjRsusIVX+mdTkEN1RNr37AiV3d1oq9JjQ146
 wcFV3lq/+WcPgsQr4fCaQncXm8jeFVnzjlxZr2fWjc/ZPMe/59RRQnBEh5o5jNI64DnM
 sdsyGsnJFFO90FmcfqWDLAQfe0tXbvtba7WX4LcVTOQ0PWNIa60CNvu1Ww6pjSgqAlvf Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y2jx64q3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 16:24:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BGCRuq138219;
        Tue, 11 Feb 2020 16:24:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y26srqt22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 16:24:00 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01BGNueX028061;
        Tue, 11 Feb 2020 16:23:56 GMT
Received: from [10.175.211.251] (/10.175.211.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Feb 2020 08:23:55 -0800
Subject: Re: [PATCH RFC 09/10] vfio/type1: Use follow_pfn for VM_FPNMAP VMAs
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-10-joao.m.martins@oracle.com>
 <20200207210831.GA31015@ziepe.ca>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <98351044-a710-1d52-f030-022eec89d1d5@oracle.com>
Date:   Tue, 11 Feb 2020 16:23:49 +0000
MIME-Version: 1.0
In-Reply-To: <20200207210831.GA31015@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9528 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9528 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=1 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/20 9:08 PM, Jason Gunthorpe wrote:
> On Fri, Jan 10, 2020 at 07:03:12PM +0000, Joao Martins wrote:
>> From: Nikita Leshenko <nikita.leshchenko@oracle.com>
>>
>> Unconditionally interpreting vm_pgoff as a PFN is incorrect.
>>
>> VMAs created by /dev/mem do this, but in general VM_PFNMAP just means
>> that the VMA doesn't have an associated struct page and is being managed
>> directly by something other than the core mmu.
>>
>> Use follow_pfn like KVM does to find the PFN.
>>
>> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
>>  drivers/vfio/vfio_iommu_type1.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 2ada8e6cdb88..1e43581f95ea 100644
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -362,9 +362,9 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>>  	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
>>  
>>  	if (vma && vma->vm_flags & VM_PFNMAP) {
>> -		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
>> -		if (is_invalid_reserved_pfn(*pfn))
>> -			ret = 0;
>> +		ret = follow_pfn(vma, vaddr, pfn);
>> +		if (!ret && !is_invalid_reserved_pfn(*pfn))
>> +			ret = -EOPNOTSUPP;
>>  	}
> 
> FWIW this existing code is a huge hack and a security problem.
> 
> I'm not sure how you could be successfully using this path on actual
> memory without hitting bad bugs?
> 
ATM I think this codepath is largelly hit at the moment for MMIO (GPU
passthrough, or mdev). In the context of this patch, guest memory would be
treated similarly meaning the device-dax backing memory wouldn't have a 'struct
page' (as introduced in this series).

> Fudamentally VFIO can't retain a reference to a page from within a VMA
> without some kind of recount/locking/etc to allow the thing that put
> the page there to know it is still being used (ie programmed in a
> IOMMU) by VFIO.
> 
> Otherwise it creates use-after-free style security problems on the
> page.
> 
I take it you're referring to the past problems with long term page pinning +
fsdax? Or you had something else in mind, perhaps related to your LSFMM topic?

Here the memory can't be used by the kernel (and there's no struct page) except
from device-dax managing/tearing/driving the pfn region (which is static and the
underlying PFNs won't change throughout device lifetime), and vfio
pinning/unpinning the pfns (which are refcounted against multiple map/unmaps);

> This code needs to be deleted, not extended :(

To some extent it isn't really an extension: the patch was just removing the
assumption @vm_pgoff being the 'start pfn' on PFNMAP vmas. This is also
similarly done by get_vaddr_frames().

	Joao
