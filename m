Return-Path: <kvm+bounces-17307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9048C3EF1
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 12:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 642752863D9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 10:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048B155C3B;
	Mon, 13 May 2024 10:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="UWPDm2J8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC634437C
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715596317; cv=none; b=q8TC5Lg+kM0V610jOF2pBDjfxU/J3HzsT9kIAjF/dowGWUq0AOKDdCgqVJx5cKYj7jc7nJiyQgXipFo2jDeDF+ahCuWthktghtfzN+fo3rrdcDEnkJOvjT9tlx8Hd1BZ2dcTow7Ugp5HGg6ySXrLqlqC7yVTMzk1Q1BH/IwjHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715596317; c=relaxed/simple;
	bh=1HQ1jEAecPacSgBBQD1tLI2+0BJrUkL+F2+Cykm1l2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NDfHObSqGPjOBAlAOVXHft/ooonsZbSQbCU2dNdP4rXPi1L3XMdKAeAIb6S7rxd6jzrxoKNzngbQ2FJ3XoFlrwsRfuRm34jEQq169qvZXJud83ZdZSd9RmDw08vSnu977CTQ4B8qtq81WG39LM9ogwZxiPFmg7/CD9XP2qtb4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=UWPDm2J8; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1715596316; x=1747132316;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uQIw9i/g+I3Ll0Kcnj1kLLWW5A3sw6sKhdQsGDX0E88=;
  b=UWPDm2J8aem1DBAV7x/wG1VjsOdhoatqePxOwVWZEhVrvr4wsQkaxeT7
   69j/mYsZVlmQLZe2tBeCCbT187a5XsEmZZwzJ2dY+adm2FxK9ZrAlYmDx
   KEGddbJK+tsNP/MQbbviLMi+J0yOQqdoYCBW1W2N82dufeHYKdLQ9zh7M
   Q=;
X-IronPort-AV: E=Sophos;i="6.08,158,1712620800"; 
   d="scan'208";a="653737330"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 10:31:53 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.44.209:28793]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.82.155:2525] with esmtp (Farcaster)
 id 24678bc8-ee46-4086-b40e-d21a7295c070; Mon, 13 May 2024 10:31:51 +0000 (UTC)
X-Farcaster-Flow-ID: 24678bc8-ee46-4086-b40e-d21a7295c070
Received: from EX19D008UEA003.ant.amazon.com (10.252.134.116) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 13 May 2024 10:31:51 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D008UEA003.ant.amazon.com (10.252.134.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 13 May 2024 10:31:51 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.252.135.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28 via Frontend
 Transport; Mon, 13 May 2024 10:31:49 +0000
Message-ID: <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk>
Date: Mon, 13 May 2024 11:31:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: Mike Rapoport <rppt@kernel.org>, Sean Christopherson <seanjc@google.com>
CC: James Gowans <jgowans@amazon.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, Derek Manwaring <derekmn@amazon.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, David Woodhouse
	<dwmw@amazon.co.uk>, Nikita Kalyazin <kalyazin@amazon.co.uk>,
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "mst@redhat.com" <mst@redhat.com>,
	"somlo@cmu.edu" <somlo@cmu.edu>, Alexander Graf <graf@amazon.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com> <ZexEkGkNe_7UY7w6@kernel.org>
Content-Language: en-US
From: Patrick Roy <roypat@amazon.co.uk>
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <ZexEkGkNe_7UY7w6@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi all,

On 3/9/24 11:14, Mike Rapoport wrote:

>>> >>> With this in mind, what’s the best way to solve getting guest RAM out of
>>> >>> the direct map? Is memfd_secret integration with KVM the way to go, or
>>> >>> should we build a solution on top of guest_memfd, for example via some
>>> >>> flag that causes it to leave memory in the host userspace’s page tables,
>>> >>> but removes it from the direct map?
>> >> memfd_secret obviously gets you a PoC much faster, but in the long term I'm quite
>> >> sure you'll be fighting memfd_secret all the way.  E.g. it's not dumpable, it
>> >> deliberately allocates at 4KiB granularity (though I suspect the bug you found
>> >> means that it can be inadvertantly mapped with 2MiB hugepages), it has no line
>> >> of sight to taking userspace out of the equation, etc.
>> >>
>> >> With guest_memfd on the other hand, everyone contributing to and maintaining it
>> >> has goals that are *very* closely aligned with what you want to do.
> > I agree with Sean, guest_memfd seems a better interface to use. It's
> > integrated by design with KVM and removing guest memory from the direct map
> > looks like a natural enhancement to guest_memfd.
> >
> > Unless I'm missing something, for fast-and-dirty POC it'll be a oneliner
> > that adds set_memory_np() to kvm_gmem_get_folio() and then figuring out
> > what to do with virtio :)

We’ve been playing around with extending guest_memfd to remove guest memory
from the direct map. Removal from direct map aspect is indeed fairly
straight-forward; since we cannot map guest_memfd, we don’t need to worry about
folios without direct map entries getting to places where they will cause
kernel panics.

However, we ran into problems running non-CoCo VMs with guest_memfd for guest
memory, independent of direct map entries being available or not. There’s a
handful of places where a traditional KVM / Userspace setup currently touches
guest memory:

* Loading the Guest Kernel into guest-owned memory
* Instruction fetch from arbitrary guest addresses and guest page table walks  
  for MMIO emulation (for example for IOAPIC accesses)
* kvm-clock
* I/O devices

With guest_memfd, if the guest is running from guest-private memory, these need
to be rethought, since now the memory is unavailable to userspace, and KVM is
not enlightened about guest_memfd’s existance everywhere (when I was
experimenting with this, it generally read garbage data from the shared VMA,
but I think I’ve since seen some patches floating around that would make it
return -EFAULT instead).

CoCo VMs have various methods for working around these: You load a guest kernel
using some “populate on first access” mechanism [1], kvm-clock and I/O is
solved by having the guest mark the relevant address ranges as “shared” ahead
of time [2] and bounce buffering via swiotlb [4], and Intel TDX solves the
instruction emulation problem for MMIO by injecting a #VE and having the guest
do the emulation itself [3].

For non-CoCo VMs, where memory is not encrypted, and the threat model assumes a
trusted host userspace, we would like to avoid changing the VM model so
completely. If we adopt CoCo’s approaches where KVM / Userspace touches guest
memory we would get all the complexity, yet none of the encryption.
Particularly the complexity on the MMIO path seems nasty, but x86 does not
pre-decode instructions on MMIO exits (which are just EPT_VIOLATIONs) like it
does for PIO exits, so I also don’t really see a way around it in the
guest_memfd model.

We’ve played around a lot with allowing userspace mappings of guest_memfd, and
then having KVM internally access guest_memfd via userspace page tables (and
came up with multiple hacky ways to boot simple Linux initrds from
guest_memfd), but this is fairly awkward for two reasons:

1. Now lots of codepaths in KVM end up accessing guest_memfd, which from my
understanding goes against the guest_memfd goal of making machine checks
because of incorrect accesses to TDX memory impossible, and
2. We need to somehow get a userspace mapping of guest_memfd into KVM (a hacky
way I could make this work was setting up kvm_user_memory_region2 with
userspace_addr set to a mmap of guest_memory, which actually "works" for
everything but kvm-clock, but I also realized later that this is just
memfd_secret with extra steps).

We also played around with having KVM access guest_memfd through the direct map
(by temporarily reinserting pages into it when needed), but this again means
lots of KVM code learns about how to access guest RAM via guest_memfd.

There are a few other features we need to support, such as serving page faults
using UFFD, which we are not too sure how to realize with guest_memfd since
UFFD is VMA based (although to me some sort of “UFFD-for-FD” sounds like
something that’d be useful even outside of our guest_memfd usecase).

With these challenges in mind, some variant of memfd_secret continues to look
attractive for the non-CoCo case. Perhaps a variant that supports in-kernel
faults and provides some way for gfn_to_pfn_cache users like kvm-clock to
restore the direct map entries.

Sean, you mentioned that you envision guest_memfd also supporting non-CoCo VMs.
Do you have some thoughts about how to make the above cases work in the
guest_memfd context?

> > --
> > Sincerely yours,
> > Mike.

Best,
Patrick

[1]: https://lore.kernel.org/kvm/20240404185034.3184582-1-pbonzini@redhat.com/T/#m4cc08ce3142a313d96951c2b1286eb290c7d1dac
[2]: https://elixir.bootlin.com/linux/latest/source/arch/x86/kernel/kvmclock.c#L227
[3]: https://www.kernel.org/doc/html/next/x86/tdx.html#mmio-handling
[4]: https://www.kernel.org/doc/html/next/x86/tdx.html#shared-memory-conversions


