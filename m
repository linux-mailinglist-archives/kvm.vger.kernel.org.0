Return-Path: <kvm+bounces-22498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C792893F4C6
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D86B8282E96
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08198146A64;
	Mon, 29 Jul 2024 12:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c3zeOTQi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1F143752
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722254528; cv=none; b=uM6gxTOMUbo6R53uJVn19MNTbVL9drYuGh/91MNig1oodvSrDsZsOSCvGBb0XTRppn+0Vq3np4Y6R3ljajsZOGBeuC6inhYDBrn1P6NuUdKDSWFbOmR4NOFoHNtxXzL7Hp/Mn+TXGNZSrcFAzAoWBgyJGHGgTJc3X8sWrHnO13U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722254528; c=relaxed/simple;
	bh=+sm3v7rvQgsQcFyh9o5UcDxyu6lwcs/uI/nbjs4nu8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QDXktSbWxNJUNcKQnHNFlyPfPSB1xOVhaeKnB2wiCcKdXv+mnjV72uVClMYHh2ELIhnUG0KTXXW5O5cp+C6qZhKSCNJU3Q+wHnKillx9fT1/pl1oMoLCquSvsVbu2TTXa/aKG3dhplU4HUc5WUs2kHS4gxXW2pMAbZqqcH1aisE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c3zeOTQi; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42122ac2f38so10093595e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722254525; x=1722859325; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/qvSCEYggbJA531byaEkDr9vmqqh4tVOMW6xdeku0Eo=;
        b=c3zeOTQiJ+muL9bLCAelrFGUpAvuOS83CkIfcoH3mecftAVs7EqobkO6TkfHzBNicl
         cWagQSgcbRF+QB2nfUkLMsKcj+PUkRckroEA730XdQ7YXfoOStJ4hBh5M934lAveqVSn
         sdrRmWPvmv1sTRr6mboGUzgwk7y/dnW0vdewYsrShSBmg9nafsPA44SsNaS5/lUltJte
         G8FW7Pma/WuxDcWf5LNwT5A5iW/c5qEGy9hY/Y2LHvSWNsGW+XRW94vrnp5q8HJwGkef
         9s2ZsZWyg1AcoQ5nzkjNMWWxLLJroAvclPSVBNOm0FpCNRPFLkHzS6bIhcHchnD/XwG+
         tyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722254525; x=1722859325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/qvSCEYggbJA531byaEkDr9vmqqh4tVOMW6xdeku0Eo=;
        b=vwILUco6czuAq02awP8X3liFPsa08Z6lbjiA24K7DK3R3IIWvFCa3B6f8YpZcW1FVa
         YocATC8XinDobVlVt36HJduEqsDLYeRIzPJi4cWR8Nhe+qc1Ml47r5/pkPFXhJStPvEv
         28sAwwtuBIhFmmU5tdnIxdHiSmLr1JQ6dNHbAeVrlVaYu0iSPlVCm4ZgNggbjVf5Aoyf
         aEkta2bmvTM1oMu0/sV8UV3daXPn16uF9DAAsZ/QwuOWnYBpDnQD9Ta/YU7D7CBfRRmU
         OSAj/oa4/TNpw9MEkBdN7CvO4Iu/Q2oUQGC9MjHPmzddgQ+Qf+zGyX3Ozq0hNFLnaQH3
         wYoA==
X-Forwarded-Encrypted: i=1; AJvYcCXT094TBfalVnGk3UNEDvjIHV1psYoRYpPuGgftUrNPgolzSUyk6IOT7TjW57MlU9Tfo+eMIJKK93YgHoVV2rqTQOSv
X-Gm-Message-State: AOJu0YwTdiF6ranwlL2ePkIKUSeZlWit+zJ3vYyiOqD+8f4yUoqkb9qS
	ZcY0KW+rMbdTC1WfnmcB34gicbx3BqC0+BYyCGl+TLhVb85+fJT+w/tZDhJey1I=
X-Google-Smtp-Source: AGHT+IFD+mPLCP16wqONM0xiaWZbeizYtEHeoTpsypYl3tjtLRKpY7ZoR1jjLZznwWE1Gxi4xvUPLQ==
X-Received: by 2002:a05:600c:a4b:b0:424:8dbe:817d with SMTP id 5b1f17b1804b1-42811e6ab12mr51422695e9.10.1722254524621;
        Mon, 29 Jul 2024 05:02:04 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.173.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4280f9e3721sm108545485e9.29.2024.07.29.05.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 05:02:04 -0700 (PDT)
Message-ID: <2d85304c-ccec-43d1-8806-bdf7b861543d@linaro.org>
Date: Mon, 29 Jul 2024 14:02:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/13] Bump avocado to 103.0
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-13-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240726134438.14720-13-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/7/24 15:44, Cleber Rosa wrote:
> This bumps Avocado to latest the LTS release.
> 
> An LTS release is one that can receive bugfixes and guarantees
> stability for a much longer period and has incremental minor releases
> made.
> 
> Even though the 103.0 LTS release is pretty a rewrite of Avocado when
> compared to 88.1, the behavior of all existing tests under
> tests/avocado has been extensively tested no regression in behavior
> was found.

Does that restore feature parity for macOS developers? Because this
community has been left behind ignored for over 2 years and already
looked at alternatives for functional testing.

> Reference: https://avocado-framework.readthedocs.io/en/103.0/releases/lts/103_0.html
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   pythondeps.toml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/pythondeps.toml b/pythondeps.toml
> index f6e590fdd8..175cf99241 100644
> --- a/pythondeps.toml
> +++ b/pythondeps.toml
> @@ -30,5 +30,5 @@ sphinx_rtd_theme = { accepted = ">=0.5", installed = "1.1.1" }
>   # Note that qemu.git/python/ is always implicitly installed.
>   # Prefer an LTS version when updating the accepted versions of
>   # avocado-framework, for example right now the limit is 92.x.
> -avocado-framework = { accepted = "(>=88.1, <93.0)", installed = "88.1", canary = "avocado" }
> +avocado-framework = { accepted = "(>=103.0, <104.0)", installed = "103.0", canary = "avocado" }
>   pycdlib = { accepted = ">=1.11.0" }


