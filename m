Return-Path: <kvm+bounces-56452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA17B3E68C
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85A8E3A9116
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD9A335BB7;
	Mon,  1 Sep 2025 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="ap59WIrK"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3BF1D61B7;
	Mon,  1 Sep 2025 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.158.153.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756735399; cv=none; b=PNXslI2fJ70v7TSKWdDYwTCpv0e8iYzdvWHpFzQnviUADDUxfgukNh8J99krgiUgLCVAmlouDg8co+F/px/bQn28BUjI+JBdcZifCJK35ccXxH2r/6JhEONeDJpQA6NEqNnhOxk7R+rnzH2R82eYFJXIB2+p0YIvrrNWBNJnnRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756735399; c=relaxed/simple;
	bh=8CSjKnM5Evxz3AwWp6BBnliN2csYH+hCb0uO2A+z0Uk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JM46EX7bkiiAa70q/uYLlIo84GtMIeswpOkw4b+d+51Ftwdx47uK35AtNYIqvVU5Q52uG+Pq5/In7rC6rWOH/uQSvRmV6F2rspwnV/D2VA1cyMWadFCYFQtBj/PSStuYItst/UfBS2w/0GqaKHWzyi2QDBISoH9IpATVQYixd98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=ap59WIrK; arc=none smtp.client-ip=18.158.153.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756735397; x=1788271397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZpDM1obzK12bUteESwrJgWTMch0DIESyPnVssVZOnU8=;
  b=ap59WIrKdbtQm4b6DVLCAaBLQJ3DofUzCM+zAZbmcwFHXxfVbGw7y7t8
   mJdq0Vem/649qNNUvDOyNpot3D6l2gNBwjWJB1XzFAOF1bA0cwtbIqiZH
   O+UagsGhHCgOSx23nuVl2f6hXKQCaV/YOy90S7vZDN8Qaw9mKn04aSa3k
   nxL2mT0ISXVZ0QCMNmtsnf94638fJIE9Eb9GHRZUeN0GqQfRP4odCvONj
   ggRTr5G9518dfGBMKK2SPGIpZqTkz/uH4s0dYdkghCSSskmbSzBVz8W/z
   pfsz58A5w5r26KatVVOuRb4WpH12Znkt5LHbPWenlITH4cPr/ISGGcBj3
   Q==;
X-CSE-ConnectionGUID: cy41DMtgQzWT9ehlwIF+7w==
X-CSE-MsgGUID: AJVPOO4OT6GsjUOkK8ggbg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1356650"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:03:07 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:17259]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.3:2525] with esmtp (Farcaster)
 id 1e95fe30-2115-4c92-bf6e-bd2030ad81f1; Mon, 1 Sep 2025 14:03:07 +0000 (UTC)
X-Farcaster-Flow-ID: 1e95fe30-2115-4c92-bf6e-bd2030ad81f1
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:03:07 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:03:06 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:03:06 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "Manwaring, Derek"
	<derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org"
	<will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0kkyhDN15WuC0qLRSRUvcsDSg==
Date: Mon, 1 Sep 2025 14:03:06 +0000
Message-ID: <20250901140305.14081-1-roypat@amazon.co.uk>
References: <7ef927d8-190d-4b22-8ec7-dcb9f5f75dba@redhat.com>
In-Reply-To: <7ef927d8-190d-4b22-8ec7-dcb9f5f75dba@redhat.com>
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

=0A=
On Thu, 2025-08-28 at 22:00 +0100, David Hildenbrand wrote:=0A=
> On 28.08.25 11:39, Roy, Patrick wrote:=0A=
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
> [...]=0A=
> =0A=
>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vm=
a)=0A=
>> +{=0A=
>> +     return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mappi=
ng);=0A=
>> +}=0A=
>> +=0A=
> =0A=
> "vma_is_no_direct_map" reads a bit weird.=0A=
> =0A=
> "vma_has_no_direct_map" or "vma_no_direct_mapping" might be better.=0A=
=0A=
I went with "vma_has_no_direct_map" for now, because vma_no_direct_mapping=
=0A=
would imply (to me at least) changing "mapping_no_direct_map" to=0A=
"mapping_no_direct_mapping", which also reads a bit weird imo.=0A=
=0A=
> With the comment Mike and Fuad raised, this LGTM.=0A=
> =0A=
> =0A=
> -- =0A=
> Cheers=0A=
> =0A=
> David / dhildenb=0A=
=0A=
Best,=0A=
Patrick=0A=
=0A=
=0A=
=0A=

