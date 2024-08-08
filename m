Return-Path: <kvm+bounces-23608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D2494BA20
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 11:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00805282D80
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 09:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17C2189BAF;
	Thu,  8 Aug 2024 09:54:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10263146A93;
	Thu,  8 Aug 2024 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723110873; cv=none; b=HnUGzx9Y+4Fsejnqv23h4bDsFisSxseTuZfA/p4DwlTRiiuMByH92uiFbAaaSoOljm2ypRZcniFKy7JanesevDwSd1qm7lGWMXsflJOH4Fxp01z4FWJ09p2it+zzt6p6F9P5+tbuiWAEr8587T2W0C+2t5frN6ra6LyuuqVPurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723110873; c=relaxed/simple;
	bh=PbFKdQioBXqrCR8IhPsvdeiSsqZdtgzRJibcfIc0ipk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3i12vyK7iFx2RXOLNFURxRiA2lR6+2HX0oUpSFE7195SLlh+VXqGN2JL9+Pc1983uVsyjNevXNm3qB4pBMKEVxYxMxL5ANr880UidNK2hf/HMZ1lDnVeRr++R4xiwnU1MiLKcbvP72ueosRNeaSaCRraRt0TKxp1Bg5gpFzGvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E8C0DA7;
	Thu,  8 Aug 2024 02:54:55 -0700 (PDT)
Received: from [10.1.26.21] (e122027.cambridge.arm.com [10.1.26.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 632F73F6A8;
	Thu,  8 Aug 2024 02:54:23 -0700 (PDT)
Message-ID: <34468ff8-2159-4adb-b680-c6048eecee80@arm.com>
Date: Thu, 8 Aug 2024 10:54:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if
 copying MTE tags hits ZONE_DEVICE
To: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-2-seanjc@google.com> <ZrOBg70pCnv7PHyK@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZrOBg70pCnv7PHyK@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/08/2024 15:15, Catalin Marinas wrote:
> On Fri, Jul 26, 2024 at 04:51:10PM -0700, Sean Christopherson wrote:
>> Put the page reference acquired by gfn_to_pfn_prot() if
>> kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
>> than-stellar heuristics for dealing with pfn-mapped memory means that KVM
>> can get a page reference to ZONE_DEVICE memory.
>>
>> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/arm64/kvm/guest.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 11098eb7eb44..e1f0ff08836a 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>>  		page = pfn_to_online_page(pfn);
>>  		if (!page) {
>>  			/* Reject ZONE_DEVICE memory */
>> +			kvm_release_pfn_clean(pfn);
>>  			ret = -EFAULT;
>>  			goto out;
>>  		}
> 
> This patch makes sense irrespective of whether the above pfn is a
> ZONE_DEVICE or not. gfn_to_pfn_prot() increased the page refcount via
> GUP, so it must be released before bailing out of this loop.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 

Yep, as Catalin says, this is an 'obviously' correct fix - the reference
needs releasing before bailing out. The comment there is perhaps
misleading - it's not just ZONE_DEVICE memory that will be rejected, but
this is the case that was in my mind when I wrote it. Although clearly I
wasn't thinking hard enough when writing the code in the first place... ;)

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

