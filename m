Return-Path: <kvm+bounces-52915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0122B0A811
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57D17A829C0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9242E5B14;
	Fri, 18 Jul 2025 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqxXXKMW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE3B2BD00C
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854332; cv=none; b=avzK4dbkHQ0uiS+2MUXZrK9cZrJ1ZKvAeQ7cwaDlLpzE3mhqqgYO190dSZ+hQlyRBP2qg7k6cjo18RtcTAAYbOjpTDU9c9UWIzT3d/77u1FmgCiFnR9ulmn2emfPn4vbI7VneAGGU1GJ6Lbo2+LvyL+5N0lXd+NEOTRB8+CEBiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854332; c=relaxed/simple;
	bh=dTYH/eJYeZBuDbF+VAdUex9P3+NR6a4FiYzeb/LInYw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EAjCmTT4RmGWsZ2uWM6e5ownBdkbYdsZ/dl9uNcINW46Z3s7BPHDpgRyIewpvR9oktPvZ14L8Yn13DUOuoySU+e5rNJOd/5AMMM6mYUDLK9+b8T/BhEcWXVhcX5Z37Mkr5aR4GJNzyjtYDMQ1iA9BawDZ/DNXW5SecD/v89Q7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqxXXKMW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752854329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBlFU/X/HLQucSGWnkd4l+ol6MCJiBi4KvDOy83SR6Q=;
	b=dqxXXKMWKlhBmfNDIEVE1hzifIkyH+gGRFHURjiYD2Y+PfS34CpzEoyRS5dqZLTIoBxgP+
	ruciZJMO+uoG5/SKEwIpvpy2GDEud/mYvmMYfwJs+MC5YjlgZYPokDs1u46ft8i6GvVFol
	DrlxYGWoYbEX2vbICsTOdECgJf6MHZQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-FKsy2prjONKD8Xnyh0kS1Q-1; Fri, 18 Jul 2025 11:58:48 -0400
X-MC-Unique: FKsy2prjONKD8Xnyh0kS1Q-1
X-Mimecast-MFC-AGG-ID: FKsy2prjONKD8Xnyh0kS1Q_1752854327
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a6d1394b07so1454410f8f.3
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752854326; x=1753459126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nBlFU/X/HLQucSGWnkd4l+ol6MCJiBi4KvDOy83SR6Q=;
        b=jAQxM7vIX7TPET53/2lQ4VV9/3HYaNkpeu5r/5GyF+4u+kpoC9gqqUIqw/E+Ar/CX0
         JeOThZ4qHqXw/KpAVc214jVvz+TNntwCRXiJEXJfDDbtWfXcvt0RkgggP/BFuqnvEFXD
         oKT59eyhBcS/ecszN75ciq29Mw0TjXHuh/61S+rfaiceGBanO2qq7EHO+WTwgqs57e6I
         DTOFTtDmV8cf0RhreSk8s9ex1yZJm/Ly4oVL/5wx0LGDwqtmQGJMvipjpNro4V4wHFmI
         4sdn2NDAL+H730eUFUNbip85FfTgJRUZMrqkoNfKwgqrvDSGOmfFPrNhXVGHEI2A5qaY
         VQXw==
X-Gm-Message-State: AOJu0YwzGLl1fjcEM2OZO42K3aKPeLY27yARMPyw6SXQqhj19ozLLyZR
	p3FgmlGLD7/c9fiEQpVGy7ArWrzsu1X1lemWpZhxhTc9JGxpvV3TGPjoPKwnn9+raCUg1Ty5E3+
	GXSSmUzY8CD9ZfbmvLMK9/A9UfY27sTloq7ICmhiy/kKlaFKeP0+fshPqL1AKXStqGEapyVkWvm
	PsUek/6phjtZhmgXC2fR/zyagICoFLCQDnTEC4vA==
X-Gm-Gg: ASbGnctp26DVoc3epyIxmY0PW/KWHx/xAvoY0NBnhkHRFLO/tjm/i7w//NC98jcPSXD
	7427ZVWuyaL/tPL+/32XQSoWgbdB8i9r7XtJ6yUWEkrI5pagiDmW9p/iV3wTe3zM0iVLjIlRk/4
	QEVj3l2x9R2HaZFN0NCS/363xJoYXICKrbNy+cUGLvw8iA6JsUjlCwi00c7lI1+G1F9jz4mXb1C
	iGwqI4vKy6HKTw4SP0zs97Kw3KfiPGGN3zbiPQ+Dh4y7isJs9fmvYASDwzBV9Bbbus3NQRxanxr
	O9xl3tj7tCwSHvS7ndYPvV7mxo1RQQ==
X-Received: by 2002:a05:6000:290b:b0:3a4:e56a:48c1 with SMTP id ffacd0b85a97d-3b60dd887c5mr10728667f8f.55.1752854326558;
        Fri, 18 Jul 2025 08:58:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEG8eY3l3bMRx0VqYEgweG61pYJg4M8/p/TELUj2kaHQMcDh4bYCTNo/yMtn+9jQFTN/z3lIQ==
X-Received: by 2002:a05:6000:290b:b0:3a4:e56a:48c1 with SMTP id ffacd0b85a97d-3b60dd887c5mr10728634f8f.55.1752854326038;
        Fri, 18 Jul 2025 08:58:46 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca254d9sm2195509f8f.17.2025.07.18.08.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 08:58:45 -0700 (PDT)
Date: Fri, 18 Jul 2025 17:58:43 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: Re: [PATCH v2] x86: add HPET counter read micro benchmark and
 enable/disable torture tests
Message-ID: <20250718175843.316cb351@fedora>
In-Reply-To: <20250714145055.1487738-1-imammedo@redhat.com>
References: <20250714145055.1487738-1-imammedo@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 16:50:55 +0200
Igor Mammedov <imammedo@redhat.com> wrote:

> test is to be used for benchmarking/validating HPET main counter reading

ignore this one as well, I've just sent v3 with a few fixes

> 
> how to run:
>    QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
> where X is desired (max) number of logical CPUs on host
> 
> it will 1st execute concurrent read benchmark
> and after that it will run torture test enabling/disabling HPET counter,
> while running readers in parallel. Goal is to verify counter that always
> goes up.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> v2:
>    * fix broken timer going backwards check
>    * report # of fails
>    * warn if number of vcpus is not sufficient for torture test and skip
>      it
>    * style fixups
> ---
>  x86/Makefile.common  |  2 ++
>  x86/hpet_read_test.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
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
> index 00000000..a14194e6
> --- /dev/null
> +++ b/x86/hpet_read_test.c
> @@ -0,0 +1,73 @@
> +#include "libcflat.h"
> +#include "smp.h"
> +#include "asm/barrier.h"
> +#include "x86/atomic.h"
> +
> +#define HPET_ADDR         0xFED00000L
> +#define HPET_COUNTER_ADDR ((uint8_t *)HPET_ADDR + 0xF0UL)
> +#define HPET_CONFIG_ADDR  ((uint8_t *)HPET_ADDR + 0x10UL)
> +#define HPET_ENABLE_BIT   0x01UL
> +#define HPET_CLK_PERIOD   10
> +
> +static atomic_t fail;
> +
> +static void hpet_reader(void *data)
> +{
> +	uint64_t old_counter = 0, new_counter;
> +	long cycles = (long)data;
> +
> +	while (cycles--) {
> +		new_counter = *(volatile uint64_t *)HPET_COUNTER_ADDR;
> +		if (new_counter < old_counter) {
> +			atomic_inc(&fail);
> +		}
> +		old_counter = new_counter;
> +	}
> +}
> +
> +static void hpet_writer(void *data)
> +{
> +	int i;
> +	long cycles = (long)data;
> +
> +	for (i = 0; i < cycles; ++i)
> +		if (i % 2)
> +			*(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
> +		else
> +			*(volatile uint64_t *)HPET_CONFIG_ADDR &= ~HPET_ENABLE_BIT;
> +}
> +
> +int main(void)
> +{
> +	long cycles = 100000;
> +	int i;
> +	int ncpus;
> +	uint64_t start, end, time_ns;
> +
> +	ncpus = cpu_count();
> +	do {
> +		printf("* starting concurrent read bench on %d cpus\n", ncpus);
> +		*(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
> +		start = *(volatile uint64_t *)HPET_COUNTER_ADDR;
> +		on_cpus(hpet_reader, (void *)cycles);
> +		end = (*(volatile uint64_t *)HPET_COUNTER_ADDR);
> +		time_ns = (end - start) * HPET_CLK_PERIOD;
> +		report(time_ns && !atomic_read(&fail),
> +			"read test took %lu ms, avg read: %lu ns\n", time_ns/1000000,  time_ns/cycles);
> +	} while (0);
> +
> +	do {
> +		printf("* starting enable/disable with concurent readers torture\n");
> +		if (ncpus > 2) {
> +			for (i = 2; i < ncpus; i++)
> +			    on_cpu_async(i, hpet_reader, (void *)cycles);
> +
> +			on_cpu(1, hpet_writer, (void *)cycles);
> +			report(!atomic_read(&fail), "torture test, fails: %u\n", atomic_read(&fail));
> +		} else {
> +			printf("SKIP: torture test: '-smp X' should be greater than 2\n");
> +	}
> +	} while (0);
> +
> +	return report_summary();
> +}


