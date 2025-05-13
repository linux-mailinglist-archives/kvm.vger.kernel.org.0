Return-Path: <kvm+bounces-46333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB40BAB52A1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64E171B66504
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37F12517A6;
	Tue, 13 May 2025 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wi2wUtqG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D024729F
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131171; cv=none; b=RCXiJE6AwCG1TZRcDGw4rru5H4AMICKt1Oai1NuodPcoPEYwcKalnJYyA4BhiNYwtxWjEaW5q4pGShGNbsiggt8+y6bzfLfVd9Bm7gsKkqtdG9jTB+sOWNozdC8cV+K1LMHDm+1CqGep5rBkfnn5fq4Qe+T9bdieXqTee62vHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131171; c=relaxed/simple;
	bh=8M/q7X4HWhzBkdqUfrx9alQOGTs1BqN1Zo1tSOYrIko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWSZA9sIZqfuZwHt5/1NhLIGx/vcWA2Y0cVjhXuFk6twdmMKZ6kcBTUaVQ1d7NFomSwCCAbKkO38jCixlXmaKQtOY2Uz0D+Cptehto0cUnMTR+S3qLwXDKzlJvGV9US1WgYf7nmJkZ7/j1mQk3CJ3lu3Ev3WtrVZPRIrqVr9p7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wi2wUtqG; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so56155085e9.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747131167; x=1747735967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ep73+iR9WQw4cYUZI66lyvkdNLNSzJz4ByceQve2wXk=;
        b=wi2wUtqGRWbVDwesbLhKRp22Ly9Hoj6pKtV8gmZI7THmyX7/g5zg52M1yUROP6Puoz
         L7qHyn9fycKfIf6NRJiBt/jW457K0yzIJ6LbNGqu2Kshdi2OL+KiwDDGns11TH73svLk
         qUmXMXFWjX/UPS2VIzgFFqzQ+3/qvkyztkCb/oVn1q/rngDqsH52na26NneQlh6h8stI
         funnXF4FGVO+srOzJJj4cOX6ppCKmp4Jo1RIOSlolL90AKBRaMZ3ozRHC1l6BlER215X
         JKVTMpgJ3dGozyP2AWJANNn/Vs1juFcB8pD71WK0r8quaH9jFImtAOo4vm8CU8cuu/sf
         hb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747131167; x=1747735967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ep73+iR9WQw4cYUZI66lyvkdNLNSzJz4ByceQve2wXk=;
        b=kkZ4Z75CtmiZM7iIqv1dHYdhnMfv7FOigw9c1b6fon0zcyA5+4mTCcdgKt1PLaSD1l
         azjZMlVVkDRKr7hz3fa0wJHTCLPS+utJV8/M2ylvg1GIGPNNrbeK3ZX0WLoTPIB4psed
         RzZVkizSHc5jb8fxRCQPgQZr52ZV/J2FjC+87nzBmHNwOxTUmxR3u0kZT9fJaLdl0sQS
         uaXJXcfSgfk+aPDpEN6SIPi/LJSBNMWa+hn6HNFi88sG4QFs0AE1nvit4/+rp0Rean8Z
         p7kE3siUCc8DN41yQa4Pdjm1N2CYQ6EUxiSQOGfqdNDspV9Nemb9Aq/9vO51F5O8K/YJ
         SlIg==
X-Gm-Message-State: AOJu0Yxidg/8QZ3wzwtzYroD25Tk72sg8bPg1oisxthV/vbgwpSZMgzO
	omOun/NfHgTkajFrL9XZIo780QSoRpwjH1PgN6xrHRgtHAnFKOUgoI4hfrufauo=
X-Gm-Gg: ASbGncvTDvjaNF7jtEoU/wJPlaQrpJZtkvx7k+8HlvknRfcT5IK+Ffxv0hwsnF3MriQ
	jo69NuDllyIUYLfSUu7C8A1aOEgzYQsowoIRwVsutS/Ql+wTDBBD9Faiy5dLhYEY1r0DxDIrwf3
	uL8cHIlyiNP3grQcdmi6tane6cSwqXQRv4IMoqLD/E1QxR5QD+okdTl9YlWAT6Mf1mf7+zXZXx5
	VIDoEyLqo2SmgeInEO9XagYtCtRBqi8sLQ8U7rsIbo+caclRNsV38ZZXMajMvDM4TkZHG+lsApB
	S0bj45HznLrRYevSbUddS3cMD/FSRLYRJ/v7+2xlBlCjPrTSqp0o5GumJ9S1PrgEU9x3vboHdkg
	QxHsxrSPJQJFtPSeOZw==
X-Google-Smtp-Source: AGHT+IGlvyyiBeyR8RnzU+5gL0728y0wVMx7KNEseOzxv+itBz68UxqnZpUnNfrcA8ai1zln4TfSIw==
X-Received: by 2002:a05:600c:82c3:b0:43d:160:cd9e with SMTP id 5b1f17b1804b1-442e9f4a297mr43907375e9.17.1747131167445;
        Tue, 13 May 2025 03:12:47 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd328535sm210133285e9.4.2025.05.13.03.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:12:46 -0700 (PDT)
Message-ID: <354c9708-39e4-4106-8333-34ae6cef2bc1@linaro.org>
Date: Tue, 13 May 2025 11:12:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 46/48] target/arm/tcg/tlb-insns: compile file once
 (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-47-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-47-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:05, Pierrick Bouvier wrote:
> aarch64 specific code is guarded by cpu_isar_feature(aa64*), so it's
> safe to expose it.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/tlb-insns.c | 7 -------
>   target/arm/tcg/meson.build | 2 +-
>   2 files changed, 1 insertion(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


