Return-Path: <kvm+bounces-50706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C2EAE8790
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1F8A3B8DC0
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF26D26A0D5;
	Wed, 25 Jun 2025 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ct5h99Kj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A9726A0A6
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750864338; cv=none; b=ou5xup/zbxwdeQUB3tW/cqQB53528AzN7Pzkj4X1zMfHMeVKSVf5U1aKxY8tNixJK5qHUZTfBQaL66R8HXZUbGjGJyX87EA62s4gIaoW74EozdeWDkY7K3+6IUb7F1bQoqngab2PUoDCX7g/FmBEZW6Ttf8KgXyzhdKVg73pSlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750864338; c=relaxed/simple;
	bh=IeXVjGCQcRrhO8rS8qFx6QkTLfsmeL1Ybd8CIJvHJk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ixi58Yc5VefPPquFg7NcjoK8LTvC3y3jU23qHQJeT6EBh+5wzsiBdLM4rqUZ+Qykzr5kllC39t+XxKB1aX2/B6WjovhKOrAQTtsfCla3Kjo0Rm5DQoPNw2Wn1gACta7jqfzRjyi8ncVDJcU85N+IRzLT82gmji4agfO+PzldhhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ct5h99Kj; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so110281b3a.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 08:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750864336; x=1751469136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/qMeMhPelSpcJ0gJ14dnSjD3jHGx1/A0gA2Na72Fbwg=;
        b=ct5h99Kj/Hw4aTqFPlbsd1tyBYPJntPZsbCT/lN2iiUnKjaLuneHwkwN0SLeiffQ7i
         i25+Xy+d1ieZlPU/VwNkqC4zXvekouNEacR95HMlShkm1h/zfCpqZagd6T2mMXf2jfTH
         8DtUg8hfyAV1HsHlkXtm7jEz00Mv+gTyUiEnlnQ8W0I3YvUPfI+2bZU3sv1gozo+IXXb
         wAuzIY3Gx62xHfC2ehyzoUbK0U4U/ElaBadjrZId1/7AAb1LrfcrwZjNp1MQlDd0YpOh
         SQRTR0Vw6MareH9b4skzIfE6hcfI2uKxmtF1Xa7w44tjQie/50WmXxW5k76TZeNX95LR
         G9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750864336; x=1751469136;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/qMeMhPelSpcJ0gJ14dnSjD3jHGx1/A0gA2Na72Fbwg=;
        b=KXARmAKauPI3iv++1/CR3vLDWXYosqi1OV37QcpZfWjDpDS4bIUl9k9fbz5jPPl8qw
         hgPwLUU4YHOZCh4ZTqIoi5OobCkkdxDeCW2QEsAbXzKkEqqp883aRgJI0JN0nPAZaDN+
         2VEiI62alBLfOqltugY+mk1XtLOFCY/iqf49nLtCPMb5vERbPWFJxUU7nP7YL9BGvl3p
         qGN/n3+rq8PYxh/QGoVpzLlyzgCM18VlY9HzLHWi5HOVauL7twCw46ZeKXy49PI2tqoc
         hijnQJrPD4mBAyQ7nOvTJ3A2NQoNReMqlPlGC7dDw5QnSocX9p9hpmAN/dxWovYSmtD4
         NiMg==
X-Forwarded-Encrypted: i=1; AJvYcCWTEeqZ2GNB+AXRcV29gTiCoa3fD8lIO855qtGkBSnd4gfavVoVqPJa0MZjzGaKFppI0GM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr3f7oL14Z2fBwN73nqp8REO59H1mHl6IrBc20IBcyd0QbJZzo
	OyRt2bQw6HFxywbHLxDwflbOjHb1e8PHznqeTcAR/9Gj23V/HILG26k0zMY+E+yuZfU=
X-Gm-Gg: ASbGncvx3HvwLVHmY/fHhkhxK1GkZQLyxv0KENITEpAsJKxeJsm+4cxsG1Hoed3rVp7
	mweCqR+0unUeFw/Y2TuROAMTfspBG6DFECw1VJjnVC7q9ea7Q0qmoIhgwVZejEm80znEqfmkn7Z
	uI/HtBwp2d8PzQcGgWiaftTbnO2EMOWJcAF/3LJ2Ie+xNTm+0LPKpYs9KgvTCrdEuLs2sAMbXnO
	sxGwJd7ExA8li4J+8Y9ysP5xMK4yg5XrQHcOMHAGxLGhPIXhvhrH+5Gs42BN2sA3HVr+0FwIZJ4
	Knn3KCSdmodpdam/pVHTAP/cBjW15lnRheIZ975Vyv60dc0xWgmAsA0/zQRsUNtVwqLBFGv5hT3
	UX1OfIYsV8w==
X-Google-Smtp-Source: AGHT+IGCI4OltHnjeZ8wmnsoagl2YId79GZjZBNxf6qaTX19UI8dhcybN5J4UzW7CwbjgTdGFziIHg==
X-Received: by 2002:a05:6a00:2302:b0:748:2e1a:84e3 with SMTP id d2e1a72fcca58-74ad4410aa8mr5718334b3a.8.1750864336323;
        Wed, 25 Jun 2025 08:12:16 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e09750sm4695867b3a.26.2025.06.25.08.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 08:12:15 -0700 (PDT)
Message-ID: <b5005da8-ff10-4644-8815-b288a719e0ee@linaro.org>
Date: Wed, 25 Jun 2025 08:12:14 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/26] target/arm/hvf: Directly re-lock BQL after
 hv_vcpu_run()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>, qemu-arm@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>,
 John Snow <jsnow@redhat.com>, Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Cameron Esfahani
 <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-6-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250623121845.7214-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/23/25 5:18 AM, Philippe Mathieu-Daudé wrote:
> Keep bql_unlock() / bql_lock() close.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Acked-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   target/arm/hvf/hvf.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index c1ed8b510db..ef76dcd28de 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -1914,7 +1914,9 @@ int hvf_vcpu_exec(CPUState *cpu)
>       flush_cpu_state(cpu);
>   
>       bql_unlock();
> -    assert_hvf_ok(hv_vcpu_run(cpu->accel->fd));
> +    r = hv_vcpu_run(cpu->accel->fd);
> +    bql_lock();
> +    assert_hvf_ok(r);
>   
>       /* handle VMEXIT */
>       uint64_t exit_reason = hvf_exit->reason;
> @@ -1922,7 +1924,6 @@ int hvf_vcpu_exec(CPUState *cpu)
>       uint32_t ec = syn_get_ec(syndrome);
>   
>       ret = 0;
> -    bql_lock();
>       switch (exit_reason) {
>       case HV_EXIT_REASON_EXCEPTION:
>           /* This is the main one, handle below. */

Just moves the lock a few lines up, does not impact what is protected.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

