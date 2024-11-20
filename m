Return-Path: <kvm+bounces-32175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 245B69D401D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 608F5B28FE1
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5AE1537CB;
	Wed, 20 Nov 2024 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nKBXymSs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61A9145B10;
	Wed, 20 Nov 2024 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118317; cv=none; b=HGVO8ji/ukGl0ljtSJaMPkQj2u8eYYZ0UNYGjMefbu0q4cf86iQmNL0uyDYb0a/BLmy/N9TGjbrx8fPHIBAfwNxWXket8KQkeCS3w71pIfIZaz/eX2uUBTs3XhlkOk2TZDMz6/TSp51s5kVBkXiNfVHq/1uXsKc9XalSZ+eeus0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118317; c=relaxed/simple;
	bh=QUCP/F2MW152qu6dweDXIAy8zsQV0D5nzigkKZ7Shn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=q/hg0/O7S4EAyVt6OTEsTKuWX9C7WVOGB4l7SqgK68na+fHMYNM/UVcS8VWhWC0sunBAPGAh4uJcSCva0w1H27mUIqqDjtUZCIRoIKOsfwengnxusewqMf+eIAqEwRz3lWXFzlaSGRly6fiTa0E5xlNsBsa2eFCq+PPl0SSexVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=nKBXymSs; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732118316; x=1763654316;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=pSZsUFc2pO+H1LRn5VA2nkGQrkmW6bpxo1bRSlx8hok=;
  b=nKBXymSslzz7JdNVM3DEMOasxtjimeKlQDXacfEYu70zWB9myuJf8lsq
   l0qy6j5cEJPj3RU2H5oyAHrulQbRuEo2MTF5OxRLHqCR7FJSQf5SJA6ot
   +YOue2BYfwe3IftXPA6+hyz5b5av9o0Ib7Dozkbxor4S9Js4GZOBC5Rj3
   A=;
X-IronPort-AV: E=Sophos;i="6.12,170,1728950400"; 
   d="scan'208";a="354185361"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 15:58:34 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:53225]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.207:2525] with esmtp (Farcaster)
 id 5ec6092c-67cf-4bc6-a64f-e617283997e7; Wed, 20 Nov 2024 15:58:32 +0000 (UTC)
X-Farcaster-Flow-ID: 5ec6092c-67cf-4bc6-a64f-e617283997e7
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 20 Nov 2024 15:58:31 +0000
Received: from [192.168.4.239] (10.106.82.23) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 20 Nov 2024
 15:58:30 +0000
Message-ID: <55b6b3ec-eaa8-494b-9bc7-741fe0c3bc63@amazon.com>
Date: Wed, 20 Nov 2024 15:58:29 +0000
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
In-Reply-To: <efe6acf5-8e08-46cd-88e4-ad85d3af2688@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D014EUA003.ant.amazon.com (10.252.50.119) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 20/11/2024 15:13, David Hildenbrand wrote:
 > Hi!

Hi! :)

 >> Results:
 >>    - MAP_PRIVATE: 968 ms
 >>    - MAP_SHARED: 1646 ms
 >
 > At least here it is expected to some degree: as soon as the page cache
 > is involved map/unmap gets slower, because we are effectively
 > maintaining two datastructures (page tables + page cache) instead of
 > only a single one (page cache)
 >
 > Can you make sure that THP/large folios don't interfere in your
 > experiments (e.g., madvise(MADV_NOHUGEPAGE))?

I was using transparent_hugepage=never command line argument in my testing.

$ cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]

Is that sufficient to exclude the THP/large folio factor?

 >> While this logic is intuitive, its performance effect is more
 >> significant that I would expect.
 >
 > Yes. How much of the performance difference would remain if you hack out
 > the atomic op just to play with it? I suspect there will still be some
 > difference.

I have tried that, but could not see any noticeable difference in the 
overall results.

It looks like a big portion of the bottleneck has moved from 
shmem_get_folio_gfp/folio_mark_uptodate to 
finish_fault/__pte_offset_map_lock somehow.  I have no good explanation 
for why:

Orig:
                   - 69.62% do_fault
                      + 44.61% __do_fault
                      + 20.26% filemap_map_pages
                      + 3.48% finish_fault
Hacked:
                   - 67.39% do_fault
                      + 32.45% __do_fault
                      + 21.87% filemap_map_pages
                      + 11.97% finish_fault

Orig:
                      - 3.48% finish_fault
                         - 1.28% set_pte_range
                              0.96% folio_add_file_rmap_ptes
                         - 0.91% __pte_offset_map_lock
                              0.54% _raw_spin_lock
Hacked:
                      - 11.97% finish_fault
                         - 8.59% __pte_offset_map_lock
                            - 6.27% _raw_spin_lock
                                 preempt_count_add
                              1.00% __pte_offset_map
                         - 1.28% set_pte_range
                            - folio_add_file_rmap_ptes
                                 __mod_node_page_state

 > Note that we might improve allocation times with guest_memfd when
 > allocating larger folios.

I suppose it may not always be an option depending on requirements to 
consistency of the allocation latency.  Eg if a large folio isn't 
available at the time, the performance would degrade to the base case 
(please correct me if I'm missing something).

> Heh, now I spot that your comment was as reply to a series.

Yeah, sorry if it wasn't obvious.

> If your ioctl is supposed to to more than "allocating memory" like
> MAP_POPULATE/MADV_POPULATE+* ... then POPULATE is a suboptimal choice.
> Because for allocating memory, we would want to use fallocate() instead.
> I assume you want to "allocate+copy"?

Yes, the ultimate use case is "allocate+copy".

> I'll note that, as we're moving into the direction of moving
> guest_memfd.c into mm/guestmem.c, we'll likely want to avoid "KVM_*"
> ioctls, and think about something generic.

Good point, thanks.  Are we at the stage where some concrete API has 
been proposed yet? I might have missed that.

> Any clue how your new ioctl will interact with the WIP to have shared
> memory as part of guest_memfd? For example, could it be reasonable to
> "populate" the shared memory first (via VMA) and then convert that
> "allocated+filled" memory to private?

No, I can't immediately see why it shouldn't work.  My main concern 
would probably still be about the latency of the population stage as I 
can't see why it would improve compared to what we have now, because my 
feeling is this is linked with the sharedness property of guest_memfd.

> Cheers,
> 
> David / dhildenb



