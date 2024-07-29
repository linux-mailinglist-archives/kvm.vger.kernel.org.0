Return-Path: <kvm+bounces-22495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E907A93F472
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D7811F224C5
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E05C145FED;
	Mon, 29 Jul 2024 11:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J0RbQRMA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0439113AA26
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722253778; cv=none; b=mFMnhzUsUMg41CAWWVDHfEdjUanMQDmRdmxP1QSLAAGn9TZe/7HDgcIwdN2ccKIiVEbfKd4SpwiYErUWKqck7kkmpvl1G766QvK8hV9wimznaO2Sd7ElRc1Hn8OySfwIQR6DdSwnWFTrHsDjUcEVz/V/FX1jiuHcU2HlhOdeiFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722253778; c=relaxed/simple;
	bh=tTFD6XbFx58/ww+nt7jW+sz/GDcxHciYpQO9gDlYb0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SJN5OXe5aKc5odQhlzWDPhJuCleZdHQVbuMGc8dmi973uFFcjDA7wwc82fQSnOFHpg5+JNHbiw8A2X5iFVGuwjHZ8rG2861slTYoUH0rmrANolTZrYqWHjZ9tGZzJkc2sdWnBF3VnU8IouS6/eF8XcO3h0cKZTRB2AReSw/FyEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J0RbQRMA; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3685afd0c56so1349927f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 04:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722253775; x=1722858575; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9JnXahZi7Ry6BaSaWzwQlRdolcTPy7oGkuYP98Cp3gk=;
        b=J0RbQRMAM37W/PPWmUfKeTEkjXCw9zleNiVu/sRKTIoOW03auFiXKcQTct7fLomAOG
         4RvlIPfAIagIzOFaYOHrRD1ewdNtvJu4NMCwiW/PXzOXzViTvz9EKYu1JLo82g8YDmNa
         EwHga30AYSeHDjj+Kd3pODNQhywRHNK8jyCik95J4POds896lV2OBcZvn+V3I883mWhx
         ePUqBYcGLCsDXWtGe2GrtonV4/IxvGAjFwK0L0Eu46JQwhlLetWNAMXW3FBtQlJaELK7
         aprIiAHd02M75zP5O+Hl4nPuNha+uWsYdDSHxdggooOHxmAs1kGixA1TGxs0GmjPZhim
         zHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722253775; x=1722858575;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JnXahZi7Ry6BaSaWzwQlRdolcTPy7oGkuYP98Cp3gk=;
        b=M7ICmDW/6PKAtz0umOQ97Ta/cq1f+/+VIArVp7y8N+KUx3fPh7B1c82nAtG6xQiwiP
         IsFRR7fOpjIucP41khMYNmuyfSugIVGIoMAE2FuC7Ojyku960b1sVh7174bzuy1xay7p
         l0g+Gn/IF0s4IrYNZQa/SRHa2ECN9Qt+YwkhgYthSZCsnIxs6KY79uAHnmpfwwdecO8d
         J+a0xJyiS2npGZeDCu7gz6Gi2Ad1j20xbKYitRolxpRwDRroNdqUy0xZXz9hbyx6bDRT
         eg7HofAKNp6cE8gkrmCmFfE6IbLt/hvK97UdpqFOJ112qL2sonLwmCD6lj0iOhVZmcsK
         YwXA==
X-Forwarded-Encrypted: i=1; AJvYcCXQqGS1UkPo9N3PjzgrCZHDVcJ66c9neIn6tmcxnLUhwFZxxqNYx/vTBY8ZLnGB6nGmFpyUbIRVhNPxcNV0Flxsbq0B
X-Gm-Message-State: AOJu0Yx9m8A3rdy+xXrX9n5v258R0ZyYdd7EM+/6G4zb+QW4X9DMHCHl
	73ayvhkZY0Z4M6b8qeiQvPGOsXYQ7mDM1+Qcbmr0dosLYTvVjpj3eJ/bw/H8JEc=
X-Google-Smtp-Source: AGHT+IFeeCiGV5thGBTiNh7gr+7QbahBgArLsgKhz9+VAJf8JWTBngqYPYwRIe5wowq9hn3JvNtDbw==
X-Received: by 2002:a5d:4e0d:0:b0:360:79d4:b098 with SMTP id ffacd0b85a97d-36b5d03ce06mr4046832f8f.29.1722253775119;
        Mon, 29 Jul 2024 04:49:35 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.173.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4281a26e1bcsm51280515e9.34.2024.07.29.04.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 04:49:34 -0700 (PDT)
Message-ID: <7ef24be1-e79c-49ce-8c73-3509a7c8d77a@linaro.org>
Date: Mon, 29 Jul 2024 13:49:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] tests/avocado: mips: fallback to HTTP given
 certificate expiration
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-2-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240726134438.14720-2-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/7/24 15:44, Cleber Rosa wrote:
> The SSL certificate installed at mipsdistros.mips.com has expired:
> 
>   0 s:CN = mipsdistros.mips.com
>   i:C = US, O = Amazon, OU = Server CA 1B, CN = Amazon
>   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
>   v:NotBefore: Dec 23 00:00:00 2019 GMT; NotAfter: Jan 23 12:00:00 2021 GMT
> 
> Because this project has no control over that certificate and host,
> this falls back to plain HTTP instead.  The integrity of the
> downloaded files can be guaranteed by the existing hashes for those
> files (which are not modified here).
> 
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/boot_linux_console.py | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>


