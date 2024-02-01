Return-Path: <kvm+bounces-7676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DF848452B9
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17D031F26910
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A684115958A;
	Thu,  1 Feb 2024 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vqrf47uk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83B7158D99
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776183; cv=none; b=rHvvHfPRb3tgX/t3LERH2OKUk9yJyVRFrcbgVJowRRTdL7/BCQ4ZGp6P85XzVqJKA3A1PjuXa6JceZHG84ZiiNwER7JrcHNtV11wi087wBrYvzZ18WBs94jxFeKcq2OjpDJ6ELbiDV4g1GAIBCkjk7K1TA+Cwr1hsxzSL7yVZII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776183; c=relaxed/simple;
	bh=utEU7qYJ8ia24gnEKKVakGa8QJNp6CosTAsUSublTLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KWJTCiZN92/85utRMIyHhU1GG6u8Hm4JbiiPn2dQKd0iKQn4vMAXPMSRJTnC78HTVieEbJstzIWZupmK8OBhcYF7lQN8cyAoJ6LzPXa/2WmqnA/0/TdLrmDNZZY4vj7PlCHdNLF6niCCWK9J1bxXYGfCQS3udwUer1rlqffWJxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vqrf47uk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776180;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ke6tcmQD8vPDAqvCxbyqKcdEDJu6RhW5sq70XTDkHTI=;
	b=Vqrf47ukEFJN7ZppywtcAUCk2M6lsI+tJOt1vbuwvwKtlI2guQRcsCsKys1bdSeHcuSHgZ
	hYp7KM3pgah0JElB5xW4kHRECmzUa4qYRbfXYMVDxRW0XlPrvN2mdbJfNRfXdMkuteMcFA
	wnkGPfqcSKIs4HBsK8OdKIAG9U0HH1s=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-aXmbvl8RPPix7izUxD0zsw-1; Thu, 01 Feb 2024 03:29:39 -0500
X-MC-Unique: aXmbvl8RPPix7izUxD0zsw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-510222349b0so514924e87.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 00:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776178; x=1707380978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ke6tcmQD8vPDAqvCxbyqKcdEDJu6RhW5sq70XTDkHTI=;
        b=LPPplgXGAc5dWwghxL1lJGO2+mpylKlA3wc1QnBMoenvybzw8Ol9LjH/kDe0MGWVMj
         8rIScdu+6KatIp10n4vhMnhz+wOw7klVCqaFFS8jwe4ctFxOf2Ir0f/7KHSPKYyLIFOV
         tuBNCjPP4g/ceQgBZpnBGRYIvu613f7at6q8kjcbxZ2R1Efx+c4RrCygSOcxeHQLPJ0r
         DQjS4j0TZexBRiXbLKWv7vA/i4YLzFcigzOE79ECLP1VhAay+HbBYUcMtgYySlPKSTPK
         3HGDf9/7XnaL77a4aEU9g0RBAw3e9Tw8o4zE2K3fQrnNJJXm3Rd3HN//XEap9zCt+Rha
         OC1Q==
X-Gm-Message-State: AOJu0YwENvW062GmdxdV5fuHw1V/cwwngK/VrBC/xCvs5ut+vYoPF2nD
	pMRCoVdI7aC25rYpykMzWItWdtzyRTCmLIuTWjBFjtSAb6s27RGaN7D0vQnyjrCPVJ8ZtLMxH/r
	0I+j1u67BQSXonpoKqum4hwJAGFvvVI1/TIc4CeIG4kjpTarolQ==
X-Received: by 2002:a19:ca49:0:b0:511:8cc:7477 with SMTP id h9-20020a19ca49000000b0051108cc7477mr1053033lfj.50.1706776177861;
        Thu, 01 Feb 2024 00:29:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmK87FtwRResZ2kC+8PmRtfUzn/yFH9y+/R5t1YtvcJstNgo7QZukPsq7uBLMLUwXOi+dszw==
X-Received: by 2002:a19:ca49:0:b0:511:8cc:7477 with SMTP id h9-20020a19ca49000000b0051108cc7477mr1053018lfj.50.1706776177508;
        Thu, 01 Feb 2024 00:29:37 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXJ9AXqCrr0LevM5KBWnQbt5ICQm7Ue655mVEkMt7+WZmiPazdpWHk/Nv13t6C2bAvQwnZOYkBuz2LCDDJdWQiVhgdt05rDAm9L6Y2NjIJqknwMdHvWHIKntGZc1gLaX4vdoEHyHb1jaeKj0i5Ac3opUdP8jXcBnjqB+NauNmkkQ9QR1aYUYPFe0/y0OysVcoXXGbA3YtG2gUX7F/a8C5ypNX9kM+e9a1hMREg1n8bg9LwRZkMEYd7ARcLD1Q/jHAoUJ1rTBqtzKijayhaVjGPVK1Q4WY22kvKEP1GpmR77qiPpC5otX9k=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a1c790c000000b0040fba120c0bsm446368wme.0.2024.02.01.00.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:37 -0800 (PST)
Message-ID: <b015765b-9833-4879-88fd-1c457b9c292f@redhat.com>
Date: Thu, 1 Feb 2024 09:29:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 02/24] riscv: Initial port, hello world
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-28-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-28-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> Add the minimal amount of code possible in order to launch a first
> test, which just prints "Hello, world" using the expected UART
> address of the QEMU virt machine. Add files, stubs, and some support,
> such as barriers and MMIO read/write along the way in order to
> satisfy the compiler. Basically everything is either copied from
> the arm64 port of kvm-unit-tests, or at least inspired by it, and,
> in that case, the RISC-V Linux kernel code was copied.
>
> Run with
>   qemu-system-riscv64 -nographic -M virt -kernel riscv/selftest.flat
>
> and then go to the monitor (ctrl-a c) and use 'q' to quit, since
> the unit test will just hang after printing hello world and the
> exit code.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>
> ---
>  configure                   | 14 ++++++
>  lib/riscv/.gitignore        |  1 +
>  lib/riscv/asm-offsets.c     |  6 +++
>  lib/riscv/asm/asm-offsets.h |  1 +
>  lib/riscv/asm/barrier.h     | 13 ++++++
>  lib/riscv/asm/csr.h         |  7 +++
>  lib/riscv/asm/io.h          | 78 +++++++++++++++++++++++++++++++
>  lib/riscv/asm/page.h        |  7 +++
>  lib/riscv/asm/setup.h       |  7 +++
>  lib/riscv/asm/spinlock.h    |  7 +++
>  lib/riscv/asm/stack.h       |  9 ++++
>  lib/riscv/io.c              | 44 ++++++++++++++++++
>  lib/riscv/setup.c           | 12 +++++
>  riscv/Makefile              | 83 +++++++++++++++++++++++++++++++++
>  riscv/cstart.S              | 92 +++++++++++++++++++++++++++++++++++++
>  riscv/flat.lds              | 75 ++++++++++++++++++++++++++++++
>  riscv/selftest.c            | 13 ++++++
>  17 files changed, 469 insertions(+)
>  create mode 100644 lib/riscv/.gitignore
>  create mode 100644 lib/riscv/asm-offsets.c
>  create mode 100644 lib/riscv/asm/asm-offsets.h
>  create mode 100644 lib/riscv/asm/barrier.h
>  create mode 100644 lib/riscv/asm/csr.h
>  create mode 100644 lib/riscv/asm/io.h
>  create mode 100644 lib/riscv/asm/page.h
>  create mode 100644 lib/riscv/asm/setup.h
>  create mode 100644 lib/riscv/asm/spinlock.h
>  create mode 100644 lib/riscv/asm/stack.h
>  create mode 100644 lib/riscv/io.c
>  create mode 100644 lib/riscv/setup.c
>  create mode 100644 riscv/Makefile
>  create mode 100644 riscv/cstart.S
>  create mode 100644 riscv/flat.lds
>  create mode 100644 riscv/selftest.c
>
> diff --git a/configure b/configure
> index ada6512702a1..05e6702eab06 100755
> --- a/configure
> +++ b/configure
> @@ -200,6 +200,11 @@ arch_name=$arch
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
>  arch_libdir=$arch
>  
> +if [ "$arch" = "riscv" ]; then
> +    echo "riscv32 or riscv64 must be specified"
> +    exit 1
> +fi
> +
>  if [ -z "$target" ]; then
>      target="qemu"
>  else
> @@ -307,6 +312,9 @@ elif [ "$arch" = "ppc64" ]; then
>          echo "You must provide endianness (big or little)!"
>          usage
>      fi
> +elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
> +    testdir=riscv
> +    arch_libdir=riscv
>  else
>      testdir=$arch
>  fi
> @@ -438,6 +446,12 @@ cat <<EOF >> lib/config.h
>  #define CONFIG_ERRATA_FORCE ${errata_force}
>  #define CONFIG_PAGE_SIZE _AC(${page_size}, UL)
>  
> +EOF
> +elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
> +cat <<EOF >> lib/config.h
> +
> +#define CONFIG_UART_EARLY_BASE 0x10000000
> +
>  EOF
>  fi
>  echo "#endif" >> lib/config.h
> diff --git a/lib/riscv/.gitignore b/lib/riscv/.gitignore
> new file mode 100644
> index 000000000000..82da12e6bd4e
> --- /dev/null
> +++ b/lib/riscv/.gitignore
> @@ -0,0 +1 @@
> +/asm-offsets.[hs]
> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
> new file mode 100644
> index 000000000000..4a74df9e4a09
> --- /dev/null
> +++ b/lib/riscv/asm-offsets.c
> @@ -0,0 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +int main(void)
> +{
> +	return 0;
> +}
> diff --git a/lib/riscv/asm/asm-offsets.h b/lib/riscv/asm/asm-offsets.h
> new file mode 100644
> index 000000000000..d370ee36a182
> --- /dev/null
> +++ b/lib/riscv/asm/asm-offsets.h
> @@ -0,0 +1 @@
> +#include <generated/asm-offsets.h>
> diff --git a/lib/riscv/asm/barrier.h b/lib/riscv/asm/barrier.h
> new file mode 100644
> index 000000000000..c6a09066b2c7
> --- /dev/null
> +++ b/lib/riscv/asm/barrier.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_BARRIER_H_
> +#define _ASMRISCV_BARRIER_H_
> +
> +#define RISCV_FENCE(p, s) \
> +	__asm__ __volatile__ ("fence " #p "," #s : : : "memory")
> +
> +/* These barriers need to enforce ordering on both devices or memory. */
> +#define mb()		RISCV_FENCE(iorw,iorw)
> +#define rmb()		RISCV_FENCE(ir,ir)
> +#define wmb()		RISCV_FENCE(ow,ow)
> +
> +#endif /* _ASMRISCV_BARRIER_H_ */
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> new file mode 100644
> index 000000000000..5c4f2de34f64
> --- /dev/null
> +++ b/lib/riscv/asm/csr.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_CSR_H_
> +#define _ASMRISCV_CSR_H_
> +
> +#define CSR_SSCRATCH		0x140
> +
> +#endif /* _ASMRISCV_CSR_H_ */
> diff --git a/lib/riscv/asm/io.h b/lib/riscv/asm/io.h
> new file mode 100644
> index 000000000000..d2eb3acc9fda
> --- /dev/null
> +++ b/lib/riscv/asm/io.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * From Linux arch/riscv/include/asm/mmio.h
> + */
> +#ifndef _ASMRISCV_IO_H_
> +#define _ASMRISCV_IO_H_
> +#include <libcflat.h>
> +
> +#define __iomem
> +
> +/* Generic IO read/write.  These perform native-endian accesses. */
> +#define __raw_writeb __raw_writeb
> +static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
> +{
> +	asm volatile("sb %0, 0(%1)" : : "r" (val), "r" (addr));
> +}
> +
> +#define __raw_writew __raw_writew
> +static inline void __raw_writew(u16 val, volatile void __iomem *addr)
> +{
> +	asm volatile("sh %0, 0(%1)" : : "r" (val), "r" (addr));
> +}
> +
> +#define __raw_writel __raw_writel
> +static inline void __raw_writel(u32 val, volatile void __iomem *addr)
> +{
> +	asm volatile("sw %0, 0(%1)" : : "r" (val), "r" (addr));
> +}
> +
> +#ifdef CONFIG_64BIT
> +#define __raw_writeq __raw_writeq
> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> +{
> +	asm volatile("sd %0, 0(%1)" : : "r" (val), "r" (addr));
> +}
> +#endif
> +
> +#define __raw_readb __raw_readb
> +static inline u8 __raw_readb(const volatile void __iomem *addr)
> +{
> +	u8 val;
> +
> +	asm volatile("lb %0, 0(%1)" : "=r" (val) : "r" (addr));
> +	return val;
> +}
> +
> +#define __raw_readw __raw_readw
> +static inline u16 __raw_readw(const volatile void __iomem *addr)
> +{
> +	u16 val;
> +
> +	asm volatile("lh %0, 0(%1)" : "=r" (val) : "r" (addr));
> +	return val;
> +}
> +
> +#define __raw_readl __raw_readl
> +static inline u32 __raw_readl(const volatile void __iomem *addr)
> +{
> +	u32 val;
> +
> +	asm volatile("lw %0, 0(%1)" : "=r" (val) : "r" (addr));
> +	return val;
> +}
> +
> +#ifdef CONFIG_64BIT
> +#define __raw_readq __raw_readq
> +static inline u64 __raw_readq(const volatile void __iomem *addr)
> +{
> +	u64 val;
> +
> +	asm volatile("ld %0, 0(%1)" : "=r" (val) : "r" (addr));
> +	return val;
> +}
> +#endif
> +
> +#include <asm-generic/io.h>
> +
> +#endif /* _ASMRISCV_IO_H_ */
> diff --git a/lib/riscv/asm/page.h b/lib/riscv/asm/page.h
> new file mode 100644
> index 000000000000..7d7c9191605a
> --- /dev/null
> +++ b/lib/riscv/asm/page.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_PAGE_H_
> +#define _ASMRISCV_PAGE_H_
> +
> +#include <asm-generic/page.h>
> +
> +#endif /* _ASMRISCV_PAGE_H_ */
> diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
> new file mode 100644
> index 000000000000..385455f341cc
> --- /dev/null
> +++ b/lib/riscv/asm/setup.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_SETUP_H_
> +#define _ASMRISCV_SETUP_H_
> +
> +void setup(const void *fdt, phys_addr_t freemem_start);
> +
> +#endif /* _ASMRISCV_SETUP_H_ */
> diff --git a/lib/riscv/asm/spinlock.h b/lib/riscv/asm/spinlock.h
> new file mode 100644
> index 000000000000..6e2b3009abf3
> --- /dev/null
> +++ b/lib/riscv/asm/spinlock.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_SPINLOCK_H_
> +#define _ASMRISCV_SPINLOCK_H_
> +
> +#include <asm-generic/spinlock.h>
> +
> +#endif /* _ASMRISCV_SPINLOCK_H_ */
> diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
> new file mode 100644
> index 000000000000..d081d0716d7b
> --- /dev/null
> +++ b/lib/riscv/asm/stack.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_STACK_H_
> +#define _ASMRISCV_STACK_H_
> +
> +#ifndef _STACK_H_
> +#error Do not directly include <asm/stack.h>. Just use <stack.h>.
> +#endif
> +
> +#endif
> diff --git a/lib/riscv/io.c b/lib/riscv/io.c
> new file mode 100644
> index 000000000000..3cfc235d19a6
> --- /dev/null
> +++ b/lib/riscv/io.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Each architecture must implement puts() and exit() with the I/O
> + * devices exposed from QEMU, e.g. ns16550a.
> + *
> + * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
> + */
> +#include <libcflat.h>
> +#include <config.h>
> +#include <asm/io.h>
> +#include <asm/spinlock.h>
> +
> +/*
> + * Use this guess for the uart base in order to make an attempt at
> + * having earlier printf support. We'll overwrite it with the real
> + * base address that we read from the device tree later. This is
> + * the address we expect the virtual machine manager to put in
> + * its generated device tree.
> + */
> +#define UART_EARLY_BASE ((u8 *)(unsigned long)CONFIG_UART_EARLY_BASE)
> +static volatile u8 *uart0_base = UART_EARLY_BASE;
> +static struct spinlock uart_lock;
> +
> +void puts(const char *s)
> +{
> +	spin_lock(&uart_lock);
> +	while (*s)
> +		writeb(*s++, uart0_base);
> +	spin_unlock(&uart_lock);
> +}
> +
> +/*
> + * Defining halt to take 'code' as an argument guarantees that it will
> + * be in a0 when we halt. That gives us a final chance to see the exit
> + * status while inspecting the halted unit test state.
> + */
> +void halt(int code);
> +
> +void exit(int code)
> +{
> +	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> +	halt(code);
> +	__builtin_unreachable();
> +}
> diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
> new file mode 100644
> index 000000000000..8937525ccb7f
> --- /dev/null
> +++ b/lib/riscv/setup.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Initialize machine setup information and I/O.
> + *
> + * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
> + */
> +#include <libcflat.h>
> +#include <asm/setup.h>
> +
> +void setup(const void *fdt, phys_addr_t freemem_start)
> +{
> +}
> diff --git a/riscv/Makefile b/riscv/Makefile
> new file mode 100644
> index 000000000000..f2e89f0e4c38
> --- /dev/null
> +++ b/riscv/Makefile
> @@ -0,0 +1,83 @@
> +#
> +# riscv makefile
> +#
> +# Authors: Andrew Jones <ajones@ventanamicro.com>
> +#
> +
> +ifeq ($(CONFIG_EFI),y)
> +exe = efi
> +else
> +exe = flat
> +endif
> +
> +tests =
> +tests += $(TEST_DIR)/selftest.$(exe)
> +#tests += $(TEST_DIR)/sieve.$(exe)
> +
> +all: $(tests)
> +
> +$(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
> +
> +cstart.o = $(TEST_DIR)/cstart.o
> +
> +cflatobjs += lib/riscv/io.o
> +cflatobjs += lib/riscv/setup.o
> +
> +########################################
> +
> +OBJDIRS += lib/riscv
> +FLATLIBS = $(libcflat) $(LIBFDT_archive)
> +
> +AUXFLAGS ?= 0x0
> +
> +# stack.o relies on frame pointers.
> +KEEP_FRAME_POINTER := y
> +
> +# We want to keep intermediate files
> +.PRECIOUS: %.elf %.o
> +
> +define arch_elf_check =
> +	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
> +		$(error $(shell $(READELF) -rW $(1) 2>&1)))
> +	$(if $(shell $(READELF) -rW $(1) | grep R_ | grep -v R_RISCV_RELATIVE),
> +		$(error $(1) has unsupported reloc types))
> +endef
> +
> +ifeq ($(ARCH),riscv64)
> +CFLAGS += -DCONFIG_64BIT
> +endif
> +CFLAGS += -DCONFIG_RELOC
> +CFLAGS += -mcmodel=medany
> +CFLAGS += -mstrict-align
> +CFLAGS += -std=gnu99
> +CFLAGS += -ffreestanding
> +CFLAGS += -O2
> +CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt
> +
> +asm-offsets = lib/riscv/asm-offsets.h
> +include $(SRCDIR)/scripts/asm-offsets.mak
> +
> +ifeq ($(CONFIG_EFI),y)
> +	# TODO
> +else
> +%.elf: LDFLAGS += -pie -n -z notext
> +%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o)
> +	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> +		-DPROGNAME=\"$(notdir $(@:.elf=.flat))\" -DAUXFLAGS=$(AUXFLAGS)
> +	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
> +		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
> +	$(RM) $(@:.elf=.aux.o)
> +	@chmod a-x $@
> +
> +%.flat: %.elf
> +	$(call arch_elf_check, $^)
> +	$(OBJCOPY) -O binary $^ $@
> +	@chmod a-x $@
> +endif
> +
> +generated-files = $(asm-offsets)
> +$(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> +
> +arch_clean: asm_offsets_clean
> +	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
> +	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/riscv/.*.d
> diff --git a/riscv/cstart.S b/riscv/cstart.S
> new file mode 100644
> index 000000000000..a28d75e8021e
> --- /dev/null
> +++ b/riscv/cstart.S
> @@ -0,0 +1,92 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Boot entry point and assembler functions for riscv.
> + *
> + * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
> + */
> +#include <asm/csr.h>
> +
> +.macro zero_range, tmp1, tmp2
For my education what were the tmp3/4 args used for on arm?
> +9998:	beq	\tmp1, \tmp2, 9997f
> +	sd	zero, 0(\tmp1)
> +	addi	\tmp1, \tmp1, 8
> +	j	9998b
> +9997:
> +.endm
> +
> +	.section .init
> +
> +/*
> + * The hartid of the current core is in a0
> + * The address of the devicetree is in a1
> + *
> + * See Linux kernel doc Documentation/riscv/boot.rst
> + */
> +.global start
> +start:
> +	/*
> +	 * Stash the hartid in scratch and shift the dtb
> +	 * address into a0
> +	 */
> +	csrw	CSR_SSCRATCH, a0
> +	mv	a0, a1
> +
> +	/*
> +	 * Update all R_RISCV_RELATIVE relocations using the table
> +	 * of Elf64_Rela entries between reloc_start/end. The build
> +	 * will not emit other relocation types.
> +	 *
> +	 * struct Elf64_Rela {
> +	 * 	uint64_t r_offset;
> +	 * 	uint64_t r_info;
> +	 * 	int64_t  r_addend;
> +	 * }
> +	 */
> +	la	a1, reloc_start
> +	la	a2, reloc_end
> +	la	a3, start			// base
> +1:
> +	bge	a1, a2, 1f
> +	ld	a4, 0(a1)			// r_offset
> +	ld	a5, 16(a1)			// r_addend
> +	add	a4, a3, a4			// addr = base + r_offset
> +	add	a5, a3, a5			// val = base + r_addend
> +	sd	a5, 0(a4)			// *addr = val
> +	addi	a1, a1, 24
> +	j	1b
> +
> +1:
> +	/* zero BSS */
> +	la	a1, bss
> +	la	a2, ebss
> +	zero_range a1, a2
> +
> +	/* zero and set up stack */
> +	la	sp, stacktop
> +	li	a1, -8192
> +	add	a1, sp, a1
> +	zero_range a1, sp
> +
> +	/* set up exception handling */
> +	//TODO
> +
> +	/* complete setup */
> +	la	a1, stacktop			// a1 is the base of free memory
> +	call	setup				// a0 is the addr of the dtb
> +
> +	/* run the test */
> +	la	a0, __argc
> +	ld	a0, 0(a0)
> +	la	a1, __argv
> +	la	a2, __environ
> +	call	main
> +	call	exit
> +	j	halt
> +
> +	.text
> +
> +.balign 4
> +.global halt
> +halt:
> +1:	wfi
> +	j	1b
> diff --git a/riscv/flat.lds b/riscv/flat.lds
> new file mode 100644
> index 000000000000..d4853f82ba1c
> --- /dev/null
> +++ b/riscv/flat.lds
> @@ -0,0 +1,75 @@
> +/*
> + * init::start will pass stacktop to setup() as the base of free memory.
> + * setup() will then move the FDT and initrd to that base before calling
> + * mem_init(). With those movements and this linker script, we'll end up
> + * having the following memory layout:
> + *
> + *    +----------------------+   <-- top of physical memory
> + *    |                      |
> + *    ~                      ~
> + *    |                      |
> + *    +----------------------+   <-- top of initrd
> + *    |                      |
> + *    +----------------------+   <-- top of FDT
> + *    |                      |
> + *    +----------------------+   <-- top of cpu0's stack
> + *    |                      |
> + *    +----------------------+   <-- top of text/data/bss sections
> + *    |                      |
> + *    |                      |
> + *    +----------------------+   <-- load address
> + *    |                      |
> + *    +----------------------+   <-- physical address 0x0
> + */
> +
> +PHDRS
> +{
> +    text PT_LOAD FLAGS(5);
> +    data PT_LOAD FLAGS(6);
> +}
> +
> +SECTIONS
> +{
> +    PROVIDE(_text = .);
> +    .text : { *(.init) *(.text) *(.text.*) } :text
> +    . = ALIGN(4K);
> +    PROVIDE(_etext = .);
> +
> +    PROVIDE(reloc_start = .);
> +    .rela.dyn : { *(.rela.dyn) }
> +    PROVIDE(reloc_end = .);
> +    .dynsym   : { *(.dynsym) }
> +    .dynstr   : { *(.dynstr) }
> +    .hash     : { *(.hash) }
> +    .gnu.hash : { *(.gnu.hash) }
> +    .got      : { *(.got) *(.got.plt) }
> +    .eh_frame : { *(.eh_frame) }
> +
> +    .rodata   : { *(.rodata*) } :data
> +    .data     : { *(.data) } :data
> +    . = ALIGN(16);
> +    PROVIDE(bss = .);
> +    .bss      : { *(.bss) }
> +    . = ALIGN(16);
> +    PROVIDE(ebss = .);
> +    . = ALIGN(4K);
> +    PROVIDE(edata = .);
> +
> +    /*
> +     * stack depth is 8K and sp must be 16 byte aligned
> +     * sp must always be strictly less than the true stacktop
> +     */
> +    . += 12K;
> +    . = ALIGN(4K);
> +    PROVIDE(stackptr = . - 16);
> +    PROVIDE(stacktop = .);
> +
> +    /DISCARD/ : {
> +        *(.note*)
> +        *(.interp)
> +        *(.comment)
> +        *(.dynamic)
> +    }
> +}
> +
> +ENTRY(start)
> diff --git a/riscv/selftest.c b/riscv/selftest.c
> new file mode 100644
> index 000000000000..88afa732649e
> --- /dev/null
> +++ b/riscv/selftest.c
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test the framework itself. These tests confirm that setup works.
> + *
> + * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
> + */
> +#include <libcflat.h>
> +
> +int main(void)
> +{
> +	puts("Hello, world\n");
> +	return 0;
> +}
Thanks

Eric


