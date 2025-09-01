Return-Path: <kvm+bounces-56458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C135B3E6E4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 035351894F81
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CF6337697;
	Mon,  1 Sep 2025 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="QLvSna8c"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235292EDD76;
	Mon,  1 Sep 2025 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756736547; cv=none; b=SDeupm/r82AbCGMwsvD4YxrdMmIf4EI/E9utY2wTGGWK+txSDpCS3oUR1YMiqKEVDOlt4qvhKsuP+hx8MBv2CcFgcUoMpb7xeAi4Vu6olbhBmZeD3HC0BT4K3izd+pDj09c8eKeHA+tO1fWG7Iuqk14FQWY0hLjy9iRR/dNO9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756736547; c=relaxed/simple;
	bh=wMkfF2t0dNP9/Poez+CLWMc02OD/Q4mBWn5bQTewYeM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b461bsmc0U+CunPNTCaHjUGqp0Ce6FSRvKA3/S143NX6CXvRXuUe0RTVPEhGmxuHyE2PbCoavjpCm217RWQBBUdYB2m8sRD3yb8VMVMijcTLCLi26cHs+bJiZeHcNFZRhM062hDoJVuDiZMmIzFcZCsGEDMNvLUGWPLjBoyXpqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=QLvSna8c; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756736545; x=1788272545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NexCRVeiTn8yKPd81BsG0VP8TjQq1oA2bxWGfc7HsT4=;
  b=QLvSna8c5AseRpSbUAD406B7YSqPUUq7C2mDvQU6i1LFMtZbOWY5F1Hd
   RWihydQ40o+DO2IO5t2ImfchoLuVb9gy/IF/3ejgA2RbcmYeFXowZRwJe
   ws/F1eq+2VvbJqk42XwoI00iAwexehsup173zwzVYkPNkOnk6MQoFJcLd
   6QS0n5Ulx1Mm4uzRYOZTgmgJ6jbuumKLKW9PXI2hQgrUN8VVts6kyAtDF
   mpAjJvBU2ecJboHQJeHgNtytV1BT1u2Zam6aF+s00gLxE2g7eicCDviFx
   g2pYSdYWuOJ3C3IEl1v4suwmg3IDT8GDWJ79O8vqnYN9/YcjxRGiFxL/G
   g==;
X-CSE-ConnectionGUID: qEKZaT7/TbumQlwD4xw4aw==
X-CSE-MsgGUID: lOy7Z9IPRo66N0b8RO5ESg==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1465584"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:22:23 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:2933]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.140:2525] with esmtp (Farcaster)
 id ce39f935-8ca3-4e3f-9b35-e9483f981017; Mon, 1 Sep 2025 14:22:23 +0000 (UTC)
X-Farcaster-Flow-ID: ce39f935-8ca3-4e3f-9b35-e9483f981017
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:22:23 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:22:22 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:22:22 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "rppt@kernel.org" <rppt@kernel.org>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 04/12] KVM: guest_memfd: Add flag to remove from direct
 map
Thread-Topic: [PATCH v5 04/12] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHcG0vV41OK1VctH0adgeriedPTLg==
Date: Mon, 1 Sep 2025 14:22:22 +0000
Message-ID: <20250901142220.30610-1-roypat@amazon.co.uk>
References: <aLBtwIhQpX6AR2Z6@kernel.org>
In-Reply-To: <aLBtwIhQpX6AR2Z6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-08-28 at 15:54 +0100, Mike Rapoport wrote:=0A=
> On Thu, Aug 28, 2025 at 09:39:21AM +0000, Roy, Patrick wrote:=0A=
>> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()=0A=
>> ioctl. When set, guest_memfd folios will be removed from the direct map=
=0A=
>> after preparation, with direct map entries only restored when the folios=
=0A=
>> are freed.=0A=
>>=0A=
>> To ensure these folios do not end up in places where the kernel cannot=
=0A=
>> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct=0A=
>> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.=0A=
>>=0A=
>> Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether=
=0A=
>> guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on=
=0A=
>> guest_memfd itself being supported, but also on whether KVM can=0A=
>> manipulate the direct map at page granularity at all (possible most of=
=0A=
>> the time, just arm64 is a notable outlier where its impossible if the=0A=
>> direct map has been setup using hugepages, as arm64 cannot break these=
=0A=
>> apart due to break-before-make semantics).=0A=
> =0A=
> There's also powerpc that does not select ARCH_HAS_SET_DIRECT_MAP=0A=
=0A=
Ah, thanks! Although powerpc also doesnt support guest_memfd in the first=
=0A=
place, but will mention.=0A=
=0A=
>> Note that this flag causes removal of direct map entries for all=0A=
>> guest_memfd folios independent of whether they are "shared" or "private"=
=0A=
>> (although current guest_memfd only supports either all folios in the=0A=
>> "shared" state, or all folios in the "private" state if=0A=
>> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map=
=0A=
>> entries of also the shared parts of guest_memfd are a special type of=0A=
>> non-CoCo VM where, host userspace is trusted to have access to all of=0A=
>> guest memory, but where Spectre-style transient execution attacks=0A=
>> through the host kernel's direct map should still be mitigated.  In this=
=0A=
>> setup, KVM retains access to guest memory via userspace mappings of=0A=
>> guest_memfd, which are reflected back into KVM's memslots via=0A=
>> userspace_addr. This is needed for things like MMIO emulation on x86_64=
=0A=
>> to work.=0A=
>>=0A=
>> Do not perform TLB flushes after direct map manipulations. This is=0A=
>> because TLB flushes resulted in a up to 40x elongation of page faults in=
=0A=
>> guest_memfd (scaling with the number of CPU cores), or a 5x elongation=
=0A=
>> of memory population. TLB flushes are not needed for functional=0A=
>> correctness (the virt->phys mapping technically stays "correct",  the=0A=
>> kernel should simply to not it for a while). On the other hand, it means=
=0A=
> =0A=
>                           ^ not use it?=0A=
=0A=
Yup, thanks!=0A=
=0A=
>> that the desired protection from Spectre-style attacks is not perfect,=
=0A=
>> as an attacker could try to prevent a stale TLB entry from getting=0A=
>> evicted, keeping it alive until the page it refers to is used by the=0A=
>> guest for some sensitive data, and then targeting it using a=0A=
>> spectre-gadget.=0A=
>>=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>  arch/arm64/include/asm/kvm_host.h | 12 ++++++++++++=0A=
>>  include/linux/kvm_host.h          |  7 +++++++=0A=
>>  include/uapi/linux/kvm.h          |  2 ++=0A=
>>  virt/kvm/guest_memfd.c            | 29 +++++++++++++++++++++++++----=0A=
>>  virt/kvm/kvm_main.c               |  5 +++++=0A=
>>  5 files changed, 51 insertions(+), 4 deletions(-)=0A=
> =0A=
> ...=0A=
> =0A=
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
>> index 9ec4c45e3cf2..e3696880405c 100644=0A=
>> --- a/virt/kvm/guest_memfd.c=0A=
>> +++ b/virt/kvm/guest_memfd.c=0A=
>> @@ -4,6 +4,7 @@=0A=
>>  #include <linux/kvm_host.h>=0A=
>>  #include <linux/pagemap.h>=0A=
>>  #include <linux/anon_inodes.h>=0A=
>> +#include <linux/set_memory.h>=0A=
>>=0A=
>>  #include "kvm_mm.h"=0A=
>>=0A=
>> @@ -42,8 +43,18 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, =
struct kvm_memory_slot *slo=0A=
>>       return 0;=0A=
>>  }=0A=
>>=0A=
>> +static bool kvm_gmem_test_no_direct_map(struct inode *inode)=0A=
>> +{=0A=
>> +     return ((unsigned long) inode->i_private) & GUEST_MEMFD_FLAG_NO_DI=
RECT_MAP;=0A=
>> +}=0A=
>> +=0A=
>>  static inline void kvm_gmem_mark_prepared(struct folio *folio)=0A=
>>  {=0A=
>> +     struct inode *inode =3D folio_inode(folio);=0A=
>> +=0A=
>> +     if (kvm_gmem_test_no_direct_map(inode))=0A=
>> +             set_direct_map_valid_noflush(folio_page(folio, 0), folio_n=
r_pages(folio), false);=0A=
> =0A=
> This may fail to split large mapping in the direct map. Why not move this=
=0A=
> to kvm_gmem_prepare_folio() where you can handle returned error?=0A=
=0A=
Argh, yeah, got that the wrong way around. Will update the error handling.=
=0A=
=0A=
> I think that using set_direct_map_invalid_noflush() here and=0A=
> set_direct_map_default_noflush() in kvm_gmem_free_folio() better is=0A=
> clearer and makes it more obvious that here the folio is removed from the=
=0A=
> direct map and when freed it's direct mapping is restored.=0A=
> =0A=
> This requires to export two symbols in patch 2, but I think it's worth it=
.=0A=
=0A=
Mh, but set_direct_map_[default|invalid]_noflush() only take a single struc=
t=0A=
page * argument, so they'd either need to gain a npages argument, or we add=
 yet=0A=
more functions to set_memory.h.  Do you still think that's worth it? =0A=
=0A=
>>       folio_mark_uptodate(folio);=0A=
>>  }=0A=
>>=0A=
>> @@ -429,25 +440,29 @@ static int kvm_gmem_error_folio(struct address_spa=
ce *mapping, struct folio *fol=0A=
>>       return MF_DELAYED;=0A=
>>  }=0A=
>>=0A=
>> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
>>  static void kvm_gmem_free_folio(struct address_space *mapping,=0A=
>>                               struct folio *folio)=0A=
>>  {=0A=
>>       struct page *page =3D folio_page(folio, 0);=0A=
>> +=0A=
>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
>>       kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
>>       int order =3D folio_order(folio);=0A=
>> +#endif=0A=
>>=0A=
>> +     if (kvm_gmem_test_no_direct_map(mapping->host))=0A=
>> +             WARN_ON_ONCE(set_direct_map_valid_noflush(page, folio_nr_p=
ages(folio), true));=0A=
> =0A=
> I don't think it can fail here. The direct map was split when you removed=
=0A=
> the folio so here it will merely update the prot bits.=0A=
=0A=
Yup, will drop this WARN_ON_ONCE.=0A=
=0A=
>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
>>       kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
>> -}=0A=
>>  #endif=0A=
>> +}=0A=
> =0A=
> Instead of moving #ifdefs into kvm_gmem_free_folio() it's better to add, =
say,=0A=
> kvm_gmem_invalidate() and move ifdefery there or even better have a stati=
c=0A=
> inline stub for !CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE case.=0A=
=0A=
Ack, will do the latter=0A=
=0A=
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c=0A=
>> index 18f29ef93543..0dbfd17e1191 100644=0A=
>> --- a/virt/kvm/kvm_main.c=0A=
>> +++ b/virt/kvm/kvm_main.c=0A=
>> @@ -65,6 +65,7 @@=0A=
>>  #include <trace/events/kvm.h>=0A=
>>=0A=
>>  #include <linux/kvm_dirty_ring.h>=0A=
>> +#include <linux/set_memory.h>=0A=
>>=0A=
>>=0A=
>>  /* Worst case buffer size needed for holding an integer. */=0A=
>> @@ -4916,6 +4917,10 @@ static int kvm_vm_ioctl_check_extension_generic(s=
truct kvm *kvm, long arg)=0A=
>>               return kvm_supported_mem_attributes(kvm);=0A=
>>  #endif=0A=
>>  #ifdef CONFIG_KVM_GUEST_MEMFD=0A=
>> +     case KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP:=0A=
>> +             if (!can_set_direct_map())=0A=
> =0A=
> Shouldn't this check with kvm_arch_gmem_supports_no_direct_map()?=0A=
=0A=
Absolutely, thanks for catching!=0A=
=0A=
>> +                     return false;=0A=
>> +             fallthrough;=0A=
>>       case KVM_CAP_GUEST_MEMFD:=0A=
>>               return 1;=0A=
>>       case KVM_CAP_GUEST_MEMFD_MMAP:=0A=
>> --=0A=
>> 2.50.1=0A=
>>=0A=
> =0A=
> --=0A=
> Sincerely yours,=0A=
> Mike.=0A=
=0A=
Best,=0A=
Patrick=0A=

