Return-Path: <kvm+bounces-17423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D70CA8C6549
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 13:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B4FE1F23FA6
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 11:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5103679E5;
	Wed, 15 May 2024 11:00:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFF25684;
	Wed, 15 May 2024 11:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715770857; cv=none; b=KW79ae24X5jAmSkRLhmpc7u+rRRQ3cEGMZYJhLuhdfKYyf9+36ewm/vsz9MdeuAvbonPDB/h1E2DwbcvTzs6mcYKZP0ndYBAJ7Pkc8BvXGuHag869c7oJvbpQOmgcsvup7MT/KhIXxvDkLWSyCS2a87pnobHwReyWW/dauu6DAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715770857; c=relaxed/simple;
	bh=J0syEP7m8ViRgWIbwy/RsJt/oCEtIdMONMLqCdV2agU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jqByRfHTbxBwpEeKGeEC4SDI21uujGeTp8IukEZZD/YEPSpIAOI4EfJ4UFqiQWu/VLrzSvBpH2o6DgU2Kq/hFH0x3cLtJIYEcpcnTOVTJa+XXSsWOKm9dqXKZXJTV03t66nydAUq0bi7gmTRIjW68/sZOx+lEHDcbWchqdjztHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56E141042;
	Wed, 15 May 2024 04:01:18 -0700 (PDT)
Received: from [10.57.34.212] (unknown [10.57.34.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC2293F762;
	Wed, 15 May 2024 04:00:50 -0700 (PDT)
Message-ID: <4e89f047-ae70-43a8-a459-e375ca05b2c2@arm.com>
Date: Wed, 15 May 2024 12:00:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/14] arm64: Force device mappings to be non-secure
 shared
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-11-steven.price@arm.com> <ZkR535Hmh3WkMYai@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZkR535Hmh3WkMYai@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/05/2024 10:01, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:09AM +0100, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Device mappings (currently) need to be emulated by the VMM so must be
>> mapped shared with the host.
> 
> You say "currently". What's the plan when the device is not emulated?
> How would the guest distinguish what's emulated and what's not to avoid
> setting the PROT_NS_SHARED bit?

Arm CCA plans to add support for passing through real devices,
which support PCI-TDISP protocol. This would involve the Realm
authenticating the device and explicitly requesting "protected"
mapping *after* the verification (with the help of RMM).




> 
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index f5376bd567a1..db71c564ec21 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -598,7 +598,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
>>   #define pgprot_writecombine(prot) \
>>   	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
>>   #define pgprot_device(prot) \
>> -	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
>> +	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)
> 
> This pgprot_device() is not the only one used to map device resources.
> pgprot_writecombine() is another commonly macro. It feels like a hack to
> plug one but not the other and without any way for the guest to figure
> out what's emulated.

Agree. I have been exploring hooking this into ioremap_prot() where we
could apply the attribute accordingly. We will change it in the next 
version.

> 
> Can the DT actually place those emulated ranges in the higher IPA space
> so that we avoid randomly adding this attribute for devices?

It can, but then we kind of break the "Realm" view of the IPA space. 
i.e., right now it only knows about the "lower IPA" half and uses the 
top bit as a protection attr to access the IPA as shared.

Expanding IPA size view kind of breaks "sharing memory", where, we
must "use a different PA" for a page that is now shared.

Suzuki



