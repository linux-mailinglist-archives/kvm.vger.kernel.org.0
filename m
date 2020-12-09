Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD32D4337
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 14:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbgLIN2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 08:28:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41406 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731923AbgLIN2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 08:28:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9DJLTc100471;
        Wed, 9 Dec 2020 13:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tjJR8fSxsRpHHh112eeug597rvZIcr/UPaqj+1uZMTE=;
 b=VChZvb1HfZEriXvryyq6/7jPfxwZe13KqHeF/07oZ8old5sjHbEQ3e3G5I50jzLpnHGD
 n1ysSe7miljDHKqG3IZvXke5nJurcaWDCFbu2v4KZsO1crNjz63/XJHxa+u6z4CSGn20
 OkvH9KuscQHWH4Bgtd/zLttdnNJ2+FEidMUyunHWFXBlEgHB/Lz9WJYFtAmh9x44bZJc
 2t7GxUvgwu5lG4L9GKy9qy+WKsvONMcI6oaKt6JuIFjxwXtUOmi+VVci73VHpbBAuRkV
 lw2/H0+Dj6b4gaj0Vfo0sXkMUMNppPKq7clnRPQCEGvI40Yyhiq8rQZDeITgBcq7RAAn Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 357yqc06sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 13:27:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9DKYjF026594;
        Wed, 9 Dec 2020 13:27:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m409awy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 13:27:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9DR0ct032643;
        Wed, 9 Dec 2020 13:27:00 GMT
Received: from [10.175.160.66] (/10.175.160.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 05:27:00 -0800
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     David Woodhouse <dwmw2@infradead.org>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.de
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
 <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com>
 <0eb8c2ef01b77af0d288888f200e812d374beada.camel@infradead.org>
 <f7dec3f1-aadc-bda5-f4dc-7185ffd9c1a6@oracle.com>
 <db4ea3bd6ebec53c40526d67273ccfba38982811.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <35165dbc-73d0-21cd-0baf-db4ffb55fc47@oracle.com>
Date:   Wed, 9 Dec 2020 13:26:55 +0000
MIME-Version: 1.0
In-Reply-To: <db4ea3bd6ebec53c40526d67273ccfba38982811.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/20 11:39 AM, David Woodhouse wrote:
> On Wed, 2020-12-09 at 10:51 +0000, Joao Martins wrote:
>> Isn't this what the first half of this patch was doing initially (minus the
>> irq routing) ? Looks really similar:
>>
>> https://lore.kernel.org/kvm/20190220201609.28290-11-joao.m.martins@oracle.com/
> 
> Absolutely! This thread is in reply to your original posting of
> precisely that patch, and I've had your tree open in gitk to crib from
> for most of the last week.
> 
I forgot about this patch given all the discussion so far and I had to re-look given that
it resembled me from your snippet. But I ended up being a little pedantic -- sorry about that.

> There's a *reason* why my tree looks like yours, and why more than half
> of the patches in it still show you as being the author :)
> 
Btw, in this patch it would be Ankur's.

More importantly, thanks a lot for picking it up and for all the awesome stuff you're
doing with it.

>> Albeit, I gotta after seeing the irq routing removed it ends much simpler, if we just
>> replace the irq routing with a domain-wide upcall vector ;)
> 
> I like "simpler".
> 
> I also killed the ->cb.queued flag you had because I think it's
> redundant with evtchn_upcall_pending anyway.
> 
Yeap, indeed.

>> Albeit it wouldn't cover the Windows Xen open source drivers which use the EVTCHN method
>> (which is a regular LAPIC vector) [to answer your question on what uses it] For the EVTCHN
>> you can just inject a regular vector through lapic deliver, and guest acks it. Sadly Linux
>> doesn't use it,
>> and if it was the case we would probably get faster upcalls with APICv/AVIC.
> 
> It doesn't need to, because those can just be injected with
> KVM_SIGNAL_MSI.
> 
/me nods

> At most, we just need to make sure that kvm_xen_has_interrupt() returns
> false if the per-vCPU LAPIC vector is configured. But I didn't do that
> because I checked Xen and it doesn't do it either.
> 
Oh! I have this strange recollection that it was, when we were looking at the Xen
implementation.

> As far as I can tell, Xen's hvm_vcpu_has_pending_irq() will still
> return the domain-wide vector in preference to the one in the LAPIC, if
> it actually gets invoked. 

Only if the callback installed is HVMIRQ_callback_vector IIUC.

Otherwise the vector would be pending like any other LAPIC vector.

> And if the guest sets ->evtchn_upcall_pending
> to reinject the IRQ (as Linux does on unmask) Xen won't use the per-
> vCPU vector to inject that; it'll use the domain-wide vector.
> Right -- I don't think Linux even installs a per-CPU upcall LAPIC vector other than the
domain's callback irq.

>>> I'm not sure that condition wasn't *already* broken some cases for
>>> KVM_INTERRUPT anyway. In kvm_vcpu_ioctl_interrupt() we set
>>> vcpu->arch.pending_userspace_vector and we *do* request KVM_REQ_EVENT,
>>> sure.
>>>
>>> But what if vcpu_enter_guest() processes that the first time (and
>>> clears KVM_REQ_EVENT), and then exits for some *other* reason with
>>> interrupts still disabled? Next time through vcpu_enter_guest(), even
>>> though kvm_cpu_has_injectable_intr() is still true, we don't enable the
>>> IRQ windowvmexit because KVM_REQ_EVENT got lost so we don't even call
>>> inject_pending_event().
>>>
>>> So instead of just kvm_xen_has_interrupt() in my patch below, I wonder
>>> if we need to use kvm_cpu_has_injectable_intr() to fix the existing
>>> bug? Or am I missing something there and there isn't a bug after all?
>>
>> Given that the notion of an event channel pending is Xen specific handling, I am not sure
>> we can remove the kvm_xen_has_interrupt()/kvm_xen_get_interrupt() logic. Much of the
>> reason that we ended up checking on vmenter that checks event channels pendings..
> 
> Sure, we definitely need the check I added in vcpu_enter_guest() for
> Xen unless I'm going to come up with a way to set KVM_REQ_EVENT at the
> appropriate time.
> 
> But I'm looking at the ExtINT handling and as far as I can tell it's
> buggy. So I didn't want to use it as a model for setting KVM_REQ_EVENT
> for Xen events.
> 
/me nods
