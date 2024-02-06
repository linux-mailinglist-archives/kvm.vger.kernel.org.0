Return-Path: <kvm+bounces-8129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D153484BCF9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 467361F24A08
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790C9134CC;
	Tue,  6 Feb 2024 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="CP1M+eA0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004D8134B1
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707244368; cv=none; b=lir4k0bgyuXE6b4AN6E7CNoKvDzIPQhcgV96tflaYjnjyvmtICbAYj3xl77Nadv7WiAffrb2F8ubhC5YYgSGhDXQRD/PUxymDXKfTANrJPrgOxClywt1hU5FbGjux5Zfpb3kBt2oRSWMbZfkn6/epWgTvgDvauzK6VWTARWTBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707244368; c=relaxed/simple;
	bh=FxDoWXU2xAhOo67HyilGeVyLXXV8IdfMTgPQD2fu354=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uRoj5l2nByRZsRuZIW7zCDfq9k1WjGnXUzs6H/dXA5uMU+yH+tzt0gZnRzbMH1ZHyK3EzqZUPwhJ9KWWWxEry5fkME25jCwoLXRZ5BErEfOHa1SnYsid4/I+zx0wiAABImcbyvdEXPJtrt+3YEO80g124C5QeOOHiLd5bL5gKuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=CP1M+eA0; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-51117bfd452so9986901e87.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707244365; x=1707849165; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nDhXmDmeSyvA3VkVywKwhma2qlBi6fmNxzxdWHwfHeE=;
        b=CP1M+eA04CU86hGhCQ5Q/lhM7u6N7nqTj+La8URIGFb/hsPy94f/mWJPInETMwPqvk
         XPHrYGck25UT6rilrWQJP0FFrTQbKR9IOe3wcHdpB0q50l7GU7U/PCzYWp7bN9jKxf+I
         VH5km9uA7QcrqJUXk/em7vzx2q1r4PhHgmGyiig/JoKETAXsqqXGXIGhe2Ma9fLVd4MJ
         UOO1m0X8zlOSfTvrckB1ZaSvM1UFkr6TEyvKpWsB9yaStffC/sRhapGwA/NQb1Q91XYv
         sZk5stiTavwjAd0ZthUKSdKbiPjQmUm35i8jySuDS7QNlMHtDyvNZ5F876Z6hHaEl+AN
         vdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707244365; x=1707849165;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nDhXmDmeSyvA3VkVywKwhma2qlBi6fmNxzxdWHwfHeE=;
        b=dHpviWTcYNGeg5UWv5Wd26nhKHueJz8BX9IJr4xJzEMe18XZxiS86mxcNn0l7zBmM5
         J+iSh3ffQqlBEzyn92Ugf6A6+1A/7hMhwgJvaCZyZyx5YdOziLVBbXtPRImUkp6M4sZ0
         kDwL6dOBuq3EYvfWQMBl0s8OZ1A4ylVygJs04TgHyWIuBt1ZrbdmEyeqqRC5S8B+Tkrw
         iI6oxINufP+wQpqr6md4fceyo7u/H+LPm1FxJMx+zh8lbXWI0uYL6wunGROSNTz4jKM5
         jy+LntH8Djj8qyR9Oq3jRMZx0yFZK8RS5iY9O9T5XHmMvonPN9pwqOIYPF7KQsdp4lEQ
         OUyA==
X-Gm-Message-State: AOJu0YyvZ4fHdo18AUvMQmngC86L9hh9zgPKMqJmRE5wpoW/7jCirMtb
	P4AMP27Cz8mwTOiKqFaPxdUPw34V2B8tMGemYcUFRNY64A0D43NrxkTBGEy3xq0=
X-Google-Smtp-Source: AGHT+IFBiwVBpJnJeJu+qjYn1uWsxAANI4onCugXB7UMZhl0JNZhjMzwvaqsuiUreKsS3lZ8xWzrgw==
X-Received: by 2002:a05:6512:2354:b0:511:5e6c:c021 with SMTP id p20-20020a056512235400b005115e6cc021mr2070586lfu.36.1707244364896;
        Tue, 06 Feb 2024 10:32:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWdi0tLoyZK3pd1VME9rRc98R2fzfocSOBB3+n2Zri6qg/HOBiF3LGezgNfUOJ18tPT/frVBCWf2JV9h8DDZka6/bDs
Received: from ?IPV6:2003:f6:af18:9900:571f:d8fb:277e:99a5? (p200300f6af189900571fd8fb277e99a5.dip0.t-ipconnect.de. [2003:f6:af18:9900:571f:d8fb:277e:99a5])
        by smtp.gmail.com with ESMTPSA id eo3-20020a056402530300b00560ada2df6dsm832131edb.45.2024.02.06.10.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 10:32:44 -0800 (PST)
Message-ID: <057b4794-7ce3-45d3-b4ae-d68c38127b36@grsecurity.net>
Date: Tue, 6 Feb 2024 19:32:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-3-minipli@grsecurity.net>
 <ZcE8rXJiXFS6OFRR@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZcE8rXJiXFS6OFRR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05.02.24 20:53, Sean Christopherson wrote:
> Subject: [PATCH] KVM: x86: Make kvm_get_dr() return a value, not use an out
>  parameter
> [...]  
> @@ -240,11 +236,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	smram->rip    = kvm_rip_read(vcpu);
>  	smram->rflags = kvm_get_rflags(vcpu);
>  
> -
> -	kvm_get_dr(vcpu, 6, &val);
> -	smram->dr6 = val;
> -	kvm_get_dr(vcpu, 7, &val);
> -	smram->dr7 = val;
> +	smram->dr6 = kvm_get_dr(vcpu, 6);
> +	smram->dr7 = kvm_get_dr(vcpu, 7);;
                                        ^^ nit: double semicolon

>  
>  	smram->cr0 = kvm_read_cr0(vcpu);
>  	smram->cr3 = kvm_read_cr3(vcpu);
> 

Thanks,
Mathias

