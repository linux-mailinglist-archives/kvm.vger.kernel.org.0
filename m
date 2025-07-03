Return-Path: <kvm+bounces-51495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ACCDAF788B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF7481C85195
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 14:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5562EE996;
	Thu,  3 Jul 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fSgZPqQJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718192ED871
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554213; cv=none; b=jFeW1VAnPkJapjlX08JBrj+3f5cnuyCI8IIUZo/yXxPoQbtD2xSPFOs8IP7k/DnwDnfXIGwaK6TT5YL+G5JpC8bc57+5ALICY4bax8Pdg9hlBuy3CnHUHOgEoiZXdtRkK8byNNYgo5JQVuBhfKY+HvDYhat9B+4f2iJl8HulD1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554213; c=relaxed/simple;
	bh=VEcNMKk1f5y+BnsFjOS3NFzjKQLthXrpt2oUBwTgtAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZlDlkzcfW8GmBVUj25C8uoV82+aadhZmk8veFHZ3nzgLMdeuIbnjy5P+Jr+Meeilnitcrxa80uBHpMZxN9WtNI99ezj5mrMnB3w/O8oU1l5miSVS/4LcOTq6bJhtZWVbEfZG9YYGZzlCqYs4eKc24kv2FkXlbKqSoXlfv76ujDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fSgZPqQJ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4538a2fc7ffso8131795e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 07:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751554210; x=1752159010; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hR1eMIb4LPiCsHEVHY3I5i1T1yeKzcBgMic5GN3xhe8=;
        b=fSgZPqQJpjAAME4TdSZWmf4xHdPfsEOveSFo6pngwSoxkFZUyIQxBVlivyUue6ajnL
         jkjdQnuHouvvXML0MKej1DsEk+0OiYPc1C+fP9VcdDc69enX0DdM3lXAn1o57K/BMYMc
         CIUm46u4yWREysUz81knZqWTmDfQG4hFZ9HOJTwEQT4MjxUBAUYGcU5vZJg+Jd9rn8cV
         U9tHHM3agejbPjaescO/fRrm38N08hHKsToc0QqzJ/HAxW6l0LmX1YqKbDWG9xfjb34E
         vzyIZmJ/2YMWRHCG8wia9xOAJQ+VhsQX9O9YzpQrr5bCg4Uh6BoX+u3YpSs4C6QpsIlW
         U/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751554210; x=1752159010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hR1eMIb4LPiCsHEVHY3I5i1T1yeKzcBgMic5GN3xhe8=;
        b=nOubSqGkURR0A7fVahbBoViQQ3+vYU0G9Ni6Xyyt1inf/q4yvEMa9e3HgfvXkjUDcg
         PFpD1fzjpJu6pVGXr5vhAdNirSYf3faYWPKJnh5Y/8CPi0E3Hzy7TeY6urlbYLgTq8yo
         HgL1drJLvERSpd2MjEXUmvwiJ27LGWBJ+pEF7eIO7vFGad844k3DtsKPUCigwxA4DtO4
         HN3Eja5wuvYBZnnqgljP4UsI+wNwd3vq80vVrKcbgaxvnGBi5LqElCerJ7QdJIAWpWck
         jqMRKgWHy78PxJ5HAknoLnQn9Ttr8S6ast5gCek2vAbcYdS7vIw40aHVsh6g1nzqdNWu
         rkDg==
X-Forwarded-Encrypted: i=1; AJvYcCVQtfiP29sgNAMZWI4WAFmRLefkukj2WeItnVXmZhiB0ywb/CuQrlWu3W/cwwqI2NUD4HY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLCMTMrhB6lKiOxwgF8nq7KzNW8Oh+cw4qUgGa30OzPf2M9cLt
	l1zQdX1uXGkyxUDzzR8FWWVwRlaaaJD5xC6sIq7ok0vtR5JgdnzrKijtpErbS82D0Bw=
X-Gm-Gg: ASbGnctTqTk4lrimek4F2HFTBrWiAw1eY8DwKd9C0c377Dco+PNk1GyL2AHQNi4l+Ox
	FHsogp3Bm/2NHUcjnifaGmDQKJogM7brNROmnRTS8O4Vzfzb+fiEtqKZ30lZCxb0vEhE/7TIwkV
	5ymvZT6eap4SLyu2TvoRF9JkxxI94uwKnX9p5LwngWfBBOTR8oCYhX0PslVnAzIQVZrELAl3cYV
	PxasjwFNLHrulIqoHqPCo8QzUTUAG8kXpzwsLiqdfXv3Mvj6T+8ieqB80GLOnRtEDZ7+NgU5m6y
	0wS6v02d8SZbqPh749zFQBOy7rXNEJqyy3XtDXEU+Nhi2YMY7hDDjG4yHu43xg6m+V6a3LyR+aR
	/hGLX1GO2IJVPD0yfLscRyW/WoN/yCs4l/BHXQm4C
X-Google-Smtp-Source: AGHT+IEJS52ksXPoSSMORIw5HdnklhB8TGerbP9Z7G+RRa11LqUNfOSNCl/2xUOUio4JfnlAUReEVQ==
X-Received: by 2002:a05:600c:a31c:b0:453:92e:a459 with SMTP id 5b1f17b1804b1-454b01ad46amr11043425e9.16.1751554209719;
        Thu, 03 Jul 2025 07:50:09 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde954sm28359795e9.33.2025.07.03.07.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 07:50:09 -0700 (PDT)
Message-ID: <9dc5921c-5698-42fb-81f7-efc98032e6a8@linaro.org>
Date: Thu, 3 Jul 2025 16:50:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/69] accel: Move cpu_common_[un]realize()
 declarations to AccelOpsClass
To: qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-21-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250703105540.67664-21-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 12:54, Philippe Mathieu-Daudé wrote:
> AccelClass is for methods dealing with AccelState.
> When dealing with vCPUs, we want AccelOpsClass.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   include/qemu/accel.h       |  2 --
>   include/system/accel-ops.h |  2 ++
>   accel/accel-common.c       | 10 ++++++----
>   accel/tcg/tcg-accel-ops.c  |  3 +++
>   accel/tcg/tcg-all.c        |  2 --
>   5 files changed, 11 insertions(+), 8 deletions(-)


> diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
> index d854b84a66a..fb199dc78f0 100644
> --- a/include/system/accel-ops.h
> +++ b/include/system/accel-ops.h
> @@ -34,6 +34,8 @@ struct AccelOpsClass {
>       /* initialization function called when accel is chosen */
>       void (*ops_init)(AccelClass *ac);
>   
> +    bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
> +    void (*cpu_common_unrealize)(CPUState *cpu);
>       bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
>       void (*cpu_reset_hold)(CPUState *cpu);
>   
> diff --git a/accel/accel-common.c b/accel/accel-common.c
> index 1d04610f55e..d1a5f3ca3df 100644
> --- a/accel/accel-common.c
> +++ b/accel/accel-common.c
> @@ -102,10 +102,12 @@ bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
>       }
>   
>       /* generic realization */
> -    if (acc->cpu_common_realize && !acc->cpu_common_realize(cpu, errp)) {
> +    if (acc->ops->cpu_common_realize
> +        && !acc->ops->cpu_common_realize(cpu, errp)) {

Unfortunately this breaks user binaries, since AccelOpsClass -- which is
declared in system/accel-ops.h -- is system-only.

This is the same design flow we have with the cpu_reset_hold() handler
not being called on user mode.

>           return false;
>       }
> -    if (acc->ops->cpu_target_realize && !acc->ops->cpu_target_realize(cpu, errp)) {
> +    if (acc->ops->cpu_target_realize
> +        && !acc->ops->cpu_target_realize(cpu, errp)) {
>           return false;
>       }
>   
> @@ -118,8 +120,8 @@ void accel_cpu_common_unrealize(CPUState *cpu)
>       AccelClass *acc = ACCEL_GET_CLASS(accel);
>   
>       /* generic unrealization */
> -    if (acc->cpu_common_unrealize) {
> -        acc->cpu_common_unrealize(cpu);
> +    if (acc->ops->cpu_common_unrealize) {
> +        acc->ops->cpu_common_unrealize(cpu);
>       }
>   }


