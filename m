Return-Path: <kvm+bounces-51180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4627BAEF4D8
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06633480C6A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D2126E6F1;
	Tue,  1 Jul 2025 10:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i3kGqAFv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A867201004
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751365068; cv=none; b=ZTWap8URU2uCtBVgQEkJBiFUE8i76Hky4yXosBb4V5iXtn4QBsecIoSKmvqrfn3ddyfzUrfROrzStYGFSoZcPCliMS+IV/Z5cNhQfeaCWtEADFeQthU0nCw/9nBxcBchgUJPlaXgXfdiIZF2aiLINl7jYnX9MH7vQL18wIDbBBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751365068; c=relaxed/simple;
	bh=vETN/EDcv2Z4da2WRLvUKaS+1RHoUB4vekMn4U2EX6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FzfEgGdqEQB3Dtm+MN1few6vIPqAE4jcgIhLqiT3ty/IKu1meKwgzwTFZlGymXb7H4NeudZSX5zMNT48wCC2GISghk4lE7uMbkuvhNql6Q4mDA17ikGc+p1OS746X1dA+JNwFlFR35DK9itYFkV77Tg6qhtdN/mNQviRZ48N4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i3kGqAFv; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ab112dea41so1636879f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751365065; x=1751969865; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qh+yvpcI8r39ZKZnBJSA3xxSTxkk3HrG+GtGOxH4/PM=;
        b=i3kGqAFvhqzdyoHQ3XHTOoQslWBFI8xK0CQ4vgtMedDYg6r+qXM+E2D3WeUxMJ+7rQ
         2WrIJI9AXWs+qQ4vz7qni43Ces4c/f+pSk4/pTznFDP5B1879q94v8kGXM7aYzfygEoj
         yCryCuhoBgSPfN5R4jKKqYCGAK/8pC3dJWNLKTr3Q3tSp4mCDTjoSomZJfs7dCip9eW9
         oHGTiCBvMhEXCH2S3Wppw5npQ5UpuG7fjk2eUuEaGTsAYiC0gajYWZnUKd24B8QP1fGo
         50FHWnVIcXsqOSYytjvbTZnx+gAdFwPHSMak5JBP6yLAG8IsIx78kA/oyvpz3Fk9nJVD
         aaxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751365065; x=1751969865;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qh+yvpcI8r39ZKZnBJSA3xxSTxkk3HrG+GtGOxH4/PM=;
        b=q/vrerhmD1tdl5kXZdLv0rUyhyiM4U3tnjzvS7OxPckJch8lMtqXuMV8pA71KMNB2g
         CVC1wi7ePLFDU8WLjZBSmpIkLJ6uS2joym1SSze2JS0UQhKmQ+WOm7dWFjVAQwpfZbqk
         PUGaOlV8PSJP+isnIuJTJF0xNXQX1upr3431Yu3pkJkqis+5bsZvxkzAZW3Xo1AJt7wg
         Govijkk0+0ngqKFNa8Ut8Mf2KxChGzWSW0RFrzPtCZa4RWxBKV6emvZPscxy0K5kBVr7
         Mb07MIUMAcEkz/gq6EIfHH7xsT1qrMQaNM3/2Y3KtiVLyDyi49CSH8huhcmK+Wt/OwVL
         q7Og==
X-Forwarded-Encrypted: i=1; AJvYcCVcLeewO8KcGXLeyXxqR/YT8zq5zau4SHXa6D87lFK9DTAWEV/9nuzKDaznLw4wOopsrCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy15xYENTkly1GIe4Tu+jneTujpYHkPmnliVHcx5oUfPPdPsU9i
	qVITQPkBHufsAcHmY91V98ItGH/kipN4YsCDPzxFYtgoXTUq6Ucj+WmxRQcCaiBVV7M=
X-Gm-Gg: ASbGncs1fPo3RsN1pUveB3CpaLCEHOYaV7ync0dbGQBvX9hQAu/UVaBYVzkyugfPcAR
	5NJFLANtfyl9pvHk9mE94h+cEvkMOh39g62BIiOESw4bLpfyjvAAzNZpsdH4HXUiATFwF3W6mpK
	ckM9oMLHEW0VOzF/izaq6sD1jEyuSXPKikDSMtqy0yL1Jgs9jYVhwUK+38v1f6Eymvm0xCDg8dA
	w6cMsnepglyhTQODgR/YYDO3JnhE2DLuHsdvJxt3zHBALEB0v7qkqAqFNk/1MtaQXQTSnG+DvM+
	66ixXOS1rdE/5R8ZHj9Dhm6KN7dZkDx9KBvyPBlnhxHt1rSWa4eNFIkV/z1cvC/EizUSRFHwuZ5
	LYssRuXFA0txMaefh5Is/mlM2BqmTeQ==
X-Google-Smtp-Source: AGHT+IE5IcBl2vXleQw3Z4b776SWAI+wP2cBamwyIbAvuDtna+L1v0oFCMG9wzPPraFIdJIOW3LE1g==
X-Received: by 2002:a05:6000:2b0d:b0:3a4:dfc2:2a3e with SMTP id ffacd0b85a97d-3a90038b75bmr11438237f8f.39.1751365064682;
        Tue, 01 Jul 2025 03:17:44 -0700 (PDT)
Received: from [192.168.69.166] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538234b6b3sm195419235e9.13.2025.07.01.03.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 03:17:44 -0700 (PDT)
Message-ID: <ae5bcf94-b9ea-43d7-b3f5-fb3a5674f9fa@linaro.org>
Date: Tue, 1 Jul 2025 12:17:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/26] target/arm: Restrict system register properties
 to system binary
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-13-philmd@linaro.org>
 <CAFEAcA87+SMWdSOGBaGuNDzynaLzoFMKv3PJmbfTyd3mN_TwzQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA87+SMWdSOGBaGuNDzynaLzoFMKv3PJmbfTyd3mN_TwzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 11:55, Peter Maydell wrote:
> On Mon, 23 Jun 2025 at 13:19, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Do not expose the following system-specific properties on user-mode
>> binaries:
>>
>>   - psci-conduit
>>   - cntfrq (ARM_FEATURE_GENERIC_TIMER)
>>   - rvbar (ARM_FEATURE_V8)
>>   - has-mpu (ARM_FEATURE_PMSA)
>>   - pmsav7-dregion (ARM_FEATURE_PMSA)
>>   - reset-cbar (ARM_FEATURE_CBAR)
>>   - reset-hivecs (ARM_FEATURE_M)
>>   - init-nsvtor (ARM_FEATURE_M)
>>   - init-svtor (ARM_FEATURE_M_SECURITY)
>>   - idau (ARM_FEATURE_M_SECURITY)
> 
> I guess these are user-accessible via "qemu-arm -cpu max,cntfrq= ..."
> syntax? Makes sense to not expose them, they won't do anything
> sensible.

Indeed, which could be confusing for users (set this property but no
behavior change), which is why I prefer to not expose them.

