Return-Path: <kvm+bounces-65747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFE0CB563E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFD8C30161B2
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F672FBDEE;
	Thu, 11 Dec 2025 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+4InD+b";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HedVqkn+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5BB2F9DBD
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765446182; cv=none; b=ZQZ1wncQb4eR4JV9v9E7RqfqkeXjsQXzNYDKihpsXa1xLsbOrEy/hw2MdqYwg4g5bXXDdDR9MJF31iRRaAHAJ/v/sOh+Z9P88oX+Yn3koipgenLFg4IULVgPH/HbOw+lpWYWtRppMm9M+deFSLLQggF3Eey8DLvJm+Kos/oPhjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765446182; c=relaxed/simple;
	bh=roRw3oQlljkJsyiwVumLAipcpq3YgAqKJo/iBu022w0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rg5mqhn93nnrzRyTneMSiTqEyTvSNYumetW6SmjYjqf1/cAhiZLj/+qYCB2ssty/YXQmKCry6RcP1g+apiU2WXpGwnCyvWPqE2qYyqH0zvPIX9OOzvcyxRri05i1sYG7zY6i/+j4JMZ6w8qIo0NCL78oQfMsh7//A16fwEyj+kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+4InD+b; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HedVqkn+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765446178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5/6uA/3wOUHJdk91kbUDLu249x2jP1J/9xVRDtTz+9M=;
	b=J+4InD+bI9HYjHkqF63+HpSooUtZE/7nQnJIoXPpXGuwJzcEmRnyro7OGk5BxPXL0h+wgx
	amkiVhgkOUFmwd0s9NKuhbnfyOmlzjf50no9zilg3LelKo4VRoLm879R6XdZGYsiKBTZlz
	wi/0BAW05BkGZ+BXhSe78EUWz7Gb6rE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-KMEKOm4OPnC2bH2PEwlXjg-1; Thu, 11 Dec 2025 04:42:57 -0500
X-MC-Unique: KMEKOm4OPnC2bH2PEwlXjg-1
X-Mimecast-MFC-AGG-ID: KMEKOm4OPnC2bH2PEwlXjg_1765446176
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-64981efd7caso657108a12.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 01:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765446176; x=1766050976; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5/6uA/3wOUHJdk91kbUDLu249x2jP1J/9xVRDtTz+9M=;
        b=HedVqkn+2hf+U/8zxlUr71rqpHBm3FgOAvA+/B4Gu5L0yXz6SGbjePQKg1J3jHNBfT
         k2EVDk5jKm5o5ch7/k06UDKFTzQe0XP9bN69pxjELwW8vC5XvxNxAd7CPXVUt47fZNiz
         7q8lfeLjN0BFDSJ+/ng9IT3r9/6rdtSRJrdFB7fiqLvEOzOyR+xzEKSftwRqc83h07nh
         r17h3DD5jJf+Iifneuud6DbqN73QyvutlPdUpFowwq5UUS9DLBuh2eKg5zgp7JdclYOL
         ezmQDzQ0riY/4Xhp8h7OdWL+c30Pf/VsUjd9e7Vkp3NjHN+Pm/NKdIPmgFputv45o950
         uETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765446176; x=1766050976;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/6uA/3wOUHJdk91kbUDLu249x2jP1J/9xVRDtTz+9M=;
        b=loQ/pveXH9KoNK20FLRChgfNYUPjr7E9jWbEDsa16RYVbGTqsr5rKX+Pe60TFrNkC8
         93BZVIoYB5UILbNA3pVJwkylFZ+TF4QBu56eRgzPGulvbss8AM74ebI16yD93dfGWXAr
         op6y05cKcuhmTk9mwCOgE16epzNQYO2YGwdMi80hSqrOaLxv0q0H57BewWX7BRyrH8ty
         hNiDhPcS/taN+1u56sGGFW9nN4VstT/C9BdamKHGQKE3vwQd1o0cHDzRYbmdSyKl2ZAY
         Ckh2Dg+0mHaCfnqRjcaCGUENKGtr3M7hZ4Wk9bDNgLwqpx3GwMj/s58Kgeka/1iS9FLn
         C9ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaoM9cKvaahsLKf3YfiTtn9GMZxM5Bt6EKFP68UWMw4MAwUYZ8Ii9uuz/OT0c3kYhfhg8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR3xHolz1ermIQhYQ+5KXadBacyaNkJLwC2GMZ/KvzoRUQDk7M
	oHbrTp1dFSyn9axXHZCUZQbvJdfdZDl+iO9IYWlUYWquFBCoVkFeNGJ8/XUbyUOc23lvhbtdVzS
	PSzCfIK+D6G6MxMIuFv35nxaPMj1Dp18IVHq5bK5Z0bdgIpwrXxZmSQ==
X-Gm-Gg: AY/fxX7nOBppAHgmYXaoOAiIuXUvpWFilmtr0pUyCRjkap+PD+KLXEs5rTkmVPpaZbw
	+vTp6vElbg0DWKRxxGL1+d3V9mKhJZaqdWptU6FBdSw3r4ilnUQ/jr2TGO0nm1p3rdynfHikL/U
	JOMkon93BOm5dzUpdpp8YOLm8akvo+di4KOcOjce1MurNtVhUeVSEpIlvAkxTHaVDaFhCS5mkip
	EUAUKeFBvJsxcyZY7cdJHmaluJMfbqAmS+pG9q3uFhNyXYYShaRH5618CXgMTJunMRAP0Q3m+AT
	I9um7ruxpfPIURh0Cv1sAt3qdB3nHYV3iFgqBEBhfPV40E+59+ghYR7TAjnGOCfqhI560zyBOf6
	Qr9f7o7aAhWK65HNfgCrZlv+m6Xp438BH5mMNAVLPZoZgiNdsortwu0aHLgi//2LdAV56WgloJ1
	IUG+aG0L5Mc99WXQI=
X-Received: by 2002:a05:6402:234e:b0:640:f1ea:8d1b with SMTP id 4fb4d7f45d1cf-6496cbc43eamr5203526a12.16.1765446176302;
        Thu, 11 Dec 2025 01:42:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFkqB0lOqTTY//ENdRxS0fIqXz+u8gEeyxDFPsZWUiU+o3HppiGYVaD75VpZdrK94jlixVxSA==
X-Received: by 2002:a05:6402:234e:b0:640:f1ea:8d1b with SMTP id 4fb4d7f45d1cf-6496cbc43eamr5203506a12.16.1765446175919;
        Thu, 11 Dec 2025 01:42:55 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-649820516desm1993624a12.14.2025.12.11.01.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 01:42:55 -0800 (PST)
Message-ID: <df96afb2-f99c-48ae-81be-ccadf0fc3496@redhat.com>
Date: Thu, 11 Dec 2025 10:42:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] i386/cpu: Support APX for KVM
To: Zhao Liu <zhao1.liu@intel.com>
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Xu <peterx@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 "Chang S . Bae" <chang.seok.bae@intel.com>, Zide Chen <zide.chen@intel.com>,
 Xudong Hao <xudong.hao@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
 <16e0fc49-0cdf-4e54-b692-5f58e18c747b@redhat.com>
 <aTqMBtkOxx6mZhn+@intel.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aTqMBtkOxx6mZhn+@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/25 10:16, Zhao Liu wrote:
> On Thu, Dec 11, 2025 at 09:08:33AM +0100, Paolo Bonzini wrote:
>> Great, thanks!  Just one question, should the CPUID feature be "apx" or
>> "apxf" (and therefore CPUID_7_1_EDX_APXF)?  I can fix that myself of course.
> 
> Good point! I didn't realize this.
> 
> 1) Per APX spec:
> 
> (APX adds) CPUID Enumeration for APX_F (APX Foundation).
> 
> 2) And gcc also use apx_f:
> 
> https://codebrowser.dev/gcc/gcc/config/i386/cpuid.h.html#_M/bit_APX_F
> 
> 3) ...and we already have "avx512f".
> 
> So you're right, I should use "apxf" and CPUID_7_1_EDX_APXF.
> 
> Since APX CPUID appears in several patches, I can respin a new version
> quickly.

No problem, I have done a quick pass with "sed" on the patches and 
reapplied them.  I do ask you to respin the Diamond Rapids series 
though, on top of the for-upstream tag of 
https://gitlab.com/bonzini/qemu (currently going through CI).

Applied for 11.0!

Paolo


