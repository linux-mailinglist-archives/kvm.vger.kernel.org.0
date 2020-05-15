Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8611D58B8
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 20:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgEOSML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 14:12:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28156 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOSML (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 14:12:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FI17tS067608;
        Fri, 15 May 2020 14:12:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101kr97h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:12:08 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FI2jGw077882;
        Fri, 15 May 2020 14:12:07 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101kr97gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:12:07 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FIAKVY020293;
        Fri, 15 May 2020 18:12:07 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 3100ubs35f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:12:07 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FIC6hD54984982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 18:12:06 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 989B428059;
        Fri, 15 May 2020 18:12:06 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 030D928058;
        Fri, 15 May 2020 18:12:05 +0000 (GMT)
Received: from [9.160.52.192] (unknown [9.160.52.192])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 18:12:05 +0000 (GMT)
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200513142934.28788-1-farman@linux.ibm.com>
 <20200514154601.007ae46f.pasic@linux.ibm.com>
 <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
 <20200515165539.2e4a8485.pasic@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <931b96fc-0bb5-cdc1-bb1c-102a96f346ea@linux.ibm.com>
Date:   Fri, 15 May 2020 14:12:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515165539.2e4a8485.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 cotscore=-2147483648 mlxlogscore=999 adultscore=0 clxscore=1015
 suspectscore=2 spamscore=0 phishscore=0 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/20 10:55 AM, Halil Pasic wrote:
> On Fri, 15 May 2020 09:09:47 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>>
>>
>> On 5/14/20 9:46 AM, Halil Pasic wrote:
>>> On Wed, 13 May 2020 16:29:30 +0200
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>
>>>> Hi Conny,
>>>>
>>>> Back in January, I suggested a small patch [1] to try to clean up
>>>> the handling of HSCH/CSCH interrupts, especially as it relates to
>>>> concurrent SSCH interrupts. Here is a new attempt to address this.
>>>>
>>>> There was some suggestion earlier about locking the FSM, but I'm not
>>>> seeing any problems with that. Rather, what I'm noticing is that the
>>>> flow between a synchronous START and asynchronous HALT/CLEAR have
>>>> different impacts on the FSM state. Consider:
>>>>
>>>>     CPU 1                           CPU 2
>>>>
>>>>     SSCH (set state=CP_PENDING)
>>>>     INTERRUPT (set state=IDLE)
>>>>     CSCH (no change in state)
>>>>                                     SSCH (set state=CP_PENDING)
>>>>     INTERRUPT (set state=IDLE)
>>>>                                     INTERRUPT (set state=IDLE)
>>>
>>> How does the PoP view of the composite device look like 
>>> (where composite device = vfio-ccw + host device)?
>>
>> (Just want to be sure that "composite device" is a term that you're
>> creating, because it's not one I'm familiar with.)
> 
> Yes I created this term because I'm unaware of an established one, and
> I could not come up with a better one. If you have something established
> or better please do tell, I will start using that.
> 
>>
>> In today's code, there isn't a "composite device" that contains
>> POPs-defined state information like we find in, for example, the host
>> SCHIB, but that incorporates vfio-ccw state. This series (in a far more
>> architecturally valid, non-RFC, form) would get us closer to that.
>>
> 
> I think it is very important to start thinking about the ccw devices
> that are exposed to the guest as a "composite device" in a sense that
> the (passed-through) host ccw device is wrapped by vfio-ccw. For instance
> the guest sees the SCHIB exposed by the vfio-ccw wrapper (adaptation
> code in qemu and the kernel module), and not the SCHIB of the host
> device.

Well, I think of "ccw devices that are exposed to the guest" as
"vfio-ccw devices" ... They look/smell/sound like CCW devices to the
guest, but have some pieces emulated by QEMU and some passed down to the
host kernel (and/or the device itself). I'm not sure what a "composite
device" buys us in any other context.

> 
> This series definitely has some progressive thoughts. It just that
> IMHO we sould to be more radical about this. And yes I'm a bit
> frustrated.

"we sould to be more radical about this" ... A little help please?

> 
>>>
>>> I suppose at the moment where we accept the CSCH the FC bit
>>> indicated clear function (19) goes to set. When this happens
>>> there are 2 possibilities: either the start (17) bit is set,
>>> or it is not. You describe a scenario where the start bit is
>>> not set. In that case we don't have a channel program that
>>> is currently being processed, and any SSCH must bounce right
>>> off without doing anything (with cc 2) as long as FC clear
>>> is set. Please note that we are still talking about the composite
>>> device here.
>>
>> Correct. Though, whether the START function control bit is currently set
>> is immaterial to a CLEAR function; that's the biggest recovery action we
>> have at our disposal, and will always go through.
>>
>> The point is that there is nothing to prevent the START on CPU 2 from
>> going through. The CLEAR does not affect the FSM today, and doesn't
>> record a FC CLEAR bit within vfio-ccw, and so we're only relying on the
>> return code from the SSCH instruction to give us cc0 vs cc2 (or
>> whatever). The actual results of that will depend, since the CPU may
>> have presented the interrupt for the CLEAR (via the .irq callback and
>> thus FSM VFIO_CCW_EVENT_INTERRUPT) and thus a new START is perfectly
>> legal from its point of view. Since vfio-ccw may not have unstacked the
>> work it placed to finish up that interrupt handler means we have a problem.
>>
>>>
>>> Thus in my reading CPU2 making the IDLE -> CP_PENDING transition
>>> happen is already wrong. We should have rejected to look at the
>>> channel program in the first place. Because as far as I can tell
>>> for the composite device the FC clear bit remains set until we
>>> process the last interrupt on the CPU 1 side in your scenario. Or
>>> am I wrong?
>>
>> You're not wrong. You're agreeing with everything I've described.  :)
>>
> 
> I'm happy our understanding seems to converge! :)
> 
> My problem is that you tie the denial of SSCH to outstanding interrupts
> ("C) A SSCH cannot be issued while an interrupt is outstanding") while
> the PoP says "Condition code 2 is set, and no other action is
> taken, when a start, halt, or clear function is currently
> in progress at the subchannel (see “Function Control
> (FC)” on page 16-22)".
> 
> This may or man not be what you have actually implemented, but it is what
> you describe in this cover letter. Also patches 2 and 3 do the 
> serialization operate on activity controls instead of on the function
> controls (as described by the PoP).

You are conflating two issues here...

1) I do use the ACTL bits in this RFC, which is almost certainly wrong
according to the POPs. But as I suggest here in this cover letter as
well as the commit message for later patches, that's irrelevant. We're
not reflecting these particular bits (or anything else in this SCSW)
back in any way/shape/form today, and they are not used for any other
decision making. I could signal the existence of another operation by
the FSM, or via three non-architected flags, or via the (correct)
architected flags.

2) The denial of the SSCH. You quote the POPs above which says "no other
action is taken, when a start, halt, or clear function is currently in
progress at the subchannel" ... But in this case, vfio-ccw has to
supplement the role of the subchannel. It's NOT done processing the
interrupt, even though the device, subchannel, and (host) CPU think it
all is.

> 
>>>
>>> AFAIR I was preaching about this several times, but could never
>>> convince the people that 'let the host ccw device sort out
>>> concurrency' is not the way this should work.
>>
>> I'm going to ignore this paragraph.
>>
> 
> ;) Wise, was just frustration venting on my side.
> 
>>>
>>> Maybe I have got a hole in my argument somewhere. If my argument
>>> is wrong, please do point out why!
>>>
>>>>
>>>> The second interrupt on CPU 1 will call cp_free() for the START
>>>> created by CPU 2, and our results will be, um, messy. This
>>>> suggests that three things must be true:
>>>>
>>>>  A) cp_free() must be called for either a final interrupt,
>>>> or a failure issuing a SSCH
>>>>  B) The FSM state must only be set to IDLE once cp_free()
>>>> has been called
>>>>  C) A SSCH cannot be issued while an interrupt is outstanding
>>>
>>> So you propose to reject SSCH in the IDLE state (if an interrupt
>>> is outstanding)? That is one silly IDLE state and FSM for sure.
>>
>> And sending a HSCH/CSCH without affecting the FSM or a POPs-valid
>> structure is not silly?
>>
> 
> It is silly! I'm frustrated because I could not convince my peers that
> it is silly.
> 
>>>
>>>>
>>>> It's not great that items B and C are separated in the interrupt
>>>> path by a mutex boundary where the copy into io_region occurs.
>>>> We could (and perhaps should) move them together, which would
>>>> improve things somewhat, but still doesn't address the scenario
>>>> laid out above. Even putting that work within the mutex window
>>>> during interrupt processing doesn't address things totally.
>>>>
>>>> So, the patches here do two things. One to handle unsolicited
>>>> interrupts [2], which I think is pretty straightforward. Though,
>>>> it does make me want to do a more drastic rearranging of the
>>>> affected function. :)
>>>>
>>>> The other warrants some discussion, since it's sort of weird.
>>>> Basically, recognize what commands we've issued, expect interrupts
>>>> for each, and prevent new SSCH's while asynchronous commands are
>>>> pending. It doesn't address interrupts from the HSCH/CSCH that
>>>> could be generated by the Channel Path Handling code [3] for an
>>>> offline CHPID yet, and it needs some TLC to make checkpatch happy.
>>>> But it's the best possibility I've seen thus far.
>>>>
>>>> I used private->scsw for this because it's barely used for anything
>>>> else; at one point I had been considering removing it outright because
>>>> we have entirely too many SCSW's in this code. :) I could implement
>>>> this as three small flags in private, to simplify the code and avoid
>>>> confusion with the different fctl/actl flags in private vs schib.
>>>>
>>>
>>> Implementing the FSM described in the PoP (which in turn
>>> conceptually relies on atomic operations on the FC bits) is IMHO
>>> the way to go. But we can track that info in our FSM states. In
>>> fact our FSM states should just add sub-partitioning of states to
>>> those states (if necessary).
>>
>> I'm not prepared to rule this out, as I originally stated, but I'm not
>> thrilled with this idea. Today, we have FSM events for an IO (START) and
>> asynchronous commands (HALT and CLEAR), and we have FSM states for the
>> different stages of a START operation. Making asynchronous commands
>> affect the FSM state isn't too big of a problem, but what happens if we
>> expand the asynchronous support to handle other commands, such as CANCEL
>> or RESUME? They don't have FC bits of their own to map into an FSM, and
>> (just like HALT/CLEAR) have some reliance on the fctl/actl/stctl bits of
>> the SCHIB.
>>
> 
> Well, fctl/actl/stctl can be seen as a possible representation of states
> and state transitions. For example for RESUME the PoP says
> "Condition code 2 is set, and no other action is
> taken, when the resume function is not applicable.
> The resume function is not applicable when the sub-
> channel (1) has any function other than the start
> function alone specified, (2) has no function speci-
> fied, (3) is resume pending, or (4) does not have sus-
> pend control specified for the start function in
> progress"
> 
> What I'm trying to say is, there is a state machine described in the PoP,
> and there the state transitions are marked by interlocked updates of bits
> in fctl/actl/stctl. I don't know how many bits relevant for the state
> machine are, but I'm pretty confident they can be packaged up in a
> quadword. So if we want we can represent that stuff with a state variable
> of ours.
> 
> BTW the whole notion of synchronous and asynchronous commands is IMHO
> broken. I tried to argue against it back then. If you read the PoP SSCH
> is asynchronous as well.

That is my fault. I was only trying to distinguish the existing
io_region used for SSCH and the new async_region used for HSCH and CSCH.

> 
>> The fact that you're talking about sub-partitioning of states, as we
>> have with CP_PROCESSING and CP_PENDING in the context of a START,
>> suggest we'd drift farther from what one actually finds in POPs and make
>> it harder to decipher what vfio-ccw is actually up to.
>>
> 
> Yes. This may or may not be justified. Because we need to do that
> translation-prefetching and we need to do some cleanup that in a
> non-virtualized context isn't there additional states may be beneficial
> or even necessary. But if our state machine is interlacing with
> the PoP state machine something is very wrong.
> 
>>>
>>>
>>>> It does make me wonder whether the CP_PENDING check before cp_free()
>>>> is still necessary, but that's a query for a later date.
>>>>
>>>> Also, perhaps this could be accomplished with two new FSM states,
>>>> one for a HALT and one for a CLEAR. I put it aside because the
>>>> interrupt handler got a little hairy with that, but I'm still looking
>>>> at it in parallel to this discussion.
>>>>
>>>
>>> You don't necessarily need 2 new states. Just one that corresponds
>>> to FC clear function will do.
>>
>> I don't think so. Maybe for my example above regarding a CSCH, but we
>> can issue a HSCH in the same way today, and a HALT should also get a cc2
>> if either a HALT or CLEAR command is already in progress. Just as a
>> START should get cc2 for a START, HALT, or CLEAR.
>>
> 
> Right. I was wrong. I misremembered something and mixed stuff up. We
> have separate FC bits for HALT and CLEAR in the PoP and that's for a
> good reason. Sorry for the noise.
> 
>>>
>>>> I look forward to hearing your thoughts...
>>>
>>> Please see above ;)
>>>
>>> Also why do we see the scenario you describe in the wild? I agree that
>>> this should be taken care of in the kernel as well, but according to my
>>> understanding QEMU is already supposed to reject the second SSCH (CPU 2)
>>> with cc 2 because it sees that FC clear function is set. Or?
>>
>> Maybe for virtio, but for vfio this all gets passed through to the
>> kernel who makes that distinction. And as I've mentioned above, that's
>> not happening.
> 
> Let's have a look at the following qemu functions. AFAIK it is
> common to vfio and virtio, or? Will prefix my inline 

My mistake, I didn't look far enough up the callchain in my quick look
at the code.

...snip...

> 
> So unless somebody (e.g. the kernel vfio-ccw) nukes the FC bits qemu
> should prevent the second SSCH from your example getting to the kernel,
> or?

It's not so much something "nukes the FC bits" ... but rather that that
the data in the irb_area of the io_region is going to reflect what the
subchannel told us for the interrupt.

Hrm... If something is polling on TSCH instead of waiting for a tap on
the shoulder, that's gonna act weird too. Maybe the bits need to be in
io_region.irb_area proper, rather than this weird private->scsw space.

> 
> This is why I hold the notion of a "composite device" for
> important.
> 
> Regards,
> Halil
> 
