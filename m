Return-Path: <kvm+bounces-39305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D04B0A4677B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBB747A4570
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 17:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A055D2248B3;
	Wed, 26 Feb 2025 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="dvHIUUlO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0697E223716;
	Wed, 26 Feb 2025 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589679; cv=none; b=Yml/XPT2drIyUZvaC7h70FB/I/RTAXukznAmdGpiBNexbLYnGO8T2hHF+tD7SGsFYJ/OSHc+pst/kM4jcO8+OVML3cBb7kYglZeKX1unBZwkf4VXE19N0QpV32wrC33U0CKIYhl8Awu3QhUhig7nzLTAfpj5j9bjKr16TDFL+9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589679; c=relaxed/simple;
	bh=cBaG+oS7JYdfqzVyKfbb8rgJ131fRZ/Hoj95YqdcdI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YX60Egk4dH2+Sy1PzIB3VWwshdZqZxmz6UHHEU6isriOx/0z/UjpA5u4oVyxN2kyUIgu368x/+YCkW+hCHOP9X9RI6IGeONvAckEKKI3S8rt8zSzlxnNIGFX5l0EScFv3GUqYrU0uWUBCeR1Og/g9i6mIK/fmt5yHm9wVSNsmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=dvHIUUlO; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740589675; x=1772125675;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=BPwWo87sDuI7usZUdxHnOOz0ofoKPOJ/UoJEVKcIEVA=;
  b=dvHIUUlOBNo4GgWcl7FyIGPqQDJrgfqHS3tZxYLwuk4fcLq71PdgqETE
   lprAPuIWnTeZnAwfccI4Dcmb3v87Fq5LU1ueJ8cicRVsF2ru9GlRu5Psg
   d4WfppAtjGrKsDERCkm+07q3FNvPAqx1hjSoCxOt4+A3lJ3AYjl55Aa4h
   k=;
X-IronPort-AV: E=Sophos;i="6.13,317,1732579200"; 
   d="scan'208";a="176232161"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:07:44 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:25271]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.36.78:2525] with esmtp (Farcaster)
 id 9ef91057-2ea6-4f6a-bc79-4520280e04df; Wed, 26 Feb 2025 17:07:43 +0000 (UTC)
X-Farcaster-Flow-ID: 9ef91057-2ea6-4f6a-bc79-4520280e04df
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 26 Feb 2025 17:07:39 +0000
Received: from [192.168.22.24] (10.106.83.21) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 26 Feb 2025
 17:07:38 +0000
Message-ID: <946fc0f5-4306-4aa9-9b63-f7ccbaff8003@amazon.com>
Date: Wed, 26 Feb 2025 17:07:36 +0000
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
In-Reply-To: <Z75nRwSBxpeMwbsR@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D006EUC001.ant.amazon.com (10.252.51.203) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 26/02/2025 00:58, Sean Christopherson wrote:
> On Fri, Feb 21, 2025, Nikita Kalyazin wrote:
>> On 20/02/2025 18:49, Sean Christopherson wrote:
>>> On Thu, Feb 20, 2025, Nikita Kalyazin wrote:
>>>> On 19/02/2025 15:17, Sean Christopherson wrote:
>>>>> On Wed, Feb 12, 2025, Nikita Kalyazin wrote:
>>>>> The conundrum with userspace async #PF is that if userspace is given only a single
>>>>> bit per gfn to force an exit, then KVM won't be able to differentiate between
>>>>> "faults" that will be handled synchronously by the vCPU task, and faults that
>>>>> usersepace will hand off to an I/O task.  If the fault is handled synchronously,
>>>>> KVM will needlessly inject a not-present #PF and a present IRQ.
>>>>
>>>> Right, but from the guest's point of view, async PF means "it will probably
>>>> take a while for the host to get the page, so I may consider doing something
>>>> else in the meantime (ie schedule another process if available)".
>>>
>>> Except in this case, the guest never gets a chance to run, i.e. it can't do
>>> something else.  From the guest point of view, if KVM doesn't inject what is
>>> effectively a spurious async #PF, the VM-Exiting instruction simply took a (really)
>>> long time to execute.
>>
>> Sorry, I didn't get that.  If userspace learns from the
>> kvm_run::memory_fault::flags that the exit is due to an async PF, it should
>> call kvm run immediately, inject the not-present PF and allow the guest to
>> reschedule.  What do you mean by "the guest never gets a chance to run"?
> 
> What I'm saying is that, as proposed, the API doesn't precisely tell userspace
> an exit happened due to an "async #PF".  KVM has absolutely zero clue as to
> whether or not userspace is going to do an async #PF, or if userspace wants to
> intercept the fault for some entirely different purpose.

Userspace is supposed to know whether the PF is async from the dedicated 
flag added in the memory_fault structure: 
KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER.  It will be set when KVM managed to 
inject page-not-present.  Are you saying it isn't sufficient?

@@ -4396,6 +4412,35 @@ static int __kvm_faultin_pfn(struct kvm_vcpu 
*vcpu, struct kvm_page_fault *fault
  {
  	bool async;

+	/* Pre-check for userfault and bail out early. */
+	if (gfn_has_userfault(fault->slot->kvm, fault->gfn)) {
+		bool report_async = false;
+		u32 token = 0;
+
+		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+			!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
+			trace_kvm_try_async_get_page(fault->addr, fault->gfn, 1);
+			if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
+				trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn, 1);
+				kvm_make_request(KVM_REQ_APF_HALT, vcpu);
+				return RET_PF_RETRY;
+			} else if (kvm_can_deliver_async_pf(vcpu) &&
+				kvm_arch_setup_async_pf_user(vcpu, fault, &token)) {
+				report_async = true;
+			}
+		}
+
+		fault->pfn = KVM_PFN_ERR_USERFAULT;
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+
+		if (report_async) {
+			vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_ASYNC_PF_USER;
+			vcpu->run->memory_fault.async_pf_user_token = token;
+		}
+
+		return -EFAULT;
+	}
+

>>>> If we are exiting to userspace, it isn't going to be quick anyway, so we can
>>>> consider all such faults "long" and warranting the execution of the async PF
>>>> protocol.  So always injecting a not-present #PF and page ready IRQ doesn't
>>>> look too wrong in that case.
>>>
>>> There is no "wrong", it's simply wasteful.  The fact that the userspace exit is
>>> "long" is completely irrelevant.  Decompressing zswap is also slow, but it is
>>> done on the current CPU, i.e. is not background I/O, and so doesn't trigger async
>>> #PFs.
>>>
>>> In the guest, if host userspace resolves the fault before redoing KVM_RUN, the
>>> vCPU will get two events back-to-back: an async #PF, and an IRQ signalling completion
>>> of that #PF.
>>
>> Is this practically likely?
> 
> Yes, I think's it's quite possible.
> 
>> At least in our scenario (Firecracker snapshot restore) and probably in live
>> migration postcopy, if a vCPU hits a fault, it's probably because the content
>> of the page is somewhere remote (eg on the source machine or wherever the
>> snapshot data is stored) and isn't going to be available quickly.
> 
> Unless the remote page was already requested, e.g. by a different vCPU, or by a
> prefetching algorithim.
> 
>> Conversely, if the page content is available, it must have already been
>> prepopulated into guest memory pagecache, the bit in the bitmap is cleared
>> and no exit to userspace occurs.
> 
> But that doesn't happen instantaneously.  Even if the VMM somehow atomically
> receives the page and marks it present, it's still possible for marking the page
> present to race with KVM checking the bitmap.

That looks like a generic problem of the VM-exit fault handling.  Eg 
when one vCPU exits, userspace handles the fault and races setting the 
bitmap with another vCPU that is about to fault the same page, which may 
cause a spurious exit.

On the other hand, is it malignant?  The only downside is additional 
overhead of the async PF protocol, but if the race occurs infrequently, 
it shouldn't be a problem.

>>>>>> What advantage can you see in it over exiting to userspace (which already exists
>>>>>> in James's series)?
>>>>>
>>>>> It doesn't exit to userspace :-)
>>>>>
>>>>> If userspace simply wakes a different task in response to the exit, then KVM
>>>>> should be able to wake said task, e.g. by signalling an eventfd, and resume the
>>>>> guest much faster than if the vCPU task needs to roundtrip to userspace.  Whether
>>>>> or not such an optimization is worth the complexity is an entirely different
>>>>> question though.
>>>>
>>>> This reminds me of the discussion about VMA-less UFFD that was coming up
>>>> several times, such as [1], but AFAIK hasn't materialised into something
>>>> actionable.  I may be wrong, but James was looking into that and couldn't
>>>> figure out a way to scale it sufficiently for his use case and had to stick
>>>> with the VM-exit-based approach.  Can you see a world where VM-exit
>>>> userfaults coexist with no-VM-exit way of handling async PFs?
>>>
>>> The issue with UFFD is that it's difficult to provide a generic "point of contact",
>>> whereas with KVM userfault, signalling can be tied to the vCPU, and KVM can provide
>>> per-vCPU buffers/structures to aid communication.
>>>
>>> That said, supporting "exitless" KVM userfault would most definitely be premature
>>> optimization without strong evidence it would benefit a real world use case.
>>
>> Does that mean that the "exitless" solution for async PF is a long-term one
>> (if required), while the short-term would still be "exitful" (if we find a
>> way to do it sensibly)?
> 
> My question on exitless support was purely exploratory, just ignore it for now.


