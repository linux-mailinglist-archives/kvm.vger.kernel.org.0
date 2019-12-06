Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033DC115895
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 22:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLFVZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 16:25:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfLFVZA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 16:25:00 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB6LDv55103236;
        Fri, 6 Dec 2019 16:24:59 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wq9hmvnnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Dec 2019 16:24:59 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xB6LE6dW103993;
        Fri, 6 Dec 2019 16:24:59 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wq9hmvnnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Dec 2019 16:24:59 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xB6LMsud023658;
        Fri, 6 Dec 2019 21:24:58 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2wkg27suw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Dec 2019 21:24:58 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB6LOvIM48169430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Dec 2019 21:24:57 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A5F528059;
        Fri,  6 Dec 2019 21:24:57 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F09B2805C;
        Fri,  6 Dec 2019 21:24:57 +0000 (GMT)
Received: from [9.80.219.143] (unknown [9.80.219.143])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  6 Dec 2019 21:24:57 +0000 (GMT)
From:   Eric Farman <farman@linux.ibm.com>
Subject: Re: [RFC PATCH v1 08/10] vfio-ccw: Wire up the CRW irq and CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
 <20191115025620.19593-9-farman@linux.ibm.com>
 <20191119195236.35189d5b.cohuck@redhat.com>
 <02d98858-ddac-df7e-96a6-7c61335d3cee@linux.ibm.com>
 <20191206112107.63fb37a1.cohuck@redhat.com>
Message-ID: <9c83e960-9f68-2328-6a89-d0fa7b8768d8@linux.ibm.com>
Date:   Fri, 6 Dec 2019 16:24:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191206112107.63fb37a1.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-06_07:2019-12-05,2019-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912060170
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/19 5:21 AM, Cornelia Huck wrote:
> On Thu, 5 Dec 2019 15:43:55 -0500
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 11/19/19 1:52 PM, Cornelia Huck wrote:
>>> On Fri, 15 Nov 2019 03:56:18 +0100
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>   
>>>> From: Farhan Ali <alifm@linux.ibm.com>
>>>>
>>>> Use an IRQ to notify userspace that there is a CRW
>>>> pending in the region, related to path-availability
>>>> changes on the passthrough subchannel.  
>>>
>>> Thinking a bit more about this, it feels a bit odd that a crw for a
>>> chpid ends up on one subchannel. What happens if we have multiple
>>> subchannels passed through by vfio-ccw that use that same chpid?  
>>
>> Yeah...  It doesn't end up on one subchannel, it ends up on every
>> affected subchannel, based on the loops in (for example)
>> chsc_chp_offline().  This means that "let's configure off a CHPID to the
>> LPAR" translates one channel-path CRW into N channel-path CRWs (one each
>> sent to N subchannels).  It would make more sense if we just presented
>> one channel-path CRW to the guest, but I'm having difficulty seeing how
>> we could wire this up.  What we do here is use the channel-path event
>> handler in vfio-ccw also create a channel-path CRW to be presented to
>> the guest, even though it's processing something at the subchannel level.
> 
> Yes, it's a bit odd that we need to do 1 -> N -> 1 conversion here, but
> we can't really avoid it without introducing a new way to report
> information that is relevant for more than one subchannel. The thing we
> need to make sure is that userspace gets the same information,
> regardless of which affected subchannel it looks at.
> 
>>
>> The actual CRW handlers are in the base cio code, and we only get into
>> vfio-ccw when processing the individual subchannels.  Do we need to make
>> a device (or something?) at the guest level for the chpids that exist?
>> Or do something to say "hey we got this from a subchannel, put it on a
>> global queue if it's unique, or throw it away if it's a duplicate we
>> haven't processed yet" ?  Thoughts?
> 
> The problem is that you can easily get several crws that look identical
> (consider e.g. a chpid that is set online and offline in a tight loop).

Yeah, I have a little program that does such a loop.  Things don't work
too well even with a random delay between on/off, though a hack I'm
trying to formalize for v2 improves matters.  If I drop that delay to
zero, um, well I haven't had the nerve to try that.  :)

> The only entity that should make decisions as to what to process here
> is the guest.

Agreed.  So your suggestion in the QEMU series of acting like stcrw is
good; give the guest all the information it can, and let it decide what
thrashing is needed.  I guess if I can just queue everything on the
vfio_ccw_private, and move one (two?) into the crw_region each time it's
read then that should work well enough.  Thanks!

> 
> (...)
> 
>>>> @@ -312,6 +334,11 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
>>>>  	case CHP_ONLINE:
>>>>  		/* Path became available */
>>>>  		sch->lpm |= mask & sch->opm;
>>>> +		private->crw.rsc = CRW_RSC_CPATH;
>>>> +		private->crw.rsid = 0x0 | (link->chpid.cssid << 8) |
>>>> +				    link->chpid.id;
>>>> +		private->crw.erc = CRW_ERC_INIT;
>>>> +		queue_work(vfio_ccw_work_q, &private->crw_work);  
>>>
>>> Isn't that racy? Imagine you get one notification for a chpid and queue
>>> it. Then, you get another notification for another chpid and queue it
>>> as well. Depending on when userspace reads, it gets different chpids.
>>> Moreover, a crw may be lost... or am I missing something obvious?  
>>
>> Nope, you're right on.  If I start thrashing config on/off chpids on the
>> host, I eventually fall down with all sorts of weirdness.
>>
>>>
>>> Maybe you need a real queue for the generated crws?  
>>
>> I guess this is what I'm wrestling with...  We don't have a queue for
>> guest-wide work items, as it's currently broken apart by subchannel.  Is
>> adding one at the vfio-ccw level right?  Feels odd to me, since multiple
>> guests could use devices connected via vfio-ccw, which may or may share
>> common chpids.
> 
> One problem is that the common I/O layer already processes the crws and
> translates them into different per-subchannel events. We don't even
> know what the original crw was: IIUC, we translate both a crw for a
> chpid and a link incident event (reported by a crw with source css and
> event information via chsc) concerning the concrete link to the same
> event. That *probably* doesn't matter too much, but it makes things
> harder. Access to the original crw queue would be nice, but hard to
> implement without stepping on each others' toes.>
>>
>> I have a rough hack that serializes things a bit, while still keeping
>> the CRW duplication at the subchannel level.  Things improve
>> considerably, but it still seems odd to me.  I'll keep working on that
>> unless anyone has any better ideas.
> 
> The main issue is that we're trying to report a somewhat global event
> via individual devices...

+1

> 
> ...what about not reporting crws at all, but something derived from the
> events we get at the subchannel driver level? Have four masks that
> indicate online/offline/vary on/vary off for the respective chpids, and
> have userspace decide how they want to report these to the guest? A
> drawback (?) would be that a series of on/off events would only be
> reported as one on and one off event, though. Feasible, or complete
> lunacy?
> 

Not complete lunacy, but brings concerns of its own as we'd need to
ensure the masks don't say something nonsensical, like (for example)
both vary on and vary off.  Or what happens if both vary on and config
off gets set?  Not a huge amount of work, but just seems to carry more
risk than a queue of the existing CRWs and letting the guest process
them itself, even if things are duplicated more than necessary.  In
reality, these events aren't that common anyway unless things go REALLY
sideways.
