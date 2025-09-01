Return-Path: <kvm+bounces-56463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A24B3E73F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78875206FDF
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C07343D92;
	Mon,  1 Sep 2025 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="VuHQf2G3"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80545340D9A;
	Mon,  1 Sep 2025 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.65.3.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756737016; cv=none; b=IGSZmUxiwaLiYg+n49pOSpJ2xoKbBtmoI2IG0Z2eXcCuX3+4NqvvVv/xZ8I0tCh0szCHA2Ksd4Q3w2NLtrVThLqrbrmDx3CL9tRnOE4nPhrGheRlFLmuMJB+Cv4jyTwh+yS0DKn+zWpzw7IqhstGzyFCN18apHD1wfk3dCO4bvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756737016; c=relaxed/simple;
	bh=ThRwItIAwvtz61VcsD5Fw+ketQmDIUxXtokPShuvEEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EJMsozQH2G1KlS6jDGPMZBU6tDo6WrKNJDCdyl4a2XFa5c7qW+Ct9pMHOKULFMntHqGSIqzvybk+ctm0XlRBclCBp5b7IdaxSae+ODWLsxPVZAy3s0/WIF2vN6v2yfnLgeE/vxuEsDRSnP3slXQ2UM1xA8aAnCnDF35ZczLwxhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=VuHQf2G3; arc=none smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756737013; x=1788273013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dLl1oyt4RUhXcYIWGbyNXvmAubTcFciHIOgmTgsswPk=;
  b=VuHQf2G3X+O31P03imHyX7UqH0pxCxOzJQru0BCLtCvVGv1MziPREAuV
   ZFjjTawKZZRMRxC9ZkgvMfwv8LoMafLl+0rcHcHsJByCO/m+uoXUV0anS
   PJCLWibnHgdAvYjDf7+DD6deFZHcxMWArmJi0WgmlwX9RA1flIhpRL7vz
   pjhFZJe7c715lCVSCOV0XawTr8o22DeWOG9XmLTvKNJW58dgaITH/oDKc
   Lg+MznA0VjhOFsSiwhka9tWET4+5aPBT7mN6UlAPKDHfEoubaBq2OK4oU
   +E+MUABMraRztQKs07Z7XFfM7OB96Tpx8GwaYY3X0Ut9fLYP5zddwprKn
   A==;
X-CSE-ConnectionGUID: 7B/ba3PkSy26ZXnwYQdRbw==
X-CSE-MsgGUID: s/0fbb7eT56B6Mg2WRcDHg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1466996"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:30:03 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:23216]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id 24b98d19-0a60-4c24-a3c6-c81ad810034e; Mon, 1 Sep 2025 14:30:03 +0000 (UTC)
X-Farcaster-Flow-ID: 24b98d19-0a60-4c24-a3c6-c81ad810034e
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:30:02 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:30:01 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:30:01 +0000
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
Subject: Re: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Index: AQHcG0zmqnuL2jS1NUKSUglbGWh4mA==
Date: Mon, 1 Sep 2025 14:30:01 +0000
Message-ID: <20250901143000.5017-1-roypat@amazon.co.uk>
References: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
In-Reply-To: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
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

On Thu, 2025-08-28 at 11:27 +0100, David Hildenbrand wrote:=0A=
> On 28.08.25 11:39, Roy, Patrick wrote:=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>   Documentation/virt/kvm/api.rst | 5 +++++=0A=
>>   1 file changed, 5 insertions(+)=0A=
>>=0A=
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api=
.rst=0A=
>> index c17a87a0a5ac..b52c14d58798 100644=0A=
>> --- a/Documentation/virt/kvm/api.rst=0A=
>> +++ b/Documentation/virt/kvm/api.rst=0A=
>> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is s=
upported, the 'flags' field=0A=
>>   supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd crea=
tion=0A=
>>   enables mmap() and faulting of guest_memfd memory to host userspace.=
=0A=
>>=0A=
>> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags=
' field=0A=
>> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the gu=
est_memfd=0A=
>> +instance behave similarly to memfd_secret, and unmaps the memory backin=
g it from=0A=
>> +the kernel's address space after allocation.=0A=
>> +=0A=
>>   When the KVM MMU performs a PFN lookup to service a guest fault and th=
e backing=0A=
>>   guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will alw=
ays be=0A=
>>   consumed from guest_memfd, regardless of whether it is a shared or a p=
rivate=0A=
> =0A=
> WARNING: Missing commit description - Add an appropriate one=0A=
=0A=
Admittedly wasn't sure what to say that wouldn't just repeat the commit tit=
le=0A=
or the contents. Maybe that just means this shouldn't be its own patch. Wil=
l=0A=
squash in the previous one (same for PATCH 11/12).=0A=
=0A=
> WARNING: From:/Signed-off-by: email name mismatch: 'From: "Roy, Patrick"=
=0A=
> <roypat@amazon.co.uk>' !=3D 'Signed-off-by: Patrick Roy <roypat@amazon.co=
.uk>'=0A=
=0A=
Heh, my git config only ever uses "Patrick Roy <roypat@amazon.co.uk>". Not =
sure=0A=
where "Roy, Patrick" comes from, could it be the mail server mangling thing=
s?=0A=
=0A=
> -- =0A=
> Cheers=0A=
> =0A=
> David / dhildenb=0A=
> =0A=
Best,=0A=
Patrick=0A=

