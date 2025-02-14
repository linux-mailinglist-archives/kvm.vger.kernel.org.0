Return-Path: <kvm+bounces-38161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78960A35DC0
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98E62188E6D9
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BAC263F26;
	Fri, 14 Feb 2025 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Tg5XSocf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B875263C73;
	Fri, 14 Feb 2025 12:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739536674; cv=none; b=A+hEsZbmcWcr6uIN70VFDVgFg1IvZCzjt+70Z536aP6q5cL4YwTctatEfPKMBSy8Qk75V4OY0+izhG3MpxOWnYQznOrEr1jWuGaiQBY0eVl+v9WfykDYlvyEgesHXfdd/Nw/8E7UGsFpA412YnAZo8UF8XdEVoqcOWIE4qxZHwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739536674; c=relaxed/simple;
	bh=MpYdylY++8VfkEnM5IvLalLzcXbKo9j+8NV8nQx4n+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=emNSTEVCRxD9b0cy+H/A0P0xk9Smzu/dSENCv1Lfb7b8TDsgZhD8fSDlIVmn5cFsEUY+pb8BhdgNXSI2MSwRgJDiNu313PdAEeb++Ul2YfZluoF7gVKAAcQp5C33gw2f/4zr65Vdp7cec+wY9geNzG95+a5/gEczNwp7fGyVmNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Tg5XSocf; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1739536672; x=1771072672;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tm+osB2yjHRvqWpYOEEHWB+vgVWcduhdO4iqJ02ZEQY=;
  b=Tg5XSocf3LCg98/2PQ2hYprXk7S9or23utbHWK3ZI6pTwrMdY3nGJ4Ne
   ni9PNiCDiPafuDwdjHgxUxTwKoeSc6dazSnvVAJaW1M+qXwpqZKu0hjFr
   rrDp2Oy8AoG9bxoMaWV3Bhpu21CtsXfM9tKPDUV+ShPubY3SZqppKvR5s
   I=;
X-IronPort-AV: E=Sophos;i="6.13,285,1732579200"; 
   d="scan'208";a="172485778"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 12:37:49 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.0.204:50712]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.24.55:2525] with esmtp (Farcaster)
 id 47e06a44-bd11-4a3c-b37d-53c7e5121d00; Fri, 14 Feb 2025 12:37:48 +0000 (UTC)
X-Farcaster-Flow-ID: 47e06a44-bd11-4a3c-b37d-53c7e5121d00
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 14 Feb 2025 12:37:48 +0000
Received: from email-imr-corp-prod-iad-1box-1a-6851662a.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Fri, 14 Feb 2025 12:37:48 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-1box-1a-6851662a.us-east-1.amazon.com (Postfix) with ESMTPS id 1720A40627;
	Fri, 14 Feb 2025 12:37:40 +0000 (UTC)
Message-ID: <ebbc4523-6bec-4f4f-a509-d10a264a9a97@amazon.co.uk>
Date: Fri, 14 Feb 2025 12:37:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce
 KVM_VM_TYPE_ARM_SW_PROTECTED machine type
To: Fuad Tabba <tabba@google.com>, Quentin Perret <qperret@google.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-mm@kvack.org>, <pbonzini@redhat.com>, <chenhuacai@kernel.org>,
	<mpe@ellerman.id.au>, <anup@brainfault.org>, <paul.walmsley@sifive.com>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>, <mic@digikod.net>,
	<vbabka@suse.cz>, <vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<keirf@google.com>, <shuah@kernel.org>, <hch@infradead.org>,
	<jgg@nvidia.com>, <rientjes@google.com>, <jhubbard@nvidia.com>,
	<fvdl@google.com>, <hughd@google.com>, <jthoughton@google.com>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-10-tabba@google.com> <Z6t227f31unTnQQt@google.com>
 <CA+EHjTweTLDzhcCoEZYP4iyuti+8TU3HbtLHh+u5ark6WDjbsA@mail.gmail.com>
 <Z6t6_M8un1Cf3nmk@google.com>
 <d9645330-3a0d-4950-a50b-ce82b428e08c@amazon.co.uk>
 <Z6uEQFDbMGboHYx7@google.com> <Z68lZUeGWwIe-tEK@google.com>
 <CA+EHjTz=d99Mz9jXt5onmtkJgxDetZ32NYkFv98L50BJgSbgGg@mail.gmail.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
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
In-Reply-To: <CA+EHjTz=d99Mz9jXt5onmtkJgxDetZ32NYkFv98L50BJgSbgGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Fri, 2025-02-14 at 11:33 +0000, Fuad Tabba wrote:
> Hi Quentin,
> 
> On Fri, 14 Feb 2025 at 11:13, Quentin Perret <qperret@google.com> wrote:
>>
>> On Tuesday 11 Feb 2025 at 17:09:20 (+0000), Quentin Perret wrote:
>>> Hi Patrick,
>>>
>>> On Tuesday 11 Feb 2025 at 16:32:31 (+0000), Patrick Roy wrote:
>>>> I was hoping that SW_PROTECTED_VM will be the VM type that something
>>>> like Firecracker could use, e.g. an interface to guest_memfd specifically
>>>> _without_ pKVM, as Fuad was saying.
>>>
>>> I had, probably incorrectly, assumed that we'd eventually want to allow
>>> gmem for all VMs, including traditional KVM VMs that don't have anything
>>> special. Perhaps the gmem support could be exposed via a KVM_CAP in this
>>> case?
>>>
>>> Anyway, no objection to the proposed approach in this patch assuming we
>>> will eventually have HW_PROTECTED_VM for pKVM VMs, and that _that_ can be
>>> bit 31 :).
>>
>> Thinking about this a bit deeper, I am still wondering what this new
>> SW_PROTECTED VM type is buying us? Given that SW_PROTECTED VMs accept
>> both guest-memfd backed memslots and traditional HVA-backed memslots, we
>> could just make normal KVM guests accept guest-memfd memslots and get
>> the same thing? Is there any reason not to do that instead? Even though
>> SW_PROTECTED VMs are documented as 'unstable', the reality is this is
>> UAPI and you can bet it will end up being relied upon, so I would prefer
>> to have a solid reason for introducing this new VM type.
> 
> The more I think about it, I agree with you. I think that reasonable
> behavior (for kvm/arm64) would be to allow using guest_memfd with all
> VM types. If the VM type is a non-protected type, then its memory is
> considered shared by default and is mappable --- as long as the
> kconfig option is enabled. If VM is protected then the memory is not
> shared by default.
> 
> What do you think Patrick? Do you need an explicit VM type?

Mhh, no, if "normal" VMs support guest_memfd, then that works too. I
suggested the VM type because that's how x86 works
(KVM_X86_SW_PROTECTED_VM), but never actually stopped to think about
whether it makes sense for ARM. Maybe Sean knows something we're missing?

I wonder whether having the "default sharedness" depend on the vm type
works out though - whether a range of gmem is shared or private is a
property of the guest_memfd instance, not the VM it's attached to, so I
guess the default behavior needs to be based solely on the guest_memfd
as well (and then if someone tries to attach a gmem to a VM whose desire
of protection doesnt match the guest_memfd's configuration, that
operation would fail)?

Tangentially related, does KVM_GMEM_SHARED to you mean "guest_memfd also
supports shared sections", or "guest_memfd does not support private
memory anymore"? (the difference being that in the former, then
KVM_GMEM_SHARED would later get the ability to convert ranges private,
and the EOPNOSUPP is just a transient state until conversion support is
merged) - doesnt matter for my usecase, but I got curious as some other
threads implied the second option to me and I ended up wondering why.

Best,
Patrick

> Cheers,
> /fuad
> 
>> Cheers,
>> Quentin

