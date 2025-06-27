Return-Path: <kvm+bounces-51036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE6BAEC2A6
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 00:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1FC87B1841
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 22:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58722290D83;
	Fri, 27 Jun 2025 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XQQQaWcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FEC28DB45
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751063846; cv=none; b=fJm/aJd2ROsxD2Jphy+Gcgoz8ZMx0qap9rvrT1TL/1sTKovwrihvkEzESKbpO7u4VFC3qThQorChYcIE0W5nxRakw/uFI7BKj4Xt8CtMgs3YLMqmz5ai3gpzPxznc2Y5eC9KUb0UaC3jWrBS9AY2h7y2b2OPd5sMLMlmkCTMWGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751063846; c=relaxed/simple;
	bh=o+LBvEWMQA5EWudzt9AhM46ANmy/jCLxBFeocx0cNfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeO06DAHRHXqUFsAo6e0X23MQjYLCMv+et/kpuKx7K/3gPcmhsuRChTunKNfiUzvjvbo100MPkEpjc69gV0PrFmB6mUaF4txtGekObE5EI495DFFGEXj/MjbRLIcsS6NxIWUAm3Fz4PsW9y+ZmkwfjaonXjlNbCJNYtiuy5+Gn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XQQQaWcM; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-73972a54919so528681b3a.3
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 15:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751063844; x=1751668644; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AmoPQKvckjmnkiguf5S2Qtd2fEgGfO024lGKEbW7LKM=;
        b=XQQQaWcMLpLi/GUzRa7Vjh7OM0ZqKwmByMulgzXbL/6z08iAUqP+m7EYCY/5sl3kx1
         AubP52Pe+ysoIqSQy1O97iNDae28cSG+kUG/7+aDhFdSIVrywIiJLs/I/N9/uIw5xOts
         +za8JXBbWtr+xF1A5iiBWlxdjY8y+/IJ0loOdyjfXjdvsfl1tZNMiftyATiVs1oklqvh
         tZyj+k36/B+ebgPw7/Vw1bhy2gMYZdy0A1f+lkuPt1D2tDUkkxIcg7YM0k3XscD9UrKU
         ++ThpYU0r2Uup/aOl6Jr3UxmHsMz+LWHo4N/+e8/rsZ8odND92r0SErQR7NcYblbJ4BR
         hOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751063844; x=1751668644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmoPQKvckjmnkiguf5S2Qtd2fEgGfO024lGKEbW7LKM=;
        b=U6TMhas+w5C55kFPmBlN2ESE5h2N2cC/rxUMBL6cWnfFvMr45zGkmHpxYfgyLMPSvk
         RzGiF8ZdOlYggt2yWWdwKcXP88UeEBA0vXRIWTsWycx8mH6A5316Nifqy3+4V0v07m1h
         D+Fk2UCSn6DyWbLF5N/ynRihYb4p5gOXJRzosQwB16tMTQ3EHF9hxLvuKle8xLSaGFEU
         duUgE2tth9/CuGVaDgQ+tuR1Y0aMUp25GHMhjILa8RRDR8X1ZSovcE4zPg1BjhQioznm
         VzdkrOi4t5qqecFbhyMn9lPDVwV2WlNRw782hA9cdmLvO3tpGFU+2yX2yrIMip/+GXLD
         R3Ew==
X-Forwarded-Encrypted: i=1; AJvYcCWnDyZ7SflBaLaL6mPrgkG4UVeHstySNoTtsJeB88DopeXwj5yWNlH7urlPv7rtYMWZaXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnNHvzLFM9xXFdMpzr7A8awVeq9/VrvYipaqwsfqj+2dTh9XNz
	1oMxtQa/Fsurg+G7d1yl3D/QtjVUJ+rZTUkRR4C1JR4I8FGaoL44Qq6QES6Tnd9GBQ==
X-Gm-Gg: ASbGnct8Mc/CfXRpfOOWk2qgjYTb8P6cpduDm1Rbs8K/ftMfcbu6ioXqche7nbSWKFT
	p3gqisKKdQ7aq1xTp4qDXxymUY8h3Kt2L7uflY83zJhYL0QiRhVZIJMBqG7/3uhHEzvJTFytMvP
	q+az14oC0ltgJMwOSYEaLwNIIMboHudjcQTG14SGINYOVmcepCKbMJPTUM152XuwtoIq/b9+9Ch
	wk+f6n4SmlOzDy3Nun38rvqsXtQxE0JA2Tc7BIHOGDxIqso27/DoWmYEhW12kAPHZfbunnuLHRl
	yaSmeuGmvB/0/h3gmjSGeDChGwq1tnacmtNnumlHbHsjJ+Q7LFQ9uk6OyjHB9v39roMi0kfCzsM
	UJ1NtpjlSWTuOA19OCYuxEJVU
X-Google-Smtp-Source: AGHT+IGOmU4XDvEBpqievcVKxPm+zgdejAJhb3e3XgqXZ4ffP/3kaKcRipz7BTJWXn9mTGUGhcBv2w==
X-Received: by 2002:a05:6a00:2411:b0:748:f854:b765 with SMTP id d2e1a72fcca58-74af6e80a87mr6582349b3a.4.1751063843716;
        Fri, 27 Jun 2025 15:37:23 -0700 (PDT)
Received: from google.com (111.67.145.34.bc.googleusercontent.com. [34.145.67.111])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af541b6e5sm2895207b3a.43.2025.06.27.15.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 15:37:22 -0700 (PDT)
Date: Fri, 27 Jun 2025 22:37:19 +0000
From: David Matlack <dmatlack@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: alex.williamson@redhat.com, bhelgaas@google.com, vipinsh@google.com,
	kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com
Subject: Re: [RFC PATCH 2/3] vfio: selftests: Introduce the selftest
 vfio_flr_test
Message-ID: <aF8dH06DsMpWCLti@google.com>
References: <20250626180424.632628-1-aaronlewis@google.com>
 <20250626180424.632628-3-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626180424.632628-3-aaronlewis@google.com>

On 2025-06-26 06:04 PM, Aaron Lewis wrote:
> Introduce the VFIO selftest "vfio_flr_test" as a way of demonstrating a
> latency issue that occurs when multiple devices are reset at the
> same time.  To reproduce this issue simply run the selftest, e.g.
> 
>   $ VFIO_BDF_1=0000:17:0c.1 VFIO_BDF_2=0000:17:0c.2 ./vfio_flr_test
>   [0x7f61bb888700] '0000:17:0c.2' initialized in 108.6ms.
>   [0x7f61bc089700] '0000:17:0c.1' initialized in 212.3ms.
> 
> When the devices are initialized in the test, despite that happening on
> separate threads, one of the devices will take >200ms.  Initializing a
> device requires a FLR (function level reset), so the device taking
> ~100ms to initialize is expected, however, when a second devices is
> initialized in parallel the desired behavior would be that the FLR
> happens concurrently.  Unfortunately, due to a lock in
> vfio_df_group_open() that does not happen.
> 
> As for how the selftest works, it requires two BDF's be passed to it as
> environment variables as shown in the example above:
>  - VFIO_BDF_1
>  - VFIO_BDF_2
> 
> It then initializes each of them on separate threads and reports how long
> they took.
> 
> The Thread ID is included in the debug prints to show what thread they
> are executing from, and to show that this is a parallel operation.
> 
> Some of the prints are commented out to allow the focus to be on the
> issue at hand, however, they can be useful for debugging so they were
> left in.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  tools/testing/selftests/vfio/Makefile        |   1 +
>  tools/testing/selftests/vfio/vfio_flr_test.c | 120 +++++++++++++++++++
>  2 files changed, 121 insertions(+)
>  create mode 100644 tools/testing/selftests/vfio/vfio_flr_test.c
> 
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index 324ba0175a33..57635883f2c2 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -1,5 +1,6 @@
>  CFLAGS = $(KHDR_INCLUDES)
>  TEST_GEN_PROGS += vfio_dma_mapping_test
> +TEST_GEN_PROGS += vfio_flr_test
>  TEST_GEN_PROGS += vfio_iommufd_setup_test
>  TEST_GEN_PROGS += vfio_pci_device_test
>  TEST_GEN_PROGS += vfio_pci_driver_test
> diff --git a/tools/testing/selftests/vfio/vfio_flr_test.c b/tools/testing/selftests/vfio/vfio_flr_test.c
> new file mode 100644
> index 000000000000..5522f6d256dc
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/vfio_flr_test.c

I don't think vfio_flr_test.c is the right name for this test. FLR is
something that happens in the kernel during one specific ioctl() deep
within vfio_pci_device_init(). And it also might not happen at all (if
the device being used does not support FLR).

What this test actually does it measure the time it takes to do
vfio_pci_device_init() in parallel across multiple threads.

How about vfio_pci_device_init_perf_test.c?

> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdlib.h>
> +
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +
> +#include <linux/limits.h>
> +#include <linux/pci_regs.h>
> +#include <linux/sizes.h>
> +#include <linux/vfio.h>
> +
> +#include <vfio_util.h>
> +
> +#define NR_THREADS 2
> +
> +double freq_ms = .0;
> +
> +static bool is_bdf(const char *str)
> +{
> +	unsigned int s, b, d, f;
> +	int length, count;
> +
> +	count = sscanf(str, "%4x:%2x:%2x.%2x%n", &s, &b, &d, &f, &length);
> +	return count == 4 && length == strlen(str);
> +}
> +
> +static const char *vfio_get_bdf(const char *env_var)
> +{
> +	char *bdf;
> +
> +	bdf = getenv(env_var);
> +	if (bdf) {
> +		VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
> +		return bdf;
> +	}
> +
> +	return NULL;
> +}

Please update the library to support multiple BDFs rather than creating
a custom solution for this test.

In the library we have support for getting a single BDF from either the
command line or the environment variable $VFIO_SELFTESTS_BDF via:

  const char *device_bdf = vfio_selftests_get_bdf(&argc, argv);

Add a variant of this that supports looking for and returning multiple
BDFs and use it here, e.g.

  const char *device_bdfs[2];

  vfio_selftests_get_bdfs(&argc, argv, device_bdfs, 2);

Then we can reimplement vfio_selftests_get_bdf() on top like this:

const char *vfio_selftests_get_bdf(int *argc, char *argv[])
{
	const char *bdf;

	vfio_selftests_get_bdfs(argc, argv, &bdf, 1);
	return bdf;
}

The new function should support getting the BDFs from either the command
line or $VFIO_SELFTESTS_BDF, just like the current function.

For bonus points we could even make vfio_selftests_get_bdfs() support
any number of BDFs by dynamically allocating the array and returning the
number it found on the command line or in the env var. That way your
test can support running with any number of devices (not just 2).

Once you do this then you can run your test just like any other VFIO
selftests, e.g.:

   $ ./run.sh -d 0000:17:0c.1 -d 0000:17:0c.2 -- ./vfio_flr_test

Or like this:

   $ ./run.sh -d 0000:17:0c.1 -d 0000:17:0c.2 -s
   $ ./vfio_flr_test
   $ exit


> +
> +static inline uint64_t rdtsc(void)
> +{
> +	uint32_t eax, edx;
> +	uint64_t tsc_val;
> +	/*
> +	 * The lfence is to wait (on Intel CPUs) until all previous
> +	 * instructions have been executed. If software requires RDTSC to be
> +	 * executed prior to execution of any subsequent instruction, it can
> +	 * execute LFENCE immediately after RDTSC
> +	 */
> +	__asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
> +	tsc_val = ((uint64_t)edx) << 32 | eax;
> +	return tsc_val;
> +}
> +
> +static void init_freq_ms(void)
> +{
> +	uint64_t tsc_start, tsc_end;
> +
> +	tsc_start = rdtsc();
> +	sleep(1);
> +	tsc_end = rdtsc();
> +	freq_ms = (double)(tsc_end - tsc_start) / 1000.0;
> +	// printf("[0x%lx] freq_ms = %.03lf\n", pthread_self(), freq_ms);
> +}
> +
> +static double now_ms(void)
> +{
> +	return (double)rdtsc() / freq_ms;
> +}
> +
> +static double time_since_last_ms(double *last_ms)
> +{
> +	double now = now_ms();
> +	double duration = now - *last_ms;
> +
> +	*last_ms = now;
> +	return duration;
> +}

Please use clock_gettime(CLOCK_MONOTONIC) to measure elapsed time in a
platform-independent way.

> +
> +static void *flr_test_thread(void *arg)
> +{
> +	const char *device_bdf = (const char *)arg;
> +	struct vfio_pci_device *device;
> +	double last = now_ms();

Should we put a simple spin-barrier here to ensure the threads do
vfio_pci_device_init() at the same time (at least as best as we can
guarantee from userspace)?

> +
> +	device = vfio_pci_device_init(device_bdf, default_iommu_mode);
> +	printf("[0x%lx] '%s' initialized in %.1lfms.\n",
> +	       pthread_self(), device_bdf, time_since_last_ms(&last));

I think we need a barrier here to make sure nothing in
vfio_pci_device_cleanup() interferes with the performance of a
still-running vfio_pci_device_init().

> +
> +	vfio_pci_device_cleanup(device);
> +	// printf("[0x%lx] '%s' cleaned up in %.1lfms\n",
> +	//        pthread_self(), device_bdf, time_since_last_ms(&last));
> +
> +	return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	const char *device_bdfs[NR_THREADS];
> +	pthread_t threads[NR_THREADS];
> +	int i;
> +
> +	init_freq_ms();
> +
> +	device_bdfs[0] = vfio_get_bdf("VFIO_BDF_1");
> +	device_bdfs[1] = vfio_get_bdf("VFIO_BDF_2");
> +
> +	// printf("[0x%lx] nr_threads = '%d'\n", pthread_self(), NR_THREADS);
> +
> +	for (i = 0; i < NR_THREADS; i++)
> +		pthread_create(&threads[i], NULL, flr_test_thread,
> +			       (void *)device_bdfs[i]);
> +
> +	for (i = 0; i < NR_THREADS; i++)
> +		pthread_join(threads[i], NULL);
> +
> +	return 0;
> +}
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

