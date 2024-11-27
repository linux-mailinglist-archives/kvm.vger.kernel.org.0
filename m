Return-Path: <kvm+bounces-32564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 218AB9DA5E3
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 11:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D35E6282B04
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 10:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F47198850;
	Wed, 27 Nov 2024 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="m4w5T8gG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1F9195FEC;
	Wed, 27 Nov 2024 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732703729; cv=none; b=LNzLDsGiVNkMwtfCwsGAT8yO25DVnKaXsUgZ6mMb7AoiU5A1zWW5gt4pWTabWe8sijiHOks9O82q/QEEO9gLwgrVenyQXkcOzkym0V74Qlt69amdHS7qy6mGyhevFfpbAoI1MkygWnEBAb1yusZVv1Sfcy1+vFtx4EkX59gRTLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732703729; c=relaxed/simple;
	bh=hwhPC+nngxGhlzp3O6yweDudyD4FEfXUMNg9mM21JjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EIEKRUq2oYlZKEKeK7u8GuUIy4+Wl1K4PBL7bJidAESPN8d5hkwfe0f5g3J40aIQJTU8Y0DY05izpExh/CQJS29VEGxSCVTuZ6QYQ5IvmQD+m31LmYblWkrglBCXaDftvrY4dCIN3Ui5xD6N9QkvXQBGWSMkzJ4S2vfyjjQ4CPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=m4w5T8gG; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732703728; x=1764239728;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=dANRT1QysBfh684irsoEIYvJESbzRAKP8LynwcGDE+4=;
  b=m4w5T8gGeYoATlymSj8BG48iNg2P97X1ROp+nzMy2qd5YWuoullg6iXy
   TMYyRIiOS+pySLSUfsNHAhYqT7jyfMXKkqIWfxxOKPZMzaFbTPfBHYf4l
   /bawtVp+4AnaHDunlf49Ar4W1AFRMHLMwyfkRfkC+G8rpBOqP4x7YInYy
   w=;
X-IronPort-AV: E=Sophos;i="6.12,189,1728950400"; 
   d="scan'208";a="356119897"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 10:35:24 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:44523]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.62:2525] with esmtp (Farcaster)
 id e57ab266-76c7-474b-a839-3465549ca324; Wed, 27 Nov 2024 10:35:23 +0000 (UTC)
X-Farcaster-Flow-ID: e57ab266-76c7-474b-a839-3465549ca324
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 10:35:21 +0000
Received: from [192.168.3.246] (10.106.82.33) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 27 Nov 2024
 10:35:19 +0000
Message-ID: <522cb8d6-63fa-4450-a786-86da64f8ecc3@amazon.com>
Date: Wed, 27 Nov 2024 10:35:17 +0000
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
 <e12ef1ad-7576-4874-8cc2-d48b6619fa95@amazon.com>
 <Z0ZHSHxpagw_HXDQ@google.com>
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
In-Reply-To: <Z0ZHSHxpagw_HXDQ@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D013EUB003.ant.amazon.com (10.252.51.65) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 26/11/2024 22:10, Sean Christopherson wrote:
> On Tue, Nov 26, 2024, Nikita Kalyazin wrote:
>> On 26/11/2024 00:06, Sean Christopherson wrote:
>>> On Mon, Nov 25, 2024, Nikita Kalyazin wrote:
>>>> In both cases the fault handling code is blocked and the pCPU is free for
>>>> other tasks.  I can't see the vCPU spinning on the IO to get completed if
>>>> the async task isn't created.  I tried that with and without async PF
>>>> enabled by the guest (MSR_KVM_ASYNC_PF_EN).
>>>>
>>>> What am I missing?
>>>
>>> Ah, I was wrong about the vCPU spinning.
>>>
>>> The goal is specifically to schedule() from KVM context, i.e. from kvm_vcpu_block(),
>>> so that if a virtual interrupt arrives for the guest, KVM can wake the vCPU and
>>> deliver the IRQ, e.g. to reduce latency for interrupt delivery, and possible even
>>> to let the guest schedule in a different task if the IRQ is the guest's tick.
>>>
>>> Letting mm/ or fs/ do schedule() means the only wake event even for the vCPU task
>>> is the completion of the I/O (or whatever the fault is waiting on).
>>
>> Ok, great, then that's how I understood it last time.  The only thing that
>> is not entirely clear to me is like Vitaly says, KVM_ASYNC_PF_SEND_ALWAYS is
>> no longer set, because we don't want to inject IRQs into the guest when it's
>> in kernel mode, but the "host async PF" case would still allow IRQs (eg
>> ticks like you said).  Why is it safe to deliver them?
> 
> IRQs are fine, the problem with PV async #PF is that it directly injects a #PF,
> which the kernel may not be prepared to handle.

You're right indeed, I was overfocused on IRQs for some reason.

>>>>>>> I have no objection to disabling host async page faults,
>>>>>>> e.g. it's probably a net>>>>> negative for 1:1 vCPU:pCPU pinned setups, but such disabling
>>>>>>> needs an opt-in from>>>>> userspace.
>> Back to this, I couldn't see a significant effect of this optimisation with
>> the original async PF so happy to give it up, but it does make a difference
>> when applied to async PF user [2] in my setup.  Would a new cap be a good
>> way for users to express their opt-in for it?
> 
> This probably needs to be handled in the context of the async #PF user series.
> If that series never lands, adding a new cap is likely a waste.  And I suspect
> that even then, a capability may not be warranted (truly don't know, haven't
> looked at your other series).

Yes, I meant that to be included in the async #PF user series (if 
required), not this one.  Just wanted to bring it up here, because the 
thread already had the relevant context.  Thanks.

