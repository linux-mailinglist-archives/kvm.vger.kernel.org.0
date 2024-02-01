Return-Path: <kvm+bounces-7674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BAF78452B4
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:29:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F950B22E5E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CDF159585;
	Thu,  1 Feb 2024 08:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KpxDd4hy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE227159589
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776169; cv=none; b=VkRRvyENj+1LpfOcuKm6V9szMOh3RNbACA3EJllicpnsZVTkvXAEDASzQv0n51JotgnGDkxz1y8qRxO+o+0IRES/HqclxY1bXvQIEwm/ndhcOcY1LsOVfwRWSeZXBfIXnMHXokLM59n8j7OffzYOvsolj0q7ImwrnwPQ7dX2qZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776169; c=relaxed/simple;
	bh=G2AM12amVMrP7GZrkut2e97ASmNSuJ6AUi0+jpz9Sno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLG2IKukpBOCKgMjKCgG5xVciDX3fqIvn4kWLiEYbNNCrPfl0N4Sekv6jUhIAALhTUqyv4gRhxwr/eB1o7/zkO64NNmo6heoxXf3puKxmblG7+VYp5mqjn3D656CGFnGs9uS3zGQxUc/UhqmLCfp/5JaLUSs5paT2EkZoxgOaDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KpxDd4hy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776166;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9MZIyh9FSa9PbK1/5CHC5q5vkvb+rf2FqdbmMNUUP0=;
	b=KpxDd4hySrMzQkMYsUrCFFffhd061sEBKDayByd9poz9zs8yUfcpAr14SO2vwh5DqV8EBa
	tFRwrOgJmB5VbDRv92EXgPWClXUcp/az/RZVP06in+PuR81YO8YQlWzEIzyEDsBDxr9FS7
	zqoC2Mdmo9BmsmVCMOtLOwjiB1PE8Hg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-Nx559nStP1yqMA00ITtvRw-1; Thu, 01 Feb 2024 03:29:25 -0500
X-MC-Unique: Nx559nStP1yqMA00ITtvRw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5101b9343easo492964e87.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 00:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776164; x=1707380964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X9MZIyh9FSa9PbK1/5CHC5q5vkvb+rf2FqdbmMNUUP0=;
        b=M8Ljg9mYAncSd6v8iGV3EJAHD0oueerGa3SWN9cAyEcYT4y1tr2DRs/+32kId2B8n/
         EtuinSNRpgEwD3flChaEb1jFtQfmzuyhtIzTM1gqNz4HP8YOuZljZFUHlPaQBx1H5Ek5
         1E89SDbC3NY/aQAOZFS9tcvf5QRaWgD/ZDj7KJUB85FBvguAwV/Zrqwox7RYfIE+7Un6
         f40p4D6RJSFrYI2nvxhvTLZq20s67NbV/5KQyW4pA9a7ymD4h4B5o+s3oy+/GY1Fbj6x
         4KTGsXCBrw8TDXhHIpgH1FP5Yuqa5cpDQVfRWywxEOZ4acAjm7tUIvIenIxL2Uj1DZOw
         Eitw==
X-Gm-Message-State: AOJu0Yyvb4fYfXgDxUnM+AQ/gOZLoUvgDvfjrP8PJD5Nm+FSnTCG429I
	eyC0TLIIYbesnGWR060MeLZ8D0F/V+qkvJVSvPfQ4L+x4d6mbQ/xND0ZchVtisjz9QMRenT5btI
	VXFGfhhBsDgPXc4+8nNGFASb+Vof2EdBwun1VlGMevhmb05I5XA==
X-Received: by 2002:a05:6512:40c:b0:511:300c:d40 with SMTP id u12-20020a056512040c00b00511300c0d40mr494948lfk.22.1706776164261;
        Thu, 01 Feb 2024 00:29:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4Wtl9F00WmIcVZzUI9GgxMBA9Jw/EuFwtCT01zyHKVbWo1cfOrwDxkZlAB7zsztJlmflgxQ==
X-Received: by 2002:a05:6512:40c:b0:511:300c:d40 with SMTP id u12-20020a056512040c00b00511300c0d40mr494936lfk.22.1706776163954;
        Thu, 01 Feb 2024 00:29:23 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVG5oaiR8h3AJCow9zKczsXhGg/hyrZfHKcIOnsw8823xzKGU65rkho7WydIvsh2Kjbxk0OGiOothfvmzQdo2vdPyCiYgoYQ9joVE9VWarEODeKHYy9gWXcr0AHr1RuYwbv0rOyw0bSv8relNci25sj3lAKxZguTtEufVHUcdFvaXYPX8k7wozBtrx8OEHkwf3coLK8pSiM+GYsY36LsAHNRw70kTk0jvgoAXjBtw4/fVAUQyN6lVsFiTUsOxpxK4cfL0jtIIxaEtQoT6VtIqvQ1EAXWzl3H4c966OiWdMzDu0lsHMb9U8=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id jr7-20020a05600c560700b0040efa513540sm3643423wmb.22.2024.02.01.00.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:23 -0800 (PST)
Message-ID: <caa36aaf-e386-4217-8444-8b6f38be00ea@redhat.com>
Date: Thu, 1 Feb 2024 09:29:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 04/24] arm/arm64: Share cpu online,
 present and idle masks
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-30-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-30-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 1/26/24 15:23, Andrew Jones wrote:
> RISC-V will also use Arm's three cpumasks. These were in smp.h,
> but they can be in cpumask.h instead, so move them there, which
> is now shared.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric
> ---
>  lib/arm/asm/smp.h | 33 ---------------------------------
>  lib/cpumask.h     | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index bb3e71a55e8c..b89a68dd344f 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -23,39 +23,6 @@ extern bool cpu0_calls_idle;
>  extern void halt(void);
>  extern void do_idle(void);
>  
> -extern cpumask_t cpu_present_mask;
> -extern cpumask_t cpu_online_mask;
> -extern cpumask_t cpu_idle_mask;
> -#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
> -#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
> -#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
> -#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
> -#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
> -
> -static inline void set_cpu_present(int cpu, bool present)
> -{
> -	if (present)
> -		cpumask_set_cpu(cpu, &cpu_present_mask);
> -	else
> -		cpumask_clear_cpu(cpu, &cpu_present_mask);
> -}
> -
> -static inline void set_cpu_online(int cpu, bool online)
> -{
> -	if (online)
> -		cpumask_set_cpu(cpu, &cpu_online_mask);
> -	else
> -		cpumask_clear_cpu(cpu, &cpu_online_mask);
> -}
> -
> -static inline void set_cpu_idle(int cpu, bool idle)
> -{
> -	if (idle)
> -		cpumask_set_cpu(cpu, &cpu_idle_mask);
> -	else
> -		cpumask_clear_cpu(cpu, &cpu_idle_mask);
> -}
> -
>  extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
>  extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpu(int cpu, void (*func)(void *data), void *data);
> diff --git a/lib/cpumask.h b/lib/cpumask.h
> index d30e14cda09e..be1919234d8e 100644
> --- a/lib/cpumask.h
> +++ b/lib/cpumask.h
> @@ -119,4 +119,37 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
>  			(cpu) < nr_cpus; 			\
>  			(cpu) = cpumask_next(cpu, mask))
>  
> +extern cpumask_t cpu_present_mask;
> +extern cpumask_t cpu_online_mask;
> +extern cpumask_t cpu_idle_mask;
> +#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
> +#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
> +#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
> +#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
> +#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
> +
> +static inline void set_cpu_present(int cpu, bool present)
> +{
> +	if (present)
> +		cpumask_set_cpu(cpu, &cpu_present_mask);
> +	else
> +		cpumask_clear_cpu(cpu, &cpu_present_mask);
> +}
> +
> +static inline void set_cpu_online(int cpu, bool online)
> +{
> +	if (online)
> +		cpumask_set_cpu(cpu, &cpu_online_mask);
> +	else
> +		cpumask_clear_cpu(cpu, &cpu_online_mask);
> +}
> +
> +static inline void set_cpu_idle(int cpu, bool idle)
> +{
> +	if (idle)
> +		cpumask_set_cpu(cpu, &cpu_idle_mask);
> +	else
> +		cpumask_clear_cpu(cpu, &cpu_idle_mask);
> +}
> +
>  #endif /* _CPUMASK_H_ */


