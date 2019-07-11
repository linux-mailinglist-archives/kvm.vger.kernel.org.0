Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2066068
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 22:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfGKUJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 16:09:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbfGKUJ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 16:09:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BK6nl4005034;
        Thu, 11 Jul 2019 16:09:24 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpat8avgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 16:09:24 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6BK4fq0025704;
        Thu, 11 Jul 2019 20:09:23 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk96xd5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 20:09:23 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BK9NXQ49349066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 20:09:23 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E939CAC059;
        Thu, 11 Jul 2019 20:09:22 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C266FAC05B;
        Thu, 11 Jul 2019 20:09:22 +0000 (GMT)
Received: from [9.60.89.60] (unknown [9.60.89.60])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 20:09:22 +0000 (GMT)
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Halil Pasic <pasic@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1562616169.git.alifm@linux.ibm.com>
 <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
 <20190709121613.6a3554fa.cohuck@redhat.com>
 <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
 <20190709162142.789dd605.pasic@linux.ibm.com>
 <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
 <20190711165703.3a1a8462.pasic@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <ed983668-44da-9e90-18b7-3f5d78164712@linux.ibm.com>
Date:   Thu, 11 Jul 2019 16:09:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711165703.3a1a8462.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110222
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/11/19 10:57 AM, Halil Pasic wrote:
> On Tue, 9 Jul 2019 17:27:47 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>>
>>
>> On 07/09/2019 10:21 AM, Halil Pasic wrote:
>>> On Tue, 9 Jul 2019 09:46:51 -0400
>>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>>
>>>>
>>>>
>>>> On 07/09/2019 06:16 AM, Cornelia Huck wrote:
>>>>> On Mon,  8 Jul 2019 16:10:37 -0400
>>>>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>>>>
>>>>>> There is a small window where it's possible that we could be working
>>>>>> on an interrupt (queued in the workqueue) and setting up a channel
>>>>>> program (i.e allocating memory, pinning pages, translating address).
>>>>>> This can lead to allocating and freeing the channel program at the
>>>>>> same time and can cause memory corruption.
>>>>>>
>>>>>> Let's not call cp_free if we are currently processing a channel program.
>>>>>> The only way we know for sure that we don't have a thread setting
>>>>>> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.
>>>>>
>>>>> Can we pinpoint a commit that introduced this bug, or has it been there
>>>>> since the beginning?
>>>>>
>>>>
>>>> I think the problem was always there.
>>>>
>>>
>>> I think it became relevant with the async stuff. Because after the async
>>> stuff was added we start getting solicited interrupts that are not about
>>> channel program is done. At least this is how I remember the discussion.
>>>
> 
> You seem to have ignored this comment. 

I read both comments as being in agreement with one another.  The
problem has always been there, but didn't mean anything until we had
another mechanism (async) to drive additional interrupts.  Hence the v3
patch including the async patch in a Fixes tag.

BTW wasn't the cp->is_initialized
> make 'Make it safe to call the cp accessors in any case, so we can call
> them unconditionally.'?
> 
> @Connie: Your opinion as the author of that patch and of the cited
> sentence?
> >>>>>>
>>>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>>>>> ---
>>>>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>>>>>> index 4e3a903..0357165 100644
>>>>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>>>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>>>>> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>>>>>    		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>>>>>    	if (scsw_is_solicited(&irb->scsw)) {
>>>>>>    		cp_update_scsw(&private->cp, &irb->scsw);
>>>>>> -		if (is_final)
>>>>>> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
>>>
>>> Ain't private->state potentially used by multiple threads of execution?
>>
>> yes
>>
>> One of the paths I can think of is a machine check from the host which 
>> will ultimately call vfio_ccw_sch_event callback which could set state 
>> to NOT_OPER or IDLE.
>>
>>> Do we need to use atomic operations or external synchronization to avoid
>>> this being another gamble? Or am I missing something?
>>
>> I think we probably should think about atomic operations for 
>> synchronizing the state (and it could be a separate add on patch?).
>>
>> But for preventing 2 threads from stomping on the cp the check should be 
>> enough, unless I am missing something?
>>
> 
> Usually programming languages don't like incorrectly synchronized
> programs. One tends to end up in undefined behavior land -- form language
> perspective. That doesn't actually mean you are bound to see strange
> stuff. With implementation spec + ABI spec + platform/architecture
> spec one may end up with things being well defined. But it that is a much
> deeper rabbit hole.
> 
> The nice thing about condition state == VFIO_CCW_STATE_CP_PENDING is
> that it can tolerate stale state values. The bad case at hand
> (you free but you should not) would be we see a stale
> VFIO_CCW_STATE_CP_PENDING but we are actually
> VFIO_CCW_STATE_CP_PROCESSING. That is pretty difficult to imagine
> because one can enter VFIO_CCW_STATE_CP_PROCESSING only form
> VFIO_CCW_STATE_CP_PENDING afair. 

I think you're backwards here.  The path is IDLE -> CP_PROCESSING ->
(CP_PENDING | IDLE)

On s390x torn reads/writes (i.e.
> observing something that ain't either the old nor the new value) on an
> int shouldn't be a concern.
> 
> The other bad case (where you don't free albeit you should) looks a
> bit trickier.

I'm afraid I don't understand your intention with the above paragraphs.  :(

> 
> I'm not a fan of keeping races around without good reasons. And I don't
> see good reasons here. I'm no fan of needlessly complicated solutions
> either.
> 
> But seems, at least with my beliefs about races, I'm the oddball
> here. 

The "race" here is that we have one synchronous operation (SSCH) and two
asynchronous operations (HSCH, CSCH), both of which interact with one
another and generate interrupts that pass through this chunk of code.

I have not fully considered this patch yet, but the race is a concern to
all of us oddballs.  I have not chimed in any great detail because I
only got through the first couple patches in v1 before going on holiday,
and the discussions on v1/v2 are numerous.

 - Eric

> 
> Regards,
> Halil
> 
>>>
>>>>>>    			cp_free(&private->cp);
>>>>>>    	}
>>>>>>    	mutex_lock(&private->io_mutex);
>>>>>
>>>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>>>
>>>>>
>>>> Thanks for reviewing.
>>>>
>>>> Thanks
>>>> Farhan
>>>
>>>
> 
