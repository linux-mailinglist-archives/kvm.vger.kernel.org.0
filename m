Return-Path: <kvm+bounces-15937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEED8B25B9
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 17:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D811EB22805
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7468714C585;
	Thu, 25 Apr 2024 15:53:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8441512B156;
	Thu, 25 Apr 2024 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714060384; cv=none; b=q24j9OylZeA+bSaXo3f/+w9AMOhMXvCuAYqFNabuqhFAAFUt+Y/qxmA4uSlWb3G95GHftMCUuoTQ4MomRdp31/bjaXN6GOTHFYbjGdHk5ndWprPEhCUC2SdQgTdJfEFyLoyHq/DFP5qK8SnC+z+pVAaFYloF9zHBtkzOUThtxm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714060384; c=relaxed/simple;
	bh=wpvhhW2gIm86VfAGnDMuFuxo/RtovAFc2eHB/QgqRRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PE4SO/jmfRGzjG0fD8FZyMSQO+dqoj6o2XEvm6mmqhEahHTlRZNPzOZ2S85iv9OZ1FulZbMB9rgxhzelFiFJnMHEGoz3R3F+wPucpG7koLfrL9IO4HW6hjmkqj6sAgi9a/SDR13hl0sGiD15URD09XrJRtj8eb7bMr653I1CCyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E112D1007;
	Thu, 25 Apr 2024 08:53:27 -0700 (PDT)
Received: from [10.57.56.40] (unknown [10.57.56.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF7D83F73F;
	Thu, 25 Apr 2024 08:52:55 -0700 (PDT)
Message-ID: <c3424195-6d9b-4d15-b5c0-f4ef1fdbf160@arm.com>
Date: Thu, 25 Apr 2024 16:52:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Emanuele.Rocca@arm.com
References: <20240412084213.1733764-10-steven.price@arm.com>
 <202404151003.vkNApJiS-lkp@intel.com>
 <f11e6d5d-d2b9-400e-96c3-5d1ded827720@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <f11e6d5d-d2b9-400e-96c3-5d1ded827720@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/04/2024 14:42, Suzuki K Poulose wrote:
> On 15/04/2024 04:13, kernel test robot wrote:
>> Hi Steven,
>>
>> kernel test robot noticed the following build errors:
>>

<snip>

>>>> drivers/hv/channel.c:442:8: error: call to undeclared function
>>>> 'set_memory_decrypted'; ISO C99 and later do not support implicit
>>>> function declarations [-Wimplicit-function-declaration]
>>       442 |         ret = set_memory_decrypted((unsigned long)kbuffer,
>>           |               ^
>>>> drivers/hv/channel.c:531:3: error: call to undeclared function
>>>> 'set_memory_encrypted'; ISO C99 and later do not support implicit
>>>> function declarations [-Wimplicit-function-declaration]
>>       531 |                 set_memory_encrypted((unsigned long)kbuffer,
>>           |                 ^
>>     drivers/hv/channel.c:848:8: error: call to undeclared function
>> 'set_memory_encrypted'; ISO C99 and later do not support implicit
>> function declarations [-Wimplicit-function-declaration]
>>       848 |         ret = set_memory_encrypted((unsigned
>> long)gpadl->buffer,
>>           |               ^
>>     5 warnings and 3 errors generated.
> 
> Thats my mistake. The correct place for declaring set_memory_*crypted()
> is asm/set_memory.h not asm/mem_encrypt.h.
> 
> Steven, please could you fold this patch below :

Sure, I've folded into my local branch. Thanks for looking into the error.

Steve

> 
> diff --git a/arch/arm64/include/asm/mem_encrypt.h
> b/arch/arm64/include/asm/mem_encrypt.h
> index 7381f9585321..e47265cd180a 100644
> --- a/arch/arm64/include/asm/mem_encrypt.h
> +++ b/arch/arm64/include/asm/mem_encrypt.h
> @@ -14,6 +14,4 @@ static inline bool force_dma_unencrypted(struct device
> *dev)
>         return is_realm_world();
>  }
> 
> -int set_memory_encrypted(unsigned long addr, int numpages);
> -int set_memory_decrypted(unsigned long addr, int numpages);
>  #endif
> diff --git a/arch/arm64/include/asm/set_memory.h
> b/arch/arm64/include/asm/set_memory.h
> index 0f740b781187..9561b90fb43c 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -14,4 +14,6 @@ int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  bool kernel_page_present(struct page *page);
> 
> +int set_memory_encrypted(unsigned long addr, int numpages);
> +int set_memory_decrypted(unsigned long addr, int numpages);
> 
> 
> 
> Suzuki


