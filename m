Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21CF3075EE
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 13:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhA1MXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:23:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231203AbhA1MWs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 07:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611836480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsHa8xktyls4ixDMchtdqo5Ye3PGJ1Vq0eVehr54S/M=;
        b=XMXxwBAyEPA3ECM5KUIc7/Wtm+6BjKGbYIbpZvf5kc9ytg3f0JdF8OdrLl379q08uTei1y
        MErM/YHiCWSARHONf0YZ8KZ5DqRxRVCTgUSVUrqBnVbmjrnEmbdbuGK9jKT9+5rb7O6/YZ
        AtaFEfEYEiC9mwKDt0tDHvsrzEP/cEc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-swbvAelhMPCWXN7o4XThyw-1; Thu, 28 Jan 2021 07:21:18 -0500
X-MC-Unique: swbvAelhMPCWXN7o4XThyw-1
Received: by mail-ed1-f72.google.com with SMTP id a26so3116418edx.8
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 04:21:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OsHa8xktyls4ixDMchtdqo5Ye3PGJ1Vq0eVehr54S/M=;
        b=IYGRnpshTU23lTtYUUnbssYhJFvqL6QK0GkJLug5mU4KHVulwyhHH70u6ybs6pM8+R
         n4lB1xbCdFLZ86IQmRp3uWiACbkcL3dtZvGeJVovCyMOybVwXBtb+JTUj9Wvj6j36w26
         7SrtPhQ4Uw5Gxa0TVtiE6LvuzZ/haK7sfKNMLnCGOWYEbKRYYEPXhgVuHFGFCZpOO1OM
         1DKzAkLv5+1DO05wM01b5n9i3LE/iLA717X2CtTmbkiEEwy0PbCQEU1GohZdGqjgo5G9
         ErTZjPKShrssrUW4yT329d+lagYRHpP7Wq3lFpHcjg2yz0A/2rSCVux1HyT7agLUoJB1
         ns2g==
X-Gm-Message-State: AOAM531BSCgMoMwNFdpejzAdPQrMolcEtdrzqtku/fhrEKmoNYzO4Lcf
        EucTv46tgf5qf0jk1JbyjaogD6w7icCKUO/72sYeXKN85L1ES3RgdsoeanowP2xYhFLZTm7ibJz
        XSUW/4VTmbETo
X-Received: by 2002:aa7:c485:: with SMTP id m5mr13575885edq.320.1611836477213;
        Thu, 28 Jan 2021 04:21:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEREcynXCq5wgdpNzalslPivz1+eG+07L/wPHHjhn4WHqLpWfj9+0oC08GpTb76DcO0SLFAg==
X-Received: by 2002:aa7:c485:: with SMTP id m5mr13575868edq.320.1611836476991;
        Thu, 28 Jan 2021 04:21:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cw21sm2871847edb.85.2021.01.28.04.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 04:21:16 -0800 (PST)
Subject: Re: [PATCH v5 02/16] KVM: x86/xen: intercept xen hypercalls if
 enabled
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-3-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f710184-b32d-3882-e9cd-6de5f1175f6c@redhat.com>
Date:   Thu, 28 Jan 2021 13:21:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111195725.4601-3-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/21 20:57, David Woodhouse wrote:

> +	} else {
> +		int lm = is_long_mode(vcpu);
> +		u8 *blob_addr = lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
> +				   : (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
> +		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
> +				  : kvm->arch.xen_hvm_config.blob_size_32;

I know this is preexisting, but please just make those pointers "u8 
__user *" to calm down the static checker.

Paolo

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
> index 374c67875cdb..9eee81bcd0e0 100644
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
> @@ -252,6 +266,7 @@ struct kvm_hyperv_exit {
>   #define KVM_EXIT_X86_WRMSR        30
>   #define KVM_EXIT_DIRTY_RING_FULL  31
>   #define KVM_EXIT_AP_RESET_HOLD    32
> +#define KVM_EXIT_XEN              33
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -428,6 +443,8 @@ struct kvm_run {
>   			__u32 index; /* kernel -> user */
>   			__u64 data; /* kernel <-> user */
>   		} msr;
> +		/* KVM_EXIT_XEN */
> +		struct kvm_xen_exit xen;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};
> @@ -1131,6 +1148,9 @@ struct kvm_x86_mce {
>   #endif
>   
>   #ifdef KVM_CAP_XEN_HVM
> +#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
> +#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
> +
>   struct kvm_xen_hvm_config {
>   	__u32 flags;
>   	__u32 msr;
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index fe41c6a0fa67..44a4128b4061 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -59,6 +59,8 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>   TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>   TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
>   TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
> +TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
>   TEST_GEN_PROGS_x86_64 += demand_paging_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fa5a90e6c6f0..d787cb802b4a 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1801,6 +1801,7 @@ static struct exit_reason {
>   	{KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
>   	{KVM_EXIT_X86_RDMSR, "RDMSR"},
>   	{KVM_EXIT_X86_WRMSR, "WRMSR"},
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

