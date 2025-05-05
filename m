Return-Path: <kvm+bounces-45440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AEFAA9B4B
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED38F1894791
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18AD2566D9;
	Mon,  5 May 2025 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vpFL0hrK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EC215E90
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746469008; cv=none; b=bSimVEfj38RABgSHWZ7nD6hD+sCJYza3qotBxmw8fyilQVHs+dknoFv8SMbASfJ4fxYBRvvM9QIGBtcOS8o3LQLylOugQZHwSKoxYqAJ0n/uOP3rIjOcEXTeHwAwihHQg5SF6yzTwyVerRfPP0MfJ0c7V0tekM9kMqx9DAdC6Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746469008; c=relaxed/simple;
	bh=L55cClWuFUsecqmygZln8UmvHuHg/vhCJ5q2Txq/SuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4Ml3DDNftWvXMh+nS5+qwYOnMm+QCd8/nklicbW00dlTg2RiDRyhTct7qpx4k7e83VBJf8cvai8Mem7BFvv/50SzuMvWWPZEfq4Mo7UWob47lWMJDhOcWRzqrK+SAcPRZgjrE9jsuxEslp4w28hQ/aG58YmFVR7cUAzhRMA1xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vpFL0hrK; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so4519774b3a.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746469004; x=1747073804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BchCeEPL8wuRtLs78ZrLwBtVoYzaAUcUsNidwPxVufM=;
        b=vpFL0hrK+Mwzw8zVT0rWi8oxRCWhxFo0WAiszeFPn4pAVoX5o/Q8mS1dEB0ZaJ43Za
         Eb5APCq4hgVLJLQSjdp0ATycSb9zGwFKTEmRU9ACSdYp+oWNvkqMlBpGAmAewhpJG/VV
         t4UIRHC0jQXX+1qTSTypnQLr/kj8EvgA+oDnRUAtSK+DjQvAMzZBy+ysH262bg30H7bJ
         7tW2tvQpSn7sHWelz/YiFUCUwjLC5UBMO+ezbpJOahmE6gvTpY7lDMmptNdnuLmzCaJg
         GRy5dfczL54xuKQd1jRUWzxG+M+HPq9N+igP2pPLggsISP19hZNdJKTt3Ki04CKDlRAS
         cdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746469004; x=1747073804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BchCeEPL8wuRtLs78ZrLwBtVoYzaAUcUsNidwPxVufM=;
        b=cMSufyt9jZToi5TGmlx/GAsaX+A9CSrmKdpOdQGR8AN3YOzLqkdHBdgx0VP/0vEV4u
         3P+IDxFdzE/ubK+ZkzaCLRiCAtAjEdNbytfAyBGKp0I7emZF4bbved15esC9yZXnNpB/
         maie6ZLS6dv2GhiuFGh3Y5eZUzEG4ZCIHggzZ5yGePEkDaXAA0oPWWu/oGkavnXA7puc
         RJrpY44JzKXU2EvQmzXELJs4OW2Id+dGICx9Jfxm0dOyQtrmRvPu+I/ZlUxdZFaNnmFC
         pt+/qtWLFZIzPevOrjSHMPr+PywrNcpOl3OhV5fE89uyy2Y/zvnaAyOiJEZo/jr8WQzY
         dlNw==
X-Forwarded-Encrypted: i=1; AJvYcCVykvv59xwSbWSqqxKPmyK/a0mZ50qKx0yA2wOOeWxgsuQYT0YkgHSRKEHgdB7HUqYX99w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZWSS5npGUfZ8EMhZiEtdsyf9hj/+frNatDZqYyYeA3o5VWxiA
	2LIphlk4MCbvjVE9Glen1U44HQTqyy+VUVa0DtXwnyv2R5bMNLALvRxaa7hGAXM=
X-Gm-Gg: ASbGncvxJGbPY18I8UMxr2dk7A3ZgMxF1UP2fdXGEdVg2IhwlhKMFJWUPCRzti2svTE
	UDFYX9e4pZJtzWK2Gzz3LdwmD5zyGUgvUal/rq65x3Pr7Yo3PkVt1B96zr7SuZWrOYETjP5NBh2
	kYYGBW/BOVDhtV22TVrBnGiFQ6p7WX8DShW8d4KandI36XJE4fFc+fovp4YGL/9dSXLJGNxPRhL
	o5IKz68rFPJIpdecBr3JThNIt+It73y4xy5NtMPScEHswuLxNC28ICSMED2sAEgzezqbJergC8m
	N2Qp9dA2Hu2O8jfw1g8GNGFbjucj75BabNWXqcYlDY9tpFxiaTppkPBYetKCvVUGnRG8eXAVh4c
	E4cnp7bE=
X-Google-Smtp-Source: AGHT+IHLaJqv/nTfqTpCIyc/1kl9cKYSzSNidERZv/lJL28Ems3xAyS3U4DNz3L90vSb0ZsaJ7JV0Q==
X-Received: by 2002:a05:6a00:ad8f:b0:736:5f75:4a3b with SMTP id d2e1a72fcca58-7406f0b12dcmr12173654b3a.7.1746469004375;
        Mon, 05 May 2025 11:16:44 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058dbbe30sm7373448b3a.62.2025.05.05.11.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:16:43 -0700 (PDT)
Message-ID: <a4db0117-ad89-47b3-b027-9c4e8cdc45ac@linaro.org>
Date: Mon, 5 May 2025 11:16:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/48] target/arm/helper: use vaddr instead of
 target_ulong for probe_access
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-17-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-17-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:51, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h        | 2 +-
>   target/arm/tcg/op_helper.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

> 
> diff --git a/target/arm/helper.h b/target/arm/helper.h
> index 95b9211c6f4..0a4fc90fa8b 100644
> --- a/target/arm/helper.h
> +++ b/target/arm/helper.h
> @@ -104,7 +104,7 @@ DEF_HELPER_FLAGS_1(rebuild_hflags_a32_newel, TCG_CALL_NO_RWG, void, env)
>   DEF_HELPER_FLAGS_2(rebuild_hflags_a32, TCG_CALL_NO_RWG, void, env, int)
>   DEF_HELPER_FLAGS_2(rebuild_hflags_a64, TCG_CALL_NO_RWG, void, env, int)
>   
> -DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, tl, i32, i32, i32)
> +DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, vaddr, i32, i32, i32)
>   
>   DEF_HELPER_1(vfp_get_fpscr, i32, env)
>   DEF_HELPER_2(vfp_set_fpscr, void, env, i32)
> diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
> index 38d49cbb9d8..33bc595c992 100644
> --- a/target/arm/tcg/op_helper.c
> +++ b/target/arm/tcg/op_helper.c
> @@ -1222,7 +1222,7 @@ uint32_t HELPER(ror_cc)(CPUARMState *env, uint32_t x, uint32_t i)
>       }
>   }
>   
> -void HELPER(probe_access)(CPUARMState *env, target_ulong ptr,
> +void HELPER(probe_access)(CPUARMState *env, vaddr ptr,
>                             uint32_t access_type, uint32_t mmu_idx,
>                             uint32_t size)
>   {


