Return-Path: <kvm+bounces-66784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F12F1CE7C59
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 495263019BE1
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC8F29BDA5;
	Mon, 29 Dec 2025 17:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j70DXFvM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DB926ED40
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030692; cv=none; b=qY3yRdC/EmIqld8YK4GA6O+sgM8XHwqnY6gMQoF44hys5xpb5OFcGM1AWEsymiyHVBIgLWZM98Psol6VZiKmA9o6oGnsC6AMMWsRWKeZgXaZ7SUYjvtsTe/5FMDQw7acGI7gMTZmg2eTmVD0blQJpL4OQDLrg1ODQkjE9HwjO40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030692; c=relaxed/simple;
	bh=AqsfxhLSFerMpfmC00qenwik4wIpGOd/07be/kUsXVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRM3ireAzwwY1mUnW5Vpfgk3Xy8P8GEAPR+J2SuHr7g6e/aT7Hfp0OxDmh/TabaBLFz3k6GbA3Ai1b/fJ8jFdJwKQ/CfKjj4nhHp+tYltrqmy5gptstpxt+yLpJvmyVpmNefs2pSPZC57GUXy5zAItYOPVeBL2n/rMbs7vUZDRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j70DXFvM; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so11346246b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030690; x=1767635490; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p+436XRNbTzJRavV5d66W2uNYOAK8m1ou4UvIqQXOdM=;
        b=j70DXFvMifQaxvxtv9NXfo94nIWL9ChzhMm4G9jROH8nmGzJ5iaMdVqiOHSrfwbpj2
         JSrGAbCY6DUCW7OMbLGJhaMVtyB5cEQn0BX7jBs8gj9Bt6vigmFt9cnntZx1CQh30Kbt
         dnjely+ZhsfUr15aW8dy7YmEQ5HZrmkEOSu9qnug1GjtD+gjONBa7kPvVBP4rU3Cjn7q
         MGixV90ZEFCiBtkAqgUWPZEi3cmwA1nctdWTUHnO6koWALSw2S1w/ue2dkBHnWyirbxV
         FzEcv+7l/37jeB09AtlLuDgVxokm/sEYgtRhEIzxuAPNzKpq98lG6SJNmOGMytzd0l8G
         6dAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030690; x=1767635490;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+436XRNbTzJRavV5d66W2uNYOAK8m1ou4UvIqQXOdM=;
        b=dlux+T4JUcAmxqTKVIw65SN3WPANUuAtKEE9A0s1Cg5UUJQnizKQ9+E+u5jpmuUHd5
         20yOsmLXTBSxnLOrNlJmuTU5xmwcgAyH0K8HlVBNLc/OyGKjkVgRYRilvwE7ajp0FjEp
         FHdTMW29BlwyHhwsXjMYozesPOo1mXS95H89kOjMJs7Bi836Pcmc8oTTaVSFsKxl3N2h
         SemvjL//dgSt31td7Rziv519NJtGGQsprgERn3xFABBAVgj+DaLvo2VxpA0IJ12EBN4R
         nEtG30KFU8/zcrIE4YEVc6x2q9vfH5vGIV2dZPhjQ3qUczLU/nlGaxDOf9JYc7D973df
         iiiw==
X-Forwarded-Encrypted: i=1; AJvYcCX//qSoawCcMf9vYyJHSNmFBBFrkTAftqx/LdVSQiysKitDNFvAsCZ1qTrpkkfrmFBNBdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIAiN5REC9r/UvbVgOJq7hZYNp1cImNf+6vIm4JzoPxhGUa23g
	4qEGDWUKK5CtVU3Qro2dcEJ8glXM8at+YyFtwE//NEqeIaDV+BJ55fVt5+AHv2UjVxU=
X-Gm-Gg: AY/fxX4ZzqDy1nH/TGXaSO44kCo+dp1Lu0y+gDbzuxsNklI1wJFPa4kqgrzVGgpDN1u
	2sHRCzrmP5psikRzH/ZMyGBqGjWev8Pi4aX9btDEMQH1hVqB3sS8GdEu6tZhg0hR8G3MXg3+/A4
	XPKwCoBnaA5T+y+OelU1Ml1i53NQRHmsiLCi3oFss//38yNM7JoqTfS0l3B58WI1QEV++G6U0a0
	gdF9u+lxvz96QSKwANRbFlbwVLQiegi/4tY1bBfL+nQ1Sdhe34LrVR4P8zLWjDniVjVA1LgyX2v
	xHgNVdmFaPkDNiItCcnkpcBeM/jKEjCdkgj3E8afQiARcF6/9VOGmButOu9SM0WEMsMUFlF2nJN
	EpOMg1So3mWI8dkxjiWmsyrzp9jkuNexwNlCxIYhs2tfZD1m0wnELvZw0X8JhKzG2gOHxVCtu6B
	OnV7Yth56vmypQrkFxWPCnjMnTn1slJzghDPITMnYnqStzP+sk/FCW/GklUrwBfRJgU7k=
X-Google-Smtp-Source: AGHT+IEu0SutJzP+BJb9bkVvZemWlptXnQ4xXCFNyljFOneNGXzzI2JU3qSyIt8+37F0+y1bh+ecyQ==
X-Received: by 2002:a05:6a00:44ca:b0:7e8:43f5:bd11 with SMTP id d2e1a72fcca58-7ff66f5a163mr30881735b3a.38.1767030690360;
        Mon, 29 Dec 2025 09:51:30 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e792b65sm30541530b3a.58.2025.12.29.09.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:51:30 -0800 (PST)
Message-ID: <f597965d-feb6-4ecf-958f-b299632811f6@linaro.org>
Date: Mon, 29 Dec 2025 09:51:28 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/28] hw/arm: virt: cleanly fail on attempt to use
 the platform vGIC together with ITS
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-7-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-7-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Switch its to a tristate.
> 
> Windows Hypervisor Platform's vGIC doesn't support ITS.
> Deal with this by reporting to the user and exiting.
> 
> Regular configuration: GICv3 + ITS
> New default configuration with WHPX: GICv3 with GICv2m
> And its=off explicitly for the newest machine version: GICv3 + GICv2m
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/arm/virt-acpi-build.c | 15 +++++++------
>   hw/arm/virt.c            | 46 +++++++++++++++++++++++++++++++---------
>   include/hw/arm/virt.h    |  4 +++-
>   3 files changed, 47 insertions(+), 18 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


