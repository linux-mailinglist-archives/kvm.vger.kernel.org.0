Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5192D1503B3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 10:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBCJ65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 04:58:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57438 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726884AbgBCJ65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 04:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580723935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FlyQV+TP+LoIpedmBu67TISNB5lNmURUJB2Fbj3tG/w=;
        b=aUgoa9A8x92U2fEYLBd2CUCZPfHlllA+UEfo7FY+GeKVKL585LkxYxoxJ5I6/Ji1/imUaH
        rDNFlHj+HRCT040oVa//pNtBTxsAFChLacrIYusyLje1QZDfFQR35AIsNtzC9hjWmSm2tG
        4LAXf1i9AnrkEo7yPtsle8X9LCS2bgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-E6rZlU8BNUWLg1Ll5MZE1A-1; Mon, 03 Feb 2020 04:58:54 -0500
X-MC-Unique: E6rZlU8BNUWLg1Ll5MZE1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD23DB66;
        Mon,  3 Feb 2020 09:58:53 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A55777792E;
        Mon,  3 Feb 2020 09:58:48 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] selftests: KVM: AMD Nested test infrastructure
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
References: <20200203090851.19938-1-eric.auger@redhat.com>
 <20200203090851.19938-2-eric.auger@redhat.com>
 <878slkovqg.fsf@vitty.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0858c283-6f78-060e-49fe-2ee46f359acc@redhat.com>
Date:   Mon, 3 Feb 2020 10:58:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <878slkovqg.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 2/3/20 10:39 AM, Vitaly Kuznetsov wrote:
> Eric Auger <eric.auger@redhat.com> writes:
> 
>> Add the basic infrastructure needed to test AMD nested SVM.
>> This is largely copied from the KVM unit test infrastructure.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/Makefile          |   2 +-
>>  .../selftests/kvm/include/x86_64/processor.h  |  20 +
>>  .../selftests/kvm/include/x86_64/svm.h        | 355 ++++++++++++++++++
>>  tools/testing/selftests/kvm/lib/x86_64/svm.c  | 211 +++++++++++
>>  4 files changed, 587 insertions(+), 1 deletion(-)
>>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm.h
>>  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>> index 608fa835c764..2e770f554cae 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -8,7 +8,7 @@ KSFT_KHDR_INSTALL := 1
>>  UNAME_M := $(shell uname -m)
>>  
>>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c
>> -LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/ucall.c
>> +LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
>>  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
>>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
>>  
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> index aa6451b3f740..8a52ae66cf5a 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> @@ -56,6 +56,26 @@ enum x86_register {
>>  	R15,
>>  };
>>  
>> +struct regs {
> 
> Nit: I would've called it a bit more specific, like
> 
> 'regs64' (to match 'desc64' below)
> or 'gp_regs' (to indicate that these are only general purpose registers)
OK
> 
>> +	u64 rax;
>> +	u64 rbx;
>> +	u64 rcx;
>> +	u64 rdx;
>> +	u64 cr2;
>> +	u64 rbp;
>> +	u64 rsi;
>> +	u64 rdi;
>> +	u64 r8;
>> +	u64 r9;
>> +	u64 r10;
>> +	u64 r11;
>> +	u64 r12;
>> +	u64 r13;
>> +	u64 r14;
>> +	u64 r15;
>> +	u64 rflags;
>> +};
>> +
>>  struct desc64 {
>>  	uint16_t limit0;
>>  	uint16_t base0;
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
>> new file mode 100644
>> index 000000000000..4a4ebe097556
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
>> @@ -0,0 +1,355 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * tools/testing/selftests/kvm/include/x86_64/svm.h
>> + * Header for nested SVM testing
>> + * Largely copied from KVM unit test svm.h
>> + *
>> + * Copyright (C) 2020, Red Hat, Inc.
>> + */
>> +
>> +#ifndef SELFTEST_KVM_SVM_H
>> +#define SELFTEST_KVM_SVM_H
>> +
>> +#include <stdint.h>
>> +#include "processor.h"
>> +
>> +#define CPUID_SVM_BIT		2
>> +#define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
>> +
>> +enum {
>> +	INTERCEPT_INTR,
>> +	INTERCEPT_NMI,
>> +	INTERCEPT_SMI,
>> +	INTERCEPT_INIT,
>> +	INTERCEPT_VINTR,
>> +	INTERCEPT_SELECTIVE_CR0,
>> +	INTERCEPT_STORE_IDTR,
>> +	INTERCEPT_STORE_GDTR,
>> +	INTERCEPT_STORE_LDTR,
>> +	INTERCEPT_STORE_TR,
>> +	INTERCEPT_LOAD_IDTR,
>> +	INTERCEPT_LOAD_GDTR,
>> +	INTERCEPT_LOAD_LDTR,
>> +	INTERCEPT_LOAD_TR,
>> +	INTERCEPT_RDTSC,
>> +	INTERCEPT_RDPMC,
>> +	INTERCEPT_PUSHF,
>> +	INTERCEPT_POPF,
>> +	INTERCEPT_CPUID,
>> +	INTERCEPT_RSM,
>> +	INTERCEPT_IRET,
>> +	INTERCEPT_INTn,
>> +	INTERCEPT_INVD,
>> +	INTERCEPT_PAUSE,
>> +	INTERCEPT_HLT,
>> +	INTERCEPT_INVLPG,
>> +	INTERCEPT_INVLPGA,
>> +	INTERCEPT_IOIO_PROT,
>> +	INTERCEPT_MSR_PROT,
>> +	INTERCEPT_TASK_SWITCH,
>> +	INTERCEPT_FERR_FREEZE,
>> +	INTERCEPT_SHUTDOWN,
>> +	INTERCEPT_VMRUN,
>> +	INTERCEPT_VMMCALL,
>> +	INTERCEPT_VMLOAD,
>> +	INTERCEPT_VMSAVE,
>> +	INTERCEPT_STGI,
>> +	INTERCEPT_CLGI,
>> +	INTERCEPT_SKINIT,
>> +	INTERCEPT_RDTSCP,
>> +	INTERCEPT_ICEBP,
>> +	INTERCEPT_WBINVD,
>> +	INTERCEPT_MONITOR,
>> +	INTERCEPT_MWAIT,
>> +	INTERCEPT_MWAIT_COND,
>> +};
> 
> The same enum in arch/x86/include/asm/svm.h has more
> (INTERCEPT_XSETBV/INTERCEPT_RDPRU).
OK.
> 
>> +
>> +struct __attribute__ ((__packed__)) vmcb_control_area {
>> +	u16 intercept_cr_read;
>> +	u16 intercept_cr_write;
>> +	u16 intercept_dr_read;
>> +	u16 intercept_dr_write;
>> +	u32 intercept_exceptions;
>> +	u64 intercept;
>> +	u8 reserved_1[42];
>> +	u16 pause_filter_count;
>> +	u64 iopm_base_pa;
>> +	u64 msrpm_base_pa;
>> +	u64 tsc_offset;
>> +	u32 asid;
>> +	u8 tlb_ctl;
>> +	u8 reserved_2[3];
>> +	u32 int_ctl;
>> +	u32 int_vector;
>> +	u32 int_state;
>> +	u8 reserved_3[4];
>> +	u32 exit_code;
>> +	u32 exit_code_hi;
>> +	u64 exit_info_1;
>> +	u64 exit_info_2;
>> +	u32 exit_int_info;
>> +	u32 exit_int_info_err;
>> +	u64 nested_ctl;
>> +	u8 reserved_4[16];
>> +	u32 event_inj;
>> +	u32 event_inj_err;
>> +	u64 nested_cr3;
>> +	u64 lbr_ctl;
>> +	u64 reserved_5;
>> +	u64 next_rip;
>> +	u8 reserved_6[816];
>> +};
> 
> This also doesn't match the definition in arch/x86/include/asm/svm.h
I will align
> 
>> +
>> +#define TLB_CONTROL_DO_NOTHING 0
>> +#define TLB_CONTROL_FLUSH_ALL_ASID 1
>> +
>> +#define V_TPR_MASK 0x0f
>> +
>> +#define V_IRQ_SHIFT 8
>> +#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
>> +
>> +#define V_INTR_PRIO_SHIFT 16
>> +#define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
>> +
>> +#define V_IGN_TPR_SHIFT 20
>> +#define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
>> +
>> +#define V_INTR_MASKING_SHIFT 24
>> +#define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
>> +
>> +#define SVM_INTERRUPT_SHADOW_MASK 1
>> +
>> +#define SVM_IOIO_STR_SHIFT 2
>> +#define SVM_IOIO_REP_SHIFT 3
>> +#define SVM_IOIO_SIZE_SHIFT 4
>> +#define SVM_IOIO_ASIZE_SHIFT 7
>> +
>> +#define SVM_IOIO_TYPE_MASK 1
>> +#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
>> +#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
>> +#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
>> +#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
>> +
>> +#define SVM_VM_CR_VALID_MASK	0x001fULL
>> +#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
>> +#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
>> +
>> +struct __attribute__ ((__packed__)) vmcb_seg {
>> +	u16 selector;
>> +	u16 attrib;
>> +	u32 limit;
>> +	u64 base;
>> +};
>> +
>> +struct __attribute__ ((__packed__)) vmcb_save_area {
>> +	struct vmcb_seg es;
>> +	struct vmcb_seg cs;
>> +	struct vmcb_seg ss;
>> +	struct vmcb_seg ds;
>> +	struct vmcb_seg fs;
>> +	struct vmcb_seg gs;
>> +	struct vmcb_seg gdtr;
>> +	struct vmcb_seg ldtr;
>> +	struct vmcb_seg idtr;
>> +	struct vmcb_seg tr;
>> +	u8 reserved_1[43];
>> +	u8 cpl;
>> +	u8 reserved_2[4];
>> +	u64 efer;
>> +	u8 reserved_3[112];
>> +	u64 cr4;
>> +	u64 cr3;
>> +	u64 cr0;
>> +	u64 dr7;
>> +	u64 dr6;
>> +	u64 rflags;
>> +	u64 rip;
>> +	u8 reserved_4[88];
>> +	u64 rsp;
>> +	u8 reserved_5[24];
>> +	u64 rax;
>> +	u64 star;
>> +	u64 lstar;
>> +	u64 cstar;
>> +	u64 sfmask;
>> +	u64 kernel_gs_base;
>> +	u64 sysenter_cs;
>> +	u64 sysenter_esp;
>> +	u64 sysenter_eip;
>> +	u64 cr2;
>> +	u8 reserved_6[32];
>> +	u64 g_pat;
>> +	u64 dbgctl;
>> +	u64 br_from;
>> +	u64 br_to;
>> +	u64 last_excp_from;
>> +	u64 last_excp_to;
>> +};
>> +
>> +struct __attribute__ ((__packed__)) vmcb {
>> +	struct vmcb_control_area control;
>> +	struct vmcb_save_area save;
>> +};
>> +
>> +#define SVM_CPUID_FEATURE_SHIFT 2
>> +#define SVM_CPUID_FUNC 0x8000000a
>> +
>> +#define SVM_VM_CR_SVM_DISABLE 4
>> +
>> +#define SVM_SELECTOR_S_SHIFT 4
>> +#define SVM_SELECTOR_DPL_SHIFT 5
>> +#define SVM_SELECTOR_P_SHIFT 7
>> +#define SVM_SELECTOR_AVL_SHIFT 8
>> +#define SVM_SELECTOR_L_SHIFT 9
>> +#define SVM_SELECTOR_DB_SHIFT 10
>> +#define SVM_SELECTOR_G_SHIFT 11
>> +
>> +#define SVM_SELECTOR_TYPE_MASK (0xf)
>> +#define SVM_SELECTOR_S_MASK (1 << SVM_SELECTOR_S_SHIFT)
>> +#define SVM_SELECTOR_DPL_MASK (3 << SVM_SELECTOR_DPL_SHIFT)
>> +#define SVM_SELECTOR_P_MASK (1 << SVM_SELECTOR_P_SHIFT)
>> +#define SVM_SELECTOR_AVL_MASK (1 << SVM_SELECTOR_AVL_SHIFT)
>> +#define SVM_SELECTOR_L_MASK (1 << SVM_SELECTOR_L_SHIFT)
>> +#define SVM_SELECTOR_DB_MASK (1 << SVM_SELECTOR_DB_SHIFT)
>> +#define SVM_SELECTOR_G_MASK (1 << SVM_SELECTOR_G_SHIFT)
>> +
>> +#define SVM_SELECTOR_WRITE_MASK (1 << 1)
>> +#define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
>> +#define SVM_SELECTOR_CODE_MASK (1 << 3)
>> +
>> +#define INTERCEPT_CR0_MASK 1
>> +#define INTERCEPT_CR3_MASK (1 << 3)
>> +#define INTERCEPT_CR4_MASK (1 << 4)
>> +#define INTERCEPT_CR8_MASK (1 << 8)
>> +
>> +#define INTERCEPT_DR0_MASK 1
>> +#define INTERCEPT_DR1_MASK (1 << 1)
>> +#define INTERCEPT_DR2_MASK (1 << 2)
>> +#define INTERCEPT_DR3_MASK (1 << 3)
>> +#define INTERCEPT_DR4_MASK (1 << 4)
>> +#define INTERCEPT_DR5_MASK (1 << 5)
>> +#define INTERCEPT_DR6_MASK (1 << 6)
>> +#define INTERCEPT_DR7_MASK (1 << 7)
>> +
>> +#define SVM_EVTINJ_VEC_MASK 0xff
>> +
>> +#define SVM_EVTINJ_TYPE_SHIFT 8
>> +#define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
>> +
>> +#define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
>> +
>> +#define SVM_EVTINJ_VALID (1 << 31)
>> +#define SVM_EVTINJ_VALID_ERR (1 << 11)
>> +
>> +#define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
>> +#define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
>> +
>> +#define	SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
>> +#define	SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
>> +#define	SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_EXEPT
>> +#define	SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_SOFT
>> +
>> +#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
>> +#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
>> +
>> +#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
>> +#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
>> +#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
>> +
>> +#define	SVM_EXIT_READ_CR0	0x000
>> +#define	SVM_EXIT_READ_CR3	0x003
>> +#define	SVM_EXIT_READ_CR4	0x004
>> +#define	SVM_EXIT_READ_CR8	0x008
>> +#define	SVM_EXIT_WRITE_CR0	0x010
>> +#define	SVM_EXIT_WRITE_CR3	0x013
>> +#define	SVM_EXIT_WRITE_CR4	0x014
>> +#define	SVM_EXIT_WRITE_CR8	0x018
>> +#define	SVM_EXIT_READ_DR0	0x020
>> +#define	SVM_EXIT_READ_DR1	0x021
>> +#define	SVM_EXIT_READ_DR2	0x022
>> +#define	SVM_EXIT_READ_DR3	0x023
>> +#define	SVM_EXIT_READ_DR4	0x024
>> +#define	SVM_EXIT_READ_DR5	0x025
>> +#define	SVM_EXIT_READ_DR6	0x026
>> +#define	SVM_EXIT_READ_DR7	0x027
>> +#define	SVM_EXIT_WRITE_DR0	0x030
>> +#define	SVM_EXIT_WRITE_DR1	0x031
>> +#define	SVM_EXIT_WRITE_DR2	0x032
>> +#define	SVM_EXIT_WRITE_DR3	0x033
>> +#define	SVM_EXIT_WRITE_DR4	0x034
>> +#define	SVM_EXIT_WRITE_DR5	0x035
>> +#define	SVM_EXIT_WRITE_DR6	0x036
>> +#define	SVM_EXIT_WRITE_DR7	0x037
>> +#define SVM_EXIT_EXCP_BASE      0x040
>> +#define SVM_EXIT_INTR		0x060
>> +#define SVM_EXIT_NMI		0x061
>> +#define SVM_EXIT_SMI		0x062
>> +#define SVM_EXIT_INIT		0x063
>> +#define SVM_EXIT_VINTR		0x064
>> +#define SVM_EXIT_CR0_SEL_WRITE	0x065
>> +#define SVM_EXIT_IDTR_READ	0x066
>> +#define SVM_EXIT_GDTR_READ	0x067
>> +#define SVM_EXIT_LDTR_READ	0x068
>> +#define SVM_EXIT_TR_READ	0x069
>> +#define SVM_EXIT_IDTR_WRITE	0x06a
>> +#define SVM_EXIT_GDTR_WRITE	0x06b
>> +#define SVM_EXIT_LDTR_WRITE	0x06c
>> +#define SVM_EXIT_TR_WRITE	0x06d
>> +#define SVM_EXIT_RDTSC		0x06e
>> +#define SVM_EXIT_RDPMC		0x06f
>> +#define SVM_EXIT_PUSHF		0x070
>> +#define SVM_EXIT_POPF		0x071
>> +#define SVM_EXIT_CPUID		0x072
>> +#define SVM_EXIT_RSM		0x073
>> +#define SVM_EXIT_IRET		0x074
>> +#define SVM_EXIT_SWINT		0x075
>> +#define SVM_EXIT_INVD		0x076
>> +#define SVM_EXIT_PAUSE		0x077
>> +#define SVM_EXIT_HLT		0x078
>> +#define SVM_EXIT_INVLPG		0x079
>> +#define SVM_EXIT_INVLPGA	0x07a
>> +#define SVM_EXIT_IOIO		0x07b
>> +#define SVM_EXIT_MSR		0x07c
>> +#define SVM_EXIT_TASK_SWITCH	0x07d
>> +#define SVM_EXIT_FERR_FREEZE	0x07e
>> +#define SVM_EXIT_SHUTDOWN	0x07f
>> +#define SVM_EXIT_VMRUN		0x080
>> +#define SVM_EXIT_VMMCALL	0x081
>> +#define SVM_EXIT_VMLOAD		0x082
>> +#define SVM_EXIT_VMSAVE		0x083
>> +#define SVM_EXIT_STGI		0x084
>> +#define SVM_EXIT_CLGI		0x085
>> +#define SVM_EXIT_SKINIT		0x086
>> +#define SVM_EXIT_RDTSCP		0x087
>> +#define SVM_EXIT_ICEBP		0x088
>> +#define SVM_EXIT_WBINVD		0x089
>> +#define SVM_EXIT_MONITOR	0x08a
>> +#define SVM_EXIT_MWAIT		0x08b
>> +#define SVM_EXIT_MWAIT_COND	0x08c
>> +#define SVM_EXIT_NPF		0x400
>> +
>> +#define SVM_EXIT_ERR		-1
>> +
>> +#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>> +
>> +struct svm_test_data {
>> +	void *vmcb_hva;
>> +	uint64_t vmcb_gpa;
>> +	struct vmcb *vmcb;
>> +
>> +	void *save_area_hva;
>> +	uint64_t save_area_gpa;
>> +	struct vmcb_save_area *save_area;
>> +};
>> +
>> +extern struct regs regs;
>> +
>> +struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
>> +void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
>> +void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
>> +void nested_svm_check_supported(void);
>> +
>> +#endif /* SELFTEST_KVM_SVM_H */
> 
> To keep this in sync with arch/x86/include/asm/svm.h I'd suggest we
> split this header into two:
> 1) The exact copy on arch/x86/include/asm/svm.h
> 2) Our testing add-ons.
> 
> It will make updating definitions much easier in the future.
That's definitively a good idea
> 
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
>> new file mode 100644
>> index 000000000000..b025c23e502a
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
>> @@ -0,0 +1,211 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * tools/testing/selftests/kvm/lib/x86_64/svm.c
>> + * Helpers used for nested SVM testing
>> + * Largely inspired from KVM unit test svm.c
>> + *
>> + * Copyright (C) 2020, Red Hat, Inc.
>> + */
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +#include "../kvm_util_internal.h"
>> +#include "processor.h"
>> +#include "svm.h"
>> +
>> +struct regs regs;
>> +
>> +/* Allocate memory regions for nested SVM tests.
>> + *
>> + * Input Args:
>> + *   vm - The VM to allocate guest-virtual addresses in.
>> + *
>> + * Output Args:
>> + *   p_svm_gva - The guest virtual address for the struct svm_test_data.
>> + *
>> + * Return:
>> + *   Pointer to structure with the addresses of the SVM areas.
>> + */
>> +struct svm_test_data *
>> +vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
>> +{
>> +	vm_vaddr_t svm_gva = vm_vaddr_alloc(vm, getpagesize(),
>> +					    0x10000, 0, 0);
>> +	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
>> +
>> +	svm->vmcb = (void *)vm_vaddr_alloc(vm, getpagesize(),
>> +					   0x10000, 0, 0);
>> +	svm->vmcb_hva = addr_gva2hva(vm, (uintptr_t)svm->vmcb);
>> +	svm->vmcb_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
>> +
>> +	svm->save_area = (void *)vm_vaddr_alloc(vm, getpagesize(),
>> +						0x10000, 0, 0);
>> +	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
>> +	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
>> +
>> +	*p_svm_gva = svm_gva;
>> +	return svm;
>> +}
>> +
>> +struct descriptor_table_ptr {
>> +	u16 limit;
>> +	ulong base;
>> +} __attribute__((packed));
>> +
>> +static inline void sgdt(struct descriptor_table_ptr *ptr)
>> +{
>> +	asm volatile ("sgdt %0" : "=m"(*ptr));
>> +}
>> +
>> +static inline void sidt(struct descriptor_table_ptr *ptr)
>> +{
>> +	asm volatile ("sidt %0" : "=m"(*ptr));
>> +}
>> +
> 
> This is not SVM specific, we seem to already have
> get_gdt_base()/get_idt_base(), can these be re-used?
most probably.
> 
>> +static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
>> +			 u64 base, u32 limit, u32 attr)
>> +{
>> +	seg->selector = selector;
>> +	seg->attrib = attr;
>> +	seg->limit = limit;
>> +	seg->base = base;
>> +}
>> +
>> +static inline u16 read_cs(void)
>> +{
>> +	u16 val;
>> +
>> +	asm volatile ("mov %%cs, %0" : "=mr"(val));
>> +	return val;
>> +}
>> +
>> +static inline u16 read_ds(void)
>> +{
>> +	u16 val;
>> +
>> +	asm volatile ("mov %%ds, %0" : "=mr"(val));
>> +	return val;
>> +}
>> +
>> +static inline u16 read_es(void)
>> +{
>> +	u16 val;
>> +
>> +	asm volatile ("mov %%es, %0" : "=mr"(val));
>> +	return val;
>> +}
>> +
>> +static inline u16 read_ss(void)
>> +{
>> +	unsigned int val;
>> +
>> +	asm volatile ("mov %%ss, %0" : "=mr"(val));
>> +	return val;
>> +}
> 
> We seem to have all these in include/x86_64/processor.h
hum yes should do the job.

> 
>> +
>> +void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
>> +{
>> +	struct vmcb *vmcb = svm->vmcb;
>> +	uint64_t vmcb_gpa = svm->vmcb_gpa;
>> +	struct vmcb_save_area *save = &vmcb->save;
>> +	struct vmcb_control_area *ctrl = &vmcb->control;
>> +	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
>> +	      | SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
>> +	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
>> +		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
>> +	struct descriptor_table_ptr desc_table_ptr;
>> +	uint64_t efer;
>> +
>> +	efer = rdmsr(MSR_EFER);
>> +	wrmsr(MSR_EFER, efer | EFER_SVME);
>> +	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
>> +
>> +	memset(vmcb, 0, sizeof(*vmcb));
>> +	asm volatile ("vmsave %0" : : "a" (vmcb_gpa) : "memory");
>> +	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
>> +	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
>> +	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
>> +	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
>> +	sgdt(&desc_table_ptr);
>> +	vmcb_set_seg(&save->gdtr, 0,
>> +		     desc_table_ptr.base, desc_table_ptr.limit, 0);
>> +	sidt(&desc_table_ptr);
>> +	vmcb_set_seg(&save->idtr, 0,
>> +		     desc_table_ptr.base, desc_table_ptr.limit, 0);
>> +
>> +	ctrl->asid = 1;
>> +	save->cpl = 0;
>> +	save->efer = rdmsr(MSR_EFER);
>> +	asm volatile ("mov %%cr4, %0" : "=r"(save->cr4) : : "memory");
>> +	asm volatile ("mov %%cr3, %0" : "=r"(save->cr3) : : "memory");
>> +	asm volatile ("mov %%cr0, %0" : "=r"(save->cr0) : : "memory");
>> +	asm volatile ("mov %%dr7, %0" : "=r"(save->dr7));
>> +	asm volatile ("mov %%dr6, %0" : "=r"(save->dr6));
> 
> Out of pure curiosity, why the clobbering is diferent for DRs?
My mistake, it should be the same
> 
>> +	asm volatile ("mov %%cr2, %0" : "=r"(save->cr2) : : "memory");
> 
> This probably can be written as a single 'asm volatile' block by
> utilizing something like offsetof() (e.g. how we do in svm_vcpu_run())
> but feel free to leave it for future generations :-)
> 
>> +	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
>> +	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>> +	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
>> +				(1ULL << INTERCEPT_VMMCALL);
>> +
>> +	vmcb->save.rip = (ulong)guest_rip;
>> +	vmcb->save.rsp = (ulong)guest_rsp;
>> +	regs.rdi = (ulong)svm;
> 
> We don't really support 32bit, do we? I'd used 'u64' then to be
> explicit.
OK
> 
>> +}
>> +
>> +#define SAVE_GPR_C                              \
>> +	"xchg %%rbx, regs+0x8\n\t"              \
>> +	"xchg %%rcx, regs+0x10\n\t"             \
>> +	"xchg %%rdx, regs+0x18\n\t"             \
>> +	"xchg %%rbp, regs+0x28\n\t"             \
>> +	"xchg %%rsi, regs+0x30\n\t"             \
>> +	"xchg %%rdi, regs+0x38\n\t"             \
>> +	"xchg %%r8, regs+0x40\n\t"              \
>> +	"xchg %%r9, regs+0x48\n\t"              \
>> +	"xchg %%r10, regs+0x50\n\t"             \
>> +	"xchg %%r11, regs+0x58\n\t"             \
>> +	"xchg %%r12, regs+0x60\n\t"             \
>> +	"xchg %%r13, regs+0x68\n\t"             \
>> +	"xchg %%r14, regs+0x70\n\t"             \
>> +	"xchg %%r15, regs+0x78\n\t"
>> +
>> +#define LOAD_GPR_C      SAVE_GPR_C
>> +
>> +/*
>> + * selftests do not use interrupts so we dropped clgi/sti/cli/stgi
>> + * for now
>> + */
>> +void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
>> +{
>> +	asm volatile (
>> +		"vmload\n\t"
>> +		"vmload %[vmcb_gpa]\n\t"
>> +		"mov regs+0x80, %%r15\n\t"  // rflags
>> +		"mov %%r15, 0x170(%[vmcb])\n\t"
>> +		"mov regs, %%r15\n\t"       // rax
>> +		"mov %%r15, 0x1f8(%[vmcb])\n\t"
>> +		LOAD_GPR_C
>> +		"vmrun %[vmcb_gpa]\n\t"
>> +		SAVE_GPR_C
>> +		"mov 0x170(%[vmcb]), %%r15\n\t"  // rflags
>> +		"mov %%r15, regs+0x80\n\t"
>> +		"mov 0x1f8(%[vmcb]), %%r15\n\t"  // rax
>> +		"mov %%r15, regs\n\t"
>> +		"vmsave %[vmcb_gpa]\n\t"
>> +		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
>> +		: "rbx", "rcx", "rdx", "rsi",
>> +		  "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
>> +		  "memory");
>> +
>> +}
>> +
>> +void nested_svm_check_supported(void)
>> +{
>> +	struct kvm_cpuid_entry2 *entry =
>> +		kvm_get_supported_cpuid_entry(0x80000001);
>> +
>> +	if (!(entry->ecx & CPUID_SVM)) {
>> +		fprintf(stderr, "nested SVM not enabled, skipping test\n");
>> +		exit(KSFT_SKIP);
>> +	}
>> +}
>> +
> 
Thanks

Eric

