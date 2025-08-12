Return-Path: <kvm+bounces-54464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E28B219EB
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45D56462DD3
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 00:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563E82D6614;
	Tue, 12 Aug 2025 00:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RtJ32x1e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052171E5B7A
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959728; cv=none; b=kq8BkcC/9P82fXBRNk2lLihbVpkqjCkLWJj+aF0AgFPDFon3RcWjcLsC/P6adTuiMDR2sfMVpSRh5jIhZV5QQJirxzLArX6hUFlfXcnXx3UKTW1iAg4nyXMBVkrgrg6bq8sqjUsxNlcoZIcTK4XYgpy6w2q3NSpCYEPvoaqinj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959728; c=relaxed/simple;
	bh=mBjaVbZGFXFd+r8XyT5RBek0kgCKebzhgVKwI8jTwqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sH+cR3J+d6IYP9BcmBnjiP+2ElILurKwk5dCYOyvbQbOGD0jSeV0y1S7dKV+VHJJkj15X29NE0TEYQ114wYK5B1qL9+AsF2cVsY22f54xcy6YG8jkqDrLqUt8hFMuNgLUeqC8SAAlc7TVxR5eoSjreeNwBhp1QhFR/4t7qO6/5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RtJ32x1e; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2405c0c431cso46184045ad.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754959726; x=1755564526; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=surpJ98tRaESk7K6ewenyJUSlUpmPKhBVFvRz3srkwU=;
        b=RtJ32x1e7cazhnFGVe+JcBavNVK/vwfdGJWXdxt5YROqeEdCL0tA3jvRffrFsTicrO
         JRF/7TZrsCj0t/CUta+niBQ0FOfhxwy5TEHtoMhaFFgzHOmU2ZEJ6W6UVkKwZunUJzEh
         sqd1TrZR3+l7MjXPQJ16c3Mzfd2EBgP5gr1qAgGUcJ6nXf6j3Yx9LfJgSdrUVrqBX36a
         agXrDBs4PUhDP7qPgAUBZvg4vK5RVJwADyiXw8aTJAN2d/zlXRHUCxwpdmMRdGBT8hzX
         MhN21F1TsOjk1cobAdMkwQs3aaSjxuIs18CT8OqY5BFVSrTNRTOnkgYvvVbLTkxNZfg3
         oSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754959726; x=1755564526;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=surpJ98tRaESk7K6ewenyJUSlUpmPKhBVFvRz3srkwU=;
        b=KW13Wxyc6od2m5unI/D6wNGlvqS2SP/dQcPe019uZMT0+nRjFtw6eU/W3qgufVyZtr
         AY9OXAkLkQWoovzJbXCnON2dLXt0fFYayVcOv+4r2hf1Dty02IsDazD60APumAGNNNJ8
         q4VYLYdXhnRtYMovRHsolbZsCng4w5WUCGgYiPqDSos9ZZ3tUz7ub0HubSjyA9o+JiJU
         ZN4luM9x93ZgrE7V9UBd7F4Lr3K2/H6cTk/C98mAjUuVO/ZhosK3IsKFd4QNyh/r2Zo3
         x5tP7VnkJemtNR01TAsdXDys+NSrnCxG7XKHJipTaUzmAieCAH5uTZQ411QiML8MnNJo
         eaLg==
X-Forwarded-Encrypted: i=1; AJvYcCVKD7VcCqn2OtfI2HoW5xV+0nSTmOXqGLZpnc73o+r/W5WuvibCTbXZG/SiWx3zi0MofFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YylVm4XbgKo6AtZC2SE7+50AH4I+oXoHyiompy6OcnGTQ8t6Pi5
	SSRwMKpO4zy8AluNEgQftt5ZSTPSJiqaljfWtRROrLRpDpQ89go6Q0PdGywKndlTpdE=
X-Gm-Gg: ASbGncuuK1hfLxDrvPUEH+jgA5woMZsJI2miZNVMq1lNBIjLqrTnLZsAPQBI0k9SPon
	v9YIyQRda30tFyT7NygwQ1cddfD1I7TWyooXiw0+U+LP9eORnX7QdxMKxUPXlgrka5Kw+26s548
	XuFQnpgyyHdumqDMOWjGaDR1yR50K/EJgZjftAIbsw+62PMiWDjY/3p2ngzortqTH80OIuIW53V
	OBMF45ChgCaV+ud8GjQg4s3XjcYu86L29H0ozBjz16PLEpQsaL7A2wi1nM54rbR73gwmXQR6QHo
	aU28HNJFtJjMgntFPYq8sn8EP5x6lsVvxHrwVoM564h2P/973utczbANp/DdxDj+/vBcK+PCKNl
	feAiFVTQEWSUJPrbxr8NuQUiRzXxl/+2184hSjvSJKw==
X-Google-Smtp-Source: AGHT+IH36nv5aftkZHvXUnHZVxdwgQ0piS8gs8U6mo1ksuQEVDfYmd+B+94Lg+Gbueb2VGnIBsgn6Q==
X-Received: by 2002:a17:903:1aac:b0:235:6aa:1675 with SMTP id d9443c01a7336-242fc371057mr20701975ad.52.1754959726287;
        Mon, 11 Aug 2025 17:48:46 -0700 (PDT)
Received: from [192.168.10.140] ([180.233.125.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aab53dsm283244775ad.170.2025.08.11.17.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 17:48:45 -0700 (PDT)
Message-ID: <8efcc809-f548-4383-b742-e435d622da73@linaro.org>
Date: Tue, 12 Aug 2025 10:48:37 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/11] target/arm: Replace kvm_arm_pmu_supported by
 host_cpu_feature_supported
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Haibo Xu <haibo.xu@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>,
 Mark Burton <mburton@qti.qualcomm.com>, Alexander Graf <agraf@csgraf.de>,
 Claudio Fontana <cfontana@suse.de>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Mads Ynddal <mads@ynddal.dk>,
 Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org,
 Cameron Esfahani <dirty@apple.com>
References: <20250811170611.37482-1-philmd@linaro.org>
 <20250811170611.37482-8-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20250811170611.37482-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/12/25 03:06, Philippe Mathieu-Daudé wrote:
> +++ b/target/arm/kvm.c
> @@ -288,7 +288,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>                                1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>       }
>   
> -    if (kvm_arm_pmu_supported()) {
> +    if (host_cpu_feature_supported(ARM_FEATURE_PMU, false)) {

Why is false correct here?  Alternately, in the next patch, why is it correct to pass true 
for the EL2 test?

What is the purpose of the can_emulate parameter at all?


r~

