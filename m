Return-Path: <kvm+bounces-32193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 905979D410C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 497A51F21A44
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469A61A9B57;
	Wed, 20 Nov 2024 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="imE9zBIP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CE614831E;
	Wed, 20 Nov 2024 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732123306; cv=none; b=PTL2m9+RIb6je55SDrUwKAX5aVexXl8GWXDY2qgMJ62Pc36uF05sxx6v8YgatFYQHNa+pB/iT6vf7ZHSPGNgcw8+yHZvVbqiVLxAm1HkI/Aqtk8gDA5Pk0H8Fut7LaWTCiokDM2MsrIzrdXfoiXRE+yCKqgc1zoJciT7tnUo8kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732123306; c=relaxed/simple;
	bh=NTciS5uR2bAcpu7nQc7zBidMJaiWZix4ilhuKQ1/pP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Jfd0kQU14X0eN/dKkGZatSHuHQeFYU+G+XdtUiOjjY+w7DbpCeWLAOU5U2EvS8QJ6rJhwoYfrVOy+S9S33O3uj1vuR0oXPJUzykGTn2N0J3/L0xTWY4suExzIxkSnsdxlygT4Hne0/hwFjd0xA3drsvmCZAYyTJcKDl2upjVeD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=imE9zBIP; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732123304; x=1763659304;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=3/fY0iM7juE2IxcKaSuL8G4jyBXYD27Dqt66/gwlyWk=;
  b=imE9zBIPFC/1fqFeuRonDRUTShDe5OvvLrzOG2VDEZ3qaqK9vM1J9Z3k
   p7DQqDwkUgUaFKoil60ELSxIs0MM4hkyWFBsWRveSqNp/tF+kMODMU4Qq
   CInbnE9fHmA/p8Vz828xvcJf/7uPJ21al5ISi5kadkTmasxRSymO0qvEs
   o=;
X-IronPort-AV: E=Sophos;i="6.12,170,1728950400"; 
   d="scan'208";a="696763459"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 17:21:39 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:22431]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.34.163:2525] with esmtp (Farcaster)
 id fa3a87a2-973e-4cfe-b2e3-5253ed2bf86d; Wed, 20 Nov 2024 17:21:38 +0000 (UTC)
X-Farcaster-Flow-ID: fa3a87a2-973e-4cfe-b2e3-5253ed2bf86d
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 20 Nov 2024 17:21:38 +0000
Received: from [192.168.4.239] (10.106.82.23) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 20 Nov 2024
 17:21:37 +0000
Message-ID: <03a12598-74aa-4202-a79a-668b45dbcc47@amazon.com>
Date: Wed, 20 Nov 2024 17:21:36 +0000
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
In-Reply-To: <f55d56d7-0ab9-495f-96bf-9bf642a9762d@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D005EUB002.ant.amazon.com (10.252.51.103) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 20/11/2024 16:44, David Hildenbrand wrote:
>> If the problem is the "pagecache" overhead, then yes, it will be a
>> harder nut to crack. But maybe there are some low-hanging fruits to
>> optimize? Finding the main cause for the added overhead would be
>> interesting.

Agreed, knowing the exact root cause would be really nice.

> Can you compare uffdio_copy() when using anonymous memory vs. shmem?
> That's likely the best we could currently achieve with guest_memfd.

Yeah, I was doing that too. It was about ~28% slower in my setup, while 
with guest_memfd it was ~34% slower.  The variance of the data was quite 
high so the difference may well be just noise.  In other words, I'd be 
much happier if we could bring guest_memfd (or even shmem) performance 
closer to the anon/private than if we just equalised guest_memfd with 
shmem (which are probably already pretty close).

> There is the tools/testing/selftests/mm/uffd-stress benchmark, not sure
> if that is of any help; it SEGFAULTS for me right now with a (likely)
> division by 0.

Thanks for the pointer, will take a look!

> Cheers,
> 
> David / dhildenb
> 


