Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF8E63D4D
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 23:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbfGIV1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 17:27:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726428AbfGIV1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jul 2019 17:27:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69LQWrX032338;
        Tue, 9 Jul 2019 17:27:49 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tn0dcn9ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 17:27:49 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x69LOYJA007592;
        Tue, 9 Jul 2019 21:27:48 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 2tjk96qsms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 21:27:48 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69LRlC848300466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 21:27:47 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99DA428064;
        Tue,  9 Jul 2019 21:27:47 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D3612805E;
        Tue,  9 Jul 2019 21:27:47 +0000 (GMT)
Received: from [9.56.58.103] (unknown [9.56.58.103])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 21:27:47 +0000 (GMT)
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562616169.git.alifm@linux.ibm.com>
 <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
 <20190709121613.6a3554fa.cohuck@redhat.com>
 <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
 <20190709162142.789dd605.pasic@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Message-ID: <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
Date:   Tue, 9 Jul 2019 17:27:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190709162142.789dd605.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090258
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/09/2019 10:21 AM, Halil Pasic wrote:
> On Tue, 9 Jul 2019 09:46:51 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>>
>>
>> On 07/09/2019 06:16 AM, Cornelia Huck wrote:
>>> On Mon,  8 Jul 2019 16:10:37 -0400
>>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>>
>>>> There is a small window where it's possible that we could be working
>>>> on an interrupt (queued in the workqueue) and setting up a channel
>>>> program (i.e allocating memory, pinning pages, translating address).
>>>> This can lead to allocating and freeing the channel program at the
>>>> same time and can cause memory corruption.
>>>>
>>>> Let's not call cp_free if we are currently processing a channel program.
>>>> The only way we know for sure that we don't have a thread setting
>>>> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.
>>>
>>> Can we pinpoint a commit that introduced this bug, or has it been there
>>> since the beginning?
>>>
>>
>> I think the problem was always there.
>>
> 
> I think it became relevant with the async stuff. Because after the async
> stuff was added we start getting solicited interrupts that are not about
> channel program is done. At least this is how I remember the discussion.
> 
>>>>
>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>>>> index 4e3a903..0357165 100644
>>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>>> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>>>    		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>>>    	if (scsw_is_solicited(&irb->scsw)) {
>>>>    		cp_update_scsw(&private->cp, &irb->scsw);
>>>> -		if (is_final)
>>>> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> 
> Ain't private->state potentially used by multiple threads of execution?

yes

One of the paths I can think of is a machine check from the host which 
will ultimately call vfio_ccw_sch_event callback which could set state 
to NOT_OPER or IDLE.

> Do we need to use atomic operations or external synchronization to avoid
> this being another gamble? Or am I missing something?

I think we probably should think about atomic operations for 
synchronizing the state (and it could be a separate add on patch?).

But for preventing 2 threads from stomping on the cp the check should be 
enough, unless I am missing something?

> 
>>>>    			cp_free(&private->cp);
>>>>    	}
>>>>    	mutex_lock(&private->io_mutex);
>>>
>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>
>>>
>> Thanks for reviewing.
>>
>> Thanks
>> Farhan
> 
> 
