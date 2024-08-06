Return-Path: <kvm+bounces-23433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B6F949846
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54D1AB2312A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34F014F9CC;
	Tue,  6 Aug 2024 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wsRGw5bL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661C41494A3
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722972632; cv=none; b=PtW5hkgo7HwoTiBItvTvW0IN4Rt6cMcfbhVwboYn9J5fPnKadK3vttssU9ZTsXUGf6DQ28ZPWkZqyl8fJQnXfU9VV4l4sNcjPTAgqyTdrpOubfn4mbr4ZJztz1jq1whTvEwIoLzrQzTiqwC0FszoxP0lt3VvKBlYbkaRZfPgGpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722972632; c=relaxed/simple;
	bh=AFyR9g8Hqnwn9qZRcPv07S/e0HT/D0cHY4/SXy4x+Yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOVT4QPoJk8iBbUL5FI8gZDHPfJv/Ri9Er65h3kGV/Hvr48ns/2WtEUHr6q2sw298+HMOCOmhfJo2MGMVcOpr+cYBR2FRdZbgL/2lSlgUNHBXM1rR0h+mIXt7GDEWPottY0jRsBoZ3OnpZOl1BGQ3IL93TKW2ARUcJiQvgY3JJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wsRGw5bL; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f136e23229so11034831fa.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 12:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722972628; x=1723577428; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P76gTOzFzXU4EN8b7uHbluQmlo5oYvuNAX6IWkFa11Q=;
        b=wsRGw5bLv44a9N2EYYHpoPixsqRcwcWCJuJ9RJtWSHw7xMcTi/dRs++82lSGjfqpPZ
         3JsmXG5HBF2PRqsXBWxWgPK2HBXSbYo2NR6SeKsyWb+itfel2zatg8bRY0Fwm2O+7Pue
         gR4hBitvWk1xpLgdyc6HEPfjwKIA/VZalW5seMJL6a6xke3JXKq4Ym1PLV2JEEX1re3a
         /ZwQsGV4wbXUhDM0IFZCcTjKDJnqAq+aXuDGDRvHFMH1Wj1d+Cc0V23qYBzKRYwvnoy9
         EAb54yHaGL5Tuv58errAMdUS0uvn3iqDEIyNLqXuEzIDyxcfdUbOcIwW4b3cnQBXGSKd
         vnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722972628; x=1723577428;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P76gTOzFzXU4EN8b7uHbluQmlo5oYvuNAX6IWkFa11Q=;
        b=FsJvgXoGfmn6GRlyBERg5xbIPqJEt4gmU1PQM+4n4rSxkyijIGn3a1Ct353sjQM5zR
         NOFuvVQwGfmjw+1IdFiDOC7vKA9xKhuv37hW5BMzRQ1to0OznYKLtvCgD9l0dNq4ypZ1
         cuDRy1ZS9PPuVkVfbu/0FaCMGGhdYppoLH2a4g+GuA9ZVLAIrSNSIj6vZ8I4f81tbgJx
         fxyx8gYwwXcTP2QH/504G/iuohulMmSyhf56ak+wRShD1Df/giwRtcB25Fl06qRRLixH
         uBxr/z+Wfx7Q8L73NUwxHujqhboqJ+L74FDunnjzrB39zYpL3X+tBxNhWmMrxxZKMxdC
         xFwg==
X-Forwarded-Encrypted: i=1; AJvYcCXzxceNsUIC5DAXt46WxXPqaSy2O0GWstiCikqcBZ7ZqpIkIJQT1vGxs0xTwIz621n2wrzET9fnIy1FaY8AIimqeIfu
X-Gm-Message-State: AOJu0Yz8eKoYHyQjGeYPRP98kczPi1pfbFxhf43JHZ70vHY6xM3hyY5N
	5rkAEle8EJQwzDP7bP5m+UPdClYKDxdc7ZDY+3qi9QBicWZuNEhWEWA1FBgsqzo=
X-Google-Smtp-Source: AGHT+IEr8TsGyQqAdDFzXKk6b+H4wmROdXIZsZxEzGySz0nVAFbPsUXyNA9aBvNixrGUipAd/jr1vQ==
X-Received: by 2002:a2e:96d1:0:b0:2ef:208f:9ec0 with SMTP id 38308e7fff4ca-2f15aa92e12mr116284951fa.14.1722972628189;
        Tue, 06 Aug 2024 12:30:28 -0700 (PDT)
Received: from [192.168.69.100] (vau06-h02-176-184-43-141.dsl.sta.abo.bbox.fr. [176.184.43.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428e6e01d0asm188941585e9.16.2024.08.06.12.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 12:30:27 -0700 (PDT)
Message-ID: <fff8c0f4-881a-4317-857a-0d20a72484eb@linaro.org>
Date: Tue, 6 Aug 2024 21:30:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] tests/avocado/machine_aarch64_sbsaref.py: allow
 for rw usage of image
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>,
 kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant
 <paul@xen.org>, Eric Auger <eric.auger@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Jamin Lin <jamin_lin@aspeedtech.com>, Steven Lee
 <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Thomas Huth <thuth@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Leif Lindholm <quic_llindhol@quicinc.com>
References: <20240806173119.582857-1-crosa@redhat.com>
 <20240806173119.582857-9-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240806173119.582857-9-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/8/24 19:31, Cleber Rosa wrote:
> When the OpenBSD based tests are run in parallel, the previously
> single instance of the image would become corrupt.  Let's give each
> test its own snapshot.
>

Suggested-by: Alex Bennée <alex.bennee@linaro.org>
?

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/machine_aarch64_sbsaref.py | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machine_aarch64_sbsaref.py
> index 756f316ac9..f8bf40c192 100644
> --- a/tests/avocado/machine_aarch64_sbsaref.py
> +++ b/tests/avocado/machine_aarch64_sbsaref.py
> @@ -190,7 +190,7 @@ def boot_openbsd73(self, cpu):
>               "-cpu",
>               cpu,
>               "-drive",
> -            f"file={img_path},format=raw",
> +            f"file={img_path},format=raw,snapshot=on",
>           )
>   
>           self.vm.launch()


