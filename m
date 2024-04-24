Return-Path: <kvm+bounces-15756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 001B98B015B
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 07:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B175B21DC1
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 05:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC43115687D;
	Wed, 24 Apr 2024 05:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="lKniXzzB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0C6139CEB
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 05:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713938014; cv=none; b=Gy51+2kBCziZ4D/1l6kj/qV7NE8ZCFOt8Dhf8nmjozHJHGzUzCdGMVoePWhFfBXeSUlud+RbrPo1zM1pAkBc6e5xMBLtvQ5r6ohDRs4ySXBczR5A0ZshM5aNPHEJmBsIIKOphCIXEAO3zhNC+SFlooGWvuV3j/76Ix7Rb+a0a9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713938014; c=relaxed/simple;
	bh=wJepBbC4EBTSzdnLQrnyj97koxDZayQV/v5JB6Y903o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NMAugJxiIWZF6Y+7LoMR4nM0C1cImFcDY/rMoo+uDw/XarTjeLflF+E5zh2zJSy4qHu4MkuDXpu3SX1CA4dxWM//dmtkSlAJPrHhFiBtNN5D5jUEOrSk46CnXu/34SnEEnVXM1//vL6UUQ1nM6j1IKNvFXMGTRuQLWPupfTqaDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=lKniXzzB; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-36a15df0f8cso29271135ab.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 22:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1713938010; x=1714542810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjdP4tihb1cLSoaaW2GzNSUUYZQTSY4+Dd2z8/yY3Cs=;
        b=lKniXzzBmvfa/1FOyw+EIg749jHONt5J/5QlR1xLykX16jkfDhI6TZeKtjjzspkifG
         6TqxDBnEc2tjt2GZkcd1qxfoBpRtNVVwNGiZngiNDqMDVUogTzU+/u0m5mfL77qqhpJi
         fXjgkl5Qjc2gccgS7E7Zzj+507VUeQ7rIBq6jLl8v12EyRFV3v2UjcQY5DYVzWtF//+v
         Ww9PKaRW5sUCwfCersUM6xSMGPiU+2FNUSYuwaoJlytPZNsnKm0eNzD86yJmkgP4VstH
         8EMUsprAfB6Es82Lhjt+0hCGtwfiXbw+EaZtoTtK7bHIU/O6dYmNPuQYVYVM6csFNdfX
         o3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713938010; x=1714542810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CjdP4tihb1cLSoaaW2GzNSUUYZQTSY4+Dd2z8/yY3Cs=;
        b=CG1IFHlNoS+ki5RGAp+U9C0cKUwynh0a49PI0vZAqnOlo9r74643LD38JVGwNR2wdQ
         pzomtO6/pZ1g//FYp2uEmY7u/PRepraTpEzr2Zg5EZwL2rPLaGPUBcAc8Eke4/BvnsoJ
         b6uwnYoFiWqyv6Q0httOhv+qInjIZURRegpXn4ubY+uf1AF8b5577mr2dD5sPlOHoh79
         tCjabk+PfjbHfzoldIFgNH8tSkxEWP55XkHRc5gBZZDmRXgLriCtctt0KaxnPRtjTfgB
         JJbX9rShTZPbW29Ev3nOmFcgjOrlaPbOQ1qPvDr8y9a6RR1B3Ghm2+leyvDGu5t2aN+4
         +YeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkCgoK6ZqHLawA+wfEcSpsQgB6MAdJOS+sXp+61CymmAN8X5XZGtMUCttcmnmcxAKS1voiNGHyvGvmCoRxRpJbmXCP
X-Gm-Message-State: AOJu0Ywb5N13qK9bwCVjZEx2xhyOWY71wbNT2pu9tfwPe6naruCWsp9u
	jOLp3Bj4LGSywYtCEQloKI7tP3z4lC+61lvJM+3Qf5ZcUhiCTEeNW5lFJ5YiC6dSmFvgzmTezmH
	PKpJ0mbQ5g56Gwqdym2b3xX6b3vrOfdnf9ga54w==
X-Google-Smtp-Source: AGHT+IEG7CKsiFvzJSE79q86Izx9I2/9tJVRYDGrK1Q76mWNLQQgJBJvn37RrO2HSkBTnkcb7++fgKR/cuLeGsb6TXM=
X-Received: by 2002:a05:6e02:188f:b0:36a:3ef4:aa0a with SMTP id
 o15-20020a056e02188f00b0036a3ef4aa0amr1929273ilu.24.1713938010324; Tue, 23
 Apr 2024 22:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423190308.2883084-1-seanjc@google.com>
In-Reply-To: <20240423190308.2883084-1-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 24 Apr 2024 11:23:19 +0530
Message-ID: <CAAhSdy10AKzcCxqoD273FS6LR21W=t-gXgCR1pJ_kLnzzcaX5A@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftest: Define _GNU_SOURCE for all selftests code
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024 at 12:33=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Define _GNU_SOURCE is the base CFLAGS instead of relying on selftests to
> manually #define _GNU_SOURCE, which is repetitive and error prone.  E.g.
> kselftest_harness.h requires _GNU_SOURCE for asprintf(), but if a selftes=
t
> includes kvm_test_harness.h after stdio.h, the include guards result in
> the effective version of stdio.h consumed by kvm_test_harness.h not
> defining asprintf():
>
>   In file included from x86_64/fix_hypercall_test.c:12:
>   In file included from include/kvm_test_harness.h:11:
>  ../kselftest_harness.h:1169:2: error: call to undeclared function
>   'asprintf'; ISO C99 and later do not support implicit function declarat=
ions
>   [-Wimplicit-function-declaration]
>    1169 |         asprintf(&test_name, "%s%s%s.%s", f->name,
>         |         ^
>
> When including the rseq selftest's "library" code, #undef _GNU_SOURCE so
> that rseq.c controls whether or not it wants to build with _GNU_SOURCE.
>
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  tools/testing/selftests/kvm/Makefile                 |  4 ++--
>  tools/testing/selftests/kvm/aarch64/arch_timer.c     |  2 --
>  .../testing/selftests/kvm/aarch64/page_fault_test.c  |  1 -
>  tools/testing/selftests/kvm/aarch64/psci_test.c      |  3 ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c      |  1 -
>  tools/testing/selftests/kvm/arch_timer.c             |  3 ---
>  tools/testing/selftests/kvm/demand_paging_test.c     |  3 ---
>  tools/testing/selftests/kvm/dirty_log_test.c         |  3 ---
>  tools/testing/selftests/kvm/guest_memfd_test.c       |  2 --
>  tools/testing/selftests/kvm/hardware_disable_test.c  |  3 ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h  | 12 ++++++------
>  .../testing/selftests/kvm/include/userfaultfd_util.h |  3 ---
>  tools/testing/selftests/kvm/kvm_binary_stats_test.c  |  2 --
>  tools/testing/selftests/kvm/kvm_create_max_vcpus.c   |  2 --
>  tools/testing/selftests/kvm/kvm_page_table_test.c    |  3 ---
>  tools/testing/selftests/kvm/lib/assert.c             |  3 ---
>  tools/testing/selftests/kvm/lib/kvm_util.c           |  2 --
>  tools/testing/selftests/kvm/lib/memstress.c          |  2 --
>  tools/testing/selftests/kvm/lib/test_util.c          |  2 --
>  tools/testing/selftests/kvm/lib/userfaultfd_util.c   |  3 ---
>  tools/testing/selftests/kvm/lib/x86_64/sev.c         |  1 -
>  tools/testing/selftests/kvm/max_guest_memory_test.c  |  2 --
>  .../selftests/kvm/memslot_modification_stress_test.c |  3 ---
>  tools/testing/selftests/kvm/riscv/arch_timer.c       |  3 ---
>  tools/testing/selftests/kvm/rseq_test.c              | 12 +++++++++---
>  tools/testing/selftests/kvm/s390x/cmma_test.c        |  2 --
>  tools/testing/selftests/kvm/s390x/sync_regs_test.c   |  2 --
>  tools/testing/selftests/kvm/set_memory_region_test.c |  1 -
>  tools/testing/selftests/kvm/steal_time.c             |  1 -
>  tools/testing/selftests/kvm/x86_64/amx_test.c        |  2 --
>  .../kvm/x86_64/exit_on_emulation_failure_test.c      |  3 ---
>  tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c   |  2 --
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c    |  2 --
>  tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c    |  1 -
>  tools/testing/selftests/kvm/x86_64/hyperv_ipi.c      |  2 --
>  tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c |  1 -
>  .../testing/selftests/kvm/x86_64/hyperv_tlb_flush.c  |  2 --
>  .../selftests/kvm/x86_64/nested_exceptions_test.c    |  2 --
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c        |  3 ---
>  .../selftests/kvm/x86_64/platform_info_test.c        |  2 --
>  .../testing/selftests/kvm/x86_64/pmu_counters_test.c |  2 --
>  .../selftests/kvm/x86_64/pmu_event_filter_test.c     |  3 ---
>  .../kvm/x86_64/private_mem_conversions_test.c        |  1 -
>  tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c |  1 -
>  tools/testing/selftests/kvm/x86_64/set_sregs_test.c  |  1 -
>  .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c   |  3 ---
>  tools/testing/selftests/kvm/x86_64/smm_test.c        |  1 -
>  tools/testing/selftests/kvm/x86_64/state_test.c      |  1 -
>  tools/testing/selftests/kvm/x86_64/sync_regs_test.c  |  2 --
>  .../selftests/kvm/x86_64/ucna_injection_test.c       |  2 --
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c   |  2 --
>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c        |  3 ---
>  .../testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c |  1 -
>  .../selftests/kvm/x86_64/vmx_preemption_timer_test.c |  1 -
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c  |  2 --
>  .../testing/selftests/kvm/x86_64/xapic_state_test.c  |  1 -
>  tools/testing/selftests/kvm/x86_64/xss_msr_test.c    |  2 --
>  57 files changed, 17 insertions(+), 120 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index 871e2de3eb05..6de9994971c9 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -226,8 +226,8 @@ LINUX_TOOL_ARCH_INCLUDE =3D $(top_srcdir)/tools/arch/=
$(ARCH)/include
>  endif
>  CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu9=
9 \
>         -Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
> -       -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
> -       -fno-builtin-strnlen \
> +       -D_GNU_SOURCE -fno-builtin-memcmp -fno-builtin-memcpy \
> +       -fno-builtin-memset -fno-builtin-strnlen \
>         -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>         -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>         -I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/tes=
ting/selftests/kvm/aarch64/arch_timer.c
> index 4eaba83cdcf3..5369959e9fc2 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -5,8 +5,6 @@
>   *
>   * Copyright (c) 2021, Google LLC.
>   */
> -#define _GNU_SOURCE
> -
>  #include "arch_timer.h"
>  #include "delay.h"
>  #include "gic.h"
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tool=
s/testing/selftests/kvm/aarch64/page_fault_test.c
> index a2a158e2c0b8..d29b08198b42 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -7,7 +7,6 @@
>   * hugetlbfs with a hole). It checks that the expected handling method i=
s
>   * called (e.g., uffd faults with the right address and write/read flag)=
.
>   */
> -#define _GNU_SOURCE
>  #include <linux/bitmap.h>
>  #include <fcntl.h>
>  #include <test_util.h>
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/test=
ing/selftests/kvm/aarch64/psci_test.c
> index 9b004905d1d3..1c8c6f0c1ca3 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -10,9 +10,6 @@
>   *  - A test for KVM's handling of PSCI SYSTEM_SUSPEND and the associate=
d
>   *    KVM_SYSTEM_EVENT_SUSPEND UAPI.
>   */
> -
> -#define _GNU_SOURCE
> -
>  #include <linux/psci.h>
>
>  #include "kvm_util.h"
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/test=
ing/selftests/kvm/aarch64/vgic_init.c
> index eef816b80993..e93022870cac 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -4,7 +4,6 @@
>   *
>   * Copyright (C) 2020, Red Hat, Inc.
>   */
> -#define _GNU_SOURCE
>  #include <linux/kernel.h>
>  #include <sys/syscall.h>
>  #include <asm/kvm.h>
> diff --git a/tools/testing/selftests/kvm/arch_timer.c b/tools/testing/sel=
ftests/kvm/arch_timer.c
> index ae1f1a6d8312..fcebd8d81ce4 100644
> --- a/tools/testing/selftests/kvm/arch_timer.c
> +++ b/tools/testing/selftests/kvm/arch_timer.c
> @@ -19,9 +19,6 @@
>   *
>   * Copyright (c) 2021, Google LLC.
>   */
> -
> -#define _GNU_SOURCE
> -
>  #include <stdlib.h>
>  #include <pthread.h>
>  #include <linux/sizes.h>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
> index 056ff1c87345..bc5c4ada5f0d 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -6,9 +6,6 @@
>   * Copyright (C) 2018, Red Hat, Inc.
>   * Copyright (C) 2019, Google, Inc.
>   */
> -
> -#define _GNU_SOURCE /* for pipe2 */
> -
>  #include <inttypes.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
> index eaad5b20854c..bf1ebc29f22a 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -4,9 +4,6 @@
>   *
>   * Copyright (C) 2018, Red Hat, Inc.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <pthread.h>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index 92eae206baa6..309fe84b84ad 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -4,8 +4,6 @@
>   *
>   * Author: Chao Peng <chao.p.peng@linux.intel.com>
>   */
> -
> -#define _GNU_SOURCE
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/=
testing/selftests/kvm/hardware_disable_test.c
> index decc521fc760..bce73bcb973c 100644
> --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> @@ -4,9 +4,6 @@
>   * kvm_arch_hardware_disable is called and it attempts to unregister the=
 user
>   * return notifiers.
>   */
> -
> -#define _GNU_SOURCE
> -
>  #include <fcntl.h>
>  #include <pthread.h>
>  #include <semaphore.h>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/=
testing/selftests/kvm/include/kvm_util_base.h
> index 8acca8237687..af02308e264e 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -27,12 +27,12 @@
>
>  /*
>   * Provide a version of static_assert() that is guaranteed to have an op=
tional
> - * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/ass=
ert.h)
> - * #undefs and #defines static_assert() as a direct alias to _Static_ass=
ert(),
> - * i.e. effectively makes the message mandatory.  Many KVM selftests #de=
fine
> - * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOUR=
CE.  As
> - * a result, static_assert() behavior is non-deterministic and may or ma=
y not
> - * require a message depending on #include order.
> + * message param.  _GNU_SOURCE is defined for all KVM selftests, _GNU_SO=
URCE
> + * implies _ISOC11_SOURCE, and if _ISOC11_SOURCE is defined, glibc #unde=
fs and
> + * #defines static_assert() as a direct alias to _Static_assert() (see
> + * usr/include/assert.h).  Define a custom macro instead of redefining
> + * static_assert() to avoid creating non-deterministic behavior that is
> + * dependent on include order.
>   */
>  #define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
>  #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_AR=
GS__, #expr)
> diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/too=
ls/testing/selftests/kvm/include/userfaultfd_util.h
> index 24f2cc5f4292..60f7f9d435dc 100644
> --- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
> +++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> @@ -5,9 +5,6 @@
>   * Copyright (C) 2018, Red Hat, Inc.
>   * Copyright (C) 2019-2022 Google LLC
>   */
> -
> -#define _GNU_SOURCE /* for pipe2 */
> -
>  #include <inttypes.h>
>  #include <time.h>
>  #include <pthread.h>
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/=
testing/selftests/kvm/kvm_binary_stats_test.c
> index 698c1cfa3111..f02355c3c4c2 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -6,8 +6,6 @@
>   *
>   * Test the fd-based interface for KVM statistics.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/t=
esting/selftests/kvm/kvm_create_max_vcpus.c
> index b9e23265e4b3..c78f34699f73 100644
> --- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> +++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> @@ -6,8 +6,6 @@
>   *
>   * Test for KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/te=
sting/selftests/kvm/kvm_page_table_test.c
> index e0ba97ac1c56..7759c685086b 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -8,9 +8,6 @@
>   * page size have been pre-allocated on your system, if you are planning=
 to
>   * use hugepages to back the guest memory for testing.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <time.h>
> diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/sel=
ftests/kvm/lib/assert.c
> index 2bd25b191d15..b49690658c60 100644
> --- a/tools/testing/selftests/kvm/lib/assert.c
> +++ b/tools/testing/selftests/kvm/lib/assert.c
> @@ -4,9 +4,6 @@
>   *
>   * Copyright (C) 2018, Google LLC.
>   */
> -
> -#define _GNU_SOURCE /* for getline(3) and strchrnul(3)*/
> -
>  #include "test_util.h"
>
>  #include <execinfo.h>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 9da388100f3a..c4f12e272b38 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -4,8 +4,6 @@
>   *
>   * Copyright (C) 2018, Google LLC.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_name */
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/=
selftests/kvm/lib/memstress.c
> index cf2c73971308..555e3932e529 100644
> --- a/tools/testing/selftests/kvm/lib/memstress.c
> +++ b/tools/testing/selftests/kvm/lib/memstress.c
> @@ -2,8 +2,6 @@
>  /*
>   * Copyright (C) 2020, Google LLC.
>   */
> -#define _GNU_SOURCE
> -
>  #include <inttypes.h>
>  #include <linux/bitmap.h>
>
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
> index 5a8f8becb129..8ed0b74ae837 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -4,8 +4,6 @@
>   *
>   * Copyright (C) 2020, Google LLC.
>   */
> -
> -#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdarg.h>
>  #include <assert.h>
> diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/t=
esting/selftests/kvm/lib/userfaultfd_util.c
> index 0ba866c4af69..7c9de8414462 100644
> --- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> @@ -6,9 +6,6 @@
>   * Copyright (C) 2018, Red Hat, Inc.
>   * Copyright (C) 2019-2022 Google LLC
>   */
> -
> -#define _GNU_SOURCE /* for pipe2 */
> -
>  #include <inttypes.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing=
/selftests/kvm/lib/x86_64/sev.c
> index d482029b6004..e9535ee20b7f 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> @@ -1,5 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <stdint.h>
>  #include <stdbool.h>
>
> diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/=
testing/selftests/kvm/max_guest_memory_test.c
> index 1a6da7389bf1..0b9678858b6d 100644
> --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> @@ -1,6 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0
> -#define _GNU_SOURCE
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <pthread.h>
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test=
.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 156361966612..05fcf902e067 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -6,9 +6,6 @@
>   * Copyright (C) 2018, Red Hat, Inc.
>   * Copyright (C) 2020, Google, Inc.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/syscall.h>
> diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testi=
ng/selftests/kvm/riscv/arch_timer.c
> index 0f9cabd99fd4..4b5004ef9c6b 100644
> --- a/tools/testing/selftests/kvm/riscv/arch_timer.c
> +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> @@ -7,9 +7,6 @@
>   *
>   * Copyright (c) 2024, Intel Corporation.
>   */
> -
> -#define _GNU_SOURCE
> -
>  #include "arch_timer.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/self=
tests/kvm/rseq_test.c
> index 28f97fb52044..0728b15b5d3a 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -1,5 +1,13 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -#define _GNU_SOURCE /* for program_invocation_short_name */
> +
> +/*
> + * Include rseq.c without _GNU_SOURCE defined, before including any head=
ers, so
> + * that rseq.c is compiled with its configuration, not KVM selftests' co=
nfig.
> + */
> +#undef _GNU_SOURCE
> +#include "../rseq/rseq.c"
> +#define _GNU_SOURCE
> +
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <pthread.h>
> @@ -20,8 +28,6 @@
>  #include "processor.h"
>  #include "test_util.h"
>
> -#include "../rseq/rseq.c"
> -
>  /*
>   * Any bug related to task migration is likely to be timing-dependent; p=
erform
>   * a large number of migrations to reduce the odds of a false negative.
> diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testin=
g/selftests/kvm/s390x/cmma_test.c
> index 626a2b8a2037..84ba79c42ab1 100644
> --- a/tools/testing/selftests/kvm/s390x/cmma_test.c
> +++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
> @@ -7,8 +7,6 @@
>   * Authors:
>   *  Nico Boehr <nrb@linux.ibm.com>
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/t=
esting/selftests/kvm/s390x/sync_regs_test.c
> index 43fb25ddc3ec..53def355ccba 100644
> --- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
> @@ -10,8 +10,6 @@
>   *
>   * Test expected behavior of the KVM_CAP_SYNC_REGS functionality.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools=
/testing/selftests/kvm/set_memory_region_test.c
> index 68c899d27561..ad95e966cff7 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -1,5 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <pthread.h>
>  #include <sched.h>
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/sel=
ftests/kvm/steal_time.c
> index 4be5a1ffa06a..b6938bd2442c 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -4,7 +4,6 @@
>   *
>   * Copyright (C) 2020, Red Hat, Inc.
>   */
> -#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <time.h>
>  #include <sched.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testin=
g/selftests/kvm/x86_64/amx_test.c
> index eae521f050e0..8e5713e36d4b 100644
> --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> @@ -6,8 +6,6 @@
>   *
>   * Tests for amx #NM exception and save/restore.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure=
_test.c b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test=
.c
> index 6c2e5e0ceb1f..9c21b6bccc38 100644
> --- a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
> @@ -4,9 +4,6 @@
>   *
>   * Test for KVM_CAP_EXIT_ON_EMULATION_FAILURE.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
> -
>  #include "flds_emulation.h"
>
>  #include "test_util.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c b/tools/t=
esting/selftests/kvm/x86_64/hwcr_msr_test.c
> index df351ae17029..10b1b0ba374e 100644
> --- a/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
> @@ -2,8 +2,6 @@
>  /*
>   * Copyright (C) 2023, Google LLC.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <sys/ioctl.h>
>
>  #include "test_util.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/te=
sting/selftests/kvm/x86_64/hyperv_cpuid.c
> index 5c27efbf405e..4f5881d4ef66 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -7,8 +7,6 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   *
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/te=
sting/selftests/kvm/x86_64/hyperv_evmcs.c
> index 4c7257ecd2a6..4f3f3a9b038b 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
> @@ -4,7 +4,6 @@
>   *
>   * Tests for Enlightened VMCS, including nested guest state.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/test=
ing/selftests/kvm/x86_64/hyperv_ipi.c
> index f1617762c22f..8206f5ef42dd 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> @@ -5,8 +5,6 @@
>   * Copyright (C) 2022, Red Hat, Inc.
>   *
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <pthread.h>
>  #include <inttypes.h>
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools=
/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> index c9b18707edc0..b987a3d79715 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> @@ -4,7 +4,6 @@
>   *
>   * Tests for Hyper-V extensions to SVM.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tool=
s/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
> index 05b56095cf76..077cd0ec3040 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
> @@ -5,8 +5,6 @@
>   * Copyright (C) 2022, Red Hat, Inc.
>   *
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <asm/barrier.h>
>  #include <pthread.h>
>  #include <inttypes.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c =
b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
> index 3670331adf21..3eb0313ffa39 100644
> --- a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
> @@ -1,6 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -#define _GNU_SOURCE /* for program_invocation_short_name */
> -
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/to=
ols/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 17bbb96fc4df..e7efb2b35f8b 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -5,9 +5,6 @@
>   *
>   * Copyright (C) 2022, Google LLC.
>   */
> -
> -#define _GNU_SOURCE
> -
>  #include <fcntl.h>
>  #include <stdint.h>
>  #include <time.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/to=
ols/testing/selftests/kvm/x86_64/platform_info_test.c
> index 87011965dc41..2165b1ad8b38 100644
> --- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
> @@ -9,8 +9,6 @@
>   * Verifies expected behavior of controlling guest access to
>   * MSR_PLATFORM_INFO.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/too=
ls/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 26c85815f7e9..77f14138594e 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -2,8 +2,6 @@
>  /*
>   * Copyright (C) 2023, Tencent, Inc.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <x86intrin.h>
>
>  #include "pmu.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b=
/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 3c85d1ae9893..5ce53b8c46e0 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -9,9 +9,6 @@
>   * Verifies the expected behavior of allow lists and deny lists for
>   * virtual PMU events.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
> -
>  #include "kvm_util.h"
>  #include "pmu.h"
>  #include "processor.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_t=
est.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
> index e0f642d2a3c4..82a8d88b5338 100644
> --- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
> @@ -2,7 +2,6 @@
>  /*
>   * Copyright (C) 2022, Google LLC.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <limits.h>
>  #include <pthread.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools=
/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> index 366cf18600bc..d691d86e5bc3 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> @@ -4,7 +4,6 @@
>   *
>   * Copyright (C) 2020, Red Hat, Inc.
>   */
> -#define _GNU_SOURCE /* for program_invocation_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/=
testing/selftests/kvm/x86_64/set_sregs_test.c
> index 3610981d9162..c021c0795a96 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
> @@ -10,7 +10,6 @@
>   * That bug allowed a user-mode program that called the KVM_SET_SREGS
>   * ioctl to put a VCPU's local APIC into an invalid state.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulat=
ion_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulatio=
n_test.c
> index 416207c38a17..362be40fc00d 100644
> --- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_tes=
t.c
> +++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_tes=
t.c
> @@ -5,9 +5,6 @@
>   * Test that KVM emulates instructions in response to EPT violations whe=
n
>   * allow_smaller_maxphyaddr is enabled and guest.MAXPHYADDR < host.MAXPH=
YADDR.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
> -
>  #include "flds_emulation.h"
>
>  #include "test_util.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testin=
g/selftests/kvm/x86_64/smm_test.c
> index e18b86666e1f..55c88d664a94 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -4,7 +4,6 @@
>   *
>   * Tests for SMM.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/test=
ing/selftests/kvm/x86_64/state_test.c
> index 88b58aab7207..1c756db329e5 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -6,7 +6,6 @@
>   *
>   * Tests for vCPU state save/restore, including nested guest state.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/=
testing/selftests/kvm/x86_64/sync_regs_test.c
> index adb5593daf48..8fa3948b0170 100644
> --- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> @@ -8,8 +8,6 @@
>   * including requesting an invalid register set, updates to/from values
>   * in kvm_run.s.regs when kvm_valid_regs and kvm_dirty_regs are toggled.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/t=
ools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> index dcbb3c29fb8e..abe71946941f 100644
> --- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> @@ -17,8 +17,6 @@
>   * delivered into the guest or not.
>   *
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <pthread.h>
>  #include <inttypes.h>
>  #include <string.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c=
 b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> index f4f61a2d2464..53afbea4df88 100644
> --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> @@ -4,8 +4,6 @@
>   *
>   * Tests for exiting into userspace on registered MSRs
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <sys/ioctl.h>
>
>  #include "kvm_test_harness.h"
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/to=
ols/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> index 977948fd52e6..fa512d033205 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> @@ -4,9 +4,6 @@
>   *
>   * Copyright (C) 2018, Red Hat, Inc.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <linux/bitmap.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/too=
ls/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index ea0cb3cae0f7..3b93f262b797 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -10,7 +10,6 @@
>   * and check it can be retrieved with KVM_GET_MSR, also test
>   * the invalid LBR formats are rejected.
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <sys/ioctl.h>
>
>  #include <linux/bitmap.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test=
.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> index affc32800158..00dd2ac07a61 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> @@ -9,7 +9,6 @@
>   * value instead of partially decayed timer value
>   *
>   */
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/=
testing/selftests/kvm/x86_64/xapic_ipi_test.c
> index 725c206ba0b9..c78e5f755116 100644
> --- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> @@ -19,8 +19,6 @@
>   * Migration is a command line option. When used on non-numa machines wi=
ll
>   * exit with error. Test is still usefull on non-numa for testing IPIs.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <getopt.h>
>  #include <pthread.h>
>  #include <inttypes.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tool=
s/testing/selftests/kvm/x86_64/xapic_state_test.c
> index ab75b873a4ad..69849acd95b0 100644
> --- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
> @@ -1,5 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/te=
sting/selftests/kvm/x86_64/xss_msr_test.c
> index 167c97abff1b..f331a4e9bae3 100644
> --- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
> @@ -4,8 +4,6 @@
>   *
>   * Tests for the IA32_XSS MSR.
>   */
> -
> -#define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <sys/ioctl.h>
>
>  #include "test_util.h"
>
> base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
> --
> 2.44.0.769.g3c40516874-goog
>

