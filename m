Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB064A81
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfGJQK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:10:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727747AbfGJQK2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jul 2019 12:10:28 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AG7Gqb139870
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 12:10:27 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tnjettbdm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 12:10:26 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Wed, 10 Jul 2019 17:10:26 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 10 Jul 2019 17:10:23 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6AGALcR50266582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 16:10:21 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB956E04C;
        Wed, 10 Jul 2019 16:10:21 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 601956E053;
        Wed, 10 Jul 2019 16:10:21 +0000 (GMT)
Received: from [9.56.58.103] (unknown [9.56.58.103])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jul 2019 16:10:21 +0000 (GMT)
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562616169.git.alifm@linux.ibm.com>
 <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
 <20190709121613.6a3554fa.cohuck@redhat.com>
 <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
 <20190709162142.789dd605.pasic@linux.ibm.com>
 <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
 <20190710154549.5c31cc0c.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Wed, 10 Jul 2019 12:10:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190710154549.5c31cc0c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19071016-0012-0000-0000-0000174E6CF8
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011405; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01230223; UDB=6.00647965; IPR=6.01011492;
 MB=3.00027667; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-10 16:10:25
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071016-0013-0000-0000-000058038C3B
Message-Id: <75e71cc4-7552-b9e5-5649-4de2cdd8f59a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/10/2019 09:45 AM, Cornelia Huck wrote:
> On Tue, 9 Jul 2019 17:27:47 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
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
>>>>>>
>>>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>>>>> ---
>>>>>>     drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>>>>>> index 4e3a903..0357165 100644
>>>>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>>>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>>>>> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>>>>>     		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>>>>>     	if (scsw_is_solicited(&irb->scsw)) {
>>>>>>     		cp_update_scsw(&private->cp, &irb->scsw);
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
> 
> Now I went through the machine check rabbit hole because I thought
> freeing the cp in there might be a good idea, but it's not that easy
> (who'd have thought...)

Thanks for taking a deeper look :)

> 
> If I read the POP correctly, an IPI or IPR in the subchannel CRW will
> indicate that the subchannel has been restored to a state after an I/O
> reset; in particular, that means that the subchannel does not have any
> I/O pending. However, that does not seem to be the case e.g. for an IPM
> (the doc does not seem to be very clear on that, though.) We can't
> unconditionally do something, as we do not know what event we're being
> called for (please disregard the positively ancient "we're called for
> IPI" comment in css_process_crw(), I think I added that one in the
> Linux 2.4 or 2.5 timeframe...) tl;dr We can't rely on anything...

Yes, the CRW infrastructure in Linux does not convey the exact event 
back to the subchannel driver.

> 
>>
>>> Do we need to use atomic operations or external synchronization to avoid
>>> this being another gamble? Or am I missing something?
>>
>> I think we probably should think about atomic operations for
>> synchronizing the state (and it could be a separate add on patch?).
> 
> +1 to thinking about some atomicity changes later.
> 
>>
>> But for preventing 2 threads from stomping on the cp the check should be
>> enough, unless I am missing something?
> 
> I think so. Plus, the patch is small enough that we can merge it right
> away, and figure out a more generic change later.

I will send out a v3 soon if no one else has any other suggestions.

> 
>>
>>>    
>>>>>>     			cp_free(&private->cp);
>>>>>>     	}
>>>>>>     	mutex_lock(&private->io_mutex);
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
> 

