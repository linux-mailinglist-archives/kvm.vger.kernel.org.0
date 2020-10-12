Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE77528BB01
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389099AbgJLOlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 10:41:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8442 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388957AbgJLOlj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Oct 2020 10:41:39 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CEZDrw078166;
        Mon, 12 Oct 2020 10:41:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mh49I7jw4VB6kT4/ay+AaLZilzKCmLBonLwWNkMHRRw=;
 b=MK1q9eNePHSQkxW58VHmw9c51ABMDsasKexGHGtGFzfduqPUsqiEoLP3H2BW8pLNOJDY
 HKqx86fR6w5oclhuufWpcOEwP0GRox8JaBTYNny6OCAn7MCC4NOBYADXeh4lyftwVqJE
 sr8kULHlSgEXQMxanjk40vuI1bFSD2BIM9y2lsiAzCbBQg6f5qdB0j+hbWLabzpIGN5U
 bdFaxg4nw+BtjTue5U9eA2In51WVMjfyNcPxdiO7vm1Otcrw/GYBNtZXjnZIUa1xkmQk
 QBmsEy0lKB9GG3gZTFV4t6AdsGpBK0O3fAnbdeXBZ0quZUqnXFhalJ1jhEuBXpdVz/cX +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344qucjbjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 10:41:29 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09CEZWTT079650;
        Mon, 12 Oct 2020 10:41:28 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344qucjawm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 10:41:28 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09CEbR7V001812;
        Mon, 12 Oct 2020 14:39:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 344558rf3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 14:39:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09CEdVqO9437672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 14:39:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF0F8A405C;
        Mon, 12 Oct 2020 14:39:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 052EAA405F;
        Mon, 12 Oct 2020 14:39:31 +0000 (GMT)
Received: from [9.145.9.103] (unknown [9.145.9.103])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Oct 2020 14:39:30 +0000 (GMT)
Subject: Re: [PATCH v2 08/17] s390/pci: Remove races against pte updates
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
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
 <6deb08dd-46f3-bf26-5362-fdc696f6fd74@linux.ibm.com>
 <20201012141906.GX438822@phenom.ffwll.local>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <3c28a96a-6bb5-f581-4671-5c87161238f7@linux.ibm.com>
Date:   Mon, 12 Oct 2020 16:39:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012141906.GX438822@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_12:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... snip ...
>>> Cc: linux-media@vger.kernel.org
>>> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
>>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>>> Cc: linux-s390@vger.kernel.org
>>> --
>>> v2: Move VM_IO | VM_PFNMAP checks around so they keep returning EINVAL
>>> like before (Gerard)
>>
>> I think the above should go before the CC/Signed-off/Reviewev block.
> 
> This is a per-subsystem bikeshed :-) drivers/gpu definitely wants it
> above, but most core subsystems want it below. I'll move it.

Today I learned, thanks! That said I think most of the time I've
actually not seen version change information in the commit message itself
only in the cover letters. I really don't care just looked odd to me.

> 
>>> ---
>>>  arch/s390/pci/pci_mmio.c | 98 +++++++++++++++++++++++-----------------
>>>  1 file changed, 57 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
>>> index 401cf670a243..1a6adbc68ee8 100644
>>> --- a/arch/s390/pci/pci_mmio.c
>>> +++ b/arch/s390/pci/pci_mmio.c
>>> @@ -119,33 +119,15 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
>>>  	return rc;
>>>  }
>>>  
>>> -static long get_pfn(unsigned long user_addr, unsigned long access,
>>> -		    unsigned long *pfn)
>>> -{
>>> -	struct vm_area_struct *vma;
>>> -	long ret;
>>> -
>>> -	mmap_read_lock(current->mm);
>>> -	ret = -EINVAL;
>>> -	vma = find_vma(current->mm, user_addr);
>>> -	if (!vma)
>>> -		goto out;
>>> -	ret = -EACCES;
>>> -	if (!(vma->vm_flags & access))
>>> -		goto out;
>>> -	ret = follow_pfn(vma, user_addr, pfn);
>>> -out:
>>> -	mmap_read_unlock(current->mm);
>>> -	return ret;
>>> -}
>>> -
>>>  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>>>  		const void __user *, user_buffer, size_t, length)
>>>  {
>>>  	u8 local_buf[64];
>>>  	void __iomem *io_addr;
>>>  	void *buf;
>>> -	unsigned long pfn;
>>> +	struct vm_area_struct *vma;
>>> +	pte_t *ptep;
>>> +	spinlock_t *ptl;
>>
>> With checkpatch.pl --strict the above yields a complained
>> "CHECK: spinlock_t definition without comment" but I think
>> that's really okay since your commit description is very clear.
>> Same oin line 277.
> 
> I think this is a falls positive, checkpatch doesn't realize that
> SYSCALL_DEFINE3 is a function, not a structure. And in a structure I'd
> have added the kerneldoc or comment.

Interesting, your theory sounds convincing, I too thought this
was a bit too pedantic.

> 
> I'll fix up all the nits you've found for the next round. Thanks for
> taking a look.

You're welcome hope I didn't sound pedantic. I think you've a lot
more experience actually and this can indeed turn into bikeshedding
but since I was answering anyway and most of this was checkpatch…

> -Daniel
> 
