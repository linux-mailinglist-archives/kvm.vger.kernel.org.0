Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C324F14C1
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344510AbiDDM3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 08:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344081AbiDDM3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 08:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9874A3DDE5
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 05:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649075264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZiet0gB7y1qw4wqhk346odVlcAtOgQHPxIoN3iAWRg=;
        b=EUG8cfN5H803CPQxy28VMChoEgYlIdQTdCPp7z8u5d6MWv0shbMKNnB/LtzmhA/V+vwAEn
        xYquSUWwyvIs5I/NwH6KkR9HnJrY0nLOzvpA7DZ18RcZlVnH5OpK1CK99qN4ZpQqzRxJ9z
        F2YBTTThvP2nSebq1AMYHY1b/DwYbvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-gCUorG1sOe-xsBcOv9_2dQ-1; Mon, 04 Apr 2022 08:27:41 -0400
X-MC-Unique: gCUorG1sOe-xsBcOv9_2dQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F24A101A52C;
        Mon,  4 Apr 2022 12:27:38 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CF1F407E1C3;
        Mon,  4 Apr 2022 12:27:33 +0000 (UTC)
Message-ID: <2401bf729beab6d9348fda18f55e90ed9c1f7583.camel@redhat.com>
Subject: Re: [PATCH 8/8] KVM: selftests: nSVM: Add
 svm_nested_soft_inject_test
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Mon, 04 Apr 2022 15:27:31 +0300
In-Reply-To: <20220402010903.727604-9-seanjc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
         <20220402010903.727604-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-02 at 01:09 +0000, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Add a KVM self-test that checks whether a nSVM L1 is able to successfully
> inject a software interrupt and a soft exception into its L2 guest.
> 
> In practice, this tests both the next_rip field consistency and
> L1-injected event with intervening L0 VMEXIT during its delivery:
> the first nested VMRUN (that's also trying to inject a software interrupt)
> will immediately trigger a L0 NPF.
> This L0 NPF will have zero in its CPU-returned next_rip field, which if
> incorrectly reused by KVM will trigger a #PF when trying to return to
> such address 0 from the interrupt handler.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
>  .../kvm/x86_64/svm_nested_soft_inject_test.c  | 147 ++++++++++++++++++
>  4 files changed, 151 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 1f1b6c978bf7..1354d3f4a362 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -33,6 +33,7 @@
>  /x86_64/state_test
>  /x86_64/svm_vmcall_test
>  /x86_64/svm_int_ctl_test
> +/x86_64/svm_nested_soft_inject_test
>  /x86_64/sync_regs_test
>  /x86_64/tsc_msrs_test
>  /x86_64/userspace_io_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c9cdbd248727..cef6d583044b 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -66,6 +66,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
> +TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
>  TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
>  TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> index a25aabd8f5e7..d49f7c9b4564 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> @@ -16,6 +16,8 @@
>  #define CPUID_SVM_BIT		2
>  #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
>  
> +#define SVM_EXIT_EXCP_BASE	0x040
> +#define SVM_EXIT_HLT		0x078
>  #define SVM_EXIT_MSR		0x07c
>  #define SVM_EXIT_VMMCALL	0x081
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> new file mode 100644
> index 000000000000..d39be5d885c1
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> @@ -0,0 +1,147 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Oracle and/or its affiliates.
> + *
> + * Based on:
> + *   svm_int_ctl_test
> + *
> + *   Copyright (C) 2021, Red Hat, Inc.
> + *
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +#define VCPU_ID		0
> +#define INT_NR			0x20
> +#define X86_FEATURE_NRIPS	BIT(3)
> +
> +#define vmcall()		\
> +	__asm__ __volatile__(	\
> +		"vmmcall\n"	\
> +		)
> +
> +#define ud2()			\
> +	__asm__ __volatile__(	\
> +		"ud2\n"	\
> +		)
> +
> +#define hlt()			\
> +	__asm__ __volatile__(	\
> +		"hlt\n"	\
> +		)

Minor nitpick: I guess it would be nice to put these in some common header file.


> +
> +static unsigned int bp_fired;
> +static void guest_bp_handler(struct ex_regs *regs)
> +{
> +	bp_fired++;
> +}
> +
> +static unsigned int int_fired;
> +static void guest_int_handler(struct ex_regs *regs)
> +{
> +	int_fired++;
> +}
> +
> +static void l2_guest_code(void)
> +{
> +	GUEST_ASSERT(int_fired == 1);
> +	vmcall();
> +	ud2();
> +
> +	GUEST_ASSERT(bp_fired == 1);
> +	hlt();
> +}


Yes, I was right - the test indeed has no either INT 0x20 nor INT 3 in the L2 guest code,
and yet this should work.

> +
> +static void l1_guest_code(struct svm_test_data *svm)
> +{
> +	#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	struct vmcb *vmcb = svm->vmcb;
> +
> +	/* Prepare for L2 execution. */
> +	generic_svm_setup(svm, l2_guest_code,
> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	vmcb->control.intercept_exceptions |= BIT(PF_VECTOR) | BIT(UD_VECTOR);
> +	vmcb->control.intercept |= BIT(INTERCEPT_HLT);
> +
> +	vmcb->control.event_inj = INT_NR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_SOFT;
> +	/* The return address pushed on stack */
> +	vmcb->control.next_rip = vmcb->save.rip;

I'll would be putting even something more spicy here just to see that KVM preserves this field
like say put two ud2 in the start of guest code, and here have

vmcb->control.next_rip = vmcb->save.rip + 4; // skip over two ud2 instructions.

That way KVM won't be able to skip over a single instruction to get correct next_rip

> +
> +	run_guest(vmcb, svm->vmcb_gpa);
> +	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
> +		       vmcb->control.exit_code,
> +		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
> +
> +	/* Skip over VMCALL */
> +	vmcb->save.rip += 3;
> +
> +	vmcb->control.event_inj = BP_VECTOR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
> +	/* The return address pushed on stack, skip over UD2 */
> +	vmcb->control.next_rip = vmcb->save.rip + 2;
> +
> +	run_guest(vmcb, svm->vmcb_gpa);
> +	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_HLT,
> +		       vmcb->control.exit_code,
> +		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
> +
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_cpuid_entry2 *cpuid;
> +	struct kvm_vm *vm;
> +	vm_vaddr_t svm_gva;
> +	struct kvm_guest_debug debug;
> +
> +	nested_svm_check_supported();
> +
> +	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
> +	if (!(cpuid->edx & X86_FEATURE_NRIPS)) {
> +		print_skip("nRIP Save unavailable");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vm, VCPU_ID);
> +
> +	vm_install_exception_handler(vm, BP_VECTOR, guest_bp_handler);
> +	vm_install_exception_handler(vm, INT_NR, guest_int_handler);
> +
> +	vcpu_alloc_svm(vm, &svm_gva);
> +	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
> +
> +	memset(&debug, 0, sizeof(debug));
> +	vcpu_set_guest_debug(vm, VCPU_ID, &debug);
> +
> +	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +	struct ucall uc;
> +
> +	vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +		    run->exit_reason,
> +		    exit_reason_str(run->exit_reason));
> +
> +	switch (get_ucall(vm, VCPU_ID, &uc)) {
> +	case UCALL_ABORT:
> +		TEST_FAIL("%s at %s:%ld, vals = 0x%lx 0x%lx 0x%lx", (const char *)uc.args[0],
> +			  __FILE__, uc.args[1], uc.args[2], uc.args[3], uc.args[4]);
> +		break;
> +		/* NOT REACHED */
> +	case UCALL_DONE:
> +		goto done;
> +	default:
> +		TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
> +	}
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}


Other that nitpicks:

Reviewed-by: Maxim levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


