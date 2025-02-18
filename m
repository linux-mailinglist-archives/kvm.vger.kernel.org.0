Return-Path: <kvm+bounces-38459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A344A3A394
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61348166AA9
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EEE26FA5D;
	Tue, 18 Feb 2025 17:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="OqWu0HRh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB51A26F464;
	Tue, 18 Feb 2025 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739898432; cv=none; b=bZszXXowE0+8XNp8LJRpRvme2epU/6fAxjS46iS0/H2AVRSIWlAf23Oujt9V5CxDqiaYsy9TgrGohffC4qYAkaROJar/LWDUqi6vsoN5GknKpR8pSlEEojhY37Uu+3UPYh2kBdEI4c1YosL07lTC4dsE0Nwag3voIeCm71FVQA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739898432; c=relaxed/simple;
	bh=z2W1klaC4NrqrdesRaJJCmZ5n84Sqox4d0Ii0u9BNx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cPg8XuLq1jR4JF/OghlZZdk/PmVQODmUv/G1YKGpYgqBGFofvyMefx9XcQalOTBimyMKOeOBFISYFew02IR6enHrLf2Kej8LhbDgfq6Z1hdF/vrQiWIXm0cplPFrM36vxEnadKQfHFYU3FjgR1lJLclBxbq/G5YlsfmXa3u/Dy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=OqWu0HRh; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739898432; x=1771434432;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=EkRdFMxzr88qlSnaM0L16SDNRKu0/9NO/91zT99To3c=;
  b=OqWu0HRhii20JUcXd6ERwSAtOC6ZpOwPkyi4ccQqkUHr3KaruVjrXTBe
   uCOVNYpwt8D0RisR/N6GwiHldP3kEKGUQYiXQGy8rHq4t/5Py8/mDWltJ
   slGLx+K2M3r2xyMA4ICUfqnFSGDF6ZZCQqIVZEr1BgEr0yDnaR2jFLWJp
   Y=;
X-IronPort-AV: E=Sophos;i="6.13,296,1732579200"; 
   d="scan'208";a="473228396"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:07:06 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:52643]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.23.222:2525] with esmtp (Farcaster)
 id b9484c5d-2f40-4fcd-8dcf-fd02932115e9; Tue, 18 Feb 2025 17:07:04 +0000 (UTC)
X-Farcaster-Flow-ID: b9484c5d-2f40-4fcd-8dcf-fd02932115e9
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 18 Feb 2025 17:07:02 +0000
Received: from [192.168.22.162] (10.106.83.18) by
 EX19D022EUC002.ant.amazon.com (10.252.51.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 18 Feb 2025 17:07:02 +0000
Message-ID: <5078ebfd-c81e-4f2f-95a8-5da48c659dc2@amazon.com>
Date: Tue, 18 Feb 2025 17:07:01 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH 1/2] KVM: x86: async_pf: remove support for
 KVM_ASYNC_PF_SEND_ALWAYS
To: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>
CC: <pbonzini@redhat.com>, <corbet@lwn.net>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <xiaoyao.li@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <roypat@amazon.co.uk>, <xmarcalx@amazon.com>
References: <20241127172654.1024-1-kalyazin@amazon.com>
 <20241127172654.1024-2-kalyazin@amazon.com> <Z6ucl7U79RuBsYJt@google.com>
 <87frkcrab8.fsf@redhat.com> <Z7SkfSRsE5hcsrRe@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <Z7SkfSRsE5hcsrRe@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D005EUB001.ant.amazon.com (10.252.51.12) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 18/02/2025 15:17, Sean Christopherson wrote:
> On Mon, Feb 17, 2025, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>>> On Wed, Nov 27, 2024, Nikita Kalyazin wrote:
>>>> 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9 ("x86/kvm: Restrict
>>>> ASYNC_PF to user space") stopped setting KVM_ASYNC_PF_SEND_ALWAYS in
>>>> Linux guests.  While the flag can still be used by legacy guests, the
>>>> mechanism is best effort so KVM is not obliged to use it.
>>>
>>> What's the actual motivation to remove it from KVM?  I agreed KVM isn't required
>>> to honor KVM_ASYNC_PF_SEND_ALWAYS from a guest/host ABI perspective, but that
>>> doesn't mean that dropping a feature has no impact.  E.g. it's entirely possible
>>> removing this support could negatively affect a workload running on an old kernel.
>>>
>>> Looking back at the discussion[*] where Vitaly made this suggestion, I don't see
>>> anything that justifies dropping this code.  It costs KVM practically nothing to
>>> maintain this code.
>>>
>>> [*] https://lore.kernel.org/all/20241118130403.23184-1-kalyazin@amazon.com
>>>
>>
>> How old is old? :-)
>>
>> Linux stopped using KVM_ASYNC_PF_SEND_ALWAYS in v5.8:
> 
> 5.8 is practically a baby.  Maybe a toddler :-)
> 
>> commit 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Fri Apr 24 09:57:56 2020 +0200
>>
>>      x86/kvm: Restrict ASYNC_PF to user space
>>
>> and I was under the impression other OSes never used KVM asynchronous
>> page-fault in the first place (not sure about *BSDs though but certainly
>> not Windows). As Nikita's motivation for the patch was "to avoid the
>> overhead ... in case of kernel-originated faults" I suggested we start
>> by simplifyign the code to not care about 'send_user_only' at all.
> 
> In practice, I don't think it's a meaningful simplification.  There are other
> scenarios where KVM shouldn't inject an async #PF, so kvm_can_deliver_async_pf()
> itself isn't going anywhere.
> 
> AFAICT, what Nikita actually wants is a way to disable host-side async #PF, e.g.

That's correct.  Just wanted to say that the main intention was to do 
that for async PF user [1] where the difference in performance is 
noticeable (at least in my setup).  I'm totally ok with the status quo 
in the async PF kernel.  If however the mechanism to achieve that turns 
out to be generic, it's better to support for both, I guess.

[1]: 
https://lore.kernel.org/kvm/20241118123948.4796-1-kalyazin@amazon.com/T/

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f97d4d435e7f..d461e1b5489c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13411,7 +13411,8 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>                       kvm_is_exception_pending(vcpu)))
>                  return false;
> 
> -       if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
> +       if ((kvm_hlt_in_guest(vcpu->kvm) || kvm_only_pv_async_pf(vcpu->kvm)) &&
> +           !kvm_can_deliver_async_pf(vcpu))
>                  return false;
> 
>          /*
> 
>> We can keep the code around, I guess, but with no plans to re-introduce
>> KVM_ASYNC_PF_SEND_ALWAYS usage to Linux I still believe it would be good
>> to set a deprecation date.


