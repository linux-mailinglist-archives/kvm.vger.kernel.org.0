Return-Path: <kvm+bounces-22518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F12A293FC3C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 19:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF832835A8
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8015187856;
	Mon, 29 Jul 2024 17:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Xos26ffX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DE3187355;
	Mon, 29 Jul 2024 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722273448; cv=none; b=HxcDh9fQg2UvpKgSVjrnfKWRXVGn2oLFV1i+aifZxQKpgEm+C1GRkEPXq4JwM1sH/5lISTu7pWEp5ZlLortDTgrqAntV6uRet1AkyZky4Bp5KuC9NOTSEdubfx241Fam6EybtdMNeRVvjYFTCBP4Ylt0Od283ZUCzv5oDbTvkWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722273448; c=relaxed/simple;
	bh=DBy9rdIyzDefoDApf3C0asqD6WUabDYzQ+Tpqh/Nqy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Qf6khP0SeaZhzzF6xZeSbNzqIcHg2Nl2SqwGYfP0wfcBMfgWjTQVcjBMDWA4U46LLahhOgwZfmBSebtDF0X24NP75Trf8V+KWhBZOgDh0UpViDTjdbmkUEHAJoKzs7Pllz3kAvJkt29sxynLKroqTPfHz6etXeXai1A3wtgNu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Xos26ffX; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1722273447; x=1753809447;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=+56SM1DfpyNENiuPZBBa2EGw4OmoljBk1uJ/Yf6TTK4=;
  b=Xos26ffXQJjVpbeySzag/4kFxkiykGwamdt3nIm7Th9UNAvVu6FvAxAn
   z/TAoJX6mC6kOGjctoH4FBCKDlcA2yrkdtu8fb7XePZZW0dxoV3Wct8xu
   +z0Tz58HHsbrdXgdyporD2znSfQcyz5h9nhItItHVif34xmmIQ6AynL+k
   o=;
X-IronPort-AV: E=Sophos;i="6.09,246,1716249600"; 
   d="scan'208";a="418030448"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 17:17:23 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:28574]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.6.51:2525] with esmtp (Farcaster)
 id f6cd28f4-d57e-459f-b07b-1bbc69ce8af3; Mon, 29 Jul 2024 17:17:21 +0000 (UTC)
X-Farcaster-Flow-ID: f6cd28f4-d57e-459f-b07b-1bbc69ce8af3
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 29 Jul 2024 17:17:21 +0000
Received: from [192.168.9.202] (10.106.82.26) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Mon, 29 Jul 2024
 17:17:20 +0000
Message-ID: <4cd16922-2373-4894-b888-83a6bb3978e7@amazon.com>
Date: Mon, 29 Jul 2024 18:17:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults,
 KVM_READ_USERFAULT
To: James Houghton <jthoughton@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, Axel Rasmussen
	<axelrasmussen@google.com>, David Matlack <dmatlack@google.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <roypat@amazon.co.uk>, Paolo Bonzini
	<pbonzini@redhat.com>, <kalyazin@amazon.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-15-jthoughton@google.com>
 <4e5c2904-f628-4391-853e-37b7f0e132e8@amazon.com>
 <CADrL8HUn-A+k-+A8WvreKtvxW-b9zZvgAGMkkaR7gCLsPr3XPg@mail.gmail.com>
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
In-Reply-To: <CADrL8HUn-A+k-+A8WvreKtvxW-b9zZvgAGMkkaR7gCLsPr3XPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D006EUA004.ant.amazon.com (10.252.50.166) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 26/07/2024 19:00, James Houghton wrote:
> If it would be useful, we could absolutely have a flag to have all
> faults go through the asynchronous mechanism. :) It's meant to just be
> an optimization. For me, it is a necessary optimization.
> 
> Userfaultfd doesn't scale particularly well: we have to grab two locks
> to work with the wait_queues. You could create several userfaultfds,
> but the underlying issue is still there. KVM Userfault, if it uses a
> wait_queue for the async fault mechanism, will have the same
> bottleneck. Anish and I worked on making userfaults more scalable for
> KVM[1], and we ended up with a scheme very similar to what we have in
> this KVM Userfault series.
Yes, I see your motivation. Does this approach support async pagefaults 
[1]? Ie would all the guest processes on the vCPU need to stall until a 
fault is resolved or is there a way to let the vCPU run and only block 
the faulted process?

A more general question is, it looks like Userfaultfd's main purpose was 
to support the postcopy use case [2], yet it fails to do that 
efficiently for large VMs. Would it be ideologically better to try to 
improve Userfaultfd's performance (similar to how it was attempted in 
[3]) or is that something you have already looked into and reached a 
dead end as a part of [4]?

[1] https://lore.kernel.org/lkml/4AEFB823.4040607@redhat.com/T/
[2] https://lwn.net/Articles/636226/
[3] https://lore.kernel.org/lkml/20230905214235.320571-1-peterx@redhat.com/
[4] 
https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/

> My use case already requires using a reasonably complex API for
> interacting with a separate userland process for fetching memory, and
> it's really fast. I've never tried to hook userfaultfd into this other
> process, but I'm quite certain that [1] + this process's interface
> scale better than userfaultfd does. Perhaps userfaultfd, for
> not-so-scaled-up cases, could be *slightly* faster, but I mostly care
> about what happens when we scale to hundreds of vCPUs.
> 
> [1]: https://lore.kernel.org/kvm/20240215235405.368539-1-amoorthy@google.com/
Do I understand it right that in your setup, when an EPT violation occurs,
  - VMM shares the fault information with the other process via a 
userspace protocol
  - the process fetches the memory, installs it (?) and notifies VMM
  - VMM calls KVM run to resume execution
?
Would you be ok to share an outline of the API you mentioned?

>> How do you envision resolving faults in userspace? Copying the page in
>> (provided that userspace mapping of guest_memfd is supported [3]) and
>> clearing the KVM_MEMORY_ATTRIBUTE_USERFAULT alone do not look
>> sufficient to resolve the fault because an attempt to copy the page
>> directly in userspace will trigger a fault on its own
> 
> This is not true for KVM Userfault, at least for right now. Userspace
> accesses to guest memory will not trigger KVM Userfaults. (I know this
> name is terrible -- regular old userfaultfd() userfaults will indeed
> get triggered, provided you've set things up properly.)
> 
> KVM Userfault is merely meant to catch KVM's own accesses to guest
> memory (including vCPU accesses). For non-guest_memfd memslots,
> userspace can totally just write through the VMA it has made (KVM
> Userfault *cannot*, by virtue of being completely divorced from mm,
> intercept this access). For guest_memfd, userspace could write to
> guest memory through a VMA if that's where guest_memfd is headed, but
> perhaps it will rely on exact details of how userspace is meant to
> populate guest_memfd memory.
True, it isn't the case right now. I think I fast-forwarded to a state 
where notifications about VMM-triggered faults to the guest_memfd are 
also sent asynchronously.

> In case it's interesting or useful at all, we actually use
> UFFDIO_CONTINUE for our live migration use case. We mmap() memory
> twice -- one of them we register with userfaultfd and also give to
> KVM. The other one we use to install memory -- our non-faulting view
> of guest memory!
That is interesting. You're replacing UFFDIO_COPY (vma1) with a memcpy 
(vma2) + UFFDIO_CONTINUE (vma1), IIUC. Are both mappings created by the 
same process? What benefits does it bring?

