Return-Path: <kvm+bounces-20565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A9F918725
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 18:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8EA1C22851
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA3E18EFF5;
	Wed, 26 Jun 2024 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dyj6u244"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAE2181CE1
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719418685; cv=none; b=j6wGc/V4SF/3XsPLAykEQgQex8r1M22wp/dYQ/X2vOXEYso2YcVPIx20jl6XixjPdu1xe1ok8FfYVBL5ShXBC7QPKgHOLiOvknP5I5NnFdQuETfSKvTZte6bjWO1GJLV6nY7w0tAjNo8H1wj6i70kVGpP39YLT7Dr6GU4liBPt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719418685; c=relaxed/simple;
	bh=D+1RmGdHktCfyEPUpa/XJuiM3as8ij+ZNbuGlJ8Z1AY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pYXFCFGPHax+NL62XGPpq5yL+7byiKeWBoMPj/NR0kbHdvAL7It4ED9hJjFUP8RcuZTcCxK1CRIYHGwO9CMNGwgjfX5wzZNsltm8scWrS9dHrk40oA3OilGPV6BmujRH1e4IlEXLEebc1cvpuTxu5iyZIwPtBKqoxWWIezf7G6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dyj6u244; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ec1620a956so82825251fa.1
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 09:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719418681; x=1720023481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DcB6IPPrpjOpTbKaDWEUmYeQ2UAfTwqRY22CEK/B2iA=;
        b=dyj6u244wogGgX94yQHZBjBhaCWdN3B5iw0I+vV2cLoR0nA0QPfIDa/TLMkpayQkgV
         mTLW+q36f0Y7espi0kiPktdzitbGwXksWBxM4VUIB/bBJfISeMMkHlNi8IPxIDILD2xW
         i1mrKrU0+uwpoWu3JU2r17FPaNa38bWyGQZE4D2gYcoG4MeJ7t4/FNHaU1oss+M2zQb9
         YieX3KpHSIZzMYRHct1H7eOes33Z/VU5n5DONJVqrFaMTult3wFpCgbAAsC4U2wuHy/u
         l5Mmfu7P4UCKNsJe4Ljv+Qwfco9w5ZNEA7pFwokk7JQvkIXuoJWI+afN17JczRedJq2G
         mNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719418681; x=1720023481;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcB6IPPrpjOpTbKaDWEUmYeQ2UAfTwqRY22CEK/B2iA=;
        b=JjaO6iknlgvSH+FfTaFDgj3+iQB17rEI80BwVFtlZX5QWPV4bbpGVCvAJu7HGXQobe
         UDlgnD0Ob9JyeZt3OuONhcqDN2bAbJRLxgcmZFg5/mZim3gzV+ynl8jw2e61HLVkXSyn
         s63ILHFnwZCLnJwA/ipMuZEnU8GCl+6TrpNrXZf5OAv881M6qL2qaTX7dnoHwZCfU7dU
         OWTEyBXvTVii+3dSC2VSLEZybYvpZ3AFX7bJChtgEG0+aHhlxfDamDC3Gz189OaIjhj3
         58JP4yIw04gMSmElPoNdbho0Fhn/X8HsKnJZdQN7Sj/gMFwOeq0xZsW38h/piOjNu9Wr
         axkg==
X-Forwarded-Encrypted: i=1; AJvYcCW6OsaGmujQ8+dBbkICJC9K0LPa6l2jrAG4fPEbLnWia2kb+tvq9diBT6R7TNJmAwX21CGEsO3brgoDXySE0+EPj+ov
X-Gm-Message-State: AOJu0YwzJSMqhcFdloVxLhgYSopseSq21Y0e1H00uDItOXEq9hU6il2b
	y+BKk8CerpS1rVXIuNuzFlhsaEntywSvd/9zaE19IQzRKVA15HkMKc5ZNNg4W9OOvT41h6vk9LI
	h
X-Google-Smtp-Source: AGHT+IFfXwEtsh+T/sDn+2rc5XBZnHCaEiUAyswzSvtd5UKEMWXGnkc3/U4D8XcR5I/y5ovhWxbUow==
X-Received: by 2002:a05:651c:211d:b0:2ec:5dfc:a64e with SMTP id 38308e7fff4ca-2ec5dfca6demr78654281fa.0.1719418681072;
        Wed, 26 Jun 2024 09:18:01 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-581e920112dsm1974823a12.93.2024.06.26.09.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 09:18:00 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 78D215F8AA;
	Wed, 26 Jun 2024 17:17:59 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,  Paolo Bonzini <pbonzini@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  "open list:X86 KVM CPUs"
 <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] target/i386: restrict SEV to 64 bit host builds
In-Reply-To: <ZnwjtOxQy1iiRoFh@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 26 Jun 2024 15:20:36 +0100")
References: <20240626140307.1026816-1-alex.bennee@linaro.org>
	<ZnwjtOxQy1iiRoFh@redhat.com>
Date: Wed, 26 Jun 2024 17:17:59 +0100
Message-ID: <87r0cjoeyw.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Wed, Jun 26, 2024 at 03:03:07PM +0100, Alex Benn=C3=A9e wrote:
>> Re-enabling the 32 bit host build on i686 showed the recently merged
>> SEV code doesn't take enough care over its types. While the format
>> strings could use more portable types there isn't much we can do about
>> casting uint64_t into a pointer. The easiest solution seems to be just
>> to disable SEV for a 32 bit build. It's highly unlikely anyone would
>> want this functionality anyway.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>  target/i386/sev.h       | 2 +-
>>  target/i386/meson.build | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/target/i386/sev.h b/target/i386/sev.h
>> index 858005a119..b0cb9dd7ed 100644
>> --- a/target/i386/sev.h
>> +++ b/target/i386/sev.h
>> @@ -45,7 +45,7 @@ typedef struct SevKernelLoaderContext {
>>      size_t cmdline_size;
>>  } SevKernelLoaderContext;
>>=20=20
>> -#ifdef CONFIG_SEV
>> +#if defined(CONFIG_SEV) && defined(HOST_X86_64)
>>  bool sev_enabled(void);
>>  bool sev_es_enabled(void);
>>  bool sev_snp_enabled(void);
>> diff --git a/target/i386/meson.build b/target/i386/meson.build
>> index 075117989b..d2a008926c 100644
>> --- a/target/i386/meson.build
>> +++ b/target/i386/meson.build
>> @@ -6,7 +6,7 @@ i386_ss.add(files(
>>    'xsave_helper.c',
>>    'cpu-dump.c',
>>  ))
>> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'confident=
ial-guest.c'))
>> +i386_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('host-c=
pu.c', 'confidential-guest.c'))
>>=20=20
>>  # x86 cpu type
>>  i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
>> @@ -21,7 +21,7 @@ i386_system_ss.add(files(
>>    'cpu-apic.c',
>>    'cpu-sysemu.c',
>>  ))
>> -i386_system_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_fals=
e: files('sev-sysemu-stub.c'))
>> +i386_system_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files(=
'sev.c'), if_false: files('sev-sysemu-stub.c'))
>>=20=20
>>  i386_user_ss =3D ss.source_set()
>
> Instead of changing each usage of CONFIG_SEV, is it better to
> prevent it getting enabled in the first place ?
>
> eg. move
>
>   #CONFIG_SEV=3Dn
>
> From
>
>   configs/devices/i386-softmmu/default.mak
>
> to
>
>   configs/devices/x86_64-softmmu/default.mak
>
> And then also change
>
>   hw/i386/Kconfig
>
> to say
>
>   config SEV
>       bool
>       select X86_FW_OVMF
>       depends on KVM && X86_64

I was wondering if I could do it all with Kconfig. Will respin thanks.

>
>
> With regards,
> Daniel

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

