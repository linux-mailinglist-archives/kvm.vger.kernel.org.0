Return-Path: <kvm+bounces-60174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7522BE4CBB
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 906D05851A7
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6941E5B72;
	Thu, 16 Oct 2025 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Iy7tVK+8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50DD334680
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634648; cv=none; b=bCNazLtujuRZ/jLkKpRghGF1sScoi5uKQjyZ56n3/Lj3+32Ft/xlNY0cjsw4jXue7hpvSlojniITfRfCFNW/HE8SJg3ecBZSs0b5g4k+/uxsxYuUBIwBTVcWGxq8DcP9v/bKn+tlwWoh1dlaTNxMQSRQ0SW8W4dhks0+CvatTYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634648; c=relaxed/simple;
	bh=H1sVZBpt6ToL7kJouxmcZ6g/rKl4bHxjUSaeXIhID+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jt82GbV1lYNJmGhzMQPn17X06YGqLoUu1J3dMLElHFoSnBAf9XWWo2gtJKa5ikbwYY4FgsHRMmdVG4uVnZtiAOq8KAbDIzpxQDzu06AbNJ7PnMgUeO0/sHMkvIKADIh7j0MxK298Yk2rMbxcROan0QcQKt2oHUi+ntaKE2qk900=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Iy7tVK+8; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so985560b3a.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634646; x=1761239446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4bG/CW24bkdpxwOsKcr0LjlYCeDV8qC5cwo2zwpHqrg=;
        b=Iy7tVK+8gm78alTtrpBFdKZU1+mu046PKxS5u2iR+HpIHv7MF9V5bJ9byw6xPeTGEJ
         NCygDshxgOx/YeM13aU8sxH7IGQlM8SF0BE7wG+6/hLYKet5sr+eNQsVtJUInMOLiMpb
         Tjo2O93gAbWT1Gs4a332h2wh2XNSIXSQPQlSlUOCQ0Ekf/9ZUhC570FFHVnudtW87Z9H
         Ql5+m6PpczzwhRmaW4BDd5mlgpUt/DNlLMckgj8blh31gu04g59jvT3gvhPJWUlAv2S8
         ALFFdAAvaub7acKKYhz2SU1umojoghPc14seIsvusiYwVJ7RxczBuWfR9ryohK+d82vv
         +KBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634646; x=1761239446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bG/CW24bkdpxwOsKcr0LjlYCeDV8qC5cwo2zwpHqrg=;
        b=tUAncVLLqnNzbE+fAtZ2PvapCoe1coUz9uGgG0dahqAjpDPNGPWgG8SGAKEkTMFKFF
         O6dHDKE1CRTU863JQZVq8lyblfphnkRBLI7SSW5rVbtXey9pVYYEC7+hjQtM/EjCM5pX
         InoU9l1sKuoBYtS6C69CFkYRwj+N6Fr3igVCtZGiI/xBWQx949ZrlaZe4TpA9G11vr3d
         HiK2sQK3/zfZRge8CiJDQTmTpxEQxppL7xEQ85t344zCHuFGmSxaynhdGNrWz2L2ALRf
         XBgJ457dl6fY+EunChKwu41efl78oK+5w5Y8ndplL7lg5jUmZLnzEqV7HJVKwHA/OP+z
         khhA==
X-Forwarded-Encrypted: i=1; AJvYcCVZUieyTlIKLo4qFiIn8B7P0+VR18InGbRbs8ie83RnnDTzJOglDzZQcAjsOJi11oQ7oqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX3lqRfLfkZbpZc3jxslDVpJ5jMFk+2Xlu4ZbnpN6W/qrctC63
	yCc72YlUTq0e7LcP66WJbg0th+wwZ6WKhvoD5mCAAQnd3+cVgFr8YpeawL7jXN/blZY=
X-Gm-Gg: ASbGncuBz2zoyDL+u4lrU+PO2BidZVqXBA8q6i17qvnhdX1w3BsUIS8CoW37m9g2lox
	M4xJxcoKTAXaHZCrvAVC9cZAlSDY/NEzMvabVGdN25La566oy5rHSq/8+v1oV5FPgVj6WpPDjOd
	kVQGOst9cP67E25z/9EqS38uETy++oY8V7BYP0hyPE2w2bsZ4QFf5MzmL7wXJ+fdD9+f6aGX+a0
	Ma5b4FgOeKdLl9IxOlGN3qJyIhgvmxROxn6oeXPOdwqsHBESwFo/1LSxIDFVgkkSGilGxyU0Cu0
	FEWSgzEC0X34SNF9q4rwYSGQUstnp9EoHgM+UwtghvTXIW7mK2JF2jgy8l8W4eYyMHIJPmb6Weq
	89Nqe1EI67X6W2nq1qgGgVznQe9uN1cRZwh3N3ycglmXqcElvDEhj+ZuuWMQd1MBHYK5k7ILUAH
	/y9Ssxs/cL3xyt
X-Google-Smtp-Source: AGHT+IFoML3KxKt6peZtjA99LF0wQnp97PYYwkoNppHByhoQa3+D2YD6/jKPVLmtFICCxoo+Jw1kOw==
X-Received: by 2002:a05:6a00:139e:b0:7a1:3b82:8d61 with SMTP id d2e1a72fcca58-7a21f9449f4mr1113465b3a.4.1760634645981;
        Thu, 16 Oct 2025 10:10:45 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992dd854a2sm22883770b3a.76.2025.10.16.10.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:10:45 -0700 (PDT)
Message-ID: <68871362-029f-4927-9860-017d66fe055f@linaro.org>
Date: Thu, 16 Oct 2025 10:10:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/24] hw/arm: virt: cleanly fail on attempt to use the
 platform vGIC together with ITS
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-16-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-16-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
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
>   hw/arm/virt-acpi-build.c | 14 +++++------
>   hw/arm/virt.c            | 50 ++++++++++++++++++++++++++++++++--------
>   include/hw/arm/virt.h    |  4 +++-
>   3 files changed, 50 insertions(+), 18 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


