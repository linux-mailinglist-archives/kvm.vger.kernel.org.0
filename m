Return-Path: <kvm+bounces-45133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B07FEAA6159
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67E331BA5DAF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B42820E005;
	Thu,  1 May 2025 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o9wg20bo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD85818DB16
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746116669; cv=none; b=IO72p5kNbJMzyftFqhzquN8UmQTW984c2K8L5dNFywsCpjGYGRFcWMxxn1unhWqqnoL4V5PcmZWxumUzupPNQc7pMY+VIqT/HBBDM20dgFI0berAI6nh+rePZ2gI00cDqs/T45Nq36O4+UHbRBh7IScnWSGlzUzkc/QuVhjpq7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746116669; c=relaxed/simple;
	bh=/6MNDkNjvgplwI6717/jIJ/8yPa46ThdMGbbkhSS9z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GycIHst17Y8e2o98iu9R2mhjl59VLlYaVK9Umm8AODY0DUNIfe2N6LXnFB3scBejD+CCScrzSKgR+u49qaRCDqXNjPh0VhKwQUnunwRilE9oM317/F/vOIgcdrPA9Z1adIuznbgodJjRQh7CXZ7NCQUrUocpmNrUk8097nmlk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o9wg20bo; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-739525d4e12so1224618b3a.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 09:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746116667; x=1746721467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=o9wg20boFiRr3bkBNiwsfl8oBaypPdAuKxyN+RYtzBlCU6QrfGCZKnwTD0He6NYMEC
         9cWMmoXZf6+eALMLrQWxjxjW+JQPtHliWxGwxUj47s33l7JeWs6wr/rApamjUr7sGSkm
         IhNdHmFsE1dbujiP9XYnVqvWyfS9XxluRJnnYat5kCN04PzA7Rx2guSlXVlCM1qx928o
         sCjxZus1Iw9S5+lOBY1ihF5v5SNI+fQe49W/VzFdUuv1YrBBFjP6DlwEavHNeDRHdyV2
         cFYJG6yCJdxS4uGGjs9A55nWX5zNZrlGJ0SicObVda06ytrUm+a816EZJOgR0aGj1jse
         ucfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746116667; x=1746721467;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=mSFN5Fajzs1QvmQZq7u0XCYV2lhWJztEuhYRTYH8xRY7lXLjIiG3lbBQU/+h92Ugkj
         3Q1Lpdz4FJA7oHsD3c1Z9x6fGJgATU/ybstlcmLs7mFbp0p0m70O0gjs7dKhwcJr4aBJ
         /ZZI/3wA3vX0zvQV1aV3BrdTCpFEIfeGb70XdFQFUJbEpCTdyMxcbXqYhqYgs5zg5R09
         9BVY73EOz7God/zZRRpdz9Aga/CLrVOnF23XUCf7ywO+cpULtgZFCvOqsDgFrYvtv8bq
         jl6NxXXkXeblqBJEcfb1ZjuXqKHGKMkx5KGaodLQEWzkbjcLRkVV5aQzi49IfNlmufES
         89dg==
X-Forwarded-Encrypted: i=1; AJvYcCVqzb6VBMtm2TlcZ9+ty1DDM/+IGnTgsGfLvHNRCBWxElfPCHc3LxABo4S9xTuG8bcqiws=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi94EHtLDKo3TryBV3vcnVz01o81vkZArYwkyu8XNT+tvwKFv4
	GTPa1eGfKVatm3Gq7pl0ielYHRDpV7ckd1/3l9lIfIrucENjH2NNXwipOyYyJm0=
X-Gm-Gg: ASbGncvYwwgyb2YL3yDWnCQVtPIBAzKJUuVdjABkwV0pPMmwvS6Nm2in1vU97toXlsq
	UM7u9RNcgFs8RANioL8Q54EXxJ5DMhObu+cbOO17clj/9DamhDzoLxqwCW/wwY/31xx/wM2OSdL
	VLuuJ/OCw6W7fq9CAOv9Gajk8gLmSNSPlM/vlz9Ot20wVaZxtIiHZRlx63rMYmzwoSHu4Bzllzu
	pFAUBH/nUgbEm57KX0d/gwPcnsFB/ZcfZ1Ms5apM2WlaAOVew6Z3LKhXmj3tqxfD66P7HgheWNy
	miOtMmOc5jHio/0WkuPlWiKQNh2aycq8otHDLMbV585r3UiS9xNKLmvhFnrK22KrxvCV3a/YoU8
	nZrWQLOZoZuOQdhN6ww==
X-Google-Smtp-Source: AGHT+IGKLGdqve4sfuTYMdlogniJ7+2V8YZQgAut8VVxQxe9cMTSQ+UfFqgvPdx3ptKN8imUOXcEEg==
X-Received: by 2002:a05:6a00:1784:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-740491db38emr4206130b3a.14.1746116667105;
        Thu, 01 May 2025 09:24:27 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1f9d66d8aesm794850a12.70.2025.05.01.09.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 09:24:26 -0700 (PDT)
Message-ID: <9512e14b-9d5c-420f-aef2-30ee28c8f701@linaro.org>
Date: Thu, 1 May 2025 09:24:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/33] target/arm/ptw: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-32-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-32-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

