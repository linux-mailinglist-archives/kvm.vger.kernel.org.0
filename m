Return-Path: <kvm+bounces-7688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D16D4845434
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78438290FEA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBDF15B99B;
	Thu,  1 Feb 2024 09:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crs0XT9L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4E4D9E8
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 09:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780182; cv=none; b=H3HYrDNF5Pt8dY6j+4yPrXFXeLpYmygHCAQobhKvmdBoHFYmomJ9XSTzx+XKhw8bs3/nuOyxAMxGbf/rqJxQMmMEYkHgWs0FVsm3wBwyMj0UW9J46+PNkWLzBwMnC69ZiJ4iv+8UQTGcKHZ2C62daTCeJ0Wp8wIDGcxeOgoAHDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780182; c=relaxed/simple;
	bh=k+JwVV9XpKIvFcoI8HvGsSxFY34QHvIOGM2hV5ezXGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzlH5V4mU59hK7rFhc1Cz7GaqK156vYY/vGoSevmKz6r1AOjD3NRRBKrWIunC71bMi6Up4dE8IN49F+g1VmXd7KfHUaQjkpqFOP7Wdaj6DS4bU66mDiamJ1JGZBihdzED92uds5Opea6EHn8nkhEy6azpKcssdQrzH9gJSVLzwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crs0XT9L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706780179;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4qsCP/JyH1svm68MjhdAiUlx0jxEfav13iwrJc1tb4=;
	b=crs0XT9LqJpPnxuDdk+6F6b2i8MU+gqPoR6oKs/aWY/T6RcRYLQad9O8DL6qH66CAw70NL
	NHwjbPbNna1e+E+MWFICO7J7TxyF9kaFCj4qgmlQDP0TPonp62bqS/SH0VlLX+5GOfi+IA
	fzv8GSD52jlM73tcewf1T1+FA4TxDPw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-vgukHioqO7uGjAfnvSScjg-1; Thu, 01 Feb 2024 04:36:17 -0500
X-MC-Unique: vgukHioqO7uGjAfnvSScjg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40fb1690f94so2759865e9.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 01:36:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706780176; x=1707384976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r4qsCP/JyH1svm68MjhdAiUlx0jxEfav13iwrJc1tb4=;
        b=vx5cWT5CBCdXvt8TUYKW1jIFWWdUF0MbvwbxYzs9i91omWXCOMX4i6hR65U8t5mnmc
         LKGtjxM+z3EmaNaZIXgcLxDh+QZLJZnygyjCo9VUgnBcVts7EJXNu94dXp3NzafWr2vz
         vYBflWdw9MXDsP/7YS+Jk9TmMz/LK9X4YSoxsrCSNC9r2+I2YLzN712+A5ziwHqdMjsQ
         jxyAsP5gM8TF5rI8qx8RlIC36d3R37oHfve7uKDbucVGwevVlO8np43sYO/j0VMpWUmO
         0caKbVt1Ox+I0BW/2D/fSj03b48+3bmbOZvBA/A0nkTgAdRdIKUuaac2/PRvjPKe98iA
         Gyfw==
X-Gm-Message-State: AOJu0YxlZKpTR1SYvEzRCRvMxEVXT+M/2RWjx1JAkEKcOXj1M1li+IkW
	TYPDzcUaEtAslb7OIYVFAvfirllj+VEMdwLTNJwwTnWMFxbiwpPTAJ9JbsxyUNX/z5gmm5gWOSe
	2kZc0asHMjj53O4K/ZLHOxGab1kn8esFUp4/qt7GS8IlI1VxyPw==
X-Received: by 2002:a05:600c:458e:b0:40f:5190:2f19 with SMTP id r14-20020a05600c458e00b0040f51902f19mr3590612wmo.1.1706780176201;
        Thu, 01 Feb 2024 01:36:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIY88dVmqC+TW+PCd4ZEBkJ9wJVyY+TArB5E0JDfK70netnau4aYcykZFrwc+CUiVhGFVBbQ==
X-Received: by 2002:a05:600c:458e:b0:40f:5190:2f19 with SMTP id r14-20020a05600c458e00b0040f51902f19mr3590583wmo.1.1706780175824;
        Thu, 01 Feb 2024 01:36:15 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW7YBAU/BoVI9FiRKZExo7K+slyHArz5W3gzil9HmPioFrKnJkOwrhHW4tgQJsj7KkfmpW8DNs3Bx99PQmLj5dfSRbuLYqehvBB+D700meKjcn6R4LrFOMjG5QH/K9cMJgXW5RQaXqAblSxHFmu3xdOGBPz1EjpHq1F0856K2Tddf9Ym7hF9qMbC9otGayl3r+Ws9TS+KqSU8QsBXSOOWWfe5NcCgPSPMe3dz0UcRWEjDPzDVAKoSUpX8qgDPhf1LbIxvOI9gz6dgKsv56+0RzuDiXZtjzB153b+47bvJRyFkWiWUmRPr0=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id fc7-20020a05600c524700b0040fbdd6f69bsm831483wmb.33.2024.02.01.01.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:36:15 -0800 (PST)
Message-ID: <1bcabd2a-1d02-4ed3-8782-ee82db435351@redhat.com>
Date: Thu, 1 Feb 2024 10:36:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 13/24] arm/arm64: Share on_cpus
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-39-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-39-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> Now that the previous patches have cleaned up Arm's on_cpus
> implementation we can move it to the common lib where riscv
> will share it.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/Makefile.common |   1 +
>  lib/arm/asm/smp.h   |   8 +--
>  lib/arm/smp.c       | 144 -----------------------------------------
>  lib/on-cpus.c       | 154 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/on-cpus.h       |  14 ++++
>  5 files changed, 170 insertions(+), 151 deletions(-)
>  create mode 100644 lib/on-cpus.c
>  create mode 100644 lib/on-cpus.h
>
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 5214c8acdab3..dc92a7433350 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -43,6 +43,7 @@ cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc.o
>  cflatobjs += lib/devicetree.o
>  cflatobjs += lib/migrate.o
> +cflatobjs += lib/on-cpus.o
>  cflatobjs += lib/pci.o
>  cflatobjs += lib/pci-host-generic.o
>  cflatobjs += lib/pci-testdev.o
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index f0c0f97a19f8..2e1dc27f7bd8 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -6,6 +6,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <cpumask.h>
> +#include <on-cpus.h>
>  #include <asm/barrier.h>
>  #include <asm/thread_info.h>
>  
> @@ -22,14 +23,7 @@ extern struct secondary_data secondary_data;
>  #define smp_wait_for_event()	wfe()
>  #define smp_send_event()	sev()
>  
> -extern bool cpu0_calls_idle;
> -
>  extern void halt(void);
> -extern void do_idle(void);
> -
> -extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
> -extern void on_cpu(int cpu, void (*func)(void *data), void *data);
> -extern void on_cpus(void (*func)(void *data), void *data);
>  
>  extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
>  extern void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry);
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index e0872a1a72c2..0207ca2a7d57 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -10,13 +10,10 @@
>  #include <cpumask.h>
>  #include <asm/thread_info.h>
>  #include <asm/spinlock.h>
> -#include <asm/barrier.h>
>  #include <asm/mmu.h>
>  #include <asm/psci.h>
>  #include <asm/smp.h>
>  
> -bool cpu0_calls_idle;
> -
>  cpumask_t cpu_present_mask;
>  cpumask_t cpu_online_mask;
>  cpumask_t cpu_idle_mask;
> @@ -83,144 +80,3 @@ void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry)
>  		__smp_boot_secondary(cpu, entry);
>  	spin_unlock(&lock);
>  }
> -
> -struct on_cpu_info {
> -	void (*func)(void *data);
> -	void *data;
> -	cpumask_t waiters;
> -};
> -static struct on_cpu_info on_cpu_info[NR_CPUS];
> -static cpumask_t on_cpu_info_lock;
> -
> -static bool get_on_cpu_info(int cpu)
> -{
> -	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> -}
> -
> -static void put_on_cpu_info(int cpu)
> -{
> -	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> -	assert(ret);
> -}
> -
> -static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
> -{
> -	int i;
> -
> -	for_each_cpu(i, waiters) {
> -		if (i == cpu) {
> -			printf("CPU%d", cpu);
> -			*found = true;
> -			return;
> -		}
> -		__deadlock_check(cpu, &on_cpu_info[i].waiters, found);
> -		if (*found) {
> -			printf(" <=> CPU%d", i);
> -			return;
> -		}
> -	}
> -}
> -
> -static void deadlock_check(int me, int cpu)
> -{
> -	bool found = false;
> -
> -	__deadlock_check(cpu, &on_cpu_info[me].waiters, &found);
> -	if (found) {
> -		printf(" <=> CPU%d deadlock detectd\n", me);
> -		assert(0);
> -	}
> -}
> -
> -static void cpu_wait(int cpu)
> -{
> -	int me = smp_processor_id();
> -
> -	if (cpu == me)
> -		return;
> -
> -	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
> -	deadlock_check(me, cpu);
> -	while (!cpu_idle(cpu))
> -		smp_wait_for_event();
> -	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> -}
> -
> -void do_idle(void)
> -{
> -	int cpu = smp_processor_id();
> -
> -	if (cpu == 0)
> -		cpu0_calls_idle = true;
> -
> -	set_cpu_idle(cpu, true);
> -	smp_send_event();
> -
> -	for (;;) {
> -		while (cpu_idle(cpu))
> -			smp_wait_for_event();
> -		smp_rmb();
> -		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> -		on_cpu_info[cpu].func = NULL;
> -		smp_wmb();
> -		set_cpu_idle(cpu, true);
> -		smp_send_event();
> -	}
> -}
> -
> -void on_cpu_async(int cpu, void (*func)(void *data), void *data)
> -{
> -	if (cpu == smp_processor_id()) {
> -		func(data);
> -		return;
> -	}
> -
> -	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
> -						"If this is intended set cpu0_calls_idle=1");
> -
> -	smp_boot_secondary_nofail(cpu, do_idle);
> -
> -	for (;;) {
> -		cpu_wait(cpu);
> -		if (get_on_cpu_info(cpu)) {
> -			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> -				break;
> -			put_on_cpu_info(cpu);
> -		}
> -	}
> -
> -	on_cpu_info[cpu].func = func;
> -	on_cpu_info[cpu].data = data;
> -	set_cpu_idle(cpu, false);
> -	put_on_cpu_info(cpu);
> -	smp_send_event();
> -}
> -
> -void on_cpu(int cpu, void (*func)(void *data), void *data)
> -{
> -	on_cpu_async(cpu, func, data);
> -	cpu_wait(cpu);
> -}
> -
> -void on_cpus(void (*func)(void *data), void *data)
> -{
> -	int cpu, me = smp_processor_id();
> -
> -	for_each_present_cpu(cpu) {
> -		if (cpu == me)
> -			continue;
> -		on_cpu_async(cpu, func, data);
> -	}
> -	func(data);
> -
> -	for_each_present_cpu(cpu) {
> -		if (cpu == me)
> -			continue;
> -		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
> -		deadlock_check(me, cpu);
> -	}
> -	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
> -		smp_wait_for_event();
> -	for_each_present_cpu(cpu)
> -		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> -}
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> new file mode 100644
> index 000000000000..aed70f7b27b2
> --- /dev/null
> +++ b/lib/on-cpus.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * on_cpus() support based on cpumasks.
> + *
> + * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + */
> +#include <libcflat.h>
> +#include <cpumask.h>
> +#include <on-cpus.h>
> +#include <asm/barrier.h>
> +#include <asm/smp.h>
> +
> +bool cpu0_calls_idle;
> +
> +struct on_cpu_info {
> +	void (*func)(void *data);
> +	void *data;
> +	cpumask_t waiters;
> +};
> +static struct on_cpu_info on_cpu_info[NR_CPUS];
> +static cpumask_t on_cpu_info_lock;
> +
> +static bool get_on_cpu_info(int cpu)
> +{
> +	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> +}
> +
> +static void put_on_cpu_info(int cpu)
> +{
> +	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> +	assert(ret);
> +}
> +
> +static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
> +{
> +	int i;
> +
> +	for_each_cpu(i, waiters) {
> +		if (i == cpu) {
> +			printf("CPU%d", cpu);
> +			*found = true;
> +			return;
> +		}
> +		__deadlock_check(cpu, &on_cpu_info[i].waiters, found);
> +		if (*found) {
> +			printf(" <=> CPU%d", i);
> +			return;
> +		}
> +	}
> +}
> +
> +static void deadlock_check(int me, int cpu)
> +{
> +	bool found = false;
> +
> +	__deadlock_check(cpu, &on_cpu_info[me].waiters, &found);
> +	if (found) {
> +		printf(" <=> CPU%d deadlock detectd\n", me);
> +		assert(0);
> +	}
> +}
> +
> +static void cpu_wait(int cpu)
> +{
> +	int me = smp_processor_id();
> +
> +	if (cpu == me)
> +		return;
> +
> +	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
> +	deadlock_check(me, cpu);
> +	while (!cpu_idle(cpu))
> +		smp_wait_for_event();
> +	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> +}
> +
> +void do_idle(void)
> +{
> +	int cpu = smp_processor_id();
> +
> +	if (cpu == 0)
> +		cpu0_calls_idle = true;
> +
> +	set_cpu_idle(cpu, true);
> +	smp_send_event();
> +
> +	for (;;) {
> +		while (cpu_idle(cpu))
> +			smp_wait_for_event();
> +		smp_rmb();
> +		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> +		on_cpu_info[cpu].func = NULL;
> +		smp_wmb();
> +		set_cpu_idle(cpu, true);
> +		smp_send_event();
> +	}
> +}
> +
> +void on_cpu_async(int cpu, void (*func)(void *data), void *data)
> +{
> +	if (cpu == smp_processor_id()) {
> +		func(data);
> +		return;
> +	}
> +
> +	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
> +						"If this is intended set cpu0_calls_idle=1");
> +
> +	smp_boot_secondary_nofail(cpu, do_idle);
> +
> +	for (;;) {
> +		cpu_wait(cpu);
> +		if (get_on_cpu_info(cpu)) {
> +			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> +				break;
> +			put_on_cpu_info(cpu);
> +		}
> +	}
> +
> +	on_cpu_info[cpu].func = func;
> +	on_cpu_info[cpu].data = data;
> +	set_cpu_idle(cpu, false);
> +	put_on_cpu_info(cpu);
> +	smp_send_event();
> +}
> +
> +void on_cpu(int cpu, void (*func)(void *data), void *data)
> +{
> +	on_cpu_async(cpu, func, data);
> +	cpu_wait(cpu);
> +}
> +
> +void on_cpus(void (*func)(void *data), void *data)
> +{
> +	int cpu, me = smp_processor_id();
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +		on_cpu_async(cpu, func, data);
> +	}
> +	func(data);
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == me)
> +			continue;
> +		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
> +		deadlock_check(me, cpu);
> +	}
> +	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
> +		smp_wait_for_event();
> +	for_each_present_cpu(cpu)
> +		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> +}
> diff --git a/lib/on-cpus.h b/lib/on-cpus.h
> new file mode 100644
> index 000000000000..41103b0245c7
> --- /dev/null
> +++ b/lib/on-cpus.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ON_CPUS_H_
> +#define _ON_CPUS_H_
> +#include <stdbool.h>
> +
> +extern bool cpu0_calls_idle;
> +
> +void do_idle(void);
> +
> +void on_cpu_async(int cpu, void (*func)(void *data), void *data);
> +void on_cpu(int cpu, void (*func)(void *data), void *data);
> +void on_cpus(void (*func)(void *data), void *data);
> +
> +#endif /* _ON_CPUS_H_ */


