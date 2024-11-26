Return-Path: <kvm+bounces-32530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3379D9A7A
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 16:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8951164122
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 15:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BCA61D63EA;
	Tue, 26 Nov 2024 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="j16/TB3W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D40C1917E6;
	Tue, 26 Nov 2024 15:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732635324; cv=none; b=IxQME6pukUEW7OnV8I7a2QXvW7lq9lVt/uWiNdqhpd/dJxG8TPovAq1U1R67wACnDghjfzf9iA8dd8Ldm25vrnUQeU6hPnrOcStyPNiRvunmXI7UC1sqNkBaJipoUNbzNPR9332jADnQU56mUxejK4hQWawhN16FP2s5Vml1UKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732635324; c=relaxed/simple;
	bh=oI//W4q1UMMY9xK64Hq9RXynxX8RgQYpcbtg2vbzkF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JsCgm+uPtXb4SlAUARGMDjwa4Wd4hZ7/1GQEEf+5wefkMSz8ANVGgTS5zUaoBRozm2iLxy47SwGuH0gEEe4203PazwUqTTPvkg224kUrU0bxgAWdSypgDuP8++ZyZej9H/JG7UkLUq6wNYBzVOiIRaPTy2jCoMHhs6gCM6tPA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=j16/TB3W; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732635323; x=1764171323;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=YSd8nei3PrOGgIB4bIkXJ6q/2Rw2Qbesj7W0KxlRtBg=;
  b=j16/TB3W4SALtBvCicjzkfcaYXupYidI2wVoO3Uro6PubHaoPFvwHklY
   maamJXHVCANP3eIgQWgsUdOovnMYIFHWwHi+kLeGOjyDILoRwVLD+6p1H
   /lWaqla2tTc6CL9+dLno5ZOijZnOQWlbDYTfSjg59zRpWYEudGExOgPhg
   A=;
X-IronPort-AV: E=Sophos;i="6.12,186,1728950400"; 
   d="scan'208";a="44662394"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 15:35:19 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:5477]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.116:2525] with esmtp (Farcaster)
 id a4f8f8de-06c1-46ac-9916-65f718e2f8b5; Tue, 26 Nov 2024 15:35:18 +0000 (UTC)
X-Farcaster-Flow-ID: a4f8f8de-06c1-46ac-9916-65f718e2f8b5
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 26 Nov 2024 15:35:17 +0000
Received: from [192.168.5.6] (10.106.82.29) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Tue, 26 Nov 2024
 15:35:16 +0000
Message-ID: <e12ef1ad-7576-4874-8cc2-d48b6619fa95@amazon.com>
Date: Tue, 26 Nov 2024 15:35:15 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <david@redhat.com>,
	<peterx@redhat.com>, <oleg@redhat.com>, <vkuznets@redhat.com>,
	<gshan@redhat.com>, <graf@amazon.de>, <jgowans@amazon.com>,
	<roypat@amazon.co.uk>, <derekmn@amazon.com>, <nsaenz@amazon.es>,
	<xmarcalx@amazon.com>
References: <20241118130403.23184-1-kalyazin@amazon.com>
 <ZzyRcQmxA3SiEHXT@google.com>
 <b6d32f47-9594-41b1-8024-a92cad07004e@amazon.com>
 <Zz-gmpMvNm_292BC@google.com>
 <b7d21cce-720f-4db3-bbb4-0be17e33cd09@amazon.com>
 <Z0URHBoqSgSr_X5-@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <Z0URHBoqSgSr_X5-@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D004EUC004.ant.amazon.com (10.252.51.191) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 26/11/2024 00:06, Sean Christopherson wrote:
> On Mon, Nov 25, 2024, Nikita Kalyazin wrote:
>> On 21/11/2024 21:05, Sean Christopherson wrote:
>>> On Thu, Nov 21, 2024, Nikita Kalyazin wrote:
>>>> On 19/11/2024 13:24, Sean Christopherson wrote:
>>>>> None of this justifies breaking host-side, non-paravirt async page faults.  If a
>>>>> vCPU hits a missing page, KVM can schedule out the vCPU and let something else
>>>>> run on the pCPU, or enter idle and let the SMT sibling get more cycles, or maybe
>>>>> even enter a low enough sleep state to let other cores turbo a wee bit.
>>>>>
>>>>> I have no objection to disabling host async page faults, e.g. it's probably a net
>>>>> negative for 1:1 vCPU:pCPU pinned setups, but such disabling needs an opt-in from
>>>>> userspace.
>>>>
>>>> That's a good point, I didn't think about it.  The async work would still
>>>> need to execute somewhere in that case (or sleep in GUP until the page is
>>>> available).
>>>
>>> The "async work" is often an I/O operation, e.g. to pull in the page from disk,
>>> or over the network from the source.  The *CPU* doesn't need to actively do
>>> anything for those operations.  The I/O is initiated, so the CPU can do something
>>> else, or go idle if there's no other work to be done.
>>>
>>>> If processing the fault synchronously, the vCPU thread can also sleep in the
>>>> same way freeing the pCPU for something else,
>>>
>>> If and only if the vCPU can handle a PV async #PF.  E.g. if the guest kernel flat
>>> out doesn't support PV async #PF, or the fault happened while the guest was in an
>>> incompatible mode, etc.
>>>
>>> If KVM doesn't do async #PFs of any kind, the vCPU will spin on the fault until
>>> the I/O completes and the page is ready.
>>
>> I ran a little experiment to see that by backing guest memory by a file on
>> FUSE and delaying response to one of the read operations to emulate a delay
>> in fault processing.
> 
> ...
> 
>> In both cases the fault handling code is blocked and the pCPU is free for
>> other tasks.  I can't see the vCPU spinning on the IO to get completed if
>> the async task isn't created.  I tried that with and without async PF
>> enabled by the guest (MSR_KVM_ASYNC_PF_EN).
>>
>> What am I missing?
> 
> Ah, I was wrong about the vCPU spinning.
> 
> The goal is specifically to schedule() from KVM context, i.e. from kvm_vcpu_block(),
> so that if a virtual interrupt arrives for the guest, KVM can wake the vCPU and
> deliver the IRQ, e.g. to reduce latency for interrupt delivery, and possible even
> to let the guest schedule in a different task if the IRQ is the guest's tick.
> 
> Letting mm/ or fs/ do schedule() means the only wake event even for the vCPU task
> is the completion of the I/O (or whatever the fault is waiting on).

Ok, great, then that's how I understood it last time.  The only thing 
that is not entirely clear to me is like Vitaly says, 
KVM_ASYNC_PF_SEND_ALWAYS is no longer set, because we don't want to 
inject IRQs into the guest when it's in kernel mode, but the "host async 
PF" case would still allow IRQs (eg ticks like you said).  Why is it 
safe to deliver them?

>>>>> I have no objection to disabling host async page faults,
>>>>> e.g. it's probably a net>>>>> negative for 1:1 vCPU:pCPU pinned setups, but such disabling
>>>>> needs an opt-in from>>>>> userspace.
Back to this, I couldn't see a significant effect of this optimisation 
with the original async PF so happy to give it up, but it does make a 
difference when applied to async PF user [2] in my setup.  Would a new 
cap be a good way for users to express their opt-in for it?

[1]: 
https://lore.kernel.org/kvm/20241118130403.23184-1-kalyazin@amazon.com/T/#ma719a9cb3e036e24ea8512abf9a625ddeaccfc96
[2]: 
https://lore.kernel.org/kvm/20241118123948.4796-1-kalyazin@amazon.com/T/

