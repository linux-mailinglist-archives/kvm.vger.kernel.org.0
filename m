Return-Path: <kvm+bounces-22659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0393B940FB3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8083284B94
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A8A19DFA5;
	Tue, 30 Jul 2024 10:36:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AE019DF6E;
	Tue, 30 Jul 2024 10:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722335780; cv=none; b=GPjNUU44cQ0laO64hhn+N+AGgtaRc8ZlVAgaNKI3bKO9y/W3V8UXgV+BfIYajKUAe9qURoqbO1CWw0E7qaSY+d69MwCuIfVcJIg7yLKyTh7nlbkkbCJGP55+kDANsu0JPIZ0MzNzctvGsr7Arq+waj8gYaxpuqomhZsxCc8wNKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722335780; c=relaxed/simple;
	bh=RfiwyEUsPb8tPAYC80PiZ5qOL/iGu9KCxcDr+2YKA6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KmbflGyPBCeNv3mfa/LcsghlBfQ7na0zPzsubcTo/RRNUNiqMHl0KKdieUi33ZqpHGv/DThVRzGTCebg+6AUSyVH1y8AgraCROmeBFE5sZSU09QFGLdkGmUUUyqLnl8rqLOIvwEgVWD6S0WEmIzK6rq/DrEPjk3/3W3P6++uMfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E68F1007;
	Tue, 30 Jul 2024 03:36:42 -0700 (PDT)
Received: from [10.57.94.83] (unknown [10.57.94.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 116653F766;
	Tue, 30 Jul 2024 03:36:13 -0700 (PDT)
Message-ID: <e05d2363-d3e4-4a23-9347-723454d603c9@arm.com>
Date: Tue, 30 Jul 2024 11:36:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-6-steven.price@arm.com>
 <b20b7e5b-95aa-4fdb-88a7-72f8aa3da8db@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <b20b7e5b-95aa-4fdb-88a7-72f8aa3da8db@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin,

Thanks for looking at the patch. Responses inline.

On 30/07/2024 02:36, Gavin Shan wrote:
> On 7/1/24 7:54 PM, Steven Price wrote:
>> All I/O is by default considered non-secure for realms. As such
>> mark them as shared with the host.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v3:
>>   * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
>>     set_fixmap_io() with a custom function.
>>   * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
>> ---
>>   arch/arm64/include/asm/fixmap.h | 2 +-
>>   arch/arm64/include/asm/io.h     | 8 ++++----
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
> 
> I'm unable to understand this. Steven, could you please explain a bit how
> PROT_NS_SHARED is turned to a shared (non-secure) mapping to hardware?
> According to tf-rmm's implementation in 
> tf-rmm/lib/s2tt/src/s2tt_pvt_defs.h,
> a shared (non-secure) mapping is is identified by NS bit (bit#55). I find
> difficulties how the NS bit is correlate with PROT_NS_SHARED. For example,
> how the NS bit is set based on PROT_NS_SHARED.


There are two things at play here :

1. Stage1 mapping controlled by the Realm (Linux in this case, as above).
2. Stage2 mapping controlled by the RMM (with RMI commands from NS Host).

Also :
The Realm's IPA space is divided into two halves (decided by the IPA 
Width of the Realm, not the NSbit #55), protected (Lower half) and
Unprotected (Upper half). All stage2 mappings of the "Unprotected IPA"
will have the NS bit (#55) set by the RMM. By design, any MMIO access
to an unprotected half is sent to the NS Host by RMM and any page
the Realm wants to share with the Host must be in the Upper half
of the IPA.

What we do above is controlling the "Stage1" used by the Linux. i.e,
for a given VA, we flip the Guest "PA" (in reality IPA) to the
"Unprotected" alias.

e.g., DTB describes a UART at address 0x10_0000 to Realm (with an IPA 
width of 40, like in the normal VM case), emulated by the host. Realm is
trying to map this I/O address into Stage1 at VA. So we apply the
BIT(39) as PROT_NS_SHARED while creating the Stage1 mapping.

ie., VA == stage1 ==> BIT(39) | 0x10_0000 =(IPA)== > 0x80_10_0000

Now, the Stage2 mapping won't be present for this IPA if it is emulated
and thus an access to "VA" causes a Stage2 Abort to the Host, which the
RMM allows the host to emulate. Otherwise a shared page would have been
mapped by the Host (and NS bit set at Stage2 by RMM), allowing the
data to be shared with the host.

Does that answer your question ?

Suzuki

> 
>> diff --git a/arch/arm64/include/asm/fixmap.h 
>> b/arch/arm64/include/asm/fixmap.h
>> index 87e307804b99..f2c5e653562e 100644
>> --- a/arch/arm64/include/asm/fixmap.h
>> +++ b/arch/arm64/include/asm/fixmap.h
>> @@ -98,7 +98,7 @@ enum fixed_addresses {
>>   #define FIXADDR_TOT_SIZE    (__end_of_fixed_addresses << PAGE_SHIFT)
>>   #define FIXADDR_TOT_START    (FIXADDR_TOP - FIXADDR_TOT_SIZE)
>> -#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
>> +#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>   void __init early_fixmap_init(void);
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 4ff0ae3f6d66..07fc1801c6ad 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void 
>> __iomem *to, const void *from,
>>   #define ioremap_prot ioremap_prot
>> -#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
>> +#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>   #define ioremap_wc(addr, size)    \
>> -    ioremap_prot((addr), (size), PROT_NORMAL_NC)
>> +    ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
>>   #define ioremap_np(addr, size)    \
>> -    ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
>> +    ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))
>>   /*
>>    * io{read,write}{16,32,64}be() macros
>> @@ -303,7 +303,7 @@ static inline void __iomem 
>> *ioremap_cache(phys_addr_t addr, size_t size)
>>       if (pfn_is_map_memory(__phys_to_pfn(addr)))
>>           return (void __iomem *)__phys_to_virt(addr);
>> -    return ioremap_prot(addr, size, PROT_NORMAL);
>> +    return ioremap_prot(addr, size, PROT_NORMAL | PROT_NS_SHARED);
>>   }
>>   /*
> 
> Thanks,
> Gavin
> 


