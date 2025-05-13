Return-Path: <kvm+bounces-46331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8626EAB5281
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FD3A16D27A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575912472B4;
	Tue, 13 May 2025 10:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g21aslCT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4492459C5
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131056; cv=none; b=TbdrhhyPHe8vXkOOBGNzpJjRM24fE8JSETp69CwBpbpmZ2PoKoWlzyNmDhncTx2hpbZGloDUMxQezEiUhpycM2ji2xbrQjg5DFP1C+Jt8v3jSSRxiVi0gKhJIIXpAm7ItM21CzJTuyUGWa5gDZAvtIobtAlnTXbvkzRKWGC8lzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131056; c=relaxed/simple;
	bh=x8DPzPShBdo7sB3zQz2lwtrlI3WVVX4RlZeB1J4v4ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oz5TKpJVkQEYvkkBB27NQuilaJlXRFRn6ZWRUxQRloKWECLAaEIcAGmOTzx/Hryf3+spDo7o2JJ3Hpr6RUJlpj1+N+vlsiIOMiNwPkIAheOQBnj7j8UhtGuyeTWvOSd7bco4KC9DCWthrzZA1/k951HUfA8fdqSJCtsY6qvtzrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g21aslCT; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a1f9791a4dso2241663f8f.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747131053; x=1747735853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YmugX3GRqGD1c+UyMRnrvs+PUb5JfixmDAgVPG7ZL0w=;
        b=g21aslCTB2jDpDUmkI2cdWmSHCc/0imy1SkY4YNdakJFSv5s7qTRu4eqa6b/yqlD86
         vvWM3TzxctDMOH0r8KfNvhoW2+8P/bmx0dXHTo1nGYc/Mgr7aD+TyN049vYWWu/GP4LR
         DNZl1WoxKWrwqdzJpySK5tUeHKzWhq31o0AZd/uQB6rYXVDDOwZ73r6/mLkxRrNJJn9b
         +AUWgBBltKvd+z8HXwM2sKSb8gP6kpHgyXKIRMO9EhhL4//dqcS2GJAvohhdlz/Ygy9O
         NdaTGUN6Ke6wUQWD2Fva9bc43z4LjDRKSuU/THjyE7rPt1CFihNu1GJSfX6CfqOn69j5
         l0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747131053; x=1747735853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmugX3GRqGD1c+UyMRnrvs+PUb5JfixmDAgVPG7ZL0w=;
        b=kMUd3+jheN/6mKHlv8vAZIsVcBaiuEPB5g2eyouqsG/B0B6siEBtWAOPgdlOtaMIpq
         /e0jcrPFRRnxxVk8zv6gdrB/iqrKFzGRjXYCi1IhkN8Y0aW/QFeu43lrdyv3OkXNlY2X
         cR4eIsQRRms9Rvj1IdCwcTG6EuXZW37t/O1bfXpsFuyi+4CFEyhISyX4dqujqVi+fIcw
         qdE3QsmxL1ifdMjkBrFXuP05cLTXavtXfyj7J93kbWeygovcH6nLjdY62HdEVEOS8O9w
         d1JqNEGQl1OBKb/wj+uicBSsvCF6ryqHl8RcGLb+FFLioYr/dItwz+w/51wN7bx8Ai/g
         Yu3Q==
X-Gm-Message-State: AOJu0Yxff7n30SFrWTTdIS2va0lgF70ZyDLWh25MSvWtdP0578TccPR3
	+irU6fknPbtbJCV1jo4J/ecIeJQ3uD3yKEl0+fmenQZk5Ew7oQLzOyfwyO/lZxg=
X-Gm-Gg: ASbGnct2W9Pzbd9Eelv++fZL6JhHHdFJ7J81iSNXYynlafqEv6RSwJRvYp6NfUnDMfg
	d0vKC3Gb3gWrjiCywD6oUVEMsirwCx5wl8YS1MEzSGtDrBPMWHufAFyxLUJ1Rvfit7zPsnm0r3M
	slqVBDsaTUz9WYNxPfuTA5hOqdE3bFOzlypUAF3mEwVPW4XXJbz+I0Yw7G8HKV/Kf/3ICCkF7ZC
	llrY5/5K5YuU2aIi4YXKSilp4+qgALjUYynMlS0U3rsDD8D5/2LU0IHAIohL4O9FLAQ79mkHl81
	wkUL+MnQuOJzixYDjEHBznWL5MAKTrYuz19hYx5YkGEzBUQn8i9VmIiloOnfToF9DQokMfAGb3y
	Rdly0HTgnKA8ScaJq/Q1kqDHLBXs8
X-Google-Smtp-Source: AGHT+IHPSdYV9Hvg10t6s81fQYAul8iIZbBu93I4T7U/xvXG+7WQ9zkVHbb4vFUD6IQs0mSvASr5Hg==
X-Received: by 2002:a05:6000:1a87:b0:3a2:6b2:e558 with SMTP id ffacd0b85a97d-3a206b2e7cbmr6254769f8f.28.1747131053188;
        Tue, 13 May 2025 03:10:53 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d68585d1sm163142375e9.31.2025.05.13.03.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:10:52 -0700 (PDT)
Message-ID: <9cc2fd4a-2b8c-4cdf-ade3-ded482fff1c5@linaro.org>
Date: Tue, 13 May 2025 11:10:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 35/48] target/arm/machine: remove TARGET_AARCH64 from
 migration state
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-36-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-36-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> This exposes two new subsections for arm: vmstate_sve and vmstate_za.
> Those sections have a ".needed" callback, which already allow to skip
> them when not needed.
> 
> vmstate_sve .needed is checking cpu_isar_feature(aa64_sve, cpu).
> vmstate_za .needed is checking ZA flag in cpu->env.svcr.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/machine.c | 4 ----
>   1 file changed, 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


