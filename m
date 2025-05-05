Return-Path: <kvm+bounces-45455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1333CAA9C1A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB0141A80A84
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FE12701BF;
	Mon,  5 May 2025 18:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JQ6Bz1Qj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95A826E159
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471441; cv=none; b=er6cnUFnWfvkRnH9oinwAo2Gz6OHl/WNYzFsf2KaBSrrvsjDWsy44qlUwKAJ9Zv0++XFTaZzJhkIC8fLW+PQ/XZMPaDPj5KB52/xRIRExMAWXxtfUdxD3PS4GPa071yBcwvZ6joo7+V5qC7jCXiuvICwN3uo8kwolvTzkXMsW+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471441; c=relaxed/simple;
	bh=YNGjosmMYvu5BQkxDIa+GoJ4jsr8vKSdcvIDc6PKsBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YxByyS0tao/UiaIXaqReoWUVx9yDZkZVxUUU15vqdyg2So6JlSVEaDSS42+XluCsmnqqk9pZqyX2d/4nLROcfF35ww4wUwGQS9xoH4unVBkbOsXa8/zFVI0nOYq76G/Z0YlAUKCbkcM6MaXYFjLfC93Aq3DDw/A7yZ4wJuBTC2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JQ6Bz1Qj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224171d6826so70960735ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746471439; x=1747076239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D3ND1SAC3lvQohdosheSraL5hqzXXgRa/d3DCKAxaiE=;
        b=JQ6Bz1QjKx5bi4lE2t+wM5I6W1jIoJt9zcRcDiQN4dEgf8Qst115+Y1lN4frTKTl7R
         WrEmDSS+otSkOnnUzfg7GfMjmeGgWgg+azpIXiRGLkWzZLSUs/zAh6XB9O6vI9hlYHMs
         rYHvolU2D4VcTRYrboGQmP9HccyEDXOtQMw9TpcaXOiVJuCYWXvacJEtBZTdX+1Q1Moc
         A3D7PL4mUs1QruLmYK6b7r6S2zxnAIS1mzJ7lD9Onzq5/EaWyMbwZwJ5OhWW9xHTfbcg
         XZIaV0v3a/A8EVWD+XoMpfpTw2vyqaj7iVJiY8zInajMJK7yx+/loiEK+mY65QwBh8wh
         DRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471439; x=1747076239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D3ND1SAC3lvQohdosheSraL5hqzXXgRa/d3DCKAxaiE=;
        b=IrELbbtAnuykDjNk/4xi+OMglpr7sZYNr1nRXoQ+NJr4El6WleWHanxyRs+e+9FV0a
         xP28nQwgyGQEjCF21zOII+bU2uV2p9eRknhyPpQ2B8HiBIhkef39vfxJaxuIuBcmLUPK
         1n+lf/Bn1iFjRNkWNcJoO63duJTiIitMtkM4FlU/HY7o1IOgAxZlkePMEJ/m1rjShGRU
         l8E2T4yHl+yoWeilLDuwXKpdPrOmfMgaXFLUx6ExOOGCrp76wVY33LC4cGV0OpdcZnE/
         3N9rZxRAdojuHsfddcOzk07LggzIZ7A7SESrc4JnyFghAH4EXDgFGwJgX/gpIxnrSxCQ
         XYlw==
X-Forwarded-Encrypted: i=1; AJvYcCVBl/Po+88OdmNvxLZuGk/5H+GQRHaRKR7Rr4UnhlKVg8gAF8+SoGFDHVH6LhA8ZPTlMnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv0b1TQk81C2WEfgfSGeXAnNVmOvu+2VSJE5qg81+5cg3cl2Hq
	sLE9kKHEwJVooPk6SmlavIK+XSiCe4EHLjSLsgH+ocpHSFmUUUtAFAwh1coZ+Tw=
X-Gm-Gg: ASbGncvk6VA2ffSjYJeLnKdD1JOkb9rNEnW/hD+NWPFKo/m6gWh4ArLkjxZBDDhwNqs
	Y65de+D2yMdizyqrW8dAUWjWrMY1QHnpGa+0o8U5PhUN8yTpZBTwcT7ADSjqz4zNIx1pd+qg4sV
	VwaSVVSW/3X0h6GOa8AOBIcPFsoiPOGaHAm0sUKljXO/usDzitmfehCk4Jwfoo1pZjPCRmN0fVE
	hyMVJj23Wui3BKTPGZN0Jp25PCOlnpr7xt9BA0V8vieyYMiilO1JK6962Sdm/DzK9mPQwdYP+3E
	jTbjel+u3LRru90BqiD9r7+w9291A+8kwwDDMj9AZ/9MCjj5z2cW3ItrroxpV0RmRNZn9zSBlz7
	5UNn4NzY=
X-Google-Smtp-Source: AGHT+IHBbFfWMdx6MOF3TzOMnofsi47UUFpxhoxY+MWXgZWqBLVhK3hrsAlK0As0A+dkEZOmLelXjg==
X-Received: by 2002:a17:903:1d1:b0:22d:b305:e082 with SMTP id d9443c01a7336-22e3311e8c8mr6072235ad.47.1746471439131;
        Mon, 05 May 2025 11:57:19 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058dbb5a6sm7188920b3a.45.2025.05.05.11.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:57:18 -0700 (PDT)
Message-ID: <3e69a6c2-f759-41f0-87f2-1eb88844e19e@linaro.org>
Date: Mon, 5 May 2025 11:57:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 48/48] target/arm/tcg/vfp_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-49-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-49-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/vfp_helper.c | 4 +++-
>   target/arm/tcg/meson.build  | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)


Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

