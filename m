Return-Path: <kvm+bounces-53756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7815DB167F2
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B64311AA5851
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BE32248A5;
	Wed, 30 Jul 2025 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X1Fr/1HP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681FF221FDC
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753909225; cv=none; b=aos9XAdUAun/DVoFVMdhpN+uYz38H/RaopCdNF6llF4ryDKucUKhIQ5+cFqX/UhQrJv7UL0Q2cS7eIyzI2ssrMBll4OAohEtgEKJVJAVdtNbddOK3NWKQBMXrix5RnZ9YEi3DACx8oVAffRSTwbfaDZvhX6o5xrleUjjF4W9k2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753909225; c=relaxed/simple;
	bh=xD8uITttXI+u2Il+GQLDd8FyaAi1kbHFwnuEPW5wbUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUMq3jpgiRteVuUzFTwDrZdBhsuEaNs1sZI69qaQZtSislqrb9HxXAkPkniChHGeM7XQkEEYkgJSMK5zXzzwVUz/UkI966qBmUPKdhCufu9OfTQBw86jbSeNtRC4g6s0u7QsxTudmnpRT2BcTmES0PHWTl3JKQJjRp1m51pM9oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X1Fr/1HP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753909222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8j5ynn8oMVneUuzpwBR+3iQlVFo6weicIO1y4rh6p58=;
	b=X1Fr/1HPBuMU9mk4dstuBOqxJmsni7ITVogpKtSTpRQCPrQYn+uMH5FWcrKiQgpGWkLwoJ
	Xgf9746K6tSvmeZFcToFOlG/0QbWM7Zek9CozJwDmnLeCxQYKHzQD5KhjLnhfhB9xU2IVL
	78dGv4kYUpCMOYzFfIEkVA8GxEtjQ2s=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-vHE3ftYtNHmvoHhJES2Ryw-1; Wed, 30 Jul 2025 17:00:21 -0400
X-MC-Unique: vHE3ftYtNHmvoHhJES2Ryw-1
X-Mimecast-MFC-AGG-ID: vHE3ftYtNHmvoHhJES2Ryw_1753909221
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ab76d734acso27412741cf.0
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 14:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753909221; x=1754514021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8j5ynn8oMVneUuzpwBR+3iQlVFo6weicIO1y4rh6p58=;
        b=iG1hcMGvFrTH+W12P7YYKMVF6P9AbrUlkLCLjOW37crZlKIBUkK19y+GbLjvUOqnxi
         PzULKXc+QObzKUieyNnSCG54LchUU3UUlo2qQinqT3+RbUW66+9waBahUj0PUeYsycAt
         yu+3pw+MdSxh0w5jgGjBnO0xEdrNIqBGyrFIhx+XOMZI7rnbgSh6Su+bTgoeMf6WC4Bj
         hSXJlSOrfGNhDMT53+B6wldN923OdcwHfna2+1Q9KUFD7+ep1e+UxqvWntvDjrWKcGwB
         jzVyTvnnEu89OtnF9BXdgWWrCKHUEpTze7QoX0Twry7dmQjn3f9dluuYf6D6xSl3ecIN
         Jm/Q==
X-Gm-Message-State: AOJu0YxmvbmQ/L6WLucPNLGoc9BKs92JJetJC0XqwAIoVRrdZ9DEGQEn
	xCj4oWe8QdWL3PBgWYJe+LwoEmv4dVRwyqmAaGfhqAGUET8G3jse5W2M9UHZZqt3RJkU0Z5uU24
	TR5VikxoP+mYAXOhKLR0bkqwbX0qxW2GWrE9GadEAho2hG9ZpTilOmg==
X-Gm-Gg: ASbGncuanzj3iQdMqFAdRiFN8BCYUO+S+fC06Xa1vxFEYJ2EsuU93zvZ4cq/pY5AV8D
	0frvGBhx59t2P+ve/6w38jUmFBapNn1mqmJFgMEGfroGtiracl1LD0Dq/PAIvpdmQ/WYt4N82z/
	9PkpX/UPlYz4am8nZleogpD1VXTWlubx7caY1znKc913JHAesW1kd/4cO2LtgDwvgxmNJq3lit3
	/q+EuJvaUMj/ekcRVxWzzZvKBKoMUQ5KCAHS+thYOGxIoO9nTtibdAnDMJw63q+XwBrev1F+nXp
	zqmOeXDO4e72gl4nFefsre2+tsw79Al0DfoFR06xnj1JqjEvBvWpLTdAR1PlvbpwAYmRdtNMlDP
	YydLRPsiUuM+Akfo2Wgrkhg==
X-Received: by 2002:a05:622a:286:b0:4ab:5963:81cf with SMTP id d75a77b69052e-4aecc8fa909mr129537011cf.18.1753909219810;
        Wed, 30 Jul 2025 14:00:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9f/TlPRhOxdxgj/a8BWbShiOJS3IFhndXPRaAf7ik/1txTuO3l4jpiC4rOXqYcBXi4RReww==
X-Received: by 2002:a05:622a:286:b0:4ab:5963:81cf with SMTP id d75a77b69052e-4aecc8fa909mr129536621cf.18.1753909219309;
        Wed, 30 Jul 2025 14:00:19 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeebde8b4sm1093861cf.4.2025.07.30.14.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 14:00:18 -0700 (PDT)
Date: Wed, 30 Jul 2025 17:00:17 -0400
From: Peter Xu <peterx@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 5/5] x86: add HPET counter read micro
 benchmark and enable/disable torture tests
Message-ID: <aIqH4Vm7ZVagBXrs@x1.local>
References: <20250725095429.1691734-1-imammedo@redhat.com>
 <20250725095429.1691734-6-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250725095429.1691734-6-imammedo@redhat.com>

On Fri, Jul 25, 2025 at 11:54:29AM +0200, Igor Mammedov wrote:
> test is to be used for benchmarking/validating HPET main counter reading
> 
> how to run:
>    QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
> where X is desired number of logical CPUs to test with
> 
> it will 1st execute concurrent read benchmark
> and after that it will run torture test enabling/disabling HPET counter,
> while running readers in parallel. Goal is to verify counter that always
> goes up.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> v4:
>    * use global for test cycles and siplify code a bit
>    * use cpu number instead of APCI ID as index into latency array
>    * report failure if a cpu measured 0 latency
>    * replace on_cpus() with on_cpu_async() to avoid BSP
>      interrupting itself
>    * drop volatile
> 
> v3:
>    * measure lat inside threads so that, threads startup time wouldn't
>      throw off results
>    * fix BSP iterrupting itself by running read test and stalling
>      other cpus as result. (fix it by exiting read test earlier if
>      it's running on BSP)
> v2:
>    * fix broken timer going backwards check
>    * report # of fails
>    * warn if number of vcpus is not sufficient for torture test and skip
>      it
>    * style fixups
> ---
>  x86/Makefile.common  |  2 +
>  x86/hpet_read_test.c | 93 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 95 insertions(+)
>  create mode 100644 x86/hpet_read_test.c
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 5663a65d..ef0e09a6 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -101,6 +101,8 @@ tests-common += $(TEST_DIR)/realmode.$(exe) \
>  realmode_bits := $(if $(call cc-option,-m16,""),16,32)
>  endif
>  
> +tests-common += $(TEST_DIR)/hpet_read_test.$(exe)
> +
>  test_cases: $(tests-common) $(tests)
>  
>  $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
> diff --git a/x86/hpet_read_test.c b/x86/hpet_read_test.c
> new file mode 100644
> index 00000000..a44cdac2
> --- /dev/null
> +++ b/x86/hpet_read_test.c
> @@ -0,0 +1,93 @@
> +#include "libcflat.h"
> +#include "smp.h"
> +#include "apic.h"
> +#include "asm/barrier.h"
> +#include "x86/atomic.h"
> +#include "vmalloc.h"
> +#include "alloc.h"
> +
> +#define HPET_ADDR         0xFED00000L
> +#define HPET_COUNTER_ADDR ((uint8_t *)HPET_ADDR + 0xF0UL)
> +#define HPET_CONFIG_ADDR  ((uint8_t *)HPET_ADDR + 0x10UL)
> +#define HPET_ENABLE_BIT   0x01UL
> +#define HPET_CLK_PERIOD   10
> +
> +#define TEST_CYCLES 100000
> +
> +static atomic_t fail;
> +static uint64_t latency[MAX_TEST_CPUS];
> +
> +static void hpet_reader(void *data)
> +{
> +	long i;
> +	uint64_t old_counter = 0, new_counter;
> +	long id = (long)data;
> +
> +	latency[id] = *(uint64_t *)HPET_COUNTER_ADDR;
> +	for (i = 0; i < TEST_CYCLES; ++i) {
> +		new_counter = *(uint64_t *)HPET_COUNTER_ADDR;
> +		if (new_counter < old_counter)
> +			atomic_inc(&fail);
> +		old_counter = new_counter;
> +	}
> +	/* claculate job latency in ns */
> +	latency[id] = (*(uint64_t *)HPET_COUNTER_ADDR - latency[id])
> +		* HPET_CLK_PERIOD / TEST_CYCLES;
> +}
> +
> +static void hpet_writer(void *data)
> +{
> +	int i;
> +
> +	for (i = 0; i < TEST_CYCLES; ++i)
> +		if (i % 2)
> +			*(uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
> +		else
> +			*(uint64_t *)HPET_CONFIG_ADDR &= ~HPET_ENABLE_BIT;
> +}
> +
> +int main(void)
> +{
> +	unsigned long cpu, time_ns, lat = 0;
> +	uint64_t start, end;
> +	int ncpus = cpu_count();
> +
> +	do {
> +		printf("* starting concurrent read bench on %d cpus\n", ncpus);
> +		*(uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
> +		start = *(uint64_t *)HPET_COUNTER_ADDR;
> +
> +		for (cpu = cpu_count() - 1; cpu > 0; --cpu)
> +			on_cpu_async(cpu, hpet_reader, (void *)cpu);
> +		while (cpus_active() > 1)
> +			pause();
> +
> +		end = (*(uint64_t *)HPET_COUNTER_ADDR);
> +		time_ns = (end - start) * HPET_CLK_PERIOD;
> +
> +		for (cpu = 1; cpu < ncpus; cpu++)
> +			if (latency[cpu])
> +				lat += latency[cpu];
> +			else
> +				report_fail("cpu %lu reported invalid latency (0)\n", cpu);
> +		lat = lat / ncpus;
> +
> +		report(time_ns && !atomic_read(&fail),
> +			"read test took %lu ms, avg read: %lu ns\n", time_ns/1000000,  lat);
> +	} while (0);
> +
> +	do {
> +		printf("* starting enable/disable with concurrent readers torture\n");
> +		if (ncpus > 2) {
> +			for (cpu = 2; cpu < ncpus; cpu++)
> +				on_cpu_async(cpu, hpet_reader, (void *)TEST_CYCLES);
> +
> +			on_cpu(1, hpet_writer, (void *)TEST_CYCLES);
> +			report(!atomic_read(&fail), "torture test, fails: %u\n",
> +				atomic_read(&fail));
> +		} else
> +			printf("SKIP: torture test: '-smp X' should be greater than 2\n");
> +	} while (0);

Nitpick: IMHO the "do... while" indentation isn't strictly needed.  Maybe
it implies the blobs can be put separately into two functions, e.g. as
test_hpet_concurrent_ro() / test_hpet_concurrent_rw().

Reviewed-by: Peter Xu <peterx@redhat.com>

> +
> +	return report_summary();
> +}
> -- 
> 2.47.1
> 

-- 
Peter Xu


