Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEDA4C294
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 22:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbfFSUxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 16:53:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726175AbfFSUxk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 16:53:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JKpb20175451;
        Wed, 19 Jun 2019 16:53:37 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t7sm7q1yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 16:53:37 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5JKnset026698;
        Wed, 19 Jun 2019 20:53:36 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 2t4ra658w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 20:53:36 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JKrYIW28967268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 20:53:34 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79067C6057;
        Wed, 19 Jun 2019 20:53:34 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF87FC605A;
        Wed, 19 Jun 2019 20:53:33 +0000 (GMT)
Received: from [9.80.222.142] (unknown [9.80.222.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 20:53:33 +0000 (GMT)
Subject: Re: [RFC PATCH v1 1/5] vfio-ccw: Move guest_cp storage into common
 struct
To:     Farhan Ali <alifm@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190618202352.39702-1-farman@linux.ibm.com>
 <20190618202352.39702-2-farman@linux.ibm.com>
 <0e55d558-08ee-996e-f9c2-f51e8695064a@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <50cf003b-017d-f475-238d-83aef2df7200@linux.ibm.com>
Date:   Wed, 19 Jun 2019 16:53:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0e55d558-08ee-996e-f9c2-f51e8695064a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/19/19 4:13 PM, Farhan Ali wrote:
> 
> 
> On 06/18/2019 04:23 PM, Eric Farman wrote:
>> Rather than allocating/freeing a piece of memory every time
>> we try to figure out how long a CCW chain is, let's use a piece
>> of memory allocated for each device.
>>
>> The io_mutex added with commit 4f76617378ee9 ("vfio-ccw: protect
>> the I/O region") is held for the duration of the VFIO_CCW_EVENT_IO_REQ
>> event that accesses/uses this space, so there should be no race
>> concerns with another CPU attempting an (unexpected) SSCH for the
>> same device.
>>
>> Suggested-by: Cornelia Huck <cohuck@redhat.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>> Conny, your suggestion [1] did not go unnoticed.  :)
>>
>> [1] https://patchwork.kernel.org/comment/22312659/
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c  | 23 ++++-------------------
>>   drivers/s390/cio/vfio_ccw_cp.h  |  7 +++++++
>>   drivers/s390/cio/vfio_ccw_drv.c |  7 +++++++
>>   3 files changed, 18 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
>> b/drivers/s390/cio/vfio_ccw_cp.c
>> index 90d86e1354c1..f358502376be 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -16,12 +16,6 @@
>>     #include "vfio_ccw_cp.h"
>>   -/*
>> - * Max length for ccw chain.
>> - * XXX: Limit to 256, need to check more?
>> - */
>> -#define CCWCHAIN_LEN_MAX    256
>> -
>>   struct pfn_array {
>>       /* Starting guest physical I/O address. */
>>       unsigned long        pa_iova;
>> @@ -386,7 +380,7 @@ static void ccwchain_cda_free(struct ccwchain
>> *chain, int idx)
>>    */
>>   static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
>>   {
>> -    struct ccw1 *ccw, *p;
>> +    struct ccw1 *ccw = cp->guest_cp;
>>       int cnt;
>>         /*
>> @@ -394,15 +388,9 @@ static int ccwchain_calc_length(u64 iova, struct
>> channel_program *cp)
>>        * Currently the chain length is limited to CCWCHAIN_LEN_MAX (256).
>>        * So copying 2K is enough (safe).
>>        */
>> -    p = ccw = kcalloc(CCWCHAIN_LEN_MAX, sizeof(*ccw), GFP_KERNEL);
>> -    if (!ccw)
>> -        return -ENOMEM;
>> -
>>       cnt = copy_ccw_from_iova(cp, ccw, iova, CCWCHAIN_LEN_MAX);
> 
> Just a minor concern, should we clear out cp->guest_cp memory before we
> do the copying? Given that the ccwchain_calc_length will also call be
> called during tic handling, it's possible there might be some garbage
> data in guest_cp, no?

Yeah, they'll be garbage there, but I'm not sure it's a problem.  By the
time we get here again (ccwchain_loop_tic() -> ccwchain_handle_ccw()),
we'll have saved the relevant CCWs for the first segment.  And the
second time through we'll be copying a fresh 2K from the target of the
TIC to cp->guest_cp, overwriting all that stale data with new CCWs (and
new garbage data).

> 
> 
>> -    if (cnt) {
>> -        kfree(ccw);
>> +    if (cnt)
>>           return cnt;
>> -    }
>>         cnt = 0;
>>       do {
>> @@ -413,10 +401,8 @@ static int ccwchain_calc_length(u64 iova, struct
>> channel_program *cp)
>>            * orb specified one of the unsupported formats, we defer
>>            * checking for IDAWs in unsupported formats to here.
>>            */
>> -        if ((!cp->orb.cmd.c64 || cp->orb.cmd.i2k) && ccw_is_idal(ccw)) {
>> -            kfree(p);
>> +        if ((!cp->orb.cmd.c64 || cp->orb.cmd.i2k) && ccw_is_idal(ccw))
>>               return -EOPNOTSUPP;
>> -        }
>>             /*
>>            * We want to keep counting if the current CCW has the
>> @@ -435,7 +421,6 @@ static int ccwchain_calc_length(u64 iova, struct
>> channel_program *cp)
>>       if (cnt == CCWCHAIN_LEN_MAX + 1)
>>           cnt = -EINVAL;
>>   -    kfree(p);
>>       return cnt;
>>   }
>>   @@ -461,7 +446,7 @@ static int ccwchain_handle_ccw(u32 cda, struct
>> channel_program *cp)
>>       struct ccwchain *chain;
>>       int len, ret;
>>   -    /* Get chain length. */
>> +    /* Copy the chain from cda to cp, and count the CCWs in it */
>>       len = ccwchain_calc_length(cda, cp);
>>       if (len < 0)
>>           return len;
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.h
>> b/drivers/s390/cio/vfio_ccw_cp.h
>> index 3c20cd208da5..7cdc38049033 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.h
>> +++ b/drivers/s390/cio/vfio_ccw_cp.h
>> @@ -16,6 +16,12 @@
>>     #include "orb.h"
>>   +/*
>> + * Max length for ccw chain.
>> + * XXX: Limit to 256, need to check more?
>> + */
>> +#define CCWCHAIN_LEN_MAX    256
>> +
>>   /**
>>    * struct channel_program - manage information for channel program
>>    * @ccwchain_list: list head of ccwchains
>> @@ -32,6 +38,7 @@ struct channel_program {
>>       union orb orb;
>>       struct device *mdev;
>>       bool initialized;
>> +    struct ccw1 *guest_cp;
>>   };
>>     extern int cp_init(struct channel_program *cp, struct device *mdev,
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
>> b/drivers/s390/cio/vfio_ccw_drv.c
>> index 66a66ac1f3d1..34a9a5e3fd36 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -129,6 +129,11 @@ static int vfio_ccw_sch_probe(struct subchannel
>> *sch)
>>       if (!private)
>>           return -ENOMEM;
>>   +    private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct
>> ccw1),
>> +                       GFP_KERNEL);
>> +    if (!private->cp.guest_cp)
>> +        goto out_free;
>> +
>>       private->io_region = kmem_cache_zalloc(vfio_ccw_io_region,
>>                              GFP_KERNEL | GFP_DMA);
>>       if (!private->io_region)
>> @@ -169,6 +174,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>>           kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
>>       if (private->io_region)
>>           kmem_cache_free(vfio_ccw_io_region, private->io_region);
>> +    kfree(private->cp.guest_cp);
>>       kfree(private);
>>       return ret;
>>   }
>> @@ -185,6 +191,7 @@ static int vfio_ccw_sch_remove(struct subchannel
>> *sch)
>>         kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
>>       kmem_cache_free(vfio_ccw_io_region, private->io_region);
>> +    kfree(private->cp.guest_cp);
>>       kfree(private);
>>         return 0;
>>
