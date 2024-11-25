Return-Path: <kvm+bounces-32460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8BA9D89AF
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4997F164481
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632551B4126;
	Mon, 25 Nov 2024 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="JFw/6E+3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E129415;
	Mon, 25 Nov 2024 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732549819; cv=none; b=VBrNz8u44yosQK/70qnQ1y7F7g2QLU2c8o0qxpAXyGvsEkQCok1Bq+uHWlnwxnIh6C5pkpc9ksIS+H4QVCZk2SAYopNbreALKYhKUjsysrq5zxsO/q41/YZKZ+OB3qfhdIxnsjQLrft6uBWMh5PjppXNcVDyYRJVSXrZ3juD90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732549819; c=relaxed/simple;
	bh=RTrfYid/b24KKBOpAo7FxUgkZvgHSjtF2kSDoXzXJz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Mo7J6eK452ou5cWRcnyc55d3Gczy+YLEFLxahX+CwBkksS1FlLwWhTVvgSgfQ8RwbxTMecZTKI5dXAlrR+q1+63ju2FxC2ScdLHi7qy4okWPhWIsgAUWQ1STH/VnkheV7upaVHXDl+Q9xpgB3ay0ZKkqhvYzGmWVbgQwpYdHIL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=JFw/6E+3; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732549819; x=1764085819;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=sXgiGKvS1hQRKUZ0yjvRKDtBqyZi73E4t8r0EfZt0Gg=;
  b=JFw/6E+379hBdoY4Ev8/5Ad/C9wUTSYErfcMIQj0fblmkPrFfuIhuMTk
   wnr5RtInq3vL5Rb3QmA3SPau+HTizag77Q9SkPBsN/rvFgbTvgR1GGoe+
   +NVpUo2+w6xwvL6Drky8USHzsklooHAKLnqSmuKdho+FLpinYRl0SFNbU
   M=;
X-IronPort-AV: E=Sophos;i="6.12,183,1728950400"; 
   d="scan'208";a="778502928"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 15:50:11 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:51692]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.207:2525] with esmtp (Farcaster)
 id ae3596c7-1096-484a-ac2c-d15d58a165af; Mon, 25 Nov 2024 15:50:09 +0000 (UTC)
X-Farcaster-Flow-ID: ae3596c7-1096-484a-ac2c-d15d58a165af
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Mon, 25 Nov 2024 15:50:08 +0000
Received: from [192.168.8.103] (10.106.83.30) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Mon, 25 Nov 2024
 15:50:07 +0000
Message-ID: <b7d21cce-720f-4db3-bbb4-0be17e33cd09@amazon.com>
Date: Mon, 25 Nov 2024 15:50:05 +0000
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
In-Reply-To: <Zz-gmpMvNm_292BC@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D004EUA004.ant.amazon.com (10.252.50.183) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 21/11/2024 21:05, Sean Christopherson wrote:
> On Thu, Nov 21, 2024, Nikita Kalyazin wrote:
>> On 19/11/2024 13:24, Sean Christopherson wrote:
>>> None of this justifies breaking host-side, non-paravirt async page faults.  If a
>>> vCPU hits a missing page, KVM can schedule out the vCPU and let something else
>>> run on the pCPU, or enter idle and let the SMT sibling get more cycles, or maybe
>>> even enter a low enough sleep state to let other cores turbo a wee bit.
>>>
>>> I have no objection to disabling host async page faults, e.g. it's probably a net
>>> negative for 1:1 vCPU:pCPU pinned setups, but such disabling needs an opt-in from
>>> userspace.
>>
>> That's a good point, I didn't think about it.  The async work would still
>> need to execute somewhere in that case (or sleep in GUP until the page is
>> available).
> 
> The "async work" is often an I/O operation, e.g. to pull in the page from disk,
> or over the network from the source.  The *CPU* doesn't need to actively do
> anything for those operations.  The I/O is initiated, so the CPU can do something
> else, or go idle if there's no other work to be done.
> 
>> If processing the fault synchronously, the vCPU thread can also sleep in the
>> same way freeing the pCPU for something else,
> 
> If and only if the vCPU can handle a PV async #PF.  E.g. if the guest kernel flat
> out doesn't support PV async #PF, or the fault happened while the guest was in an
> incompatible mode, etc.
> 
> If KVM doesn't do async #PFs of any kind, the vCPU will spin on the fault until
> the I/O completes and the page is ready.

I ran a little experiment to see that by backing guest memory by a file 
on FUSE and delaying response to one of the read operations to emulate a 
delay in fault processing.

1. Original (the patch isn't applied)

vCPU thread (disk-sleeping):

[<0>] kvm_vcpu_block+0x62/0xe0
[<0>] kvm_arch_vcpu_ioctl_run+0x240/0x1e30
[<0>] kvm_vcpu_ioctl+0x2f1/0x860
[<0>] __x64_sys_ioctl+0x87/0xc0
[<0>] do_syscall_64+0x47/0x110
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Async task (disk-sleeping):

[<0>] folio_wait_bit_common+0x116/0x2e0
[<0>] filemap_fault+0xe5/0xcd0
[<0>] __do_fault+0x30/0xc0
[<0>] do_fault+0x9a/0x580
[<0>] __handle_mm_fault+0x684/0x8a0
[<0>] handle_mm_fault+0xc9/0x220
[<0>] __get_user_pages+0x248/0x12c0
[<0>] get_user_pages_remote+0xef/0x470
[<0>] async_pf_execute+0x99/0x1c0
[<0>] process_one_work+0x145/0x360
[<0>] worker_thread+0x294/0x3b0
[<0>] kthread+0xdb/0x110
[<0>] ret_from_fork+0x2d/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

2. With the patch applied (no async task)

vCPU thread (disk-sleeping):

[<0>] folio_wait_bit_common+0x116/0x2e0
[<0>] filemap_fault+0xe5/0xcd0
[<0>] __do_fault+0x30/0xc0
[<0>] do_fault+0x36f/0x580
[<0>] __handle_mm_fault+0x684/0x8a0
[<0>] handle_mm_fault+0xc9/0x220
[<0>] __get_user_pages+0x248/0x12c0
[<0>] get_user_pages_unlocked+0xf7/0x380
[<0>] hva_to_pfn+0x2a2/0x440
[<0>] __kvm_faultin_pfn+0x5e/0x90
[<0>] kvm_mmu_faultin_pfn+0x1ec/0x690
[<0>] kvm_tdp_page_fault+0xba/0x160
[<0>] kvm_mmu_do_page_fault+0x1cc/0x210
[<0>] kvm_mmu_page_fault+0x8e/0x600
[<0>] vmx_handle_exit+0x14c/0x6c0
[<0>] kvm_arch_vcpu_ioctl_run+0xeb1/0x1e30
[<0>] kvm_vcpu_ioctl+0x2f1/0x860
[<0>] __x64_sys_ioctl+0x87/0xc0
[<0>] do_syscall_64+0x47/0x110
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

In both cases the fault handling code is blocked and the pCPU is free 
for other tasks.  I can't see the vCPU spinning on the IO to get 
completed if the async task isn't created.  I tried that with and 
without async PF enabled by the guest (MSR_KVM_ASYNC_PF_EN).

What am I missing?

>> so the amount of work to be done looks equivalent (please correct me
>> otherwise).  What's the net gain of moving that to an async work in the host
>> async fault case? "while allowing interrupt delivery into the guest." -- is
>> this the main advantage?


