Return-Path: <kvm+bounces-23425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC60949774
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1FECB22199
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFD177F13;
	Tue,  6 Aug 2024 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q2Ics40+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99423C485
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 18:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968407; cv=none; b=GvXJqct/88FHmyCHhc1AR5zoFC7NL9OLKtdFEAhj6DlpWyUQ0cruh9GWa7MySHTc38xG+COfRRcPjBrRGCbt+HSwKOChd/dSza9VSnNbqYSIyyRSPy7hk3E/KfrMYDjmEUTaYujCyjJtCIrNFklEDp5aFackeYr9z8XdIqTPN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968407; c=relaxed/simple;
	bh=uZcRzEjiebG/NY+oEglcoEkyW0+3hATz8z0INWg3N30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i2/ft4ePYN7QDu8nMWojydESSAgaRIUDW8CClHhFVGLapCm7Zn/Z2mww1a72GJKW7I+LusBrGsI1i72ZvjIW63QtZJ/70+CxLLJzSxD1FwbYX1YuUlWXAeVz8TZ7WBd/7EkU/WxW48UPn3aFlEmIW89oTgb3ZF1SMqGlcbFmlrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q2Ics40+; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5af51684d52so1094013a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722968404; x=1723573204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UZxCd+zIg8/fTwlkeH78ozUnzNFrJo/odIzAXVX7Upw=;
        b=q2Ics40+lnIgU5ThBg290IApGxlnO0ixu1b0c1OSYT1lBrHuYzQWn0QTUt31gHFX0N
         la8BkAhrycBofpXFHYT0giCVOGo+M3YCotPhvwUW8MJPXWFGiGyZupsXH1NzAcnFy4Vl
         lpiKB7LT8yaLwUdd4jI3rnmLcsTFViRjQlG3p1orVFdgOFZ5x8QpHgY6/KT/WdHIFFPq
         MVDZJgZH7CkgVa2x4MrZRBt/X4sMYgqrbZpbvDqh0piocB3ZUUKMv7KIppm4oroZSAc9
         RF/qAxkPL5wVG3LQfsSkeLbNxdSqq0mVjzlR4KuGOgBJyDV5yXsfCCdpWjpmIbPZ2y8h
         lvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722968404; x=1723573204;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UZxCd+zIg8/fTwlkeH78ozUnzNFrJo/odIzAXVX7Upw=;
        b=GfgUJiWHfyF/ZE2bOm9gYY2nmwC8o6h+M5wzL8iw+Cak9B1xP5ITP0LyvyRav0LA+W
         zaNpFWIakIuzZ6ni3Hk3+ixhXH55LjzwFOPnW0WX86gPO/SGpjNbHv+aDXb2wsFp9MDU
         EMCFfmAMIRExHuCg2hd/Erb+4Iqp5CreBl6IQ/igznHTZ9Pkfaekp6yKIM/dotZx2ZV9
         Q3adsWXisYXPF41QErGbnkAuk4nUvFaYLs5ZEAdis2iSKe9uTYepN0YepaAcPwfhY2gT
         dbqXSjTlPE06Q7+uPOD1PWqgQSSrTWCNAYLQ0M6stEj2o8HDIjqvHFyl+mYAbKO8dyw6
         1EoA==
X-Forwarded-Encrypted: i=1; AJvYcCVMqaCrPxSsf6PsTDk6NuAI5Z1lOIsf3rSoPLBs65UgOIoMy2xjn/klmBRsvepQ6+gGo5QAD9sEmSToAeJAxoWf0qdf
X-Gm-Message-State: AOJu0YwxVjIAgPDlGf52XsJBVGWjTv6Zda7CkaPZrZFupseTJUwz5R14
	Kjq5qo2Yac1fKKcFtzr+SO6wVfftUKW9NDVKL50nGl/CR9DUaEwDo85HczVAVLw=
X-Google-Smtp-Source: AGHT+IE8dgDyUbnsAjnj8P7IFi+pXso4GIXfTKr8ZQP6PSSV6i5OvK9bz5C2uRKcB1d1teqJ/9q12A==
X-Received: by 2002:a17:907:846:b0:a7d:340e:43a4 with SMTP id a640c23a62f3a-a7dc4fae19bmr1087323266b.31.1722968403412;
        Tue, 06 Aug 2024 11:20:03 -0700 (PDT)
Received: from [192.168.200.25] (83.8.56.232.ipv4.supernova.orange.pl. [83.8.56.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9d89a9fsm563924066b.156.2024.08.06.11.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 11:20:03 -0700 (PDT)
Message-ID: <540fafc7-9044-4e9a-b2c8-2f2f04412b88@linaro.org>
Date: Tue, 6 Aug 2024 20:20:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] tests/avocado/tuxrun_baselines.py: use Avocado's
 zstd support
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>,
 kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
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
 <20240806173119.582857-8-crosa@redhat.com>
From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Content-Language: pl-PL, en-GB, en-HK
Organization: Linaro
In-Reply-To: <20240806173119.582857-8-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6.08.2024 19:31, Cleber Rosa wrote:
> This makes use of the avocado.utils.archive support for zstd.
> 
> In order to not duplicate code, the skip condition uses a private
> utility from the module which is going to become public in Avocado
> versions 103.1 LTS (and also in versions >= 107.0).
> 
> Reference: https://github.com/avocado-framework/avocado/pull/5996
> Reference: https://github.com/avocado-framework/avocado/pull/5953
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/tuxrun_baselines.py | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/tests/avocado/tuxrun_baselines.py b/tests/avocado/tuxrun_baselines.py
> index 736e4aa289..bd02e88ed6 100644
> --- a/tests/avocado/tuxrun_baselines.py
> +++ b/tests/avocado/tuxrun_baselines.py
> @@ -17,6 +17,7 @@
>   from avocado_qemu import QemuSystemTest
>   from avocado_qemu import exec_command, exec_command_and_wait_for_pattern
>   from avocado_qemu import wait_for_console_pattern
> +from avocado.utils import archive
>   from avocado.utils import process
>   from avocado.utils.path import find_command
>   
> @@ -40,17 +41,12 @@ def get_tag(self, tagname, default=None):
>   
>           return default
>   
> +    @skipUnless(archive._probe_zstd_cmd(),
> +                'Could not find "zstd", or it is not able to properly '
> +                'decompress decompress the rootfs')

One "decompress" would be enough.

