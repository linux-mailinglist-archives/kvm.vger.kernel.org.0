Return-Path: <kvm+bounces-44977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 634C3AA5479
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 21:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8A225047D6
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 19:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52D52698BF;
	Wed, 30 Apr 2025 19:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mvuf2xRF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70CF2B9A9
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 19:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039981; cv=none; b=DKdQThW9488baurkb20ipuvU+eHCdsQAskDZ46VeLM3FHMFU50bgH1uCUd3XSrqxri4jBjDPK8cUM6Qfha/x87kj7SQPd7fb5yzE0d67+jW+1V4/TP/t/7H4LMIQsVyKDvjKZbVjB363wNcugerVyzGMp4B4xOSohhGnrYVVSAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039981; c=relaxed/simple;
	bh=qcksKdV5w13Rln4xlnTNEyq7J3OqvqFgwRXoJlYP/no=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HC3na6/heE5yefOhuhtF4INcUlCM7y+UwEHN8RuYWH+NsmYEXcT0eUyMIA0IH1xxJA2WssWlO9zZ/SRe60OZomTzC+OvILuVt0866r6fR4Il+Y0YVFnlGs845FRWXhcEDwqRb2H0Nx0YrMp9m2hjDPq+npx3bfa267iHIRymJmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mvuf2xRF; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b13e0471a2dso155274a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 12:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746039979; x=1746644779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OlVE7gl+CUw4uBk5E7cv6Cwlsk+3Ly8aETY/UIpTw9M=;
        b=mvuf2xRF5tAFRA/iR8iq3j22TelgyItvIW8iVdzy5aTap244BdyiwuJXsJmOSrEpsO
         4QNBPrglZvoli6jikBjt+R+D4KbuyN7Qi+MniI8sqKXAV2aQm+Fxoy8XEcd76LNBYN4p
         A3OaxdfLpL5FwfE1cmqf1B8Iv35UaZ+dtDv3CXCU72T2DczXkoBpeY3ztclTtOmYXT8a
         O3/66PH/Or5Fnu5jniF/fNCGSc2VEXyVfP4wy5LxIWC9AmjR0OaEKG/AYLcaxAK8oYvO
         R0ix2/OsGDV6OJttbmlk9GNsZtmYoah4dEXsqvv2uTw03k7tqQ0szRnXmmgoD6qUHdOT
         xJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746039979; x=1746644779;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OlVE7gl+CUw4uBk5E7cv6Cwlsk+3Ly8aETY/UIpTw9M=;
        b=hw1c6ebo/QFx2mCwIW7FarPvtR1QmUf1/5bT8e/XM7dx1xgHl+/JvV9t3ad+KFWw6o
         Y7vABMJraEcYKDeAzERnAbNX+M0CNr4umgradGqrICMpSmZLFXukVCnOf6wNlakgwOTn
         /QkWUccs7lI5jVqAknr30HzA544jzUy7oictwButF7I+4dSjdr6QYou4WsvlZdIE31fG
         Lox7RXM1/j+DRr/GfcOisGDA0U/feXWdzOlxp5rVdctA7EUqb+Tu/DU8hD09jHIV4RMu
         O4Z36Een0qndzyoZI50G+YdDtBfsm6T9Mp3NcufGl2csCsAN3LAdRfHlfpSuwU1oYx69
         3qKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPJj/6lApHlV7Of1ETLJeUs/l6ydVVjwY+baDXvJgIPdae6s66/hD2KWlm/C7HS4MjWaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWAMHA0Et7XWCZ8DgGsXigKqZJ6iXtkBXChcLkGPkIbRJUfxEq
	V0abMpQH/Jv5eRo+vULdcnOT7adsng766MMmkkSWm+RuXLtsg0wlgs3jg/Mb3/A=
X-Gm-Gg: ASbGnctHK3m4FdZdOYtGxsqqUe5xcjgkdrINZJ+DHxJo6IJ/TfjU+LdUqh7Pn+xkT7y
	PVeMjcU5Q6ZiRC3E5DGcO8UXNyF9JqJHVORQnMsqbk7nTknktVpPpUtEYs4+08qa73B7Y2zZgZj
	LvMfjWfb0UiAjbM/Kg+BfKXNsnKOWA52YGAJPEmSf4zSZtGWXS4VXdrS3tKwVFT+10pIiVfv+Ey
	WJSPXtXWu1u9dioa/c5jyIDwpQ2h4eTto2KF6w0MmFIjzWs4Ranpdr6iB5MSqC7+tB1gp3rLXKq
	peCP8rdwoZ2niMHw05+8LW4v3EZzhidQPGo9jROeIoNGCKknbJQm/A==
X-Google-Smtp-Source: AGHT+IGj5B6+DB2NaW+I5mAxRhlLboxIrcBkEvFW6E9iaGZb6qpzUxdVqI+SAgAnfIBrFAywlTIIXQ==
X-Received: by 2002:a05:6a21:1511:b0:203:becd:f9ce with SMTP id adf61e73a8af0-20ba8e4bbe9mr461533637.39.1746039979042;
        Wed, 30 Apr 2025 12:06:19 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f7ec3116sm11157941a12.31.2025.04.30.12.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 12:06:18 -0700 (PDT)
Message-ID: <23d84ae9-5409-4022-a65b-0b0ffa5ff51a@linaro.org>
Date: Wed, 30 Apr 2025 12:06:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] target/arm/cpu: compile file twice (user,
 system) only
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-12-pierrick.bouvier@linaro.org>
 <e77b5c7d-5f6b-46e8-ad68-207ae87a07dc@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <e77b5c7d-5f6b-46e8-ad68-207ae87a07dc@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 11:50 AM, Richard Henderson wrote:
> On 4/30/25 07:58, Pierrick Bouvier wrote:
>> +arm_common_system_ss.add(files('cpu.c'), capstone)
> 
> I wonder if we should inherit these dependencies from common_ss or system_ss?
>

I ran into the same issue when working on hw/arm [1], and didn't really 
look for a way to do this from main meson.build.
I thought that it's a good thing to document those kind of dependencies 
next to the sources who depend on them, so I didn't dig too much.
That said, I'm not opposed to it if you feel your approach is better.

[1] hw/arm/meson.build
-arm_ss.add(files('boot.c'))
+arm_common_ss.add(fdt, files('boot.c'))
-arm_ss.add(when: 'CONFIG_MUSICPAL', if_true: files('musicpal.c'))
+arm_common_ss.add(when: 'CONFIG_MUSICPAL', if_true: [pixman, 
files('musicpal.c')])

> 
> r~


