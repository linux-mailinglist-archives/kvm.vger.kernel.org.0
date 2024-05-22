Return-Path: <kvm+bounces-17969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 022A08CC481
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05D881C21506
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312EF141987;
	Wed, 22 May 2024 15:52:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0F0140E4D;
	Wed, 22 May 2024 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716393171; cv=none; b=nfzJWQh7ncw6xL2x+Ez1KUyqr3LGXD1GlAsaCKHtDuxcyrBHtLsL8iOIrnYKa1sUiaAjIxT9EzZf2EBxu/Qt5BEeqdoBf6v4ijqBfriu+K+dl1s3UadN4D2k0bjzaHxJ9jYF94zMZEPmobT7+Us/LqW/SyVDBP5b3zhq8dHIkLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716393171; c=relaxed/simple;
	bh=FNUKhCgH3p/nE748aRJauYt6enORN/xUcsNBXPvhy6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3ZqqC2DS5HVIO10SpkNlMVkxMnzZYlu9L0HGg1odLmy7kIq2Qx2dMCvqhLcw7KwqM9I0gholEfQ9sETh50wQEC67pNrYCWHHWXy5jVF3gVKQ4x9hBe62R0L9SKRtHpg9gZKjdMFpRIDaqPjEuglytwqrXMVfpR+o+vJ1uQGcYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2005DDA7;
	Wed, 22 May 2024 08:53:13 -0700 (PDT)
Received: from [10.57.35.73] (unknown [10.57.35.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 750243F766;
	Wed, 22 May 2024 08:52:45 -0700 (PDT)
Message-ID: <fe1e3793-a413-42b6-b368-619aae277cb6@arm.com>
Date: Wed, 22 May 2024 16:52:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/14] arm64: rsi: Interfaces to query attestation
 token
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Sami Mujawar <sami.mujawar@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-14-steven.price@arm.com> <ZkSYCYOWxKSV9t8S@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZkSYCYOWxKSV9t8S@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/05/2024 12:10, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:12AM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
>> index b4cbeafa2f41..c1850aefe54e 100644
>> --- a/arch/arm64/include/asm/rsi_cmds.h
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -10,6 +10,9 @@
>>  
>>  #include <asm/rsi_smc.h>
>>  
>> +#define GRANULE_SHIFT		12
>> +#define GRANULE_SIZE		(_AC(1, UL) << GRANULE_SHIFT)
> 
> The name is too generic and it goes into a header file. Also maybe move
> it to rsi.h, and use it for other definitions like rsi_config struct
> size and alignment.
> 

The realm config structure although it 'happens to be' granule sized
isn't really required to be - so I think it would be a bit confusing to
specify that.

There are only two other interfaces that require this:
 * RSI_IPA_STATE_GET - completely unused so far
 * RSI_ATTESTATION_TOKEN_CONTINUE - the buffer has to be contained with
   a granule, so it affects the maximum length per operation.

I'll rename to RSI_GRANULE_{SHIFT,SIZE}, but I'm not sure it really
belongs in rsi.h because none of that functionality cares about the
granule size (indeed the driver in the following patch doesn't include
rsi.h).

Thanks,
Steve

