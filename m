Return-Path: <kvm+bounces-45126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4FEAA60BF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89B3F4C2E31
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B69DB1F4C90;
	Thu,  1 May 2025 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qyCmKPUH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3F132C85
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113457; cv=none; b=eIaaJvfkCAW1tYPlSON85ytzwKRuZkhwEt+PLhXl4ROVqRWCkQWTmRjcTce9SAFjrKLjNjPZ529X29v8T4cJvRmJGu3Sc9i2KRnY5RN2CrmDJ8tvL8n7bI7U2Z7LvorNaoxr83uAOQlPsHd44LLvBCnpedfHL4ItinbKRV3BHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113457; c=relaxed/simple;
	bh=/6MNDkNjvgplwI6717/jIJ/8yPa46ThdMGbbkhSS9z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=opYCbqLTGFwGYIK2TFFJNRKQPmWt9jmN/+2sGh/+JJdKuSg8aBn5sB6X6Wv9nFxnsJ45LmjPMEWdyKtKuwXnVFppZURQ3QO5LJINRH4t5q11PGn497TUvKZHqHybTTGZaee29Wr8LNITys5nwcI2dRgz3625C5b7sQO2gIC7uG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qyCmKPUH; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22435603572so12474275ad.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746113455; x=1746718255; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=qyCmKPUHHr7qODyC9xn2kAO7CXuyJ5TSU4Ahaxod+iX0Yt+GPmXsUSUeJQTueNG2Qd
         0gDzB13b+t53POZRLOpjeWczxNC3qGLik70UKAuTq94IS/gSXp64bounPgYgGJjTpQP0
         fzvFisIG55KEbBhzORvo7LHvkeSt0Og9MpyS6vwLUkJvBgFUcZ4QneI1E2nnVoNb2gY2
         Pj0/sP0CuobMdyEcF15ETwgiJvghQ02bWZ/sIixW8tg3O16ss3WTU/JWmX8pizndQXHd
         JwTWrBOgbTEEX6VKcM3ED54vK/hCq3QM7GkRuEmkFOYrxSOSkwQAq7ZomF74qpAcKPtD
         bERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746113455; x=1746718255;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=sg0kRCHziVOQkIOPabJF1Nys5rd5LWloyX+7SQCkDDBJ4YS/nUZ6w4I9XA+JyhRqRT
         ERTztb4rqKUInMielVYJkQX6tYMfdFX9BntLHKEeyk9n3bd/jfCY8yijCM9qCfwCGzqT
         DYHERJ8FZmNEaLyhndvzfEHMOTHWX4T68Rfq1z4WPB+xvHfF5+9X/BUuVUVezUwkQ6U8
         JRRCDyEA7syWOSzy+gjik8kE/h6yDHrA23U2TeXVq7xOJyUjWiU+lwaybU4ZP50rchev
         WhYiqaOsEJtMg19inIAQqYKEaPyLnX+TupUVAEu9yp5Otsdew0tC8XkTMip7dTg/ZTtj
         S1xg==
X-Forwarded-Encrypted: i=1; AJvYcCW3TJ3997c/Ti7MvwdTy4j7OGZlZhrCxL4NiWlbBPf7JXGUBXezwVzedU1a26LpkVdHELo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9IcV2wJv6POp5uAYetyaxpZLtD1yjZbGgkIFoZPZTTENM3+a5
	t8O/iMuGU2NxwVDFrSWsA3vpIFU5iMsBEt4cH0cq0IvXGVlctLPnJAsjnh6iZK4=
X-Gm-Gg: ASbGncuzWLI+oXTjnmltl9lmDMDZWfx1yiZF+IN+2hY+HQNu5ZlOB/eB1PHDwkTBTmi
	S//XL4whvMfT4vGunQamnc4k+8TPz6gM8J84ZCEG6I5NcXOtJqvco6RarftxJUUg3UO9yZ3UTVq
	NerSG8G7YAn3pj7OkYbffF8BIV81A2ldVMIkXTT6Eiwf20ZApi5R4tgETrTvDDeiFDRrWj0ZU+N
	oZBxAagXOWRKROVu/iMLNs3k4bk+EIxxC9f1puUf6EhJ5KAj/Tes6jR1fc7CtwaOxQ0GOeOhHoV
	W+RseXyxpLdwhmQiOhxWAm8lxbuPrpVNBQchjb1B4Qxx9YzqTasp1qQS5l78lG7xBFBqM6whPBE
	v6xLoYzQ=
X-Google-Smtp-Source: AGHT+IGzeJ0uKlST6RHLeyXfLwxl9azhIspU6tXs0Mg6AOMGNGmywhrNGTAzy4CllvHWvHp61PdBtQ==
X-Received: by 2002:a17:902:f548:b0:21f:4649:fd49 with SMTP id d9443c01a7336-22e0863efbfmr42799735ad.49.1746113455692;
        Thu, 01 May 2025 08:30:55 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1f9d4b2622sm750511a12.17.2025.05.01.08.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:30:55 -0700 (PDT)
Message-ID: <d21a3e99-14c2-4eb2-b331-bd39b8374ec6@linaro.org>
Date: Thu, 1 May 2025 08:30:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/33] target/arm/cortex-regs: compile file once
 (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-29-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-29-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

