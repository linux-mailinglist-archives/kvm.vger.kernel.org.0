Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A497029491E
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 09:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502108AbgJUH4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 03:56:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502101AbgJUH4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 03:56:16 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L7X16V066044;
        Wed, 21 Oct 2020 03:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lv0GwBldnmbZQXrayavRSYj6mxTJ2VfqBwFS3jQIG0c=;
 b=dUv4rTX/nfJgprmkjOdg/5aMNPuqyVb/enj5JDQw9bniaKU2bnh8sbD2Y8UOdBgiaPty
 9nnPLGBESYPJKwDsDB98+duUeED7csFciXP23ClQhtZhGQ1arOV75HXtSWrTF3bTdM/a
 R1XwxPsvjilXzGOOu7JJ8R95o65oCrwFvZte6e1Piz4lya872/SzZHEoZ7GsuMzH19al
 0rnOqou3KlBmxWNZKa7kH6GzbDoXTeeuyhHGV02HSvREsYslXl3QtEAplEW7VW7RnHaK
 AjKKmH/TdGcIYX/5UDQoDExVw2rwMpxPlF1iFwQjshxFzKC3jAP0OSpSWpJICUaYtCvb vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34agdm96ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 03:56:03 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09L7Y7ob070104;
        Wed, 21 Oct 2020 03:56:03 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34agdm969c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 03:56:03 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09L7plEK007941;
        Wed, 21 Oct 2020 07:56:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 347qvha47f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 07:56:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09L7twAb32506250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 07:55:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BD5DA4051;
        Wed, 21 Oct 2020 07:55:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88367A4055;
        Wed, 21 Oct 2020 07:55:57 +0000 (GMT)
Received: from [9.145.178.173] (unknown [9.145.178.173])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Oct 2020 07:55:57 +0000 (GMT)
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
Message-ID: <3594c115-541f-806a-ee33-e99a2d1d31e8@linux.ibm.com>
Date:   Wed, 21 Oct 2020 09:55:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012141906.GX438822@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Daniel,

friendly ping. I haven't seen a new version of this patch series,
as I said I think your change for s390/pci is generally useful so
I'm curious, are you planning on sending a new version soon?
If you want you can also just sent this patch with the last few
nitpicks (primarily the mail address) fixed and I'll happily apply.

Best regards,
Niklas Schnelle

On 10/12/20 4:19 PM, Daniel Vetter wrote:
> On Mon, Oct 12, 2020 at 04:03:28PM +0200, Niklas Schnelle wrote:
... snip ....
>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: John Hubbard <jhubbard@nvidia.com>
>>> Cc: Jérôme Glisse <jglisse@redhat.com>
>>> Cc: Jan Kara <jack@suse.cz>
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>
>> The above Cc: line for Dan Williams is a duplicate
>>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-samsung-soc@vger.kernel.org
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
> 
> I'll fix up all the nits you've found for the next round. Thanks for
> taking a look.
> -Daniel
> 
