Return-Path: <kvm+bounces-9363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD4185F4E9
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E774C1F22275
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 09:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E563EA8B;
	Thu, 22 Feb 2024 09:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="eHXbV8aG"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787D83D99C;
	Thu, 22 Feb 2024 09:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708595161; cv=none; b=Oe0CG9L5UgvQiFhGqm9IrOZdkRjA6Rc6besU1uCFfUkiQM3LAsNlPAwFZ0hI8WLQBaUbSaQQsTsUH5sJXjrC7FMc69W6vnOOYz4MT7ofwIneDczjz8MNzFu0g1zWIGAhG9J0oCFq0jH8PljEk8c1X+JBzedNqo2zqd7jBMr9x70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708595161; c=relaxed/simple;
	bh=OATWuTBcSrRQnsAQcEJVtWvg5kuTMiuCytgedBHWqcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JoutQAYhJfQqs0yxR857Hmp2pjdJ6apy9hf1uYTudddwQG9Zm7DomUQz1OTMXHTAJpZYgb3neYA2ML2puKi7HRcagj5Nkveu/UNI2PfXO3Bn1BI5uJ4jMq3LAOPqhUTwhvUsIap4VAIqvxeCWvZtlntz5QwZ+tpoFPTC01WQTOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=eHXbV8aG; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708595157; bh=OATWuTBcSrRQnsAQcEJVtWvg5kuTMiuCytgedBHWqcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eHXbV8aGJB0ujrUWJGnfgMm6WOMvBvd3BoCoGQorjtnCQgvZNr5siYU8QCq8HHiYg
	 nuJ2/PCENj+1bYr0jDK/3478D+blyJfmeAf43QnwnqUEVSAFZ3HYMyKuakuNXZWwlf
	 vSCUFn/tH+H5+rkS5Oql+SFyKzP/h09m+MzM5Rsw=
Received: from [IPV6:240e:688:100:1:5f9c:42f0:f9f2:a909] (unknown [IPv6:240e:688:100:1:5f9c:42f0:f9f2:a909])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 0376660094;
	Thu, 22 Feb 2024 17:45:56 +0800 (CST)
Message-ID: <4a12394a-8ebf-40b8-b0bc-65b5a66967cd@xen0n.name>
Date: Thu, 22 Feb 2024 17:45:56 +0800
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
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <412ea29b-7a53-1f91-1cdb-5a256e74826b@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2/17/24 11:03, maobibo wrote:
> Hi Xuerui,
> 
> Good catch, and thank for your patch.
> 
> On 2024/2/16 下午4:58, WANG Xuerui wrote:
>> [snip]
>> @@ -324,31 +319,33 @@ static int _kvm_get_cpucfg(int id, u64 *v)
>>           if (cpu_has_lasx)
>>               *v |= CPUCFG2_LASX;
>> -        break;
>> +        return 0;
>> +    case 0 ... 1:
>> +    case 3 ... KVM_MAX_CPUCFG_REGS - 1:
>> +        /* no restrictions on other CPUCFG IDs' values */
>> +        *v = U64_MAX;
>> +        return 0;
> how about something like this?
>      default:
>          /* no restrictions on other CPUCFG IDs' values */
>          *v = U64_MAX;
>          return 0;

I don't think this version correctly expresses the intent. Note that the 
CPUCFG ID range check is squashed into the switch as well, so one switch 
conveniently expresses the three intended cases at once:

* the special treatment of CPUCFG2,
* all-allow rules for other in-range CPUCFG IDs, and
* rejection for out-of-range IDs.

Yet the suggestion here is conflating the latter two cases, with the 
effect of allowing every ID that's not 2 to take any value (as expressed 
by the U64_MAX mask), and *removing the range check* (because no return 
path returns -EINVAL with this change).

So I'd like to stick to the current version, but thanks anyway for your 
kind review and suggestion.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


