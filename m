Return-Path: <kvm+bounces-37892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F6EA31188
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3ED5F7A2A64
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E235255E32;
	Tue, 11 Feb 2025 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="HlmdOvyF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DE6253F0D;
	Tue, 11 Feb 2025 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739291568; cv=none; b=KOc+N02IrTOr02sOqlLB4zxkURFPZ4PQrejqo/mPbsAa8rhrAVLmmO1TcSUhgrMyCI7pHw5eNXcwxTqLRpaOx9/XWHMsGc1xDtweSYn7gPn2ZraXFeehw8glK78LKIu1M1BCI2ZA0GBpDktrEjSbfQPVOi8LEx3V0Xs5sJAbIjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739291568; c=relaxed/simple;
	bh=gIPhdKcjyZT9aSJLPxACHmhEGbu/IggQFQd1f408M70=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jFlcNqPdCSMb7EA3A5Z8pXcMPs/WycGo2IuR8pEtWGjvLpEioctRzwcguSi6VxnUcIsxHofHnry+SC5OPNJ8TeArKhEEHLtQfrkzNg6ZbdIY6dWdtCxZufXhSECgaHTxiV32dg1IxJuVBKCpDA77Rp0TDqBDOtT0ybyKah2+RU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=HlmdOvyF; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1739291567; x=1770827567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ygKk6wEbpUicyoqA5WJDKNaCGBqqq7EW/hGr67EMYIE=;
  b=HlmdOvyFbeccX+lL9iu1oSYVoEZwTRnAbTa8D9VzN688ulClr2S1i4VJ
   KyshqTzJnrSiEq4v/YIfvbiliGiU80++wvaYpqOLnlIwuwQbgCH5jkPVB
   ClN44H6e2CQKjJcWMrsK8sYWu8SS+rVskiqYqM17LchXF2x5EJqWlsXFY
   U=;
X-IronPort-AV: E=Sophos;i="6.13,278,1732579200"; 
   d="scan'208";a="465958686"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 16:32:43 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.0.204:18579]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.10.217:2525] with esmtp (Farcaster)
 id 0d565f17-f1bd-495a-ba2a-b17d55c2932f; Tue, 11 Feb 2025 16:32:42 +0000 (UTC)
X-Farcaster-Flow-ID: 0d565f17-f1bd-495a-ba2a-b17d55c2932f
Received: from EX19EXOUEB001.ant.amazon.com (10.252.135.46) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 11 Feb 2025 16:32:41 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.108) by
 EX19EXOUEB001.ant.amazon.com (10.252.135.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 11 Feb 2025 16:32:41 +0000
Received: from email-imr-corp-prod-iad-all-1b-3ae3de11.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Tue, 11 Feb 2025 16:32:41 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-all-1b-3ae3de11.us-east-1.amazon.com (Postfix) with ESMTPS id 62730A0434;
	Tue, 11 Feb 2025 16:32:32 +0000 (UTC)
Message-ID: <d9645330-3a0d-4950-a50b-ce82b428e08c@amazon.co.uk>
Date: Tue, 11 Feb 2025 16:32:31 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce
 KVM_VM_TYPE_ARM_SW_PROTECTED machine type
To: Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-mm@kvack.org>, <pbonzini@redhat.com>, <chenhuacai@kernel.org>,
	<mpe@ellerman.id.au>, <anup@brainfault.org>, <paul.walmsley@sifive.com>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <seanjc@google.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
	<chao.p.peng@linux.intel.com>, <jarkko@kernel.org>, <amoorthy@google.com>,
	<dmatlack@google.com>, <yu.c.zhang@linux.intel.com>,
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
In-Reply-To: <Z6t6_M8un1Cf3nmk@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Quentin,

On Tue, 2025-02-11 at 16:29 +0000, Quentin Perret wrote:> On Tuesday 11 Feb 2025 at 16:17:25 (+0000), Fuad Tabba wrote:
>> Hi Quentin,
>>
>> On Tue, 11 Feb 2025 at 16:12, Quentin Perret <qperret@google.com> wrote:
>>>
>>> Hi Fuad,
>>>
>>> On Tuesday 11 Feb 2025 at 12:11:25 (+0000), Fuad Tabba wrote:
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index 117937a895da..f155d3781e08 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -652,6 +652,12 @@ struct kvm_enable_cap {
>>>>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK        0xffULL
>>>>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)          \
>>>>       ((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>>>> +
>>>> +#define KVM_VM_TYPE_ARM_SW_PROTECTED (1UL << 9)
>>>
>>> FWIW, the downstream Android code has used bit 31 since forever
>>> for that.
>>>
>>> Although I very much believe that upstream should not care about the
>>> downstream mess in general, in this particular instance bit 9 really
>>> isn't superior in any way, and there's a bunch of existing userspace
>>> code that uses bit 31 today as we speak. It is very much Android's
>>> problem to update these userspace programs if we do go with bit 9
>>> upstream, but I don't really see how that would benefit upstream
>>> either.
>>>
>>> So, given that there is no maintenance cost for upstream to use bit 31
>>> instead of 9, I'd vote for using bit 31 and ease the landing with
>>> existing userspace code, unless folks are really opinionated with this
>>> stuff :)
>>
>> My thinking is that this bit does _not_ mean pKVM. It means an
>> experimental software VM that is similar to the x86
>> KVM_X86_SW_PROTECTED_VM. Hence why I didn't choose bit 31.
>>
>> From Documentation/virt/kvm/api.rst (for x86):
>>
>> '''
>> Note, KVM_X86_SW_PROTECTED_VM is currently only for development and testing.
>> Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
>> production.  The behavior and effective ABI for software-protected VMs is
>> unstable.
>> '''
>>
>> which is similar to the documentation I added here.
> 
> Aha, I see, but are we going to allocate _another_ bit for protected VMs
> proper once they're supported? Or just update the doc for the existing
> bit? If the latter, then I guess this discussion can still happen :)

I was hoping that SW_PROTECTED_VM will be the VM type that something
like Firecracker could use, e.g. an interface to guest_memfd specifically
_without_ pKVM, as Fuad was saying.

> Thanks,
> Quentin

Best, 
Patrick

