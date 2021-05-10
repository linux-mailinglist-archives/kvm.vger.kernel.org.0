Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA9379015
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhEJOC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 10:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347262AbhEJOAx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 10:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620655188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yth30XVDmF6UPqqF4E89Gx4Hg7eFx4CUBKfYB4Vwl9A=;
        b=PWgAWReRyVbZBffMP91YbbFZtpBF1MWGTb3f6tfHFAugT9dk9hTNWO8wM5uQfK7NyEWuZT
        aAjWd5+gq+RiB5Q2+0bZJPCCg6MOCAIf111oM/OA1O4Idp0DPbSDroJIKqYglrpsQmrRZ6
        hiqd62WnuJufKiH4FtYNVABIQhzzIxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-088ia9nFP8KXZ3oBvv--2A-1; Mon, 10 May 2021 09:59:44 -0400
X-MC-Unique: 088ia9nFP8KXZ3oBvv--2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4A3D63ACF;
        Mon, 10 May 2021 13:59:40 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2B2E100EBAD;
        Mon, 10 May 2021 13:59:36 +0000 (UTC)
Message-ID: <082d8b638e20332b60a0977b5f7b5c684ebed7b7.camel@redhat.com>
Subject: Re: [PATCH 8/8] KVM: selftests: x86: Add vmx_nested_tsc_scaling_test
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:59:35 +0300
In-Reply-To: <20210506103228.67864-9-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-9-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> Test that nested TSC scaling works as expected with both L1 and L2
> scaled.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 209 ++++++++++++++++++
>  3 files changed, 211 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index bd83158e0e0b..cc02022f9951 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -29,6 +29,7 @@
>  /x86_64/vmx_preemption_timer_test
>  /x86_64/vmx_set_nested_state_test
>  /x86_64/vmx_tsc_adjust_test
> +/x86_64/vmx_nested_tsc_scaling_test
>  /x86_64/xapic_ipi_test
>  /x86_64/xen_shinfo_test
>  /x86_64/xen_vmcall_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index e439d027939d..1078240b1313 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -60,6 +60,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>  TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> new file mode 100644
> index 000000000000..b05f5151ecbe
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> @@ -0,0 +1,209 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vmx_nested_tsc_scaling_test
> + *
> + * Copyright (C) 2021 Amazon.com, Inc. or its affiliates.
> + *
> + * This test case verifies that nested TSC scaling behaves as expected when
> + * both L1 and L2 are scaled using different ratios. For this test we scale
> + * L1 down and scale L2 up.
> + */
> +
> +
> +#include "kvm_util.h"
> +#include "vmx.h"
> +#include "kselftest.h"
> +
> +
> +#define VCPU_ID 0
> +
> +/* L1 is scaled down by this factor */
> +#define L1_SCALE_FACTOR 2ULL
> +/* L2 is scaled up (from L1's perspective) by this factor */
> +#define L2_SCALE_FACTOR 4ULL

For fun, I might have randomized these factors as well.

> +
> +#define TSC_OFFSET_L2 (1UL << 32)
> +#define TSC_MULTIPLIER_L2 (L2_SCALE_FACTOR << 48)
It would be fun to use a negative offset here (also randomally).

> +
> +#define L2_GUEST_STACK_SIZE 64
> +
> +enum { USLEEP, UCHECK_L1, UCHECK_L2 };
> +#define GUEST_SLEEP(sec)         ucall(UCALL_SYNC, 2, USLEEP, sec)
> +#define GUEST_CHECK(level, freq) ucall(UCALL_SYNC, 2, level, freq)
> +
> +
> +/*
> + * This function checks whether the "actual" TSC frequency of a guest matches
> + * its expected frequency. In order to account for delays in taking the TSC
> + * measurements, a difference of 1% between the actual and the expected value
> + * is tolerated.
> + */
> +static void compare_tsc_freq(uint64_t actual, uint64_t expected)
> +{
> +	uint64_t tolerance, thresh_low, thresh_high;
> +
> +	tolerance = expected / 100;
> +	thresh_low = expected - tolerance;
> +	thresh_high = expected + tolerance;
> +
> +	TEST_ASSERT(thresh_low < actual,
> +		"TSC freq is expected to be between %"PRIu64" and %"PRIu64
> +		" but it actually is %"PRIu64,
> +		thresh_low, thresh_high, actual);
> +	TEST_ASSERT(thresh_high > actual,
> +		"TSC freq is expected to be between %"PRIu64" and %"PRIu64
> +		" but it actually is %"PRIu64,
> +		thresh_low, thresh_high, actual);
> +}
> +
> +static void check_tsc_freq(int level)
> +{
> +	uint64_t tsc_start, tsc_end, tsc_freq;
> +
> +	/*
> +	 * Reading the TSC twice with about a second's difference should give
> +	 * us an approximation of the TSC frequency from the guest's
> +	 * perspective. Now, this won't be completely accurate, but it should
> +	 * be good enough for the purposes of this test.
> +	 */

It would be nice to know if the host has stable TSC (you can obtain this via 
KVM_GET_CLOCK, the KVM_CLOCK_TSC_STABLE flag).

And if not stable skip the test, to avoid false positives.
(Yes I have a laptop I just bought that has an unstable TSC....)


> +	tsc_start = rdmsr(MSR_IA32_TSC);
> +	GUEST_SLEEP(1);
> +	tsc_end = rdmsr(MSR_IA32_TSC);
> +
> +	tsc_freq = tsc_end - tsc_start;
> +
> +	GUEST_CHECK(level, tsc_freq);
> +}
> +
> +static void l2_guest_code(void)
> +{
> +	check_tsc_freq(UCHECK_L2);
> +
> +	/* exit to L1 */
> +	__asm__ __volatile__("vmcall");
> +}
> +
> +static void l1_guest_code(struct vmx_pages *vmx_pages)
> +{
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	uint32_t control;
> +
> +	/* check that L1's frequency looks alright before launching L2 */
> +	check_tsc_freq(UCHECK_L1);
> +
> +	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
> +	GUEST_ASSERT(load_vmcs(vmx_pages));
> +
> +	/* prepare the VMCS for L2 execution */
> +	prepare_vmcs(vmx_pages, l2_guest_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	/* enable TSC offsetting and TSC scaling for L2 */
> +	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
> +	control |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_USE_TSC_OFFSETTING;
> +	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
> +
> +	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
> +	control |= SECONDARY_EXEC_TSC_SCALING;
> +	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
> +
> +	vmwrite(TSC_OFFSET, TSC_OFFSET_L2);
> +	vmwrite(TSC_MULTIPLIER, TSC_MULTIPLIER_L2);
> +	vmwrite(TSC_MULTIPLIER_HIGH, TSC_MULTIPLIER_L2 >> 32);
> +
> +	/* launch L2 */
> +	GUEST_ASSERT(!vmlaunch());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> +
> +	/* check that L1's frequency still looks good */
> +	check_tsc_freq(UCHECK_L1);
> +
> +	GUEST_DONE();
> +}
> +
> +static void tsc_scaling_check_supported(void)
> +{
> +	if (!kvm_check_cap(KVM_CAP_TSC_CONTROL)) {
> +		print_skip("TSC scaling not supported by the HW");
> +		exit(KSFT_SKIP);
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +	vm_vaddr_t vmx_pages_gva;
> +
> +	uint64_t tsc_start, tsc_end;
> +	uint64_t tsc_khz;
> +	uint64_t l0_tsc_freq = 0;
> +	uint64_t l1_tsc_freq = 0;
> +	uint64_t l2_tsc_freq = 0;
> +
> +	nested_vmx_check_supported();
> +	tsc_scaling_check_supported();
> +
> +	tsc_start = rdtsc();
> +	sleep(1);
> +	tsc_end = rdtsc();
> +
> +	l0_tsc_freq = tsc_end - tsc_start;
> +	printf("real TSC frequency is around: %"PRIu64"\n", l0_tsc_freq);
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
> +	vcpu_alloc_vmx(vm, &vmx_pages_gva);
> +	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
> +
> +	tsc_khz = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_TSC_KHZ, NULL);
> +	TEST_ASSERT(tsc_khz != -1, "vcpu ioctl KVM_GET_TSC_KHZ failed");
> +
> +	/* scale down L1's TSC frequency */
> +	vcpu_ioctl(vm, VCPU_ID, KVM_SET_TSC_KHZ,
> +		  (void *) (tsc_khz / L1_SCALE_FACTOR));
> +
> +	for (;;) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s", (const char *) uc.args[0]);
> +		case UCALL_SYNC:
> +			switch (uc.args[0]) {
> +			case USLEEP:
> +				sleep(uc.args[1]);
> +				break;
> +			case UCHECK_L1:
> +				l1_tsc_freq = uc.args[1];
> +				printf("L1's TSC frequency is around: %"PRIu64
> +				       "\n", l1_tsc_freq);
> +
> +				compare_tsc_freq(l1_tsc_freq,
> +						 l0_tsc_freq / L1_SCALE_FACTOR);
> +				break;
> +			case UCHECK_L2:
> +				l2_tsc_freq = uc.args[1];
> +				printf("L2's TSC frequency is around: %"PRIu64
> +				       "\n", l2_tsc_freq);
> +
> +				compare_tsc_freq(l2_tsc_freq,
> +						 l1_tsc_freq * L2_SCALE_FACTOR);
> +				break;
> +			}
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
Overall looks OK to me.

I can't test it, since the most recent Intel laptop I have (i7-7600U)
still lacks TSC scaling (or did Intel cripple this feature on clients like what
they did with APICv ?)

Best regards,
	Maxim Levitsky



