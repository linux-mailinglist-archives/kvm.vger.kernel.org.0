Return-Path: <kvm+bounces-40255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB1EA55069
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EC817A7C9F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FD2212D82;
	Thu,  6 Mar 2025 16:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="omIsIFnW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F231991CF
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741277997; cv=none; b=pjBel6kGpNZcmo0YQzw3EELSGdw/yuI4tSXurO33eUjG0IChgsEI+/iKtE47Ln40WXIZTyPMtOvMf0KvBubVQrcMG59p1wiu5eaONdwzLfsKtXA1h0qTDtv+E6VIQNUt7CxU6waDUlIEX50Kt13AFsbR9iQiAOHcbjjSL4eNC10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741277997; c=relaxed/simple;
	bh=fAlVVrXNw9QeHkJOLAUMWkDard9surHUma36HTVGHoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xu7u8G5OgSRzBjRCddkfJW+0WqTgZlZsga+HdJNRXfd1G5PgMMLeEwdFKUtCblqF9Mg/u5dVJ+EWQigHOY4NbZMiYiirOm+jWVWIoWvo1h2i/n6ejeuGDI9IalQMMiHjs+pQVed88rzRMvOsJB///Iqj70vR48XOt8yfB5e1uMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=omIsIFnW; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2239aa5da08so14313335ad.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 08:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741277995; x=1741882795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YyTTslkGZl/g2Xh5c93BjxA1h20vhJ1AQm8u4TqCtoc=;
        b=omIsIFnWdG4DoHrkP5BBb2rJCeGsNIYDTuRhzNs/scx2hOBX8AleJeDDvmX9UJb4Nu
         ADm9V7lULQ59MrO3u49QtwrQYv7C301J+jkE7mORTsW10UKSy1G14qccKccTsqAF6e4e
         TSH3x9Y1VpDP43Tvd+iF3RoTJjLRwowppzITfXaU4MmA7GYr1Ecv6lQTnq2N/ZAUaa+B
         4R12mvnFkRbaIoS1FekOFgw5ZVSIotOzV31k1ocDaAhILA47yKr2J8Ujj3uXYkXJORMI
         N1AyHZPJuu5KSYTLF1ZgK/878wptQ9rCh50o/TN5lBlNCNwOKepBSIKNxE8i25UIcKCL
         jyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741277995; x=1741882795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YyTTslkGZl/g2Xh5c93BjxA1h20vhJ1AQm8u4TqCtoc=;
        b=E0eUrjmUDIAymq4Q7ux6Zzh+jEcTZHtp1mBayFK8VcfxLsDx+s79uDNpSENkUnwcrT
         c9xmLnbkHiBf00RXfvFQYjCx1Kz9Ptc1O8DigFRD+jdAFDbeZ6ZhZIgkUkrxaKRKjiyZ
         dgcg8BYCO692XC3MCtrCRjCssddct7vQNrY0L8AzoeyPI2pTk3XI7O4cXxcqXoGbWH+9
         7HhrZNErr/XxL4G531X6BauUzrIvX15UgTMXhUNhCIj8UlHSdqC1wAjdVLZD16NajDNP
         hchyRoaLAApMwk4odpMRXRLkj3mSph3Igph8gJPCwaO7gxqDqwFYwvt8xGiG37FImXto
         e5gA==
X-Gm-Message-State: AOJu0Yw0ixoRlrbR7Q2+SsqybFlSQD7ssIUg1fUF2GuYinA6Sv5Y2vFL
	pDBz8997RSJlN/djHjt32eJHaPBxiZtiXlV4GX6ETobTQnDehfsThSKnebTPk1k=
X-Gm-Gg: ASbGnctTSM/GgKUzs8t2Lh/tjNAu5tS0eLu6D3bOZgfCaRPC+9p4gJceUVfAW/EZtjV
	o4LG1ahpku4xi4qMhZfWoYdtK1YTsq6Fqq72eXY8+ZhbuNmRB16FDksG0RbBG5WTpa7Kv2ZdE2v
	TdxPdbUo0pnCbE0wSPgKwuoUkQI69zQDFyc+7AznLYzSYffmoziLNJDV1y/SXXQIAxMZTBlTKtK
	jw48xWoj8LQG5oqHQ6uoqqDKdNvQu4OXrnkLcmCsrWYe0nKXv0XY9mY6hKhTsuUpxw29nHQXiPl
	MHlY6QuRvWY086cw6lgK5xEsuu7lashocOfhe5dHPuH1iFGd8NodHKvyrD4i/72DdPOf12xvicl
	M8WC20gd0
X-Google-Smtp-Source: AGHT+IH8cqQB1JFfHtiMgSr7M3xuAxg7M2IV0C6IViP0/skUuvFOVdV5zfYv+gm3L/lv7o9w6zE9+w==
X-Received: by 2002:a05:6a00:2e9f:b0:736:5486:7820 with SMTP id d2e1a72fcca58-73682be6ed9mr12077370b3a.13.1741277995216;
        Thu, 06 Mar 2025 08:19:55 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73698244daesm1596751b3a.53.2025.03.06.08.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:19:54 -0800 (PST)
Message-ID: <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
Date: Thu, 6 Mar 2025 08:19:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, philmd@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 22:41, Pierrick Bouvier wrote:
> Replace TARGET_PAGE.* by runtime calls
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/syndbg.c    | 7 ++++---
>   hw/hyperv/meson.build | 2 +-
>   2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
> index d3e39170772..f9382202ed3 100644
> --- a/hw/hyperv/syndbg.c
> +++ b/hw/hyperv/syndbg.c
> @@ -14,7 +14,7 @@
>   #include "migration/vmstate.h"
>   #include "hw/qdev-properties.h"
>   #include "hw/loader.h"
> -#include "cpu.h"
> +#include "exec/target_page.h"
>   #include "hw/hyperv/hyperv.h"
>   #include "hw/hyperv/vmbus-bridge.h"
>   #include "hw/hyperv/hyperv-proto.h"
> @@ -188,7 +188,8 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
>                                   uint64_t timeout, uint32_t *retrieved_count)
>   {
>       uint16_t ret;
> -    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
> +    const size_t buf_size = qemu_target_page_size() - UDP_PKT_HEADER_SIZE;
> +    uint8_t *data_buf = g_alloca(buf_size);
>       hwaddr out_len;
>       void *out_data;
>       ssize_t recv_byte_count;

We've purged the code base of VLAs, and those are preferable to alloca.
Just use g_malloc and g_autofree.


r~

