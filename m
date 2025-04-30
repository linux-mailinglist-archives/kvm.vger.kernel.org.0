Return-Path: <kvm+bounces-44979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D69AA547D
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 21:07:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0A1C5055C4
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 19:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732C8268C73;
	Wed, 30 Apr 2025 19:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mLjfH+CA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B2D26563B
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746040018; cv=none; b=LUz9SQln3x8H4OLURVO3GV2ncyNU2Ho9hz7ki5CrkoRX6D8LlSB5x5a2UCuivZMoSdtVEUtC3gdGuxxshQUa6YnnMa3vwfmCgqf7cnqMNC5o2RcYdKxOfoSAuXNYAOQcwINtFoi5CGaVBgzbClDQ2rrNSTuji1mxHjvD4pYmxtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746040018; c=relaxed/simple;
	bh=hkyFUhoxO4EOBxTryJJh5ZXHpyQkX7NSqRgqMRFaScY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JlOT5gh0/MBOt34vFBktUt4Tf2u1JIKCXKdeqNMYqgI3wO0+H20HwOanp4nVXT+OzGCqVXVvpgpn/fxJFYGqbBcPJRGwhpWDlwJBYXMC7yt9bzKPBYHBHRuUdmmEfs8qXlwzmOAuHyEwjQQdtfMG4JFNnG7+KbJsGyxNiy6qdPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mLjfH+CA; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ae727e87c26so140343a12.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 12:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746040016; x=1746644816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oHH/CJ/HNr3q5RCvWrg5ycf+bD+rJTBVJLQQPcyxTPE=;
        b=mLjfH+CA6kXjPLQPcI4SWOM4qFQiEfgBgZIt0u0Azcg70tyKrU5bXVsAox8AMDwFiK
         5dqt4V7ladlRm6Qt/EXp5YTDfQ5flRBdrKGRuHkBuFtzq66dWxDo+k1tzvDTr22/JjXE
         6nPYvqkrQTeDPQ4yEQ+RKTNZ4HgOTwCDb8cNYbbcdbpBTJrkYZs24thZ9nmGPZQoUnYZ
         aj1eN1spps7nfD7v78Q0sue7Z/Ok2BmNtpT6UhZnH3W6fehToUiR7qD975RbQXbYhdS1
         ukfIvYGLpyBdvRviHI5kLAV5BxS1jQaQgtRsakX68UOfp1M22G6r2xZy9yRbyuHBNk6I
         x+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746040016; x=1746644816;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHH/CJ/HNr3q5RCvWrg5ycf+bD+rJTBVJLQQPcyxTPE=;
        b=k2zmvA633KhRof2ha8RolyWSJmu/IdXAP9+4zPm7B0E0jDzceaOw121NytSF8gc2Mn
         90rNWMxmrUkAILQlcYNxttrgKmOKkbM5tZwT6eKF27KON9z8oi5VXZVBuXexHyAilVwv
         U4taM4h8zs/RQEPtzP8VUerxQR603ZeddZYBMGKUe1cq0Jr5POpC0l9/UZqsk1tgZgP1
         7gX+NG+3Ombb+AYJjRCJ77TtXLJuYe0QypzzEPdKLwPY30aKfAseaYt7AmyPGdqjc8o9
         SPPovAcgzrYfT9uLBu0N8kAjppDuSD4eEV2/uyT0qWW3Casv1p1EnJleiU53g8Eof8yb
         dUow==
X-Forwarded-Encrypted: i=1; AJvYcCUDjo+YZHnhblT+cHoxTzr2/49ZRAmxzJpFIaOdRdI/1+RL1TdW3ZJMoAzJhs0vtdBSSUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUvuh7GPT6VFA/McppZ1oCLR3LPrxmd9tgVePuYRWP14wza9rz
	8HUZUrD3PQeh0VNZsdcZ8q1e/1GIe/UG9AlEDyFJ6qtp05vrTZjXQcLqjfbWjN4=
X-Gm-Gg: ASbGnct2PpG12RFaoN90Ol6XOUHra3LX4IgyRjW7HGmZxnD+4kZc8uru359U94aiDIW
	EVvtA+YORzkxIqEhNeQCFSLPP2KSfTnEcWeqCd4NXB1GwEA+UxSwfeydox7K5GdzbZu/xIZ8p43
	waXrPd9HSiW4lsMzFhMcOYVkCaBz31/RsAcbYV6eoPaQtZ4rONikLo+TfNR1sjZjheKo9KeybSX
	01szWLSdz/hdvjQYPmveYyIAQ/H12x8PYD4jvsjjGJagVlUwU7fQT4RmsMj67hznkz+ydpH7Vlf
	M06BGq3oy31LCR6gK7owXxBaXH723zYwiIERzY/CRIG9WrB3z2j4jw==
X-Google-Smtp-Source: AGHT+IEmtsMxKzfl913AuCQz4vQAnUz/8tQEJ0yj76c7JEnnFdJLPruhJNFw8n2y3PV37pbT1B8rvw==
X-Received: by 2002:a17:90b:5347:b0:2f9:c139:b61f with SMTP id 98e67ed59e1d1-30a332f2c24mr7242936a91.14.1746040016332;
        Wed, 30 Apr 2025 12:06:56 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a3bcf1sm2018153a91.37.2025.04.30.12.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 12:06:55 -0700 (PDT)
Message-ID: <1e223128-a2cc-4070-a7a9-9a34e5abded8@linaro.org>
Date: Wed, 30 Apr 2025 12:06:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] accel/hvf: add hvf_enabled() for common code
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-8-pierrick.bouvier@linaro.org>
 <db654764-8377-4080-8f68-7fc61e8eaaae@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <db654764-8377-4080-8f68-7fc61e8eaaae@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 11:43 AM, Richard Henderson wrote:
> On 4/30/25 07:58, Pierrick Bouvier wrote:
>> +++ b/accel/hvf/hvf-stub.c
>> @@ -0,0 +1,3 @@
>> +#include "qemu/osdep.h"
>> +
>> +bool hvf_allowed;
> 
> Even small files require license lines.  Otherwise,
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 

I'll add it, thanks.

> r~


