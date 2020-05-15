Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D171D58F3
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgEOSTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 14:19:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgEOSTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 14:19:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FI3bAG063099;
        Fri, 15 May 2020 14:19:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 311rdp7f08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:19:48 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FIB8eO092491;
        Fri, 15 May 2020 14:19:47 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 311rdp7eyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:19:47 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FIFYHw031323;
        Fri, 15 May 2020 18:19:47 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3100uc7er6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:19:47 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FIJkP254198696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 18:19:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7CD28058;
        Fri, 15 May 2020 18:19:46 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9DF628059;
        Fri, 15 May 2020 18:19:45 +0000 (GMT)
Received: from [9.160.52.192] (unknown [9.160.52.192])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 18:19:45 +0000 (GMT)
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200513142934.28788-1-farman@linux.ibm.com>
 <20200514154601.007ae46f.pasic@linux.ibm.com>
 <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
 <20200515165539.2e4a8485.pasic@linux.ibm.com>
 <20200515175850.79e2ac74.cohuck@redhat.com>
 <20200515194135.2fbac8a3.pasic@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <4c7d58ac-613c-ccb5-a5da-a72df3aa6ddc@linux.ibm.com>
Date:   Fri, 15 May 2020 14:19:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515194135.2fbac8a3.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 cotscore=-2147483648 priorityscore=1501 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 phishscore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/20 1:41 PM, Halil Pasic wrote:
> On Fri, 15 May 2020 17:58:49 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> [only some very high-level comments; I have not had time for this yet
>> and it's late on a Friday]
>>
>> On Fri, 15 May 2020 16:55:39 +0200
>> Halil Pasic <pasic@linux.ibm.com> wrote:
>>
>>> On Fri, 15 May 2020 09:09:47 -0400
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>
>>>>
>>>>
>>>> On 5/14/20 9:46 AM, Halil Pasic wrote:  
>>>>> On Wed, 13 May 2020 16:29:30 +0200
>>>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>>>   
>>>>>> Hi Conny,
>>>>>>
>>>>>> Back in January, I suggested a small patch [1] to try to clean up
>>>>>> the handling of HSCH/CSCH interrupts, especially as it relates to
>>>>>> concurrent SSCH interrupts. Here is a new attempt to address this.
>>>>>>
>>>>>> There was some suggestion earlier about locking the FSM, but I'm not
>>>>>> seeing any problems with that. Rather, what I'm noticing is that the
>>>>>> flow between a synchronous START and asynchronous HALT/CLEAR have
>>>>>> different impacts on the FSM state. Consider:
>>>>>>
>>>>>>     CPU 1                           CPU 2
>>>>>>
>>>>>>     SSCH (set state=CP_PENDING)
>>>>>>     INTERRUPT (set state=IDLE)
>>>>>>     CSCH (no change in state)
>>>>>>                                     SSCH (set state=CP_PENDING)
>>>>>>     INTERRUPT (set state=IDLE)
>>>>>>                                     INTERRUPT (set state=IDLE)  
>>>>>
>>>>> How does the PoP view of the composite device look like 
>>>>> (where composite device = vfio-ccw + host device)?  
>>>>
>>>> (Just want to be sure that "composite device" is a term that you're
>>>> creating, because it's not one I'm familiar with.)  
>>>
>>> Yes I created this term because I'm unaware of an established one, and
>>> I could not come up with a better one. If you have something established
>>> or better please do tell, I will start using that.
>>
>> I don't think "composite" is a term I would use; in the end, we are
>> talking about a vfio-ccw device that gets some of its state from the
>> host device. As such, I don't think there's really anything like a "PoP
>> view" of it; the part that should comply with what the PoP specifies is
>> what gets exposed to the guest.
> 
> I agree, what matters is the architectural compliance of the device as
> exposed to the guest. I tried to refer the architectural view of the
> whole device as the PoP view. The diagram above is clearly operating
> on the vfio-ccw kernel module level as state=IDLE and state=CP_PENDING
> is stuff on that level.
> 
> What I tried to illuminate by using the word 'composite', is that what
> the guest sees is a superposition of what the QEMU code does, what the
> kernel module code does and what the host device does. And that the
> situation described should have been prevented prior the second
> SSCH hitting the kernel module (at least according to my understanding).
> 
> Let us forget about the term composite. But we do have be aware of how
> things compose. ;)
> 
>>
>>>
>>>>
>>>> In today's code, there isn't a "composite device" that contains
>>>> POPs-defined state information like we find in, for example, the host
>>>> SCHIB, but that incorporates vfio-ccw state. This series (in a far more
>>>> architecturally valid, non-RFC, form) would get us closer to that.
>>>>   
>>>
>>> I think it is very important to start thinking about the ccw devices
>>> that are exposed to the guest as a "composite device" in a sense that
>>> the (passed-through) host ccw device is wrapped by vfio-ccw. For instance
>>> the guest sees the SCHIB exposed by the vfio-ccw wrapper (adaptation
>>> code in qemu and the kernel module), and not the SCHIB of the host
>>> device.
>>
>> See my comments on that above.
>>
> 
> Sorry for muddying the water. :(
>  
>>>
>>> This series definitely has some progressive thoughts. It just that
>>> IMHO we sould to be more radical about this. And yes I'm a bit
>>> frustrated.
>>>
>>>>>
>>>>> I suppose at the moment where we accept the CSCH the FC bit
>>>>> indicated clear function (19) goes to set. When this happens
>>>>> there are 2 possibilities: either the start (17) bit is set,
>>>>> or it is not. You describe a scenario where the start bit is
>>>>> not set. In that case we don't have a channel program that
>>>>> is currently being processed, and any SSCH must bounce right
>>>>> off without doing anything (with cc 2) as long as FC clear
>>>>> is set. Please note that we are still talking about the composite
>>>>> device here.  
>>>>
>>>> Correct. Though, whether the START function control bit is currently set
>>>> is immaterial to a CLEAR function; that's the biggest recovery action we
>>>> have at our disposal, and will always go through.
>>>>
>>>> The point is that there is nothing to prevent the START on CPU 2 from
>>>> going through. The CLEAR does not affect the FSM today, and doesn't
>>>> record a FC CLEAR bit within vfio-ccw, and so we're only relying on the
>>>> return code from the SSCH instruction to give us cc0 vs cc2 (or
>>>> whatever). The actual results of that will depend, since the CPU may
>>>> have presented the interrupt for the CLEAR (via the .irq callback and
>>>> thus FSM VFIO_CCW_EVENT_INTERRUPT) and thus a new START is perfectly
>>>> legal from its point of view. Since vfio-ccw may not have unstacked the
>>>> work it placed to finish up that interrupt handler means we have a problem.
>>>>   
>>>>>
>>>>> Thus in my reading CPU2 making the IDLE -> CP_PENDING transition
>>>>> happen is already wrong. We should have rejected to look at the
>>>>> channel program in the first place. Because as far as I can tell
>>>>> for the composite device the FC clear bit remains set until we
>>>>> process the last interrupt on the CPU 1 side in your scenario. Or
>>>>> am I wrong?  
>>>>
>>>> You're not wrong. You're agreeing with everything I've described.  :)
>>>>   
>>>
>>> I'm happy our understanding seems to converge! :)
>>>
>>> My problem is that you tie the denial of SSCH to outstanding interrupts
>>> ("C) A SSCH cannot be issued while an interrupt is outstanding") while
>>> the PoP says "Condition code 2 is set, and no other action is
>>> taken, when a start, halt, or clear function is currently
>>> in progress at the subchannel (see “Function Control
>>> (FC)” on page 16-22)".
>>>
>>> This may or man not be what you have actually implemented, but it is what
>>> you describe in this cover letter. Also patches 2 and 3 do the 
>>> serialization operate on activity controls instead of on the function
>>> controls (as described by the PoP).
>>
>> I have not really had the cycles yet to look at this series in detail,
>> but should our goal really be to mimic what the PoP talks about in
>> vfio-ccw (both kernel and userspace parts)? IMO, the important part is
>> that the guest sees a device that acts *towards the guest* in a way
>> that is compliant with the PoP; we can take different paths inside
>> vfio-ccw.
> 
> I agree with the principle, but I don't agree with some of the paths
> taken :)

Hey, I didn't agree with your FSM locking either, and then marked this
as an RFC.  :)

> 
> Moreover, each time we decide to not take the path that maps the PoP
> in the most straightforward fashion, we better be very careful.
> 
>>
>> (...)
>>
>>> BTW the whole notion of synchronous and asynchronous commands is IMHO
>>> broken. I tried to argue against it back then. If you read the PoP SSCH
>>> is asynchronous as well.
>>
>> I don't see where we ever stated that SSCH was synchronous. That would
>> be silly. The async region is called the async region because it is
>> used for some async commands (HSCH/CSCH), not because it is the only
>> way to do async commands. (The original idea was to extend the I/O
>> region for HSCH/CSCH, but that turned out to be awkward.)
> 
> What I don't understand is why are HALT and CLEAR async commands, and
> START a synchronous command, or a non-async command.

As I mentioned in my other response, I introduced this confusion. What I
wanted to convey was that it's a distinction between the io_region (for
SSCH) and the async_region (HSCH/CSCH) ... Writing to the former affects
the vfio-ccw FSM, and the writing to the latter does not. That is all I
wished to convey. I did not intend to convey how the operations are
architected in POPs nor how they work in hardware (or vfio-ccw, minus
the regions being used).

> 
>>
>> (...)
>>
>> I hope I can find more time to look at this next week, but as it will
>> be a short work week for me and I'm already swamped with various other
>> things, I fear that you should keep your expectations low.

These next handful of days are not great for me either, so no rush. It's
just the next thing on my list after Channel Path Handling.

>>
> 
> Thanks for chiming in. And please do complain when I talk silly.
> Unfortunately I'm no great communicator.
> 
> Regards,
> Halil
> 
