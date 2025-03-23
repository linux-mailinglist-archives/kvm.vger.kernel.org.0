Return-Path: <kvm+bounces-41767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70650A6D0C3
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 616443AF6B2
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAFE19E83E;
	Sun, 23 Mar 2025 19:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mNtEOJJb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67EFEAF1
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742758093; cv=none; b=ZYX1X8PwQc0QvOIF5Wd9XadnzV6ivmiMDL/kpiPQp2xWjiIHtUOh9D0mbHN5HRxbGEPYrChU6T8+h0LrrkHwIm1XrmeK2DsRNyL8SgUXwS5kO1Gtls8wVy04GPMW6aD8Gh/fJ0eX0tSU2xIpy42B9TQ4Liz6JF6n3hwgCnQhIVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742758093; c=relaxed/simple;
	bh=MDGBo8e/CR1U6v9DYJ5DQbxukSQByTGJw+eGZmBX+X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdS5iaXRkAzICDOUmbcWnJ707bwkNGsOFAO6dcM7aOFLssiSTGozHNoVyNaTTUKlgty8iau2f/2VA+YXRhbi7J7v1nvfb8vXTNGBqtvuLXgQENw94milOATNXFaoN5eMyhe7q2LII5OYflCaT1r0TvdbMURoI8ohnsazzCaHug0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mNtEOJJb; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22423adf751so66163285ad.2
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742758090; x=1743362890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k874A7awCV0W2Ydj0mIjddbFKT8kiobQ9PZe2gafaio=;
        b=mNtEOJJbcTIZgB228Uuw/um9e3qDcbqK0PBRCDFvkEud82IJu2XsbElBxI8Q5Wpgpy
         EnWVY7hTfbm95xJRsREq3bK9/dlqqp1+2XGbwBf52AKRLF/QsqzVIuDk6VOHFiRnSWxo
         4LAUe7H1fXW4JyCQAF0IU/aIAna31+L9TyORernEkqgSupp17A1sgrocQsk3r6h3ZVXY
         C9YXzuFpJY3dPRLiAtDl35BAjaGbNmNw9Vv+M0eDmwR/c6qloF9Tkp26zl2BM4FJKFWw
         yyeT8NFEgoUnOldNwHf0UR2XaPbTRkmBiixm1oWDmrLb32cQycH4oofM20iFpEgTSXYQ
         FlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742758090; x=1743362890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k874A7awCV0W2Ydj0mIjddbFKT8kiobQ9PZe2gafaio=;
        b=lOB+y5xH2ltZwKEHgzz8yYAe4vVVLRrrczkXeiHbxyU70LsV4flY7Fd6uj8gIj46FR
         gmDsBif+lN6f27yXA9l13KRmMJLpo58vm/jQumlpC8B5cJ464MQJjY9ndVOELHlXJ67s
         +I8Sk23j4iMs5zR9pqOLKDngP9uYTa3wX6mkU73iPhH1bnezdkfIA83LibQ+eJG6rQen
         XbOYLI1YV5b0MUuiIZZN3USG19oDbLLwxn9uZTEsXpZfv2l7PavRpunllbnXAWTKS9/z
         MQuDZvGo5hiKhLqKg/i8grGdAZU4xZvyEdG/AcBJAT1tD8H7bKmxqL1YDrErjpPCN8l6
         dTzQ==
X-Gm-Message-State: AOJu0YzME/r7TWWbQ+iaWf8ueGJqStNXe1/QWWvB37ESef+qye+KD/z4
	KfL9e/NT1QfLM/vF6R8uYK8x4QKP0TrBpZocDkTpuSznYs0SYxnyMI5AR5JjSYM=
X-Gm-Gg: ASbGncvDFwKIHYIj2y09yOFLCfopmLi5Ea7qi4TMBEMN3hnS3sKzvymBZnqH+95vmr5
	Xrq91nYiKgICBGksk807m89lTERCHyPaWjHF6v6aJDDW6FEwJPwbPVwocpGPOxCM8BZA3m0lpl9
	ZYZ/WxG8H46cxGwbpZRBLS35KcqJ0LJQgjTD6V4tR64j9gAjcByjPb5HokcGPKFXNylLN8PvFQJ
	aSIAeshacwolSjQIn1ydlRjHnMkn7tDgfVHnD8J6GMQx+0NXarRuw/XzZb+z1y1zDLUhqlWL/AB
	iGjQnGjr555d5PPNNpplk+dbKqximDwXb3UIjSnOwudUBqpsUjNC8aZwi7BvH8DSy7dm5Lc/qVU
	xNzf7ChFp
X-Google-Smtp-Source: AGHT+IGcnxhYb5NggH77kYiJNWz2MXC3uuzdnoOzrp4gOG0fkOpqkEDKVm3D3Tgc9B5jqbrgiwVAbQ==
X-Received: by 2002:a17:90b:2647:b0:2f7:7680:51a6 with SMTP id 98e67ed59e1d1-3030fe6a058mr13981930a91.6.1742758090161;
        Sun, 23 Mar 2025 12:28:10 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf64aca3sm10427246a91.49.2025.03.23.12.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:28:09 -0700 (PDT)
Message-ID: <7296aa89-95d2-449c-b2ae-a9281d760fde@linaro.org>
Date: Sun, 23 Mar 2025 12:28:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/30] exec/cpu-all: extract tlb flags defines to
 exec/tlb-flags.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h               | 63 --------------------
>   include/exec/tlb-flags.h             | 87 ++++++++++++++++++++++++++++
>   accel/tcg/cputlb.c                   |  1 +
>   accel/tcg/user-exec.c                |  1 +
>   semihosting/uaccess.c                |  1 +
>   target/arm/ptw.c                     |  1 +
>   target/arm/tcg/helper-a64.c          |  1 +
>   target/arm/tcg/mte_helper.c          |  1 +
>   target/arm/tcg/sve_helper.c          |  1 +
>   target/i386/tcg/system/excp_helper.c |  1 +
>   target/riscv/op_helper.c             |  1 +
>   target/riscv/vector_helper.c         |  1 +
>   target/s390x/tcg/mem_helper.c        |  1 +
>   target/sparc/mmu_helper.c            |  1 +
>   14 files changed, 99 insertions(+), 63 deletions(-)
>   create mode 100644 include/exec/tlb-flags.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

