Return-Path: <kvm+bounces-45113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12783AA6090
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C88371BC1B99
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137CA1E2852;
	Thu,  1 May 2025 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iTkXAK7E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CEE2F37
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112531; cv=none; b=rw2hmGOrbQb3qCodhqoePPdVlF/nfFKOgKb3cU6ZmfICAsxvfb9w5yTWpLkTeL6pnU0qdCruXTqgW7eTjeiZ2p4QF0ILzCP6H35dKpA8cYPomP2AYhUlGNjoJwFXncKnG343vmi5Qdagp58Y/q2m3IMeNkw6Aibh3LxBCYyp4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112531; c=relaxed/simple;
	bh=QmQ06Sha+5LLO2Fg4ghaaUr7h7LDqpve3uQ6HUCrcMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tz1sX/PX51+rRsqP0SYkXnqmrVvgxcQin1s6+y/6/mEwR8I2U4Q6CjCqUBKPObMBqbILihdJRp5n+m2zh4IX0+lZa3NChtQaTYFN6jBsao9tHghIm8yMkvfQX6V3goLQoR/AzJgx+1dCqL9ZMxebhR3HM5k0tmD0R9jb6FOLPFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iTkXAK7E; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2243803b776so18470375ad.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112529; x=1746717329; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FF3pddHEwUgaH/9RTqdn87i5S0KIL/aYEK/4foUzVjo=;
        b=iTkXAK7EoNKee7ZNsnuTO8KWNbs/XQKLCKWFigL7CgPd/Y76j9hol+4udoChvGFj6p
         mtdXqm0+JyqHg2mcUZMosDhbbwvbtgUhDF/P7I4UpemRf0kA9Da0zimorebDMFySPq8C
         jMkBb7/XKqvm53WELuvjjfdW4NU+5Avxu21J7PXL5QAWxW/X6+Fuj387Kjmv//oGt4hk
         iAYeDMt4Y0tVuKHACavTyhaxs/OrZ4ebcCq06cxNEgFuSbj4p50CM+8mcHpiOidKsnza
         pPOwmSFekgWz6enxUPEOFOmEq1S451IKz7QdlZRoV9S1dfn/csjGAi9pcTULFyuXA1i+
         1MPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112529; x=1746717329;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FF3pddHEwUgaH/9RTqdn87i5S0KIL/aYEK/4foUzVjo=;
        b=sDo13HRBoJoXTGqoBiZVF7ldBFyaSgp5a1w6jBJByiIgpjRBxJVCMTNf967O2Q87dn
         UT7ldjc+d6OnWmtgepEWFLbZbFHdr2ypm62AE89hnWVZ7F/TlJRztRehJ+fgp8I006Sk
         E/+jptaCjNXv/JnB7YEmnfOhn0LbQGFxRqO5SUTNRkVqK+J0X9PphVTHUdJsML6Q0cpm
         1zbe/BFJoUeIEVGFUBKl3EYHB3PXVZ14zULq44fUFY0cxtJqe/Q/d8SRogq+i/eua40B
         NQayoBlpNt7WNe+jGqr7KLYrfI0iuabsARJ0nsSptAWqDPKXeQkQPHzmlGWTiCaDjEBD
         sydA==
X-Forwarded-Encrypted: i=1; AJvYcCXGyc8SVKZFdmjQjGHWg42ScgpRgTbD6FqvGj5BuGpLWObzTnwqKNZOPvy18CknNQrhaws=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPnq+VwazV+Ul/xYMmGdBFQH9gpXwjCrhneJvGxRAr+9FXSAyt
	O7hPeOciVcSzPvVJqnsWd2gzjhnqhphPkW4lY2pCO6L4OG6oFOscZrweWyIwY+A=
X-Gm-Gg: ASbGncuzhw9CQG0ZXOuE9QW4acjwWxCiwg3yjWHG5rlWKHBziPkSMojLLU2Hb4v7uqd
	BvyB8Ra7qOiPxweTEeENz94hMmM1238b4h/A0rNMKWLd7wTqiALjpyHT88rZXszYx+lIJ8RHenx
	SkpX0J+h3rP/NUOlQdeEp5WqSmYXiX/hi2GC6JKcUgfasa0TtAhTiqmwaeHZeLnzT6b4AGaSifH
	IYhRPs8PYKF4MxM/DMspNFn5y7yeGvWaCbwS+B7zw05EMNWZBawZ1NTFrPn1nOy/hcO2nReclwx
	+fohBvPcr66+hR/lWyZApciFsvtJ+DB+6dY3ypRJsh+bsiCejKL2G+Zn2tawfoPMeCHPLVGMEfL
	CLsZq+DE=
X-Google-Smtp-Source: AGHT+IHmyRr7z6sPij1th8t08gn508e/IEYOVboajUzflb5IvUbXe1xABl2MLT26AzlI/t3uR/F3TA==
X-Received: by 2002:a17:903:4407:b0:224:8bf:6d81 with SMTP id d9443c01a7336-22e04127919mr60789965ad.46.1746112529060;
        Thu, 01 May 2025 08:15:29 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1f9d4edc4esm731664a12.39.2025.05.01.08.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:15:28 -0700 (PDT)
Message-ID: <0762481e-878d-46dd-9964-666c115ca692@linaro.org>
Date: Thu, 1 May 2025 08:15:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/33] target/arm/helper: restrict include to common
 helpers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-20-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-20-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 257b1ba5270..085c1656027 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -12,7 +12,6 @@
>   #include "cpu.h"
>   #include "internals.h"
>   #include "cpu-features.h"
> -#include "exec/helper-proto.h"
>   #include "exec/page-protection.h"
>   #include "exec/mmap-lock.h"
>   #include "qemu/main-loop.h"
> @@ -36,6 +35,9 @@
>   #include "target/arm/gtimer.h"
>   #include "qemu/plugin.h"
>   
> +#define HELPER_H "tcg/helper.h"
> +#include "exec/helper-proto.h.inc"
> +
>   #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
>   
>   static void switch_mode(CPUARMState *env, int mode);

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

