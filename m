Return-Path: <kvm+bounces-41073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C398A61480
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF4F57A377B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBEB72010E1;
	Fri, 14 Mar 2025 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AvEcEHkW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAD517579
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741964829; cv=none; b=sW4gMdXPZBQByzioTaU6nlg65j3cFs1xGdgdfbME11/JJ5m0IuCPvQXUR66hmvITHb/5NcfhD0uCCbdwXd+wwpXqVl52KSZV0lamBCR01ZueLXtj3a+51XIJOux8fPd3zES1UeKWpUC3KJupqhYqilYHMScwXGHSWwVPKooBzqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741964829; c=relaxed/simple;
	bh=sJLeBuGvwZPCRgRoqF1poNdktXHv+fF6Kpyzh6hyzno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Chf/e+g0JkI+GW5e8boqUqyB8afGOhDI6BvNCnis3Sf0IV5Nt9jWdHMrNdWq0AqRKs7j4b09KgkHwsH0raWXB8dbxniNVucosnIWswt/nNb5J8BMFA9z4CE7yA2jsaJ2vruSsopw2hZ7++Z7K3z65p0RLohIzxhoJBV3pwEiumU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AvEcEHkW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741964826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w+rX8sLBoLqwgm6ggmdeXPxqg6ljE9ON3jRGhrKcK/c=;
	b=AvEcEHkWB2iDVgdfL170jjhuWwDMVqfuSWu/MSFfq2FqG2hSWGGXE1ztgJfe5GfrcxtHQb
	uLi027PRYWwpwW7cmOo4u3VnAhx/xFiHGzbKKgO2hHfUZMB+ULWOymOBcvA1JT6i2QIBik
	yl3kbaI4UBqNRZOxU00eQk7mKT2YX30=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-m8XR5aw7NIqX9j3vpIGfaA-1; Fri, 14 Mar 2025 11:07:04 -0400
X-MC-Unique: m8XR5aw7NIqX9j3vpIGfaA-1
X-Mimecast-MFC-AGG-ID: m8XR5aw7NIqX9j3vpIGfaA_1741964823
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ab39f65dc10so239953966b.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741964823; x=1742569623;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w+rX8sLBoLqwgm6ggmdeXPxqg6ljE9ON3jRGhrKcK/c=;
        b=ZRdwi9JW5MkTJYhiXd5QnuZcW+TTh8FoikIGAq0ZaLncyy0c/eEcK5NksHSH5mMSiS
         uEBxJ9DPHzYvfi3WEAGcLf79/5Dbh9bBVbqRIUSEOjbk3oC2M1cpULxAUeP9bnPu/ux8
         48phbMg1B3GIzeoeLsB9VTgXs6yJWOfOQYRQOJmd+0P4AmqNhi7TGrWhkppAHSaUU6y+
         2HxpyBABMZKBHJPjEzImQYKft2t6l8+Rd9r8Ol+c4DIi9F1gd0hjwJcRLh57dj3JmbG5
         NztP0LZuQvAv/HsdJJRlF2YSRZ5+F9k2QllspNam4cj0ksDHXvoPXYtdMvnB1uGyA27J
         qOrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYyqhI0u1BthuZm7z2sMiWlkS9RCO2jjj/FASElrMsfnC4mZPYPhTdbw3kPrk3MZY43hI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO+uVZtFshgRvrvgELPLDZ+3txNiHj0KqEewbOmc+akjfdfpeQ
	CtnhfPpeV1Y2kSZ3R+X3jeHZpM7HcXszSMI89Z47XbSIUUxZgVP7IxsQ0u7MLbbJNfhAWS56B1N
	mDdaaRLccStPIY9lbA9rv2PEDs2+uSF/KQDbmNdl9IvtqN7mm2g==
X-Gm-Gg: ASbGncuRjreyv4+3K3+cauL8GSois1DnxzYytujgluq4bXVs1KG4uBSllYop6KeMIVo
	HlH6dAL5jpELrS9Sd0J+lnmiTNM229PUkYgk9BIVO0D8zGeStzfl56cpDsNdsVLuMYPBjqPvbxK
	VXK1lWvpfDpg6/f7uEDF00IdaL95n26oKX3XxujHVRjThsH33+5FJ/6sXn0+G8XuFn3wKkYlllq
	dBh5PigFrZnHTNtcKYDezOhMqazJ90glnHf09fOsrvQcdTMmSORTVfmNj8UG4xkVIq2MOchVraI
	0isVpJ3+w3+I8G2mjjtodQ==
X-Received: by 2002:a17:907:9281:b0:abf:49de:36de with SMTP id a640c23a62f3a-ac330108ae9mr389746566b.1.1741964823139;
        Fri, 14 Mar 2025 08:07:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGv3yXbg91jrMnmT82WQ9ZPMV3M6T+c8Q0TlFzgSgulAU4LUdCAOG3A2FJOSRB/FpAdyRdzkQ==
X-Received: by 2002:a17:907:9281:b0:abf:49de:36de with SMTP id a640c23a62f3a-ac330108ae9mr389741566b.1.1741964822725;
        Fri, 14 Mar 2025 08:07:02 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.122.167])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac3147ed1e4sm238196566b.66.2025.03.14.08.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 08:07:02 -0700 (PDT)
Message-ID: <2fd1f956-3c6c-4d96-ad16-7c8a6803120c@redhat.com>
Date: Fri, 14 Mar 2025 16:07:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250225004708.1001320-1-jmattson@google.com>
 <CALMp9eRHrEZX4-JWyGXNRvafU2dNbfa6ZjT5HhrDBYujGYEvaw@mail.gmail.com>
 <Z9Q2Tl50AjxpwAKG@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z9Q2Tl50AjxpwAKG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/14/25 14:59, Sean Christopherson wrote:
> On Thu, Mar 13, 2025, Jim Mattson wrote:
>> On Mon, Feb 24, 2025 at 4:47 PM Jim Mattson <jmattson@google.com> wrote:
>>>
>>> Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
>>> without interception.
>>>
>>> The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are not
>>> handled at all. The MSR values are not zeroed on vCPU creation, saved
>>> on suspend, or restored on resume. No accommodation is made for
>>> processor migration or for sharing a logical processor with other
>>> tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
>>> do not account for time the same way as the comparable PMU events,
>>> whether the PMU is virtualized by the traditional emulation method or
>>> the new mediated pass-through approach.
>>>
>>> Nonetheless, in a properly constrained environment, this capability
>>> can be combined with a guest CPUID table that advertises support for
>>> CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
>>> effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
>>> no performance cost for this capability.
>>>
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> ---
> 
> ...
> 
>> Any thoughts?
> 
> It's absolutely absurd, but I like it.  I would much rather provide functionality
> that is flawed in obvious ways, as opposed to functionality that is flawed in
> subtle and hard-to-grok ways.  Especially when the former is orders of magnitude
> less complex.
> 
> I have no objections, so long as we add very explicit disclaimers in the docs.
> 
> FWIW, the only reason my response was delayed is because I was trying to figure
> out if there's a clean way to avoid adding a large number of a capabilities for
> things like this.

True but it's not even a capability, it's just a new bit in the existing 
KVM_CAP_X86_DISABLE_EXITS.

Just one question:

> -       u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
> +       u64 r = KVM_X86_DISABLE_EXITS_PAUSE | KVM_X86_DISABLE_EXITS_APERFMPERF;

Should it be conditional on the host having the APERFMPERF feature 
itself?  As is the patch _does_ do something sensible, i.e. #GP, but 
this puts the burden on userspace of checking the host CPUID and 
figuring out whether it makes sense to expose the feature to the guest. 
It would be simpler for userspace to be able to say "if the bit is there 
then enable it and make it visible through CPUID".

Paolo


