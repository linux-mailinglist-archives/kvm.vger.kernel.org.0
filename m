Return-Path: <kvm+bounces-7675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 909F58452B6
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B61EB1C25A86
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4604715A490;
	Thu,  1 Feb 2024 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L49lSphB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDB1159594
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 08:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776172; cv=none; b=Zl/LWCnUTg+7GbThDavWR8fLheE24hduSEf3tWw9P0w6Z9H4+iqCxOf1PljakbsGRgBM2dYzxC4+Tm6/CRr/Me96o+wwituzQhq1KKOpDam7C29KlhzV7n0qTg/rbby9UQnYP//WSN6TU808prhQwCbGXisL1Ce7AyDI+3488m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776172; c=relaxed/simple;
	bh=CiAbHUFATzrYRcqWkCE60XxX0mo7+aaPHgsV9bAEClA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e624wjGYluK5aHyUJDbDtrD6b764o4Kkw+XGSVy/wpVax1/e0rwjOCGBtTLRIo8Gg+nX16K2E76BPYlwnuIWqnbjpc2QIp2S2K6zl6Mo4jG138epLcKIpUN8Ro7UVjf05pLdFGEeKacK8Vj64EB7aWY8AMVDWVBQoMNkNOGaDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L49lSphB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776169;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmW2zyN5jXyC4AyMWYaUE5nqSrK+UeP5RxrZvT/F3Rk=;
	b=L49lSphBn/12AN4EN5y2ZGjrlpz4entcYXZ9ROKZWyRi6+34B6X0KewINemOpUUglkQkRW
	2gNyj95nc75nQo9y4iTz2RQ18QdZLvoInfarkpla9kShc/uokWtRY8etC+g3+/3F/YzJLA
	5yw6d8ja1DeuxtvifGC9WYrAfjXEuks=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-kcZAokSdONC8-V7ziWYQfQ-1; Thu, 01 Feb 2024 03:29:28 -0500
X-MC-Unique: kcZAokSdONC8-V7ziWYQfQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40fba0c4fbbso2631925e9.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 00:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776167; x=1707380967;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmW2zyN5jXyC4AyMWYaUE5nqSrK+UeP5RxrZvT/F3Rk=;
        b=ZocxHrvv+CTtO9vGbIv1mflHnf61R7dWwbJAiPJK6d+AtJNuAab/bl813aX9M34aus
         ASJcEMj9mf932MsTybCG3F/E413xttGGe6MgQywoWqTYGb7sJisVZlxxz+mM/ENx0lLD
         t7MTIbZ5HDopN69hhQCnFMVEIgP4PPDBU8mjMJ6NFigmWR9KQPTEBhE7QexVQFrvim9p
         Cc+L/+BXvqFNH0ZdTkXAE0bp8+va4+DQHnTELeljT4f2nr3PbVFPvQBfXx7Mwm+Pvoxb
         a16vCVaUfre9Y0uPhlKwPvQOQJ44Jve91p191Y2KkFzEx8TkAwuySc9/+Y3nF7Oztk7f
         9SwA==
X-Gm-Message-State: AOJu0Yxb81+Na56V+VOlK9Ld+DBO7MSH879ERql3gwTN224itZNYjU+t
	FS21x6sis8wVrYURnMiYNoHTaTFSZTJo9OuJ+qi6VEummm6M8PprHDC+NzOgrW3Voyx4Qjkk9ng
	5d/KqoJLPExH4A5B1YN8GJCz0oqJvjVdCsx2uPF+udYpFRe6Acg==
X-Received: by 2002:a05:600c:a52:b0:40e:ce9e:b543 with SMTP id c18-20020a05600c0a5200b0040ece9eb543mr3179669wmq.41.1706776167047;
        Thu, 01 Feb 2024 00:29:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHG9bnaWIWqqChKJKH+8bFPVEhs3XmbtnTafAVpyrfzeI4rjaWi2rcT4xfeb8Iq91GMwJ1hVg==
X-Received: by 2002:a05:600c:a52:b0:40e:ce9e:b543 with SMTP id c18-20020a05600c0a5200b0040ece9eb543mr3179657wmq.41.1706776166747;
        Thu, 01 Feb 2024 00:29:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWs4ivuRfh/fL0eD2SSxqCyS0TAPyLaai3I7GWzqXMhlcsmAvYJc4u4DSLEetDRHqUlzH4ipl2oPlHpTUSyFk7Fl/rz209k4JkMIebQGA3sRRgAGnd+LzhXsO+PjbHBulmSu2gM3ENR1CjT/UqJZI5jpCHlGkCnqCPjElgdyYaVB7kszKpjVRAR6rvDXR9hC1hV0tIoby2SczJJWtj97YfBtPJtVubduwogCH75+O1HPcT4FBBQcRWn6GwwOfPbCyNxMEVtaYmvHw1JtKcYkaNU65J05hE5kshmUAO/JQ3qAqOH8CfzvL0=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a1c790c000000b0040fba120c0bsm446368wme.0.2024.02.01.00.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:24 -0800 (PST)
Message-ID: <6810c7a7-2494-4bb3-9e74-98010f4d8d4a@redhat.com>
Date: Thu, 1 Feb 2024 09:29:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 03/24] arm/arm64: Move cpumask.h to
 common lib
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-29-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-29-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> RISC-V will also make use of cpumask.h, so move it to the arch-common
> directory.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/arm/asm/gic-v2.h        | 2 +-
>  lib/arm/asm/gic-v3.h        | 2 +-
>  lib/arm/asm/gic.h           | 2 +-
>  lib/arm/asm/smp.h           | 2 +-
>  lib/arm/mmu.c               | 2 +-
>  lib/arm/smp.c               | 2 +-
>  lib/arm64/asm/cpumask.h     | 1 -
>  lib/{arm/asm => }/cpumask.h | 9 ++++-----
>  8 files changed, 10 insertions(+), 12 deletions(-)
>  delete mode 100644 lib/arm64/asm/cpumask.h
>  rename lib/{arm/asm => }/cpumask.h (94%)
>
> diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
> index 1fcfd43c8075..ff11afb15d30 100644
> --- a/lib/arm/asm/gic-v2.h
> +++ b/lib/arm/asm/gic-v2.h
> @@ -18,7 +18,7 @@
>  #define GICC_IAR_INT_ID_MASK		0x3ff
>  
>  #ifndef __ASSEMBLY__
> -#include <asm/cpumask.h>
> +#include <cpumask.h>
>  
>  struct gicv2_data {
>  	void *dist_base;
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index b4ce130e56c6..a1cc62a298b8 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -67,10 +67,10 @@
>  #include <asm/arch_gicv3.h>
>  
>  #ifndef __ASSEMBLY__
> +#include <cpumask.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
>  #include <asm/delay.h>
> -#include <asm/cpumask.h>
>  #include <asm/smp.h>
>  #include <asm/io.h>
>  
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 189840014b02..dc8cc18c0fbd 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -47,7 +47,7 @@
>  #define SPI(irq)			((irq) + GIC_FIRST_SPI)
>  
>  #ifndef __ASSEMBLY__
> -#include <asm/cpumask.h>
> +#include <cpumask.h>
>  
>  enum gic_irq_state {
>  	GIC_IRQ_STATE_INACTIVE,
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index dee4c1a883e7..bb3e71a55e8c 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -5,8 +5,8 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <cpumask.h>
>  #include <asm/thread_info.h>
> -#include <asm/cpumask.h>
>  
>  #define smp_processor_id()		(current_thread_info()->cpu)
>  
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 2f4ec815a35d..b16517a3200d 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -5,9 +5,9 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <cpumask.h>
>  #include <asm/setup.h>
>  #include <asm/thread_info.h>
> -#include <asm/cpumask.h>
>  #include <asm/mmu.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index 1d470d1aab45..78fc1656cefa 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -7,9 +7,9 @@
>   */
>  #include <libcflat.h>
>  #include <auxinfo.h>
> +#include <cpumask.h>
>  #include <asm/thread_info.h>
>  #include <asm/spinlock.h>
> -#include <asm/cpumask.h>
>  #include <asm/barrier.h>
>  #include <asm/mmu.h>
>  #include <asm/psci.h>
> diff --git a/lib/arm64/asm/cpumask.h b/lib/arm64/asm/cpumask.h
> deleted file mode 100644
> index d1421e7abe31..000000000000
> --- a/lib/arm64/asm/cpumask.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include "../../arm/asm/cpumask.h"
> diff --git a/lib/arm/asm/cpumask.h b/lib/cpumask.h
> similarity index 94%
> rename from lib/arm/asm/cpumask.h
> rename to lib/cpumask.h
> index 3fa57bfb17c6..d30e14cda09e 100644
> --- a/lib/arm/asm/cpumask.h
> +++ b/lib/cpumask.h
> @@ -1,12 +1,11 @@
> -#ifndef _ASMARM_CPUMASK_H_
> -#define _ASMARM_CPUMASK_H_
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * Simple cpumask implementation
>   *
>   * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> - *
> - * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#ifndef _CPUMASK_H_
> +#define _CPUMASK_H_
>  #include <asm/setup.h>
>  #include <bitops.h>
>  
> @@ -120,4 +119,4 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
>  			(cpu) < nr_cpus; 			\
>  			(cpu) = cpumask_next(cpu, mask))
>  
> -#endif /* _ASMARM_CPUMASK_H_ */
> +#endif /* _CPUMASK_H_ */


