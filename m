Return-Path: <kvm+bounces-45434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BABAA99E2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B3433AF469
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 16:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925CC26A0E2;
	Mon,  5 May 2025 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RYkpHmYq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379A31D63C7
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746464353; cv=none; b=OPr8MrLtwgItKeWUAoECkEVzVhD3VsTh93HVp3/abOAd+udIQ53YbxUZF3elmiIoSx6cZVUXqk6cA++CAA+ymNeDaB6IiMjujRYO8Lmgk1GQUvF40J+tYyYjTqtVYTiiCXo5dvQHnrIsetZkpr8+Vu5MIB8KbqR0pP9Eh3xF16A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746464353; c=relaxed/simple;
	bh=E/fzt4HDxFu9wAqM96SCl9l28+g7UMWMNIp8fb3Ac+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXJyuRI3JLly+6VX6VmUy+o6nxJ6C675Ta3oS3J6Y+/frjMBaL0wIgO+0Tj7KjjqUGwb32ZJ8MDiflaEIQ6Cq75Os88TehMtK4NGPy8tOy7pf46Aka4avSE382Fr3mzhDRrMtqdRBxuuFsuCuc72obVELmXGYiEAk/WScNoZn+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RYkpHmYq; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-227c7e57da2so42767025ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 09:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746464351; x=1747069151; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U9OTFqGp8mCWvlRmY2T5kbkW+mv+S6TaxK3o9YJyPUs=;
        b=RYkpHmYq5E0Htx1HauBrDjvqOofkuiRWTVz25iBUAOX8zgnFminl3h40yXZwglpwE0
         LHxpiakLthLddOqnCSjEo7J+MkXdckHVSYmaURhXocxHcMtCpHslJkLLNkWVAGWulmVE
         zP/O5/H9bn4jeAH0Id9lPjFCEpuU/njQboJ0JWupxOwDh5gQGzmQh8RZzUX6l92rNpmN
         DdA1FUmJWPAQ7ttzotvjifOC4p00Xo278WCHDf79SvROpguzkiGS/tBuCFM+djUNqfww
         DKOoorA6P06NHWeVWvmBtT/fnw5H2t/6KiwLcq929IaStTXm2U3y3SL9KL8wgx6baM6n
         vSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746464351; x=1747069151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U9OTFqGp8mCWvlRmY2T5kbkW+mv+S6TaxK3o9YJyPUs=;
        b=d/c54z8d44aGkYs/H6rjx4xBJHhf0+KBDM6As4Pw8xNlaGAXpWJdpUCwgNVbyXs/1e
         tcjA4eeMmhnJvsNgFx51VMsHUNehuYN+qVT9ZTReWdII4YJyjowc67hrUhsC05qPFldF
         xjLzVLfM5n4bxb6CTGtQcARbsPbEUCIccdNrZJVAY+Ulgks3TRvYx9oMnmUG6ST+LwHA
         xbwsI+mITdeQQvxFYEvc7a30UMCVNK/TAxeV+fffv89SjYCKuDemEI40KnDicZxVRvKp
         Yzy38cnywC//OjqNQR+M/Cnp8+t561LPl4Yv+m6lodu7tANquhUWxV8izkLWluhiM3o5
         MFjA==
X-Forwarded-Encrypted: i=1; AJvYcCWg6aPeBzw5IQmNwlf8ltTf2iBjQNwL6Jhgbu5cu2k5n2lRZz44H0Oh4IMWJ3TyERaBvpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkQGcrUx92UX/jzd74/nN8emDkdpvezeGF4Ez64XkYaoIsL4CK
	NRHEyYNn8F8N2wUzxU06FwSJpeCnADGWTN0TeAVeznGN32kw1dctLB/fuwixw38=
X-Gm-Gg: ASbGncvlPyWkP3FmvUkpF1niQ8dTkZTQogJrT5tuDuGrs6AieVDxvb1Jvm3VtLFEB6S
	dlfBf/4mP96qhMCPa1Leb02Rie0eVWERSkq0llXh0TAW1iG3D1NP9SaC3prmbzIRkiqxVCRl8ZN
	BA3f9L04Bf1c9m/iZX0IaTDWkipuxmIrUsgfjXXxDedMV0ol0dVkPwNXn8BXy1ATFWB3Jl/IOBN
	jdoHC0fdiilU3bpwvD9+RFm7gu5eQjAOiYdwefL1YGzCqW02hgrEWkgfQ0iyo4gSmVEwmGD064E
	WfiSEIEfX/pDINqn3WTftkHf6R1+MQxTFReqp2blCFXrcLVK7GCq+7lViFok8B7AnRem9cp57Fj
	tMSDWmEY=
X-Google-Smtp-Source: AGHT+IGV4mvjBxjuUac2hqTkiakJrNcMLiL/yCT2vwZCoMaGvyR+N0l58cjWbCbjip6vwNGvfemS6A==
X-Received: by 2002:a17:90b:520a:b0:301:1d03:93cd with SMTP id 98e67ed59e1d1-30a7c0cb75bmr202365a91.24.1746464351450;
        Mon, 05 May 2025 09:59:11 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34748935sm11971734a91.13.2025.05.05.09.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:59:11 -0700 (PDT)
Message-ID: <857f0b9f-e58b-48a1-87af-49c3c52b379a@linaro.org>
Date: Mon, 5 May 2025 09:59:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/48] meson: apply target config for picking files
 from libsystem and libuser
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:51, Pierrick Bouvier wrote:
> semihosting code needs to be included only if CONFIG_SEMIHOSTING is set.
> However, this is a target configuration, so we need to apply it to the
> libsystem libuser source sets.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   meson.build | 26 ++++++++++++++------------
>   1 file changed, 14 insertions(+), 12 deletions(-)

Acked-by: Richard Henderson <richard.henderson@linaro.org>

I'm not quite sure how this is supposed to work.  It appears this compiles everything in 
libsystem_ss, and then later selects whether the individual objects should be included in 
the link.  This is fine for internal CONFIG like SEMIHOSTING, but won't be fine for a 
CONFIG that implies external dependencies like VNC.

I guess we can think about externals later, if it becomes an issue.


r~


