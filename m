Return-Path: <kvm+bounces-46140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 174ACAB30BB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 878D7177723
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 07:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5535256C73;
	Mon, 12 May 2025 07:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Ky9NTgh/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA155186A;
	Mon, 12 May 2025 07:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747035983; cv=none; b=P2sOhiCR4MANOoB2e8zaD7UBDu0KYpBIFNcXwymJEEoSLHXj/Cb2X+7luU8MqTGMOk9LM/Jv0IEp2mFEJz0xtZ/GSIcXgeAzqj+/+5UMGUVMfrbLYmxzr0WuSLEBfkrOjfV8RNdljPwt4xMb8o2HkfafAd/3uCSyV6Ra4z0Vti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747035983; c=relaxed/simple;
	bh=0RT5pR3zu8s4u/ve/UmtKxEnYyePlnDmI1fmyK7EEu4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FlR4ZYv7zoXTkqg4mCbjynF8ylxH0XjyI9ZZteI4EK04M8dhKSi9xkpGBDIGEkh+aP56Gmw8JVeXnnYg27BPUIz13bjq8dgiUJDQ+36kOBANlC9Nb1GwJGd8RPiO0X58+1Biy+v0jnK+pdskNxc7YhkkQfV184sP05eM679PC+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Ky9NTgh/; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1747035983; x=1778571983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UFHX9bhgLQx+UYifQKLj+r4SVr4Xj6mwpCPoMq7PFqQ=;
  b=Ky9NTgh/kirHEfchj3SZlw5XbWbYdjEhkC3iU1ehMnhMDxWX6+mgPEWF
   w4ilAP6ooybz5IH4WuWZ4oDAbpIX9ugKD/jcamQBvjuCmR+nHjYXNVnwz
   iu2mSBCByRHBNzwCuOltRe+31xuDy/PXUCu7foZEn5Hr/BwZnrbqHlmGS
   0Zikquj+fFGXjfrQGRUnBq/AwzLoZYg2wWtNszP6E/XsLtRl3KT5UFPhl
   Auy1LMTw5nMrwiJFeHNfp+2SMRz5DfLrzkoWDGCqwEJFyUnvs79wstYn0
   51BURJZyuqtYM/Uj1wLfQ7I5X+hl+SbOyUQtRboXPlHyr/BlSVPXtp7V2
   A==;
X-IronPort-AV: E=Sophos;i="6.15,281,1739836800"; 
   d="scan'208";a="491223325"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 07:46:19 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:57683]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.1.36:2525] with esmtp (Farcaster)
 id 2a2a5210-3103-4885-a716-a4de45963b83; Mon, 12 May 2025 07:46:18 +0000 (UTC)
X-Farcaster-Flow-ID: 2a2a5210-3103-4885-a716-a4de45963b83
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 12 May 2025 07:46:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 12 May 2025 07:46:17 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.1544.014; Mon, 12 May 2025 07:46:17 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"amoorthy@google.com" <amoorthy@google.com>, "anup@brainfault.org"
	<anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "chenhuacai@kernel.org"
	<chenhuacai@kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"fvdl@google.com" <fvdl@google.com>, "hch@infradead.org" <hch@infradead.org>,
	"hughd@google.com" <hughd@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "isaku.yamahata@intel.com"
	<isaku.yamahata@intel.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jthoughton@google.com"
	<jthoughton@google.com>, "keirf@google.com" <keirf@google.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "liam.merwick@oracle.com"
	<liam.merwick@oracle.com>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "maz@kernel.org"
	<maz@kernel.org>, "mic@digikod.net" <mic@digikod.net>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"qperret@google.com" <qperret@google.com>, "quic_cvanscha@quicinc.com"
	<quic_cvanscha@quicinc.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "quic_mnalajal@quicinc.com"
	<quic_mnalajal@quicinc.com>, "quic_pderrin@quicinc.com"
	<quic_pderrin@quicinc.com>, "quic_pheragu@quicinc.com"
	<quic_pheragu@quicinc.com>, "quic_svaddagi@quicinc.com"
	<quic_svaddagi@quicinc.com>, "quic_tsoni@quicinc.com"
	<quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, "Roy,
 Patrick" <roypat@amazon.co.uk>, "seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "steven.price@arm.com"
	<steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"tabba@google.com" <tabba@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "wei.w.wang@intel.com"
	<wei.w.wang@intel.com>, "will@kernel.org" <will@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, "xiaoyao.li@intel.com"
	<xiaoyao.li@intel.com>, "yilun.xu@intel.com" <yilun.xu@intel.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
Thread-Topic: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
Thread-Index: AQHbwxHxVdW3j+H8JUSlmMeNB3J9nA==
Date: Mon, 12 May 2025 07:46:16 +0000
Message-ID: <20250512074615.27394-1-roypat@amazon.co.uk>
References: <702d9951-ac26-4ee4-8a78-d5104141c2e4@redhat.com>
In-Reply-To: <702d9951-ac26-4ee4-8a78-d5104141c2e4@redhat.com>
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

On Sun, 2025-05-11 at 09:03 +0100, David Hildenbrand wrote:=0A=
>>>                return -ENODEV;=0A=
>>> +=0A=
>>> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D=0A=
>>> +           (VM_SHARED | VM_MAYSHARE)) {=0A=
>>> +               return -EINVAL;=0A=
>>> +       }=0A=
>>> +=0A=
>>> +       vm_flags_set(vma, VM_DONTDUMP);=0A=
>>=0A=
>> Hi Fuad,=0A=
>>=0A=
>> Sorry if I missed this, but why exactly do we set VM_DONTDUMP here?=0A=
>> Could you leave a small comment? (I see that it seems to have=0A=
>> originally come from Patrick? [1]) I get that guest memory VMAs=0A=
>> generally should have VM_DONTDUMP; is there a bigger reason?=0A=
=0A=
Iirc, I essentially copied my mmap handler from secretmem for that RFC. But=
=0A=
even for direct map removal, it seems this is not needed, because get_dump_=
page=0A=
goes via GUP, which errors out for direct map removed VMAs. So what David i=
s=0A=
saying below also applies in that case.=0A=
 =0A=
> (David replying)=0A=
> =0A=
> I assume because we might have inaccessible parts in there that SIGBUS=0A=
> on access.=0A=
> =0A=
> get_dump_page() does ignore any errors, though (returning NULL), so=0A=
> likely we don't need VM_DONTDUMP.=0A=
> =0A=
> -- =0A=
> Cheers,=0A=
> =0A=
> David / dhildenb=0A=
=0A=
Best,=0A=
Patrick=0A=

