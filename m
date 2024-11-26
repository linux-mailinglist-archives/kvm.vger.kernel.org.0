Return-Path: <kvm+bounces-32531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604839D9B00
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 17:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF79D283302
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 16:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569D01D7986;
	Tue, 26 Nov 2024 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="HS/uTytg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A8E3EA69;
	Tue, 26 Nov 2024 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732637102; cv=none; b=r7Jw0o1/HCVNR6mOxj9dCAn8fPvqmj5kneZy+VmDuPohj4Gk+7HEz7i9Huh3Vr6yaj0j/upP5brkXt5wuS9usHSXT5QozlhOPxJo0L/O8QnF15Qb1AeXd/EtT6cY68b8QfWMFnqwnbsA1JIg/EqddL4Dm3UORZRaiMbtx9LYH3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732637102; c=relaxed/simple;
	bh=hK3Lvut46ClYBRk6BhyY0n+LHeDgPszEzIEK1PLKjzw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=oLJBZw5vMaggidtPJxLVDQdAcyy/qkCNhS7KlEhYaqi7i+pyfNIeXAV1uPhtwSKIabXE1f3F2eIGKuLA53Clveq/ZxGJExOIwogUmjN4xUlFnGrim7uq05Gt9C0oGGAglvYM89n//L1bzLbwn6+/4YnRQjV8FhOAKLdZNYR6bsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=HS/uTytg; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732637101; x=1764173101;
  h=message-id:date:mime-version:reply-to:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=HRWp5MKfE6uueBU5wQW7RW/Kjbh6R68ifML8DEFIQdE=;
  b=HS/uTytgsS8Pw2EjDxMN2CrtbZlkMZXid6pNe0bn2P2aHRaTbxkzb6lG
   5aLKOrvzGkKo0gjE1RBIFoGaFwUFt7IW3VtiucIuOgx+I+TAjwNaMwttX
   wXGmy4Ptc/M8ne9PwdXrNTyqtL6yQv2nuqF1FLlBeDxJzqmGifji488CM
   w=;
X-IronPort-AV: E=Sophos;i="6.12,186,1728950400"; 
   d="scan'208";a="250358078"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 16:04:57 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:39943]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.13:2525] with esmtp (Farcaster)
 id 704d7f83-a641-4c17-9c05-2a8b2b7eb302; Tue, 26 Nov 2024 16:04:54 +0000 (UTC)
X-Farcaster-Flow-ID: 704d7f83-a641-4c17-9c05-2a8b2b7eb302
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 26 Nov 2024 16:04:54 +0000
Received: from [192.168.5.6] (10.106.82.29) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Tue, 26 Nov 2024
 16:04:53 +0000
Message-ID: <b8589fbd-733d-42ae-a6a7-8683c77a4817@amazon.com>
Date: Tue, 26 Nov 2024 16:04:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
From: Nikita Kalyazin <kalyazin@amazon.com>
To: David Hildenbrand <david@redhat.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>, "Sean
 Christopherson" <seanjc@google.com>, <linux-mm@kvack.org>
References: <20241024095429.54052-1-kalyazin@amazon.com>
 <08aeaf6e-dc89-413a-86a6-b9772c9b2faf@amazon.com>
 <01b0a528-bec0-41d7-80f6-8afe213bd56b@redhat.com>
 <efe6acf5-8e08-46cd-88e4-ad85d3af2688@redhat.com>
 <55b6b3ec-eaa8-494b-9bc7-741fe0c3bc63@amazon.com>
 <9286da7a-9923-4a3b-a769-590e8824fa10@redhat.com>
 <f55d56d7-0ab9-495f-96bf-9bf642a9762d@redhat.com>
 <03a12598-74aa-4202-a79a-668b45dbcc47@amazon.com>
 <74cbda4a-7820-45a9-a1b2-139da9dae593@redhat.com>
 <8ac0e3e6-5af3-4841-b3ba-ab0458ab355b@amazon.com>
Content-Language: en-US
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <8ac0e3e6-5af3-4841-b3ba-ab0458ab355b@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D003EUB002.ant.amazon.com (10.252.51.90) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 21/11/2024 16:46, Nikita Kalyazin wrote:
> 
> 
> On 20/11/2024 18:29, David Hildenbrand wrote:
>  > Any clue how your new ioctl will interact with the WIP to have shared
>  > memory as part of guest_memfd? For example, could it be reasonable to
>  > "populate" the shared memory first (via VMA) and then convert that
>  > "allocated+filled" memory to private?
> 
> Patrick and I synced internally on this.  What may actually work for 
> guest_memfd population is the following.
> 
> Non-CoCo use case:
>   - fallocate syscall to fill the page cache, no page content 
> initialisation (like it is now)
>   - pwrite syscall to initialise the content + mark up-to-date (mark 
> prepared), no specific preparation logic is required
> 
> The pwrite will have "once" semantics until a subsequent 
> fallocate(FALLOC_FL_PUNCH_HOLE), ie the next pwrite call will "see" the 
> page is already prepared and return EIO/ENOSPC or something.

I prototyped that to see if it was possible (and it was).  Actually the 
write syscall can also do the allocation part, so no prior fallocate 
would be required.  The only thing is there is a cap on how much IO can 
be done in a single call (MAX_RW_COUNT) [1], but it doesn't look like a 
significant problem.  Does it sound like an acceptable solution?

[1]: https://elixir.bootlin.com/linux/v6.12.1/source/fs/read_write.c#L507

> 
> SEV-SNP use case (no changes):
>   - fallocate as above
>   - KVM_SEV_SNP_LAUNCH_UPDATE to initialise/prepare
> 
> We don't think fallocate/pwrite have dependencies on current->mm 
> assumptions that Paolo mentioned in [1], so they should be safe to be 
> called on guest_memfd from a non-VMM process.
> 
> [1]: https://lore.kernel.org/kvm/20241024095429.54052-1- 
> kalyazin@amazon.com/T/#m57498f8e2fde577ad1da948ec74dd2225cd2056c
> 
>  > Makes sense. Best we can do is:
>  >
>  > anon: work only on page tables
>  > shmem/guest_memfd: work only on pageacache
>  >
>  > So at least "only one treelike structure to update".
> 
> This seems to hold with the above reasoning.
> 
>  > --
>> Cheers,
>>
>> David / dhildenb 
> 


