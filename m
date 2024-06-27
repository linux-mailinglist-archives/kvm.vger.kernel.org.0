Return-Path: <kvm+bounces-20608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D0B91A869
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 15:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA9921C21447
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 13:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A97C19539F;
	Thu, 27 Jun 2024 13:56:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7112D14EC40;
	Thu, 27 Jun 2024 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719496590; cv=none; b=NCs3eSpXCfgGvO6EtfIFOiN4tvnONS+MBP98I8CSBQFmsYQ85sUegQCVX0JmWQ66UmE8kLpEMqpn9DW4/Kzm/HD6pCNHNzGUypBBzSpXpwnWUR0kLeHRjfH0E6j+u0Zg3HWp21kmU6FVmtg3aRyMkbTBy6eyK+Oa119pgFU9zoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719496590; c=relaxed/simple;
	bh=kYrvsf0uqKm88ZvZcePkZ49uLkndvFg7AwD2JBZhy68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPw6ffowuRaqCu4BDXQ8k7jIVpr5rm4Zoa+VilzQhXqksvHX6Sjc8VutytmnqWZ5XR0+fcfri9iyY4XEmarrgaeIVtsCHOscUGZTlcZy4U5tEzOhkVpmcggLLmCeBEBrYbmd7KK5V2wEn5x1RxbshxJcm2VdcdsUcu3lF5BaOTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABD27367;
	Thu, 27 Jun 2024 06:56:52 -0700 (PDT)
Received: from [10.1.30.72] (e122027.cambridge.arm.com [10.1.30.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FB513F73B;
	Thu, 27 Jun 2024 06:56:23 -0700 (PDT)
Message-ID: <b611bb5f-b6f8-44a4-9b33-a92862974363@arm.com>
Date: Thu, 27 Jun 2024 14:56:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] arm64: Override set_fixmap_io
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-7-steven.price@arm.com> <Zmc8x3Xvs8uu9zHp@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <Zmc8x3Xvs8uu9zHp@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/06/2024 18:49, Catalin Marinas wrote:
> On Wed, Jun 05, 2024 at 10:29:58AM +0100, Steven Price wrote:
>> +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
>> +{
>> +	pgprot_t prot = FIXMAP_PAGE_IO;
>> +
>> +	/*
>> +	 * For now we consider all I/O as non-secure. For future
>> +	 * filter the I/O base for setting appropriate permissions.
>> +	 */
>> +	prot = __pgprot(pgprot_val(prot) | PROT_NS_SHARED);
>> +
>> +	return __set_fixmap(idx, phys, prot);
>> +}
> 
> In v2, Suzuki said that we want to keep this as a function rather than
> just adding PROT_NS_SHARED to FIXMAP_PAGE_IO in case we want to change
> this function in the future to allow protected MMIO.
> 
> https://lore.kernel.org/linux-arm-kernel/6ba1fd72-3bad-44ca-810d-572b70050772@arm.com/
> 
> What I don't understand is that all the other MMIO cases just statically
> assume unprotected/shard MMIO. Should we drop this patch here as well,
> adjust FIXMAP_PAGE_IO and think about protected MMIO later when we
> actually have to do device assignment?

I agree, there's not much point in this patch as it stands. I'll drop it
(and the previous one) for the next version of the series. We can add it
back if needed when protected MMIO is a thing.

Thanks,
Steve


