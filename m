Return-Path: <kvm+bounces-15938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D05A58B25CF
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 17:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECECCB23689
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8526A14BF9B;
	Thu, 25 Apr 2024 15:58:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D0D149E05;
	Thu, 25 Apr 2024 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714060699; cv=none; b=DIH/nzbh+6rKR85ZEXNI095l90hDW1aYxPlJNwAygP88Kjq1YKUPK1hpfVnUXG8/ydm1oZGmOXk4lkikkQfIsZloL5FRAEDHx5ddNKS7k0Jl2plvHKN2wcWQ1MHg3qqLkIVDuWsSlGcFNqHAnyMZVY6eNeB4AHokT8trk9ez8Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714060699; c=relaxed/simple;
	bh=f2EiSgp8zlHR9yB6BJrFYtDILE/zqRT/fk/hI9IqEgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mlt2CSi12NtJ7vncCl89tTY+s1Je8dSjO0Y5HApQoYK7X9n3S52f+Ek0GkhgIvmb8ROSEIiUq66kbNVohh59FvGFNxzulx8EgZLuV90VXSQd+kzIYClEiln7yKQVV/h4Klz49PEcsqi4G+yxV6HM5FUrJuXC/6HSKXRwAH9cODo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 399DA1007;
	Thu, 25 Apr 2024 08:58:45 -0700 (PDT)
Received: from [10.57.56.40] (unknown [10.57.56.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 166443F73F;
	Thu, 25 Apr 2024 08:58:13 -0700 (PDT)
Message-ID: <4195a811-7084-42fe-ad10-27d898fb3196@arm.com>
Date: Thu, 25 Apr 2024 16:58:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/43] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Sean Christopherson <seanjc@google.com>,
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
 <20240412084309.1733783-2-steven.price@arm.com>
 <CA+EHjTwDaP6qULmjEGH=Eye=vjFikr9iJHEyzzX+cr_sH57vcA@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTwDaP6qULmjEGH=Eye=vjFikr9iJHEyzzX+cr_sH57vcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/04/2024 10:48, Fuad Tabba wrote:
> Hi,
> 
> On Fri, Apr 12, 2024 at 9:43 AM Steven Price <steven.price@arm.com> wrote:
>>
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Add flags to "struct kvm_gfn_range" to let notifier events target only
>> shared and only private mappings, and write up the existing mmu_notifier
>> events to be shared-only (private memory is never associated with a
>> userspace virtual address, i.e. can't be reached via mmu_notifiers).
>>
>> Add two flags so that KVM can handle the three possibilities (shared,
>> private, and shared+private) without needing something like a tri-state
>> enum.
>>
>> Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  include/linux/kvm_host.h | 2 ++
>>  virt/kvm/kvm_main.c      | 7 +++++++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 48f31dcd318a..c7581360fd88 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -268,6 +268,8 @@ struct kvm_gfn_range {
>>         gfn_t start;
>>         gfn_t end;
>>         union kvm_mmu_notifier_arg arg;
>> +       bool only_private;
>> +       bool only_shared;
>>         bool may_block;
>>  };
>>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index fb49c2a60200..3486ceef6f4e 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -633,6 +633,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>>                          * the second or later invocation of the handler).
>>                          */
>>                         gfn_range.arg = range->arg;
>> +
>> +                       /*
>> +                        * HVA-based notifications aren't relevant to private
>> +                        * mappings as they don't have a userspace mapping.
>> +                        */
>> +                       gfn_range.only_private = false;
>> +                       gfn_range.only_shared = true;
>>                         gfn_range.may_block = range->may_block;
> 
> I'd discussed this with Sean when he posted this earlier. Having two
> booleans to encode three valid states could be confusing. In response,
> Sean suggested using an enum instead:
> https://lore.kernel.org/all/ZUO1Giju0GkUdF0o@google.com/

That would work fine too! Unless I've missed it Sean hasn't posted an
updated patch. My assumption is that this will get merged (in whatever
form) before the rest of the series as part of that other series. It
shouldn't be too hard to adapt.

Thanks,

Steve

> Cheers,
> /fuad
> 
>>
>>                         /*
> 
> 
>> --
>> 2.34.1
>>
> 


