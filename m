Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A92F5231EB
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiEKLfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240401AbiEKLfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:35:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 947B82311C4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xhRkRTM1s3XCqG7usuDSzmUS6nbMcfodiMVzITNLyzA=;
        b=M8v9gk+Gn6dYDRpus2ueBVS7hdwRMIz+TzHkNiBuU7V1CMXJoY8LVvo2o0+PTT+ww6TFUe
        kEg+VPbUHtwO7OGoBK0zB81EjuUkewTASrxpyggzw+t+k2h+4Biun0Hq5a8DRPYvqo81Yp
        DQ+BnooNX9GK8w9+fSww/CSeqx7oFzw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-1ufYHWCKNwSub6A4TqBAEw-1; Wed, 11 May 2022 07:35:22 -0400
X-MC-Unique: 1ufYHWCKNwSub6A4TqBAEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED011800882;
        Wed, 11 May 2022 11:35:21 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74ECB1121314;
        Wed, 11 May 2022 11:35:19 +0000 (UTC)
Message-ID: <eadde57a313dd70d9409791c2368828f6bd9b083.camel@redhat.com>
Subject: Re: [PATCH v3 24/34] KVM: selftests: Hyper-V PV IPI selftest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:35:18 +0300
In-Reply-To: <20220414132013.1588929-25-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-25-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> Introduce a selftest for Hyper-V PV IPI hypercalls
> (HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx).
> 
> The test creates one 'sender' vCPU and two 'receiver' vCPU and then
> issues various combinations of send IPI hypercalls in both 'normal'
> and 'fast' (with XMM input where necessary) mode. Later, the test
> checks whether IPIs were delivered to the expected destination vCPU[s].
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/hyperv.h     |   3 +
>  .../selftests/kvm/x86_64/hyperv_features.c    |   5 +-
>  .../testing/selftests/kvm/x86_64/hyperv_ipi.c | 374 ++++++++++++++++++
>  5 files changed, 381 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 56140068b763..5d5fbb161d56 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -23,6 +23,7 @@
>  /x86_64/hyperv_clock
>  /x86_64/hyperv_cpuid
>  /x86_64/hyperv_features
> +/x86_64/hyperv_ipi
>  /x86_64/hyperv_svm_test
>  /x86_64/mmio_warning_test
>  /x86_64/mmu_role_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index af582d168621..44889f897fe7 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -52,6 +52,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
> +TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index b66910702c0a..f51d6fab8e93 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -184,5 +184,8 @@
>  
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT		BIT(16)
> +#define HV_HYPERCALL_VARHEAD_OFFSET	17
> +
> +#define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
>  
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 672915ce73d8..98c020356925 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -14,7 +14,6 @@
>  #include "hyperv.h"
>  
>  #define VCPU_ID 0
> -#define LINUX_OS_ID ((u64)0x8100 << 48)
>  
>  extern unsigned char rdmsr_start;
>  extern unsigned char rdmsr_end;
> @@ -127,7 +126,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>  	int i = 0;
>  	u64 res, input, output;
>  
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
>  	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
>  
>  	while (hcall->control) {
> @@ -230,7 +229,7 @@ static void guest_test_msrs_access(void)
>  			 */
>  			msr->idx = HV_X64_MSR_GUEST_OS_ID;
>  			msr->write = 1;
> -			msr->write_val = LINUX_OS_ID;
> +			msr->write_val = HYPERV_LINUX_OS_ID;
>  			msr->available = 1;
>  			break;
>  		case 3:

Nitpick: I think that the HYPERV_LINUX_OS_ID change should be in a separate patch.


> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> new file mode 100644
> index 000000000000..075963c32d45
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
> @@ -0,0 +1,374 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hyper-V HvCallSendSyntheticClusterIpi{,Ex} tests
> + *
> + * Copyright (C) 2022, Red Hat, Inc.
> + *
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <pthread.h>
> +#include <inttypes.h>
> +
> +#include "kvm_util.h"
> +#include "hyperv.h"
> +#include "processor.h"
> +#include "test_util.h"
> +#include "vmx.h"
> +
> +#define SENDER_VCPU_ID   1
> +#define RECEIVER_VCPU_ID_1 2
> +#define RECEIVER_VCPU_ID_2 65
> +
> +#define IPI_VECTOR	 0xfe
> +
> +static volatile uint64_t ipis_rcvd[RECEIVER_VCPU_ID_2 + 1];
> +
> +struct thread_params {
> +	struct kvm_vm *vm;
> +	uint32_t vcpu_id;
> +};
> +
> +struct hv_vpset {
> +	u64 format;
> +	u64 valid_bank_mask;
> +	u64 bank_contents[2];
> +};
> +
> +enum HV_GENERIC_SET_FORMAT {
> +	HV_GENERIC_SET_SPARSE_4K,
> +	HV_GENERIC_SET_ALL,
> +};
> +
> +/* HvCallSendSyntheticClusterIpi hypercall */
> +struct hv_send_ipi {
> +	u32 vector;
> +	u32 reserved;
> +	u64 cpu_mask;
> +};
> +
> +/* HvCallSendSyntheticClusterIpiEx hypercall */
> +struct hv_send_ipi_ex {
> +	u32 vector;
> +	u32 reserved;
> +	struct hv_vpset vp_set;
> +};
> +
> +static inline void hv_init(vm_vaddr_t pgs_gpa)
> +{
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> +}
> +
> +static void receiver_code(void *hcall_page, vm_vaddr_t pgs_gpa)
> +{
> +	u32 vcpu_id;
> +
> +	x2apic_enable();
> +	hv_init(pgs_gpa);
> +
> +	vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
> +
> +	/* Signal sender vCPU we're ready */
> +	ipis_rcvd[vcpu_id] = (u64)-1;
> +
> +	for (;;)
> +		asm volatile("sti; hlt; cli");
> +}
> +
> +static void guest_ipi_handler(struct ex_regs *regs)
> +{
> +	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
> +
> +	ipis_rcvd[vcpu_id]++;
> +	wrmsr(HV_X64_MSR_EOI, 1);
> +}
> +
> +static inline u64 hypercall(u64 control, vm_vaddr_t arg1, vm_vaddr_t arg2)
> +{
> +	u64 hv_status;
> +
> +	asm volatile("mov %3, %%r8\n"
> +		     "vmcall"
> +		     : "=a" (hv_status),
> +		       "+c" (control), "+d" (arg1)
> +		     :  "r" (arg2)
> +		     : "cc", "memory", "r8", "r9", "r10", "r11");
> +
> +	return hv_status;
> +}
> +
> +static inline void nop_loop(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < 100000000; i++)
> +		asm volatile("nop");
> +}
> +
> +static inline void sync_to_xmm(void *data)
> +{
> +	int i;
> +
> +	for (i = 0; i < 8; i++)
> +		write_sse_reg(i, (sse128_t *)(data + sizeof(sse128_t) * i));
> +}
> +
> +static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
> +{
> +	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
> +	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
> +	int stage = 1, ipis_expected[2] = {0};
> +	u64 res;
> +
> +	hv_init(pgs_gpa);
> +	GUEST_SYNC(stage++);
> +
> +	/* Wait for receiver vCPUs to come up */
> +	while (!ipis_rcvd[RECEIVER_VCPU_ID_1] || !ipis_rcvd[RECEIVER_VCPU_ID_2])
> +		nop_loop();
> +	ipis_rcvd[RECEIVER_VCPU_ID_1] = ipis_rcvd[RECEIVER_VCPU_ID_2] = 0;
> +
> +	/* 'Slow' HvCallSendSyntheticClusterIpi to RECEIVER_VCPU_ID_1 */
> +	ipi->vector = IPI_VECTOR;
> +	ipi->cpu_mask = 1 << RECEIVER_VCPU_ID_1;
> +	res = hypercall(HVCALL_SEND_IPI, pgs_gpa, pgs_gpa + 4096);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +	/* 'Fast' HvCallSendSyntheticClusterIpi to RECEIVER_VCPU_ID_1 */
> +	res = hypercall(HVCALL_SEND_IPI | HV_HYPERCALL_FAST_BIT,
> +			IPI_VECTOR, 1 << RECEIVER_VCPU_ID_1);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +
> +	/* 'Slow' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_1 */
> +	memset(hcall_page, 0, 4096);
> +	ipi_ex->vector = IPI_VECTOR;
> +	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +	ipi_ex->vp_set.valid_bank_mask = 1 << 0;
> +	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_1);
> +	res = hypercall(HVCALL_SEND_IPI_EX | (1 << HV_HYPERCALL_VARHEAD_OFFSET),
> +			pgs_gpa, pgs_gpa + 4096);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_1 */
> +	sync_to_xmm(&ipi_ex->vp_set.valid_bank_mask);
> +	res = hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT |
> +			(1 << HV_HYPERCALL_VARHEAD_OFFSET),
> +			IPI_VECTOR, HV_GENERIC_SET_SPARSE_4K);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +
> +	/* 'Slow' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_2 */
> +	memset(hcall_page, 0, 4096);
> +	ipi_ex->vector = IPI_VECTOR;
> +	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +	ipi_ex->vp_set.valid_bank_mask = 1 << 1;
> +	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_2 - 64);
> +	res = hypercall(HVCALL_SEND_IPI_EX | (1 << HV_HYPERCALL_VARHEAD_OFFSET),
> +			pgs_gpa, pgs_gpa + 4096);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_2 */
> +	sync_to_xmm(&ipi_ex->vp_set.valid_bank_mask);
> +	res = hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT |
> +			(1 << HV_HYPERCALL_VARHEAD_OFFSET),
> +			IPI_VECTOR, HV_GENERIC_SET_SPARSE_4K);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +
> +	/* 'Slow' HvCallSendSyntheticClusterIpiEx to both RECEIVER_VCPU_ID_{1,2} */
> +	memset(hcall_page, 0, 4096);
> +	ipi_ex->vector = IPI_VECTOR;
> +	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +	ipi_ex->vp_set.valid_bank_mask = 1 << 1 | 1;
> +	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_1);
> +	ipi_ex->vp_set.bank_contents[1] = BIT(RECEIVER_VCPU_ID_2 - 64);
> +	res = hypercall(HVCALL_SEND_IPI_EX | (2 << HV_HYPERCALL_VARHEAD_OFFSET),
> +			pgs_gpa, pgs_gpa + 4096);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to both RECEIVER_VCPU_ID_{1, 2} */
> +	sync_to_xmm(&ipi_ex->vp_set.valid_bank_mask);
> +	res = hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT |
> +			(2 << HV_HYPERCALL_VARHEAD_OFFSET),
> +			IPI_VECTOR, HV_GENERIC_SET_SPARSE_4K);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +
> +	/* 'Slow' HvCallSendSyntheticClusterIpiEx to HV_GENERIC_SET_ALL */
> +	memset(hcall_page, 0, 4096);
> +	ipi_ex->vector = IPI_VECTOR;
> +	ipi_ex->vp_set.format = HV_GENERIC_SET_ALL;
> +	res = hypercall(HVCALL_SEND_IPI_EX,
> +			pgs_gpa, pgs_gpa + 4096);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to HV_GENERIC_SET_ALL */
> +	sync_to_xmm(&ipi_ex->vp_set.valid_bank_mask);
> +	res = hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT,
> +			IPI_VECTOR, HV_GENERIC_SET_ALL);
> +	GUEST_ASSERT((res & 0xffff) == 0);
> +	nop_loop();
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
> +	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
> +	GUEST_SYNC(stage++);
> +
> +	GUEST_DONE();
> +}
> +
> +static void *vcpu_thread(void *arg)
> +{
> +	struct thread_params *params = (struct thread_params *)arg;
> +	struct ucall uc;
> +	int old;
> +	int r;
> +	unsigned int exit_reason;
> +
> +	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
> +		    params->vcpu_id, r);
> +
> +	vcpu_run(params->vm, params->vcpu_id);
> +	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
> +
> +	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
> +		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
> +		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
> +
> +	if (get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_ABORT) {
> +		TEST_ASSERT(false,
> +			    "vCPU %u exited with error: %s.\n",
> +			    params->vcpu_id, (const char *)uc.args[0]);
> +	}
> +
> +	return NULL;
> +}
> +
> +static void cancel_join_vcpu_thread(pthread_t thread, uint32_t vcpu_id)
> +{
> +	void *retval;
> +	int r;
> +
> +	r = pthread_cancel(thread);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_cancel on vcpu_id=%d failed with errno=%d",
> +		    vcpu_id, r);
> +
> +	r = pthread_join(thread, &retval);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_join on vcpu_id=%d failed with errno=%d",
> +		    vcpu_id, r);
> +	TEST_ASSERT(retval == PTHREAD_CANCELED,
> +		    "expected retval=%p, got %p", PTHREAD_CANCELED,
> +		    retval);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int r;
> +	pthread_t threads[2];
> +	struct thread_params params[2];
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +	vm_vaddr_t hcall_page;
> +	struct ucall uc;
> +	int stage = 1;
> +
> +	vm = vm_create_default(SENDER_VCPU_ID, 0, sender_guest_code);
> +	params[0].vm = vm;
> +	params[1].vm = vm;
> +
> +	/* Hypercall input/output */
> +	hcall_page = vm_vaddr_alloc_pages(vm, 2);
> +	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
> +
> +	vm_init_descriptor_tables(vm);
> +
> +	vm_vcpu_add_default(vm, RECEIVER_VCPU_ID_1, receiver_code);
> +	vcpu_init_descriptor_tables(vm, RECEIVER_VCPU_ID_1);
> +	vcpu_args_set(vm, RECEIVER_VCPU_ID_1, 2, hcall_page, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_msr(vm, RECEIVER_VCPU_ID_1, HV_X64_MSR_VP_INDEX, RECEIVER_VCPU_ID_1);
> +	vcpu_set_hv_cpuid(vm, RECEIVER_VCPU_ID_1);
> +
> +	vm_vcpu_add_default(vm, RECEIVER_VCPU_ID_2, receiver_code);
> +	vcpu_init_descriptor_tables(vm, RECEIVER_VCPU_ID_2);
> +	vcpu_args_set(vm, RECEIVER_VCPU_ID_2, 2, hcall_page, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_msr(vm, RECEIVER_VCPU_ID_2, HV_X64_MSR_VP_INDEX, RECEIVER_VCPU_ID_2);
> +	vcpu_set_hv_cpuid(vm, RECEIVER_VCPU_ID_2);
> +
> +	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> +
> +	vcpu_args_set(vm, SENDER_VCPU_ID, 2, hcall_page, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_hv_cpuid(vm, SENDER_VCPU_ID);
> +
> +	params[0].vcpu_id = RECEIVER_VCPU_ID_1;
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_create halter failed errno=%d", errno);
> +
> +	params[1].vcpu_id = RECEIVER_VCPU_ID_2;
> +	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_create halter failed errno=%d", errno);
> +
> +	run = vcpu_state(vm, SENDER_VCPU_ID);
> +
> +	while (true) {
> +		r = _vcpu_run(vm, SENDER_VCPU_ID);
> +		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "unexpected exit reason: %u (%s)",
> +			    run->exit_reason, exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, SENDER_VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			TEST_ASSERT(uc.args[1] == stage,
> +				    "Unexpected stage: %ld (%d expected)\n",
> +				    uc.args[1], stage);
> +			break;
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
> +				  __FILE__, uc.args[1]);
> +			return 1;
> +		case UCALL_DONE:
> +			return 0;
> +		}
> +
> +		stage++;
> +	}
> +
> +	cancel_join_vcpu_thread(threads[0], RECEIVER_VCPU_ID_1);
> +	cancel_join_vcpu_thread(threads[1], RECEIVER_VCPU_ID_2);
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}


Looks overall good to me, but I might have missed something.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky




