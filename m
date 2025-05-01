Return-Path: <kvm+bounces-45116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F20AA609E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 372821BC3217
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6341F3BB8;
	Thu,  1 May 2025 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RsCCTcKw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F713D984
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112764; cv=none; b=Nmn9km438uFp57rqp8M/ybk4MIUQ8n/HFJ55Lvj8QZ8QzXr0bmELhL0h2NmpW3usZXuwfKkWtmZ9tbCh+e9ssPGejfExIr/R2Jec8kTZOjlAosL6R1PPG+1aCBhYPzxuwJE8IVCd1aKpUTJQ4kNpglVQj12CgQy4UuU0G+3wZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112764; c=relaxed/simple;
	bh=U27HlA+Ch6t5FmNRy7j4s7WxfttgGvrE5g0uULrnybI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZUa0WR65Eb++z+5JRQig3xZ/RMWgKUPnFqtLVwZXorU4NV9ZAKIiAQIBpTtFK/N99x5SkWa9bivbtE+d+zkqDKy9Eb9nUOq29Wp/nkJ1TJWIekJn8zvCg1PaveEAzrpEczJL7qX1zvVpvwe4PnNMUNluMfY2kGpSK+eUd2xVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RsCCTcKw; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225477548e1so12017895ad.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112762; x=1746717562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQkfl6PWb1kXCkfaF29URjOl94N4FTQyK7ZQw8qsJ8s=;
        b=RsCCTcKwqczNgWnOCk71+9NZHW9I2krqNCdpSMv9jwu0qXwpSs9VX86+syh2ddOLbh
         Sj0xSZjyvZ2GyjTdKvvjdNVrxkgAtDJMAJ8/ePiMxNGop4ImDF5rLM+E0jjhhJS4zPB5
         uTFQweY8xn+R4b3ss/5mdBCHOg+ZE4dE3SeB00cbi8OjmKIJkTNeIy5WjEYdJ67heRdq
         5I7EHBOsCpomwVYAyxfMZCCmV7BSrpQ/CGSm87KvBPs05rwC7vAjanozRBXqm7BFQhZt
         NsXcoq3Gawlz2joIP0rTYrcYMWqCX+i5Kkm+/1Rd0MP779jm5xCAxovXAeaVwAAZJsB1
         N/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112762; x=1746717562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EQkfl6PWb1kXCkfaF29URjOl94N4FTQyK7ZQw8qsJ8s=;
        b=og1yssxhj9kfinCSbD7ssLM78IUM+U7+fVWqA/GjQcFR8psyfdqSPHLH/Rdlo7sV7o
         wfeVT/wypjPDgMl57uJB+fYOnsY7ZHhaK8irnVxD/zWBURvqHOn5tPr4n1ceai0kPjbI
         mXsolUyc65+9+c4fuVhbB5JwuReqpw8s1ySxI8Z0wP5GR66eQWgtuwFlrEVm0aRerX68
         TuZYRXaeu/sq8YwEtEqMwCtE454WjI1lbNJCoJcUOpnwXoFbBdIttULXQIGsgDr33WRd
         WTj6bx7YqRrb2Dm5b8P49xMsS5r4fCEgzAbzJvFQzcTIzvQhiLifDrg7z/oPB4qVMFRy
         5DVg==
X-Forwarded-Encrypted: i=1; AJvYcCVECmBgOKgr0E9XJ7kjOqMc7z9IAoYNXiCh1raQDg4X7wBFlVi+z3Hn8ZvGODHpTF9GLlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqiJL0FTrBWFA3A/egI6BUGXjM8DKl6H0ukw7XM6KOVEhd8ViL
	yvnY7vXMtNmpmPV1jdQT2z0147raGdPxfTzt0/ILTegpzDMjIpSwjc9aA6YsJSo=
X-Gm-Gg: ASbGncvC4vsxEBBRwxmWwL51EgzvmApp1T5Ta2fDBCTh2bLeBx+Y4tdAUSytaKqbPVM
	NcJ8mZyoCYcp5UPfh9gGmX+yI+Fg34YY4fZyidRo16e2Yox/F1gDO0D+LGqyQBRYxWBA7oEVTqt
	lGdAjxN2nKxTAuCEjqdhlzFMX7xefEdQ9QATUaH8H3IOJ7HEbLpruKh/Bn9Km/yYfLn9jDUMMDc
	ZgklWq5Ns5n2b+q0vtU9drTee65+LnKq7N+mMdORUmwdGwVMpQb/V/WSlpdmDTK4HpySZKvt3zN
	JI+iylrX473ZE4P7Y+gV2kynrz08+suUp1LZCXQVkjcunlGZwUfqfaVdYb6/Z4Lz+gVSf9mEZNj
	d3iNyBfA=
X-Google-Smtp-Source: AGHT+IHo1cQj3dctWO/PI4RDwJQxUMLzCGTpYaZ4IX9+6jZm2ktcxW6CnV9GH9l2Ufag+sg/SHlhbQ==
X-Received: by 2002:a17:903:3bc5:b0:224:1ec0:8a16 with SMTP id d9443c01a7336-22e08424e71mr45540075ad.21.1746112761851;
        Thu, 01 May 2025 08:19:21 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bc7bea4sm7798285ad.198.2025.05.01.08.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:19:21 -0700 (PDT)
Message-ID: <0ced131a-0072-4b15-890b-3dae3a1c37f1@linaro.org>
Date: Thu, 1 May 2025 08:19:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/33] target/arm/helper: remove remaining
 TARGET_AARCH64
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-23-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-23-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
> we can expose safely.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 8 --------
>   1 file changed, 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

