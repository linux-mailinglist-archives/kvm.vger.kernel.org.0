Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D346B12E9B2
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 19:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgABSGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 13:06:05 -0500
Received: from foss.arm.com ([217.140.110.172]:49112 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgABSGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 13:06:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61448328;
        Thu,  2 Jan 2020 10:06:04 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0538E3F703;
        Thu,  2 Jan 2020 10:06:02 -0800 (PST)
Date:   Thu, 2 Jan 2020 18:03:24 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 03/18] lib: Add WRITE_ONCE and
 READ_ONCE implementations in compiler.h
Message-ID: <20200102180324.085a136e@donnerap.cambridge.arm.com>
In-Reply-To: <1577808589-31892-4-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-4-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Dec 2019 16:09:34 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Add the WRITE_ONCE and READ_ONCE macros which are used to prevent the
> compiler from optimizing a store or a load, respectively, into something
> else.

Compared to the Linux version and found to be equivalent:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> Cc: Drew Jones <drjones@redhat.com>
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/linux/compiler.h | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
>  create mode 100644 lib/linux/compiler.h
> 
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> new file mode 100644
> index 000000000000..2d72f18c36e5
> --- /dev/null
> +++ b/lib/linux/compiler.h
> @@ -0,0 +1,83 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Taken from Linux commit 219d54332a09 ("Linux 5.4"), from the file
> + * tools/include/linux/compiler.h, with minor changes.
> + */
> +#ifndef __LINUX_COMPILER_H
> +#define __LINUX_COMPILER_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <stdint.h>
> +
> +#define barrier()	asm volatile("" : : : "memory")
> +
> +#define __always_inline	inline __attribute__((always_inline))
> +
> +static __always_inline void __read_once_size(const volatile void *p, void *res, int size)
> +{
> +	switch (size) {
> +	case 1: *(uint8_t *)res = *(volatile uint8_t *)p; break;
> +	case 2: *(uint16_t *)res = *(volatile uint16_t *)p; break;
> +	case 4: *(uint32_t *)res = *(volatile uint32_t *)p; break;
> +	case 8: *(uint64_t *)res = *(volatile uint64_t *)p; break;
> +	default:
> +		barrier();
> +		__builtin_memcpy((void *)res, (const void *)p, size);
> +		barrier();
> +	}
> +}
> +
> +/*
> + * Prevent the compiler from merging or refetching reads or writes. The
> + * compiler is also forbidden from reordering successive instances of
> + * READ_ONCE and WRITE_ONCE, but only when the compiler is aware of some
> + * particular ordering. One way to make the compiler aware of ordering is to
> + * put the two invocations of READ_ONCE or WRITE_ONCE in different C
> + * statements.
> + *
> + * These two macros will also work on aggregate data types like structs or
> + * unions. If the size of the accessed data type exceeds the word size of
> + * the machine (e.g., 32 bits or 64 bits) READ_ONCE() and WRITE_ONCE() will
> + * fall back to memcpy and print a compile-time warning.
> + *
> + * Their two major use cases are: (1) Mediating communication between
> + * process-level code and irq/NMI handlers, all running on the same CPU,
> + * and (2) Ensuring that the compiler does not fold, spindle, or otherwise
> + * mutilate accesses that either do not require ordering or that interact
> + * with an explicit memory barrier or atomic instruction that provides the
> + * required ordering.
> + */
> +
> +#define READ_ONCE(x)					\
> +({							\
> +	union { typeof(x) __val; char __c[1]; } __u =	\
> +		{ .__c = { 0 } };			\
> +	__read_once_size(&(x), __u.__c, sizeof(x));	\
> +	__u.__val;					\
> +})
> +
> +static __always_inline void __write_once_size(volatile void *p, void *res, int size)
> +{
> +	switch (size) {
> +	case 1: *(volatile uint8_t *) p = *(uint8_t  *) res; break;
> +	case 2: *(volatile uint16_t *) p = *(uint16_t *) res; break;
> +	case 4: *(volatile uint32_t *) p = *(uint32_t *) res; break;
> +	case 8: *(volatile uint64_t *) p = *(uint64_t *) res; break;
> +	default:
> +		barrier();
> +		__builtin_memcpy((void *)p, (const void *)res, size);
> +		barrier();
> +	}
> +}
> +
> +#define WRITE_ONCE(x, val)				\
> +({							\
> +	union { typeof(x) __val; char __c[1]; } __u =	\
> +		{ .__val = (val) }; 			\
> +	__write_once_size(&(x), __u.__c, sizeof(x));	\
> +	__u.__val;					\
> +})
> +
> +#endif /* !__ASSEMBLY__ */
> +#endif /* !__LINUX_COMPILER_H */

