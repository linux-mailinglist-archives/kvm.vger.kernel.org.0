Return-Path: <kvm+bounces-18542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C758D66D3
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 18:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 630BF28DA2C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 16:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C4315B978;
	Fri, 31 May 2024 16:29:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8DA158DD3;
	Fri, 31 May 2024 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717172971; cv=none; b=S1NaBt+QrlR6nCZ+Ju8ytVarUdY6lNdVfDTrhmh7xcE3/LVepuTije4cRVTmKJOpUORI7W+E8N18dMPNzMW/jgJ0cxkT+lGpwHzrQeqz8ZxspGv+HEmYh+Bmrr9TIuCIWpU2pvhVIGK8bTKA45cFTOoETg09+eZsBCKpj31/Lk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717172971; c=relaxed/simple;
	bh=ojtrrpN1OarLx49BhUQv9ID6AunPCtGWlhkKeZU2fRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XaCK6yy5QMgz/kp2qecD2TNtywubM4Hj8BffkBwUL6NPq/AkDLVhjpVabmhlRoRp3dY3/1na1Y1SsQnjSl75vqH118qjzMzuQSsFPonfn0ICgGi4OETQUwGIwhoJf8nG94LGU3/fLwcwfpElE7jA5tbchEb3J3I0AkbH2LLNaio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EBEE1424;
	Fri, 31 May 2024 09:29:53 -0700 (PDT)
Received: from [10.57.40.150] (unknown [10.57.40.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C07F3F792;
	Fri, 31 May 2024 09:29:26 -0700 (PDT)
Message-ID: <19650d71-2421-4cef-a858-9639a5537dbe@arm.com>
Date: Fri, 31 May 2024 17:29:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/14] arm64: rsi: Interfaces to query attestation
 token
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Sami Mujawar <sami.mujawar@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-14-steven.price@arm.com> <ZkSYCYOWxKSV9t8S@arm.com>
 <fe1e3793-a413-42b6-b368-619aae277cb6@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <fe1e3793-a413-42b6-b368-619aae277cb6@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 16:52, Steven Price wrote:
> On 15/05/2024 12:10, Catalin Marinas wrote:
>> On Fri, Apr 12, 2024 at 09:42:12AM +0100, Steven Price wrote:
>>> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
>>> index b4cbeafa2f41..c1850aefe54e 100644
>>> --- a/arch/arm64/include/asm/rsi_cmds.h
>>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>>> @@ -10,6 +10,9 @@
>>>   
>>>   #include <asm/rsi_smc.h>
>>>   
>>> +#define GRANULE_SHIFT		12
>>> +#define GRANULE_SIZE		(_AC(1, UL) << GRANULE_SHIFT)
>>
>> The name is too generic and it goes into a header file. Also maybe move
>> it to rsi.h, and use it for other definitions like rsi_config struct
>> size and alignment.
>>
> 
> The realm config structure although it 'happens to be' granule sized
> isn't really required to be - so I think it would be a bit confusing to
> specify that.

The struct realm_config must be aligned to GRANULE_SIZE and the argument
must be as such aligned.

> 
> There are only two other interfaces that require this:
>   * RSI_IPA_STATE_GET - completely unused so far
>   * RSI_ATTESTATION_TOKEN_CONTINUE - the buffer has to be contained with
>     a granule, so it affects the maximum length per operation.
> 
> I'll rename to RSI_GRANULE_{SHIFT,SIZE}, but I'm not sure it really

That looks good to me.

Suzuki


> belongs in rsi.h because none of that functionality cares about the
> granule size (indeed the driver in the following patch doesn't include
> rsi.h).
> 
> Thanks,
> Steve


