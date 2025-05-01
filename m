Return-Path: <kvm+bounces-45123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E53A1AA60B4
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CBE81B67602
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CBF201276;
	Thu,  1 May 2025 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XvP/YQQ9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C2F33C9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113052; cv=none; b=RZB9pjWPamh0XoWA6xDMF96htgrHJGsbHGgZg5+zIbtY0+KKBv9cmy4WdcrKXZ8hEPGIvfIS1yu8/JOcTrYz9l4IZjCSCpMd4OZ/Ql5Ej4SdbLUjaAfVDRWSUK9LmHPV2sZkh0Z/0AS88+mbHa9y4wm9w3oAplXRYICsHEmvl6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113052; c=relaxed/simple;
	bh=/6MNDkNjvgplwI6717/jIJ/8yPa46ThdMGbbkhSS9z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8R1tcXWv/swB/qsSnT1xucVnQ/c0lgETnZPaBxgpyBtFq1tsv/z/LyjpuA8Fiv74tzzyrRTfqqy3DlyXEUyj44AnCirugTP1gdJ5SjNrxPs2wCaguXMIRgkJGQi/5dL90Dwxrt6Ek5RKW71EWZcY5q2u0Ce7CGG3K6DXM101zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XvP/YQQ9; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7369ce5d323so1062450b3a.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746113050; x=1746717850; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=XvP/YQQ97Kl5VDGwGqVugIgOOKSEUPuUW36h+5C55nS0x9z3pWu+YlUwKucFTWRMsf
         GXXNJJVZnob8ELCWFeF/qfcjWFx1FweTBSdOQ0z2k0P+1pDillRi9H61TOcK9yZ0illV
         qabsUZFMOm1BCzi2ljcHl2vRGRprY/E6cbmaHP1AdEkFxTKHvHgER52IzrdfTgMtGy09
         QuRhwXm9+b0GO1udlBFIpy1czUKoXa4wKYBxoQw/5/oez5nJXyu45Kr17DwYTqtFfroX
         /oikW1Y/fb5vPQqNe7MHW8IxdXj2mPUKi9HUqs33O1oHOJbeJ70wOol7eFpuxu0Dd75h
         KPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746113050; x=1746717850;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=Vd2JEcE/peMVqr826wri7+kKgetqeHG+nGeM5d38NMW21yNVrdwhzksOOA8UKGF/b4
         z3xtNHL+Hph6zqPgMrb8kJOhRtd3y6KXfd05jS1670MvAY7DaF9NYww2+HFi86hiVmn0
         7bcDdkqEk+xDLX5SZkWwTngLpYpGmznVmY/zrV/oOsWjGMUXKKcrsmy1EyCi6xuUyAW1
         r3HWXo23g+QqnBZlafIK2vTD8vIdAYBhIrgb8d3DQmAbZNTV6uXLCxLJA/DSGPO76Tnx
         9EwPn/dIAgGPecuDPZ7ZZUpL/8rOZ1btjenlwqlhAdEtQu7dSqfeExsgjTMfUHhJCoML
         aXNA==
X-Forwarded-Encrypted: i=1; AJvYcCWQJEug0IZU+epa7vvK5S/8Qa2RGRvrF6W6EJiQnK4eBMqv+jgQgIbZf8RVsAjBHAhycVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXMVzHOwxe8JcisxJQg9blsGUnjKu1wvzwpoWrwBOnXpSuEL+r
	KqIT4pjrYqW2tQzU3O6Sjgzo+gHilZ4Fwzy5MwpdN8WyMfWSGs+2AgYW7HKpn4M=
X-Gm-Gg: ASbGncvapUts/hHZ3fRWcRX7Bb9YWQrIy69GqL9WbGHKUk+OfFc7i19/WoxfhVKKf8F
	dgyiqdhMrOPLhM6K1YifwkSnS2NI+SNfjX3qgayYAvDI83gqwyBcSdd3FGZdAU/s4yVaneYa/LN
	z+tcs1HTQ8rQUq7PR//UzyECwUmESP6mZyXBV4uwHCFoxzbDChqANsSXYh3m/REJ9SCtNkngZdj
	E71V1aUZ8TvT7PBKkizCztdcsPEe6sf9PS1ox3wSVJfsDH/hcWXD9DjR3Qmyj458yRAiSpQYFnn
	6VvKhitFAGzvRDmmf7wUXyodTMsdSOFy4M4S3xFkrog9XcC4lFkl2f79uoXGImDbLAIBNBURnHv
	vC/uAQNg=
X-Google-Smtp-Source: AGHT+IFtYPPoKV22gQdXSnGvoCfMB1I5lAUTgyrS/ys3+0aJbnk8DbbtBSmldZ23PrL2j0wpzoqV4Q==
X-Received: by 2002:a05:6a20:258d:b0:203:de5e:798c with SMTP id adf61e73a8af0-20bd6b4b359mr4810347637.18.1746113049768;
        Thu, 01 May 2025 08:24:09 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404eeb293csm965322b3a.10.2025.05.01.08.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:24:09 -0700 (PDT)
Message-ID: <e01f8acb-bf41-4ce3-86be-c576a690aad3@linaro.org>
Date: Thu, 1 May 2025 08:24:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/33] target/arm/arm-powerctl: compile file once
 (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-28-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-28-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

