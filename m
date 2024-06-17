Return-Path: <kvm+bounces-19787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7492890B42C
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A0461C22A0A
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C8016B381;
	Mon, 17 Jun 2024 14:55:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345841684AD;
	Mon, 17 Jun 2024 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718636130; cv=none; b=bcm4EsDyJJqb7Q9Q/I/VhFSpmW1UVjoLkcOtK3emm5NyjuBxcnp07FUk8DFa5PDIbSgUWv6fAaBsdYygsIJ80+k7JufkxUHvCFhHu06I7ZdK/rNycvsAxXRX8y9JNONA9h3G9cMFEInI9V95UQ0alRNEms9RooELArzbRamVzIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718636130; c=relaxed/simple;
	bh=iJk9/d6zOeqXjwm67Z4BMaoI35+DzOEtZYOajmU5ReQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OipfdGsXC/KhFksdRoepWK0xxFaXk3IOOJBoT7Tpoa8hYORrrYY9T3A5LKLPIYAXBWiu+yKl+oyoxjH2QsJBChCtyYk2eMdTZElF8xkEtXFpklgXmaNzCORv1ik4LT32lN//ckEhCsBDNPnD6w3BF8LfEXxk6jrfIC9aPJPbEEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29177DA7;
	Mon, 17 Jun 2024 07:55:52 -0700 (PDT)
Received: from [10.57.72.20] (unknown [10.57.72.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2528D3F6A8;
	Mon, 17 Jun 2024 07:55:24 -0700 (PDT)
Message-ID: <1dd92421-8eba-48db-99da-4390d9e19abd@arm.com>
Date: Mon, 17 Jun 2024 15:55:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/14] arm64: Force device mappings to be non-secure
 shared
Content-Language: en-GB
To: Michael Kelley <mhklinux@outlook.com>, Steven Price
 <steven.price@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-11-steven.price@arm.com>
 <SN6PR02MB4157D26A6CE9B3B96032A1D1D4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <SN6PR02MB4157D26A6CE9B3B96032A1D1D4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/06/2024 04:33, Michael Kelley wrote:
> From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:30 AM
>>
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Device mappings (currently) need to be emulated by the VMM so must be
>> mapped shared with the host.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 11d614d83317..c986fde262c0 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -644,7 +644,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
>>   #define pgprot_writecombine(prot) \
>>   	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
>>   #define pgprot_device(prot) \
>> -	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
>> +	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)
>>   #define pgprot_tagged(prot) \
>>   	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED))
>>   #define pgprot_mhp	pgprot_tagged
> 
> In v2 of the patches, Catalin raised a question about the need for
> pgprot_decrypted(). What was concluded? It still looks to me like
> pgprot_decrypted() and prot_encrypted() are needed, by
> dma_direct_mmap() and remap_oldmem_pfn_range(), respectively.
> Also, assuming Hyper-V supports CCA at some point, the Linux guest
> drivers for Hyper-V need pgprot_decrypted() in hv_ringbuffer_init().

Right, I think we could simply do :

diff --git a/arch/arm64/include/asm/pgtable.h 
b/arch/arm64/include/asm/pgtable.h
index c986fde262c0..1ed45893d1e6 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -648,6 +648,10 @@ static inline void set_pud_at(struct mm_struct *mm, 
unsigned long addr,
  #define pgprot_tagged(prot) \
         __pgprot_modify(prot, PTE_ATTRINDX_MASK, 
PTE_ATTRINDX(MT_NORMAL_TAGGED))
  #define pgprot_mhp     pgprot_tagged
+
+#define pgprot_decrypted(prot) __pgprot_modify(prot, PROT_NS_SHARED, 
PROT_NS_SHARED)
+#define pgprot_encrypted(prot)  __pgprot_modify(prot, PROT_NS_SHARED, 0)
+


Suzuki

