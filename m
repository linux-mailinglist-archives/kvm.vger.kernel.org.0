Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2680D2EAA7E
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbhAEMPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 07:15:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbhAEMPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 07:15:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105C9O0F193336;
        Tue, 5 Jan 2021 12:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SE6ayLWKmdVONRIN1PoTB2VVNujq5FlBnJ3EQLdtZgE=;
 b=pAtQeKkTXsYC80cJeWkzARt3C3FV0Yk0AIqSwi1+eNvJcd21DYeqoyorIh9n/VfTgK7Z
 DVhwD5jjDXy2kXIpGTGYjlfxQwPGZwiNYiyY76gDbIAoRXWgTmVbnr+VP1VKgu9I4NgK
 L4ZZAqZ/rJzoA5rLJuj4f+yTfXA97HZ4CCAtau1vLyZjRQfqI4Tmi3J7tuKlqf2hA9Ne
 jexi8UislsUvJXya8Z5NVQ0kIWyDvVtmFnuNmJgW1lBclr9G/y4AOV1BjMl7K2kK+miW
 7pgPbn4BiCwKt+KKgU8K4kv5Gn+evvJExzTYFhUP5VUnfH1Kt+oP1mnm8YHkihvxsULg OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35tg8r0h6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 12:14:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105CBeY5035520;
        Tue, 5 Jan 2021 12:11:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35vct5s1vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 12:11:59 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105CBrZC008977;
        Tue, 5 Jan 2021 12:11:53 GMT
Received: from [192.168.1.67] (/94.61.1.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 04:11:53 -0800
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     David Woodhouse <dwmw2@infradead.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-11-joao.m.martins@oracle.com>
 <71753a370cd6f9dd147427634284073b78679fa6.camel@infradead.org>
 <53baeaa7-0fed-d22c-7767-09ae885d13a0@oracle.com>
 <4ad0d157c5c7317a660cd8d65b535d3232f9249d.camel@infradead.org>
 <c43024b3-6508-3b77-870c-da81e74284a4@oracle.com>
 <c4a1a6824c534d1f1420f6c64d72b02eb5caf4c6.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <abd12f38-a2fa-1e7c-72e9-4d2296c7b4a2@oracle.com>
Date:   Tue, 5 Jan 2021 12:11:46 +0000
MIME-Version: 1.0
In-Reply-To: <c4a1a6824c534d1f1420f6c64d72b02eb5caf4c6.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/1/21 2:33 PM, David Woodhouse wrote:
> On Wed, 2020-12-02 at 18:34 +0000, Joao Martins wrote:
>>> But if the kernel is going to short-circuit the IPIs and VIRQs, then
>>> it's already going to have to handle the evtchn_pending/evtchn_mask
>>> bitmaps, and actually injecting interrupts.
>>>
>>
>> Right. I was trying to point that out in the discussion we had
>> in next patch. But true be told, more about touting the idea of kernel
>> knowing if a given event channel is registered for userspace handling,
>> rather than fully handling the event channel.
>>
>> I suppose we are able to provide both options to the VMM anyway
>> i.e. 1) letting them handle it enterily in userspace by intercepting
>> EVTCHNOP_send, or through the irq route if we want kernel to offload it.
>>
>>> Given that it has to have that functionality anyway, it seems saner to
>>> let the kernel have full control over it and to just expose
>>> 'evtchn_send' to userspace.
>>>
>>> The alternative is to have userspace trying to play along with the
>>> atomic handling of those bitmasks too 
>>
>> That part is not particularly hard -- having it done already.
> 
> Right, for 2-level it works out fairly well. I like your model of
> installing { vcpu_id, port } into the KVM IRQ routing table and that's
> enough for the kernel to raise the event channels that it *needs* to
> know about, while userspace can do the others for itself. It's just
> atomic test-and-set bitop stuff with no real need for coordination.
> 
> For FIFO event channels it gets more fun, because the updates aren't
> truly atomic — they require a spinlock around the three operations that
> the host has to perform when linking an event into a queue: 
> 
>  • Set the new port's LINKED bit
>  • Set the previous head's LINK to point to the new port
>  • Store the new port# as the head.
> 
> One option might be to declare that for FIFO, all updates for a given
> queue *must* be handled either by the kernel, or by userspace, and
> there's sharing of control.
> 
> Or maybe there's a way to keep the kernel side simple by avoiding the
> tail handling completely. Surely we only really care about kernel
> handling of the *fast* path, where a single event channel is triggered
> and handled immediately? In the high-latency case where we're gathering
> multiple events in a queue before the guest ever gets to process them, 
> we might as well let that be handled by userspace, right?
> 
> So in that case, perhaps the kernel part could forget all the horrid
> nonsense with tracking the tail of the queue. It would handle the event
> in-kernel *only* in the case where the event is the *first* in the
> queue, and the head was previously zero?
> 
> But even that isn't a simple atomic operation though; we still have to
> mark the event LINKED, then update the head pointer to reference it.
> And what if we set the 'LINKED' bit but then find that userspace has
> already linked another port so ->head is no longer zero?
> 
> Can we just clear the LINKED bit and then punt the whole event for
> userspace to (re)handle? Or raise a special event to userspace so it
> knows it needs to go ahead and link the port even though its LINKED bit
> has already been set?
> 
> None of the available options really fill me with joy; I'm somewhat
> inclined just to declare that the kernel won't support acceleration of
> FIFO event channels at all.
> 
> None of which matters a *huge* amount right now if I was only going to
> leave that as a future optimisation anyway.
> 
ACK.

> What it does actually mean in the short term is that as I update your
> KVM_IRQ_ROUTING_XEN_EVTCHN support, I probably *won't* bother to add a
> 'priority' field to struct kvm_irq_routing_xen_evtchn to make it
> extensible to FIFO event channels. We can always add that later.
> 
> Does that seem reasonable?
> 
Yes, makes sense IMHO. Guests need to anyway fallback to 2L if the
evtchnop_init_control hypercall fails, and the way we are handling events,
doesn't warrant FIFO event channel support as mandatory.

Despite the many fifo event features, IIRC the main driving motivation
was to go beyond the 1K/4K port limit for 32b/64b guests to be 128K max
ports per guest instead. But that was mostly a limit for Domain-0 as it hosts
all the backend handling in the traditional (i.e. without driver
domains) deployment. Therefore limiting how many vdevs one could host in
the system. And on cases for dense VM consolidation where you host 1K
guests with e.g. 3 block devices and 1 network interface one would quickly
ran out of interdomain event channel ports in Dom0. But that is not the
case here.

We are anyways ABI-limited to HVM_MAX_VCPUS (128) and if we assume
4 event channels for the legacy guest per VCPU (4 ipi evts, 1 timer,
1 debug) then it means we have still 3328 ports for interdomain event
channels for a 128 vCPU HVM guest ... when using the 2L event channels ABI.

	Joao
