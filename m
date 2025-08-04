Return-Path: <kvm+bounces-53890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE44B19ED6
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 11:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBC52189B1F5
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94457244673;
	Mon,  4 Aug 2025 09:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="eZS9zSLF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BEF23ABBD
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 09:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754300160; cv=none; b=qVE/V967Uc5B79m87GiUd4GXsVM59ICtyqEcry2CFK1HPi/AczypV2jZ2f5v/9+txEcw8MBwgJuxmtqBxfVQ91yk6L4rb6zv5N6jpY2T4c5P+2AQS+sI1zR1Pd/ABsOO2jJFp5prjnQepgfXypQQ/rio+rgKlODyudMtQOIB49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754300160; c=relaxed/simple;
	bh=RSEUUDPk0ivxtKPryYLZckoW5/oxzbqoOUtFYK7FH1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bv3fL+dtE/fLNV2YLmVQzgDVKH7pInb/OhtI6+HXSIRDyRVDXlcRJIY97uJIWXs4ckA+a4Zlu8SizrLRPgSPLqNdvlAmlNKMp7wxPepYVtMekxu3fN4BZjtrwmQ3Q5fme/20YhefezPIHIvPx1t3dH+thvXlFmyNwGB/PAVtNx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=eZS9zSLF; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e691926a6aso213401685a.3
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 02:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1754300158; x=1754904958; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sSGViVqk8tYm1Hl4rf3sipWjZp79oeSys3OXdOq7qQ0=;
        b=eZS9zSLFhjC2fCy8UwDFwaFdpatvwuoEdy4acDKSZ4FqZ+vVqX5lJRmPk513QzFA50
         JXXN9rJBSkcONN01snAZcd4PHXk5v27xJT29yBrpqoUbkCdS/4DfbBkm2qspFqsvWxW6
         6QMOtA6oZ9WZoK6o8a3l+Lug5f7tmUs/tfOe4obqKVryecHUgoT5w9gNguotaHRrazuP
         mxO/pdzjBMW+TSC+X7m12Pdxo+PqWOyY5eas0EMU0n0El2Klow2lZSRRW+PuyP47K7FA
         8pVUgeVTFd9q/D4u/dOZD0BzJpWCiM8MBRGZ1p+8ZcE0KmojzUwcLaE2Rdt/RUg5Nc+5
         v5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754300158; x=1754904958;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSGViVqk8tYm1Hl4rf3sipWjZp79oeSys3OXdOq7qQ0=;
        b=PRbhD5QSFG2RCwzk2Jfd0TaPeaQkmkaO+VLdXRkSSZd0uGwysVe7uwD67TS6spdFgY
         KYKBbcehlt257g/KGE15YFKQ9mgFxtfahbRfzz+39IkGh+CPyuik5sYX6+2dimkcLfhB
         xLtgOh9oz6vkm5cvZNVMy14QIIng/ApKeI7DLjdH6QXfK425XoSi5jWzo0B1vVKwvmqK
         BnjCbyy/1AXWNqrGuo+B54emwfqXRLcOyxUhc+wlJ30AjNDvJdnyTOzMMYGLkH6eh7dd
         v4Rly+pnoMwBvjrrEcH9DHVgmjwLPlFzGgk6dkkca/z3bO1vLwW1xZM8gnVDseP9OBkN
         Y0eA==
X-Forwarded-Encrypted: i=1; AJvYcCUOIvu51/o72C3SOmikFq16KxsW0Eht0e5VcyB4s83veJWQymaKwAeqIDLogeyRC4h2YOE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsh5S3gLlCdK+/bolna1Aldg8EC2i/WoXJeYopkBr4aCRPCE/J
	4ovkECzG6itYBtuKmW2B2AqXIgMU4rzJYiinlVaXzXeaR12qsCevzNGGNmqgxwBVp0k=
X-Gm-Gg: ASbGncumrBYbUJsZjTeYArExGtQSc4kAcFc9aaAkay5SoYjA8yWm2yhLGc0NOhguHib
	TZ3aIYS3nthCq5LwxYgxdvd2h3zx43XNNjVFpzpv9KOD31fQKKQOooKd3r2CpmSVH0ViHQBMA0O
	hxdilTTWf3dWIGYPGiqPyxGuMV1xiaPRx5CXZM34mnBnkjf6zxF4hgEdh7DIxxxtSXhuMbxvb35
	79s2l0SZqplKD2F0TpnbWihm1zVx1rH2hjoTfBdgA5Qc79/iVxerLYu6ql3bj3teuONH6QcRTEL
	bYRKW8swA+tj4U+spqy+cFbsI5VchNXNf4MbOotxnaHLuZJflHqmx3sZWTp4nV+HZvpLX1Uw5As
	bvBJBM+OMKniH8O6n0xPap/D3tzdgb3Iixz7lyI32r/JDh5Qa4myOiTgRi8gklRvVlBaIVxot9L
	wcs3Hm/2Aw9DRQquNY/jEKzARDkfazlTsBzu32VKOSb/Qo0sBrFmifz46Soneg9d/Org==
X-Google-Smtp-Source: AGHT+IGbM9Mk6uhLMIfQkTcN7oqrD3mx+58S38TYJ9YZp0XYWcvPrm86ys90AFtGU4ZHqA92/ooSxw==
X-Received: by 2002:a05:620a:21c6:b0:7e3:4678:aae with SMTP id af79cd13be357-7e6963543e9mr973213885a.41.1754300157937;
        Mon, 04 Aug 2025 02:35:57 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f594206sm521802385a.4.2025.08.04.02.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 02:35:57 -0700 (PDT)
Message-ID: <b0179d3d-d36a-4ae8-b32c-5659794995db@grsecurity.net>
Date: Mon, 4 Aug 2025 11:35:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <271351582cbe88731098bd4fbdd8f7ef522f20f6.camel@infradead.org>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <271351582cbe88731098bd4fbdd8f7ef522f20f6.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23.07.25 11:26, David Woodhouse wrote:
> On Thu, 2025-06-19 at 21:42 +0200, Mathias Krause wrote:
>> KVM has a weird behaviour when a guest executes VMCALL on an AMD system
>> or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
>> exception (#UD) as they are just the wrong instruction for the CPU
>> given. But instead of forwarding the exception to the guest, KVM tries
>> to patch the guest instruction to match the host's actual hypercall
>> instruction. That is doomed to fail as read-only code is rather the
>> standard these days. But, instead of letting go the patching attempt and
>> falling back to #UD injection, KVM injects the page fault instead.
>>
>> That's wrong on multiple levels. Not only isn't that a valid exception
>> to be generated by these instructions, confusing attempts to handle
>> them. It also destroys guest state by doing so, namely the value of CR2.
>>
>> Sean attempted to fix that in KVM[1] but the patch was never applied.
>>
>> Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
>> conceptually be disabled. Paolo even called out to add this very
>> functionality to disable the quirk in QEMU[3]. So lets just do it.
>>
>> A new property 'hypercall-patching=on|off' is added, for the very
>> unlikely case that there are setups that really need the patching.
>> However, these would be vulnerable to memory corruption attacks freely
>> overwriting code as they please. So, my guess is, there are exactly 0
>> systems out there requiring this quirk.
> 
> I am always wary of making assumptions about how guests behave in the
> general case. Every time we do so, we seem to find that *some* ancient
> version of some random network applicance — or FreeBSD — does exactly
> the thing we considered unlikely. And customers get sad.
> 
> As a general rule, before disabling a thing that even *might* have
> worked for a guest, I'd like to run in a 'warning' mode first. Only
> after running the whole fleet with such a warning and observing that it
> *doesn't* trigger, can we actually switch the thing *off*.

Looks like I was overly optimistic. There are, of course, use cases that
rely on the hypercall patching, even if it's just for testing purposes.
One of these are the KUT tests. I tried to fix these[1], however, there
are probably more such mini-kernels, so I reverted back to not changing
the default behaviour and only provided a knob to disabled the quirk,
making users to manually opt-in to it[2].

> 
> Can we have 'hypercall-patching=on|off|log' ? 

I'd like to have the 'log' option as well. But as KVM does the patching
on its own, this would require QEMU to analyze and react to related #UD
exceptions (and possibly #PF to handle currently failing uses cases with
read-only code too) further, I'd rather not want to do.

Another option would be to do a WARN_ON[_ONCE]() in KVM if it does the
patching. But, then, existing use cases would suddenly trigger a kernel
warning, which used to work before. Again, something users probably
don't want to see. :/

I guess, we have to stick around with the default but make users aware
of the option to disable the patching themselves.

Thanks,
Mathias

[1]
https://lore.kernel.org/kvm/20250724191050.1988675-1-minipli@grsecurity.net/
[2]
https://lore.kernel.org/kvm/20250801131226.2729893-1-minipli@grsecurity.net/

