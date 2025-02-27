Return-Path: <kvm+bounces-39559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAF4A47AAE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 11:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A690172A4E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 10:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5649122AE41;
	Thu, 27 Feb 2025 10:45:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291CB227E95;
	Thu, 27 Feb 2025 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740653155; cv=none; b=H6cjadiRLBT2AIG/447+poD4CRiDqfNQs+xmf6wXUugMAfkGfZgPcb/oocWAhBAqqUfhAL+Con5S1Aio6pstxARkIlhCVg/CiXdykzDhhxBLPUBLGwgHRwOkzWbRkpx6TjNL7NJqXShjg9yUSAWxLEtydKsh7FM6oF3Wnpu4Gpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740653155; c=relaxed/simple;
	bh=rl7PDQVu9xbZVpMs2pbjVuHwz+EkGPkkI2IIJhdpEU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lDQHrafTDfuxu8deZcNMpXXsL6Dd2GtVzDCCce9OoT8JjCCT2K7ZJG9ipVk8LGHXzJCAiAJSubQQBJQymLl9l7nMRNYQ0V3joylmsqqJUCNhAoXFvPr2MkluHJQk8RX9tHOJcxlXpDC0N/5wtq4eK6xJ9+LXa/PuAx1bWsrviZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F03E12BCC;
	Thu, 27 Feb 2025 02:46:08 -0800 (PST)
Received: from [10.1.30.50] (e122027.cambridge.arm.com [10.1.30.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6B373F673;
	Thu, 27 Feb 2025 02:45:48 -0800 (PST)
Message-ID: <aec8ecd9-55b0-4690-9c54-780fc47643bc@arm.com>
Date: Thu, 27 Feb 2025 10:45:46 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/11] arm64: Enable memory encrypt for Realms
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-10-steven.price@arm.com>
 <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com> <Z79lZdYqWINaHfrp@arm.com>
 <20250227002330.GA24899@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20250227002330.GA24899@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/02/2025 00:23, Will Deacon wrote:
> On Wed, Feb 26, 2025 at 07:03:01PM +0000, Catalin Marinas wrote:
>> On Wed, Feb 19, 2025 at 02:30:28PM +0000, Steven Price wrote:
>>>> @@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
>>>>  bool can_set_direct_map(void)
>>>>  {
>>>>  	/*
>>>> -	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
>>>> -	 * mapped at page granularity, so that it is possible to
>>>> +	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
>>>> +	 * map to be mapped at page granularity, so that it is possible to
>>>>  	 * protect/unprotect single pages.
>>>>  	 *
>>>>  	 * KFENCE pool requires page-granular mapping if initialized late.
>>>> +	 *
>>>> +	 * Realms need to make pages shared/protected at page granularity.
>>>>  	 */
>>>>  	return rodata_full || debug_pagealloc_enabled() ||
>>>> -	       arm64_kfence_can_set_direct_map();
>>>> +		arm64_kfence_can_set_direct_map() || is_realm_world();
>>>>  }
>>>
>>> Aneesh pointed out that this call to is_realm_world() is now too early 
>>> since the decision to delay the RSI detection. The upshot is that a 
>>> realm guest which doesn't have page granularity forced for other reasons 
>>> will fail to share pages with the host.
>>>
>>> At the moment I can think of a couple of options:
>>>
>>> (1) Make rodata_full a requirement for realm guests. 
>>>     CONFIG_RODATA_FULL_DEFAULT_ENABLED is already "default y" so this 
>>>     isn't a big ask.
>>>
>>> (2) Revisit the idea of detecting when running as a realm guest early. 
>>>     This has the advantage of also "fixing" earlycon (no need to 
>>>     manually specify the shared-alias of an unprotected UART).
>>>
>>> I'm currently leaning towards (1) because it's the default anyway. But 
>>> if we're going to need to fix earlycon (or indeed find other similar 
>>> issues) then (2) would obviously make sense.
>>
>> I'd go with (1) since the end result is the same even if we implemented
>> (2) - i.e. we still avoid block mappings in realms.
> 
> Is it, though? The config option is about the default behaviour but there's
> still an "rodata=" option on the command-line.

I think the question comes down to is there any value in having page
mappings and not setting the read-only permissions? I.e.
rodata_full=false but we're still avoiding block mappings.

(1) as I've currently proposed doesn't allow that combination - if you
disable rodata_full you also break realms (assuming
DEBUG_PAGEALLOC/kfence don't otherwise force can_set_direct_map().

(2) forces page mappings if there's an RMM present, but does allow
disabling the read-only permissions with "rodata=".

So I guess there's also another option:

(3) Provide another compile/command line flag which forces page mapping
which is different from rodata_full. That would then allow realms
without affecting the permissions.

or indeed:

(4) Change can_set_direct_map() to always return true! ;)

Thanks,
Steve


