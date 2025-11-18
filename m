Return-Path: <kvm+bounces-63485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA15C67372
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 05:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F23C0363CCB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D19A277C96;
	Tue, 18 Nov 2025 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="JN23eR4n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F02641C6
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763438669; cv=none; b=nCg7Uhofurk+3yunosWSDuaKxHXIjJHMof33NZUdya0onJGwbISIsAnxiI24koKW9aKvv9ow2S2njrztyx0/PWqhPal4a5LvVviHXOCSgsoNa9TD61fjaNCPBCEvXYiIdIb65jpM8M17Y1yv7mjnr5o47Xx80zoehMGmC1kV5z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763438669; c=relaxed/simple;
	bh=ljbbiYERFeSOTRGaceHAzEEubwKLchVHrZZCtpHtoTY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=AWofBHqmDJWwFzXVJPyhUS2db4NNCo44z1m0/5MydgRFbjQYSfH42K3sEwfeHgscjXiCOcrjGke0VP6PEfkifXvIrq+UJxJTOABCPMa9I4N/c5bO9Tg/k+O2XL/5M0U6o3rgvkNM+amm7uDJRqklBQ4w6V6WQBb2Ds5GLOot7FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=JN23eR4n; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8804650ca32so47166216d6.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 20:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763438666; x=1764043466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LIet07/lRHEtB6AmwUtzkeLdfdQoCqns9tuhswSScXk=;
        b=JN23eR4n9nK9qlPHMRT+A8yesKTY8stiVQxThKtIdn/2zeYhjgtTXUvaG6t1vO7crN
         Z0x9SWSPS8AFeZy9hlrm3tQRF++iSrn8jZ63KloL8xJDUzNye9TrJQ5uIahLwriM0tYY
         IJ5/W6pC4fc5JyjenAy6pFSrXH/iwUHf8BjgHlv7oJFtLScdXNFmEZ7qN9zFjWxvD+RW
         Clz47rSIyTYHJXfkUip1vYZ+QAND/ZhFjjCZjNVAKHsqFAmnXCo36qFZ8hE87rUtC4o3
         IViQoX0wrPobaFYX6riqcGYUCsLtpwOYVayd/6gX7RoJ72hj6APBi+kwrjJsMITqTWzh
         YWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763438666; x=1764043466;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIet07/lRHEtB6AmwUtzkeLdfdQoCqns9tuhswSScXk=;
        b=hJZPcpHVu3JU7Ec1L/jWvPbEVn1Ksex1J97AU/BoUuMl9QG617kq73iIYn5KHdeznc
         GZK1VJWIP6umBiTeExxivuGVCutOyUuLlbSTUS7ENqHmhxXyhg40Pe4G8EZShoX2yjyn
         DtBn9Nag2V+5fV8iAEvIS5f7sX1tSRQoiHbgAYSWV0lE+BQQl0VdofAe7RoFjYxWSUW3
         ovO4gG/vY5imrVCeymL08MEdSirRMzRNOpfnnjsPe6topq38yr3l+OQL/Tu2UDNBSGNz
         nQwBg2zRKc1f71F4sXg9BbwyIorC7SKf1vg47bgQdukgzOBx1NtmikRypiIDtdbvgpEw
         e5Uw==
X-Gm-Message-State: AOJu0Ywt3/p9drxcTl4STMQG5+H6+UJrJmFkSkM3Kjq8n8YG8Na5m3sh
	sCtj4T7JH0YUsph5pgcXbbgyXxGptvhPvtUBurns1WtaOpJdxbzxqc3DIsSk/q8XHEU=
X-Gm-Gg: ASbGncuLKRnR4zhJ+b/8pnRwboPQgFHrSnzVjx4m+JZXeTSPt/gP450q8fYzmQjkhUD
	0Ykn1IYMKBuEHSBh/I1C1VDM6wj+WxzyoMz8p8eq7UW/7tPJVlQLrKR0suGJYzjXeylPONSdnuj
	G4MVpO476AxMD/li7Z6f8MHfGfILU4ALiO/9e2tq+rUuUMjlV1Q+qi7e9KKRme6DvCHu5GiJNCF
	9sIRVNJK0HsWH/coQA4dgLCpYMc9tTYe2Hv/N9EFCeZ98FTUo9j34qa9Du8Vp/1ZJywRorlqKEQ
	pCosmeLoQSeMpILCUVm6/jsIVsa/hPxLMo9pjkCNXoqGNByc4ageG+ZAMANGKCAYeG9fFjPJrDu
	zm68hin0FQUqQGf7lg8k63KUj8Uu2kNaaxmXxtN58J3R/AomBlO4MZuPjEc50hBDZXhoqaPMh04
	1tKFMOfhR1naAQtF8crml15vylvCTKachtgJWRXd0YBQW48UaX8DSn8xZTF7J2TybBtXYJAvHwr
	IcmxU2vcjGA5V4jsOBnFniFdwH3hJ8noywQSpitStZ1r4dI2S9Jl1JX
X-Google-Smtp-Source: AGHT+IFy1GDWeEfH9CbsPtmLofTYHqdYBSwkguwrnMsd9CZfO3rsUWpmnvaCcZ/461CTJvepwhjkiw==
X-Received: by 2002:a05:6214:d6c:b0:87d:c94a:17f4 with SMTP id 6a1803df08f44-8829275dc8cmr215233066d6.62.1763438666005;
        Mon, 17 Nov 2025 20:04:26 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede87e6abesm97547591cf.23.2025.11.17.20.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 20:04:25 -0800 (PST)
Message-ID: <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
Date: Tue, 18 Nov 2025 05:04:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 xsDNBF4u6F8BDAC1kCIyATzlCiDBMrbHoxLywJSUJT9pTbH9MIQIUW8K1m2Ney7a0MTKWQXp
 64/YTQNzekOmta1eZFQ3jqv+iSzfPR/xrDrOKSPrw710nVLC8WL993DrCfG9tm4z3faBPHjp
 zfXBIOuVxObXqhFGvH12vUAAgbPvCp9wwynS1QD6RNUNjnnAxh3SNMxLJbMofyyq5bWK/FVX
 897HLrg9bs12d9b48DkzAQYxcRUNfL9VZlKq1fRbMY9jAhXTV6lcgKxGEJAVqXqOxN8DgZdU
 aj7sMH8GKf3zqYLDvndTDgqqmQe/RF/hAYO+pg7yY1UXpXRlVWcWP7swp8OnfwcJ+PiuNc7E
 gyK2QEY3z5luqFfyQ7308bsawvQcFjiwg+0aPgWawJ422WG8bILV5ylC8y6xqYUeSKv/KTM1
 4zq2vq3Wow63Cd/qyWo6S4IVaEdfdGKVkUFn6FihJD/GxnDJkYJThwBYJpFAqJLj7FtDEiFz
 LXAkv0VBedKwHeBaOAVH6QEAEQEAAc0nTWF0aGlhcyBLcmF1c2UgPG1pbmlwbGlAZ3JzZWN1
 cml0eS5uZXQ+wsERBBMBCgA7AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEd7J359B9
 wKgGsB94J4hPxYYBGYYFAmBbH/cCGQEACgkQJ4hPxYYBGYaX/gv/WYhaehD88XjpEO+yC6x7
 bNWQbk7ea+m82fU2x/x6A9L4DN/BXIxqlONzk3ehvW3wt1hcHeF43q1M/z6IthtxSRi059RO
 SarzX3xfXC1pc5YMgCozgE0VRkxH4KXcijLyFFjanXe0HzlnmpIJB6zTT2jgI70q0FvbRpgc
 rs3VKSFb+yud17KSSN/ir1W2LZPK6er6actK03L92A+jaw+F8fJ9kJZfhWDbXNtEE0+94bMa
 cdDWTaZfy6XJviO3ymVe3vBnSDakVE0HwLyIKvfAEok+YzuSYm1Nbd2T0UxgSUZHYlrUUH0y
 tVxjEFyA+iJRSdm0rbAvzpwau5FOgxRQDa9GXH6ie6/ke2EuZc3STNS6EBciJm1qJ7xb2DTf
 SNyOiWdvop+eQZoznJJte931pxkRaGwV+JXDM10jGTfyV7KT9751xdn6b6QjQANTgNnGP3qs
 TO5oU3KukRHgDcivzp6CWb0X/WtKy0Y/54bTJvI0e5KsAz/0iwH19IB0vpYLzsDNBF4u6F8B
 DADwcu4TPgD5aRHLuyGtNUdhP9fqhXxUBA7MMeQIY1kLYshkleBpuOpgTO/ikkQiFdg13yIv
 q69q/feicsjaveIEe7hUI9lbWcB9HKgVXW3SCLXBMjhCGCNLsWQsw26gRxDy62UXRCTCT3iR
 qHP82dxPdNwXuOFG7IzoGBMm3vZbBeKn0pYYWz2MbTeyRHn+ZubNHqM0cv5gh0FWsQxrg1ss
 pnhcd+qgoynfuWAhrPD2YtNB7s1Vyfk3OzmL7DkSDI4+SzS56cnl9Q4mmnsVh9eyae74pv5w
 kJXy3grazD1lLp+Fq60Iilc09FtWKOg/2JlGD6ZreSnECLrawMPTnHQZEIBHx/VLsoyCFMmO
 5P6gU0a9sQWG3F2MLwjnQ5yDPS4IRvLB0aCu+zRfx6mz1zYbcVToVxQqWsz2HTqlP2ZE5cdy
 BGrQZUkKkNH7oQYXAQyZh42WJo6UFesaRAPc3KCOCFAsDXz19cc9l6uvHnSo/OAazf/RKtTE
 0xGB6mQN34UAEQEAAcLA9gQYAQoAIAIbDBYhBHeyd+fQfcCoBrAfeCeIT8WGARmGBQJeORkW
 AAoJECeIT8WGARmGXtgL/jM4NXaPxaIptPG6XnVWxhAocjk4GyoUx14nhqxHmFi84DmHUpMz
 8P0AEACQ8eJb3MwfkGIiauoBLGMX2NroXcBQTi8gwT/4u4Gsmtv6P27Isn0hrY7hu7AfgvnK
 owfBV796EQo4i26ZgfSPng6w7hzCR+6V2ypdzdW8xXZlvA1D+gLHr1VGFA/ZCXvVcN1lQvIo
 S9yXo17bgy+/Xxi2YZGXf9AZ9C+g/EvPgmKrUPuKi7ATNqloBaN7S2UBJH6nhv618bsPgPqR
 SV11brVF8s5yMiG67WsogYl/gC2XCj5qDVjQhs1uGgSc9LLVdiKHaTMuft5gSR9hS5sMb/cL
 zz3lozuC5nsm1nIbY62mR25Kikx7N6uL7TAZQWazURzVRe1xq2MqcF+18JTDdjzn53PEbg7L
 VeNDGqQ5lJk+rATW2VAy8zasP2/aqCPmSjlCogC6vgCot9mj+lmMkRUxspxCHDEms13K41tH
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 02:47, Mathias Krause wrote:
> On 18.11.25 02:33, Mathias Krause wrote:
>> On 17.11.25 23:19, Sean Christopherson wrote:
>>> Spoke too soon :-(
>>>
>>> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
>>> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.
> 
> Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
> functions") broke vmx_sipi_signal_test too :(
> 
> Looking into it!

Can't see it. The issue is, the call to hypercall(1) does return in
x86/vmx.c:guest_entry() with f01ea38a385a applied but not w/o it. But
that makes no sense to me whatsoever. :/

Below debug diff shows the issue:

diff --git a/x86/vmx.c b/x86/vmx.c
index c803eaa67ac6..e49668f5ff95 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -806,4 +806,5 @@ asm(
        "       mov $1, %edi\n\t"
        "       call hypercall\n\t"
+       "       ud2"
 );

It also explains why the test fails: it's executing random code that
follows, in my case, __this_cpu_has().

Catching some sleep!

Mathias

