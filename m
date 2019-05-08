Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA30E17A8C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 15:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfEHN0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 09:26:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726600AbfEHN0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 09:26:05 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48DM0UK026667;
        Wed, 8 May 2019 09:26:02 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sbxjjwpy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 May 2019 09:26:02 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x487TQ1J008109;
        Wed, 8 May 2019 07:30:10 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 2s92c3yrwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 May 2019 07:30:10 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48DPxCQ12648938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 13:25:59 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3638D6A047;
        Wed,  8 May 2019 13:25:59 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 576996A057;
        Wed,  8 May 2019 13:25:58 +0000 (GMT)
Received: from [9.85.183.31] (unknown [9.85.183.31])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 13:25:58 +0000 (GMT)
Subject: Re: [PATCH 3/7] s390/cio: Split pfn_array_alloc_pin into pieces
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-4-farman@linux.ibm.com>
 <20190508124327.5c496c8a.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <15e733fc-e6eb-176e-e9bd-3f7629d5f935@linux.ibm.com>
Date:   Wed, 8 May 2019 09:25:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508124327.5c496c8a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=886 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/8/19 6:43 AM, Cornelia Huck wrote:
> On Fri,  3 May 2019 15:49:08 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> The pfn_array_alloc_pin routine is doing too much.  Today, it does the
>> alloc of the pfn_array struct and its member arrays, builds the iova
>> address lists out of a contiguous piece of guest memory, and asks vfio
>> to pin the resulting pages.
>>
>> Let's effectively revert a significant portion of commit 5c1cfb1c3948
>> ("vfio: ccw: refactor and improve pfn_array_alloc_pin()") such that we
>> break pfn_array_alloc_pin() into its component pieces, and have one
>> routine that allocates/populates the pfn_array structs, and another
>> that actually pins the memory.  In the future, we will be able to
>> handle scenarios where pinning memory isn't actually appropriate.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 72 +++++++++++++++++++++++++++---------------
>>   1 file changed, 47 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index f86da78eaeaa..b70306c06150 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -50,28 +50,25 @@ struct ccwchain {
>>   };
>>   
>>   /*
>> - * pfn_array_alloc_pin() - alloc memory for PFNs, then pin user pages in memory
>> + * pfn_array_alloc() - alloc memory for PFNs
>>    * @pa: pfn_array on which to perform the operation
>> - * @mdev: the mediated device to perform pin/unpin operations
>>    * @iova: target guest physical address
>>    * @len: number of bytes that should be pinned from @iova
>>    *
>> - * Attempt to allocate memory for PFNs, and pin user pages in memory.
>> + * Attempt to allocate memory for PFN.
> 
> s/PFN/PFNs/
> 
>>    *
>>    * Usage of pfn_array:
>>    * We expect (pa_nr == 0) and (pa_iova_pfn == NULL), any field in
>>    * this structure will be filled in by this function.
>>    *
>>    * Returns:
>> - *   Number of pages pinned on success.
>> - *   If @pa->pa_nr is not 0, or @pa->pa_iova_pfn is not NULL initially,
>> - *   returns -EINVAL.
>> - *   If no pages were pinned, returns -errno.
>> + *         0 if PFNs are allocated
>> + *   -EINVAL if pa->pa_nr is not initially zero, or pa->pa_iova_pfn is not NULL
>> + *   -ENOMEM if alloc failed
>>    */
>> -static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
>> -			       u64 iova, unsigned int len)
>> +static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
>>   {
>> -	int i, ret = 0;
>> +	int i;
>>   
>>   	if (!len)
>>   		return 0;
>> @@ -97,23 +94,33 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
>>   	for (i = 1; i < pa->pa_nr; i++)
>>   		pa->pa_iova_pfn[i] = pa->pa_iova_pfn[i - 1] + 1;
>>   
>> +	return 0;
>> +}
>> +
>> +/*
>> + * pfn_array_pin() - Pin user pages in memory
>> + * @pa: pfn_array on which to perform the operation
>> + * @mdev: the mediated device to perform pin operations
>> + *
>> + * Returns:
>> + *   Number of pages pinned on success.
>> + *   If fewer pages than requested were pinned, returns -EINVAL
>> + *   If no pages were pinned, returns -errno.
> 
> I don't really like the 'returns -errno' :) It's actually the return
> code of vfio_pin_pages(), and that might include -EINVAL as well.
> 
> So, what about mentioning in the function description that
> pfn_array_pin() only succeeds if it coult pin all pages, and simply
> stating that it returns a negative error value on failure?

Seems reasonable to me...  Something like:

  * Returns number of pages pinned upon success.
  * If the pin request partially succeeds, or fails completely,
  * all pages are left unpinned and a negative error value is returned.

> 
>> + */
>> +static int pfn_array_pin(struct pfn_array *pa, struct device *mdev)
>> +{
>> +	int ret = 0;
>> +
>>   	ret = vfio_pin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr,
>>   			     IOMMU_READ | IOMMU_WRITE, pa->pa_pfn);
>>   
>> -	if (ret < 0) {
>> -		goto err_out;
>> -	} else if (ret > 0 && ret != pa->pa_nr) {
>> +	if (ret > 0 && ret != pa->pa_nr) {
>>   		vfio_unpin_pages(mdev, pa->pa_iova_pfn, ret);
>>   		ret = -EINVAL;
>> -		goto err_out;
>>   	}
>>   
>> -	return ret;
>> -
>> -err_out:
>> -	pa->pa_nr = 0;
>> -	kfree(pa->pa_iova_pfn);
>> -	pa->pa_iova_pfn = NULL;
>> +	if (ret < 0)
>> +		pa->pa_iova = 0;
>>   
>>   	return ret;
>>   }
> 
> (...)
> 
