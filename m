Return-Path: <kvm+bounces-45344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30559AA8803
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 854F63AA9CB
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D20931D63CF;
	Sun,  4 May 2025 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GlNsbxMs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D04F8F7D
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375764; cv=none; b=p9YAAW7NlYWvvFP52LJtbMwRs/JfN+9XLNAI5AivNew+VeNBLxBYAK0gzUVmOsHexTAtCcS1yknzPuuV67n5K33jYIyTHqevzVe7DwcpKARJMHeW/nDw9mZSV/LZJiWhjegAeCGSjdVSHipiIDmpk6HPSbUJLd8gltA72RuD1ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375764; c=relaxed/simple;
	bh=YWT1xVwGUk/BKRa0Wt87O+JB18fQBb5du1YKxw21kEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JPKgbnizaLwK2MwIUKIOHZQxupKg2S2Kj+Ghz9oJyQA8KAZYa/A/hhLBCgGv4bjXPKGrNDNyGE7+mmZmMDlIAwphAUzrjwmC6M1eRot1FZkWbNJ+okCJ6Hul968ozy19npJc0jrFbGDBZ9FpnAVUTI6+sgWYQjdZcQ9yKvpHvAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GlNsbxMs; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7403f3ece96so4844048b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375762; x=1746980562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kgIX1vsZuDFUCgCQi+gmJJxCZwsyyNSVWctppGjoyyk=;
        b=GlNsbxMsnOTy08/X1Ae5lOmFLN1HcpyVqDsk5oUsFt5aUuz8szTlIgOe57hfWiJn/3
         z03lLHAO9L46N/s/s+7ezANRUXqX8pRQy7AAbFSvMhuQRxieTALcfKFBTImkiOA79jOP
         YyKvG+seNeH+7QH/UaYnySua2YQ/s/tRoOZtnxNsp2xoQ+Um759IcFH533QiLTPpEf0E
         eo6y5vfat8NIbjDSM/v5Z64jJn59ea+iOE6aKjazdoujYaJeaMY37ZIQr7x3HGiPMegK
         6l0iimXnI+Cv6/DRPQszdojRJy+K5v93Ivfyj/HlCIsadFnprc4mTE8wsuIcaVrnVHkY
         +KhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375762; x=1746980562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgIX1vsZuDFUCgCQi+gmJJxCZwsyyNSVWctppGjoyyk=;
        b=MYVo+lEzTfkD0A/03l+SQA0jGyCt/B/8OTdb5IU5zsSrrKwCEyVTDZTzoFap6Neegm
         ibHh54Kjo0bWlk1blWaEyiAIWWqqpKyCTx4LJYbZ5o4RUULxUgj1f+EWC3/Jck/Mrdlw
         0/c24JjGzfCFJ2EHEIdrJ0wszwNnN3Gs15TCJ5bSx5B2hMD0Uo1tv3xcQXVUqCXQoasi
         y4uHPs/MkS9XQu5u67AlGLhG9Z1gl6CKrwhJRrbkSYMltaBPWzd5GQaN58eOf+dMremA
         hNQ2jr8uLiMm0bLA4G1Z7zTIQd8VgqflYS8eVABunuIl20fTHRDi8D+crHGRF+m2/7A4
         6bpA==
X-Forwarded-Encrypted: i=1; AJvYcCUtSmxWlA4GwBGIJMZDVA103zW6AQpn7/BO4ZyuxvPp19HAkH2Rfci/48PkkCBoOzxZE3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFwYzNU7wd6b7oeJ7R+ANEcmmRRiWdKJDH34AvPdVK97EbcWd7
	CzMupHnE8gy0LmFHV+B3prakHYGCMK3WWFogsDDG13Y+qlpArUDYL05+hOxUigc=
X-Gm-Gg: ASbGncuAVfLqv7+K79dzsmKhtEDpLDkEaR1gK0qMIwZS9zu+UniVcHd16sqiopxymtz
	6Zsf9upGIFQFCqhMS8smVsnfI+neWZ6YDoGkn3QahUtx6Uq088sG7q4JaMm4qWN2JagZrJQbfgE
	/ygNV59PVvSC0/7XfH4J2AJrFJSs9C7albyrL8ZyddCF2H/tp4gdPB1U1dbsqOzOdbg8jyFKd75
	bKdcOxX2E85WdBEo9Q7mrk2QjS1Qj+Wnp4scB807wpeIC6E70jdyZ+gsR+TAtVfTnzfF1swlYYA
	2KT9nKrOhC+KWEf5DlCiEYMAwhP/vH24X7GnRYsPgjhlq4a1jwNU8N5zf6K7BhOxDkEP5zIGW7Z
	QTtZN27E=
X-Google-Smtp-Source: AGHT+IHRYk5QgI7VMX8dTjZoYjvU+aCIcTnL50+b27cw+8DBfiz6tjKw/RO839BAj82CBUKEpNuImA==
X-Received: by 2002:a05:6a00:1d0a:b0:736:46b4:bef2 with SMTP id d2e1a72fcca58-7406f09cfb1mr5345964b3a.6.1746375761753;
        Sun, 04 May 2025 09:22:41 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059020fe7sm5186235b3a.102.2025.05.04.09.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:22:41 -0700 (PDT)
Message-ID: <3fc7e2c5-12bd-4a6e-be17-303bc870a0f9@linaro.org>
Date: Sun, 4 May 2025 09:22:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 39/40] target/arm/kvm-stub: add missing stubs
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-40-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-40-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:29, Pierrick Bouvier wrote:
> Those become needed once kvm_enabled can't be known at compile time.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm-stub.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)


Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


> 
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
> index 4806365cdc5..34e57fab011 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -109,3 +109,13 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
>   {
>       g_assert_not_reached();
>   }
> +
> +void kvm_arm_cpu_pre_save(ARMCPU *cpu)
> +{
> +    g_assert_not_reached();
> +}
> +
> +bool kvm_arm_cpu_post_load(ARMCPU *cpu)
> +{
> +    g_assert_not_reached();
> +}


