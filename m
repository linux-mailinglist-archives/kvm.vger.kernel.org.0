Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84901340BE6
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCRRdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229467AbhCRRca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616088749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5og1yr1tqvFs5wbS70bwULgR4G/77BVByoguDkryFDU=;
        b=HJMXKR4iXcT2RYsxid5+DiVU6aBPo9CzI0P2KU9WQfp7IM/8JQZXwjSNCNxUhLkb+aXLm4
        GaeWGOddvR2oDziD8IK1i7/x8R0URTgCctgx1kJGQYC9Oa5GwlO3u7MY3JR7/t3ROV6zVG
        /SIKSX04VG8F3Y9Q/FmiHaX6Yrxk100=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-__qF_4xuNYyRtjGkfzQypQ-1; Thu, 18 Mar 2021 13:32:28 -0400
X-MC-Unique: __qF_4xuNYyRtjGkfzQypQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8D211927800;
        Thu, 18 Mar 2021 17:32:26 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E7925D9CA;
        Thu, 18 Mar 2021 17:32:26 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id D7A234188684; Thu, 18 Mar 2021 13:57:56 -0300 (-03)
Date:   Thu, 18 Mar 2021 13:57:56 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
Message-ID: <20210318165756.GA36190@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318140949.1065740-1-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 03:09:49PM +0100, Vitaly Kuznetsov wrote:
> Introduce a new selftest for Hyper-V clocksources (MSR-based reference TSC
> and TSC page). As a starting point, test the following:
> 1) Reference TSC is 1Ghz clock.
> 2) Reference TSC and TSC page give the same reading.
> 3) TSC page gets updated upon KVM_SET_CLOCK call.
> 4) TSC page does not get updated when guest opted for reenlightenment.
> 5) Disabled TSC page doesn't get updated.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/hyperv_clock.c       | 233 ++++++++++++++++++
>  3 files changed, 235 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 32b87cc77c8e..22be05c55f13 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -9,6 +9,7 @@
>  /x86_64/evmcs_test
>  /x86_64/get_cpuid_test
>  /x86_64/kvm_pv_test
> +/x86_64/hyperv_clock
>  /x86_64/hyperv_cpuid
>  /x86_64/mmio_warning_test
>  /x86_64/platform_info_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a6d61f451f88..c3672e9087d3 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_ha
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
> +TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> new file mode 100644
> index 000000000000..39d6491d8458
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> @@ -0,0 +1,233 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021, Red Hat, Inc.
> + *
> + * Tests for Hyper-V clocksources
> + */
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +struct ms_hyperv_tsc_page {
> +	volatile u32 tsc_sequence;
> +	u32 reserved1;
> +	volatile u64 tsc_scale;
> +	volatile s64 tsc_offset;
> +} __packed;
> +
> +#define HV_X64_MSR_GUEST_OS_ID			0x40000000
> +#define HV_X64_MSR_TIME_REF_COUNT		0x40000020
> +#define HV_X64_MSR_REFERENCE_TSC		0x40000021
> +#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
> +#define HV_X64_MSR_REENLIGHTENMENT_CONTROL	0x40000106
> +#define HV_X64_MSR_TSC_EMULATION_CONTROL	0x40000107
> +
> +/* Simplified mul_u64_u64_shr() */
> +static inline u64 mul_u64_u64_shr64(u64 a, u64 b)
> +{
> +	union {
> +		u64 ll;
> +		struct {
> +			u32 low, high;
> +		} l;
> +	} rm, rn, rh, a0, b0;
> +	u64 c;
> +
> +	a0.ll = a;
> +	b0.ll = b;
> +
> +	rm.ll = (u64)a0.l.low * b0.l.high;
> +	rn.ll = (u64)a0.l.high * b0.l.low;
> +	rh.ll = (u64)a0.l.high * b0.l.high;
> +
> +	rh.l.low = c = rm.l.high + rn.l.high + rh.l.low;
> +	rh.l.high = (c >> 32) + rh.l.high;
> +
> +	return rh.ll;
> +}
> +
> +static inline void nop_loop(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < 1000000; i++)
> +		asm volatile("nop");
> +}
> +
> +static inline void check_tsc_msr_rdtsc(void)
> +{
> +	u64 tsc_freq, r1, r2, t1, t2;
> +	s64 delta_ns;
> +
> +	tsc_freq = rdmsr(HV_X64_MSR_TSC_FREQUENCY);
> +	GUEST_ASSERT(tsc_freq > 0);
> +
> +	/* First, check MSR-based clocksource */
> +	r1 = rdtsc();
> +	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
> +	nop_loop();
> +	r2 = rdtsc();
> +	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
> +
> +	GUEST_ASSERT(t2 > t1);
> +
> +	/* HV_X64_MSR_TIME_REF_COUNT is in 100ns */
> +	delta_ns = ((t2 - t1) * 100) - ((r2 - r1) * 1000000000 / tsc_freq);
> +	if (delta_ns < 0)
> +		delta_ns = -delta_ns;

I think this should be monotonically increasing: 

1.	r1 = rdtsc();
2.	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
3.	nop_loop();
4.	r2 = rdtsc();
5.	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);	

	=>

	r1 <= t1 <= r2 <= t2

> +
> +	/* 1% tolerance */
> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
> +}

Doesnt an unbounded schedule-out/schedule-in (which resembles
overloaded host) of the qemu-kvm vcpu in any of the 
points 1,2,3,4,5 break the assertion above?


