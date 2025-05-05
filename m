Return-Path: <kvm+bounces-45462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C42AA9CAA
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29FFA1A80F33
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512E11D7E4A;
	Mon,  5 May 2025 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EKxvmqPn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93C823CB
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746473625; cv=none; b=oKrQuZBCE9K0GxXiUq5Pzw2+bB4iRmfF8QtnTDG0vFnA1EjH7zFZHazIXLRkMimbzldmZqnzvqBPfXZHUXt4dFCfHkrp0mSk2CeADrTJtO2+7/6BQ7TU+3xvBFzZt2kpUpp+yPSsfgwu8k7ah4S0zqrcmy30cCBrz3/LRupEZTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746473625; c=relaxed/simple;
	bh=oCh2zDDvwaIeYGfHRd72BjnkQb3JMSK5BXZw7um1qYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/yXOdR4v+fvgMm346MxlRTF6avXDyQEM+RdpjzxlnE9768WpCPYhzAG/YpyxNEt8oZfJRhsntvDc413utD2B/fONx4dtZlvDjk3bg66P1HNVMkPd8mZP0RwsrpsIwSTt0Bsb6ML2jZ3hG6UiMcN3pAzx2HR7nt5fInPyogyJ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EKxvmqPn; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22e331215dbso1713145ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746473623; x=1747078423; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vWUJ5/LQMFceJ7l1Ffi4cUdM3ed9wHY8/6UU56HqvrM=;
        b=EKxvmqPnK/GCwjnuEGaCDVjIBlRsPbwHFLQyrQD6xQFa0lCjOzYHvkvGadHT1smjck
         DUbHR+lpXGCuaxFcAQSLXK3FuFGAZXeU5vOOI5049TzglgpJvQb9XhNj3L+TzANxYACe
         dzMSGEGH0emOFfPsACdbW/URGHKuBuKedBFn0o/IzUABHouipBGcEEwxyiNHq+ULiXbd
         3xFSUuauAGVitUm0MkifEAUdybFCKD6HiqngLo4G0y7avSew7V7/QHyQiCpiiNV3EV0J
         izk34moSjTirlQjvyNDVjtCiCHJEQVMuvbm7XHcH4mN7BvFRVNdmf+oeiUD+7kbT8UaR
         f4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746473623; x=1747078423;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vWUJ5/LQMFceJ7l1Ffi4cUdM3ed9wHY8/6UU56HqvrM=;
        b=THOOFMTQSmCqp7e9wsQWHLfEkbwIwQhm+CIsQOF3KhqhquVrtf2+0/WCmbRNy96B3T
         i5mgv9n8q4wR5v5eBUnxuczm7WqYsf8uLfDwpYAAgMwjzXIaqTZUtifsN/Sh1xFgb28E
         4fRd0rFZ05qIz2SdIJgNNU/aOeP7YFYUwpxZ3txIGt7xeVnd4mh6CYfiVS80QD0Wr/2v
         YrW/5LR5FqIuxNsmLH3TcJ/+jq5QtREIY1D4Kv6h5Exi2XJGrp5VIjYzbVgbJICwqhto
         ut50ypViNHgmjoqBKme0J8Bof1xGpRBeu9/pdpLHZ3aYBQcywDPJumInYBJ9Mwb2oBT1
         WZ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4XnwzI8PbisM5i97v8yNaXIgW8KGUyKr+HqlpgpHn0s9uP1dhd6bySjvW5yx5ADH502M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBmcNrd2qON9msyK++mTF4XnXOX10IGOeS5D3yJcMTjlH+4oEa
	z6UeC37R3xF+DQI5ef5EC18aerDkfbupHgCJbFOYMQ7ynFjMQi9HwSWLVv6HlrU=
X-Gm-Gg: ASbGncsJamiHL1novqUdcMrs89uc/Cb5EA+rEp/yrNhvjBCd+ZxLvdVivVnx3mZ1hoN
	NmCMMuarEUj9YzlexBSZ4tZt6ekQbb6SdpIypfSV9HgU7Y3vZoqS2CIsCv/0iYTUJMH9y1R044b
	zHD+sGbq8hBvPh2F1ArAD7AqAB1CKzp2F08hhQN4vUiOLITsXSdiyjJFG2lsMfw4w0ZXZID3er1
	pphkin8dUbk/xbT8Eg98Px9WtqHodsLiwPBsDY2fhod2vR3l2ztFuszz2pPkGZq+w+Zlm49LFTw
	kvf35hDUE9TFX66MX9K88ZUnTBFCZH2/b0CxLMUlQ01exyOEzM5wxQ==
X-Google-Smtp-Source: AGHT+IEX9V83EnaL/ZcwpR1eBzmw998FIZZRQI9U8y2GSW1Kc/OQM9yPvI/71pp5QWhFctyPBRWNWg==
X-Received: by 2002:a17:902:ecc4:b0:220:fe36:650c with SMTP id d9443c01a7336-22e328077efmr10171025ad.23.1746473623187;
        Mon, 05 May 2025 12:33:43 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151ebd08sm58947705ad.104.2025.05.05.12.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 12:33:42 -0700 (PDT)
Message-ID: <85513f8e-232c-4d66-ad03-15c4f697dbae@linaro.org>
Date: Mon, 5 May 2025 12:33:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 47/48] target/arm/tcg/arith_helper: compile file twice
 (system, user)
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-48-pierrick.bouvier@linaro.org>
 <e8eee40f-3785-4816-b96a-af022b3031b1@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <e8eee40f-3785-4816-b96a-af022b3031b1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 11:54 AM, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/tcg/arith_helper.c | 4 +++-
>>    target/arm/tcg/meson.build    | 3 ++-
>>    2 files changed, 5 insertions(+), 2 deletions(-)
> 
> This one doesn't use CPUARMState, so we can probably drop the cpu.h include, and thus
> always build once.
>

Done.

> r~


