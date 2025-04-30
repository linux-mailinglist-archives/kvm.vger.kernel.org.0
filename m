Return-Path: <kvm+bounces-44967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3789AAA53FF
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A5D81C23E96
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F33270EBC;
	Wed, 30 Apr 2025 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pfw1H87S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D99A1C8FB5
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038632; cv=none; b=SnFWbUV4qMCvMdsy49ci//MhLRby8FSTJShDSHnAFlB5Ar2U8k8RboAdWTMUE5n45xpbgtG4ZMdASKyTXRvZI+vZYgMtz4vfTSGGFr8BHQoGjLm0raJjGI1Q3GTFJSy1p6Url0uYqNEfbx0JsW7dKCiL6h2zBTkxM24AeU5OQwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038632; c=relaxed/simple;
	bh=R4bHT2yZIvEA8KVENsVG9NtSNYalxPD5tYe2vkxctS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RRQTZ6CceV/cUarY8/TFuB+icXSuYQdlGAEAIRpJVTv/VpCV2eAk/QjRGqVpijZZTW5Q93vhzY3khtttJPNGz039vi7Y+gHYbq19hlzvSOkn4J0CODTRbLd6FluJiLE75i16fzveLAdXqB2zBsvuQ6fAVSxReAd9KnOCzDmHtCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pfw1H87S; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223f4c06e9fso2213495ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038630; x=1746643430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eERu5hpha4PpgkMhmqqhBzBFgIZvmQXsSQLAuCeFsU4=;
        b=pfw1H87S8RmVzsLuZWlE4zY431A6fnwK6RCuLITKzlVFSvpq204Nx7yv1W8oObjcv8
         mpwr3xIE42ozf0YBBKige9BZ7Uxv7cQdxuylwIXnOUcJ9E1jOyOYrSyYQatZkL9qH4oN
         tKQhNn8UUhb+vUTCtNMMjmt1VTRWwshxk48YngHU3pC0OGmuVyNdc+rLqoxEjOJzwzzS
         TA9CGnMpiysbtQo4gfUHZy8OyHAp8uEU5KGI6aGEnb3RS985leC/p28FYtt4uHYsjCN8
         icViExnjbVj7pLVk/4KLa+2hC4Wj0aTWTpZsuujRhEdy81d5YXLtSRkIzyNCEK5VKIjY
         HuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038630; x=1746643430;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eERu5hpha4PpgkMhmqqhBzBFgIZvmQXsSQLAuCeFsU4=;
        b=VsPUJgrjTw5rOLMK/0Y/rIKnKWi1n7/NXej0WXrz1R5Ke4FL646FP8/2wmvI3VZZlS
         KEI5BbP+40XNNfVl8FpURM38dHLncA5kuU3cdVftMXYfg+KrZYoYwRzXLks+05Dq4Ks3
         BI2IUMkGR6WjAYwVloxTK3APtUMWBpyyZr4IvzCNufSSzEbEqXTUK++Rd6hETKxM9yEq
         /C5kIS6+71HuwEv6iMs4LzrNoj/3nrMgp1x6yrynCEuo973IxbQ+9jFxbz+s/+ztSPpU
         qFPivdsqq08ekXyujnYUZq5lfMdqeIwCyg3Rpog4bOjWJTjaatIpp6HGXRmey/4Dbzi3
         3Dyw==
X-Forwarded-Encrypted: i=1; AJvYcCV1JEi0bqtEGVtWbHwTAB0pmVac6/S00DbryXMIXuOtGMDXmV7b0oSymHd49x2Hry7qSSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7tzHKweSM24AggZugsa7EuvPpLCfoih2wiRxgyE83tlP9zd23
	3jAk3APLpk6GTdcmZiNW3jDBh3k7W0uaGckPGq4F8Pk8NBfIkGOSDJZKQNTkz7s=
X-Gm-Gg: ASbGnctJnABfnHi2Qe/9QlyOZsNRQyF88LSNQOHtC4EWFkd0Vn9lIKN+OmRUT9bHKIq
	EZdWzgUYoJfy4FQCMY5wpdq7bT+jDwT9uqrFyqsivM65O2hpRdKxxbSBy3HHRQO7FkSxAMKH61r
	pMFCkADtqZsbQ0QBXvBA9YqcbWEzyvc7xbtbFdkVij9kn+LOBXEfy3f1oV9XxAnuOFkHY/9pEYX
	XGjDdW75wKa6n+EFXmxABSjNxx1xfXgtBMRonLHnx7iMzxdTgSVxhgb8PQuUxe1kCb9HdkNnAaU
	ysp3QAxXAB0sK2y/iuVhiBrQ1rBtoHzRSfsA05pS2l4Ok2P7xPQIvj5RkAJuB5YXvzzI+ngovET
	Gv0qgzoU=
X-Google-Smtp-Source: AGHT+IFcTY0EafwDz49gNChfNmQsOIOBymhD6KYDInJcF69ZZEdaHOS8/3OcR7xmJH99nfyMr6bJUQ==
X-Received: by 2002:a17:902:f541:b0:216:271d:e06c with SMTP id d9443c01a7336-22e03491b39mr6315505ad.4.1746038630387;
        Wed, 30 Apr 2025 11:43:50 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5221c60sm125821895ad.228.2025.04.30.11.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:43:49 -0700 (PDT)
Message-ID: <db654764-8377-4080-8f68-7fc61e8eaaae@linaro.org>
Date: Wed, 30 Apr 2025 11:43:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] accel/hvf: add hvf_enabled() for common code
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> +++ b/accel/hvf/hvf-stub.c
> @@ -0,0 +1,3 @@
> +#include "qemu/osdep.h"
> +
> +bool hvf_allowed;

Even small files require license lines.  Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

