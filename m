Return-Path: <kvm+bounces-41708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E6DA6C206
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C60C7A3AAE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D085A22E405;
	Fri, 21 Mar 2025 18:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oDZnZl9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BA922D794
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580162; cv=none; b=Gmtp3kdYZm9pGPGbvsL8lONtsW2DtoS3yGdHYZCuIWbIXYAWr6r0aBAMIASvfN9oepGQbhHcaABfmMu+uSHJ2ekq9ZL1XRoynOEX9l2c78ODuoytLk45NBrhIubsNwslyFkqHyX8FM+f26PHnfewaqivZuqZ8R9Q69C6DS+ARvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580162; c=relaxed/simple;
	bh=MpihDolM29Wm/Xkd9ZeuV+6zjcnh5aInikUlanCGLyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=giBDgCYOszFV2xv77kzT4sMzV8bpkDC2RCf8UliNE6q3ZECTQspgr9lNOWCaYU/c4kRWgjSImovf4hRVG2Mr84XV+/hwv9uC3r5juw9UdPEH28vHu86xT3oDtWcgpH5V0V1HcZ32I7Fy3XFkW4xOA/5mZyCZFNRWdiLXRosymw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oDZnZl9o; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22435603572so44951925ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580160; x=1743184960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZQx1MYwR5XGQhoOob8K5fBrwsUBCr9fmoIlVhl+BMyI=;
        b=oDZnZl9ow8HJWlqPp2DoyrJ1ieRO82URugsJtop9sy3snPnZT8Ay9v57yoPXiL/ohe
         EQwebyN5oVzkRTZyslz+pIdBFbXzcConeSDMMwyt5F1olxlwttmoalhOdsWy8V2ymect
         k2ulADapOcqsJ6s3x+J7OqhxEgeE0zzdwOeo2OqDSH6zVuam5Ta9/jEH31mdAhYPvWyk
         k1TOMH+ZqthbcX6tGQGO8uy4QXyBv1U2ecdBrClKr+zQxQ2S9m8y4/nQ0N5AiFgYcUnI
         fO0bO+Yar9tD+fTgLeqcD+UBtHtOLoshre4LK3/VSH5LlkvY/T4NnNtunP/1MU7+U2eO
         5KWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580160; x=1743184960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQx1MYwR5XGQhoOob8K5fBrwsUBCr9fmoIlVhl+BMyI=;
        b=kSsnzvyg5/4ztlwVtJImI0tG0krg2gSXo0rVvIjh2NaOLDdlLR+qhz/gJ1RdqhZUbp
         uqGSqPQgwTbxWEsqBQo3LXeITw1uV5Eq4dK1y1b+cBIRMBrwo+L4ow/8lzfBFroZWnoI
         N79MPrmOzCIP9HJNdWmCbpIvn3Qaq3zlsWfzNNwOIyG6BbRC9EjwxODyhl2kChU+EiLW
         WJ6AvmLRYCo0kkyCJLjaOa2RMIJUXueoSMRI8BPdG6xgbuGsfpMVt/GoJVlCTW9iAiEb
         LVIky5jjy5FynmgC2zfW9eFKRfowa1K2KervHf3Nsn9ZUh7qbI3nVmBz6R/wOtZ0Ywp2
         UDLw==
X-Gm-Message-State: AOJu0YwM+oSIIE2Iu53Ti7bJGh2Fg+ziFtW32VUlA0XL6OP416HBJ8mS
	2PYCiEdpHUkpo96/YkmyFR9EE7oe8zmUP+y7OYIupJUHa85AHqXaDPix1Viiuz8=
X-Gm-Gg: ASbGnctXwVgjuSnuIAxTbbMW5QxfXSXdDJe6YbMgI2QyvbHkILzp5NeDxZjqlwvgmcv
	MfZ8G4sIIjfdwSWes+92+sRaJxrnZl5MiDvPAemZYsotSL3Z/ZZL8v4U79JryE6hvunBenY79uG
	E7CA5f5xCT2digPGaTzrD3NiEIvkpDuxe2mr6PBxJRKUi5Z4iD3BzLGc5ZQKCRwdmPOstctcQjT
	/gNnN9n+VaG3y2ZUiYvrrbXq1k64cB3u1BIdSMn67ZAylLxfwZN9lmb35CRNSpO/41ZIEtB/afr
	LmhfDMsk7chuokzIjT/4JNhoI7ziHutcD8R1kwnpgpq6fH02hmqq227abJPYavP9QgpsW1HoZfB
	EzSpcRWLk
X-Google-Smtp-Source: AGHT+IHeHBnqsyQDfPVC5c6M9WveDyjBqtnNjS+sN49PBUiT/Etyamb3XA0J7Wn3GsZAAWnCbxJzNw==
X-Received: by 2002:a17:903:228c:b0:224:1ec0:8a16 with SMTP id d9443c01a7336-22780d81298mr74015835ad.21.1742580159551;
        Fri, 21 Mar 2025 11:02:39 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811da561sm20161365ad.185.2025.03.21.11.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:02:39 -0700 (PDT)
Message-ID: <5d76ef18-f284-443c-b7ec-468246fd2a79@linaro.org>
Date: Fri, 21 Mar 2025 11:02:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/30] exec/cpu-all: remove cpu include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-15-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Now we made sure important defines are included using their direct
> path, we can remove cpu.h from cpu-all.h.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 2 --
>   accel/tcg/cpu-exec.c   | 1 +
>   2 files changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

