Return-Path: <kvm+bounces-32279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E819D50E5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 17:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 214E9B23C46
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 16:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A21F1A2C19;
	Thu, 21 Nov 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Wfo0huLF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A337874C08;
	Thu, 21 Nov 2024 16:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732207627; cv=none; b=olrh3mApSuZRGl/lM1pY54x0eNjpKxsA6XwwhvBSyy0yL8NfS8S8AKXSqlAOecK9ltldnD83rOIjmB+xQDILTHboacse39VTmt6b1J5IsZoZ+7Ek0bsvjUJnEvpknmQHyJD6ZV0Bfv0tqhEVEzjliWUa2AhVzHfYhhgY8Wjy+YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732207627; c=relaxed/simple;
	bh=sCB9dkVcUaWIcMEgrF4mHxRVyYpDcDGowhkhLz/S/mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=m3p/lEtBVJzaJD0eOtq1ylnb2kS/ivw1I8S4M/JVhhg3EIAmaY7ZFvBdzsmq72Q4x2YNLw0lqhE+gHkgPHX2dhFGQ/XUG9Bs68s+V1dE8P5q6bVFWDWYpa3sfJ2HpgbHyf9QHeQJRquqXdWA1SKK/xtUovkHdIPcCuSe0Jji1fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Wfo0huLF; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732207626; x=1763743626;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=3rYcatr6xn14OakYphLU6gjqCUo8BfUaPtrhEVfRA6s=;
  b=Wfo0huLFBzg6G9wcgDdl5WeQ5/i7GGsDpsnlBmkXHrELNQ6Vhp0HfMk0
   2DeCtMbpze+SBJYRclu4xC4IiX1v0PcgTNDGQYxUMHLrP61qRZ7SRFvVK
   PLwjKYgjsm8gBAImml9xmW+tpT5S3Kn9YpG0LyTKIVCwrFVS75fBRW57n
   w=;
X-IronPort-AV: E=Sophos;i="6.12,173,1728950400"; 
   d="scan'208";a="354610907"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 16:47:03 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:42989]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.62:2525] with esmtp (Farcaster)
 id 84b57715-564e-4b10-a824-6b676d02ad0e; Thu, 21 Nov 2024 16:47:01 +0000 (UTC)
X-Farcaster-Flow-ID: 84b57715-564e-4b10-a824-6b676d02ad0e
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 21 Nov 2024 16:47:01 +0000
Received: from [192.168.3.109] (10.106.83.32) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Thu, 21 Nov 2024
 16:47:00 +0000
Message-ID: <8ac0e3e6-5af3-4841-b3ba-ab0458ab355b@amazon.com>
Date: Thu, 21 Nov 2024 16:46:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
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
In-Reply-To: <74cbda4a-7820-45a9-a1b2-139da9dae593@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D003EUB003.ant.amazon.com (10.252.51.36) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 20/11/2024 18:29, David Hildenbrand wrote:
 > Any clue how your new ioctl will interact with the WIP to have shared
 > memory as part of guest_memfd? For example, could it be reasonable to
 > "populate" the shared memory first (via VMA) and then convert that
 > "allocated+filled" memory to private?

Patrick and I synced internally on this.  What may actually work for 
guest_memfd population is the following.

Non-CoCo use case:
  - fallocate syscall to fill the page cache, no page content 
initialisation (like it is now)
  - pwrite syscall to initialise the content + mark up-to-date (mark 
prepared), no specific preparation logic is required

The pwrite will have "once" semantics until a subsequent 
fallocate(FALLOC_FL_PUNCH_HOLE), ie the next pwrite call will "see" the 
page is already prepared and return EIO/ENOSPC or something.

SEV-SNP use case (no changes):
  - fallocate as above
  - KVM_SEV_SNP_LAUNCH_UPDATE to initialise/prepare

We don't think fallocate/pwrite have dependencies on current->mm 
assumptions that Paolo mentioned in [1], so they should be safe to be 
called on guest_memfd from a non-VMM process.

[1]: 
https://lore.kernel.org/kvm/20241024095429.54052-1-kalyazin@amazon.com/T/#m57498f8e2fde577ad1da948ec74dd2225cd2056c

 > Makes sense. Best we can do is:
 >
 > anon: work only on page tables
 > shmem/guest_memfd: work only on pageacache
 >
 > So at least "only one treelike structure to update".

This seems to hold with the above reasoning.

 > --
> Cheers,
> 
> David / dhildenb 


