Return-Path: <kvm+bounces-45451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 106E3AA9BF9
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00D143BF8B9
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA0C26D4E9;
	Mon,  5 May 2025 18:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZxIcP/XV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB4BA49
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471111; cv=none; b=u47cXiPSRBVKbclWTIomu9RBNrJGXgbleSY+OreMOMc213phQ2mbknxdV9QmUviGYxTwsYyu3jjoLqIwdOPjEJZDx+GzqqCWsZDMM+eqUOJMIHaiBqDEK8dHxohqaWDv1wXGVZMliwJtnawfmHQRNgknYEhsd5JFkHFq/LobN+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471111; c=relaxed/simple;
	bh=Tljaw6zfdJ2rGJs0z5jBIwEKBRf2/qURGLCCnDHV64g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kMkL2LWFejJ8CJnlpe272W65gbPGKDKX5dk33v7KBAbQG9cHpqB6Zw1iK44Rbor/ExEhAknnr0xtnb05sRxHZTummwM7BRtdQ4G465q+xnQe3aPn+Fu6efUyuGrq9l5mm4erCgJGa3RDEnXsyF5b9ozb2FyFCccaFbV1LsYNnTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZxIcP/XV; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-30828fc17adso4682087a91.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746471109; x=1747075909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wFa5afTFllsh88Fa9jTh0JeUcoNick2xFbmV1V5kyxg=;
        b=ZxIcP/XVff0/Jx5E4jFZuiEiZpQldsMYB06EFPgy2onwh2zRj0uJyzf8tE+jb8IDJm
         Q+wg2q/jTpTDoc7bUR7uI++WifN7vT857QieMSZlHWj2cu3Sj7QbSlcbf9mkD6Lm1fxF
         6enVmoNA8hzJSIAbRZWIPHCcYixuTkpMA4MXRf3W4OgHXSSRMlbpgkpnMCtOE8+Zs29B
         BJPvxAXR+3v91fe/5KUzohxW/aEXQUJLDbyB48uxPKeR9ZPf5ZVtUCqOyeIEkIcu7ZvU
         CECAAIJmWeIAfiXlcpwzmLkYONew3GjoYh95oYVQQk/La7sA/hsDL+34vnisFO0s6+ig
         x0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471109; x=1747075909;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFa5afTFllsh88Fa9jTh0JeUcoNick2xFbmV1V5kyxg=;
        b=u6BBvXnUWk+pNIGX2l/0byaQx1EgJnjd6Mif4qvaD2sKEeztFtaZiPgPBpYWwjRbZV
         OyBcfLIWBWNpWwGt6bY7dGiyZPb2MpSjMXaxPKUXjNqSREVQMDxLLXHN43m27CsH4goP
         3IhJ6p056pZEVV9bD3A0mdwOUQU9NI0uEbTVtYo9kGu8eKwZtl+xh7wbgTYfGMwhTLnA
         VeVy94mGR++xk02KTTZSPsKH/H7bAGQ5DrYhZ/j1qOJs6Ep6cjDeCfJHV0qzVyVyFa7g
         icrz+0azLH1HOIgUZqmAjvh0XRRIeAv8TQ7oHKcZfo6SQTKoWdib52dU1tKdotJwxy4D
         udIw==
X-Forwarded-Encrypted: i=1; AJvYcCXvfmBnLvXFkTUwZkbaFd8NRszI1JdK/lHxljSbo8BGS6AzRMhIy2o+QBhVdHM62DDBM6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YykDA/iFC+H06skwAXeimmNR3A7qa7XLpH9bAouPI4W0s4R4Vdm
	5ZDHf8Lk9y21bNEPE4B/OdLowTJxugob8pO3QJrzB+rRhK2vRVCGZszC8PB7E6c=
X-Gm-Gg: ASbGncuh80Ehww0yhtFKvTxilx8xdu9Rn8qXB1xpPWSe5AbCtOa6HHfWFSZ1fbvLeDe
	yVvH6htYY77FUElGFr87AO464T0VAiyahtkm04WoH21sUkwvMZOdg+Pf/A0b8XTqk8MR+Qc+KuY
	sxdsTZsa0JT+PV5deG3fGrAnR2rK1CukJBgbuF9+quXAiiXxW+sE92vrMRPsvdzVaImKFaNxcMB
	pba01or5cQLw5583KU6aCokCFLHi5w6RAGjRu2UTXAk+0+snF5KfyuBTX9saFkGtNwSRUw8hlhb
	ouJayS4YWj0MKkLktD6jdhUy1MFyoxWaG5DmQAEoL7X9eG18kwKRtsJg/btUFNLwwy17FxTkWPa
	FfLg7Lak=
X-Google-Smtp-Source: AGHT+IFT2VC3lXxrH5o9hFQWMnOfnze8kfwxQwH28m537ex0rGytUEYd+B6nwd6awF4Y2DFyjfxf5A==
X-Received: by 2002:a17:90b:2dc1:b0:2ee:f440:53ed with SMTP id 98e67ed59e1d1-30a7c0de480mr668649a91.31.1746471109072;
        Mon, 05 May 2025 11:51:49 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a263ea6e8sm16512549a91.1.2025.05.05.11.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:51:48 -0700 (PDT)
Message-ID: <7129b772-cd75-4b55-b660-a75d176ab059@linaro.org>
Date: Mon, 5 May 2025 11:51:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 43/48] target/arm/tcg/iwmmxt_helper: compile file twice
 (system, user)
From: Richard Henderson <richard.henderson@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-44-pierrick.bouvier@linaro.org>
 <2c005b5f-1308-4c7e-9b0c-9640aef294e9@linaro.org>
Content-Language: en-US
In-Reply-To: <2c005b5f-1308-4c7e-9b0c-9640aef294e9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 11:43, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/tcg/iwmmxt_helper.c | 4 +++-
>>   target/arm/tcg/meson.build     | 3 ++-
>>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> It appears iwmmxt_helper.c could be built once, like crypto_helper.c.

Based on the crypto answer,

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

