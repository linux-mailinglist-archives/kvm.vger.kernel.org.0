Return-Path: <kvm+bounces-46330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8367AB52B1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF6729873DB
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D854F226CFE;
	Tue, 13 May 2025 10:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iL2ZQZQj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D48923D28F
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131008; cv=none; b=pWydkB/yc6kkcpL0LbsCIZFPZADWqmhuDVd+GMpDWGPGexJIfAGM+mQvJebRExShA9/KgXzfK7IolJersKGG9V2mgMotW5DBomwEQAUeREUxuJoaiOj9wu2Psz6alEgTrMXu5KI0tIQ+kloZCWuziNFDAEXAYSVEONzqFaDg/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131008; c=relaxed/simple;
	bh=WpTluBXcKgWHb0oGfrITW1ZIaVq5vypH7t8dMKs+Zws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOVeY2dtIp9LhpiJlKBNBhC2IAqhbGWBfm2k7XDZ/0yIvzQHXqEgZlAB3i6c2jQt70vj/wy2O7XsbjzIIzDL4yJRBEMIhOpcmJVFmQb0LkIlldjZS+PZKCVvVRXUe9aZByX370nx/nFd03Y9T5M0Ym+VhbHKQ6u7iyh+vuNH0tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iL2ZQZQj; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-442ed8a275fso2838505e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747131005; x=1747735805; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOAigfDLRAGWVzplLf58yZ9Svxs+dmsZC52tDhTGccQ=;
        b=iL2ZQZQj+FShN8oE0Kv1wI93HhT6jWYIkfWc/s+brSpQ3WbwRPEnUKd0ZdIRL7ICds
         PUZ/KCLvxaofExCW/xh+mS0hqVky5+073+/pOu/10h/17SeB/tUpIFX8FFxMBCw9WFu1
         oytsbsit80wrjhr5ByKFp7ZFGNH/NFlP7Oa/FzD3OSlbOcCw4wek4MuRJKDPjOllaoc0
         9mB+cj0LV0zkuVoxxRsaVJbWjMmsFAl8s+GeUJBq1ruF17s2My02gKjxvjbw8f3IWLQ4
         TC192tf82FSRWMk11NhcASK+I7DUxpVH5KCZENz/QpK6hZ8Y75v9ryQc38k8bznNmhYL
         zdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747131005; x=1747735805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOAigfDLRAGWVzplLf58yZ9Svxs+dmsZC52tDhTGccQ=;
        b=NoOUT0V48Fs0H6zx/W2DBihCI4mr3USYo1dHak5eNkCw64SpmV9HZdet4Dm5gDtd9A
         AZ4wmme7LBCcsEG3O2d4iWzk+Xm+5wsbcdN1Nbj7hCja+QaQAc8Xl9EfPIWLyr6+S/rt
         yCFJJGzxmHYWIYwdXPGnSiht5USI2euDXmxKwx66N6myAuXUWCW8kdExTCmYV9/iOxVU
         Vd0+fioIf9LOlZXgJHXjCLAIVMBAdeWN1YLYN92BMsw/zyMEuQGs3tRdp6uQ7xvSYtED
         tlhc762A5XkCrXEwBk7LGm8aGkMGQrut7RRV/YzApJwfWjY828YkzMjnZvJvy7O4OSxL
         ae/Q==
X-Gm-Message-State: AOJu0YxwSJm6+5m6OWYKyNHkCHK+Co1Ld4zGYCLYDTKJjpiff0wCfcxe
	yRt+6oamps15fjvWckbla4/ra0wD3fFRvxRfArMTzVnvPR04cElW0mrSuKdIkhc=
X-Gm-Gg: ASbGncu9NHftAfS+iHCslXPTlrdy7nn8qV/s3nmiPLUmTMUQNabQUCzwBmDZedyS7vv
	GUn+77hymbIU25JgU6rUZszMj6zi/uM2emwOkyJQ27HKWhgudYRKgzkJVqKvfj8pCrajH4RpWs6
	MOpwmsobYh9knTzvHjVj5M+W2PwG1H8cD+Dorv9mlnWxCld9svTroFV1S38ph7IyvKYW4XS2sZj
	ZWiPLGBIYlyFXmeyfz+3W4mjVYgtUhqAY26WkxS15FTi1TWEWvO9x03bQ0wAhDYPLuBqBLISm3D
	S+uPAiQLZsSr8TNdQCZX6ZT+a8NbXuzTCCw2F0wPp2CniUi022ytdi2UI+xgAxtOlPEZpDCkwId
	859ibUAeFxkNuVPHHpw==
X-Google-Smtp-Source: AGHT+IH/BJmKeG8sCCjsrnEU4GvBCUJ7l4E3/vLrsI8yqEHlrC8lIIvVJnGpT7mn94M2UYA/kQCk4g==
X-Received: by 2002:a05:600c:8284:b0:43d:878c:7c40 with SMTP id 5b1f17b1804b1-442d6d1fb3bmr160420685e9.10.1747131005348;
        Tue, 13 May 2025 03:10:05 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aeb79sm205060145e9.27.2025.05.13.03.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:10:04 -0700 (PDT)
Message-ID: <69c83783-e2b4-4487-ba0c-d94fae9c7b75@linaro.org>
Date: Tue, 13 May 2025 11:10:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 32/48] target/arm/meson: accelerator files are not
 needed in user mode
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-33-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-33-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


