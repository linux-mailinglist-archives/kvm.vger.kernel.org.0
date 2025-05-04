Return-Path: <kvm+bounces-45340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A28ADAA87F0
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D4663A3731
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C9F8F7D;
	Sun,  4 May 2025 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n/J5+PcQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976A3F9DA
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375514; cv=none; b=tumN2guI+kxTeW7w/cjrbmluIgGjyVr7F8UfxemYa0Uz/8wOIe6vY0jzhZ4YJoPWU5vEjADgAE4FQ8zazMWSWQtUgz6WIORYu0JNd63JPcIAEXQkIP1Atk+rSU6sUO+9Kv6DkQPSgxSiNc+65bCwGaKwMiHAxzcXyDZlvao0Qkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375514; c=relaxed/simple;
	bh=oWSW/cdfbRhnkZa/hauO2Aga5G0yUdHThkf7sPL0Hmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X5JUCEPyzH5TeHilTg3elZLqP1sjRF3AsTQcDkf9w5fifRehLlc7EROQeJYfvm2o3jlYcGbXeGqcURQY+3wHXwY/Hv2u4I7pxcpE0JhqIRyKtV6zL7xyVghNkmZd3aNeAWxLmWfqffwCDGSdftGDm6r6XaKdpT1EGoPR4DevSm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n/J5+PcQ; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b0db0b6a677so3612963a12.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375512; x=1746980312; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVgHVjCZAzrnk6Yz+gPuLZDT9JxPN58KFxsJBrzHsuY=;
        b=n/J5+PcQAe0ohNuuVHd38AvK6wbpGZXyjobm4iu3PyK6ZGkwVygXVlQLAdo1zeeBeh
         Jb3+VcC7v1qb6Oy+lw1pJbQUQiwmQhFtClcevua7Mt+Iq1oGNerMVmwECBtKYhNkofdo
         Jklw3wlBMymLtiAESqE9yrCIT8ltfFfSznUAc5mZEKpmfn5UDxZ3au1Vgcox12SYnHtt
         WC5daeb0W2JEbjGaG6xweN+LhBOK4LzlzJMUFWkDflM0UQNGws/MmBV8m7+vhwoPNpsc
         0DO1muztF0zzxXRSlWFUfKlbm0kkBT2RryxJKzbSARNJhdyVcqx7lDjw6+nF5UqgftsU
         a5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375512; x=1746980312;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVgHVjCZAzrnk6Yz+gPuLZDT9JxPN58KFxsJBrzHsuY=;
        b=Eh/tfb1yZVRATYPCiokmDM/Ubih/Lbz6EcB39SeTH1KPB6XSiSez4Q6gq6a9jgGpOz
         mYoX0qkdNHnLapVTthnsAC12+xqkICxTFTfjsnNv4s3nn4R+lM1Si/0qN9lRRnzeoc87
         LlDvptxEo2neASzhN21/gku25iDKNN9HTDwzTWdb87cUE7Qdjp467NfVskHq8HrEJtay
         MNq0iMgggXE/S4+Mj/q5lF88AkZOPqfqb34zhxDRHSLSUBiJbvaR+GXTSueLFDXew4Ag
         zZU0DLbcUlJ9HJ09uULwL1FnyYiUHl1HlMo1F2TZImAZyIksQ26fiUCSgbP1HXL9YvPT
         XPDg==
X-Forwarded-Encrypted: i=1; AJvYcCXZdx3DWW9k9znw31iRDcGcYmtQwpn6FOgmn9xkDn8hF2Um40scDguqrJ/e2T4rsqg9C2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YydVyyFeff2++n5Jaxr1v+hPVULvzqvw/1QvJ9AZk9XNEUUvB1U
	m11fBe4vkcpE6O9qhMrntATJzW7Fj7I5eSxjADhh2sN8m05GF9uyFDOX/TtlaBt5poi8SxihFim
	3
X-Gm-Gg: ASbGncuJRXud7nCKrZhS90s652IS7pZKlPuxzDeqt9Itv+xAifAFC2PJPW7er2KzY1+
	8CpwRKlafS3lMZfPnyebyot74znyZFQAQ0O82373aBgJWVkOIe9S4XfSf9vyAJzscmN6w1hi5iR
	cyQnKC5Ycq6zz+6wJ3g6Gj0rS85xjYYjoAi2mGUUYqcnwYGiDjDNQ9xJ5AsEQq7wkEfD8fEK2OF
	d3Ufc9rjvZP7JvrkFtPitBSxlrvaO3iBzr/B03+VfwnbuwDDlAYoBkrm1W4aunHRl8irH5NJYOJ
	diLTK9JU9HTpHKSIzi6vtBQ3zKZCnZpxPgwpXOpNNxUR4ZKFgMd9krxypgqCYhNAllnlvFGGFh2
	V0Y+qq1w=
X-Google-Smtp-Source: AGHT+IFDVehLEijp7OUzeIAXqkg+5iC8+kDb1Uvyac3I7ayEa8psrutgXlbFuIS85v5QsmgH3zDmYw==
X-Received: by 2002:a17:90b:3d45:b0:305:5f33:980f with SMTP id 98e67ed59e1d1-30a5aeb69f2mr9376272a91.27.1746375511926;
        Sun, 04 May 2025 09:18:31 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a263f4324sm7897339a91.1.2025.05.04.09.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:18:31 -0700 (PDT)
Message-ID: <a50b2d4e-011d-447a-ad15-6165598a865f@linaro.org>
Date: Sun, 4 May 2025 09:18:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 32/40] target/arm/ptw: replace TARGET_AARCH64 by
 CONFIG_ATOMIC64 from arm_casq_ptw
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-33-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-33-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:29, Pierrick Bouvier wrote:
> This function needs 64 bit compare exchange, so we hide implementation
> for hosts not supporting it (some 32 bit target, which don't run 64 bit
> guests anyway).
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/ptw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index 424d1b54275..f3e5226bac5 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>                                uint64_t new_val, S1Translate *ptw,
>                                ARMMMUFaultInfo *fi)
>   {
> -#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
> +#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
>       uint64_t cur_val;
>       void *host = ptw->out_host;
>   

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

