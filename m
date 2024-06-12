Return-Path: <kvm+bounces-19511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCDC7905DC9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAD2B1C20CA7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E25D126F02;
	Wed, 12 Jun 2024 21:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="TCw9a7Dy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96454537FF
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718228100; cv=none; b=svHy1JlHTsS72u7cIZ4Cn4vAE4UFEEGO7I4LPGqqBb20sFYUXqPbq4PjlAOeXkNW2iwCVOliKFSuxE3nXvAmeNoFAmtrnnYJ6CUYKGsEzOzv/u+qPZZ9VCCARrM/xe/2WRhGcWiFXAB36zUtk0WKepxneGjtq7K9lPsBFVUJBo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718228100; c=relaxed/simple;
	bh=sliHwa6MnwiJ9v7O8K/H28FxxNzdGYwcm+zXgeETbtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sDLoKWX+j5kuJevOj1a9FnClEUOlprm2cPMz5xekwgk2qkRuDU9pSNr1/3MUwlejnUXVcSgZMkDdk7ADY5610ivKC0/3h/QgV9jLmiE3g8nWj3qvQua3aVTs/jr4d1beeBXvAu246DMG7g/k4HvLpv012MvHwfNbP/E5tGfEGTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=TCw9a7Dy; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a63359aaaa6so50351966b.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718228097; x=1718832897; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fyoCTeKKPPrg/+9sA069gKA+7T39LJbamoXLFs1e1k8=;
        b=TCw9a7DyNQb7LmTgwCt11HnFrPdvh9bS96dmyfjTaM5RstAyVQPhpmtxMq2ico2li1
         jQ+0IWYKCrtB9pksAfQ9vRE6lHi5ZHeE+GHDm70jqCGYziAvmuY3B++GdlvjbXlNZsUx
         TDGDBeUMr1qEFm4KXHNuKJvx+EM4CjRfoQadusX1rSbkgF5fex7bMHrkBiRyRVKQs1wp
         TM3oK4k38d0bwBQKtLNmEicf3yKrR9pWtnhKM9ILLyQzW79Z1RXjRiSRjVjzOfibTPSO
         7yGfLjTwCxsZdkcuA+lLhK4Qe+fmNc0moMYtzKPKgs8kAe0j+If0VIkiibeQS2abvINr
         /B7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718228097; x=1718832897;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyoCTeKKPPrg/+9sA069gKA+7T39LJbamoXLFs1e1k8=;
        b=IKStnGbMPkp8fjINI9PMr6d3uGzdTnET6D9JEHxrWTdEXeslKeYwaicoRyMXoPUIDz
         WKPmDQT4VnBWIl0QOzcNfdAMHVq8eRGMUdD0z59/cMOXMGZpraVSD9qwu6FOGD2rM3yg
         uh8r2V454sbKhGV3H35Ys45WQEHiXezjucWdLUSaaS4osdFrO6JWCJp0YOJeVyOWMOxG
         +zp5LLYbkGZmuCU7GuktpvoAqAJSMJZqme9XIcEjE2kdvcnJ38lHUhlUieC24Co4d3e6
         Y8tVjzM8b1YQWOFCWCI4JR/nREOrdwjrzNWHp1vbH6tvQ1SjeigaOZaSjGmaW456u7mm
         Aftw==
X-Forwarded-Encrypted: i=1; AJvYcCUGy65UphByrLvs3Es4CeYv9oyWRWitQhHPZWFXRVupEtuUC9rEROG8Dk9pQQL+DJM363zobY1i0oso9JpsBRoMVtmt
X-Gm-Message-State: AOJu0YyTqoXnbElMrx5CjHWdraNygKZzUafgHmHPtrFavjIl90Ppn4Hq
	9KrjvFM26Urv3rD3xl7FZxLCPi1bhONCWHCcLID9gjywWCyMyv9SnMGq43qLXrA=
X-Google-Smtp-Source: AGHT+IEfd2yjlsaKGrqZrqYJ3q5zEXueemb3+Kl0bsMKUPZSblqEfJ6Ny9R/pH80sCQNwZN0XUPM5Q==
X-Received: by 2002:a17:906:7f89:b0:a6e:fd41:6315 with SMTP id a640c23a62f3a-a6f47ff38e1mr174094766b.69.1718228096752;
        Wed, 12 Jun 2024 14:34:56 -0700 (PDT)
Received: from ?IPV6:2003:f6:af37:2f00:c44:4b1e:bcbc:1017? (p200300f6af372f000c444b1ebcbc1017.dip0.t-ipconnect.de. [2003:f6:af37:2f00:c44:4b1e:bcbc:1017])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f4a3afc30sm114889166b.48.2024.06.12.14.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 14:34:56 -0700 (PDT)
Message-ID: <fdbed80e-7f92-4b33-b2c2-8bc791835631@grsecurity.net>
Date: Wed, 12 Jun 2024 23:34:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
References: <20240605220504.2941958-1-minipli@grsecurity.net>
 <20240605220504.2941958-2-minipli@grsecurity.net>
 <ZmDnQkNL5NYUmyMN@google.com>
 <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net>
 <ZmHN3SUsnTXI_71J@google.com>
 <516b4fd8-e1fd-43ec-a138-f670cc62a625@grsecurity.net>
 <ZmJQZe6WWxojO7Bk@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZmJQZe6WWxojO7Bk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 07.06.24 02:12, Sean Christopherson wrote:
> On Thu, Jun 06, 2024, Mathias Krause wrote:
>> On 06.06.24 16:55, Sean Christopherson wrote:
>>> On Thu, Jun 06, 2024, Mathias Krause wrote:
>>>> [snip]
>>>              If @id is checked as a 32-bit value, and we somehow screw up and
>>> define KVM_MAX_VCPU_IDS to be a 64-bit value, clang will rightly complain that
>>> the check is useless, e.g. given "#define KVM_MAX_VCPU_ID_TEST	BIT(32)"
>>>
>>> arch/x86/kvm/x86.c:12171:9: error: result of comparison of constant 4294967296 with
>>> expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>>>         if (id > KVM_MAX_VCPU_ID_TEST)
>>>             ~~ ^ ~~~~~~~~~~~~~~~~~~~~
>>> 1 error generated.
>>   ^^^^^^^^^^^^^^^^^^
>> Perfect! So this breaks the build. How much better can we prevent this
>> bug from going unnoticed?
> 
> Yes, but iff @id is a 32-bit value, i.e. this trick doesn't work on 64-bit kernels
> if the comparison is done with @id is an unsigned long (and I'm hoping that we
> can kill off 32-bit KVM support in the not too distant future).

Fortunately, the BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX) will still
catch it.

> 
>> ¹ IMHO, using 'int' for vcpu_id is actually *very* *wrong*, as it's used
>> as an index in certain constructs and having a signed type doesn't feel
>> right at all. But that's just a side matter, as, according to the checks
>> on the ioctl() path, the actual value of vcpu_id can never be negative.
>> So lets not distract.
> 
> Hmm, I 100% agree that it's horrific, but I disagree that it's a distraction.
> I think we should fix that at the same time as we harden the trunction stuff, so
> that it's (hopefully) clear what KVM _intends_ to support, as opposed to what the
> code happens to allow.

I looked into it a little closer and it's even a bigger mess than what I
initially thought. 'vcpu_id' values get passed around as int, unsigned
int, u32, u16 even (S390) and unsigned long in the various architectures
implementing KVM support. A change touching all of these clearly needs
quite some coordination among multiple maintainers and testing to rule
out issues caused by changing the sign of the underlying type -- even if
it'll be just new warnings popping up. I don't even have cross-compilers
for all of these, less so setups to actually do some tests. So,
unfortunately, I'm not up to do that change.

> 
> In the end, I'm ok relying on the KVM_MAX_VCPU_IDS check, so long as there's
> a BUILD_BUG_ON() and a comment.

Ok, will send a v2 series soon, covering KVM_SET_BOOT_CPU_ID, too.

Thanks,
Mathias

