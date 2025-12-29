Return-Path: <kvm+bounces-66790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F20CE7C89
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF76A301A19D
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2E932B9A7;
	Mon, 29 Dec 2025 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kAsPHIlq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F9B1E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030938; cv=none; b=N8ROWCZEIHdxVEdDoPKsSyibNA2Rm1/TbwGxGD0G9TgY167SEG6jyQRU9cyyq6HEVC+qYJbBMsu9wKWIHp47XacSwTB0g2cPs7eZsfNsYuIYk01/43nPVmmFDhg89rc6bJnw4zDvBA1xAO9VMqIMZtIG/QeVM/TGNcA3D5IARQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030938; c=relaxed/simple;
	bh=24nIIxiexscDLPl+P0KwpKHeE3Fh4BIFdooQ86rNnvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cl6llEO9HQe1Bs0UAmoyoJUOAvybG7mGS9eDiAfFMgroL9Pm6iiS1MsHv40M9NLcetomWJKsqIb42PAgEQ51C65IhtPWYLZp7geQvlU/EjYztxvar5Cb5+4CoMZR4XEv8QlPc8M+X46xl1XZxMTDHy3/xfhxDsXLGHVYMkqp0Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kAsPHIlq; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34ccdcbe520so5343696a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030936; x=1767635736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xcF97KlrXNRG0gM8bCfa1jut/8WfK/9bOClnty/0Pek=;
        b=kAsPHIlqyemN0I+3869+VwQ61R9zPcYWBAYi89SfieboxGt0a71epa42ynrH4Kh7sU
         kHKv7YB/gipb4FvzwCosXX1FVFJHDdfnw0Gn0ErcJB69GLIEhp/qhFN79bZQE2SvZHEp
         iPN0HCZ6k93lTjjaRzJAzUNLMYLE3S6PaT6aspsQZEBIQwIgjQDE91H/6cp9WTveGVFx
         YPUtpvXmBeHfS1dO6gPf0Aqvynetm3PH4u5PVv8H6GenOkgzdRgswztJ7ruX6z5HAMqV
         iwOic+u4tks/+IPC6OAissKJRqWIdBv460aQYn8QBDXuckdrzpi6w3PwRIVY6g8EziUI
         WqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030936; x=1767635736;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xcF97KlrXNRG0gM8bCfa1jut/8WfK/9bOClnty/0Pek=;
        b=KT5dKuLAtB3t/wP+5TGILSXS891tsRacc3xuV1eA8YA5UkhH/iMsth9a6jLcpL9BdN
         Ryjku6bTiCnFVliBj/Og1roMcCD3BSSZFc2ZIDv3ZXNXGMqITGYib4uRfU7QT4bSAkNz
         9qVSJOrhnzc+PEi9xYbL6AmmHOqJssz8ku/twDnAfCuW/m/dUF0GDtHRsQy9zUChadvV
         E8997osMGGeUWmugt7BzL9+RhPMGmHK1DS+PGhWyZogZJbLd0hZA5tAfar6Hwa9ObOC0
         cc0BxixcOc8BgPOEkPeB2MT8fM5FipPEIPOUxYGHthRCqC8GGcWSlPfdwH0CQbGEypd9
         irGA==
X-Forwarded-Encrypted: i=1; AJvYcCXXTi2PqVQllBJn9Q45I0eWcoLQcjsxYHbzGgDWRVJT7UMqVB7VmupVoPSa42NQt4PIwAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YytQfjJx34LExVo5+Rh7zjMmbi9T6atLARSIfLrCqEk20NLTqh8
	WQZ5f5uTH9d37be/Q3d5ZTLNEVGyuAZtdqPn/ufCRRENTx1TQHojcQAy2CZpPtdFBQI=
X-Gm-Gg: AY/fxX6PCLKdWgFI9Z/0tKuSe62m+6e0TKFAkMSz8Yvis8N+Nj0989pYkfYMYMNEshW
	+7e29Vc2sv2ICClCm8Lk0Z3KOlL+CIoDSDPWnrutGpakyeN5rSqvJSCOgE1IoksLdVmBK2/brKQ
	dMfp9ryZZxhwIsL3lj3UQEFI1hXM/urNkSZS2/O1JT4LfbGRc2JZXwGZ8O39gs5UDwZp0EeH2pp
	zzoEXjap0SvzNiW7KS9orXJcm1B5h2qZvWiN+gujHil+G8G/2JfqzyurWvJeQhY72Qcx3GXQJbw
	+clYi/QpLqFwocqTc6HOyzK0h7ZFMWbGCiZ8CMS7rVhKEXg9IXGS6Yas1GUOXPUAGnhSrXVP0DI
	5KzIfg6HInquc4QvpGXFZ+/ahql5iOA0jKOqd8Zf5ACkBtlUs1EuWJK50jMvVdpbaF0FJOjyokq
	VEWQaaAN4myQIEl/tpD2Inpu8WjARAVe/N4/Swg7mCcc4kxiLJaymRnOub
X-Google-Smtp-Source: AGHT+IG5pKPIbgCZ+/t/NTtXRh7gSD4tBjI5MGLqwu+CadBnV8CKYEfqdkOPnfFH50bbinsjuzBHiw==
X-Received: by 2002:a17:90b:5487:b0:343:cfa1:c458 with SMTP id 98e67ed59e1d1-34e90df6b79mr26125375a91.18.1767030936148;
        Mon, 29 Dec 2025 09:55:36 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d676b8sm30759702a91.8.2025.12.29.09.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:55:35 -0800 (PST)
Message-ID: <1f680262-eee4-4924-9dff-b938f8035a9b@linaro.org>
Date: Mon, 29 Dec 2025 09:55:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 26/28] whpx: arm64: check for physical address width
 after WHPX availability
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
 <20251228235422.30383-27-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-27-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> In the case where WHPX isn't supported on the platform, makes the
> intended error appear instead of failing at getting the IPA width.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   target/arm/whpx/whpx-all.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


