Return-Path: <kvm+bounces-22038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3397938B55
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 10:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E1231F210EC
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 08:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FBF167D83;
	Mon, 22 Jul 2024 08:37:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D3135280;
	Mon, 22 Jul 2024 08:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721637455; cv=none; b=upi6Wc/+5XwsezKW7cX1GoWpl7t+ePcN9ByOb0WsJj14k7KTToPAeFYvF11e1SWRmwfDuuSNb+lyxbgfwr1MCXjpD0g2z6XN4MWGf4sklKKP5BNsqJmCY4t0V43c76KrcQ8IZeJX9Lwpr/P3O5RfmitDaBVV9RJF9fAA/eXZrNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721637455; c=relaxed/simple;
	bh=2EEZaUkorjmqtX4vo+wsyxSXw+I7qnOqGEyZXTSHmOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VUTaQb9ulSjSe1BXk+ni7nT3lLEgZUAt1D36+BWivuw1k059jY3ziPox/JCUIW4jYq2BCBIVCpBIG3gH0GHguPt7wMrEWGijY98IWjFsBEZhoFwfF4GzClSVAM6fYgeC/8Tb8u0CKmOeukJ9yGboaRsMEtajJjVvdHM0TO8MXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0FAA367;
	Mon, 22 Jul 2024 01:37:57 -0700 (PDT)
Received: from [10.162.41.8] (a077893.blr.arm.com [10.162.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5E803F73F;
	Mon, 22 Jul 2024 01:37:28 -0700 (PDT)
Message-ID: <85b781d6-c3b0-49d8-8839-33d606724d02@arm.com>
Date: Mon, 22 Jul 2024 14:07:24 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/sysreg: Correct the values for GICv4.1
To: Zenghui Yu <yuzenghui@huawei.com>,
 Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240718215532.616447-1-rananta@google.com>
 <ab66968b-3d56-caec-cfe1-b509307caf94@huawei.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ab66968b-3d56-caec-cfe1-b509307caf94@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/21/24 14:59, Zenghui Yu wrote:
> On 2024/7/19 5:55, Raghavendra Rao Ananta wrote:
>> Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
>> ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
>> Hence, correct them to reflect ARM ARM.
>>
>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>> ---
>>  arch/arm64/tools/sysreg | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index a4c1dd4741a47..7ceaa1e0b4bc2 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -149,7 +149,7 @@ Res0    63:32
>>  UnsignedEnum    31:28    GIC
>>      0b0000    NI
>>      0b0001    GICv3
>> -    0b0010    GICv4p1
>> +    0b0011    GICv4p1
>>  EndEnum
>>  UnsignedEnum    27:24    Virt_frac
>>      0b0000    NI
>> @@ -903,7 +903,7 @@ EndEnum
>>  UnsignedEnum    27:24    GIC
>>      0b0000    NI
>>      0b0001    IMP
>> -    0b0010    V4P1
>> +    0b0011    V4P1
>>  EndEnum
>>  SignedEnum    23:20    AdvSIMD
>>      0b0000    IMP
> 
> Fortunately there is no user for this bit inside kernel. We had checked
> against the correct hard-coded value (0x3) in gic_cpuif_has_vsgi().

which probably helped this problem to be left unnoticed till now :) but I
guess it would be better to use ID_AA64PFR0_EL1_GIC_V4P1 there instead.

> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> 

