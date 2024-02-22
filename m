Return-Path: <kvm+bounces-9372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 544F485F5E4
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 841CF1C23853
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9335439854;
	Thu, 22 Feb 2024 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="JX+qBwuN"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED83038F88;
	Thu, 22 Feb 2024 10:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708598402; cv=none; b=occGXG9tLdMED3dQ6PPYnggY+rKhqQhKzLbM7NY/HnnPvkUIktxhgrCdqr59b0h1Crk/18HVjleQEnFl62k5lr6Na8KDtQGKk4Ailg3ohR7UGq2ZBRT2Zy8F3yOpf0IXztzT9igibBGIiJgn6++H4RuuBqrAyvlShjpjUeoC/0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708598402; c=relaxed/simple;
	bh=FuBDCm+nfRJvluqNb4wLXsonwNUes6SMoT6bu57fO/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqYAc3/6+oTnM0+jbbO5U7i9maJm/8zstKRGgUBWx3z+Vse3prLCfxqYcZgnQAPdwfbieQFEdXzZtnc6R/ZwSo8221V0q1TLmLKnBhmhSVjzGquZxNazmFPOzu5S7t39zitsYId56hgf0/1IhU/uzyBoPC1uCGqo7W+tXviyCkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=JX+qBwuN; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708598398; bh=FuBDCm+nfRJvluqNb4wLXsonwNUes6SMoT6bu57fO/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JX+qBwuN++k/Hw5I0RCrbZ9ISDmuYWxA8/AfimqU4TDzheKM+5W0nbh0ENjXmTqva
	 WUSzBDwfxpPBpiuYr/qtLq/Kb+alTtFGmBhrOwjMaUrDk1xIKFsqAA70KGvzHeiTkI
	 k9AY3jmi0hio5+Ur4ZCAHm9UMxw0deMXB8prNTf4=
Received: from [IPV6:240e:688:100:1:5f9c:42f0:f9f2:a909] (unknown [IPv6:240e:688:100:1:5f9c:42f0:f9f2:a909])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 747ED60094;
	Thu, 22 Feb 2024 18:39:58 +0800 (CST)
Message-ID: <37521d9a-7980-486b-8ab6-980a8ccb7bbf@xen0n.name>
Date: Thu, 22 Feb 2024 18:39:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-6.8 v3 1/3] LoongArch: KVM: Fix input validation of
 _kvm_get_cpucfg and kvm_check_cpucfg
Content-Language: en-US
To: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 WANG Xuerui <git@xen0n.name>
References: <20240216085822.3032984-1-kernel@xen0n.name>
 <20240216085822.3032984-2-kernel@xen0n.name>
 <412ea29b-7a53-1f91-1cdb-5a256e74826b@loongson.cn>
 <4a12394a-8ebf-40b8-b0bc-65b5a66967cd@xen0n.name>
 <0c27477b-d144-37f3-d47c-956f9ba07723@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <0c27477b-d144-37f3-d47c-956f9ba07723@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/22/24 18:22, maobibo wrote:
> 
> 
> On 2024/2/22 下午5:45, WANG Xuerui wrote:
>> Hi,
>>
>> On 2/17/24 11:03, maobibo wrote:
>>> Hi Xuerui,
>>>
>>> Good catch, and thank for your patch.
>>>
>>> On 2024/2/16 下午4:58, WANG Xuerui wrote:
>>>> [snip]
>>>> @@ -324,31 +319,33 @@ static int _kvm_get_cpucfg(int id, u64 *v)
>>>>           if (cpu_has_lasx)
>>>>               *v |= CPUCFG2_LASX;
>>>> -        break;
>>>> +        return 0;
>>>> +    case 0 ... 1:
>>>> +    case 3 ... KVM_MAX_CPUCFG_REGS - 1:
>>>> +        /* no restrictions on other CPUCFG IDs' values */
>>>> +        *v = U64_MAX;
>>>> +        return 0;
>>> how about something like this?
>>>      default:
>>>          /* no restrictions on other CPUCFG IDs' values */
>>>          *v = U64_MAX;
>>>          return 0;
>>
>> I don't think this version correctly expresses the intent. Note that 
>> the CPUCFG ID range check is squashed into the switch as well, so one 
>> switch conveniently expresses the three intended cases at once:
>>
>> * the special treatment of CPUCFG2,
> +    case 0 ... 1:
> +    case 3 ... KVM_MAX_CPUCFG_REGS - 1:
> +        /* no restrictions on other CPUCFG IDs' values */
> +        *v = U64_MAX;
> +        return 0;
> cpucfg6 checking will be added for PMU support soon. So it will be
>          case 6:
>              do something check for cpucfg6
>              return mask;
>          case 0 ... 1:
>          case 3 ... 5:
>          case 7 ... KVM_MAX_CPUCFG_REGS - 1:
>                *v = U64_MAX;
>              return 0;
> 
> If you think it is reasonable to add these separate "case" sentences, I 
> have no objection.
>> * all-allow rules for other in-range CPUCFG IDs, and
>> * rejection for out-of-range IDs.
>   static int kvm_check_cpucfg(int id, u64 val)
>   {
> -    u64 mask;
> -    int ret = 0;
> -
> -    if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
> -        return -EINVAL;
> you can modify && with ||, like this:
>      if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
>          return -EINVAL;

Yes I know. Personally I don't find the "three cases" that annoying, but 
I agree with you that it can be mildly frustrating if one case addition 
would split the ranges even more.

Given I'd like to also change the U64_MAX into U32_MAX (CPUCFG data is 
specified to be 32-bit wide), I'll send a v4 that keeps the "if" branch 
to make more people happy (Huacai privately also expressed preference 
for minimizing changes to the overall code shape). Thanks for your 
suggestion.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


