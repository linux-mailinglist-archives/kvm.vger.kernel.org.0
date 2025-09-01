Return-Path: <kvm+bounces-56466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF64B3E7FF
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC7E51A84AC5
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1E0342CAC;
	Mon,  1 Sep 2025 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Zz/3rOz0"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B132341AB7;
	Mon,  1 Sep 2025 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.28.197.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756738606; cv=none; b=hQqHvREpQ2+YN+J/vHTrqh6KjM/r8WrMnqQv0QqSnODcghBaVrn800KTolz6vzkBdIbvumd+zbe1cB7wZoe0HoGtZaAUusPSMvJb4PCxTYdTrtvQOqFmo93OA7WPX6ZPYyrMmAQSoYpXyLePV3r2CVY482ks9c2QbngvPchifO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756738606; c=relaxed/simple;
	bh=0r92TVxw7xStPkhxnOmkl8O336c+4U2sqZq5v2M5rfQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ScokYEA2vvCQm31dBoAo9HBujDStd09RhZ6TfGC95shwawYybN/H1mQw0jlgX2fwmLr5jBAwNlZefws46ddGUb/M49vwK5ygHAK+gvNqXslESD+DKDvq5fNZ5/uQNLKFXW3PKnXCXtZnXrFjwH9CC0uHxqIGwyr6wwZ/lGebgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Zz/3rOz0; arc=none smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756738604; x=1788274604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DzdixQuy30cIOdtGPtZhymwxAjNsuo6l8KhPTQzil28=;
  b=Zz/3rOz02k0CZijphqp9ZkI2uI+MNzRHVUtqSaZj0zco6n+GKXQecmxT
   v0winJS3clIBs3DoevV7i21tnrZHvkBYMIzZc488ErWNdDvdPuLXFlic3
   NuB7uWF4peU+w6IYuB5aimAFu4wNfAFqvXa/fFYQIGJnFRMcutOZpWs9f
   oqYoFpzHYBbU3aJ4Z+RCn5ucKCSQzhGWMN10ISnPXJMlsJ+uYjPy45Lsu
   ghCjiS03i/pxxXd1WGydNCWFW2Jf3/yYQg5NHwJNGCbTfwbYRonT8wMzR
   T34wslWVo3fHlrDg31uws6b6a2gxBCVEp6Bz6wBNIukxyJOYNZmEjo2B4
   A==;
X-CSE-ConnectionGUID: TP9bWQ1xROib+ix+/ngIXQ==
X-CSE-MsgGUID: YwAZ6XeoRvujHV/6Dg0jJQ==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1364214"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:56:34 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:28303]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.37:2525] with esmtp (Farcaster)
 id 90fd1a2a-3fc2-46c8-b14d-04ef65bb514a; Mon, 1 Sep 2025 14:56:34 +0000 (UTC)
X-Farcaster-Flow-ID: 90fd1a2a-3fc2-46c8-b14d-04ef65bb514a
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:56:33 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:56:33 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:56:33 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0fkqK4jccjXtUKv/NLtaS3P1rR+aqUA
Date: Mon, 1 Sep 2025 14:56:33 +0000
Message-ID: <20250901145632.28172-1-roypat@amazon.co.uk>
References: <20250901135408.5965-1-roypat@amazon.co.uk>
In-Reply-To: <20250901135408.5965-1-roypat@amazon.co.uk>
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

On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:=0A=
> =0A=
> Hi Fuad!=0A=
> =0A=
> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:=0A=
>> Hi Patrick,=0A=
>>=0A=
>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:=
=0A=
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
>>> index 12a12dae727d..b52b28ae4636 100644=0A=
>>> --- a/include/linux/pagemap.h=0A=
>>> +++ b/include/linux/pagemap.h=0A=
>>> @@ -211,6 +211,7 @@ enum mapping_flags {=0A=
>>>                                    folio contents */=0A=
>>>         AS_INACCESSIBLE =3D 8,    /* Do not attempt direct R/W access t=
o the mapping */=0A=
>>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
>>> +       AS_NO_DIRECT_MAP =3D 10,  /* Folios in the mapping are not in t=
he direct map */=0A=
>>>         /* Bits 16-25 are used for FOLIO_ORDER */=0A=
>>>         AS_FOLIO_ORDER_BITS =3D 5,=0A=
>>>         AS_FOLIO_ORDER_MIN =3D 16,=0A=
>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_=
on_reclaim(struct address_spac=0A=
>>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping-=
>flags);=0A=
>>>  }=0A=
>>>=0A=
>>> +static inline void mapping_set_no_direct_map(struct address_space *map=
ping)=0A=
>>> +{=0A=
>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static inline bool mapping_no_direct_map(struct address_space *mapping=
)=0A=
>>> +{=0A=
>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *v=
ma)=0A=
>>> +{=0A=
>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_ma=
pping);=0A=
>>> +}=0A=
>>> +=0A=
>> Any reason vma is const whereas mapping in the function that it calls=0A=
>> (defined above it) isn't?=0A=
> =0A=
> Ah, I cannot say that that was a conscious decision, but rather an artifa=
ct of=0A=
> the code that I looked at for reference when writing these two simply did=
 it=0A=
> this way.  Are you saying both should be const, or neither (in my mind, b=
oth=0A=
> could be const, but the mapping_*() family of functions further up in thi=
s file=0A=
> dont take const arguments, so I'm a bit unsure now)?=0A=
=0A=
Hah, just saw=0A=
https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@io=
nos.com/.=0A=
Guess that means "both should be const" then :D=0A=
=0A=
>> Cheers,=0A=
>> /fuad=0A=
> =0A=
> Best,=0A=
> Patrick=0A=
=0A=

