Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11FA3DA97E
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhG2Q4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhG2Q4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 12:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627577762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qd8XPVBC2FLnXDVHSjbTPB6AK3eiJygwDg1gPalgFcA=;
        b=X1OLhachK7Ih+uzx4Fu4905kC9Tp9RQoA+qSov5dcAtSyhupE1cXXl2SgTaDAm03+JqSdZ
        dgE9iRI5JqQpvc50fWqr6AHwK9tBAqFGEYVwfWYhqhSxHbWU/5D96aSDj1MKpogHA1sUVF
        XE9YaWsKIh8w4FTG9l03gRrTD3brfo0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-R425JeiVOLazCFz5_ZUX7Q-1; Thu, 29 Jul 2021 12:56:01 -0400
X-MC-Unique: R425JeiVOLazCFz5_ZUX7Q-1
Received: by mail-io1-f71.google.com with SMTP id w3-20020a0566020343b02905393057ad92so4158180iou.20
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qd8XPVBC2FLnXDVHSjbTPB6AK3eiJygwDg1gPalgFcA=;
        b=dwXOjcV9Q1joNlYkwx/nMchVg+KciSjQaRgD+hWvIjR/DdzjVi0Mqf7l5fnvnBB6OV
         EIHAGLF2oE4pUwx83Jr+ZcQAgDAEvnIKJtQDYrs1D9efO/A/mCrEjhWPKjRfF+ILqG7d
         W1e84VLesh3PlrrJ8ecjNMvFCT5AoZTiSnJDw5aseetVOuYplOpdy1PN/oe/Gq4bilM5
         NvPG4KtwFHZeENCiYkO1SHqyFmadDrjj3zFOyNXHFApQ5cKz2yAqucw9Zi5X3sLgE3QI
         2pTYKywtmuSfP4rdfyHYaHiO/pq6wudRXWV5yRqPgv7WUex75PRZk3ugmJEemVw7Zb/2
         m35A==
X-Gm-Message-State: AOAM5319cqdDHPwpymtFfeYhyA0k2bjlikjiBEBw6+xK7bUnbqlkxnIW
        qxPj0fwKFWgBVmE3B04qAFdx6fVEMJKHPFjvE9xqCCZ4BFtzBb90XeVI7fislSzkNbwpsHBjlY6
        vhRvpWcF0xMOw
X-Received: by 2002:a02:a595:: with SMTP id b21mr5254684jam.122.1627577760379;
        Thu, 29 Jul 2021 09:56:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDwBtPaZ45IBi88gv6nYi46aPm3qisyI/FRh7gTE3p7yOzi4XJvvIIIgRUo5VL7uB/tmW01Q==
X-Received: by 2002:a02:a595:: with SMTP id b21mr5254648jam.122.1627577759855;
        Thu, 29 Jul 2021 09:55:59 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id n10sm2010853ile.82.2021.07.29.09.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:55:59 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:55:56 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 13/13] selftests: KVM: Add counter emulation benchmark
Message-ID: <20210729165556.pce7dzy3ovltycxx@gator>
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-14-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729001012.70394-14-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 12:10:12AM +0000, Oliver Upton wrote:
> Add a test case for counter emulation on arm64. A side effect of how KVM
> handles physical counter offsetting on non-ECV systems is that the
> virtual counter will always hit hardware and the physical could be
> emulated. Force emulation by writing a nonzero offset to the physical
> counter and compare the elapsed cycles to a direct read of the hardware
> register.
> 
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/counter_emulation_benchmark.c | 215 ++++++++++++++++++
>  3 files changed, 217 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 3d2585f0bffc..a23198ea6e7a 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/debug-exceptions
> +/aarch64/counter_emulation_benchmark
>  /aarch64/get-reg-list
>  /aarch64/vgic_init
>  /s390x/memop
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index fab42e7c23ee..db8706eb6104 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -88,6 +88,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> +TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
> diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> new file mode 100644
> index 000000000000..73aeb6cdebfe
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> @@ -0,0 +1,215 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * counter_emulation_benchmark.c -- test to measure the effects of counter
> + * emulation on guest reads of the physical counter.
> + *
> + * Copyright (c) 2021, Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +#include <asm/kvm.h>
> +#include <linux/kvm.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +#define VCPU_ID 0
> +
> +static struct counter_values {
> +	uint64_t cntvct_start;
> +	uint64_t cntpct;
> +	uint64_t cntvct_end;
> +} counter_values;
> +
> +static uint64_t nr_iterations = 1000;
> +
> +static void do_test(void)
> +{
> +	/*
> +	 * Open-coded approach instead of using helper methods to keep a tight
> +	 * interval around the physical counter read.
> +	 */
> +	asm volatile("isb\n\t"
> +		     "mrs %[cntvct_start], cntvct_el0\n\t"
> +		     "isb\n\t"
> +		     "mrs %[cntpct], cntpct_el0\n\t"
> +		     "isb\n\t"
> +		     "mrs %[cntvct_end], cntvct_el0\n\t"
> +		     "isb\n\t"
> +		     : [cntvct_start] "=r"(counter_values.cntvct_start),
> +		     [cntpct] "=r"(counter_values.cntpct),
> +		     [cntvct_end] "=r"(counter_values.cntvct_end));
> +}
> +
> +static void guest_main(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_iterations; i++) {
> +		do_test();
> +		GUEST_SYNC(i);
> +	}
> +
> +	for (i = 0; i < nr_iterations; i++) {
> +		do_test();
> +		GUEST_SYNC(i);
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static bool enter_guest(struct kvm_vm *vm)
> +{
> +	struct ucall uc;
> +
> +	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
> +
> +	switch (get_ucall(vm, VCPU_ID, &uc)) {
> +	case UCALL_DONE:
> +		return true;
> +	case UCALL_SYNC:
> +		break;
> +	case UCALL_ABORT:
> +		TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
> +			    __FILE__, uc.args[1]);
> +		break;
> +	default:
> +		TEST_ASSERT(false, "unexpected exit: %s",
> +			    exit_reason_str(vcpu_state(vm, VCPU_ID)->exit_reason));
> +		break;
> +	}
> +
> +	/* more work to do in the guest */
> +	return false;
> +}
> +
> +static double counter_frequency(void)
> +{
> +	uint32_t freq;
> +
> +	asm volatile("mrs %0, cntfrq_el0"
> +		     : "=r" (freq));
> +
> +	return freq / 1000000.0;
> +}
> +
> +static void log_csv(FILE *csv, bool trapped)
> +{
> +	double freq = counter_frequency();
> +
> +	fprintf(csv, "%s,%.02f,%lu,%lu,%lu\n",
> +		trapped ? "true" : "false", freq,
> +		counter_values.cntvct_start,
> +		counter_values.cntpct,
> +		counter_values.cntvct_end);
> +}
> +
> +static double run_loop(struct kvm_vm *vm, FILE *csv, bool trapped)
> +{
> +	double avg = 0;
> +	int i;
> +
> +	for (i = 0; i < nr_iterations; i++) {
> +		uint64_t delta;
> +
> +		TEST_ASSERT(!enter_guest(vm), "guest exited unexpectedly");
> +		sync_global_from_guest(vm, counter_values);
> +
> +		if (csv)
> +			log_csv(csv, trapped);
> +
> +		delta = counter_values.cntvct_end - counter_values.cntvct_start;
> +		avg = ((avg * i) + delta) / (i + 1);
> +	}
> +
> +	return avg;
> +}
> +
> +static void setup_counter(struct kvm_vm *vm, uint64_t offset)
> +{
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				KVM_ARM_VCPU_TIMER_OFFSET_PTIMER, &offset,
> +				true);
> +}
> +
> +static void run_tests(struct kvm_vm *vm, FILE *csv)
> +{
> +	double avg_trapped, avg_native, freq;
> +
> +	freq = counter_frequency();
> +
> +	if (csv)
> +		fputs("trapped,freq_mhz,cntvct_start,cntpct,cntvct_end\n", csv);
> +
> +	/* no physical offsetting; kvm allows reads of cntpct_el0 */
> +	setup_counter(vm, 0);
> +	avg_native = run_loop(vm, csv, false);
> +
> +	/* force emulation of the physical counter */
> +	setup_counter(vm, 1);
> +	avg_trapped = run_loop(vm, csv, true);
> +
> +	TEST_ASSERT(enter_guest(vm), "guest didn't run to completion");
> +	pr_info("%lu iterations: average cycles (@%.02fMHz) native: %.02f, trapped: %.02f\n",
> +		nr_iterations, freq, avg_native, avg_trapped);
> +}
> +
> +static void usage(const char *program_name)
> +{
> +	fprintf(stderr,
> +		"Usage: %s [-h] [-o csv_file] [-n iterations]\n"
> +		"  -h prints this message\n"
> +		"  -n number of test iterations (default: %lu)\n"
> +		"  -o csv file to write data\n",
> +		program_name, nr_iterations);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct kvm_vm *vm;
> +	FILE *csv = NULL;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "hn:o:")) != -1) {
> +		switch (opt) {
> +		case 'o':
> +			csv = fopen(optarg, "w");
> +			if (!csv) {
> +				fprintf(stderr, "failed to open file '%s': %d\n",
> +					optarg, errno);
> +				exit(1);
> +			}
> +			break;
> +		case 'n':
> +			nr_iterations = strtoul(optarg, NULL, 0);
> +			break;
> +		default:
> +			fprintf(stderr, "unrecognized option: '-%c'\n", opt);
> +			/* fallthrough */
> +		case 'h':
> +			usage(argv[0]);
> +			exit(1);
> +		}
> +	}
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +	sync_global_to_guest(vm, nr_iterations);
> +	ucall_init(vm, NULL);
> +
> +	if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				  KVM_ARM_VCPU_TIMER_OFFSET_PTIMER)) {
> +		print_skip("KVM_ARM_VCPU_TIMER_OFFSET_PTIMER not supported.");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	run_tests(vm, csv);
> +	kvm_vm_free(vm);
> +
> +	if (csv)
> +		fclose(csv);
> +}
> -- 
> 2.32.0.432.gabb21c7263-goog
>

I skimmed through this, but didn't see any changes from v3 where I had a
couple comments.

Thanks,
drew

