Return-Path: <kvm+bounces-21694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C710A932297
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 11:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84C5E2842E9
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 09:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3CE195FE8;
	Tue, 16 Jul 2024 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UQCEBO7v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0932B195B28
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721121565; cv=none; b=EkBp7BNmskRfr+M04t4LZxXdwBzqg45kXEWl9mfWu+tiS6S6/Ht2poZ7V0zwRZY5nZHLh6Y7rBFbMvLR4G2J8pIpl8vAtrr4EGOjYn/AWO9qE6PVWgiay/4Uv14pXaz3oiiL+KXq/5W9l2beuJURSja8IC5mXcKS8AILq6rMJ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721121565; c=relaxed/simple;
	bh=wIKFTkgOxKarKu7ZvRVo3CXwGmlLlx8gEItUhdOXHqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeQfiNw8e6Af3xxyVky6wtNEBQ7L8DyCFVQe+4E+/t5ceWeaBKwKEHtj+fdvcxGFEBTsK1Ljte6FafubH+W+9klHKghv+RRNJwaJTnHke+uIvmrS5Zb42ziDsgaKP8Q2Kevh4kMj8vXIrYQaM1Iz7VnMZdEEkhuLXYnSvkB2TVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UQCEBO7v; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-367ab76d5e1so1628064f8f.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 02:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721121562; x=1721726362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HCwG4y9RfylQmlQ9XAEiDhPnOMthCInzLc5NEQS7oxY=;
        b=UQCEBO7v0ubtKGkcWZAiyTWB4gPcJkNgrui1n3+4n2zpoqiOZt8fl89wTQyx5/EdAm
         TTGIl3iGNZKYOOST/TWbyqLNP17zUOJJpO/W5mbilgKMOd0ZSZljKGv/+b2Gdy3izluK
         Hrauez45/pPWPUTpYYXT/WqOo/YD7JEavBJ+IQREASZ+HhfpmN+LyECtxcz0R37kfhFY
         3eDoLJcVRr1Iw4aiZWZBFWIfnU+EwT7uZhwr/0F9vB1K9DvwwcCb5ab9dh07RSmfwYyt
         uU+NUn3iAS2iBfX3QdmMrEKGGlbsnYW339QOsYyJcbvU+TsvP/jXUn08m66IoQEH7nhY
         UaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721121562; x=1721726362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCwG4y9RfylQmlQ9XAEiDhPnOMthCInzLc5NEQS7oxY=;
        b=dSYUCO6UGnkcMS4AP3GKGoAO+FjyJIm00KTSZFI+VplKZ8ODfT/86LaxlJPkZsSPqa
         spLMpYJ/Zj3QBNsc1V4AKenHN9/9L2IETssUp8kQJYsq+DWvA01NxGl9AU25359xjkrQ
         qFVCA2mRKO+n7eHdGsxCE4cG2kL6Qb+NPA0CPXti6wkE91t6lvh5NooCVlMAbBI4bimI
         r6ubDU2c2/5BIWxaSAjI2xTGVpYA8mXPIV8d6D8uTU2A1P3zomLYT0Vojqk84T3qiCrv
         UihqSUhkTkGhuDHZ/HxjcEKlwCpYgyQpHpIJbB6JQlWoT9gph7Iu/hMCR0pBQXC/QTry
         AiZw==
X-Forwarded-Encrypted: i=1; AJvYcCWAju6sGVWaWTCrLr4jJGQvEk5QkL23e7M85xv3RxoAVXn17JgN1buST3gSytzt7i5M4MLWT5BEMtaOfsiqCmwX9wfh
X-Gm-Message-State: AOJu0YyV3iWwGio3TXUD6NLzphxa0OuF6pOhKkzkUgg8HAC9eX0upj6F
	iRzjB5nO3eiAvyUq8g4QpwT0AeDmYia3NNY5Ciq0H83IgcP6iuSZXoCwlN8/Fmw=
X-Google-Smtp-Source: AGHT+IHQQCGHWb0tVPOJFNgT4QVaj7AoigdHomsGm8sHFJSwrT7GUHGIItLW9bF+/GymOFBLt7CKkA==
X-Received: by 2002:a5d:4204:0:b0:366:ecd1:2f38 with SMTP id ffacd0b85a97d-36825f7476bmr877035f8f.7.1721121562296;
        Tue, 16 Jul 2024 02:19:22 -0700 (PDT)
Received: from [192.168.86.175] (233.red-95-127-43.staticip.rima-tde.net. [95.127.43.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dab3cb0sm8387945f8f.10.2024.07.16.02.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 02:19:21 -0700 (PDT)
Message-ID: <b6fa54fc-bba9-4f0a-9fd6-f3bc62eaa1ac@linaro.org>
Date: Tue, 16 Jul 2024 11:19:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] target/arm: Always add pmu property
To: Akihiko Odaki <akihiko.odaki@daynix.com>,
 Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
 <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/7/24 10:28, Akihiko Odaki wrote:
> kvm-steal-time and sve properties are added for KVM even if the
> corresponding features are not available. Always add pmu property too.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   target/arm/cpu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


