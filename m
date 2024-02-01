Return-Path: <kvm+bounces-7685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE778453CF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3F8B2803E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0E915B985;
	Thu,  1 Feb 2024 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8uJ8XjW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083C615B109
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 09:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706779377; cv=none; b=k/Ue6jszSRYswk0ArltEgdV+SsCzBzupzwfqXl+qwyFDh7YMQdNQwGe0HQPi0zIHxw97dER7o8Pg0CHVWMoIO9QsR12bVPetg2yiveTte7zlMJaPGIZ1FRgYU7ilrZjLlDGgX6Xqk9GO5x/cwQbZ1wKdWZ4cRLbrN5Os5+U0kEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706779377; c=relaxed/simple;
	bh=VioJxwMJIRkuwozVUM8QmfeNEn+A4QsocCdq3vb/loo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EunL9aV0I4C4gJmOOxNyMSIb0fRnXnwsgiux7iEA7CH1Faq0OWNZuRGBGAjB9XmrtdHa8mMhmSi8hYSxJhnbsLXktuaUCn+RbC3xFKkeh2fbgtUhxoDK80AY+E0W/hVWMoiXo93kPVswsjOoOLFl85RyercuqC0c/lU7XMyV4+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8uJ8XjW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706779375;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XWZ+yadK+kdwISy8VmBuG3S1iOvZd1GlxEVqXWoMVAY=;
	b=a8uJ8XjWd6lDS+5tlSEvW0gP+NCNWuNJkcNZY4Znn0xUiSFlUw4jCh6vECuc9idqlyUWXM
	jeYb+DpNEPnZ0vN8OhwjW/SO1oBUJ8MO8jjMZlBv4pWagOzWozi4dg9sYu4+r3+mVFX/kg
	rCjUKpzFXwTFUwx76utsIR7FQtmskmA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-rcnFhahtN7CWTj-9brQEbg-1; Thu, 01 Feb 2024 04:22:53 -0500
X-MC-Unique: rcnFhahtN7CWTj-9brQEbg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-337bf78ef28so233933f8f.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 01:22:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706779371; x=1707384171;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWZ+yadK+kdwISy8VmBuG3S1iOvZd1GlxEVqXWoMVAY=;
        b=GQXyXy3LkLe5SM7dhL6eV1wtxFrFpQC+v1Y/FEnIWoKk/kpCULvk65Ib1FLqU3wthU
         xoKs6fUPjFAchEae2cL32ZEQSJdxECM5O+7rh6/d4zIYAXwz8ov1enIUlP6rX+Q8V633
         YpeKOfPNU+2smtDdjj/zfcGvVydnb3Y0/EZafQbIBGahAu5hlj6S9v+bH39ZuHHaKpFx
         n1YsM8ujCAU6sHW7pNdXo/SjJMBvb0RGbvxULAOFBrtta1/jsK0xJ1ejQQJpOUe5VNkU
         arAXLkM7StyGZyKtrnOWnnC3Mg0f9KH52h4IJprLNMqybwRZpZzFHKaaxo4UX8jsTHBN
         yATg==
X-Gm-Message-State: AOJu0Yz7pPkl4/SfJZiNC1y7KZ0OpYRKAXA90iTwfBIHp6d9pbqHSX5w
	qjIYZ/yME1b3W/hHN6ijntcvFrxzSVmjVgKnbxs/zcuycUl+DdS5HTvAsqWvxjMPj8hWaKtU0T2
	kuneRJOJyBLi3ymVPDsnSTxyw4uB6SFEwOtIxdywloSvv26/Ge3MgRZHnUQ==
X-Received: by 2002:a05:6000:1375:b0:33b:150c:2d50 with SMTP id q21-20020a056000137500b0033b150c2d50mr891733wrz.16.1706779371795;
        Thu, 01 Feb 2024 01:22:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpkpLYGKP7afPtGOqfWpm9X9NQOYeGH9SbDyXD1r4xrzxjbYAVTZK5n2JDppwz1ADZEIapbg==
X-Received: by 2002:a05:6000:1375:b0:33b:150c:2d50 with SMTP id q21-20020a056000137500b0033b150c2d50mr891716wrz.16.1706779371467;
        Thu, 01 Feb 2024 01:22:51 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXSRMBamd/eEaRCAvxYsTirCe8TfxXURJCsXvNDf62Pyy5rKVTr5zBfOjuGSiOWl4T092+FnOZX/duyO54k+uBVnM1/b+Rny42ghANXI0z6JC2z1vqe4ELbTakot7EOkLqi/3pTxKv3jjUaKrl2s0PUw46UZITfJMQFcvvyFtAAMGm+czaQusmbIfBNMB/3wmBOZ/ENqi2MgQYJfNnAJ/Xfw/j3m9FBccXpCAKq15GYLnUiVwGQGx01s14mZBUJzb8SZ+yKvNQyut1Tx8ll574HG6FsxVjPJmUSo4jO9dnKu3MbWNn7dRs=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ce2-20020a5d5e02000000b0033af4848124sm8741803wrb.109.2024.02.01.01.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:22:51 -0800 (PST)
Message-ID: <3623c065-8842-4570-a591-5d0b11911dee@redhat.com>
Date: Thu, 1 Feb 2024 10:22:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 11/24] arm/arm64: Generalize wfe/sev
 names in smp.c
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-37-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-37-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> Most of Arm's on_cpus() implementation can be shared by any
> architecture which has the possible, present, and idle cpumasks,
> like riscv does. Rename the exceptions (wfe/sve) to something
> more generic in order to prepare to share the functions.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  lib/arm/asm/smp.h |  4 ++++
>  lib/arm/smp.c     | 16 ++++++++--------
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index b89a68dd344f..9f6d839ab568 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -6,6 +6,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <cpumask.h>
> +#include <asm/barrier.h>
>  #include <asm/thread_info.h>
>  
>  #define smp_processor_id()		(current_thread_info()->cpu)
> @@ -18,6 +19,9 @@ struct secondary_data {
>  };
>  extern struct secondary_data secondary_data;
>  
> +#define smp_wait_for_event()	wfe()
> +#define smp_send_event()	sev()
> +
>  extern bool cpu0_calls_idle;
>  
>  extern void halt(void);
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index 78fc1656cefa..c00fda2efb03 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -45,7 +45,7 @@ secondary_entry_fn secondary_cinit(void)
>  	 */
>  	entry = secondary_data.entry;
>  	set_cpu_online(ti->cpu, true);
> -	sev();
> +	smp_send_event();
>  
>  	/*
>  	 * Return to the assembly stub, allowing entry to be called
> @@ -65,7 +65,7 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
>  	assert(ret == 0);
>  
>  	while (!cpu_online(cpu))
> -		wfe();
> +		smp_wait_for_event();
>  }
>  
>  void smp_boot_secondary(int cpu, secondary_entry_fn entry)
> @@ -122,7 +122,7 @@ static void cpu_wait(int cpu)
>  	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
>  	deadlock_check(me, cpu);
>  	while (!cpu_idle(cpu))
> -		wfe();
> +		smp_wait_for_event();
>  	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
>  }
>  
> @@ -134,17 +134,17 @@ void do_idle(void)
>  		cpu0_calls_idle = true;
>  
>  	set_cpu_idle(cpu, true);
> -	sev();
> +	smp_send_event();
>  
>  	for (;;) {
>  		while (cpu_idle(cpu))
> -			wfe();
> +			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
>  		on_cpu_info[cpu].func = NULL;
>  		smp_wmb();
>  		set_cpu_idle(cpu, true);
> -		sev();
> +		smp_send_event();
>  	}
>  }
>  
> @@ -174,7 +174,7 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
>  	on_cpu_info[cpu].data = data;
>  	spin_unlock(&lock);
>  	set_cpu_idle(cpu, false);
> -	sev();
> +	smp_send_event();
>  }
>  
>  void on_cpu(int cpu, void (*func)(void *data), void *data)
> @@ -201,7 +201,7 @@ void on_cpus(void (*func)(void *data), void *data)
>  		deadlock_check(me, cpu);
>  	}
>  	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
> -		wfe();
> +		smp_wait_for_event();
>  	for_each_present_cpu(cpu)
>  		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
>  }


