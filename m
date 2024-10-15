Return-Path: <kvm+bounces-28864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEB299E242
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 542071C21ADC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 09:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050B71C8787;
	Tue, 15 Oct 2024 09:08:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302ED1741D4;
	Tue, 15 Oct 2024 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728983313; cv=none; b=B8oukx2wFzkQjizgdBLhaDnmASgSRxY2R/1uZH1SS7DlqfPgu4FCLUYRXpE5sxEisveROHQ5I14HjMigXICMpYpVmbCJORcNrAeYn2HaUJAGxcC/UbFTfVqKqSY+25g3QFXpDS/BskqCPNtEhzJ7cAkaE4O9R/rD9RMWZ5VHFkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728983313; c=relaxed/simple;
	bh=283QZq5IAbGhv0OVut1nalndoywJzzjatqkhXYC1l9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bbh8/BUJxugYHdhwuAxCk3+WITOHUKDWqEuVWyDa1l7peKbUhp28fv33RiUD3zhGA0EoqUr3gvC6w9T+hD62B7FXG8QjGlwo6YDDlExBoZiqO9nsFIYBtcqiy1djoQZiZAmb6KVQmnUDSOAQ7WJChh+HjkQfHibtYn50c3ZPoE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBFCF1007;
	Tue, 15 Oct 2024 02:08:59 -0700 (PDT)
Received: from [10.1.30.47] (e122027.cambridge.arm.com [10.1.30.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 076173F51B;
	Tue, 15 Oct 2024 02:08:25 -0700 (PDT)
Message-ID: <e69536dd-aab2-49de-a026-506e09359207@arm.com>
Date: Tue, 15 Oct 2024 10:08:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/11] arm64: realm: Query IPA size from the RMM
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-4-steven.price@arm.com>
 <2352629a-3742-45e9-a38f-196989918c9b@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <2352629a-3742-45e9-a38f-196989918c9b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 15/10/2024 04:55, Gavin Shan wrote:
> On 10/5/24 12:42 AM, Steven Price wrote:
>> The top bit of the configured IPA size is used as an attribute to
>> control whether the address is protected or shared. Query the
>> configuration from the RMM to assertain which bit this is.
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v4:
>>   * Make PROT_NS_SHARED check is_realm_world() to reduce impact on
>>     non-CCA systems.
>> Changes since v2:
>>   * Drop unneeded extra brackets from PROT_NS_SHARED.
>>   * Drop the explicit alignment from 'config' as struct realm_config now
>>     specifies the alignment.
>> ---
>>   arch/arm64/include/asm/pgtable-prot.h | 4 ++++
>>   arch/arm64/include/asm/rsi.h          | 2 +-
>>   arch/arm64/kernel/rsi.c               | 8 ++++++++
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index 9bf757b4b00c..a6495a64d9bb 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -8,6 +8,11 @@
>>   #include <linux/psci.h>
>>   #include <asm/rsi.h>
>>   +struct realm_config config;
>> +
> 
> Nit: I think this variable is file-scoped since it has a generic name.
> In this case, 'static' is needed to match with the scope.

Good spot - it should definitely be static.

Thanks,
Steve

>> +unsigned long prot_ns_shared;
>> +EXPORT_SYMBOL(prot_ns_shared);
>> +
>>   DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>>   EXPORT_SYMBOL(rsi_present);
>>   @@ -67,6 +72,9 @@ void __init arm64_rsi_init(void)
>>           return;
>>       if (!rsi_version_matches())
>>           return;
>> +    if (WARN_ON(rsi_get_realm_config(&config)))
>> +        return;
>> +    prot_ns_shared = BIT(config.ipa_bits - 1);
>>         arm64_rsi_setup_memory();
>>   
> 
> Thanks,
> Gavin
> 


