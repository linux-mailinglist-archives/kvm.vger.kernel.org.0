Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6C54EECD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 20:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfFUSeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 14:34:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfFUSeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jun 2019 14:34:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LILt7u046796;
        Fri, 21 Jun 2019 14:34:12 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t92uwm6mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 14:34:12 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5LIL7ZZ024847;
        Fri, 21 Jun 2019 18:34:11 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 2t8hrp631k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 18:34:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LIYAtr50725172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 18:34:11 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF4B028059;
        Fri, 21 Jun 2019 18:34:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B7A2805E;
        Fri, 21 Jun 2019 18:34:10 +0000 (GMT)
Received: from [9.56.58.42] (unknown [9.56.58.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jun 2019 18:34:10 +0000 (GMT)
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Eric Farman <farman@linux.ibm.com>, cohuck@redhat.com
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1561055076.git.alifm@linux.ibm.com>
 <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
 <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
 <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
 <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Message-ID: <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
Date:   Fri, 21 Jun 2019 14:34:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/21/2019 01:40 PM, Eric Farman wrote:
> 
> 
> On 6/21/19 10:17 AM, Farhan Ali wrote:
>>
>>
>> On 06/20/2019 04:27 PM, Eric Farman wrote:
>>>
>>>
>>> On 6/20/19 3:40 PM, Farhan Ali wrote:
>>>> There is a small window where it's possible that an interrupt can
>>>> arrive and can call cp_free, while we are still processing a channel
>>>> program (i.e allocating memory, pinnging pages, translating
>>>
>>> s/pinnging/pinning/
>>>
>>>> addresses etc). This can lead to allocating and freeing at the same
>>>> time and can cause memory corruption.
>>>>
>>>> Let's not call cp_free if we are currently processing a channel program.
>>>
>>> The check around this cp_free() call is for a solicited interrupt, so
>>> it's presumably in response to a SSCH we issued.  But if we're still
>>> processing a CP, then we hadn't issued the SSCH to the hardware yet.  So
>>> what is this interrupt for?  Do the contents of irb.cpa provide any
>>> clues, perhaps if it's in the current cp or for someone else?
>>>
>>
>> I don't think the interrupt is in response to an ssch but rather due to
>> an csch/hsch.
>>
>>>>
>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>>> ---
>>>>
>>>> I have been running my test overnight with this patch and I haven't
>>>> seen the stack traces that I mentioned about earlier. I would like
>>>> to get some reviews on this and also if this is the right thing to
>>>> do?
>>>>
>>>> Thanks
>>>> Farhan
>>>>
>>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
>>>> b/drivers/s390/cio/vfio_ccw_drv.c
>>>> index 66a66ac..61ece3f 100644
>>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>>> @@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct
>>>> *work)
>>>>                 (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>>>        if (scsw_is_solicited(&irb->scsw)) {
>>>>            cp_update_scsw(&private->cp, &irb->scsw);
>>>
>>> As I alluded earlier, do we know this irb is for this cp?  If no, what
>>> does this function end up putting in the scsw?
>>>
>>>> -        if (is_final)
>>>> +        if (is_final && private->state != VFIO_CCW_STATE_CP_PROCESSING)
>>>
>>> In looking at how we set this state, and how we exit it, I see we do:
>>>
>>> if SSCH got CC0, CP_PROCESSING -> CP_PENDING
>>> if SSCH got !CC0, CP_PROCESSING -> IDLE
>>>
>>> While the first scenario happens immediately after the SSCH instruction,
>>> I guess it could be just tiny enough, like the io_trigger FSM patch I
>>> sent a few weeks ago.
>>>
>>> Meanwhile, the latter happens way after we return from the jump table.
>>> So that scenario leaves considerable time for such an interrupt to
>>> occur, though I don't understand why it would if we got a CC(1-3) on the
>>> SSCH.
>>>
>>> And anyway, the return from fsm_io_helper() in that case will also call
>>> cp_free().  So why does the cp->initialized check provide protection
>>> from a double-free in that direction, but not here?  I'm confused.
>>
>> I have a theory where I think it's possible to have 2 different threads
>> executing cp_free
>>
>> If we start with private->state == IDLE and the guest issues a
>> clear/halt and then an ssch
>>
>> - clear/halt will be issued to hardware, and if succeeds we will return
>> cc=0 to guest
>>
>> - the guest can then issue ssch
> 
> It can issue whatever it wants, but shouldn't the SSCH get a CC2 until
> the halt/clear pending state is cleared?  Hrm, fsm_io_request() doesn't
> look.  Rather, it (fsm_io_helper()) relies on the CC2 to be signalled
> from the SSCH issued to the device.  There's a lot of stuff that happens
> before we get to that point.

Yes, and stuff that happens is memory allocation, pinning and other 
things which can take time.

> 
> I'm wondering if there's a way we could/should return the SSCH here
> before we do any processing.  After all, until the interrupt on the
> workqueue is processed, we are busy.
> 

you mean return the csch/hsch before processing the ssch? Maybe we could 
extend CP_PENDING state, to just PENDING and use that to reject any ssch 
if we have a pending csch/hsch?

>>
>> - we get an interrupt for csch/hsch and we queue the interrupt in the
>> workqueue
>>
>> - we start processing the ssch and then at the same time another cpu
>> could be working on the
>> interrupt>
>>
>> Thread 1                                        Thread 2
>> --------                                        --------
>>
>> fsm_io_request                                  vfio_ccw_sch_io_todo
>>      cp_init                                         cp_free
>>      cp_prefetch
>>      fsm_io_helper
>>          cp_free
>>
>>
>>
>> The test that I am trying is with a guest running an fio workload, while
>> at the same time stressing the error recovery path in the guest. So
>> there is a lot of ssch and lot of csch.
>>
>> Of course I don't think my patch completely solves the problem, I think
>> it just makes the window narrower. I just wanted to get a discussion
>> started :)
>>
>>
>> Now that I am thinking more about it, I think we might have to protect
>> cp with it's own mutex.
> 
> That seems like a big hammer, and I wonder if the existing SCHIB/FSM/CP
> state data doesn't provide that information to us.  But I gotta wander
> around some code before I say.

Any ideas are welcome :)

> 
>>
>> Thanks
>> Farhan
>>
>>
>>>
>>>>                cp_free(&private->cp);
>>>>        }
>>>>        mutex_lock(&private->io_mutex);
>>>>
>>>
>>
> 
