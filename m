Return-Path: <kvm+bounces-56451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1670CB3E64E
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23C55188C755
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E6133A036;
	Mon,  1 Sep 2025 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="c+M3u15H"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01E72F0690;
	Mon,  1 Sep 2025 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.156.205.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756734992; cv=none; b=P8/o02zkA4ZIlL2hFEsea02O5P2OPBtFGW0fByzEr8uECtAe/fyM5aN7cT0r4uBvzWi6ixdoQpndYsSdlD6OMMsKu+i+ucoAhMyi6JamwN+jvtyEuMClv87KjVuedLxesrF+PIr4pMVe17IxBaWUxAPlw5L9hWDZlhRiWYfogrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756734992; c=relaxed/simple;
	bh=i95CXdEujrHz2oIc/u+qVILlkYUOUDMfZHl60kuLTAU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=adzHZVnC3+s3r96A6v9Gqp/LokCPIC5zgBGoE5xN3SQiG/Cq8o2BzgudfoQ9VVNAVX8ewDjhHM+m3i1uq7uEuAXY8wFwXN1IIUVn15CpRd/J4vBGUbCmtYq1VXKVQcG1MxBXvcThSajVzKyOLTcai5jpxdUXKJ+ZsBKR/V6+SWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=c+M3u15H; arc=none smtp.client-ip=18.156.205.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756734990; x=1788270990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ShuxvqvDerzcNDGyxqNGPvo4DRrl5n6jGqzZ1svVTj0=;
  b=c+M3u15HqFign15DJexLOgYp2hqmq6JRSQnD3vOSr7AHMhv5mGyLxPoa
   qOrXbjVdF23QpmBBSDzfpK2AOAzqRcBBVmx0llVf/Kc4vi4SHq2WH2EM9
   ISXFdSLEQWewmKHXB3T7E8Uv9tRcExwqrfGwgCp4K4V0EF0emqc6B00iG
   LFMsQDxHFjdtwL/KBNzaYeszfFnajd6DNrOPFxV7UaxvB4yQrGcEecE+M
   URpAoh1dD9sqzi75w0RB+9SIZlYV4SShBtqbrbzqI8RlGSBkr6KtZ1JCu
   JcM3hDzsDoA70eIfQhJdlvSx76V9zLda2zo91R3cwc7jYxQLTxdw15GjD
   A==;
X-CSE-ConnectionGUID: W0SVbbBGRzWj4V7tZRsvSQ==
X-CSE-MsgGUID: 1UgY4F0/TxuSRxd+6VB0Jg==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1464002"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 13:56:18 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:27204]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id 3007a2af-4f0d-4c19-b4ab-3118cbde73e5; Mon, 1 Sep 2025 13:56:18 +0000 (UTC)
X-Farcaster-Flow-ID: 3007a2af-4f0d-4c19-b4ab-3118cbde73e5
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 13:56:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 13:56:17 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 13:56:17 +0000
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
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0gw3raZWQR6+ESSIUK7nFklbw==
Date: Mon, 1 Sep 2025 13:56:17 +0000
Message-ID: <20250901135615.7601-1-roypat@amazon.co.uk>
References: <aLBnHwUN74ErKVjX@kernel.org>
In-Reply-To: <aLBnHwUN74ErKVjX@kernel.org>
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

Hi Mike,=0A=
=0A=
On Thu, 2025-08-28 at 15:26 +0100, Mike Rapoport wrote:=0A=
> On Thu, Aug 28, 2025 at 09:39:19AM +0000, Roy, Patrick wrote:=0A=
>> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are=
=0A=
>> set to not present . Currently, mappings that match this description are=
=0A=
>> secretmem mappings (memfd_secret()). Later, some guest_memfd=0A=
>> configurations will also fall into this category.=0A=
>>=0A=
>> Reject this new type of mappings in all locations that currently reject=
=0A=
>> secretmem mappings, on the assumption that if secretmem mappings are=0A=
>> rejected somewhere, it is precisely because of an inability to deal with=
=0A=
>> folios without direct map entries, and then make memfd_secret() use=0A=
>> AS_NO_DIRECT_MAP on its address_space to drop its special=0A=
>> vma_is_secretmem()/secretmem_mapping() checks.=0A=
>>=0A=
>> This drops a optimization in gup_fast_folio_allowed() where=0A=
>> secretmem_mapping() was only called if CONFIG_SECRETMEM=3Dy. secretmem i=
s=0A=
>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on=
=0A=
>> by default"), so the secretmem check did not actually end up elided in=
=0A=
>> most cases anymore anyway.=0A=
>>=0A=
>> Use a new flag instead of overloading AS_INACCESSIBLE (which is already=
=0A=
>> set by guest_memfd) because not all guest_memfd mappings will end up=0A=
>> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that=
=0A=
>> can be mapped to userspace should also be GUP-able, and generally not=0A=
>> have restrictions on who can access it).=0A=
>>=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>  include/linux/pagemap.h   | 16 ++++++++++++++++=0A=
>>  include/linux/secretmem.h | 18 ------------------=0A=
>>  lib/buildid.c             |  4 ++--=0A=
>>  mm/gup.c                  | 14 +++-----------=0A=
>>  mm/mlock.c                |  2 +-=0A=
>>  mm/secretmem.c            |  6 +-----=0A=
>>  6 files changed, 23 insertions(+), 37 deletions(-)=0A=
>>=0A=
>> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h=0A=
>> index e918f96881f5..0ae1fb057b3d 100644=0A=
>> --- a/include/linux/secretmem.h=0A=
>> +++ b/include/linux/secretmem.h=0A=
>> @@ -4,28 +4,10 @@=0A=
>>=0A=
>>  #ifdef CONFIG_SECRETMEM=0A=
>>=0A=
>> -extern const struct address_space_operations secretmem_aops;=0A=
> =0A=
> Please also make secretmem_aops static in mm/secretmem.c=0A=
=0A=
Ack.=0A=
=0A=
>> -static inline bool secretmem_mapping(struct address_space *mapping)=0A=
>> -{=0A=
>> -     return mapping->a_ops =3D=3D &secretmem_aops;=0A=
>> -}=0A=
>> -=0A=
> =0A=
> ...=0A=
> =0A=
>> diff --git a/mm/gup.c b/mm/gup.c=0A=
>> index adffe663594d..8c988e076e5d 100644=0A=
>> --- a/mm/gup.c=0A=
>> +++ b/mm/gup.c=0A=
>> @@ -1234,7 +1234,7 @@ static int check_vma_flags(struct vm_area_struct *=
vma, unsigned long gup_flags)=0A=
>>       if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))=0A=
>>               return -EOPNOTSUPP;=0A=
>>=0A=
>> -     if (vma_is_secretmem(vma))=0A=
>> +     if (vma_is_no_direct_map(vma))=0A=
>>               return -EFAULT;=0A=
>>=0A=
>>       if (write) {=0A=
>> @@ -2751,7 +2751,6 @@ static bool gup_fast_folio_allowed(struct folio *f=
olio, unsigned int flags)=0A=
>>  {=0A=
>>       bool reject_file_backed =3D false;=0A=
>>       struct address_space *mapping;=0A=
>> -     bool check_secretmem =3D false;=0A=
>>       unsigned long mapping_flags;=0A=
>>=0A=
>>       /*=0A=
>> @@ -2763,14 +2762,6 @@ static bool gup_fast_folio_allowed(struct folio *=
folio, unsigned int flags)=0A=
>>               reject_file_backed =3D true;=0A=
>>=0A=
>>       /* We hold a folio reference, so we can safely access folio fields=
. */=0A=
>> -=0A=
>> -     /* secretmem folios are always order-0 folios. */=0A=
>> -     if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))=0A=
>> -             check_secretmem =3D true;=0A=
>> -=0A=
>> -     if (!reject_file_backed && !check_secretmem)=0A=
>> -             return true;=0A=
>> -=0A=
>>       if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
>>               return false;=0A=
> =0A=
> There's a check for hugetlb after this and a comment there mentions=0A=
> secretmem, please update that to "mapping with no direct map" or somethin=
g=0A=
> like that.=0A=
=0A=
Ack.=0A=
=0A=
> --=0A=
> Sincerely yours,=0A=
> Mike.=0A=
=0A=
Thanks,=0A=
Patrick=0A=

