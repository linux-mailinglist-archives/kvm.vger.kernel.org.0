Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297D72CBE03
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 14:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgLBNNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 08:13:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgLBNNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 08:13:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2D9OLL057109;
        Wed, 2 Dec 2020 13:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NiaItZXfGqsZFxUteNDdVZXupMku1Gw4cxBdf83Xqzk=;
 b=uiE58jMEAU8cOQYu2Mna+GwSNMBGGCbIdeGa3ruGsGli13DErKc1QEInADWH/AHcqvK7
 53F98ueIFPriiawupjXCwZ+McGC7F3FdgwyHZn9QyP6kztnU8Ag6D8bjMaL1kPSYl8N4
 egze33u0s0XYKSnjWypT7aOudoEsYPuPm3Oy7Sp1qd9CupVWFNsgf/E1Z2qaQ+Q2r31e
 fIhbdxMcxcB1asbZgWooVgncM0HwZzAcTwP22I8OU+DvRfQ4KlUqCwyesVbTH8QXPz9F
 kbIn1Myq5SMxQGbCMRESvguf9QJDwnCoP8iU2W3pUyOncUd0Ukko6bKkabdm8P2u+btw Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqr55a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 13:12:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2DASuG008587;
        Wed, 2 Dec 2020 13:12:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404p9vuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 13:12:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B2DCCXI003229;
        Wed, 2 Dec 2020 13:12:12 GMT
Received: from [10.175.181.158] (/10.175.181.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 05:12:11 -0800
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
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <53baeaa7-0fed-d22c-7767-09ae885d13a0@oracle.com>
Date:   Wed, 2 Dec 2020 13:12:07 +0000
MIME-Version: 1.0
In-Reply-To: <71753a370cd6f9dd147427634284073b78679fa6.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 11:17 AM, David Woodhouse wrote:
> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>> @@ -176,6 +177,9 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>>         int r;
>>  
>>         switch (e->type) {
>> +       case KVM_IRQ_ROUTING_XEN_EVTCHN:
>> +               return kvm_xen_set_evtchn(e, kvm, irq_source_id, level,
>> +                                      line_status);
>>         case KVM_IRQ_ROUTING_HV_SINT:
>>                 return kvm_hv_set_sint(e, kvm, irq_source_id, level,
>>                                        line_status);
>> @@ -325,6 +329,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>                 e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
>>                 e->hv_sint.sint = ue->u.hv_sint.sint;
>>                 break;
>> +       case KVM_IRQ_ROUTING_XEN_EVTCHN:
>> +               e->set = kvm_xen_set_evtchn;
>> +               e->evtchn.vcpu = ue->u.evtchn.vcpu;
>> +               e->evtchn.vector = ue->u.evtchn.vector;
>> +               e->evtchn.via = ue->u.evtchn.via;
>> +
>> +               return kvm_xen_setup_evtchn(kvm, e);
>>         default:
>>                 return -EINVAL;
>>         }
> 
> 
> Hmm. I'm not sure I've have done it that way.
> 
> These IRQ routing entries aren't for individual event channel ports;
> they don't map to kvm_xen_evtchn_send().
> 
> They actually represent the upcall to the given vCPU when any event
> channel is signalled, and it's really per-vCPU configuration.
> 
Right.

> When the kernel raises (IPI, VIRQ) events on a given CPU, it doesn't
> actually use these routing entries; it just uses the values in
> vcpu_xen->cb.{via,vector} which were cached from the last of these IRQ
> routing entries that happens to have been processed?
> 
Correct.

> The VMM is *expected* to set up precisely one of these for each vCPU,
> right?
> 
From guest PoV, the hypercall:

	HYPERVISOR_hvm_op(HVMOP_set_param, HVM_PARAM_CALLBACK_IRQ, ...)

(...) is global.

But this one (on more recent versions of Xen, particularly recent Windows guests):

	HVMOP_set_evtchn_upcall_vector

Is per-vCPU, and it's a LAPIC vector.

But indeed the VMM ends up changing the @via @vector on a individual CPU.

> Would it not be better to do that via KVM_XEN_HVM_SET_ATTR?

It's definitely an interesting (better?) alternative, considering we use as a vCPU attribute.

I suppose you're suggesting like,

	KVM_XEN_ATTR_TYPE_CALLBACK

And passing the vector, and callback type.

> The usage model for userspace is presumably that the VMM should set the
> appropriate bit in evtchn_pending, check evtchn_mask and then call into
> the kernel to do the set_irq() to inject the callback vector to the
> guest?
> 
Correct, that's how it works for userspace handled event channels.

> I might be more inclined to go for a model where the kernel handles the
> evtchn_pending/evtchn_mask for us. What would go into the irq routing
> table is { vcpu, port# } which get passed to kvm_xen_evtchn_send().
> 

But passing port to the routing and handling the sending of events wouldn't it lead to
unnecessary handling of event channels which aren't handled by the kernel, compared to
just injecting caring about the upcall?

I thought from previous feedback that it was something you wanted to avoid.

> Does that seem reasonable?
> 
Otherwise, it seems reasonable to have it.

I'll let Ankur chip in too, as this was something he was more closely modelling after.

> Either way, I do think we need a way for events raised in the kernel to
> be signalled to userspace, if they are targeted at a vCPU which has
> CALLBACK_VIA_INTX that the kernel can't do directly. So we probably
> *do* need that eventfd I was objecting to earlier, except that it's not
> a per-evtchn thing; it's per-vCPU.
> 

Ah!

I wanted to mention the GSI callback method too, but wasn't enterily sure if eventfd was
enough.

	Joao
