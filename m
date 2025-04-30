Return-Path: <kvm+bounces-44965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9244EAA53D7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CD891C22E07
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB72D2690CF;
	Wed, 30 Apr 2025 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jcE/CMF6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A80263F3D
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038381; cv=none; b=Adtf+rLOhBKp7MSIR1mGJoczDlx1CSTkai7c8tv6GYXieiHpZtQIhN7/8Pftnpsw+3UBdJ+3zYo63t4ptKsXppXFFJPopCwZDKkNzMOW3GVmiZmtkANAPkX4NJ2myR+gh1H0Csu00QdlkzO4Xi/VwjFkekRqMdvl/2pSXS4T0wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038381; c=relaxed/simple;
	bh=WdT3ZV8uqfRyyW2hRRvfISGrhig9WoPE+xo6tHGlOk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IoyC5CpEQh9BEmu6p1OfncUui2vh2LbOP4glorHQlnWPfMnfhTumqVCzROU1mAp2asv83uROhVQPoXzLDu8TC500i9t7kRKpQUJGqB65suYGIng2EYqQYdD7JbWgLUQERtY7IDLipLioSHqUBHlumTktPRbi0tgWH4TWLbPR3FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jcE/CMF6; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223fd89d036so2238485ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038379; x=1746643179; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ff8Y6zqBYXNmm9gwXG98+NPFRnuYVDI1VQURvXQtWA=;
        b=jcE/CMF67eLfjXvc34/qmyuy1mOopsEBJBD+yO0Kbaq7M752i+k+WdHp3s4qulCSMT
         GK8nI8oGMNYTQ745NfIl/dEC9PAPFeKIvYHaiXb2KM+ZluFTTauz65/OopG0bjADt7sT
         U83wBVR489FJhZy4Y5zHDBS9BTo2lBFn3tXyrcIfUzLWokyw8DDmH5Gb11+ep4grdwhR
         q5d6DJ+lzbIWqMq5LDfDaMCzyybxLiqR7aLqu8Xji85S28UEKxvpdVbdP801jpZ5clAk
         2EEeq4C09/IkXZTh94+pbP+lFqhodYr8lPhHErmWbCAocg4b+v05tmqUlMgI5zU+2IvR
         scVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038379; x=1746643179;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ff8Y6zqBYXNmm9gwXG98+NPFRnuYVDI1VQURvXQtWA=;
        b=SY3c7yz9XZaHMWehPiSkLy/6CAqrIcGPDKpCNQ6cujRIOj/JfOYG8QUTWPFmYBnF3b
         M9VYEud2V0yHnmR7NSP6aGyHa62tb0/+I92mJINicnxUL9pZjlQRYPDB4bNnUpgHhjw3
         WgJJbuEj1YdgQe9RKJRjjQV5jqKkyecootfFPEtvxXf4M0b0hCr5rmLP9vk0UEEFEHb6
         +fIxIUNn67MJmUXyVAuv4v82gXC462wyIPCaLTsU5MiQoG7MXFILreXyuOHZqnGOqkZX
         DiAcUfHBEJCLgeLiFjhk1EuCuitayknuzwcl5NGsFOwWsnAK8F0ywc1el/ywf816gPv4
         6cyw==
X-Forwarded-Encrypted: i=1; AJvYcCX4/8D1BdnCD17JBDXYD1u9zXhqypTxvHjx2eO0UE2t3/XE5Glf8tWT8sNwrLzR4Eljh/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsUQQoM1Ud9WQ+V/faStkH221QD77nVvP82iI7tQSeIQrX0ENz
	hr7JSsqFdm7BqYCBoNcTZHT3HkLbcbNsKkx0F+QrorlVi8Fd/2WBPJUJUjmtBEs=
X-Gm-Gg: ASbGncuTEs3NteEfY1afm11Z4ZlVPO2/kK27C4nO8Vxeg9aOnD4rkoEOGGw4aJ9HC/B
	MHyxmpHpSXOzBNeoDV+C/Pp814IMJDsGrx7YmrhCjFJAEyvvZFqVdvW5lVmVGG5SVqdczDjOGfL
	c7EpSyixjhnBCkGGBaoRzIlS89JdQ9GK4VDl37Si2Ia7SX041ZkzoRwOBziRqPQCDlh1TV8l9cU
	sbsBZ8AhaOR4I6aKIC5H0leWR+At3OCA/sNKz32X7xFTg3LfxscwPfCy+JCXpcOUG4YGKrje2+G
	tcJYHKNnmHDlyg/JWuO8OcUvbXIgrdX3ybTLJN8kwkpeA0+fMNa2xgJrLgSgyDjvbXrC8MBuas4
	Lv1EfYZU=
X-Google-Smtp-Source: AGHT+IGXF4Fgw1kYgpyx8Ulqwz6AW0vOTKOeRFdEg9TqKru3gxSbDPa1DRENkGOwQUFTbr6oFy/sxA==
X-Received: by 2002:a17:903:3c67:b0:215:b473:1dc9 with SMTP id d9443c01a7336-22df5838ca7mr62603565ad.46.1746038379655;
        Wed, 30 Apr 2025 11:39:39 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5103259sm125531555ad.185.2025.04.30.11.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:39:39 -0700 (PDT)
Message-ID: <1c9aa799-4254-45de-9918-435566299b2e@linaro.org>
Date: Wed, 30 Apr 2025 11:39:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> Needed in target/arm/cpu.c once kvm is possible.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm-stub.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
> index 2b73d0598c1..e34d3f5e6b4 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
>   {
>       g_assert_not_reached();
>   }
> +
> +void kvm_arm_reset_vcpu(ARMCPU *cpu)
> +{
> +    g_assert_not_reached();
> +}

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

