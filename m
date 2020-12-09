Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644132D3B8C
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 07:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgLIGg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 01:36:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57812 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgLIGg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 01:36:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B96Y9b9027361;
        Wed, 9 Dec 2020 06:35:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QlN5WVvN+EUMDdZSXbrBXnrkaAXBmi3yGLPASyio3EM=;
 b=CJ3TXV2gzrxS3BKqETMESZZKuQx5G9qw2crLYMi3oCmfTiclyIAdOSEhjx3bkaX/ABlJ
 JJOh5CLMLdxlhk2ZxFIGtUx48JdBXFY5HwqWuFaZqAizgP8JzDSS5Kb98N1Kvzm6ZP36
 Shjf01s20j0AorF0e/4gP9l9W7liHQ0LkewMAGDwfJxm2X1Izbp/mSdZPRBwkhUfWevl
 YG2XM9PVemgIVg9f0Q17z34uRAaQ+62VFLq9lF85m2MpMyvJyVR81OsMPUu16ke+sutX
 kjOFYrcDSkZXuXjKtTP+B27LYywmp5OUINzSQRUsRvjSTpTbVpmkMXAhL3XBDOtqSn4p XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqxecc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 06:35:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B96UW08089705;
        Wed, 9 Dec 2020 06:35:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 358m3yt1fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 06:35:52 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B96Zl4h032015;
        Wed, 9 Dec 2020 06:35:47 GMT
Received: from [10.159.229.96] (/10.159.229.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 22:35:47 -0800
From:   Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     David Woodhouse <dwmw2@infradead.org>,
        Joao Martins <joao.m.martins@oracle.com>, karahmed@amazon.de
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
 <6a6b5806be1fe4c0fe96c0b664710d1ce614f29d.camel@infradead.org>
Message-ID: <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com>
Date:   Tue, 8 Dec 2020 22:35:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <6a6b5806be1fe4c0fe96c0b664710d1ce614f29d.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-08 8:08 a.m., David Woodhouse wrote:
> On Wed, 2020-12-02 at 19:02 +0000, David Woodhouse wrote:
>>
>>> I feel we could just accommodate it as subtype in KVM_XEN_ATTR_TYPE_CALLBACK_VIA.
>>> Don't see the adavantage in having another xen attr type.
>>
>> Yeah, fair enough.
>>
>>> But kinda have mixed feelings in having kernel handling all event channels ABI,
>>> as opposed to only the ones userspace asked to offload. It looks a tad unncessary besides
>>> the added gain to VMMs that don't need to care about how the internals of event channels.
>>> But performance-wise it wouldn't bring anything better. But maybe, the former is reason
>>> enough to consider it.
>>
>> Yeah, we'll see. Especially when it comes to implementing FIFO event
>> channels, I'd rather just do it in one place — and if the kernel does
>> it anyway then it's hardly difficult to hook into that.
>>
>> But I've been about as coherent as I can be in email, and I think we're
>> generally aligned on the direction. I'll do some more experiments and
>> see what I can get working, and what it looks like.
> 
> 
> So... I did some more typing, and revived our completely userspace
> based implementation of event channels. I wanted to declare that such
> was *possible*, and that using the kernel for IPI and VIRQ was just a
> very desirable optimisation.
> 
> It looks like Linux doesn't use the per-vCPU upcall vector that you
> called 'KVM_XEN_CALLBACK_VIA_EVTCHN'. So I'm delivering interrupts via
> KVM_INTERRUPT as if they were ExtINT....
> 
> ... except I'm not. Because the kernel really does expect that to be an
> ExtINT from a legacy PIC, and kvm_apic_accept_pic_intr() only returns
> true if LVT0 is set up for EXTINT and unmasked.
> 
> I messed around with this hack and increasingly desperate variations on
> the theme (since this one doesn't cause the IRQ window to be opened to
> userspace in the first place), but couldn't get anything working:

Increasingly desperate variations,  about sums up my process as well while
trying to get the upcall vector working.

> 
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2380,6 +2380,9 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
>          if ((lvt0 & APIC_LVT_MASKED) == 0 &&
>              GET_APIC_DELIVERY_MODE(lvt0) == APIC_MODE_EXTINT)
>                  r = 1;
> +       /* Shoot me. */
> +       if (vcpu->arch.pending_external_vector == 243)
> +               r = 1;
>          return r;
>   }
>   
> 
> Eventually I resorted to delivering the interrupt through the lapic
> *anyway* (through KVM_SIGNAL_MSI with an MSI message constructed for
> the appropriate vCPU/vector) and the following hack to auto-EOI:
> 
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2416,7 +2419,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>           */
>   
>          apic_clear_irr(vector, apic);
> -       if (test_bit(vector, vcpu_to_synic(vcpu)->auto_eoi_bitmap)) {
> +       if (vector == 243 || test_bit(vector, vcpu_to_synic(vcpu)->auto_eoi_bitmap)) {
>                  /*
>                   * For auto-EOI interrupts, there might be another pending
>                   * interrupt above PPR, so check whether to raise another
> 
> 
> That works, and now my guest finishes the SMP bringup (and gets as far
> as waiting on the XenStore implementation that I haven't put back yet).
> 
> So I think we need at least a tiny amount of support in-kernel for
> delivering event channel interrupt vectors, even if we wanted to allow
> for a completely userspace implementation.
> 
> Unless I'm missing something?

I did use the auto_eoi hack as well. So, yeah, I don't see any way of
getting around this.

Also, IIRC we had eventually gotten rid of the auto_eoi approach
because that wouldn't work with APICv. At that point we resorted to
direct queuing for vectored callbacks which was a hack that I never
grew fond of...
  
> I will get on with implementing the in-kernel handling with IRQ routing
> entries targeting a given { port, vcpu }. And I'm kind of vacillating
> about whether the mode/vector should be separately configured, or
> whether they might as well be in the IRQ routing table too, even if
> it's kind of redundant because it's specified the same for *every* port
> targeting the same vCPU. I *think* I prefer that redundancy over having
> a separate configuration mechanism to set the vector for each vCPU. But
> we'll see what happens when my fingers do the typing...
> 

Good luck to your fingers!

Ankur
