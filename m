Return-Path: <kvm+bounces-18541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 041558D6643
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 18:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEF8929091F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 16:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D0115887C;
	Fri, 31 May 2024 16:04:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A8432C8C;
	Fri, 31 May 2024 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717171442; cv=none; b=B6gaa13HQmbt1v0U4qHhaS4djNuNMxfm+KdOaBZUu3W/8C2u/sBlu3r+P9WbLL/8VHeCfHut+0X3M/f04n5pBjeXUIfPg55W0SKrMJjlQqI52nUDabChEL6RR2pSt2oud49/uY3Y0OATAcTQITYx8QqzkpWBt0h79pmQGqtefWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717171442; c=relaxed/simple;
	bh=IFUjXMQpAq5HwdlN0F4Ro/EwDdykkZC4cPHBidBAlvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZfMmBduE8GkzDx1D6m1HCUZoZKKl3elO9Foeg5Tq0mVZeesZFus7Sq/zbisTsToXxkyIHa/PpdeAkAmAjcThSz/7zrxyjtnAtmzD3O2Cg6dJoFdUn8baaEC4wAYFGwtwE22/wpCcFSvBNx5msDyQcc3YTTr9K7FwPctA4XUxzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A6631424;
	Fri, 31 May 2024 09:04:24 -0700 (PDT)
Received: from [10.1.27.19] (e122027.cambridge.arm.com [10.1.27.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A9A33F792;
	Fri, 31 May 2024 09:03:56 -0700 (PDT)
Message-ID: <ab2ac224-ec8f-423a-80ce-0d7b18a7a173@arm.com>
Date: Fri, 31 May 2024 17:03:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 21/43] arm64: RME: Runtime faulting of memory
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-22-steven.price@arm.com>
 <CA+EHjTyr1swQ4ONE2oVnWU5uPkcq2WDNYDRA8eK29-4BQDcCLw@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTyr1swQ4ONE2oVnWU5uPkcq2WDNYDRA8eK29-4BQDcCLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/04/2024 11:43, Fuad Tabba wrote:
> Hi,

Hi,

Thanks for the review. Sorry I didn't respond earlier.

> On Fri, Apr 12, 2024 at 9:44 AM Steven Price <steven.price@arm.com> wrote:
>>
<snip>
>> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
>> +                                phys_addr_t fault_ipa,
>> +                                struct kvm_memory_slot *memslot)
>> +{
>> +       struct kvm *kvm = vcpu->kvm;
>> +       gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
>> +       gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>> +       bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
>> +       bool priv_exists = kvm_mem_is_private(kvm, gfn);
>> +       struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +       int order;
>> +       kvm_pfn_t pfn;
>> +       int ret;
>> +
>> +       if (priv_exists != is_priv_gfn) {
>> +               kvm_prepare_memory_fault_exit(vcpu,
>> +                                             fault_ipa & ~gpa_stolen_mask,
>> +                                             PAGE_SIZE,
>> +                                             kvm_is_write_fault(vcpu),
>> +                                             false, is_priv_gfn);
>> +
>> +               return 0;
>> +       }
>> +
>> +       if (!is_priv_gfn) {
>> +               /* Not a private mapping, handling normally */
>> +               return -EAGAIN;
>> +       }
>> +
>> +       if (kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &order))
>> +               return 1; /* Retry */
> 
> You don't need to pass a variable to hold the order if you don't need
> it. You can pass NULL.

Ah, good point - that simplifies things.

> I am also confused about the return, why do you return 1 regardless of
> the reason kvm_gmem_get_pfn() fails?

Thinking about this, I don't think we actually expect kvm_gmem_get_pfn()
to fail, so it's actually more appropriate to just pass return any error
value.

>> +       ret = kvm_mmu_topup_memory_cache(memcache,
>> +                                        kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +       if (ret)
>> +               return ret;
> 
> If this fails you should release the page you got earlier (e.g.,
> kvm_release_pfn_clean()), or you could move it before
> kvm_gmem_get_pfn().

Good point, however...

>> +       /* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
>> +       ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
>> +                            memcache);
>> +       if (!ret)
>> +               return 1; /* Handled */
> 
> Should also release the page if it fails. Speaking of which,
> where/when do you eventually release the page?

... I messed this up ;) It seems I'm managing to leak all guestmem
pages. I'm not sure what I was thinking but I think I'd got it into my
head guestmem wasn't reference counting the pages. I'll fix this up in
the next version.

Thanks,

Steve


