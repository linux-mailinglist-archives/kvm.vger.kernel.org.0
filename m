Return-Path: <kvm+bounces-50307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83FC9AE3EA1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 211E51768B6
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623CA242D6A;
	Mon, 23 Jun 2025 11:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vfRhXIUx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB68023E359
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750679675; cv=none; b=H5cmOeh1EqFqzl+/jcD1N7Conbl4SgmEM6yeIL1FbVAa/Ad2DMiaxLVps/AoRJU6i9ngavqAmWITIpdvYZR4x9ELldvCrWc7+mfaDcndw5bgfEXgocu2esHeVQDlHfb9L8hmVrubcoSCxWbRUkPNuMZ0gSc7JInH54xXQoDsBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750679675; c=relaxed/simple;
	bh=OjsRFdcBNhVX7OIMd901Wx90KcuEHGL8ijgRyvPbohU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8G36deGLfhpjqhBz/30BK47FfZajjqqloBaPp6qPztDB1XQtp+dBiERHMVrXPYrHmle41xV5aUuPmdbNAX0BH/jaRtIHw/VRI/1YJXcjOl7t4XsIzOgATsSfC585wnPnBou3o0OSOMrOIw/iSR8jh/WsLt5mBcn0CypMZBqv7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vfRhXIUx; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a50fc819f2so3230688f8f.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 04:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750679672; x=1751284472; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mA1bPn5/VKcYzEd4AJcMgbdM29kFbTpL6cqkZBp0IqU=;
        b=vfRhXIUxQdf6aABKFEkO/yJyOdmhOjRPw828hKhG4V9zlDk3mQRaNQG+TY8o8tU/yy
         bpdbA8xYBE2Rmwz65VzFL82CsXZh2SGBRsjpiRdCLLS2nwn/WklonzjVGk2DsevGObPV
         ebWS4O0PGgSv2eGPwnyYS1LCNw77vXcemNlTqRc4n+KdqaETqqXapYYAjeUaZP4ypjO1
         RJv/6ppnSsxszqiKpXZdEGc2yIrUx6QEdY8xWoDcPcMaa9mphL2lH7bT8Fj+X+jn8px5
         iOg6Jf5pN7eJGv1rnqh0dQAi5loE5+luYBeJImmU0q7VYYsVmeu0DU5TC1gTwkzF0rEp
         PYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750679672; x=1751284472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mA1bPn5/VKcYzEd4AJcMgbdM29kFbTpL6cqkZBp0IqU=;
        b=ZVHUsRW7TbeX6yM67Ngk91v2nsAclKXjVzbCTMCi2TYwJpLVeDcji1z2QNxQfjSrY6
         eA8eRlJYTUJT3lRiibT70nLbODDYR3N0De8KoEZUjqz0B8llWZbH+st+ftrxImT4p+x8
         L5STacaa3ez3vHQ1je5URjPB2ntXddEArU6g82Q+OZzcgKaR7KE1DQi4DnrqdAEzhCK2
         u0VnB+mJkp02hqkKuvN4nAbVPmtsWjlM6Ba6nU6YWHLP2ZN2I9ZugeSK7XroaCBmjIsU
         oIbXcPsVx7Y8qSZ5y5bUuIshdhpBMzaGvDyc7wOziWaMyPO44TmqmYHzClfQk+IOjEyz
         0aLw==
X-Forwarded-Encrypted: i=1; AJvYcCXbKsoQsvN4/KwcH18UxEwcRn3fjpJv9bWHbRlKLHFaSi//KzJsp5MYOP/HUe+2f/GCqGo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9m88Y29ORQbNcjx7MHkqmh5mE3ge/43O0JR7EHB6W4+vSCIiP
	jGvezXoJuXnpmwH15IvQwWmgFu4ic9mJTNHb54Zi583ILAg68OoMx8Wqzyc1+yV6cKQ=
X-Gm-Gg: ASbGnctNAhrFYoPJuCoJ6/1pebdNOiazNRfMCsVgxjtfrftaGaI6qWKT2pBz6gHKhkg
	imKQwPezrqxNeR4R/uUlC3rLduJ5OOfpGIOHpzwn78GiQ8V33rXnMz97my2QetLcHlSpdGGhlVm
	SccowdO+e6dvLH8krQ8dp4hkVxO3/bts5k+OiUHXapdCZiOiobjCSjPN4WAhpzqgoSTR75MrZNT
	ZM+OSVNK0cVlVubi7RSSQ8q1LJpsr0cCrTgSkzcxYSShZQX33GJOpUyqn+v3ml6VQpUpRd50mZc
	hzxNGQGUphPRsHoNEUMou/NTThFzFUc2OvOr5ulQnWVNjIHwuW96sNPznD1M9u5hCJbX6utTjZM
	aMYVpgCTTOufBdAgbuEyDLrCEY1dNLg==
X-Google-Smtp-Source: AGHT+IECw1gIHOR0QOBsHa/SDc+jBWm8t+IURqICdiK8HE4kWpV03x7yosYd71lVv5bIijrW7Li9TQ==
X-Received: by 2002:adf:9c8c:0:b0:3a4:f7af:db9c with SMTP id ffacd0b85a97d-3a6d1318226mr9569094f8f.59.1750679672219;
        Mon, 23 Jun 2025 04:54:32 -0700 (PDT)
Received: from [192.168.69.167] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f19b30sm9469755f8f.37.2025.06.23.04.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 04:54:31 -0700 (PDT)
Message-ID: <76730787-f153-474d-859f-0f51ede79e93@linaro.org>
Date: Mon, 23 Jun 2025 13:54:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/26] tests/functional: Require TCG to run Aarch64
 imx8mp-evk test
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Radoslaw Biernacki <rad@semihalf.com>, Alexander Graf <agraf@csgraf.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Bernhard Beschow <shentey@gmail.com>,
 Cleber Rosa <crosa@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, Eric Auger <eric.auger@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, John Snow <jsnow@redhat.com>
References: <20250620130709.31073-1-philmd@linaro.org>
 <20250620130709.31073-25-philmd@linaro.org>
 <3896c4a8-8b25-45e0-978c-1539648ab4cc@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <3896c4a8-8b25-45e0-978c-1539648ab4cc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/6/25 10:19, Thomas Huth wrote:
> On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
>> The imx8mp-evk machine is only built when TCG is available.
> 
> The rationale here sounds wrong. If the machine is only built with TCG, 
> then the set_machine() should be good enough to check whether it's 
> available.
> So I'd rather say:
> 
> "The imx8mp-evk machine can only run with the TCG accelerator".

Yes, you are correct.
> 
> With that update:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks :)

>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   tests/functional/test_aarch64_imx8mp_evk.py | 1 +
>>   1 file changed, 1 insertion(+)


