Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9DF2CB44C
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 06:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgLBFUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 00:20:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60286 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgLBFUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 00:20:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B255TcY194972;
        Wed, 2 Dec 2020 05:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nzpIOmReDUKMlG2lhhF3JsJuycrwPw8krJ0kN8yBnvE=;
 b=yjCu3ZE+PVxJi8QyzpiPD37UndCvY61hUfKOS54cPUFdryDO82sMnN5GGQzZhxmKMIAo
 NXCIgNZPgSFNrnRMm3mROCZdAxYq9hFOd7t86N48Dk9wRwLV/pIf6BqK3g7wHjYAawmy
 1tz/HeGk1Oxha+eHGPwJjpK9T32dfT60uLcAcDiH37fKo++UU7igzc+rlFBzBP3WCQYn
 IHEAs7NPiSRZ4NT0hSHKm21hSWRE79gChDf5YfopmBUbyyvM6sUQjPrfCWQopRuhgQUZ
 KNbJqmhCNw3KBPh68fXwqq5nv+LfAmYXNVObkPvIdhDVQcvoCxSK9AmDEXmKQL753+jc gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2axcb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 05:19:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B251Mx0076988;
        Wed, 2 Dec 2020 05:19:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fy2994-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 05:19:38 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B25Ja8k029723;
        Wed, 2 Dec 2020 05:19:37 GMT
Received: from [192.168.0.108] (/70.36.60.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 21:19:36 -0800
Subject: Re: [PATCH RFC 02/39] KVM: x86/xen: intercept xen hypercalls if
 enabled
To:     David Woodhouse <dwmw2@infradead.org>,
        Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-3-joao.m.martins@oracle.com>
 <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <240b82b3-9621-8b08-6d37-75da6a61b3ce@oracle.com>
Date:   Tue, 1 Dec 2020 21:19:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-01 1:48 a.m., David Woodhouse wrote:
> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>> Add a new exit reason for emulator to handle Xen hypercalls.
>> Albeit these are injected only if guest has initialized the Xen
>> hypercall page
> 
> I've reworked this a little.
> 
> I didn't like the inconsistency of allowing userspace to provide the
> hypercall pages even though the ABI is now defined by the kernel and it
> *has* to be VMCALL/VMMCALL.
> 
> So I switched it to generate the hypercall page directly from the
> kernel, just like we do for the Hyper-V hypercall page.
> 
> I introduced a new flag in the xen_hvm_config struct to enable this
> behaviour, and advertised it in the KVM_CAP_XEN_HVM return value.
> 
> I also added the cpl and support for 6-argument hypercalls, and made it
> check the guest RIP when completing the call as discussed (although I
> still think that probably ought to be a generic thing).
> 
> I adjusted the test case from my version of the patch, and added
> support for actually testing the hypercall page MSR.
> 
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xenpv
> 
> I'll go through and rebase your patch series at least up to patch 16
> and collect them in that tree, then probably post them for real once
> I've got everything working locally.
> 
> 
> =======================
>  From c037c329c8867b219afe2100e383c62e9db7b06d Mon Sep 17 00:00:00 2001
> From: Joao Martins <joao.m.martins@oracle.com>
> Date: Wed, 13 Jun 2018 09:55:44 -0400
> Subject: [PATCH] KVM: x86/xen: intercept xen hypercalls if enabled
> 
> Add a new exit reason for emulator to handle Xen hypercalls.
> 
> Since this means KVM owns the ABI, dispense with the facility for the
> VMM to provide its own copy of the hypercall pages; just fill them in
> directly using VMCALL/VMMCALL as we do for the Hyper-V hypercall page.
> 
> This behaviour is enabled by a new INTERCEPT_HCALL flag in the
> KVM_XEN_HVM_CONFIG ioctl structure, and advertised by the same flag
> being returned from the KVM_CAP_XEN_HVM check.
> 
> Add a test case and shift xen_hvm_config() to the nascent xen.c while
> we're at it.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/include/asm/kvm_host.h               |   6 +
>   arch/x86/kvm/Makefile                         |   2 +-
>   arch/x86/kvm/trace.h                          |  36 +++++
>   arch/x86/kvm/x86.c                            |  46 +++---
>   arch/x86/kvm/xen.c                            | 140 ++++++++++++++++++
>   arch/x86/kvm/xen.h                            |  21 +++
>   include/uapi/linux/kvm.h                      |  19 +++
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
>   .../selftests/kvm/x86_64/xen_vmcall_test.c    | 123 +++++++++++++++
>   10 files changed, 365 insertions(+), 30 deletions(-)
>   create mode 100644 arch/x86/kvm/xen.c
>   create mode 100644 arch/x86/kvm/xen.h
>   create mode 100644 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
> 

> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> new file mode 100644
> index 000000000000..6400a4bc8480
> --- /dev/null
> +++ b/arch/x86/kvm/xen.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright © 2019 Oracle and/or its affiliates. All rights reserved.
> + * Copyright © 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + *
> + * KVM Xen emulation
> + */
> +
> +#include "x86.h"
> +#include "xen.h"
> +
> +#include <linux/kvm_host.h>
> +
> +#include <trace/events/kvm.h>
> +
> +#include "trace.h"
> +
> +int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
> +	{
> +	struct kvm *kvm = vcpu->kvm;
> +	u32 page_num = data & ~PAGE_MASK;
> +	u64 page_addr = data & PAGE_MASK;
> +
> +	/*
> +	 * If Xen hypercall intercept is enabled, fill the hypercall
> +	 * page with VMCALL/VMMCALL instructions since that's what
> +	 * we catch. Else the VMM has provided the hypercall pages
> +	 * with instructions of its own choosing, so use those.
> +	 */
> +	if (kvm_xen_hypercall_enabled(kvm)) {
> +		u8 instructions[32];
> +		int i;
> +
> +		if (page_num)
> +			return 1;
> +
> +		/* mov imm32, %eax */
> +		instructions[0] = 0xb8;
> +
> +		/* vmcall / vmmcall */
> +		kvm_x86_ops.patch_hypercall(vcpu, instructions + 5);
> +
> +		/* ret */
> +		instructions[8] = 0xc3;
> +
> +		/* int3 to pad */
> +		memset(instructions + 9, 0xcc, sizeof(instructions) - 9);
> +
> +		for (i = 0; i < PAGE_SIZE / sizeof(instructions); i++) {
> +			*(u32 *)&instructions[1] = i;
> +			if (kvm_vcpu_write_guest(vcpu,
> +						 page_addr + (i * sizeof(instructions)),
> +						 instructions, sizeof(instructions)))
> +				return 1;
> +		}

HYPERVISOR_iret isn't supported on 64bit so should be ud2 instead.


Ankur

> +	} else {
> +		int lm = is_long_mode(vcpu);
> +		u8 *blob_addr = lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
> +				   : (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
> +		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
> +				  : kvm->arch.xen_hvm_config.blob_size_32;
> +		u8 *page;
> +
> +		if (page_num >= blob_size)
> +			return 1;
> +
> +		page = memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
> +		if (IS_ERR(page))
> +			return PTR_ERR(page);
> +
> +		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
> +			kfree(page);
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
> +{
> +	kvm_rax_write(vcpu, result);
> +	return kvm_skip_emulated_instruction(vcpu);
> +}
> +
> +static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_run *run = vcpu->run;
> +
> +	if (unlikely(!kvm_is_linear_rip(vcpu, vcpu->arch.xen.hypercall_rip)))
> +		return 1;
> +
> +	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
> +}
> +
> +int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	bool longmode;
> +	u64 input, params[6];
> +
> +	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
> +
> +	longmode = is_64_bit_mode(vcpu);
> +	if (!longmode) {
> +		params[0] = (u32)kvm_rbx_read(vcpu);
> +		params[1] = (u32)kvm_rcx_read(vcpu);
> +		params[2] = (u32)kvm_rdx_read(vcpu);
> +		params[3] = (u32)kvm_rsi_read(vcpu);
> +		params[4] = (u32)kvm_rdi_read(vcpu);
> +		params[5] = (u32)kvm_rbp_read(vcpu);
> +	}
> +#ifdef CONFIG_X86_64
> +	else {
> +		params[0] = (u64)kvm_rdi_read(vcpu);
> +		params[1] = (u64)kvm_rsi_read(vcpu);
> +		params[2] = (u64)kvm_rdx_read(vcpu);
> +		params[3] = (u64)kvm_r10_read(vcpu);
> +		params[4] = (u64)kvm_r8_read(vcpu);
> +		params[5] = (u64)kvm_r9_read(vcpu);
> +	}
> +#endif
> +	trace_kvm_xen_hypercall(input, params[0], params[1], params[2],
> +				params[3], params[4], params[5]);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_XEN;
> +	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
> +	vcpu->run->xen.u.hcall.longmode = longmode;
> +	vcpu->run->xen.u.hcall.cpl = kvm_x86_ops.get_cpl(vcpu);
> +	vcpu->run->xen.u.hcall.input = input;
> +	vcpu->run->xen.u.hcall.params[0] = params[0];
> +	vcpu->run->xen.u.hcall.params[1] = params[1];
> +	vcpu->run->xen.u.hcall.params[2] = params[2];
> +	vcpu->run->xen.u.hcall.params[3] = params[3];
> +	vcpu->run->xen.u.hcall.params[4] = params[4];
> +	vcpu->run->xen.u.hcall.params[5] = params[5];
> +	vcpu->arch.xen.hypercall_rip = kvm_get_linear_rip(vcpu);
> +	vcpu->arch.complete_userspace_io =
> +		kvm_xen_hypercall_complete_userspace;
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> new file mode 100644
> index 000000000000..81e12f716d2e
> --- /dev/null
> +++ b/arch/x86/kvm/xen.h
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright © 2019 Oracle and/or its affiliates. All rights reserved.
> + * Copyright © 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + *
> + * KVM Xen emulation
> + */
> +
> +#ifndef __ARCH_X86_KVM_XEN_H__
> +#define __ARCH_X86_KVM_XEN_H__
> +
> +int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
> +int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
> +
> +static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
> +{
> +	return kvm->arch.xen_hvm_config.flags &
> +		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
> +}
> +
> +#endif /* __ARCH_X86_KVM_XEN_H__ */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..00221fe56994 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -216,6 +216,20 @@ struct kvm_hyperv_exit {
>   	} u;
>   };
>   
> +struct kvm_xen_exit {
> +#define KVM_EXIT_XEN_HCALL          1
> +	__u32 type;
> +	union {
> +		struct {
> +			__u32 longmode;
> +			__u32 cpl;
> +			__u64 input;
> +			__u64 result;
> +			__u64 params[6];
> +		} hcall;
> +	} u;
> +};
> +
>   #define KVM_S390_GET_SKEYS_NONE   1
>   #define KVM_S390_SKEYS_MAX        1048576
>   
> @@ -250,6 +264,7 @@ struct kvm_hyperv_exit {
>   #define KVM_EXIT_ARM_NISV         28
>   #define KVM_EXIT_X86_RDMSR        29
>   #define KVM_EXIT_X86_WRMSR        30
> +#define KVM_EXIT_XEN              31
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -426,6 +441,8 @@ struct kvm_run {
>   			__u32 index; /* kernel -> user */
>   			__u64 data; /* kernel <-> user */
>   		} msr;
> +		/* KVM_EXIT_XEN */
> +		struct kvm_xen_exit xen;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};
> @@ -1126,6 +1143,8 @@ struct kvm_x86_mce {
>   #endif
>   
>   #ifdef KVM_CAP_XEN_HVM
> +#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
> +
>   struct kvm_xen_hvm_config {
>   	__u32 flags;
>   	__u32 msr;
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 3d14ef77755e..d94abec627e6 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -59,6 +59,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>   TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
>   TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
> +TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
>   TEST_GEN_PROGS_x86_64 += demand_paging_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 126c6727a6b0..6e96ae47d28c 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1654,6 +1654,7 @@ static struct exit_reason {
>   	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
>   	{KVM_EXIT_OSI, "OSI"},
>   	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
> +	{KVM_EXIT_XEN, "XEN"},
>   #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
>   	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
>   #endif
> diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
> new file mode 100644
> index 000000000000..3f1dd93626e5
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
> @@ -0,0 +1,123 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_vmcall_test
> + *
> + * Copyright © 2020 Amazon.com, Inc. or its affiliates.
> + *
> + * Userspace hypercall testing
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define VCPU_ID		5
> +
> +#define HCALL_REGION_GPA	0xc0000000ULL
> +#define HCALL_REGION_SLOT	10
> +
> +static struct kvm_vm *vm;
> +
> +#define INPUTVALUE 17
> +#define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
> +#define RETVALUE 0xcafef00dfbfbffffUL
> +
> +#define XEN_HYPERCALL_MSR 0x40000000
> +
> +static void guest_code(void)
> +{
> +	unsigned long rax = INPUTVALUE;
> +	unsigned long rdi = ARGVALUE(1);
> +	unsigned long rsi = ARGVALUE(2);
> +	unsigned long rdx = ARGVALUE(3);
> +	register unsigned long r10 __asm__("r10") = ARGVALUE(4);
> +	register unsigned long r8 __asm__("r8") = ARGVALUE(5);
> +	register unsigned long r9 __asm__("r9") = ARGVALUE(6);
> +
> +	/* First a direct invocation of 'vmcall' */
> +	__asm__ __volatile__("vmcall" :
> +			     "=a"(rax) :
> +			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
> +			     "r"(r10), "r"(r8), "r"(r9));
> +	GUEST_ASSERT(rax == RETVALUE);
> +
> +	/* Now fill in the hypercall page */
> +	__asm__ __volatile__("wrmsr" : : "c" (XEN_HYPERCALL_MSR),
> +			     "a" (HCALL_REGION_GPA & 0xffffffff),
> +			     "d" (HCALL_REGION_GPA >> 32));
> +
> +	/* And invoke the same hypercall that way */
> +	__asm__ __volatile__("call *%1" : "=a"(rax) :
> +			     "r"(HCALL_REGION_GPA + INPUTVALUE * 32),
> +			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
> +			     "r"(r10), "r"(r8), "r"(r9));
> +	GUEST_ASSERT(rax == RETVALUE);
> +
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
> +	      KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) ) {
> +		print_skip("KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL not available");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	struct kvm_xen_hvm_config hvmc = {
> +		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
> +		.msr = XEN_HYPERCALL_MSR,
> +	};
> +	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
> +
> +	/* Map a region for the hypercall page */
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +                                    HCALL_REGION_GPA, HCALL_REGION_SLOT,
> +				    getpagesize(), 0);
> +	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 1, 0);
> +
> +	for (;;) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +
> +		if (run->exit_reason == KVM_EXIT_XEN) {
> +			ASSERT_EQ(run->xen.type, KVM_EXIT_XEN_HCALL);
> +			ASSERT_EQ(run->xen.u.hcall.cpl, 0);
> +			ASSERT_EQ(run->xen.u.hcall.longmode, 1);
> +			ASSERT_EQ(run->xen.u.hcall.input, INPUTVALUE);
> +			ASSERT_EQ(run->xen.u.hcall.params[0], ARGVALUE(1));
> +			ASSERT_EQ(run->xen.u.hcall.params[1], ARGVALUE(2));
> +			ASSERT_EQ(run->xen.u.hcall.params[2], ARGVALUE(3));
> +			ASSERT_EQ(run->xen.u.hcall.params[3], ARGVALUE(4));
> +			ASSERT_EQ(run->xen.u.hcall.params[4], ARGVALUE(5));
> +			ASSERT_EQ(run->xen.u.hcall.params[5], ARGVALUE(6));
> +			run->xen.u.hcall.result = RETVALUE;
> +			continue;
> +		}
> +
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s", (const char *)uc.args[0]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
> +		}
> +	}
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> 
