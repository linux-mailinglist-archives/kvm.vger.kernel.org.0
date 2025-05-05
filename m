Return-Path: <kvm+bounces-45439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA65AA9B4A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38C1D1894236
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF3217333F;
	Mon,  5 May 2025 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrLOvoAc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985B9191
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746468937; cv=none; b=ikoXmEVen33zlTt/YbOYoLQioyK0x4VuHsSELZP8+NxyMUStAYo5fDvuymFfttj6AXQDeAcLwAN6FQeV68CTLqgEhfIY1tSE1SjNgP5pUmuEZoiwtJxku2bPP5RiNqoCK1hAPtfLs7TxgExN3bKyCMUHvbmfvH1PIY5LscKAgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746468937; c=relaxed/simple;
	bh=OvGbfICWrT6JYdA+ZOZrfG0aA6oVAPadzk55vl9nrdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VNY4l3az5WIvRqKd+nSJxPMi1kjncwiLRtQptu8u2sV2UDJ1GRgKsL02vFpa7GkrSzR9GbiDDe+leu8PBPsSGovO9jz9tdfQbe9bmfB8hnrGqNnULs1naxGduPFz8rv+7gP2S7vX2m81A8J2u/Pb2FyXQVKlWRnvwWKKArYWO7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UrLOvoAc; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223fb0f619dso56775435ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746468935; x=1747073735; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kd6gV1USLNd4p4PNo72gWbrU36bQLzdDoB4a27U1rFM=;
        b=UrLOvoAc2oU1hKolkJywR9xgNRdij6VsxTJYrVSfhrh5K0xCJsQgp0wmHzGEJ0E+dO
         3M8s1QO/PzjwOEBWqGqpsUIUo74c5jfKDtHMB2F65fb87+qQsf8s7e/xBD62QG0Tv0ql
         Yzzt69QpmkVkMCQWnBo3mtyp2hMLGIlWmEjn3YaV4JenNXM7qznu3dzpstoRwsllua4Y
         WWLqfppEPKlWqr60ZuNwRMnT+oKsRHjHEaY5gvQNBYRrJMYkcRQkqq3HG2P1zVFkn3jH
         ahJbL9O2RQ6FnY74XryDAk/m0TkYjYKJOC19z3ytQ/BqECZsb0be1JI8qu5vFbc6Y8j8
         hV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746468935; x=1747073735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kd6gV1USLNd4p4PNo72gWbrU36bQLzdDoB4a27U1rFM=;
        b=MxHz8mW69pEgu+8tFjMZujl4+Rza+cqCHAWmZfj7+9DFRlGRQnK5/9F9ubZHT+QfUn
         In8hD3XnFGIbe18jqeLgfZJryxRm4GSFsz7pDpkKzUkpXz+2+bkKHL5tqZmUx3QwP9wK
         4EFPr9tlwt/WU6d0haL0op+XWLKdSh2W3X1WZrKDE7SLbLD2HVuuHs4yAauEr2Os34cj
         e7hgPuMLSW5wJxCDMdCkmDHUdXviIU/EdzlDzHWbhP474rFTR24CBB1mSrz6kLMY278R
         SzA7Q2QKAmziguq2js11UIHNwF7yRyLLj7y/18IZNsgi4++8z4irKp04LMvbCGZZVmqb
         guMA==
X-Forwarded-Encrypted: i=1; AJvYcCURtA8CMh0322ipEmCxN007+CKJhx3ZVaPUjEwRcFBFXogLGjFHxsVH3i2wQJPwSKod3aM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKrKUDF0g/4MaS+z0Ub4VTwHm4v3Jc+JtBZqt0yHiGllQKDmX8
	+GPWzQn5w8hFrHh0JCN/dm/MIxrPF6XbYbcNexedrVRB9K6fj0pN4vI6DD2Lin8=
X-Gm-Gg: ASbGncuBTLuh8lUAjayyhODqZMmrm4em2V67uJwqsYBtFbslqnFuUUPEIUzBCE8mX8G
	Kyw5yju/N2bSusClFtjtWS+198Te6uo+ciD3Eh39agwQjLVhjw6l3unF8MLqPdlYdabErdxb6ty
	cbRqxjgrkIK7tJAuuuF+gPPNMjn3tKoLYaQszz11kQcv7GCq342eRv+7ojGJ7k4osC99KNJR9Y4
	Bflo2Y8D0YjI39gnM87Lo2QcG0n7e2Bfc0gk3KUK3z4z7h+baD/W+92EgAqq8b7HIVwGiJOwfKQ
	g8a47+ErO6p03UZnuplkxw/lAf4PrDm+8y5bmSBxexNRwjpOcCb+MrY0AxHgYYettCVJPs1CCTD
	tVuCiyc8=
X-Google-Smtp-Source: AGHT+IF+qPu0gNAX9hw7En2FMcjF10KlwzTyrbe0+ojnqQ3d4oNSY3U0Ki9IYrYge5zoB6d1Kdp4xg==
X-Received: by 2002:a17:902:e84b:b0:224:18b0:86a0 with SMTP id d9443c01a7336-22e10355d3amr212805815ad.37.1746468934882;
        Mon, 05 May 2025 11:15:34 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e150eae07sm58227335ad.8.2025.05.05.11.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:15:34 -0700 (PDT)
Message-ID: <87cb4a90-25d4-40c5-b8ae-ca8cf9080d5e@linaro.org>
Date: Mon, 5 May 2025 11:15:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/48] tcg: add vaddr type for helpers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-15-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:51, Pierrick Bouvier wrote:
> Defined as an alias of i32/i64 depending on host pointer size.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/tcg/tcg-op-common.h    |  1 +
>   include/tcg/tcg.h              | 14 ++++++++++++++
>   include/exec/helper-head.h.inc | 11 +++++++++++
>   tcg/tcg.c                      |  5 +++++
>   4 files changed, 31 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

