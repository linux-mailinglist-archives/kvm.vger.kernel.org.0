Return-Path: <kvm+bounces-45115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9637EAA609A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 062114A0365
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51FD1EEA46;
	Thu,  1 May 2025 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="amEBQsGE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6CB6FB9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112648; cv=none; b=pUHEWX2wxhogZmABHUu+HOvwngR6fIt4qFmmogSb7eMhg6rHuEkW77y0ZJxYtW77fmq8eoiIuhAYSyaz10+uUhN6jxeDqKXqN07Hq2vOdBrz3i3Fcp8hnUlBzyDwL3+B6g/6LTL7unWVfJL7FCUKzt2W/Rnr1U8ODV+15B05us8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112648; c=relaxed/simple;
	bh=TAc6fVyf2iHQnEh2bjWoyo98o1z4hY4NunBYhrmpcSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=coAHNvyfsyTMnAI41dpRwVrKFChVq4O6gBEceuJdXXPMLbxMKMmN1ldS9D6nnkJKZBXan0yv3KUMfXM8Ul0MRwv3uYBu0ap//cmtiwqFcGC//gOwUgbr0jSrfoQpAFWcy/34TQE9KX3TfHVKnrLmVqN0rafFKiEfLTmS/lVubWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=amEBQsGE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2260c91576aso9535025ad.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112646; x=1746717446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dy64AXLSg33oFDxGg0PbrM1b8FWcFNT8FYGR5t0yQQ4=;
        b=amEBQsGEiYqZYvrKXGunlrrsxvkuvWou/NzUZqp/6N6pUhCfV7vb3y4BvnOBFfwGk+
         K8Tot0zwcAsVLP9eLQX4MVvx36FVZHTHQF8If/b9Y9I+q1ugr3y/va7te4bb0el7z3vX
         LDbm3SbD1w2GwzA5VRUV5ekA7ZhP6g0RrHupeUlaH9EbdtGbCSBMvKk0/6V7ZedoNljs
         JjMGp8hCy8h7rBoH9fRkttoUIG7dhoSq958jnTcG3Vzk2ktcV/gus57pXOJJSi26Qt+P
         R7WgSAxzkvteDorxgEgVx8vr7U1Mwdc1YPpICNnk2KRJu1DsaMt7vD/tfVhkIhl5nx1q
         6nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112646; x=1746717446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dy64AXLSg33oFDxGg0PbrM1b8FWcFNT8FYGR5t0yQQ4=;
        b=oMGSxrEn8QO1l0ykrm7+8Oi9Sw57fOSFnNQpFf4uigjm+o8XvKXiqo+G+Ah2jEVI8B
         70ro0J8lhfGJGr16ofRRZhruOQfuex+vy0xXSfoJTdRZN9y++mbeibsEGUEZqrJZRCNq
         0UXaB7sYC8iqH36Nl7yXauzHp8AKNqN+QgL8K4D5ySVpnrSGYrstKyH3t/FD71vhlHsk
         p+hoUiackl2wxsVHKgkUhl8drzkj+EMmWfeLT3UsZKADzMCu3D9EyCaycrIiksngDTw7
         B2qVAorzrs5YSNa255PQ0Bmn0px4otQvcJSI9mAabDth1SSzvApPa13GEdoeAeuf1Fpk
         D6LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzA/6luco4ouk/B8QkvKF3QdJ7NZ4ai/xLntG71QFIcTuE4jz4i0Khl37OB5nu1yGdNUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkH+UoK0JNqRH3rqojVE+mUNKOWO/FwUgZX4+GzwTh/uoc8F6C
	tAjgfH9RLeCUfwPkq9KLkLD2/G0jC4GBTbT8G+ZluejSrzpsvtX7tX5bJyj4a9Q=
X-Gm-Gg: ASbGncsv5kfcrbhe3jig4WKWe5BmFM6vplTKbKOPd128IHplZLo5PovKmN7DkOzEgMl
	CK852OWAnjBVNj/Z6SaQIiUTfvIhSwYXHZk/7hyp0Wx6MpfOHmD+kfMv5P3JEIQlvBP2Pq18njb
	PbWdwOUfzsUIOhdSbRZsOoUbKuMXteQPvICckmbAjH/T2SXg/y9xJOW0vHPUHqsLCRXpqPn5iLN
	t0A5x3NT6QD8bhWZbpXciK/oD8sj23CURV/mZbuIUSbsH19bAIqdjPsj2YBBB3HIB0nhsVb1ua/
	M8zmqEB+Bl4txXVL2PhsckFmQYe6U1pJ0AtsEqrPLNSeeH3LHhkCzwSC8CS3OC18kCwMRWBmilH
	IL6giOWw=
X-Google-Smtp-Source: AGHT+IHhEHrWTzObUpfD2ICW5GU6jqOmtHEYur8ShlNi/oGjCpkvd87Fz0ZVUMYC8k/Hng5SFchK6Q==
X-Received: by 2002:a17:903:1c1:b0:21f:5cd8:c67 with SMTP id d9443c01a7336-22e040e45eemr53848915ad.31.1746112645853;
        Thu, 01 May 2025 08:17:25 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bb04bbfsm7979095ad.13.2025.05.01.08.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:17:25 -0700 (PDT)
Message-ID: <2b9b7a9e-c720-4c11-b650-e5e34e3a91f7@linaro.org>
Date: Thu, 1 May 2025 08:17:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/33] target/arm/helper: expose aarch64 cpu
 registration
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-22-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-22-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> associated define_arm_cp_regs are guarded by
> "cpu_isar_feature(aa64_*)", so it's safe to expose that code for arm
> target (32 bit).
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 7 -------
>   1 file changed, 7 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

