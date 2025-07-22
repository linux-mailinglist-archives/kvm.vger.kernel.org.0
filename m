Return-Path: <kvm+bounces-53073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F5FB0D163
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DF86543F51
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6DA28C87A;
	Tue, 22 Jul 2025 05:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="A1Y3CgrJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6701E0E00
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 05:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753163370; cv=none; b=ov5slrN8n0V8wfgraKZ1HAvzR9OsSZjHPKiV3hUWDX7cSQAOb50sfoXD0ZOONCrEjiErIRHG9cK3X9qH9fTpSKA132FMf9AUMXsoIF02jCo+5V2vU/9U8AFpEu+6BKIWd56Vs5XQEnUas7xoQL8FzvpKsWMUglZADWtyiBH99Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753163370; c=relaxed/simple;
	bh=EYsiutdD7obro3J8tRqNKcz0V+WlOluUDDcO6lr16h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqvgyxMLfURwK9jk13kTTb6+8qggdaxZTck36vYsKJWMmjdY+jzwCirF09WVTMygkQkw1ZifEJfBLIyYd89P2Ut/ptQWVacxKYfIrbB/rm8HOIrbqnW2lKQbq4u+OSx3BgRqJ86hCRP5E+vupkwHGWvhuJNWx/u9UENxFXaqFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=A1Y3CgrJ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b31d489a76dso4326413a12.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753163368; x=1753768168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AnoJBa5+d/Xeyj/TiIdw33DeMjcCXsPUii0CNLMcpN8=;
        b=A1Y3CgrJg1GNVLeN1VA+OwPFqp6SjsoOnyY6BWK1yzU8JGWn13fEBl6T1E99ufiqx8
         51gudzyXKMqejG7uXhsTDvH0igSe+EYeh2QG12vnp8fsiYC5KHOXYioSG3K1GwEk0qAF
         uNeiLkJODLyYsJjuXIUbeFBSM7dl8/pg53lpgoicCN3BAGwb4a6LsEV7gaYy6nMSumbb
         pav7m5sFGeG32Q0MzbPuFIpg+2qOn0MU0vnC06T+QMc0vP/goI3zbD5tc7o2FIgBzXjk
         503+AUZKRu3lvWmlw/wic0p2gjyOswsSFzTn8mG+fjbM4tAxhLZWINUAT2CPH2QbRsBp
         2V6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753163368; x=1753768168;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnoJBa5+d/Xeyj/TiIdw33DeMjcCXsPUii0CNLMcpN8=;
        b=GUMXvrt3AQb8+D/gu2PRCmLTe3VUsICLeBRRx3ofPG1P1gNeyU7WpsR7iqkzq0eEoa
         mSwCWI9BcAXnTzt42s3m4/TfqW2JAZE4wzBuEVm8VdDqdGXK8/Jfu0bO4tZYvCHWDF9h
         2YI0eejN3Xv3CE7qU838tZjqlSPNdggZ4M1A7OFE6IuHpRJ8Oyg7amA88u5HGy/wXFj1
         JC8Nt9SI7iXt4kwil+pyGLn0ghkCoSm30T3iye7BmjeceaCSb9U1dttoIigFaFS2ibYD
         /wuPLlIctZnsZkyTm4TZ+R1zCGE9EjqqQrTSuEpeLn6ZBd7AVPsU+hOU791yzHJSP3Xm
         xeeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvomFWrys/Fr2rXD+MWiZrMsxAWWeQKs6Og5QSTKnNBpd5mi13YJZJksuFe4GaAsdyFuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPe+kPCDXWZyQGZDgd3tWBDmfioiXaU/UJvUQI9DIe/Jly6ajJ
	/xuol1//rd9w4NJ/z62jK+ruT5D0RaaKSW2NhatJRnj/vtDZFZx/VKo1YSx/OuJy2Ig=
X-Gm-Gg: ASbGnctLqmmVs9ON2Co4AX6RGCBa3s0Nek4kiK+nap4TDjCc9Nl3cpgvfnkl4xYdFC8
	LGcSv+vlJkdacBKllR0qNie+Di8MAJtR1dJxiVdfhLhHbKVJDW29UG0Og9jnZgi4dObbmD7vXIG
	Rm/fwFYNpzW2D6IIcwnxg51BAK3NW4BWFon3anIsVgQcmQmVmq/6r+GRinovdbebRi1ez/LtXhv
	sIhfgRNRwgEbBqLGq5clFB60lCoewnqfg33GyqzLZwE30mnxlNjNQ1ZvonZNPohwQl6yi5XnK7r
	PM9/7HOcvYPlbQRJns7JDVgemC9CHuxMcH+zOSm8up/hyU1yC9wVffEpHqZNtEWspxY4NW3w5ud
	HOtfqJCIC4PRGE4qmKOY4V9eEBewyKHwsfQ6WZYOQv78WsBuitI8KWEjvn8o/IttHXpDXvBxtLu
	8rYqAku2vD9c+ZAruN5+CBpE0yT9oYoidAqUOjOPQBgz+oKkRjuB7RzKs=
X-Google-Smtp-Source: AGHT+IGy7zc48edkju9bcZ32HPIv6nt5zr1Ku2glRdmr2ANOmtNOGOqnrirNkfszas0t7uVz5kPKvg==
X-Received: by 2002:a05:6a20:12cb:b0:220:78b9:f849 with SMTP id adf61e73a8af0-23812c45ea0mr37911064637.24.1753163368136;
        Mon, 21 Jul 2025 22:49:28 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759cb76d4e4sm6849616b3a.106.2025.07.21.22.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 22:49:27 -0700 (PDT)
Message-ID: <96a0a8b2-3ebd-466c-9c6e-8ba63cd4e2e3@grsecurity.net>
Date: Tue, 22 Jul 2025 07:49:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 19/23] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
 dave.hansen@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
 john.allen@amd.com, weijiang.yang@intel.com, xin@zytor.com,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-20-chao.gao@intel.com>
 <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net>
 <aH58w_wHx3Crklp4@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aH58w_wHx3Crklp4@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21.07.25 19:45, Sean Christopherson wrote:
> On Mon, Jul 21, 2025, Mathias Krause wrote:
>> Can we please make CR4.CET a guest-owned bit as well (sending a patch in
>> a second)? It's a logical continuation to making CR0.WP a guest-owned
>> bit just that it's even easier this time, as no MMU role bits are
>> involved and it still makes a big difference, at least for grsecurity
>> guest kernels.
> 
> Out of curiosity, what's the use case for toggling CR4.CET at runtime?

Plain and simple: architectural requirements to be able to toggle CR0.WP.

>> Using the old test from [1] gives the following numbers (perf stat -r 5
>> ssdd 10 50000):
>>
>> * grsec guest on linux-6.16-rc5 + cet patches:
>>   2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )
>>
>> * grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
>>   1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )
>>
>> Not only is it ~35% faster, it's also more stable, less fluctuation due
>> to less VMEXITs, I believe.

Above test exercises the "pain path" by single-stepping a process and
constantly switching between tracer and tracee. The scheduling part
involves a CR0.WP toggle in grsecurity to be able to write to r/o
memory, which now requires toggling CR4.CET as well.

>>
>> Thanks,
>> Mathias
>>
>> [1]
>> https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
> 
>> From 14ef5d8b952744c46c32f16fea3b29184cde3e65 Mon Sep 17 00:00:00 2001
>> From: Mathias Krause <minipli@grsecurity.net>
>> Date: Mon, 21 Jul 2025 13:45:55 +0200
>> Subject: [PATCH] KVM: VMX: Make CR4.CET a guest owned bit
>>
>> There's no need to intercept changes of CR4.CET, make it a guest-owned
>> bit where possible.
> 
> In the changelog, please elaborate on the assertion that CR4.CET doesn't need to
> be intercepted, and include the motiviation and perf numbers.  KVM's "rule" is
> to disable interception of something if and only if there is a good reason for
> doing so, because generally speaking intercepting is safer.  E.g. KVM bugs are
> less likely to put the host at risk.  "Because we can" isn't not a good reason :-)

Understood, will extend the changelog accordingly.

> 
> E.g. at one point CR4.LA57 was a guest-owned bit, and the code was buggy.  Fixing
> things took far more effort than it should have there was no justification for
> the logic (IIRC, it was done purely on the whims of the original developer).
> 
> KVM has had many such cases, where some weird behavior was never documented/justified,
> and I really, really want to avoid committing the same sins that have caused me
> so much pain :-)

I totally understand your reasoning, "just because" shouldn't be the
justification. In this case, however, not making it a guest-owned bit
has a big performance impact for grsecurity, we would like to address.

The defines and asserts regarding KVM_MMU_CR4_ROLE_BITS and
KVM_POSSIBLE_CR4_GUEST_BITS (and KVM_MMU_CR0_ROLE_BITS /
KVM_POSSIBLE_CR0_GUEST_BITS too) should catch future attempts on
involving CR4.CET in any MMU-related decisions and I found no other use
of the (nested) guest's CR4.CET value beside for sanity checks to
prevent invalid architectural state (CR4.CET=1 but CR0.WP=0).

That is, imho, existing documentation regarding the expectations on
guest-owned bits and, even better, with BUILD_BUG_ON()s enforcing these.


Thanks,
Mathias

