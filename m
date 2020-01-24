Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33FD148BA9
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 17:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbgAXQIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 11:08:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21140 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727306AbgAXQIS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jan 2020 11:08:18 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OFw3ZM048390;
        Fri, 24 Jan 2020 11:08:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xqmjtneb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jan 2020 11:08:17 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 00OFxr42054486;
        Fri, 24 Jan 2020 11:08:16 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xqmjtneab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jan 2020 11:08:16 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00OG5D5k028844;
        Fri, 24 Jan 2020 16:08:15 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 2xksn77vwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jan 2020 16:08:15 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00OG8EPo55640498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 16:08:14 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EE8D6E04E;
        Fri, 24 Jan 2020 16:08:14 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D8C86E050;
        Fri, 24 Jan 2020 16:08:13 +0000 (GMT)
Received: from [9.160.39.16] (unknown [9.160.39.16])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jan 2020 16:08:12 +0000 (GMT)
Subject: Re: [PATCH v1 1/1] vfio-ccw: Don't free channel programs for
 unrelated interrupts
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200124145455.51181-1-farman@linux.ibm.com>
 <20200124145455.51181-2-farman@linux.ibm.com>
 <20200124163305.3d6f0d47.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <50a0fe00-a7c1-50e4-12f5-412ee7a0e522@linux.ibm.com>
Date:   Fri, 24 Jan 2020 11:08:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200124163305.3d6f0d47.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_05:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 suspectscore=2 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/24/20 10:33 AM, Cornelia Huck wrote:
> On Fri, 24 Jan 2020 15:54:55 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> With the addition of asynchronous channel programs (HALT or CLEAR
>> SUBCHANNEL instructions), the hardware can receive interrupts that
>> are not related to any channel program currently active.  An attempt
>> is made to ensure that only associated resources are freed, but the
>> host can fail in unpleasant ways:
>>
>> [ 1051.330289] Unable to handle kernel pointer dereference in virtual kernel address space
>> [ 1051.330360] Failing address: c880003d16572000 TEID: c880003d16572803
>> [ 1051.330365] Fault in home space mode while using kernel ASCE.
>> [ 1051.330372] AS:00000000fde9c007 R3:0000000000000024
>> ...snip...
>> [ 1051.330539]  [<00000000fccbd33e>] __kmalloc+0xd6/0x3d8
>> [ 1051.330543] ([<00000000fccbd514>] __kmalloc+0x2ac/0x3d8)
>> [ 1051.330550]  [<000003ff801452b4>] cp_prefetch+0xc4/0x3b8 [vfio_ccw]
>> [ 1051.330554]  [<000003ff801471e4>] fsm_io_request+0x2d4/0x7b8 [vfio_ccw]
>> [ 1051.330559]  [<000003ff80145d9c>] vfio_ccw_mdev_write+0x17c/0x300 [vfio_ccw]
>> [ 1051.330564]  [<00000000fccf0d20>] vfs_write+0xb0/0x1b8
>> [ 1051.330568]  [<00000000fccf1236>] ksys_pwrite64+0x7e/0xb8
>> [ 1051.330574]  [<00000000fd4524c0>] system_call+0xdc/0x2d8
>>
>> The problem is corruption of the dma-kmalloc-8 slab [1], if an interrupt
>> occurs for a CLEAR or HALT that is not obviously associated with the
>> current channel program.  If the channel_program struct is freed AND
>> another interrupt for that I/O occurs, then this may occur:
>>
>> 583.612967 00          cp_prefetch  NEW SSCH
>> 583.613180 03 vfio_ccw_sch_io_todo  orb.cpa=03012690 irb.cpa=03012698
>>                                     ccw=2704004203015600 *cda=1955d8fb8
>>                                     irb: fctl=4 actl=0 stctl=7
>> 587.039292 04          cp_prefetch  NEW SSCH
>> 587.039296 01 vfio_ccw_sch_io_todo  orb.cpa=7fe209f0 irb.cpa=03012698
>>                                     ccw=3424000c030a4068 *cda=1999e9cf0
>>                                     irb: fctl=2 actl=0 stctl=1
>> 587.039505 01 vfio_ccw_sch_io_todo  orb.cpa=7fe209f0 irb.cpa=7fe209f8
>>                                     ccw=3424000c030a4068 *cda=0030a4070
>>                                     irb: fctl=4 actl=0 stctl=7
>>
>> Note how the last vfio_ccw_sch_io_todo() call has a ccw.cda that is
>> right next to its supposed IDAW, compared to the previous one?  That
>> is the result of the previous one freeing the cp (and its IDAL), and
>> kfree writing the next available address at the beginning of the
>> newly released memory.  When the channel goes to store data, it
>> believes the IDAW is valid and overwrites that pointer and causes
>> kmalloc to fail some time later.
>>
>> Since the vfio-ccw interrupt handler walks the list of ccwchain structs
>> to determine if the guest SCSW needs to be updated, it can be changed
>> to indicate whether the interrupt points within the channel_program.
>> If yes, then the channel_program is valid and its resources can be freed.
>> It not, then another interrupt is expected to do that later.
>>
>> [1] It could be other dma-kmalloc-xxx slabs; this just happens to be the
>> one driven most frequently in my testing.
>>
>> Fixes: f4c9939433bd ("vfio-ccw: Don't call cp_free if we are processing a channel program")
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>  drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++++--
>>  drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>>  drivers/s390/cio/vfio_ccw_drv.c |  4 ++--
>>  3 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index 3645d1720c4b..2d942433baf9 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -803,15 +803,19 @@ union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
>>   *
>>   * This function updates @scsw->cpa to its coressponding guest physical
>>   * address.
>> + *
>> + * Returns true if the channel program address in the irb was found
>> + * within the chain of CCWs for this channel program.
>>   */
>> -void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>> +bool cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>>  {
>>  	struct ccwchain *chain;
>>  	u32 cpa = scsw->cmd.cpa;
>>  	u32 ccw_head;
>> +	bool within_chain = false;
>>  
>>  	if (!cp->initialized)
>> -		return;
>> +		return false;
>>  
>>  	/*
>>  	 * LATER:
>> @@ -833,11 +837,14 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>>  			 * head gets us the guest cpa.
>>  			 */
>>  			cpa = chain->ch_iova + (cpa - ccw_head);
>> +			within_chain = true;
>>  			break;
>>  		}
>>  	}
>>  
>>  	scsw->cmd.cpa = cpa;
> 
> Looking at this, I'm wondering why we would want to update the cpa if
> !within_chain. But I'm probably too tired to review this properly
> today...

We probably don't, it's just what happens today and I didn't want to be
too disruptive (yet)  :)

> 
>> +
>> +	return within_chain;
>>  }
>>  
>>  /**
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
>> index ba31240ce965..a4cb6527bd4e 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.h
>> +++ b/drivers/s390/cio/vfio_ccw_cp.h
>> @@ -47,7 +47,7 @@ extern int cp_init(struct channel_program *cp, struct device *mdev,
>>  extern void cp_free(struct channel_program *cp);
>>  extern int cp_prefetch(struct channel_program *cp);
>>  extern union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
>> -extern void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
>> +extern bool cp_update_scsw(struct channel_program *cp, union scsw *scsw);
>>  extern bool cp_iova_pinned(struct channel_program *cp, u64 iova);
>>  
>>  #endif
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index e401a3d0aa57..a8ab256a217b 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -90,8 +90,8 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>  	is_final = !(scsw_actl(&irb->scsw) &
>>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>  	if (scsw_is_solicited(&irb->scsw)) {
>> -		cp_update_scsw(&private->cp, &irb->scsw);
>> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
>> +		if (cp_update_scsw(&private->cp, &irb->scsw) &&
>> +		    is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> 
> ...but I still wonder why is_final is not catching non-ssch related
> interrupts, as I thought it would. We might want to adapt that check,
> instead. (Or was the scsw_is_solicited() check supposed to catch that?
> As said, too tired right now...)

I had looked at the (un)solicited bits at one point, and saw very few
unsolicited interrupts.  The ones that did show up didn't appear to
affect things in the way that would cause the problems I'm seeing.

As for is_final...  That POPS table states that for "status pending
[alone] after termination of HALT or CLEAR ... cpa is unpredictable",
which is what happens here.  In the example above, the cpa is the same
as the previous (successful) interrupt, and thus unrelated to the
current chain.  Perhaps is_final needs to check that the function
control in the interrupt is for a start?

I will keep pondering the bit-checking before I hit my end of day.  Have
a fine weekend!

> 
>>  			cp_free(&private->cp);
>>  	}
>>  	mutex_lock(&private->io_mutex);
> 
