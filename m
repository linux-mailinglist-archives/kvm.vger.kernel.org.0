Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF715232C5
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbiEKMRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiEKMRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:17:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95A3945523
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U2Fiyg3dLOfcRHnVihb6T3YG51gyrTAXADZT1yCe1SU=;
        b=hrtIxR989Iii+wjbYr3MSfOJVSrxAInkHcZ46bs/YDK+yfRqKmKIyrHke2iNI++NrHJW2c
        NM/oEs1pF4KO7lccfU8tNfChAkkadmT5GPvg7LsYrnWF1CQBeUJXKKoc40of5VrS7wdn0P
        cj5hqKt2eI61GBmNPCELROV3MTR6NX0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-Ie3IecJWNpSG49fLHh_RMQ-1; Wed, 11 May 2022 08:17:14 -0400
X-MC-Unique: Ie3IecJWNpSG49fLHh_RMQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDAA1185A794;
        Wed, 11 May 2022 12:17:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FAE6416385;
        Wed, 11 May 2022 12:17:10 +0000 (UTC)
Message-ID: <fd38937d4305bf606e0da687fc11b4866f575275.camel@redhat.com>
Subject: Re: [PATCH v3 26/34] KVM: selftests: Hyper-V PV TLB flush selftest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:17:09 +0300
In-Reply-To: <20220414132013.1588929-27-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-27-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> Introduce a selftest for Hyper-V PV TLB flush hypercalls
> (HvFlushVirtualAddressSpace/HvFlushVirtualAddressSpaceEx,
> HvFlushVirtualAddressList/HvFlushVirtualAddressListEx).
> 
> The test creates one 'sender' vCPU and two 'worker' vCPU which do busy
> loop reading from a certain GVA checking the observed value. Sender
> vCPU drops to the host to swap the data page with another page filled
> with a different value. The expectation for workers is also
> altered. Without TLB flush on worker vCPUs, they may continue to
> observe old value. To guard against accidental TLB flushes for worker
> vCPUs the test is repeated 100 times.
> 
> Hyper-V TLB flush hypercalls are tested in both 'normal' and 'XMM
> fast' modes.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/hyperv.h     |   1 +
>  .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 647 ++++++++++++++++++
>  4 files changed, 650 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 5d5fbb161d56..1a1d09e414d5 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -25,6 +25,7 @@
>  /x86_64/hyperv_features
>  /x86_64/hyperv_ipi
>  /x86_64/hyperv_svm_test
> +/x86_64/hyperv_tlb_flush
>  /x86_64/mmio_warning_test
>  /x86_64/mmu_role_test
>  /x86_64/platform_info_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 44889f897fe7..8b83abc09a1a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -54,6 +54,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
> +TEST_GEN_PROGS_x86_64 += x86_64/hyperv_tlb_flush
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index f51d6fab8e93..1e34dd7c5075 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -185,6 +185,7 @@
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT		BIT(16)
>  #define HV_HYPERCALL_VARHEAD_OFFSET	17
> +#define HV_HYPERCALL_REP_COMP_OFFSET	32
>  
>  #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
> new file mode 100644
> index 000000000000..00bcae45ddd2
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
> @@ -0,0 +1,647 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hyper-V HvFlushVirtualAddress{List,Space}{,Ex} tests
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
> +#define WORKER_VCPU_ID_1 2
> +#define WORKER_VCPU_ID_2 65
> +
> +#define NTRY 100
> +
> +struct thread_params {
> +	struct kvm_vm *vm;
> +	uint32_t vcpu_id;
> +};
> +
> +struct hv_vpset {
> +	u64 format;
> +	u64 valid_bank_mask;
> +	u64 bank_contents[];
> +};
> +
> +enum HV_GENERIC_SET_FORMAT {
> +	HV_GENERIC_SET_SPARSE_4K,
> +	HV_GENERIC_SET_ALL,
> +};
> +
> +#define HV_FLUSH_ALL_PROCESSORS			BIT(0)
> +#define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
> +#define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
> +#define HV_FLUSH_USE_EXTENDED_RANGE_FORMAT	BIT(3)
> +
> +/* HvFlushVirtualAddressSpace, HvFlushVirtualAddressList hypercalls */
> +struct hv_tlb_flush {
> +	u64 address_space;
> +	u64 flags;
> +	u64 processor_mask;
> +	u64 gva_list[];
> +} __packed;
> +
> +/* HvFlushVirtualAddressSpaceEx, HvFlushVirtualAddressListEx hypercalls */
> +struct hv_tlb_flush_ex {
> +	u64 address_space;
> +	u64 flags;
> +	struct hv_vpset hv_vp_set;
> +	u64 gva_list[];
> +} __packed;
> +
> +static inline void hv_init(vm_vaddr_t pgs_gpa)
> +{
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> +}
> +
> +static void worker_code(void *test_pages, vm_vaddr_t pgs_gpa)
> +{
> +	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
> +	unsigned char chr;
> +
> +	x2apic_enable();
> +	hv_init(pgs_gpa);
> +
> +	for (;;) {
> +		chr = READ_ONCE(*(unsigned char *)(test_pages + 4096 * 2 + vcpu_id));
It would be nice to wrap this into a function, like set_expected_char does for ease
of code understanding.

> +		if (chr)
> +			GUEST_ASSERT(*(unsigned char *)test_pages == chr);
> +		asm volatile("nop");
> +	}
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
> +	for (i = 0; i < 10000000; i++)
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

Nitpick: I see duplicated code, I complain ;-) - maybe put the above to some common file?

> +
> +static void set_expected_char(void *addr, unsigned char chr, int vcpu_id)
> +{
> +	asm volatile("mfence");

I remember that Paolo once told me (I might not remember that correctly though),
that on x86 the actual hardware barriers like mfence are not really
needed, because hardware already does memory accesses in order,
unless fancy (e.g non WB) memory types are used.

> +	*(unsigned char *)(addr + 2 * 4096 + vcpu_id) = chr;
> +}
> +
> +static void sender_guest_code(void *hcall_page, void *test_pages, vm_vaddr_t pgs_gpa)
> +{
> +	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)hcall_page;
> +	struct hv_tlb_flush_ex *flush_ex = (struct hv_tlb_flush_ex *)hcall_page;
> +	int stage = 1, i;
> +	u64 res;
> +
> +	hv_init(pgs_gpa);
> +
> +	/* "Slow" hypercalls */

I hopefully understand it correctly, see my comments below,
but it might be worthy to add something similar to my comments
to the code to make it easier for someone reading the code to understand it.

> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for WORKER_VCPU_ID_1 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);

Here we set expected char to 0, meaning that now workers will not assert
if there is mismatch.

> +		GUEST_SYNC(stage++);
Now there is a mismatch, the host swapped pages for us.

> +		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE, pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);

Now we flushed the TLB, the guest should see correct value.

> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);

Now we force the workers to check it.

Btw, an idea: it might be nice to use more that two test pages,
like say 100 test pages each filled with different value,
memory is cheap, and this way there will be no way for something
to cause 'double error' which could hide the bug by a chance.


Another thing, it might be nice to wrap this into a macro/function
to avoid *that* much duplication.


> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for WORKER_VCPU_ID_1 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
> +		flush->gva_list[0] = (u64)test_pages;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for HV_FLUSH_ALL_PROCESSORS */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS;
> +		flush->processor_mask = 0;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE, pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for HV_FLUSH_ALL_PROCESSORS */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS;
> +		flush->gva_list[0] = (u64)test_pages;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for WORKER_VCPU_ID_2 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
> +				(1 << HV_HYPERCALL_VARHEAD_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for WORKER_VCPU_ID_2 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		/* bank_contents and gva_list occupy the same space, thus [1] */
> +		flush_ex->gva_list[1] = (u64)test_pages;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
> +				(1 << HV_HYPERCALL_VARHEAD_OFFSET) |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for both vCPUs */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64) |
> +			BIT_ULL(WORKER_VCPU_ID_1 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
> +		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
> +				(2 << HV_HYPERCALL_VARHEAD_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for both vCPUs */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_1 / 64) |
> +			BIT_ULL(WORKER_VCPU_ID_2 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
> +		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		/* bank_contents and gva_list occupy the same space, thus [2] */
> +		flush_ex->gva_list[2] = (u64)test_pages;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
> +				(2 << HV_HYPERCALL_VARHEAD_OFFSET) |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for HV_GENERIC_SET_ALL */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX,
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for HV_GENERIC_SET_ALL */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
> +		flush_ex->gva_list[0] = (u64)test_pages;
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				pgs_gpa, pgs_gpa + 4096);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* "Fast" hypercalls */
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for WORKER_VCPU_ID_1 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
> +		sync_to_xmm(&flush->processor_mask);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
> +				HV_HYPERCALL_FAST_BIT, 0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for WORKER_VCPU_ID_1 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
> +		flush->gva_list[0] = (u64)test_pages;
> +		sync_to_xmm(&flush->processor_mask);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST | HV_HYPERCALL_FAST_BIT |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for HV_FLUSH_ALL_PROCESSORS */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		sync_to_xmm(&flush->processor_mask);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +				HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for HV_FLUSH_ALL_PROCESSORS */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush->gva_list[0] = (u64)test_pages;
> +		sync_to_xmm(&flush->processor_mask);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST | HV_HYPERCALL_FAST_BIT |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET), 0x0,
> +				HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for WORKER_VCPU_ID_2 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		sync_to_xmm(&flush_ex->hv_vp_set);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX | HV_HYPERCALL_FAST_BIT |
> +				(1 << HV_HYPERCALL_VARHEAD_OFFSET),
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for WORKER_VCPU_ID_2 */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		/* bank_contents and gva_list occupy the same space, thus [1] */
> +		flush_ex->gva_list[1] = (u64)test_pages;
> +		sync_to_xmm(&flush_ex->hv_vp_set);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX | HV_HYPERCALL_FAST_BIT |
> +				(1 << HV_HYPERCALL_VARHEAD_OFFSET) |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for both vCPUs */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64) |
> +			BIT_ULL(WORKER_VCPU_ID_1 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
> +		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		sync_to_xmm(&flush_ex->hv_vp_set);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX | HV_HYPERCALL_FAST_BIT |
> +				(2 << HV_HYPERCALL_VARHEAD_OFFSET),
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for both vCPUs */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> +		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_1 / 64) |
> +			BIT_ULL(WORKER_VCPU_ID_2 / 64);
> +		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
> +		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
> +		/* bank_contents and gva_list occupy the same space, thus [2] */
> +		flush_ex->gva_list[2] = (u64)test_pages;
> +		sync_to_xmm(&flush_ex->hv_vp_set);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX | HV_HYPERCALL_FAST_BIT |
> +				(2 << HV_HYPERCALL_VARHEAD_OFFSET) |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for HV_GENERIC_SET_ALL */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
> +		sync_to_xmm(&flush_ex->hv_vp_set);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX | HV_HYPERCALL_FAST_BIT,
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
> +
> +	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for HV_GENERIC_SET_ALL */
> +	for (i = 0; i < NTRY; i++) {
> +		memset(hcall_page, 0, 4096);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, 0x0, WORKER_VCPU_ID_2);
> +		GUEST_SYNC(stage++);
> +		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
> +		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
> +		flush_ex->gva_list[0] = (u64)test_pages;
> +		sync_to_xmm(&flush_ex->hv_vp_set);
> +		res = hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX | HV_HYPERCALL_FAST_BIT |
> +				(1UL << HV_HYPERCALL_REP_COMP_OFFSET),
> +				0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
> +		GUEST_ASSERT((res & 0xffff) == 0);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_1);
> +		set_expected_char(test_pages, i % 2 ? 0x1 : 0x2, WORKER_VCPU_ID_2);
> +		nop_loop();
> +	}
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
> +	vm_vaddr_t hcall_page, test_pages;
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
> +	/*
> +	 * Test pages: the first one is filled with '0x1's, the second with '0x2's
> +	 * and the test will swap their mappings. The third page keeps the indication
> +	 * about the current state of mappings.
> +	 */
> +	test_pages = vm_vaddr_alloc_pages(vm, 3);
> +	memset(addr_gva2hva(vm, test_pages), 0x1, 4096);
> +	memset(addr_gva2hva(vm, test_pages) + 4096, 0x2, 4096);
> +	set_expected_char(addr_gva2hva(vm, test_pages), 0x0, WORKER_VCPU_ID_1);
> +	set_expected_char(addr_gva2hva(vm, test_pages), 0x0, WORKER_VCPU_ID_2);
> +
> +	vm_vcpu_add_default(vm, WORKER_VCPU_ID_1, worker_code);
> +	vcpu_args_set(vm, WORKER_VCPU_ID_1, 2, test_pages, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_msr(vm, WORKER_VCPU_ID_1, HV_X64_MSR_VP_INDEX, WORKER_VCPU_ID_1);
> +	vcpu_set_hv_cpuid(vm, WORKER_VCPU_ID_1);
> +
> +	vm_vcpu_add_default(vm, WORKER_VCPU_ID_2, worker_code);
> +	vcpu_args_set(vm, WORKER_VCPU_ID_2, 2, test_pages, addr_gva2gpa(vm, hcall_page));
> +	vcpu_set_msr(vm, WORKER_VCPU_ID_2, HV_X64_MSR_VP_INDEX, WORKER_VCPU_ID_2);
> +	vcpu_set_hv_cpuid(vm, WORKER_VCPU_ID_2);
> +
> +	vcpu_args_set(vm, SENDER_VCPU_ID, 3, hcall_page, test_pages,
> +		      addr_gva2gpa(vm, hcall_page));

It seems that all worker vCPUs get pointer to the hypercall page,
which they don't need and if used will create a race.


> +	vcpu_set_hv_cpuid(vm, SENDER_VCPU_ID);
> +
> +	params[0].vcpu_id = WORKER_VCPU_ID_1;
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_create halter failed errno=%d", errno);
> +
> +	params[1].vcpu_id = WORKER_VCPU_ID_2;
> +	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_create halter failed errno=%d", errno);

Also here worker threads don't halt, the message was not updated I think.


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
> +		/* Swap test pages */
> +		if (stage % 2) {
> +			__virt_pg_map(vm, test_pages, addr_gva2gpa(vm, test_pages) + 4096,
> +				      X86_PAGE_SIZE_4K, true);
> +			__virt_pg_map(vm, test_pages + 4096, addr_gva2gpa(vm, test_pages) - 4096,
> +				      X86_PAGE_SIZE_4K, true);
> +		} else {
> +			__virt_pg_map(vm, test_pages, addr_gva2gpa(vm, test_pages) - 4096,
> +				      X86_PAGE_SIZE_4K, true);
> +			__virt_pg_map(vm, test_pages + 4096, addr_gva2gpa(vm, test_pages) + 4096,
> +				      X86_PAGE_SIZE_4K, true);
> +		}

Another question: why the host doing the swapping of the pages? Since !EPT/!NPT is not the goal of this test,

no doubt, why not let the guest vCPU (the sender) do the swapping, which should eliminate the VM exits
to the host (which can interfere with TLB flush even) and make it closer to the real world usage.


> +
> +		stage++;
> +	}
> +
> +	cancel_join_vcpu_thread(threads[0], WORKER_VCPU_ID_1);
> +	cancel_join_vcpu_thread(threads[1], WORKER_VCPU_ID_2);
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}


Best regards,
	Maxim Levitsky


