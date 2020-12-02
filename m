Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB32CC78F
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 21:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbgLBUNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 15:13:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52280 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgLBUNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 15:13:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2K90QF142936;
        Wed, 2 Dec 2020 20:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Jc7qsNgolGmF18q39ERx3qKsOIEtsG0DDZ6fka3d//w=;
 b=U5fwIO+rEbyJy+0vgIU0lBQbLBarkgN5MPfiQbcWdg/m+3+sv1IpEX+CwEzotaZGQX//
 7E3kx2xx21za+elLWppgtr3hBKG76HS3M3FmTS3xySVyrFO2ZNr1DTOXjLKKhMqzyFJc
 kEiARiLpXuxvP57glmSph6d44rSbhM2qpwuKp1KYvbHb7rnn7De9D8TgoP45p+Lfh7zU
 /HDVP58bAiIHTnomBjp7JTeO7A9JGIDZrmgssNnOVqd60IZ8fqWagTyczHBbE/fiq0vU
 r1sWJm4+GP4E0JNjo8YpPCTp2EhLHwgcqb0Sdd1QgJ5B+O4/ARXG95QkF8gRkb7Ce3Vo mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b2m1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 20:12:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KASjd088452;
        Wed, 2 Dec 2020 20:12:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404ptnur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 20:12:55 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2KCsds003992;
        Wed, 2 Dec 2020 20:12:54 GMT
Received: from [10.175.218.41] (/10.175.218.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 12:12:54 -0800
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
 <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <59751932-92c3-5397-0706-13c4e1b38aa5@oracle.com>
Date:   Wed, 2 Dec 2020 20:12:50 +0000
MIME-Version: 1.0
In-Reply-To: <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 7:02 PM, David Woodhouse wrote:
> On Wed, 2020-12-02 at 18:34 +0000, Joao Martins wrote:
>> On 12/2/20 4:47 PM, David Woodhouse wrote:
>>> On Wed, 2020-12-02 at 13:12 +0000, Joao Martins wrote:
>>>> On 12/2/20 11:17 AM, David Woodhouse wrote:
>>> For the VMM
>>> API I think we should follow the Xen model, mixing the domain-wide and
>>> per-vCPU configuration. It's the best way to faithfully model the
>>> behaviour a true Xen guest would experience.
>>>
>>> So KVM_XEN_ATTR_TYPE_CALLBACK_VIA can be used to set one of
>>>  • HVMIRQ_callback_vector, taking a vector#
>>>  • HVMIRQ_callback_gsi for the in-kernel irqchip, taking a GSI#
>>>
>>> And *maybe* in a later patch it could also handle
>>>  • HVMIRQ_callback_gsi for split-irqchip, taking an eventfd
>>>  • HVMIRQ_callback_pci_intx, taking an eventfd (or a pair, for EOI?)
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

Some of the Windows drivers we used were relying on GSI.

I don't know about what kernel is SLES10 but Linux is aware
of XENFEAT_hvm_callback_vector since 2.6.35 i.e. about 10years.
Unless some other out-of-tree patch is opting it out I suppose.

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
> 
Fortunately that's xen 4.3 and up *I think* :) (the FIFO events)

And Linux is the one user I am aware IIRC.

> But I've been about as coherent as I can be in email, and I think we're
> generally aligned on the direction. 

Yes, definitely.

> I'll do some more experiments and
> see what I can get working, and what it looks like.
> 
> I'm focusing on making the shinfo stuff all use kvm_map_gfn() first.
> 
I was chatting with Ankur, and we can't fully 100% remember why we dropped using
kvm_vcpu_map/kvm_map_gfn. We were using kvm_vcpu_map() but at the time the new guest
mapping series was in discussion, so we dropped those until it settled in.

One "side effect" on mapping shared_info with kvm_vcpu_map, is that we have to loop all
vcpus unless we move shared_info elsewhere IIRC. But switching vcpu_info, vcpu_time_info
(and steal clock) to kvm_vcpu_map is trivial.. at least based on our old wip branches here.

	Joao
