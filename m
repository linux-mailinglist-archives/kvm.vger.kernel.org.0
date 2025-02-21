Return-Path: <kvm+bounces-38845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C9FA3F29C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 12:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D26119C6B2D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 11:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E7C2080EA;
	Fri, 21 Feb 2025 11:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="MurHizg3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4170B1EB1A6;
	Fri, 21 Feb 2025 11:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740135749; cv=none; b=LejdgP048zqsHeA88GtAeQ2W+VlGZezFvLVtRmoBPp6hOk5w8GfDGapjzL+1qb7g3iVGIeFLOJPI1QQvycUU43/P5LvG3k4qRtTMIVUWKPB0NYTSMjt91f6KtJlbZcC4HrUustSe+YdSDQmZK5CqHNrl13MeDw6HIdyKdnpHA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740135749; c=relaxed/simple;
	bh=eNLkknFRSmBxOet24bmBXoewQoMVBIWYBNaTmtsnYTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WDVmaphPs9J/uLNJpU2pZHJSYRbG4xti8QjLy3fVESJ6KZs7SJNY9YYXmm64fHrx3FRrKWZ6xjZ7Em+G6mj1+g/L7cvei00GX1//oKmZVewM2iN+pwQ245FOMfxcgPSHZcNADRGEgGCWLFr2rMi//rfU6NXcyLeE9IsfqxwI1kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=MurHizg3; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740135748; x=1771671748;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=wVZmmrzgZqCCthLth4G92Wt3dsta5fcgtbs4H+qCwfI=;
  b=MurHizg3kjSv9jQIf6F8ot4q+OWuloVaFs7XWnSC09xTGkJGTAzXnX21
   dxymkKDH4NK/gZxwcyIHdm/xMqOI2iboBNbvSXZ9p1hC4Ugnurw3IFy0v
   YdsCQZGCjnohyPMo7J/erb2NfsKrXFTretxT4Gcxl4Nspii2wNp5YA2rA
   w=;
X-IronPort-AV: E=Sophos;i="6.13,304,1732579200"; 
   d="scan'208";a="273223897"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 11:02:24 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:44889]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.107:2525] with esmtp (Farcaster)
 id f351c569-4f9b-48af-8480-bb025a5a6c0a; Fri, 21 Feb 2025 11:02:23 +0000 (UTC)
X-Farcaster-Flow-ID: f351c569-4f9b-48af-8480-bb025a5a6c0a
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 21 Feb 2025 11:02:23 +0000
Received: from [192.168.7.129] (10.106.83.15) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Fri, 21 Feb 2025
 11:02:21 +0000
Message-ID: <f820b630-13c1-4164-baa8-f5e8231612d1@amazon.com>
Date: Fri, 21 Feb 2025 11:02:20 +0000
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
In-Reply-To: <Z7d5HT7FpE-ZsHQ9@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D013EUB004.ant.amazon.com (10.252.51.92) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 20/02/2025 18:49, Sean Christopherson wrote:
> On Thu, Feb 20, 2025, Nikita Kalyazin wrote:
>> On 19/02/2025 15:17, Sean Christopherson wrote:
>>> On Wed, Feb 12, 2025, Nikita Kalyazin wrote:
>>> The conundrum with userspace async #PF is that if userspace is given only a single
>>> bit per gfn to force an exit, then KVM won't be able to differentiate between
>>> "faults" that will be handled synchronously by the vCPU task, and faults that
>>> usersepace will hand off to an I/O task.  If the fault is handled synchronously,
>>> KVM will needlessly inject a not-present #PF and a present IRQ.
>>
>> Right, but from the guest's point of view, async PF means "it will probably
>> take a while for the host to get the page, so I may consider doing something
>> else in the meantime (ie schedule another process if available)".
> 
> Except in this case, the guest never gets a chance to run, i.e. it can't do
> something else.  From the guest point of view, if KVM doesn't inject what is
> effectively a spurious async #PF, the VM-Exiting instruction simply took a (really)
> long time to execute.

Sorry, I didn't get that.  If userspace learns from the 
kvm_run::memory_fault::flags that the exit is due to an async PF, it 
should call kvm run immediately, inject the not-present PF and allow the 
guest to reschedule.  What do you mean by "the guest never gets a chance 
to run"?

>> If we are exiting to userspace, it isn't going to be quick anyway, so we can
>> consider all such faults "long" and warranting the execution of the async PF
>> protocol.  So always injecting a not-present #PF and page ready IRQ doesn't
>> look too wrong in that case.
> 
> There is no "wrong", it's simply wasteful.  The fact that the userspace exit is
> "long" is completely irrelevant.  Decompressing zswap is also slow, but it is
> done on the current CPU, i.e. is not background I/O, and so doesn't trigger async
> #PFs.
> 
> In the guest, if host userspace resolves the fault before redoing KVM_RUN, the
> vCPU will get two events back-to-back: an async #PF, and an IRQ signalling completion
> of that #PF.

Is this practically likely?  At least in our scenario (Firecracker 
snapshot restore) and probably in live migration postcopy, if a vCPU 
hits a fault, it's probably because the content of the page is somewhere 
remote (eg on the source machine or wherever the snapshot data is 
stored) and isn't going to be available quickly.  Conversely, if the 
page content is available, it must have already been prepopulated into 
guest memory pagecache, the bit in the bitmap is cleared and no exit to 
userspace occurs.

>>>> What advantage can you see in it over exiting to userspace (which already exists
>>>> in James's series)?
>>>
>>> It doesn't exit to userspace :-)
>>>
>>> If userspace simply wakes a different task in response to the exit, then KVM
>>> should be able to wake said task, e.g. by signalling an eventfd, and resume the
>>> guest much faster than if the vCPU task needs to roundtrip to userspace.  Whether
>>> or not such an optimization is worth the complexity is an entirely different
>>> question though.
>>
>> This reminds me of the discussion about VMA-less UFFD that was coming up
>> several times, such as [1], but AFAIK hasn't materialised into something
>> actionable.  I may be wrong, but James was looking into that and couldn't
>> figure out a way to scale it sufficiently for his use case and had to stick
>> with the VM-exit-based approach.  Can you see a world where VM-exit
>> userfaults coexist with no-VM-exit way of handling async PFs?
> 
> The issue with UFFD is that it's difficult to provide a generic "point of contact",
> whereas with KVM userfault, signalling can be tied to the vCPU, and KVM can provide
> per-vCPU buffers/structures to aid communication.
> 
> That said, supporting "exitless" KVM userfault would most definitely be premature
> optimization without strong evidence it would benefit a real world use case.

Does that mean that the "exitless" solution for async PF is a long-term 
one (if required), while the short-term would still be "exitful" (if we 
find a way to do it sensibly)?

