Return-Path: <kvm+bounces-37982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CE7A32E3B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 19:14:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F384188AD18
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 18:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052E625E446;
	Wed, 12 Feb 2025 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="qm0sMRbZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4A25C709;
	Wed, 12 Feb 2025 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384066; cv=none; b=exjfnftmg8CFpK3n6z6NiC2Qfqc65XgmV2XXmz7qeAhbuJ2GCAxKTjfDa64xZY7nid1aqC9v1t010UsWvquPuSW4MJI7853Avjk8y1pQsOPwz2ACj3QcKHHSD2zIny8XAuWH8Hoi26SAW782nYMwsd3IR4GIMqrCR19SS46FWt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384066; c=relaxed/simple;
	bh=Vm/vy95eI1ezE1PcaSjVCSTl+B1DwmM79oWZaxTkKyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HZcVeiTeVOg2p/gizBwqMIEuwmK5OEXtk2EZF3h0lYn1T4G4IzwX3I/sx8fWkfLuF/oXYDurV/795eAYOtivq2vFwArsz/GA5ulBkZD+RWJVh2WNoBJjTRFLia/j1AZHcuPyrzwae/w3/fVhDu1xlFpbNyJpqFCXgKoYcqOUcWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=qm0sMRbZ; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739384063; x=1770920063;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=tLQ7EYLSV5p6U68SgS/kba4CtD/Xo5+7Mfv8EG+fVPo=;
  b=qm0sMRbZvEwXaQ6YMG/aNu1yH00ZLgZZ/LPlcv1PTAVfe4tmtc2CwjxC
   XpHgus/LmrWzJou09u+Y9K/hDi9ixrKWmh1X4xrVoAq/XcFmUqQMy+hP7
   7GLxSmZZ16N+Fu1wihbCjRUlTeQ8OZldNxoAYK0XVwCbug11eaNgAIcWV
   s=;
X-IronPort-AV: E=Sophos;i="6.13,280,1732579200"; 
   d="scan'208";a="171921279"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 18:14:17 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:55874]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.13.140:2525] with esmtp (Farcaster)
 id 904e299c-b667-4a04-9212-5c8f5c103a88; Wed, 12 Feb 2025 18:14:16 +0000 (UTC)
X-Farcaster-Flow-ID: 904e299c-b667-4a04-9212-5c8f5c103a88
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Wed, 12 Feb 2025 18:14:16 +0000
Received: from [192.168.16.81] (10.106.82.23) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 12 Feb 2025
 18:14:14 +0000
Message-ID: <a7080c07-0fc5-45ce-92f7-5f432a67bc63@amazon.com>
Date: Wed, 12 Feb 2025 18:14:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/6] KVM: x86: async PF user
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
In-Reply-To: <Z6u-WdbiW3n7iTjp@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D007EUA002.ant.amazon.com (10.252.50.68) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 11/02/2025 21:17, Sean Christopherson wrote:
> On Mon, Nov 18, 2024, Nikita Kalyazin wrote:
>> Async PF [1] allows to run other processes on a vCPU while the host
>> handles a stage-2 fault caused by a process on that vCPU. When using
>> VM-exit-based stage-2 fault handling [2], async PF functionality is lost
>> because KVM does not run the vCPU while a fault is being handled so no
>> other process can execute on the vCPU. This patch series extends
>> VM-exit-based stage-2 fault handling with async PF support by letting
>> userspace handle faults instead of the kernel, hence the "async PF user"
>> name.
>>
>> I circulated the idea with Paolo, Sean, David H, and James H at the LPC,
>> and the only concern I heard was about injecting the "page not present"
>> event via #PF exception in the CoCo case, where it may not work. In my
>> implementation, I reused the existing code for doing that, so the async
>> PF user implementation is on par with the present async PF
>> implementation in this regard, and support for the CoCo case can be
>> added separately.
>>
>> Please note that this series is applied on top of the VM-exit-based
>> stage-2 fault handling RFC [2].
> 
> ...
> 
>> Nikita Kalyazin (6):
>>    Documentation: KVM: add userfault KVM exit flag
>>    Documentation: KVM: add async pf user doc
>>    KVM: x86: add async ioctl support
>>    KVM: trace events: add type argument to async pf
>>    KVM: x86: async_pf_user: add infrastructure
>>    KVM: x86: async_pf_user: hook to fault handling and add ioctl
>>
>>   Documentation/virt/kvm/api.rst  |  35 ++++++
>>   arch/x86/include/asm/kvm_host.h |  12 +-
>>   arch/x86/kvm/Kconfig            |   7 ++
>>   arch/x86/kvm/lapic.c            |   2 +
>>   arch/x86/kvm/mmu/mmu.c          |  68 ++++++++++-
>>   arch/x86/kvm/x86.c              | 101 +++++++++++++++-
>>   arch/x86/kvm/x86.h              |   2 +
>>   include/linux/kvm_host.h        |  30 +++++
>>   include/linux/kvm_types.h       |   1 +
>>   include/trace/events/kvm.h      |  50 +++++---
>>   include/uapi/linux/kvm.h        |  12 +-
>>   virt/kvm/Kconfig                |   3 +
>>   virt/kvm/Makefile.kvm           |   1 +
>>   virt/kvm/async_pf.c             |   2 +-
>>   virt/kvm/async_pf_user.c        | 197 ++++++++++++++++++++++++++++++++
>>   virt/kvm/async_pf_user.h        |  24 ++++
>>   virt/kvm/kvm_main.c             |  14 +++
>>   17 files changed, 535 insertions(+), 26 deletions(-)
> 
> I am supportive of the idea, but there is way too much copy+paste in this series.
Hi Sean,

Yes, like I mentioned in the cover letter, I left the new implementation 
isolated on purpose to make the scope of the change clear.  There is 
certainly lots of duplication that should be removed later on.

> And it's not just the code itself, it's all the structures and concepts.  Off the
> top of my head, I can't think of any reason there needs to be a separate queue,
> separate lock(s), etc.  The only difference between kernel APF and user APF is
> what chunk of code is responsible for faulting in the page.

There are two queues involved:
  - "queue": stores in-flight faults. APF-kernel uses it to cancel all 
works if needed.  APF-user does not have a way to "cancel" userspace 
works, but it uses the queue to look up the struct by the token when 
userspace reports a completion.
  - "ready": stores completed faults until KVM finds a chance to tell 
guest about them.

I agree that the "ready" queue can be shared between APF-kernel and 
-user as it's used in the same way.  As for the "queue" queue, do you 
think it's ok to process its elements differently based on the "type" of 
them in a single loop [1] instead of having two separate queues?

[1] https://elixir.bootlin.com/linux/v6.13.2/source/virt/kvm/async_pf.c#L120

> I suspect a good place to start would be something along the lines of the below
> diff, and go from there.  Given that KVM already needs to special case the fake
> "wake all" items, I'm guessing it won't be terribly difficult to teach the core
> flows about userspace async #PF.

That sounds sensible.  I can certainly approach it in a "bottom up" way 
by sparingly adding handling where it's different in APF-user rather 
than adding it side by side and trying to merge common parts.

> I'm also not sure that injecting async #PF for all userfaults is desirable.  For
> in-kernel async #PF, KVM knows that faulting in the memory would sleep.  For
> userfaults, KVM has no way of knowing if the userfault will sleep, i.e. should
> be handled via async #PF.  The obvious answer is to have userspace only enable
> userspace async #PF when it's useful, but "an all or nothing" approach isn't
> great uAPI.  On the flip side, adding uAPI for a use case that doesn't exist
> doesn't make sense either :-/

I wasn't able to locate the code that would check whether faulting would 
sleep in APF-kernel.  KVM spins APF-kernel whenever it can ([2]). 
Please let me know if I'm missing something here.

[2] 
https://elixir.bootlin.com/linux/v6.13.2/source/arch/x86/kvm/mmu/mmu.c#L4360

> Exiting to userspace in vCPU context is also kludgy.  It makes sense for base
> userfault, because the vCPU can't make forward progress until the fault is
> resolved.  Actually, I'm not even sure it makes sense there.  I'll follow-up in

Even though we exit to userspace, in case of APF-user, userspace is 
supposed to VM enter straight after scheduling the async job, which is 
then executed concurrently with the vCPU.

> James' series.  Anyways, it definitely doesn't make sense for async #PF, because
> the whole point is to let the vCPU run.  Signalling userspace would definitely
> add complexity, but only because of the need to communicate the token and wait
> for userspace to consume said token.  I'll think more on that.

By signalling userspace you mean a new non-exit-to-userspace mechanism 
similar to UFFD?  What advantage can you see in it over exiting to 
userspace (which already exists in James's series)?


Thanks,
Nikita

> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 0ee4816b079a..fc31b47cf9c5 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -177,7 +177,8 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>    * success, 'false' on failure (page fault has to be handled synchronously).
>    */
>   bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -                       unsigned long hva, struct kvm_arch_async_pf *arch)
> +                       unsigned long hva, struct kvm_arch_async_pf *arch,
> +                       bool userfault)
>   {
>          struct kvm_async_pf *work;
> 
> @@ -202,13 +203,16 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>          work->addr = hva;
>          work->arch = *arch;
> 
> -       INIT_WORK(&work->work, async_pf_execute);
> -
>          list_add_tail(&work->queue, &vcpu->async_pf.queue);
>          vcpu->async_pf.queued++;
>          work->notpresent_injected = kvm_arch_async_page_not_present(vcpu, work);
> 
> -       schedule_work(&work->work);
> +       if (userfault) {
> +               work->userfault = true;
> +       } else {
> +               INIT_WORK(&work->work, async_pf_execute);
> +               schedule_work(&work->work);
> +       }
> 
>          return true;
>   }


