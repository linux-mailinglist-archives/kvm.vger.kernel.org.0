Return-Path: <kvm+bounces-46325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 572C7AB5159
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AFE27B6B27
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E772D23E35D;
	Tue, 13 May 2025 10:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZMLhuzd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B93321B199
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130849; cv=none; b=d5FovG53FO3nvr1xxSiisjExzhkcvMfS6pE7AFT5MKB0sJ7WDErzg0QqV1NVMXu+eOBZFZqP92XZGPlLxDprFexQ6U8vbq7c3Ok1Sib2xpFaqaUhWV3V8RBaXHZ/gdNTYJ0BJF1Qvgt6xRoIJz0bn1gtG5ULWAOaw0UCD/IGVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130849; c=relaxed/simple;
	bh=QYIkLOsYwnRTFHjfaZvXe36ed/Ig2ShR4JXssolC/Hg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBQzvgRdCbA6j1NcZlZewInZAMMgifse7sPLGN4JF6kxGWw2p7AOeiCmFfDGT0HvQWT4GoS0SSQJOeyybODEm8DWKOUFqwlSblfFeMKj54v5x5ekcPVWSRK2Wpw+iwKbmcXaf05HHxn7WMcTTjUci4BiQu3Kvy1rRH2+aFaGyKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dZMLhuzd; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a0adcc3e54so3279010f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130846; x=1747735646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T5vSQjcPExIVnRx8sVx5D2ET1Pw3X75NisVy3+k6Mfg=;
        b=dZMLhuzduKXl1K/iVo0l5zlqYt4dc8DShk4zfqQRjNVynOBoDphi0Q+wWYKLfbctTT
         x33dIq/n252X4NLtx66AD2LJrEiGUkD5AKjj+aM8e97lfnZVPIjXvbtw5oQJPnykDX7m
         X/si8PgnIhaK8WHzDFNi9mO/Oa4aOJZyEvnVv1yicOkqz1e3ofUpy8gLMZIr7xRp/1BY
         yAPWv4knB03iEqMl/Ui+FR98+YOeXP+e06wm7zXuZHfeqrpAhb7pS9HAFxk+g8y7FOVl
         R1JGJwf9KM9j8unLCZz5uGv79PIIpTwjIEwOdwyLPfugjgMKJ37UI+IU3UAbKAS19Qnj
         LB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130846; x=1747735646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T5vSQjcPExIVnRx8sVx5D2ET1Pw3X75NisVy3+k6Mfg=;
        b=iosPK53Y1hNumtNl4XOXcijI6MUIuWUzwumk81bfFFQROGXN/DUYCkWTz1AIH/0Hg2
         q9mDwf7yHxK37/aa0faZYO0kNRGQU8wznrUMyG4CpeAKVKgx5eUTnTa9h2PkA+k/GLWi
         rr6izPpGTd6lg/7Fr34RYQxPg1YkHVmL96jgqukNjh7BC7yfJEm5Y+HTnP+x/nh/+xwJ
         c7EQhyajTaP/Eh09R3h2CFxwupzbq9R0wN81jUI8wDCwOHlfNr06nNKcXQEGou7M13uX
         zf7Tn9ra8GlTmm2XeYgNFUfEwj/QQY4pq7uem+67c2EG0YWQkgs4O7AzelX2aG9xqcPg
         pR/g==
X-Gm-Message-State: AOJu0Ywj68Q09l/4u9N2fKzsukNViBUoJZhWRkDWkRLe8g2HwCfYRNTF
	ZD/0ViND6KsJFDFb3sqXmBAp1onzaxOZ2wLz8zoihUJWc4xXUqTiB1Yo60dsZws=
X-Gm-Gg: ASbGncu5L58h6ehljWPTlPc8uK3/lkP/xh8IOaO6JtoYLet2jJwBX7JVKJYky1RLW4t
	CYZh03wqmBPDs8SlG0/ipwV0WJT/ufLd7lFFFlvVjAUxmEVo2EPzn8AfMFx3rFgTVbF4p89Sf5b
	cCMu76TJ3IY0VtT9UDsVKju9+CWnDC6NDrNCCNLx0taUqCEig5mDdhviiv13u3MeZSNcVfhXKdO
	4xLVba7j+YRrLrJsDT1q9NTBDKVthApyp8BqFRndIGCsgcbkc/2TVJ/fTtzdkgfUVCruwFaDDp7
	UC82L8qbGWLIW0LgDEZuPuuSJLSFKj0YWd31kL9lgiUshJfAurjmSd5STuTnD+r9E5CW8MOoXpt
	idFdUGNqVXKF4m1tFPw==
X-Google-Smtp-Source: AGHT+IGR+hSqCpg5XZTqgxaXNn0FphVU6ZKFnDYfOWg97FAe0KPokbedUpX2+fZVdhEHBwHFkB+7zQ==
X-Received: by 2002:adf:a304:0:b0:3a0:bcb0:f69c with SMTP id ffacd0b85a97d-3a1f646d9f7mr10195760f8f.3.1747130845709;
        Tue, 13 May 2025 03:07:25 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2d2ffsm15808904f8f.66.2025.05.13.03.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:07:25 -0700 (PDT)
Message-ID: <4a2fd091-fe87-47ad-a5f9-cd47076cdabf@linaro.org>
Date: Tue, 13 May 2025 11:07:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 24/48] target/arm/vfp_fpscr: compile file twice (user,
 system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-25-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-25-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


