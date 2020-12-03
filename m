Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF0F2CCB6E
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 02:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgLCBJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 20:09:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60330 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgLCBJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 20:09:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B315Db9103601;
        Thu, 3 Dec 2020 01:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jCgXNIKCNXgWdDkKjB7SKWN45ccDc4ppC62togC7RZc=;
 b=rhn9ZXoVc4ObHBWODSkv1Kl/A1Faz4WJIH3kqYUaXa3dNveVFxEti+VBN9hH6BAwe0tk
 wuX3/uEqCZHCrwanTnt1rfMpUzuACixanY634nDyvdRDp2J2sI38AVIn4M9fBMuUOQ0Z
 y4gcU1+ASzQjqSaV8cMlKHXfEDuUwKGF5jLDlgDxs8wGt0GKqPWiYxRp53P3vSJjxtj3
 px8oh91Rj3BK1neA4oBPwA+J+G77H4xOYOK3O4CASnkysLIKhrbMx0njecKVLZ1IEkj2
 pKFbPkUEUsEEu2r7YLrVoUuzOdb3UoXqLY9qE8nNEBIzXQCy9MXUCYkGJtdsDfC//ci5 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b3gx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 01:08:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B314SuD054405;
        Thu, 3 Dec 2020 01:08:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404q2mur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 01:08:20 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3189JX014579;
        Thu, 3 Dec 2020 01:08:09 GMT
Received: from [10.159.240.123] (/10.159.240.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 17:08:09 -0800
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     David Woodhouse <dwmw2@infradead.org>,
        Joao Martins <joao.m.martins@oracle.com>
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
 <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <8875ff08-9b92-3eb7-3b17-f5dc036148e2@oracle.com>
Date:   Wed, 2 Dec 2020 17:08:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030002
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-02 11:02 a.m., David Woodhouse wrote:
> On Wed, 2020-12-02 at 18:34 +0000, Joao Martins wrote:
>> On 12/2/20 4:47 PM, David Woodhouse wrote:
>>> On Wed, 2020-12-02 at 13:12 +0000, Joao Martins wrote:
>>>> On 12/2/20 11:17 AM, David Woodhouse wrote:
>>>>> I might be more inclined to go for a model where the kernel handles the
>>>>> evtchn_pending/evtchn_mask for us. What would go into the irq routing
>>>>> table is { vcpu, port# } which get passed to kvm_xen_evtchn_send().
>>>>
>>>> But passing port to the routing and handling the sending of events wouldn't it lead to
>>>> unnecessary handling of event channels which aren't handled by the kernel, compared to
>>>> just injecting caring about the upcall?
>>>
>>> Well, I'm generally in favour of *not* doing things in the kernel that
>>> don't need to be there.
>>>
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
> 
> Right. The kernel takes what it knows about and anything else goes up
> to userspace.
> 
> I do like the way you've handled the vcpu binding in userspace, and the
> kernel just knows that a given port goes to a given target CPU.
> 
>>
>>> For the VMM
>>> API I think we should follow the Xen model, mixing the domain-wide and
>>> per-vCPU configuration. It's the best way to faithfully model the
>>> behaviour a true Xen guest would experience.
>>>
>>> So KVM_XEN_ATTR_TYPE_CALLBACK_VIA can be used to set one of
>>>   • HVMIRQ_callback_vector, taking a vector#
>>>   • HVMIRQ_callback_gsi for the in-kernel irqchip, taking a GSI#
>>>
>>> And *maybe* in a later patch it could also handle
>>>   • HVMIRQ_callback_gsi for split-irqchip, taking an eventfd
>>>   • HVMIRQ_callback_pci_intx, taking an eventfd (or a pair, for EOI?)
>>>
>>
>> Most of the Xen versions we were caring had callback_vector and
>> vcpu callback vector (despite Linux not using the latter). But if you're
>> dating back to 3.2 and 4.1 well (or certain Windows drivers), I suppose
>> gsi and pci-intx are must-haves.
> 
> Note sure about GSI but PCI-INTX is definitely something I've seen in
> active use by customers recently. I think SLES10 will use that.
> 
>> I feel we could just accommodate it as subtype in KVM_XEN_ATTR_TYPE_CALLBACK_VIA.
>> Don't see the adavantage in having another xen attr type.
> 
> Yeah, fair enough.
> 
>> But kinda have mixed feelings in having kernel handling all event channels ABI,
>> as opposed to only the ones userspace asked to offload. It looks a tad unncessary besides
>> the added gain to VMMs that don't need to care about how the internals of event channels.
>> But performance-wise it wouldn't bring anything better. But maybe, the former is reason
>> enough to consider it.
> 
> Yeah, we'll see. Especially when it comes to implementing FIFO event
> channels, I'd rather just do it in one place — and if the kernel does
> it anyway then it's hardly difficult to hook into that.

Sorry I'm late to this conversation. Not a whole lot to add to what Joao
said. I would only differ with him on how much to offload.

Given that we need the fast path in the kernel anyway, I think it's simpler
to do all the event-channel bitmap only in the kernel.
This would also simplify using the kernel Xen drivers if someone eventually
decides to use them.


Ankur

> 
> But I've been about as coherent as I can be in email, and I think we're
> generally aligned on the direction. I'll do some more experiments and
> see what I can get working, and what it looks like.
> 
> I'm focusing on making the shinfo stuff all use kvm_map_gfn() first.
> 
