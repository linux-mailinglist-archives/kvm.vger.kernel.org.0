Return-Path: <kvm+bounces-39621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 265E2A487B8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92C9B3AD4D2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8D51F584B;
	Thu, 27 Feb 2025 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="G3/XvC/X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98831B424D;
	Thu, 27 Feb 2025 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740680655; cv=none; b=IAQzqka42/KsxeK8w11pbhtw1AAzWqHwSFYxP4VpEAsjwc/KbUxVCpeJebWfhXu3akz8h4RWJkftNFN0h+kK/8FFlh/HbHCHEPAvbN7A7pTmxY7tnycFFczsE//9FMTO83y9ZXfWx/4QxDbBXkA8B/gGmb1ahUIJj6d4LxyiMIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740680655; c=relaxed/simple;
	bh=I1CbooREzLYn9AAlLO5H4sUKHJxW7EPg7nEEHpyFmNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FFWuTyj8wYmrxXFj150GVeZijiDkf2/ls5hy3WKQPM1CYAZAQDivcgg0BiJGNSCm6FujP44nrXNASqqaqd//MVmGnH7OWWGKGJnxADAz4td94Zw6B1ADugjappO5nuTQXu2YzDqPx81cKIQwmCVeIimaXVT6GB9IUZ6I82VD3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=G3/XvC/X; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740680653; x=1772216653;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=j3OPBGuyioaxsCKCSnyqb+F4cY9H+pA8vNbT+Ls4f/A=;
  b=G3/XvC/X20YPL2O+wFXBQjsinccl8Xrr8olD/DNvb4u9vyeruoSySQ6O
   j2XE1DuRKasNrTmRWGl4HI4hV/kULyXW60nyLoBj62xFDeO1k0AhNIZal
   Q2Bk5rO+fxMlNcLuG1XSiVin7/Ci8M97xlPAKA9SzeoIkc+659CB2Jrff
   g=;
X-IronPort-AV: E=Sophos;i="6.13,320,1732579200"; 
   d="scan'208";a="69833984"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:24:10 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:43332]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.1.85:2525] with esmtp (Farcaster)
 id a2951172-87b8-49fe-bd0f-813ab7bbf005; Thu, 27 Feb 2025 18:24:08 +0000 (UTC)
X-Farcaster-Flow-ID: a2951172-87b8-49fe-bd0f-813ab7bbf005
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 27 Feb 2025 18:24:08 +0000
Received: from [192.168.19.93] (10.106.83.21) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Thu, 27 Feb 2025
 18:24:07 +0000
Message-ID: <7f2b25c9-c92b-4b0a-bfd9-dda8b0b7a244@amazon.com>
Date: Thu, 27 Feb 2025 18:24:05 +0000
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
 <a7080c07-0fc5-45ce-92f7-5f432a67bc63@amazon.com>
 <Z7X2EKzgp_iN190P@google.com>
 <6eddd049-7c7a-406d-b763-78fa1e7d921b@amazon.com>
 <Z7d5HT7FpE-ZsHQ9@google.com>
 <f820b630-13c1-4164-baa8-f5e8231612d1@amazon.com>
 <Z75nRwSBxpeMwbsR@google.com>
 <946fc0f5-4306-4aa9-9b63-f7ccbaff8003@amazon.com>
 <Z8CWUiAYVvNKqzfK@google.com>
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
In-Reply-To: <Z8CWUiAYVvNKqzfK@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D006EUA002.ant.amazon.com (10.252.50.65) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 27/02/2025 16:44, Sean Christopherson wrote:
> On Wed, Feb 26, 2025, Nikita Kalyazin wrote:
>> On 26/02/2025 00:58, Sean Christopherson wrote:
>>> On Fri, Feb 21, 2025, Nikita Kalyazin wrote:
>>>> On 20/02/2025 18:49, Sean Christopherson wrote:
>>>>> On Thu, Feb 20, 2025, Nikita Kalyazin wrote:
>>>>>> On 19/02/2025 15:17, Sean Christopherson wrote:
>>>>>>> On Wed, Feb 12, 2025, Nikita Kalyazin wrote:
>>>>>>> The conundrum with userspace async #PF is that if userspace is given only a single
>>>>>>> bit per gfn to force an exit, then KVM won't be able to differentiate between
>>>>>>> "faults" that will be handled synchronously by the vCPU task, and faults that
>>>>>>> usersepace will hand off to an I/O task.  If the fault is handled synchronously,
>>>>>>> KVM will needlessly inject a not-present #PF and a present IRQ.
>>>>>>
>>>>>> Right, but from the guest's point of view, async PF means "it will probably
>>>>>> take a while for the host to get the page, so I may consider doing something
>>>>>> else in the meantime (ie schedule another process if available)".
>>>>>
>>>>> Except in this case, the guest never gets a chance to run, i.e. it can't do
>>>>> something else.  From the guest point of view, if KVM doesn't inject what is
>>>>> effectively a spurious async #PF, the VM-Exiting instruction simply took a (really)
>>>>> long time to execute.
>>>>
>>>> Sorry, I didn't get that.  If userspace learns from the
>>>> kvm_run::memory_fault::flags that the exit is due to an async PF, it should
>>>> call kvm run immediately, inject the not-present PF and allow the guest to
>>>> reschedule.  What do you mean by "the guest never gets a chance to run"?
>>>
>>> What I'm saying is that, as proposed, the API doesn't precisely tell userspace
>                                                                           ^^^^^^^^^
>                                                                           KVM
>>> an exit happened due to an "async #PF".  KVM has absolutely zero clue as to
>>> whether or not userspace is going to do an async #PF, or if userspace wants to
>>> intercept the fault for some entirely different purpose.
>>
>> Userspace is supposed to know whether the PF is async from the dedicated
>> flag added in the memory_fault structure:
>> KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER.  It will be set when KVM managed to
>> inject page-not-present.  Are you saying it isn't sufficient?
> 
> Gah, sorry, typo.  The API doesn't tell *KVM* that userfault exit is due to an
> async #PF.
> 
>>> Unless the remote page was already requested, e.g. by a different vCPU, or by a
>>> prefetching algorithim.
>>>
>>>> Conversely, if the page content is available, it must have already been
>>>> prepopulated into guest memory pagecache, the bit in the bitmap is cleared
>>>> and no exit to userspace occurs.
>>>
>>> But that doesn't happen instantaneously.  Even if the VMM somehow atomically
>>> receives the page and marks it present, it's still possible for marking the page
>>> present to race with KVM checking the bitmap.
>>
>> That looks like a generic problem of the VM-exit fault handling.  Eg when
> 
> Heh, it's a generic "problem" for faults in general.  E.g. modern x86 CPUs will
> take "spurious" page faults on write accesses if a PTE is writable in memory but
> the CPU has a read-only mapping cached in its TLB.
> 
> It's all a matter of cost.  E.g. pre-Nehalem Intel CPUs didn't take such spurious
> read-only faults as they would re-walk the in-memory page tables, but that ended
> up being a net negative because the cost of re-walking for all read-only faults
> outweighed the benefits of avoiding spurious faults in the unlikely scenario the
> fault had already been fixed.
> 
> For a spurious async #PF + IRQ, the cost could be signficant, e.g. due to causing
> unwanted context switches in the guest, in addition to the raw overhead of the
> faults, interrupts, and exits.
> 
>> one vCPU exits, userspace handles the fault and races setting the bitmap
>> with another vCPU that is about to fault the same page, which may cause a
>> spurious exit.
>>
>> On the other hand, is it malignant?  The only downside is additional
>> overhead of the async PF protocol, but if the race occurs infrequently, it
>> shouldn't be a problem.
> 
> When it comes to uAPI, I want to try and avoid statements along the lines of
> "IF 'x' holds true, then 'y' SHOULDN'T be a problem".  If this didn't impact uAPI,
> I wouldn't care as much, i.e. I'd be much more willing iterate as needed.
> 
> I'm not saying we should go straight for a complex implementation.  Quite the
> opposite.  But I do want us to consider the possible ramifications of using a
> single bit for all userfaults, so that we can at least try to design something
> that is extensible and won't be a pain to maintain.

So you would've liked more the "two-bit per gfn" approach as in: provide 
2 interception points, for sync and async exits, with the former chosen 
by userspace when it "knows" that the content is already in memory? 
What makes it a conundrum then?  It looks like an incremental change to 
what has already been proposed.  There is a complication that 2-bit 
operations aren't atomic, but even 1 bit is racy between KVM and userspace.

