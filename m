Return-Path: <kvm+bounces-51608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E35AF974C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C89BB5A2E06
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F4D2C325E;
	Fri,  4 Jul 2025 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XYZDoMik"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C09428FAA8
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751644318; cv=none; b=Qp867EG1FfGUjllHz1ldWz2KWOaR8Mo0EPxOzLpGqnQsfzXu56E+WKs4RZ3d7xyrUqUOG6eFYTqltAwEwPPAJgKksIkUvCvhbebL+XUghzP4LL89r+r8E6FkmbgSdZT+qdLhYGOv91m4IKo9DfuIpixgdr1TAFY0Zoh5QouKTxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751644318; c=relaxed/simple;
	bh=0Jwsy4fiElH6DjxL7xP6HCU8+ooiuLGdI/EPlkcomSE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s+Pdn++UbFPEHu7N2ANI3IJWEK1HNnDHbOVnXo5dRIWh6u404a6najA+q4uw3NZO+b5F0PKT87bo+FpkpNJ4eVP6P2eqUUtJWJoEH4yB0ai/vMaUmaS8Br8Eq87NbWlfSQSY0ZaonMjFvDGWLhLifQUqpJmcb/Ka4xtgQZRO8KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XYZDoMik; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751644315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LNHDXPppGfzkBTHyYPJuKgKu3xjCUfj1+0Tl2jyPYg=;
	b=XYZDoMikfrWr6ru69yLG7YPdJm+qIadGTME0SdHFGvm9nm8tMXfDYuDqmdCxCDxXInam+F
	W9lGK0rTCLRYNqltbuY3GWCoy1wP/NoVCuGJ38jVXFzIeM864onO6/WiDq17umk5+pwzRX
	b6K1RGQw+kVZPstCbs5PjCdTjizHVug=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-RS99RpOuOLyzT1g7APxJeg-1; Fri, 04 Jul 2025 11:51:54 -0400
X-MC-Unique: RS99RpOuOLyzT1g7APxJeg-1
X-Mimecast-MFC-AGG-ID: RS99RpOuOLyzT1g7APxJeg_1751644313
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so5416615e9.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 08:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751644312; x=1752249112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5LNHDXPppGfzkBTHyYPJuKgKu3xjCUfj1+0Tl2jyPYg=;
        b=NSCOrWtccE/rlN9XOOMetXN+tzG5V+xb7KAYER6H/5hpAsX9clm2CYkx5XlMeRDLB4
         Q6wafvmFH5DUOMaWEjvt60EsXARiA/Y9aIILKHn7dIClw11CIKLtECQ0x7DXfLW62U1q
         dyxVjvRRTPjM1b7doxZz6LlxCJ1MJRgXbdwMaNnvjfx+1GrJ1c3+UWGK/QfGAQA/C13I
         ajrMH6xWD/MibmsCUPdy0PRZvqy7Pi2Rfu+ViQghPwl9MbcaYKyfdUyusmHzYhhckG2W
         Jpg/RmSltQ25dNN7AL6bKw+JZddqZlKdisa159NhSfZ25gDaUzATBaFFrgh1ei5kGP/O
         DU1g==
X-Gm-Message-State: AOJu0YyKC1x6sU6Knc7MASiwc6E8vnVrtBVxSIpLuO4GTZUjO49rsd9N
	f0+Ytll/ybgPUkZbnLpw1xwvI8FeryX4GmP3V7M8u4YBia65+x8cSNheXpdS6a6ksIxMu98+FEm
	1sCNiPQIk1w7cMu8ZneGC32yRQkdKn+/nKxxjxZyCQWkphZGBQakEO8W9cUXef48U8pr5NxGr+A
	nmhRp7cew3w5Ftu/10vTVWfBxrQCvv8lOlUKuB0g==
X-Gm-Gg: ASbGncuIDwNsC1OGBLY+IgFHHfaZUw9QsuhXognFIMIyYsisWC8YhkIp9hDKOVWEVf4
	/cnhmA6oeW/OHf2W4G9z2MXPwB3cWARmfJ1kNmBJvRfYcEDbygIN6u0wSrBSLRMm+ktjSZClrEd
	als/Fn4zWeBDbkzAJLKeZBxxp5kCAu84tF/LD91dKhH3IUJI5mszAbLfHFSc5etWpRpZLGpLL9V
	xTVk2H2enW53x3zPdo4Ce3/XILPNWCC5oHXZ31m1UBpjrTgwyim9CAdg9MeYDvMNRrcK18bbSO0
	mE5rkOqIiMSW
X-Received: by 2002:a05:600c:c0dc:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-454b32084damr29429015e9.16.1751644312454;
        Fri, 04 Jul 2025 08:51:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjqvUWFrrs4pWgudtRSkdHM9ILdrauvKj3DcK34w/KsTtsAq33aMoWkIoOd1nUBl9GvkakvA==
X-Received: by 2002:a05:600c:c0dc:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-454b32084damr29428715e9.16.1751644311850;
        Fri, 04 Jul 2025 08:51:51 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b161e8f1sm30127775e9.8.2025.07.04.08.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 08:51:51 -0700 (PDT)
Date: Fri, 4 Jul 2025 17:51:50 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: add HPET counter read micro
 benchmark and enable/disable torture tests
Message-ID: <20250704175150.1555b5a0@fedora>
In-Reply-To: <20250702145123.1313738-1-imammedo@redhat.com>
References: <20250702145123.1313738-1-imammedo@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  2 Jul 2025 16:51:23 +0200
Igor Mammedov <imammedo@redhat.com> wrote:

> test is to be used for benchmarking/validating HPET main counter read
> 
> how to run:
>    QEMU=/foo/qemu-system-x86_64 x86/run x86/hpet_read_test.flat -smp X
> where X is max number of logical CPUs on host
> 
> it will 1st execute concurrent read benchmark
> and after that it will run torture test enabling/disabling HPET counter,
> while running readers in parallel. Goal is to verify counter that always
> goes up.

ignore that, fail check in torture test is broken.
I'll send fixed v2 later on

> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> this also will be used for testing upcomming HPET fain-grained
> locking QEMU series  
> 
> ---
>  x86/Makefile.common  |  2 ++
>  x86/hpet_read_test.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
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
> index 00000000..2f56ab6b
> --- /dev/null
> +++ b/x86/hpet_read_test.c
> @@ -0,0 +1,66 @@
> +#include "libcflat.h"
> +#include "smp.h"
> +
> +#define HPET_ADDR         0xFED00000L
> +#define HPET_COUNTER_ADDR ((uint8_t *)HPET_ADDR + 0xF0UL)
> +#define HPET_CONFIG_ADDR  ((uint8_t *)HPET_ADDR + 0x10UL)
> +#define HPET_ENABLE_BIT   0x01UL
> +#define HPET_CLK_PERIOD   10
> +
> +static int fail = 0;
> +static void hpet_reader(void *data)
> +{
> +    long cycles = (long)data;
> +
> +    while (cycles--) {
> +        uint64_t old_counter = 0, new_counter;
> +        new_counter = *(volatile uint64_t *)HPET_COUNTER_ADDR;
> +        if (new_counter < old_counter) {
> +            fail = 1;
> +            report_abort("HPET counter jumped back");
> +        }
> +    }
> +}
> +
> +
> +static void hpet_writer(void *data)
> +{
> +    int i;
> +    long cycles = (long)data;
> +
> +    for (i = 0; i < cycles; ++i)
> +        if (i % 2)
> +            *(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
> +        else
> +            *(volatile uint64_t *)HPET_CONFIG_ADDR &= ~HPET_ENABLE_BIT;
> +}
> +
> +int main(void)
> +{
> +    long cycles = 100000;
> +    int i;
> +    int ncpus;
> +    uint64_t start, end, time_ns;
> +
> +    ncpus = cpu_count();
> +    do {
> +        printf("starting concurrent read bench on %d cpus\n", ncpus);
> +        *(volatile uint64_t *)HPET_CONFIG_ADDR |= HPET_ENABLE_BIT;
> +        start = *(volatile uint64_t *)HPET_COUNTER_ADDR;
> +        on_cpus(hpet_reader, (void *)cycles);
> +        end = (*(volatile uint64_t *)HPET_COUNTER_ADDR);
> +        time_ns = (end - start) * HPET_CLK_PERIOD;
> +        report(time_ns, "read test took %lu ms\n", time_ns/1000000);
> +    } while (0);
> +
> +    do {
> +        printf("starting enable/disable with concurent readers torture\n");
> +        for (i = 2; i < ncpus; i++)
> +            on_cpu_async(i, hpet_reader, (void *)cycles);
> +
> +        on_cpu(1, hpet_writer, (void *)cycles);
> +    } while (0);
> +
> +    report(!fail, "passed torture test\n");
> +    return report_summary();
> +}


