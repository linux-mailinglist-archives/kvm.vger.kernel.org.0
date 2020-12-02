Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB6E2CC54A
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbgLBSfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:35:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730978AbgLBSfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:35:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2ITEK3137230;
        Wed, 2 Dec 2020 18:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wM3gMDIYpEosfOh8iiKxu7/6vtVBlGm9RtuV3kcv7+w=;
 b=WKLQS3H/yTqV+1yXDIO83qfvjAnO3Bzllo1FnRy7iG2zt9FA0hMiGbzRPjfA5oerXhzG
 7dR43J9VQNI8ukJC9Xq99OQzBf+QybOpl+Sfpi88FziKyMcdoS05Zl8Fddm+n+Z+JgQz
 VMQ+GNuHOnvc1JsnePDGEEi6g20x950Sx0P6QQo1OhpvDQD4S3rPQZ5VG0rGKAUc0fe6
 yFYiLI8tlSiCxFU10WMOzxiEIf1GYFKOVUGuIBK/UztkQ3qxuOW3kMwzwIsI03Yk40D9
 3UsnJdA6edn/B5S4pT7fZfNQOjc9k2ANXQIXVpWydbz6CjTaWAvtdQZhaBEtm+k6FJgK zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2b24ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 18:34:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2IUXOM128721;
        Wed, 2 Dec 2020 18:34:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540auq6me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 18:34:08 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2IY7iB010836;
        Wed, 2 Dec 2020 18:34:07 GMT
Received: from [10.175.181.158] (/10.175.181.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 10:34:07 -0800
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
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <c43024b3-6508-3b77-870c-da81e74284a4@oracle.com>
Date:   Wed, 2 Dec 2020 18:34:02 +0000
MIME-Version: 1.0
In-Reply-To: <4ad0d157c5c7317a660cd8d65b535d3232f9249d.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 4:47 PM, David Woodhouse wrote:
> On Wed, 2020-12-02 at 13:12 +0000, Joao Martins wrote:
>> On 12/2/20 11:17 AM, David Woodhouse wrote:
>>> I might be more inclined to go for a model where the kernel handles the
>>> evtchn_pending/evtchn_mask for us. What would go into the irq routing
>>> table is { vcpu, port# } which get passed to kvm_xen_evtchn_send().
>>
>> But passing port to the routing and handling the sending of events wouldn't it lead to
>> unnecessary handling of event channels which aren't handled by the kernel, compared to
>> just injecting caring about the upcall?
> 
> Well, I'm generally in favour of *not* doing things in the kernel that
> don't need to be there.
> 
> But if the kernel is going to short-circuit the IPIs and VIRQs, then
> it's already going to have to handle the evtchn_pending/evtchn_mask
> bitmaps, and actually injecting interrupts.
> 
Right. I was trying to point that out in the discussion we had
in next patch. But true be told, more about touting the idea of kernel
knowing if a given event channel is registered for userspace handling,
rather than fully handling the event channel.

I suppose we are able to provide both options to the VMM anyway
i.e. 1) letting them handle it enterily in userspace by intercepting
EVTCHNOP_send, or through the irq route if we want kernel to offload it.

> Given that it has to have that functionality anyway, it seems saner to
> let the kernel have full control over it and to just expose
> 'evtchn_send' to userspace.
> 
> The alternative is to have userspace trying to play along with the
> atomic handling of those bitmasks too 

That part is not particularly hard -- having it done already.

>, and injecting events through
> KVM_INTERRUPT/KVM_SIGNAL_MSI in parallel to the kernel doing so. That
> seems like *more* complexity, not less.
>
/me nods

>> I wanted to mention the GSI callback method too, but wasn't enterily sure if eventfd was
>> enough.
> 
> That actually works quite nicely even for userspace irqchip.
> 
> Forgetting Xen for the moment... my model for userspace I/OAPIC with
> interrupt remapping is that during normal runtime, the irqfd is
> assigned and things all work and we can even have IRQ posting for
> eventfds which came from VFIO. 
> 
> When the IOMMU invalidates an IRQ translation, all it does is
> *deassign* the irqfd from the KVM IRQ. So the next time that eventfd
> fires, it's caught in the userspace event loop instead. Userspace can
> then retranslate through the IOMMU and reassign the irqfd for next
> time.
> 
> So, back to Xen. As things stand with just the hypercall+shinfo patches
> I've already rebased, we have enough to do fully functional Xen
> hosting. 

Yes -- the rest become optimizations in performance sensitive paths.

TBH (and this is slightly offtopic) the somewhat hairy part is xenbus/xenstore.
And the alternative to playing nice with xenstored, is the VMM learning
to parse the xenbus messages and fake the xenstored content/transactions stuff
individually per per-VM .

> The event channels are slow but it *can* be done entirely in

While consulting my old notes, about twice as slow if done in userspace.

> userspace — handling *all* the hypercalls, and delivering interrupts to
> the guest in whatever mode is required.
> 
> Event channels are a very important optimisation though. 

/me nods

> For the VMM
> API I think we should follow the Xen model, mixing the domain-wide and
> per-vCPU configuration. It's the best way to faithfully model the
> behaviour a true Xen guest would experience.
> 
> So KVM_XEN_ATTR_TYPE_CALLBACK_VIA can be used to set one of
>  • HVMIRQ_callback_vector, taking a vector#
>  • HVMIRQ_callback_gsi for the in-kernel irqchip, taking a GSI#
> 
> And *maybe* in a later patch it could also handle
>  • HVMIRQ_callback_gsi for split-irqchip, taking an eventfd
>  • HVMIRQ_callback_pci_intx, taking an eventfd (or a pair, for EOI?)
> 
Most of the Xen versions we were caring had callback_vector and
vcpu callback vector (despite Linux not using the latter). But if you're
dating back to 3.2 and 4.1 well (or certain Windows drivers), I suppose
gsi and pci-intx are must-haves.

> I don't know if the latter two really make sense. After all the
> argument for handling IPI/VIRQ in kernel kind of falls over if we have
> to bounce out to userspace anyway. 

Might as well let userspace EVTCHNOP_send handle it, I wonder.

> So it *only* makes sense if those
> eventfds actually end up wired *through* userspace to a KVM IRQFD as I
> described for the IOMMU stuff.
> 
We didn't implement the phy event channels, but for most old kernels we
tested (back to 2.6.XX) at the time, seemed to play along.

> In addition to that per-domain setup, we'd also have a per-vCPU
> KVM_XEN_ATTR_TYPE_VCPU_CALLBACK_VECTOR which takes {vCPU, vector}.
> 
I feel we could just accommodate it as subtype in KVM_XEN_ATTR_TYPE_CALLBACK_VIA.
Don't see the adavantage in having another xen attr type.

But kinda have mixed feelings in having kernel handling all event channels ABI,
as opposed to only the ones userspace asked to offload. It looks a tad unncessary besides
the added gain to VMMs that don't need to care about how the internals of event channels.
But performance-wise it wouldn't bring anything better. But maybe, the former is reason
enough to consider it.

	Joao
