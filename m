Return-Path: <kvm+bounces-38770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 902D8A3E3DC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A68C47A4AA5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E100121481F;
	Thu, 20 Feb 2025 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="r8/SFMIz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D284F2144D6;
	Thu, 20 Feb 2025 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740076158; cv=none; b=EzKWnYGEqCK+RMV4zBMJ+oMJ1YGb+vpv/KpGKsBCGPSN7cym2swIN8NgIasnB4734B2b9YAL1VIxUlX+/hqiJILnr91BXWMprockuAFlA/V1Wjtazk1jgSfIBJrg/yVmTZzZ/qFzrtfsm/YSN5QgrIhWAKfvGWTIRQR8z1P0kWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740076158; c=relaxed/simple;
	bh=kqVz+1AldbLXOBZVYypP2Ed2J4FtZ20KxmQsr5EG5iA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=arM01AogasjTYKlGaJQxFYDt4iCU5u4ht5vazjdTgjyju//snyxF8JE8CqRx2ik+7mNm5L9j0lgrWp6R5j0jZ+24Bwd/JWYCNDz5qyoyBuw43f8hNLe5RalVdzyHO9EdSUc3ce5Jf/9p4kuwQ4memhk89ma8VSyDhD0lUpGzfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=r8/SFMIz; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740076156; x=1771612156;
  h=message-id:date:mime-version:from:subject:reply-to:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ybnQQQJshfjPtf2iD7zzoG7mrZXy9rePM8iGKoPDiY0=;
  b=r8/SFMIzr3DEIdXGFTGOCPq6ZV6Wy0vl8EshugAVSf0KixQ9/2QZs+54
   KfKXGkiOaltNK8TqssFFjHBxrSt+/ykeVIc2+gQ/K+vDnYp7ie8d1nmVz
   f6x5nbxXdVVG+fBaDlq2t9szYsEmfk8aQmG+CRv8aAKbAegH+2dF+7SDN
   g=;
X-IronPort-AV: E=Sophos;i="6.13,302,1732579200"; 
   d="scan'208";a="464360141"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 18:29:12 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:8297]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.214:2525] with esmtp (Farcaster)
 id dc32c66d-6ddc-49fb-8a7a-c0ff88da8034; Thu, 20 Feb 2025 18:29:10 +0000 (UTC)
X-Farcaster-Flow-ID: dc32c66d-6ddc-49fb-8a7a-c0ff88da8034
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 20 Feb 2025 18:29:10 +0000
Received: from [192.168.17.147] (10.106.82.15) by
 EX19D022EUC002.ant.amazon.com (10.252.51.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 20 Feb 2025 18:29:08 +0000
Message-ID: <6eddd049-7c7a-406d-b763-78fa1e7d921b@amazon.com>
Date: Thu, 20 Feb 2025 18:29:01 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Nikita Kalyazin <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/6] KVM: x86: async PF user
Reply-To: <kalyazin@amazon.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <corbet@lwn.net>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <jthoughton@google.com>,
	<david@redhat.com>, <peterx@redhat.com>, <oleg@redhat.com>,
	<vkuznets@redhat.com>, <gshan@redhat.com>, <graf@amazon.de>,
	<jgowans@amazon.com>, <roypat@amazon.co.uk>, <derekmn@amazon.com>,
	<nsaenz@amazon.es>, <xmarcalx@amazon.com>
References: <20241118123948.4796-1-kalyazin@amazon.com>
 <Z6u-WdbiW3n7iTjp@google.com>
 <a7080c07-0fc5-45ce-92f7-5f432a67bc63@amazon.com>
 <Z7X2EKzgp_iN190P@google.com>
Content-Language: en-US
In-Reply-To: <Z7X2EKzgp_iN190P@google.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D003EUA004.ant.amazon.com (10.252.50.128) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 19/02/2025 15:17, Sean Christopherson wrote:
> On Wed, Feb 12, 2025, Nikita Kalyazin wrote:
>> On 11/02/2025 21:17, Sean Christopherson wrote:
>>> On Mon, Nov 18, 2024, Nikita Kalyazin wrote:
>>> And it's not just the code itself, it's all the structures and concepts.  Off the
>>> top of my head, I can't think of any reason there needs to be a separate queue,
>>> separate lock(s), etc.  The only difference between kernel APF and user APF is
>>> what chunk of code is responsible for faulting in the page.
>>
>> There are two queues involved:
>>   - "queue": stores in-flight faults. APF-kernel uses it to cancel all works
>> if needed.  APF-user does not have a way to "cancel" userspace works, but it
>> uses the queue to look up the struct by the token when userspace reports a
>> completion.
>>   - "ready": stores completed faults until KVM finds a chance to tell guest
>> about them.
>>
>> I agree that the "ready" queue can be shared between APF-kernel and -user as
>> it's used in the same way.  As for the "queue" queue, do you think it's ok
>> to process its elements differently based on the "type" of them in a single
>> loop [1] instead of having two separate queues?
> 
> Yes.
> 
>> [1] https://elixir.bootlin.com/linux/v6.13.2/source/virt/kvm/async_pf.c#L120
>>
>>> I suspect a good place to start would be something along the lines of the below
>>> diff, and go from there.  Given that KVM already needs to special case the fake
>>> "wake all" items, I'm guessing it won't be terribly difficult to teach the core
>>> flows about userspace async #PF.
>>
>> That sounds sensible.  I can certainly approach it in a "bottom up" way by
>> sparingly adding handling where it's different in APF-user rather than
>> adding it side by side and trying to merge common parts.
>>
>>> I'm also not sure that injecting async #PF for all userfaults is desirable.  For
>>> in-kernel async #PF, KVM knows that faulting in the memory would sleep.  For
>>> userfaults, KVM has no way of knowing if the userfault will sleep, i.e. should
>>> be handled via async #PF.  The obvious answer is to have userspace only enable
>>> userspace async #PF when it's useful, but "an all or nothing" approach isn't
>>> great uAPI.  On the flip side, adding uAPI for a use case that doesn't exist
>>> doesn't make sense either :-/
>>
>> I wasn't able to locate the code that would check whether faulting would
>> sleep in APF-kernel.  KVM spins APF-kernel whenever it can ([2]). Please let
>> me know if I'm missing something here.
> 
> kvm_can_do_async_pf() will be reached if and only if faulting in the memory
> requires waiting.  If a page is swapped out, but faulting it back in doesn't
> require waiting, e.g. because it's in zswap and can be uncompressed synchronously,
> then the initial __kvm_faultin_pfn() with FOLL_NO_WAIT will succeed.
> 
>          /*
>           * If resolving the page failed because I/O is needed to fault-in the
>           * page, then either set up an asynchronous #PF to do the I/O, or if
>           * doing an async #PF isn't possible, retry with I/O allowed.  All
>           * other failures are terminal, i.e. retrying won't help.
>           */
>          if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
>                  return RET_PF_CONTINUE;
> 
>          if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>                  trace_kvm_try_async_get_page(fault->addr, fault->gfn);
>                  if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
>                          trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
>                          kvm_make_request(KVM_REQ_APF_HALT, vcpu);
>                          return RET_PF_RETRY;
>                  } else if (kvm_arch_setup_async_pf(vcpu, fault)) {
>                          return RET_PF_RETRY;
>                  }
>          }
> 
> The conundrum with userspace async #PF is that if userspace is given only a single
> bit per gfn to force an exit, then KVM won't be able to differentiate between
> "faults" that will be handled synchronously by the vCPU task, and faults that
> usersepace will hand off to an I/O task.  If the fault is handled synchronously,
> KVM will needlessly inject a not-present #PF and a present IRQ.

Right, but from the guest's point of view, async PF means "it will 
probably take a while for the host to get the page, so I may consider 
doing something else in the meantime (ie schedule another process if 
available)".  If we are exiting to userspace, it isn't going to be quick 
anyway, so we can consider all such faults "long" and warranting the 
execution of the async PF protocol.  So always injecting a not-present 
#PF and page ready IRQ doesn't look too wrong in that case.

> But that's a non-issue if the known use cases are all-or-nothing, i.e. if all
> userspace faults are either synchronous or asynchronous.

Yes, pretty much.  The user will be choosing the extreme that is more 
performant for their specific usecase.

>> [2] https://elixir.bootlin.com/linux/v6.13.2/source/arch/x86/kvm/mmu/mmu.c#L4360
>>
>>> Exiting to userspace in vCPU context is also kludgy.  It makes sense for base
>>> userfault, because the vCPU can't make forward progress until the fault is
>>> resolved.  Actually, I'm not even sure it makes sense there.  I'll follow-up in
>>
>> Even though we exit to userspace, in case of APF-user, userspace is supposed
>> to VM enter straight after scheduling the async job, which is then executed
>> concurrently with the vCPU.
>>
>>> James' series.  Anyways, it definitely doesn't make sense for async #PF, because
>>> the whole point is to let the vCPU run.  Signalling userspace would definitely
>>> add complexity, but only because of the need to communicate the token and wait
>>> for userspace to consume said token.  I'll think more on that.
>>
>> By signalling userspace you mean a new non-exit-to-userspace mechanism
>> similar to UFFD?
> 
> Yes.
> 
>> What advantage can you see in it over exiting to userspace (which already exists
>> in James's series)?
> 
> It doesn't exit to userspace :-)
> 
> If userspace simply wakes a different task in response to the exit, then KVM
> should be able to wake said task, e.g. by signalling an eventfd, and resume the
> guest much faster than if the vCPU task needs to roundtrip to userspace.  Whether
> or not such an optimization is worth the complexity is an entirely different
> question though.

This reminds me of the discussion about VMA-less UFFD that was coming up 
several times, such as [1], but AFAIK hasn't materialised into something 
actionable.  I may be wrong, but James was looking into that and 
couldn't figure out a way to scale it sufficiently for his use case and 
had to stick with the VM-exit-based approach.  Can you see a world where 
VM-exit userfaults coexist with no-VM-exit way of handling async PFs?

[1]: https://lore.kernel.org/kvm/ZqwKuzfAs7pvdHAN@x1n/

