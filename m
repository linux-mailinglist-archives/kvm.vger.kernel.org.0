Return-Path: <kvm+bounces-41770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6E3A6D0D2
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F014C1893A9D
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B69BB19D093;
	Sun, 23 Mar 2025 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BCaK9zEQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73549136E
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742758626; cv=none; b=Ngv8KjynXpl/hl3m8uZSHA1J5i0tB9zU36sFGA7YH1hLiDnM4v/ph+YaI+BsaufEsE50ocZNBgS5xaA0g5DB5uDIGCWMp/Zxj29FR+d4Tqm5dGLK6cqGrisM4cDzCCAXed67iqd8RzkFzoiA1Tv7RJFx9EPebl5j2lvN78Lug4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742758626; c=relaxed/simple;
	bh=4+HxCzSSI7iAzuG24sYlkWHXZLyg/rI46yYC248xTfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O+yWZD74nty0QxrXHUhcLIzidfmuFTswd0boeq34oU6Ef2UXKxR68uh1tjeDS+8Z1wu7MGPpQ22WbqH6eSrYOqngkA4hvjwSjr4iXgsXyLFtPG4UWAevigelcjhg+9uUyutcq+YE0S0TNP4xUPLM+mALVWXFGY1G9mCvAzHCB48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BCaK9zEQ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2239c066347so80485955ad.2
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742758625; x=1743363425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aFsN9QNVIUdgmic/nMHOU/vMi+SnWp1uZJldFQD5uko=;
        b=BCaK9zEQcPjTPzylFhlntp469Pg4+WVhK2MCPCfZ1T3/Iz0ZaSjxWuHw84ghhXD31Q
         SzzHatXq1wHwl0/vNKtvPo0As7fWPlVdtX7WAE8jSHiV85H+QTLembcqJUfaBO30SnHB
         Kt1Msh+FRSWS3Ql6NdWUeOCFAL5PleF0lX2r12vEEliMmS/7hm2asDhE8EXNYkWuIbXz
         PNSoobll4s9XEcBeqf8JopzM0bxOl5HKyQSLi50fxwEWcq6temKGsKJ5yZvnhA7hBSzz
         bPfzLflSD/oNAzsI6gSehXCNhKZaBhGNCtHd3/3bb+p1iIthjUHPhLKBtLETK2sBf8dC
         9RAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742758625; x=1743363425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aFsN9QNVIUdgmic/nMHOU/vMi+SnWp1uZJldFQD5uko=;
        b=lOQvcylHZjjXvihOBO7yeBy1fx2TYKGE/4+ydR5rfIOVh+HarKzV+uuTWmn3ISn4ln
         l/dzHWW73FvIPgzCLT+bYfIoy3r4CP7djLmTbTMN9UqSrubeEsltxSbI1gCGw04bixWQ
         Z9El5X+M9r+EMsq9IU7Mx/5FuYcfZk7RIuAxhmLchHwbvtDqjgJyqviWSyTJzu7r9vom
         404i4LwA7d1PgnSH7X4irjU1mbPR83ZWpvYV2aiAPXA06WzFHtWjPteGRHSf2hveLwcA
         98B/CDkhY3BnOS5f/Tyubbz7uN2wlqvj3c7dG5tnCkmnQsq953v/Lu5CfwcmsjmLufIU
         Nb3g==
X-Gm-Message-State: AOJu0YxTc+KNpRdAmRTPKioQ3V+9FoIHmsgwUYYPhPdv56d81+jBRX0B
	ztslgCILcMw50mwJH6WINizgO4VNmgpbaV7J5Lgo4jCfcoo8SPaFOlFVuhH7be4=
X-Gm-Gg: ASbGncuKJuaNmLqNava65NfSVvp6di8j/BiXb4IXc1BKo1wMzt+WEqhDYzllgLwlaca
	IDe7KLEzhedQ9yGokOiI+CKA6k2Q/4OJICpsY9I1kYm7bAfA84SR/Khv23kraSVhnn2LksKEErG
	QJBIiTlnU5JGJ0ve43tiAtyiqM6zchgEPKX82X8Kp0HZk/7ud3u0D/j0mLqAKGmKJUVUQSf4mbn
	i0Ti90qTioQsRc2iQNDd1I3u7GsObNfAwKhMePPUCwFYnN5z8QfRmiciqO064Fzo7J8AJxPcyAb
	KOpdhXUUM3OqaUDy3bV2Tu//i2POhUjkOvt/86RBrXVlavCmanzPlLxmukF0J5L0aIpwWt0D843
	Xtn7d6h2x
X-Google-Smtp-Source: AGHT+IEfZzNzGR8ATTRp9XvwUOJ9Ba9h+/FFFjlbnr+Q3InyZSRXbyWWEYoY1KpvywdGICttkrg2Mg==
X-Received: by 2002:a05:6a20:9f90:b0:1f5:8cc8:9cbe with SMTP id adf61e73a8af0-1fe42f311bfmr15412277637.5.1742758624686;
        Sun, 23 Mar 2025 12:37:04 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a28001efsm5587748a12.22.2025.03.23.12.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:37:04 -0700 (PDT)
Message-ID: <1109fe22-9008-47c6-b14d-7323f9888822@linaro.org>
Date: Sun, 23 Mar 2025 12:37:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/30] target/arm/cpu: always define kvm related
 registers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> This does not hurt, even if they are not used.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index a8a1a8faf6b..ab7412772bc 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -971,7 +971,6 @@ struct ArchCPU {
>        */
>       uint32_t kvm_target;
>   
> -#ifdef CONFIG_KVM
>       /* KVM init features for this CPU */
>       uint32_t kvm_init_features[7];
>   
> @@ -984,7 +983,6 @@ struct ArchCPU {
>   
>       /* KVM steal time */
>       OnOffAuto kvm_steal_time;
> -#endif /* CONFIG_KVM */
>   
>       /* Uniprocessor system with MP extensions */
>       bool mp_is_up;

I'm not sure what this achieves?   CONFIG_KVM is a configure-time selection.


r~

