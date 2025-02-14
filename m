Return-Path: <kvm+bounces-38170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A7ECA35ED1
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E6E73A6284
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D894526562F;
	Fri, 14 Feb 2025 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="fARH3w9K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2470F264A6F;
	Fri, 14 Feb 2025 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739539127; cv=none; b=HKOYBC2kI0Dh3WlZC2zfQ/QmTLDHa9Q/Qzqp1XpJT7dBpUFttsUbmMkbMPmWyM3X8M5zbRlYWonY7CwHab9IPHTvqZj2GChVRLokMucywEmYBjc/iZxOCtHm2U1Ko5Z5jyHsz1DthWqiNKdFiKYxid7a00rDFiT8yk0IjhPPuw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739539127; c=relaxed/simple;
	bh=xXxNLa3G7qTfVzYOIdqHoDtXL5O0PUXYdxtU5wzx5JM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UvLW98WnIAsuv7WRKGCSO7JeJoRu5BRKOE+FZ39BUSAY/sslR0gfUt9DaDbvwOpDCpggSxZoWZ3tFjpx2+dhHHzdJ3IKGcQuymBcQMubxMv8F4RO0P4REM/jDdbWww58z9UKp9sEIZtHNLW/d6ztJmUtU1CrTcaj4QupcitdZF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=fARH3w9K; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1739539127; x=1771075127;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qr604Rq0b4EyCMGppcLexMAz3k0+4r6zv7y+lpHBXWY=;
  b=fARH3w9KAPrfARXnnEHscG8ffpvWOf9uX9SOiHNssdnz80gpF8PIWa3C
   nGBMT+Q8Whtn5schnXqZaclsQwu6aM4dmmlicGM3xu1LSu+STUPFbJeB8
   xIjEK6K+7Ldzo/YgXFZLtFST0HgB5RnId9F2FjEbNzyAnJrf797Yj69VL
   0=;
X-IronPort-AV: E=Sophos;i="6.13,286,1732579200"; 
   d="scan'208";a="798814957"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 13:18:20 +0000
Received: from EX19MTAUEB002.ant.amazon.com [10.0.29.78:46374]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.84.99:2525] with esmtp (Farcaster)
 id eb3728cb-15eb-4699-8139-4389b04912de; Fri, 14 Feb 2025 13:18:18 +0000 (UTC)
X-Farcaster-Flow-ID: eb3728cb-15eb-4699-8139-4389b04912de
Received: from EX19EXOUEC001.ant.amazon.com (10.252.135.173) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 14 Feb 2025 13:18:14 +0000
Received: from EX19MTAUEB002.ant.amazon.com (10.252.135.47) by
 EX19EXOUEC001.ant.amazon.com (10.252.135.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 14 Feb 2025 13:18:10 +0000
Received: from email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Fri, 14 Feb 2025 13:18:10 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com (Postfix) with ESMTPS id 71A284221E;
	Fri, 14 Feb 2025 13:18:04 +0000 (UTC)
Message-ID: <a17d4cd4-b902-4578-83c4-78bb7e0c4bd1@amazon.co.uk>
Date: Fri, 14 Feb 2025 13:18:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce
 KVM_VM_TYPE_ARM_SW_PROTECTED machine type
To: Fuad Tabba <tabba@google.com>
CC: Quentin Perret <qperret@google.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>,
	<pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
	<yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>, <jarkko@kernel.org>,
	<amoorthy@google.com>, <dmatlack@google.com>, <yu.c.zhang@linux.intel.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
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
 <ebbc4523-6bec-4f4f-a509-d10a264a9a97@amazon.co.uk>
 <CA+EHjTyiRAun3XbRUZA52Pq2kSk+gHFt_PksJcCh7P1V3-J3_A@mail.gmail.com>
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
In-Reply-To: <CA+EHjTyiRAun3XbRUZA52Pq2kSk+gHFt_PksJcCh7P1V3-J3_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Fri, 2025-02-14 at 13:11 +0000, Fuad Tabba wrote:
> Hi Patrick,
> 
> On Fri, 14 Feb 2025 at 12:37, Patrick Roy <roypat@amazon.co.uk> wrote:
>>
>>
>>
>> On Fri, 2025-02-14 at 11:33 +0000, Fuad Tabba wrote:
>>> Hi Quentin,
>>>
>>> On Fri, 14 Feb 2025 at 11:13, Quentin Perret <qperret@google.com> wrote:
>>>>
>>>> On Tuesday 11 Feb 2025 at 17:09:20 (+0000), Quentin Perret wrote:
>>>>> Hi Patrick,
>>>>>
>>>>> On Tuesday 11 Feb 2025 at 16:32:31 (+0000), Patrick Roy wrote:
>>>>>> I was hoping that SW_PROTECTED_VM will be the VM type that something
>>>>>> like Firecracker could use, e.g. an interface to guest_memfd specifically
>>>>>> _without_ pKVM, as Fuad was saying.
>>>>>
>>>>> I had, probably incorrectly, assumed that we'd eventually want to allow
>>>>> gmem for all VMs, including traditional KVM VMs that don't have anything
>>>>> special. Perhaps the gmem support could be exposed via a KVM_CAP in this
>>>>> case?
>>>>>
>>>>> Anyway, no objection to the proposed approach in this patch assuming we
>>>>> will eventually have HW_PROTECTED_VM for pKVM VMs, and that _that_ can be
>>>>> bit 31 :).
>>>>
>>>> Thinking about this a bit deeper, I am still wondering what this new
>>>> SW_PROTECTED VM type is buying us? Given that SW_PROTECTED VMs accept
>>>> both guest-memfd backed memslots and traditional HVA-backed memslots, we
>>>> could just make normal KVM guests accept guest-memfd memslots and get
>>>> the same thing? Is there any reason not to do that instead? Even though
>>>> SW_PROTECTED VMs are documented as 'unstable', the reality is this is
>>>> UAPI and you can bet it will end up being relied upon, so I would prefer
>>>> to have a solid reason for introducing this new VM type.
>>>
>>> The more I think about it, I agree with you. I think that reasonable
>>> behavior (for kvm/arm64) would be to allow using guest_memfd with all
>>> VM types. If the VM type is a non-protected type, then its memory is
>>> considered shared by default and is mappable --- as long as the
>>> kconfig option is enabled. If VM is protected then the memory is not
>>> shared by default.
>>>
>>> What do you think Patrick? Do you need an explicit VM type?
>>
>> Mhh, no, if "normal" VMs support guest_memfd, then that works too. I
>> suggested the VM type because that's how x86 works
>> (KVM_X86_SW_PROTECTED_VM), but never actually stopped to think about
>> whether it makes sense for ARM. Maybe Sean knows something we're missing?
>>
>> I wonder whether having the "default sharedness" depend on the vm type
>> works out though - whether a range of gmem is shared or private is a
>> property of the guest_memfd instance, not the VM it's attached to, so I
>> guess the default behavior needs to be based solely on the guest_memfd
>> as well (and then if someone tries to attach a gmem to a VM whose desire
>> of protection doesnt match the guest_memfd's configuration, that
>> operation would fail)?
> 
> Each guest_memfd is associated with a KVM instance. Although it could
> migrate, it would be weird for a guest_memfd instance to migrate
> between different types of VM, or at least, migrate between VMs that
> have different confidentiality requirements.

Ahh, right, I keep forgetting that CREATE_GUEST_MEMFD() is a vm ioctl. My
bad, sorry!

>> Tangentially related, does KVM_GMEM_SHARED to you mean "guest_memfd also
>> supports shared sections", or "guest_memfd does not support private
>> memory anymore"? (the difference being that in the former, then
>> KVM_GMEM_SHARED would later get the ability to convert ranges private,
>> and the EOPNOSUPP is just a transient state until conversion support is
>> merged) - doesnt matter for my usecase, but I got curious as some other
>> threads implied the second option to me and I ended up wondering why.
> 
> My thinking (and implementation in the other patch series) is that
> KVM_GMEM_SHARED (back then called KVM_GMEM_MAPPABLE) allows sharing in
> place/mapping, without adding restrictions.

That makes sense to me, thanks for the explanation!

> Cheers,
> /fuad
> 
>> Best,
>> Patrick
>>
>>> Cheers,
>>> /fuad
>>>
>>>> Cheers,
>>>> Quentin


