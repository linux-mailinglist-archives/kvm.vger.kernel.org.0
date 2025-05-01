Return-Path: <kvm+bounces-45112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC51AA608D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C16227A9E56
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00777202C45;
	Thu,  1 May 2025 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oD2pIPc7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21881BF37
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112487; cv=none; b=QcACcxehG2SWY9o+hBB4dWlWyqH+dKC37NDBA1hAVcs0Pf3pbhfTHQ4lU/Z+69lVUv1BBDR5aMAWrNFs0YATV6tYfI8LeC9ouOAUUQJgqY8NHlrhN26HzcG1p7fTZYckBjro38URLnNGAlDeBP0hwAalz4IEmluqy3dexieCq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112487; c=relaxed/simple;
	bh=CiIdi3nBRL9vYdy8kc0DQe8DzA4pexFw8OLz3Uv29Qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZCC+yT2GGJB25sP7Jmr7KklMyWbueOxFGJ9Pik2gHJu4UpcEFO2DF07lQzmlzwAUHbpSxm5bReDspCvtVADMmBx+hbojWT1IqtB+H4uYCijl9t10DHVDnkCzDrCKU2dnedmNYC5F119v58+12WOAG5CbOo9X1n5bzBsi1a2rQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oD2pIPc7; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-73972a54919so1104224b3a.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112485; x=1746717285; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jbLSF72pruch0HGWlc9WZf5BHEj56Rx4pJZa2a38Hks=;
        b=oD2pIPc7o+OS18r36O6uJVfBopk1nlE1dEexak4ehRTpL2/3dSWI5GpZo8nSMVD8Ac
         CSpQ0UH0RJ10+Y0rT8/RpVAJf8/WopfBrx5Gvg8hQaew95b3CoTbGMwlqCguauXsEJUj
         jBKeMkyHzfH0adv18uQ4PXcEJ7y2ysEhFeBrBqCmRdnK9o8sUJiuybDQzfBQalLzQdmD
         BD4nIEbpAD/ni+9oqY1hJJRApIyWplmWmgCY6L0AVU0vbbUm6dr2UvefBzhQkzOG+bTT
         eRin3zHtYwFaHWrACClOVO6YXuunsv9TOeD73p03D4XwQzpGEHIeKfO+gevJIuamxJ7m
         kAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112485; x=1746717285;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jbLSF72pruch0HGWlc9WZf5BHEj56Rx4pJZa2a38Hks=;
        b=pYsPKWDepcQ+ZjKINKzOuPezOknvQTjKWMS8Nrn42nmHxgB6VCmOmZgrTwxzy8SDxd
         nCC491IshzBhVFFFYJoHb0UnIn3II3KuS4ndAOkYhgRqhagw5KFN8FkGiJDBzFYPy8Jz
         tckEYEGMTbkhxkaTtBxs99yl7sXtRjHaRy0+nI0P5nvU43rLLJmbmfZ9II6iGZKObzE8
         QXoIl/9VGBLSLvziIjbaWZ29vHUpwkT9QXbyAQwFbxt/pk3XvYQ9iUwnRADYYaiw6AzC
         B5HAigV7EBrdilZJUCJOQhyIV7pssjKlXdY/uDZEInk276cIM0rpTjm9T++gV8nshrRS
         SiAg==
X-Forwarded-Encrypted: i=1; AJvYcCV7ZSWmKZmPjAmZ3IgU4jF4SFLiWAXR7HA+fnTVkjKp1D0DTrBPVPq591B2rszI8fFW82I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo1BxsvKt8NGci1ONXv8TuxKqYxACZtp144r1KFADZdGANg2X/
	UXO7PrH2TBroHPryY37nYhoX+74lXiIRGuwPcuSPu9xBlDylsERCWi1P9DXjH2Y=
X-Gm-Gg: ASbGnctGj9jXFaD4izfMIbRu0URaNkujBRkOSYzJ6ecIurXG89dJvvmiHmkWx7WKtCN
	/SI/blcxeDl/2vBOTgO1IodseKplKRZRWl+HQCc2C+G9mloNB+aFDS78OwZG0LellU8M23ytNm2
	l7wwgWM7ItoJiXAOyWulVY2MbnXBnWfCSH33lVoYvUuTNQiPEeHBByP82c2HqUdaEy1mNim5q4q
	OoFF/KlYuaWP9o7Q/S5wpl0f6OqXSthoIvt0130hsg0o8YIOqTYvnibeKZTepwoxTREQK9CE/bZ
	MTsWkSt5sd7h5PEOQ7FjAWXd/yCsSzpzPgztkFAow2UBLjY9OEU1P1psLzxhOk3E/MYXJiFeqKz
	0vGT26AQ=
X-Google-Smtp-Source: AGHT+IFMgvqQh+s5Nyuz5qPHiDHOVmpKnz8SegFotdFjKojk6rVGT/GQv6niP61swtxBzwtl/6INPQ==
X-Received: by 2002:a05:6a00:2309:b0:73f:ff25:90b3 with SMTP id d2e1a72fcca58-74049275c32mr4772573b3a.24.1746112484843;
        Thu, 01 May 2025 08:14:44 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404eeb1355sm917352b3a.20.2025.05.01.08.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:14:44 -0700 (PDT)
Message-ID: <50a5e081-97f9-4054-9b99-fdf1c1e88e72@linaro.org>
Date: Thu, 1 May 2025 08:14:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/33] target/arm/debug_helper: compile file twice
 (user, system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-19-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-19-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

