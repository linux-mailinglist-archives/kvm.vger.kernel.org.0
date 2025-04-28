Return-Path: <kvm+bounces-44586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64422A9F4F8
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D56BE189EE3D
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65722528EB;
	Mon, 28 Apr 2025 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DCo1dmXd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659542566E2
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745855659; cv=none; b=rtctwDaJKiG8P8yuM/AVxq60PgtP7QpczP6zy6z2DY9DfxL92TcNO6+tq5aJ4yYG9eiF2hprTHD8Ck1DqPXsiVz7mUsvLm/NKJIrVMvRdGcYs2/9xIGM7DWspr1QjStcbRcb6BUtOSyXJKM1h0J6sx9pAcyAIE9JGSyyXpl9/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745855659; c=relaxed/simple;
	bh=IWi9eoxjwRvRFypbvZ+Li8cO8D4OkDrzuLtB29dAb/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nn8D+p8ElxjS5W5lWKwOvwpvBlgUpDb+tWP5fUU3hoGHTDwKJqrsoSDMrUObMjnffSZMCv5AiIIo9oWDYWMOnWqyiott0Q/gRYxf2vcU81OMWtxSwxnv/Q83CnBKyTUN6GxhWpllvSIQVlhuPZEKQKolQzsBAOFjsITeXYjccr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DCo1dmXd; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-af579e46b5dso3508658a12.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745855655; x=1746460455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q3aqpTyEo4Ne+b8xIfe/goV4Eq53K8pgzq5YFaS0WxY=;
        b=DCo1dmXdKVkpEoctYUAyi15srekn4C//DqIL0fTHvAxai4+JtZYB8PT9wVTBWBVJK1
         7itF+cupdv7n1HcFylJ71s6K270VzRfUNjjbdDvkOwA7PDyCH5F37WvTb3qV5lRwxdhX
         HGz4qnL6F3MRr0cBmTTSIpwxfB2uuweZsU6AAKz5CKbN0uGiA0bNekCpVkNGpQfZOkNv
         T3Fa2QF0sqWKMj+gL/WA+hCW4O4a6rVq/rVWwL7faUKATvWBB0nH1dxFT3vsOobqP8Tl
         sYTQmmCrCWtbDcSAVVbzfH/UqfQgM0zzqxH50jY3IVazpuaA/zmtFpfUtTZIRFyjBuhq
         gqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745855655; x=1746460455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3aqpTyEo4Ne+b8xIfe/goV4Eq53K8pgzq5YFaS0WxY=;
        b=RTXSXaWOSiqKcSSyGc2I9FaFLpAcb7h1fSXOOwY/k1mjz7piE9zYG1PAWvRSOHGNX0
         2lr+Q5mAIFvgoNm0EYtr+LlOEP/Dd6XWKq9/bXm/PwaZgsWH5YLy8fIUKjqMcBgWQC38
         bERtspk6hnJjU53pECXtKk1B4mFXF8SI6SkgICh6U2xOclTErvD2x0D9qQmo43Xl0JKU
         Yei2OUtKpqoJC9yd9nbNuZ2n8KJ37Rk+F5aUrkzQO2cG2Fdd5LuSnKZqPluXJ9suBMcW
         vsW4VvvZtakzQPFSeFxKkfVa9E8vvEitNMQ2TuZbsao8bU0IXG+1i6jdkKYFPxxY25oE
         e7rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWqSfv9EpqNt/zOgPkFabcftdSx6rIj2kUyZgZaWg7n5g5daXmz/4oBNjjJxcc1vZMXp0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww3XfNco25yZx+xH3JBD7pD7oaNa1/EGEiMV5AUxjqnE+4MD1C
	EBB/UMIpn+geakuOUABQQ32kUgT96DLSQ6ptzVF6Gw1w9y/V29+HlgAgMBi84Ys=
X-Gm-Gg: ASbGncvY59nZjIN50E1C3KGFOsmDtXTwytWFQLvo5PQmnGUHY5OoNVgYfLs40QDIX21
	r54qoLbjhzPnpGPKM4K9jdKZIg88Qu8ffYLs2+hp+jyo8G6CklAsg3mjQ5X29kQhKVORjmtZ1Oo
	e5jZLSp5af7H0qaVqFBc1MdZG8fGd+lpMd/jWWGlcoYPvU7XnVNvXlAr8cReea9TJ7+4A0rRM9U
	lGc2Oq+TCTIIHj4dxlgitAlN3rpSHy+lLTL7ZFxjwa9anroY+KIRfODqcnyZgTPuQNrIiFeOC6B
	NQ+10auGET9oP2188EPvOdQ+TCfTvlX2sKfGJrCSFrqPXKWeQl3/UscJB792ckGZigzlWQdy7pt
	vMGRyvvc=
X-Google-Smtp-Source: AGHT+IGq39Fkm/08Siuzlsmrfgf5QPyWBbk5ihd8aKOtZ1eIcBk7fY2KHAohyoB2LpQBTEJtpPMUKw==
X-Received: by 2002:a17:90b:180d:b0:2ea:3f34:f18f with SMTP id 98e67ed59e1d1-30a2155e3a9mr443786a91.19.1745855655583;
        Mon, 28 Apr 2025 08:54:15 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309f782d461sm8169389a91.39.2025.04.28.08.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 08:54:15 -0700 (PDT)
Message-ID: <4ae2766c-28f9-4374-ac3e-94213fe53981@linaro.org>
Date: Mon, 28 Apr 2025 08:54:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/8] hw/hyperv/hyperv: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org,
 kvm@vger.kernel.org, philmd@linaro.org, manos.pitsidianakis@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
 <20250424232829.141163-9-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250424232829.141163-9-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 16:28, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/hyperv.c    | 3 ++-
>   hw/hyperv/meson.build | 2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

