Return-Path: <kvm+bounces-45164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA251AA6410
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E2DA3BDFCD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A10C2253EB;
	Thu,  1 May 2025 19:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qpoXy2Y2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A280367
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127575; cv=none; b=Klj4kFy5uXcxm/Y+HFozatBTapXIMC/mjukVcUIMdCr1mDTmFzLze/NGHravyryXyTnyU3HRubEsNOuD/qW2I/z1h5tDxxOwj9vPApce+zBlEtCfsd23OIEhQqP1B4PNa56UMD1QbWSqHwO8Li4sG3ETDilt8fvAU4OhT63mric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127575; c=relaxed/simple;
	bh=RBsigpanIXfTC2UHwom89PLleDXNz3FrHKn4eBs23C8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j4oT1eVidysQZ6TE09iERkhMTYRu/hPH8lF4WdRTvTF5oQMteqsrqQP4YexSejF2dEQaPloqJQsZa/xF6emn6XZEr2/tQeOvghAEg77aeHxTWSA44wuE6sFVDeeiKsj1QAegTHbBBX8Tgyu9yNl8fnbRuRExerZyZ1/DaGj8JJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qpoXy2Y2; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8644aa73dfcso48741839f.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746127573; x=1746732373; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mOEvc0SSn4n4LmFVDeAobZ/gyH4Gzc1mitFhkjq5Fbs=;
        b=qpoXy2Y2smZ6wGAKCBFwkPHPQ0mEyHy8vhht5L1ilOMEhrFDeYHU8VVh8Y9hZ2j6Sg
         XwWtyjkHifhbZZ7D/x41SY6eEmjII0YLq6j/R1n6o4aKLOS6gv8xaLNA4bt7nhUsjfB/
         atvx5XEsdbXKgJDiILzttmdNz4nQ77m5+RJupqkS/InAnhi9YOK/Tjfpq/m4Z36ScWic
         agT52ZXzTVmzQw6TWWztNVkSyU+MafU1Xwt1VP0jw6DFSQnxlf9oygvLNfbx/9d5IOT8
         aClYpW5eX/212ygmoo5WRo8L6GQbei7j90bqliWclS373MFU2PZkepOwuOBL+vWuhjks
         5X7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746127573; x=1746732373;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOEvc0SSn4n4LmFVDeAobZ/gyH4Gzc1mitFhkjq5Fbs=;
        b=Y7wLTfCQk2UbB+obE79Lw659F8AJOV4aRoZEIp0kiLR5mY+fzrgthJz4IHFnV6T8t5
         qZN16vQCxtc5Yi//FfD4m5ZiSGPGwX3HrLnjBoPqLQlfowaKhQ6igA5MmINI/4t9taPm
         etzgnG2miYDZdMcR5n/Rc0AkTsVL1+q3yPoUXyGerUM+fDRbjcYyCSmgM8Dd5CtsywJI
         OrLyvI9AStK9xWEs47vDVRS/k/FYHCpe1t5lJByBStQRRNc+ASQHWuFme/xizb58ANz2
         Mp0bGDqHfkoiN5oKZBOgxIXVkgKP+Y+9zOAGdEFiRtjirXXp1VsXYThD7NA9kukM5MaW
         9mDg==
X-Forwarded-Encrypted: i=1; AJvYcCUKxi6HhK5BDOp57UTCx2DRNDA1LunbP4UiD32DF12/V37DOz7f1wm1L2Xr5K5o8rrdv6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfLX8B4IPs/sMjlLUOvzjQ71zLov+YCKRBT0/K6ftwO7n+SWoh
	KNUjWGHQGU2WMY38Z8/lIu0Ryr0o4H/O0IEfaJQz6a6TW2urAijSdZ4GWWAC4TA=
X-Gm-Gg: ASbGncvMyGrwDcmI5/5YaCp31i3X+gLe8OoNKJ4c8tYZrjo1WgPnnjWz/oTgop5KM5k
	8IIa4ssXI+lSX+m1p8yu3jpddop6F++KPNp6cuStlPFryjMPcEU+SIfeqDWS+L+fUvLET9QGgtD
	Yobn4LHxULYk1kYaTSebXGwGEvo/ft8GoowNFkmzscstbhLpak+DsTpGM0BLStjka0nZTAG98+O
	9ReshjlafVSr18lsW/v0njCqFD2bRFIHo34vK4lkZmqM6VVOBknfrm/IAH/xFBH6uBbFIJ5u1s8
	5ii+CvR4e2azO4NBXpYlwtcfFkQMmUHdZP4NlxQnif3UEE9C8/1/CM5EJDNamKcy027hJs702/Z
	uMDXgfMk7d50XPw==
X-Google-Smtp-Source: AGHT+IEnseijY1qZFqXaH/JWrG++6y+RPfgHvgSE0pN11DNLZSAd2eF21TBG53pPmJQRnKWTEfeZgQ==
X-Received: by 2002:a05:6602:6ccd:b0:861:c238:bf03 with SMTP id ca18e2360f4ac-8669f9bbb08mr51312739f.8.1746127573026;
        Thu, 01 May 2025 12:26:13 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa591a6sm7263173.83.2025.05.01.12.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:26:12 -0700 (PDT)
Message-ID: <2ac29f3e-3026-4384-8f49-0549d7368043@linaro.org>
Date: Thu, 1 May 2025 21:26:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/33] target/arm/debug_helper: remove target_ulong
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/debug_helper.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


