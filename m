Return-Path: <kvm+bounces-41434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CCEA67BC0
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E56B53BAD45
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A96210F5A;
	Tue, 18 Mar 2025 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VPOUcJZI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4204212F82
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321694; cv=none; b=HDrGsHFV2zarvMDX7k9ti8gXtYWY3ZCwGai2ANXsS07ZoPQmx362PvUi0HMQrik1d4FGp2zUdPaniZuCMoLLs0e5H0Oj2doJZGLPsr1x2ulNaulM8GPGpyjvheMWiIkBJTo7WR6ch4yzCyyL/eStMLUpfcnzA7H1k+1pyQbyC70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321694; c=relaxed/simple;
	bh=li6WZkA74zABQSqKyEorPgnTCAdDZzs90rTYqAi1HTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NiRYzLxCa7G4SRBMyMklvwYLN6OaH5PM3ZIvglcwMOra8VxJykxvMweKJsrjv7B68rUa7QdLQUsmgzR94T50W58c+M02WTsXgtjZb+fxcqWderU/sSGJ3ENd2VfZilWsuzTHdaHIKRE5wPAwzekeyOETsBB2PSB7M/axL24eSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VPOUcJZI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cf628cb14so23969135e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742321687; x=1742926487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BHwyXtD9sEyyGr5c+FuZRLUFIfG7HhOrVMbvojfaBjE=;
        b=VPOUcJZILiBKn0hAPPFX/bCb6MQV4NLYU5IPw+XzMbQB9L/+UnExwNJ9K/IlOsEfx9
         iUM823eViZkPTvWmAxJBR85OZvmAHh083EOPSEKfy9z8gmEaFLO7qgTL9qTo1v55jvsW
         k6S7OoK4RK0U0hKcZi7/XbtVXRwJPqLmm7mSty3mewDD0f5wkSjLwDtEe6j+v8tErjNX
         4QnLz1sCOMBCHeJWTmY2SYxyWtfvzpIWbKouIrdka2O3tYlS0D5juUOh2EgCKvd0TvzH
         LusYQ19ai7s0Dy+eqqNzkk2uE5xFgecqUaKJRSjYFuWUqgkP+fLNjQOfSR6T/AulJxHx
         x38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742321687; x=1742926487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BHwyXtD9sEyyGr5c+FuZRLUFIfG7HhOrVMbvojfaBjE=;
        b=NDiQv9efGMbe9dDzdQncFcPn6r2bIlW5pdPwOhDvbyjVS6BwwS6ht+oGWWurvisdPV
         zFQaeeaGYivw+/WcUhN8bWUQm6EVs7kLeAsS4er5Wutx6klaADYxwLzkceEfJU57WfMw
         sdzBwifm6pXKublfPzVr+W/EdFJfnPs+qiVvDj87x4MUrRBhowJhyVwe+pYsmrALboCT
         /D9/jrZ10yFDUjXTP9YpgJHMxfrNTOitkWyqB/lgnjGvQc/BRN+LzVk9/MGrfT6jPWyE
         itQPCwuQbGseTCTptBU0m4MchtdF2EaPssPxYJCDFs3zvq4F4CZihCMFJUnPilb57KV6
         qmiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVodlOx+CNRZ0GCOsAhtO54FsBHMD9WFZaRkkDnE4ipSrYbeu30WrR61LHSAcjvPPV/4eM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCVulg5VFaT1QGIYSednSLMPuoGcj7AYlFsuazX1NFRX6Wqdsi
	Q338XN3orH1Mh0741Shu7G3JMUM8Ys9x15dF5e2lJfcFlMGvMDqNk/aVYaOU5Uc=
X-Gm-Gg: ASbGncsx84R5byLUTq4FbmBtviChLHYHAiNwv8Kz0Mr/uIDVY66QQ17N9FmB+DlSFOs
	s2IcCbFHDYMRbnAQkhglJmh2pHETEnNktVMPHiWD519fojxY/gzNMfCAosXGXBxEO5BI7LXMjih
	RIxBsUIoa9GNYrfu1XX8eG3V8oPYz9CBIuZzXO/TRcFufy+r/5lMuX2k32Mu5H1zZp38dqP6egi
	p9i1xvhw+/99F9msTnKb50/GfU6L6dhN8f7Yeauz6yFulfxWeqPzXjkzYZ60nXsNTimEiVO0Nsk
	Q0/oQgkEpKiopGYkwr5LimbHI0B8W2iPMPUD+N6pVChZ9Fmm2x66n42C/a5I6o5iNPy6UftSG2m
	aUrWcHhC68mfu0gIFnK6c6rU=
X-Google-Smtp-Source: AGHT+IGjFHimgPwrXJB69701bffChbLD/HEoki8yIc2rRZawW/+t712tZ7qp7WVYQIXal7RK/toejg==
X-Received: by 2002:a05:6000:1f8a:b0:391:2a79:a110 with SMTP id ffacd0b85a97d-3996bb57561mr3621625f8f.29.1742321687133;
        Tue, 18 Mar 2025 11:14:47 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8975d65sm19100205f8f.56.2025.03.18.11.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 11:14:46 -0700 (PDT)
Message-ID: <fa3c4676-f78c-42af-b572-559640c0e4f7@linaro.org>
Date: Tue, 18 Mar 2025 19:14:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] target/arm/cpu: always define kvm related registers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250318045125.759259-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/3/25 05:51, Pierrick Bouvier wrote:
> This does not hurt, even if they are not used.

I'm not convinced by the rationale.

> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 23c2293f7d1..96f7801a239 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -971,7 +971,6 @@ struct ArchCPU {
>        */
>       uint32_t kvm_target;
>   
> -#ifdef CONFIG_KVM
>       /* KVM init features for this CPU */
>       uint32_t kvm_init_features[7];
>   
> @@ -984,7 +983,6 @@ struct ArchCPU {
>   
>       /* KVM steal time */
>       OnOffAuto kvm_steal_time;
> -#endif /* CONFIG_KVM */

Maybe we need an opaque ArchAccelCpuState structure...

>   
>       /* Uniprocessor system with MP extensions */
>       bool mp_is_up;


