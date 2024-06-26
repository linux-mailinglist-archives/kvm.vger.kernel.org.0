Return-Path: <kvm+bounces-20578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97740919B5E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 01:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CEE52828A5
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 23:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D3919415F;
	Wed, 26 Jun 2024 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F1o7w2lY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB5D1940B1
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 23:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719445381; cv=none; b=YKPGkt7MTSIkl18zdghQPHYfEXn+AM9MNopw33DIOPrtdW9Y/wEGR05Jst5UzSNIEOcGL//t2okWpJmLIk7upjuV8eUDFKCBnGuZt2Yv9Mp2OF2SPCfbPcCMS7JW/XdRQKh8TyxapwrRAMjaNO02TMXxi/pZlUx0+cb2SCffrFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719445381; c=relaxed/simple;
	bh=5nbIlBDGDMBOk76zendDvSasr3V+tn+st9rUwe1NHyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZi3TzhzaFcNCZE5iY5/mUv9eo06bjcOE3aidZDpADLY+I4/t4a+nkqkT7dcAa7n+2poVsV+oghb7KsauVQSeuWRC2MIKPGWMXKRNJsMEUTyB/ham9ZzHkfIPEmmvID2pIhs3FeIv9qAjNedSRLkaCFRDlKTalupSSMyBfA+zQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F1o7w2lY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719445378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2MRsBhRz3av/jkoQlN1aC+3haU3qVcXaZ5Hlj5aTWT0=;
	b=F1o7w2lYsX6gLTWGFwU3LqrionX0ZCJ9afv/ovT2/hnZwUYZye93CcGrgatD5Y1URxmCh9
	SHN9ombqZHtwf9HtCdy9I2nNWatAPhmbb64GMXuoUAJmN6pCRn3T7023mdkkWjbCNL3Zjm
	Gg50AJ+Mym/9EVDysObHcFv2Ne0Ym2o=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-nM_Ar8RbOcGeZO8DoN6l0g-1; Wed, 26 Jun 2024 19:42:57 -0400
X-MC-Unique: nM_Ar8RbOcGeZO8DoN6l0g-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ec62b1fb18so34089531fa.3
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 16:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719445375; x=1720050175;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2MRsBhRz3av/jkoQlN1aC+3haU3qVcXaZ5Hlj5aTWT0=;
        b=rCg4Ro3k0QvY7t9eGtRRMn8S2mkypLsdnc3Z1TenXTDHPHLuILmIgOdzvpn14M1l6F
         n+0Z+lJSPQiZGC1vuGdXOP9RzFcfTG5oY/mPPIiGnvIFmxWexrRren/dh3r345ZyRaTI
         t+mEZaHHjphlVjhDcmf4v8Gjo0UxwXNTpFYyK6en97+XreSS4bwPTkdNmnqZabZU6DJx
         ph4MsWZ3b6CElNYYuY1SsSKRPaMBYzbz7NFWzaTSZqgncsq5WQBEhXY2Ajc3i/jNeVca
         9VINeJVVTFjxO9A2RDk7Exre2xCFPn/f1W8bWichuhM00f1D21B5B5KwZtibvvbUuz2I
         VplA==
X-Forwarded-Encrypted: i=1; AJvYcCUWmgyWTUO8K00WlUp1wPXKN7FrkN3oRLQHfsLCwyQ160vY9KY/Aq2D4qv86dXMoPpqSizSuwomyxZMyzyyA4ub9uDQ
X-Gm-Message-State: AOJu0Yw32yyyaKF+Bb1pIqxFEuOhEwgk0gEpBph7+alklycTrmPnwzq3
	1jujJqsqP/Ee1cGoHxP1HhOGRhjB0HmAZ+xDUZ7j5gSiRM5dwdbkMMPOvrTW+CqeTGH/DPUJDE4
	OnhbOHFVx8iFwOdRAjyy75PgRCcZUNENSn/JTT1TdEHMH/AshwA==
X-Received: by 2002:a05:6512:3e1c:b0:52c:e084:bb1e with SMTP id 2adb3069b0e04-52ce084bc12mr12477255e87.13.1719445375574;
        Wed, 26 Jun 2024 16:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDwQ4PnVWz0p28X43mkXITWyttCuEh1r3MtUlpnew8gJ+cNFZuSGDWSK82BDgDRW5BJc6KVQ==
X-Received: by 2002:a05:6512:3e1c:b0:52c:e084:bb1e with SMTP id 2adb3069b0e04-52ce084bc12mr12477225e87.13.1719445374194;
        Wed, 26 Jun 2024 16:42:54 -0700 (PDT)
Received: from [192.168.10.47] ([151.62.196.71])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a729d778ad1sm2953666b.141.2024.06.26.16.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 16:42:53 -0700 (PDT)
Message-ID: <d2cab7e4-2634-43b3-8cb1-58172456f602@redhat.com>
Date: Thu, 27 Jun 2024 01:42:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] target/i386: restrict SEV to 64 bit host builds
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20240626140307.1026816-1-alex.bennee@linaro.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240626140307.1026816-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/26/24 16:03, Alex Bennée wrote:
> Re-enabling the 32 bit host build on i686 showed the recently merged
> SEV code doesn't take enough care over its types. While the format
> strings could use more portable types there isn't much we can do about
> casting uint64_t into a pointer. The easiest solution seems to be just
> to disable SEV for a 32 bit build. It's highly unlikely anyone would
> want this functionality anyway.

It's better style to just fix the compilation issues.  I'll send a small 
series once I test it.

Paolo

> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   target/i386/sev.h       | 2 +-
>   target/i386/meson.build | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 858005a119..b0cb9dd7ed 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -45,7 +45,7 @@ typedef struct SevKernelLoaderContext {
>       size_t cmdline_size;
>   } SevKernelLoaderContext;
>   
> -#ifdef CONFIG_SEV
> +#if defined(CONFIG_SEV) && defined(HOST_X86_64)
>   bool sev_enabled(void);
>   bool sev_es_enabled(void);
>   bool sev_snp_enabled(void);
> diff --git a/target/i386/meson.build b/target/i386/meson.build
> index 075117989b..d2a008926c 100644
> --- a/target/i386/meson.build
> +++ b/target/i386/meson.build
> @@ -6,7 +6,7 @@ i386_ss.add(files(
>     'xsave_helper.c',
>     'cpu-dump.c',
>   ))
> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'confidential-guest.c'))
> +i386_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('host-cpu.c', 'confidential-guest.c'))
>   
>   # x86 cpu type
>   i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
> @@ -21,7 +21,7 @@ i386_system_ss.add(files(
>     'cpu-apic.c',
>     'cpu-sysemu.c',
>   ))
> -i386_system_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
> +i386_system_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
>   
>   i386_user_ss = ss.source_set()
>   


