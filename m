Return-Path: <kvm+bounces-46340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 004B7AB531B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56F8416E52A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F9826A1D0;
	Tue, 13 May 2025 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FuFp7PRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B4B265CCD
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747133126; cv=none; b=TRBfAQe9lMBF/wWL0kWAcBPrCa4TcjOmJJfmi4pMKT/liReFdmBsjuvu4Sow8J+qvtArgqeIx7bgIa7sSyhcpJH/Bckeo8LkScbK0a0EII9h8FSslfsnXWZzjdBiOUS3bdJBPgcp3fTKDzkCDRjFCuxLePw0pw/esICCII1p+zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747133126; c=relaxed/simple;
	bh=ek4UBgiuVCaeeTxv8pO2pP2X+HV0btjAOzBk8ETFh6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fppTxXTwgwrjOdF3sUSXpwRCGTqSYqM4h3k3PZQDPR2hwIB/GNhIlanv4rPE4yFQaGTrm+CaZimng3pStNKWONvoT+BSqpYXimcW9hKdwGK/oVPX8UpR/sMIo7nPC3SQsNKVK5g9csUxuAW7T+VBNhZL4BbM22V4bZvpGp+WIuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FuFp7PRO; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a0be50048eso4142463f8f.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747133123; x=1747737923; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PQV+7dB2bIIgAZan0TAPV10yQXx671Pd1FMs0t1F1F8=;
        b=FuFp7PROxc7AacklH0JCo/WEYW4pQkJg30BCKOjBqb30oESBSN8n2cZkTVRfkXsItu
         xgaRhdJv6iE64+WWd0oQEwjM673iH0nZJjVpS+ueg0PQctolvf7NQZ1qU17VlWAd7gY4
         Fnz1DMoqTFfZH46UZv0k+n1LvKLcAn0jDdSZADtughrID+HZ83blj/ggr66iUXr4pGys
         V4xFq44GuAZ3oElrW92NFYVsaNpbj9y+e4xoTnmkhA4UmensjkQOAFeWGezKzhfuIbd8
         yaAmgNlYjBpdNCJEMWTECu5vDxeW2HfoXzaedjVa6inBmuHrOqHnEULYgdv0l76L5ME5
         wVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747133123; x=1747737923;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQV+7dB2bIIgAZan0TAPV10yQXx671Pd1FMs0t1F1F8=;
        b=aH0zo+upuNb5UMFet7X9e4/M8Y1m7AA/oZQ0VIvwfslEUKX9OKrESX7fxZItzBx/tc
         m0yj06oVSDS6B0F2VUvVf+nyb+uPQlVDqj5OUIdtO2Vbu+zwIyvbuzAc0p6a/Du6N8nA
         n3nVwhfp0zUR3HUQycrua5C9aUyuddu0uW++yQvXCazcmhH2VSB3uB2L6JwQRNNfNmlE
         Oh/jbxVgf2SkUxeaIlzyFAEx/yiQWAlWY1aXoIi9N6EZQpw/3AxqvPg7IC216k4rztYS
         3hUez+gpWp/RQywtaZ+WjT+2xRLzVCx0ltJd11qvfs/F2G4hGe7eBhyN/CNPuqDvUVZ5
         AfqQ==
X-Gm-Message-State: AOJu0YyFmowIzG6LaezK7QcB+BnNr5BTg9ruxEfXNG9CP/tUR4gMSsmb
	sbDZErfMg+1JPDAWbPZBwNiwG7OF6hma25af4YtgzSdAbryJ6TzOtkt/6hvIUIGcjHwaf/7r+lD
	80oWZkUO5
X-Gm-Gg: ASbGnctU+toI1jN1hIH+x5XZOq8XaR2/ATuYJUE7auDezUlJ1Wn55wRgMIcC0y7bshj
	i1V3gyASlPxtlLEh6vwZiwileSDlZCLMr2uGswoPKbnEUFDJkcexXqjdRjrhI11aEj6SLcmirvW
	zL1LbOm3AqSVueg1K/5teiUzE8Kn/s22arIX44sl05jaJNKCkQGPNX3FRE7RuKfEGLGpmTBv4+3
	TmWPkg5CH2Yzw4qnbNXDLzjezjg4XcxEtOiKGz+7ZfComkyesWgpBjGHGkjpSB+5qAPWQgEHYr/
	F9Kb5VSR2HDtRj0SeZdM3EADRB638r7XE9/NoQx9L3PuuX+/AU6Wpv/ZFPdJPmmp3XVTQ95aV4/
	pDQflKIo5pO1e7264yA==
X-Google-Smtp-Source: AGHT+IFw3reMRUBDNST3NUnjyeu+5GloTdANb9TuZA9BtpnHKd4htSDtQ4ZnlvnFdVWLpaXAtu6R8Q==
X-Received: by 2002:a05:6000:420f:b0:39e:e438:8e4b with SMTP id ffacd0b85a97d-3a1f64ae792mr12932586f8f.50.1747133122641;
        Tue, 13 May 2025 03:45:22 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2ca31sm15852338f8f.65.2025.05.13.03.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:45:22 -0700 (PDT)
Message-ID: <7c4e1607-98d6-4040-ab78-317fb6a58e68@linaro.org>
Date: Tue, 13 May 2025 11:45:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 36/48] target/arm/machine: move cpu_post_load kvm bits
 to kvm_arm_cpu_post_load function
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-37-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-37-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm_arm.h |  4 +++-
>   target/arm/kvm.c     | 13 ++++++++++++-
>   target/arm/machine.c |  8 +-------
>   3 files changed, 16 insertions(+), 9 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


