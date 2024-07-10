Return-Path: <kvm+bounces-21316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D528A92D50A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F0CC1F23231
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B425610A09;
	Wed, 10 Jul 2024 15:34:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCC113AD07;
	Wed, 10 Jul 2024 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625671; cv=none; b=MVVmCQaLtetginicKw8LW42BQsErQh1ZFDkKeF4pjIL6ilENDSwLEX29OPQKPmJZ756ycBKegmT5OSGylVRgPepOfgVX2yV02x89kFEcTsuq3qJCPW6ZScbOlkF+XwT02it6Rkw1uya1jEiIHin9ZPWqEHMnEB7mbwgLAayUDKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625671; c=relaxed/simple;
	bh=6PzCCON/Fm4+qkUpnMmXydMD9VtxdUaNuVJVRhkCw14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EgLXm7cP4Q8iKUvX/91diSOroFNUJ5oA9Rv388pTofHrFjs7SgzsvWBr6v69rH+slj2hlOkcrgNH0+qSCayu9sStpfu9lrEOcgksbGTYdJGfXYwNRCyOJo6j5yAPj8eB46+dKqv2ynFT2PDrs4lX+S44bzRmcFjtng9dh0Yo3AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CFFE106F;
	Wed, 10 Jul 2024 08:34:54 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 490933F766;
	Wed, 10 Jul 2024 08:34:21 -0700 (PDT)
Message-ID: <b6dc6c3a-cbf1-406f-a885-48eebf0c3d78@arm.com>
Date: Wed, 10 Jul 2024 16:34:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/15] arm64: realm: Query IPA size from the RMM
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-5-steven.price@arm.com>
 <20240709105325.GF12978@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240709105325.GF12978@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/07/2024 11:53, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:54AM +0100, Steven Price wrote:
>> The top bit of the configured IPA size is used as an attribute to
>> control whether the address is protected or shared. Query the
>> configuration from the RMM to assertain which bit this is.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>  * Drop unneeded extra brackets from PROT_NS_SHARED.
>>  * Drop the explicit alignment from 'config' as struct realm_config now
>>    specifies the alignment.
>> ---
>>  arch/arm64/include/asm/pgtable-prot.h | 3 +++
>>  arch/arm64/kernel/rsi.c               | 8 ++++++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
>> index b11cfb9fdd37..6c29f3b32eba 100644
>> --- a/arch/arm64/include/asm/pgtable-prot.h
>> +++ b/arch/arm64/include/asm/pgtable-prot.h
>> @@ -70,6 +70,9 @@
>>  #include <asm/pgtable-types.h>
>>  
>>  extern bool arm64_use_ng_mappings;
>> +extern unsigned long prot_ns_shared;
>> +
>> +#define PROT_NS_SHARED		(prot_ns_shared)
> 
> Since the _vast_ majority of Linux systems won't be running in a realm,
> can we use a static key to avoid loading a constant each time?

Fair enough, the following should do the trick:

#define PROT_NS_SHARED		(is_realm_world() ? prot_ns_shared : 0)

Thanks,
Steve


