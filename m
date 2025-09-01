Return-Path: <kvm+bounces-56449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 131B6B3E5EB
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 235B116E575
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F853375A3;
	Mon,  1 Sep 2025 13:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Q9JC1tDG"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974F91E2823;
	Mon,  1 Sep 2025 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.28.197.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756734434; cv=none; b=AILiwdEAaJAT5QIO5MamT9AHinn4Jmp01MjJ/2dN+RL33vc0KA56KZLdqKCh/4pTfXt+akVxIzRGKGti70/f1o6O2hvH1XohP5+7Sb6iL8SVD0T5bqt9f9ZgNJNOZPifv8GCMJFU4e8q79s2KOGnDSf0xci6ZaLhGmQaAIYGDIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756734434; c=relaxed/simple;
	bh=AfWNq8qOG43flzRWME3FN/9/nkz8zIUH0oyoL8ZMcCk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NPd7rmYNbUTQHMcf5OdudxVew2bwKSOSzHJlqpBihlOVZNQEJ6d3I9h3CTtOXk5YqrgQFFlt+cyPDWOta1KL/xrvxiAL2CulTDvUgWBh+Gl+L6Fb18SDjd+z54sWLwJkrlDVP6i1iTPgRbwpfH0GBW/eiUzCzqUriN35LbZ2RiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Q9JC1tDG; arc=none smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756734432; x=1788270432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+FO6rXzJ1OSaPqvoH5IT1CQYrfHskP0PMe12nrwxRLg=;
  b=Q9JC1tDGGmQa8cbTlrJeUFILAHZVn9hv8HoPCtoYm5T2eHgQ9R8CBpvf
   q/+ojK3nXCvA0HBRFselha6Bm9s3mslwgU4T+5bzYjZoHQMhggFc/JPuJ
   PyudG0+YE9ShgQJ5WRgZCGiCq0/2AAKSRlPowtWabB0+iT19U5yHSTvJb
   EC4ps/QZ0UdwkfHkkQ5YZTgQBEiOUXzgWoeY4eTP+iI7ARJAtPBh9aSm1
   eVUdtP+lDPzuQMgY7EQ/2p+ku0wj5Y82sEoU3FEstufT0kiO9cMCvWR5f
   ekeWAZ9AqFLki2cCdePAqoXSr81uZsfLm/7a25v0z3jHpJYvU0EFiN+jS
   Q==;
X-CSE-ConnectionGUID: m8ytizq0Q1qu8e8vIjnAEg==
X-CSE-MsgGUID: iRZ+qBh2R/uOhlJ6+f0jsg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1359904"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 13:47:02 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:16772]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.3:2525] with esmtp (Farcaster)
 id ca3958c9-cdc5-4794-b45a-6e9b3384e54b; Mon, 1 Sep 2025 13:47:02 +0000 (UTC)
X-Farcaster-Flow-ID: ca3958c9-cdc5-4794-b45a-6e9b3384e54b
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 13:47:01 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 13:47:01 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 13:47:01 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "tabba@google.com" <tabba@google.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to KVM
 module
Thread-Topic: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to
 KVM module
Thread-Index: AQHcG0bk577bUdlDRkuvvFVSrUyVog==
Date: Mon, 1 Sep 2025 13:47:00 +0000
Message-ID: <20250901134659.32171-1-roypat@amazon.co.uk>
References: <CA+EHjTwDZ-FRV2KfC5ZG9SJYeeMRVUHQ8rVtb9dx2AQwCriPQw@mail.gmail.com>
In-Reply-To: <CA+EHjTwDZ-FRV2KfC5ZG9SJYeeMRVUHQ8rVtb9dx2AQwCriPQw@mail.gmail.com>
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

Hi Fuad!=0A=
=0A=
On Thu, 2025-08-28 at 11:07 +0100, Fuad Tabba wrote:=0A=
>> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=
=0A=
>> index f5e910b68229..d076bfd3fcbf 100644=0A=
>> --- a/arch/loongarch/mm/pageattr.c=0A=
>> +++ b/arch/loongarch/mm/pageattr.c=0A=
>> @@ -217,6 +217,7 @@ int set_direct_map_invalid_noflush(struct page *page=
)=0A=
>>=0A=
>>         return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT=
 | _PAGE_VALID));=0A=
>>  }=0A=
>> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
> =0A=
> This should be after 'set_direct_map_valid_noflush', not 'invalid'.=0A=
> =0A=
> With that fixed:=0A=
> =0A=
> Reviewed-by: Fuad Tabba <tabba@google.com>=0A=
=0A=
Ah, yes, good catch, thanks!=0A=
=0A=
Best,=0A=
Patrick=0A=

