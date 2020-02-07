Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E538155919
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 15:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgBGOQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 09:16:36 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54004 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726874AbgBGOQf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 09:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581084993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qIVMe3b3ozUkQ5vxeIfE0BOQHIA2otO6CK263oCYvNA=;
        b=PcVNKrd3iit1dw1+D7hA7/e089ZAue7D+Fc+3Si+GzsraBz2gyPEKqacC6uWrpb9BHGDt8
        zhze1a0vV2QJ8Z9WaoalhiSnublI+SGacLyQApWqYIy0BQh5oQ5JFJkUonA6C+jSs24/6X
        j5qizmdpLJWay2nsM+JeK73ZdBRXu0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-nTtZKGtJOniUqev8cn445w-1; Fri, 07 Feb 2020 09:16:30 -0500
X-MC-Unique: nTtZKGtJOniUqev8cn445w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D6DE8010E7;
        Fri,  7 Feb 2020 14:16:29 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0633A5DA7D;
        Fri,  7 Feb 2020 14:16:24 +0000 (UTC)
Subject: Re: [PATCH v4 2/3] selftests: KVM: AMD Nested test infrastructure
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-3-eric.auger@redhat.com>
 <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a6abd84d-eded-59d0-d645-b1431f081c77@redhat.com>
Date:   Fri, 7 Feb 2020 15:16:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Krish,

On 2/6/20 11:57 PM, Krish Sadhukhan wrote:
>=20
>=20
> On 02/06/2020 02:47 AM, Eric Auger wrote:
>> Add the basic infrastructure needed to test AMD nested SVM.
>> This is largely copied from the KVM unit test infrastructure.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v3 -> v4:
>> - just keep the 16 GPRs in gpr64_regs struct
>> - vm* instructions do not take any param
>> - add comments
>>
>> v2 -> v3:
>> - s/regs/gp_regs64
>> - Split the header into 2 parts: svm.h is a copy of
>> =C2=A0=C2=A0 arch/x86/include/asm/svm.h whereas svm_util.h contains
>> =C2=A0=C2=A0 testing add-ons
>> - use get_gdt/dt() and remove sgdt/sidt
>> - use get_es/ss/ds/cs
>> - fix clobber for dr6 & dr7
>> - use u64 instead of ulong
>> ---
>> =C2=A0 tools/testing/selftests/kvm/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
>> =C2=A0 .../selftests/kvm/include/x86_64/processor.h=C2=A0 |=C2=A0 20 +=
+
>> =C2=A0 .../selftests/kvm/include/x86_64/svm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 297 ++++++++++++++++++
>> =C2=A0 .../selftests/kvm/include/x86_64/svm_util.h=C2=A0=C2=A0 |=C2=A0=
 38 +++
>> =C2=A0 tools/testing/selftests/kvm/lib/x86_64/svm.c=C2=A0 | 161 ++++++=
++++
>> =C2=A0 5 files changed, 517 insertions(+), 1 deletion(-)
>> =C2=A0 create mode 100644 tools/testing/selftests/kvm/include/x86_64/s=
vm.h
>> =C2=A0 create mode 100644
>> tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> =C2=A0 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile
>> b/tools/testing/selftests/kvm/Makefile
>> index 608fa835c764..2e770f554cae 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -8,7 +8,7 @@ KSFT_KHDR_INSTALL :=3D 1
>> =C2=A0 UNAME_M :=3D $(shell uname -m)
>> =C2=A0 =C2=A0 LIBKVM =3D lib/assert.c lib/elf.c lib/io.c lib/kvm_util.=
c
>> lib/sparsebit.c
>> -LIBKVM_x86_64 =3D lib/x86_64/processor.c lib/x86_64/vmx.c
>> lib/x86_64/ucall.c
>> +LIBKVM_x86_64 =3D lib/x86_64/processor.c lib/x86_64/vmx.c
>> lib/x86_64/svm.c lib/x86_64/ucall.c
>> =C2=A0 LIBKVM_aarch64 =3D lib/aarch64/processor.c lib/aarch64/ucall.c
>> =C2=A0 LIBKVM_s390x =3D lib/s390x/processor.c lib/s390x/ucall.c
>> =C2=A0 diff --git a/tools/testing/selftests/kvm/include/x86_64/process=
or.h
>> b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> index 6f7fffaea2e8..12475047869f 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> @@ -56,6 +56,26 @@ enum x86_register {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 R15,
>> =C2=A0 };
>> =C2=A0 +/* General Registers in 64-Bit Mode */
>> +struct gpr64_regs {
>> +=C2=A0=C2=A0=C2=A0 u64 rax;
>> +=C2=A0=C2=A0=C2=A0 u64 rcx;
>> +=C2=A0=C2=A0=C2=A0 u64 rdx;
>> +=C2=A0=C2=A0=C2=A0 u64 rbx;
>> +=C2=A0=C2=A0=C2=A0 u64 rsp;
>> +=C2=A0=C2=A0=C2=A0 u64 rbp;
>> +=C2=A0=C2=A0=C2=A0 u64 rsi;
>> +=C2=A0=C2=A0=C2=A0 u64 rdi;
>> +=C2=A0=C2=A0=C2=A0 u64 r8;
>> +=C2=A0=C2=A0=C2=A0 u64 r9;
>> +=C2=A0=C2=A0=C2=A0 u64 r10;
>> +=C2=A0=C2=A0=C2=A0 u64 r11;
>> +=C2=A0=C2=A0=C2=A0 u64 r12;
>> +=C2=A0=C2=A0=C2=A0 u64 r13;
>> +=C2=A0=C2=A0=C2=A0 u64 r14;
>> +=C2=A0=C2=A0=C2=A0 u64 r15;
>> +};
>> +
>> =C2=A0 struct desc64 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t limit0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t base0;
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h
>> b/tools/testing/selftests/kvm/include/x86_64/svm.h
>> new file mode 100644
>> index 000000000000..f4ea2355dbc2
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
>> @@ -0,0 +1,297 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * tools/testing/selftests/kvm/include/x86_64/svm.h
>> + * This is a copy of arch/x86/include/asm/svm.h
>> + *
>> + */
>> +
>> +#ifndef SELFTEST_KVM_SVM_H
>> +#define SELFTEST_KVM_SVM_H
>> +
>> +enum {
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_INTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_NMI,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_SMI,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_INIT,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_VINTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_SELECTIVE_CR0,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_STORE_IDTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_STORE_GDTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_STORE_LDTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_STORE_TR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_LOAD_IDTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_LOAD_GDTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_LOAD_LDTR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_LOAD_TR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_RDTSC,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_RDPMC,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_PUSHF,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_POPF,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_CPUID,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_RSM,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_IRET,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_INTn,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_INVD,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_PAUSE,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_HLT,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_INVLPG,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_INVLPGA,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_IOIO_PROT,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_MSR_PROT,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_TASK_SWITCH,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_FERR_FREEZE,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_SHUTDOWN,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_VMRUN,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_VMMCALL,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_VMLOAD,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_VMSAVE,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_STGI,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_CLGI,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_SKINIT,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_RDTSCP,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_ICEBP,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_WBINVD,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_MONITOR,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_MWAIT,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_MWAIT_COND,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_XSETBV,
>> +=C2=A0=C2=A0=C2=A0 INTERCEPT_RDPRU,
>> +};
>> +
>> +
>> +struct __attribute__ ((__packed__)) vmcb_control_area {
>> +=C2=A0=C2=A0=C2=A0 u32 intercept_cr;
>> +=C2=A0=C2=A0=C2=A0 u32 intercept_dr;
>> +=C2=A0=C2=A0=C2=A0 u32 intercept_exceptions;
>> +=C2=A0=C2=A0=C2=A0 u64 intercept;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_1[40];
>> +=C2=A0=C2=A0=C2=A0 u16 pause_filter_thresh;
>> +=C2=A0=C2=A0=C2=A0 u16 pause_filter_count;
>> +=C2=A0=C2=A0=C2=A0 u64 iopm_base_pa;
>> +=C2=A0=C2=A0=C2=A0 u64 msrpm_base_pa;
>> +=C2=A0=C2=A0=C2=A0 u64 tsc_offset;
>> +=C2=A0=C2=A0=C2=A0 u32 asid;
>> +=C2=A0=C2=A0=C2=A0 u8 tlb_ctl;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_2[3];
>> +=C2=A0=C2=A0=C2=A0 u32 int_ctl;
>> +=C2=A0=C2=A0=C2=A0 u32 int_vector;
>> +=C2=A0=C2=A0=C2=A0 u32 int_state;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_3[4];
>> +=C2=A0=C2=A0=C2=A0 u32 exit_code;
>> +=C2=A0=C2=A0=C2=A0 u32 exit_code_hi;
>> +=C2=A0=C2=A0=C2=A0 u64 exit_info_1;
>> +=C2=A0=C2=A0=C2=A0 u64 exit_info_2;
>> +=C2=A0=C2=A0=C2=A0 u32 exit_int_info;
>> +=C2=A0=C2=A0=C2=A0 u32 exit_int_info_err;
>> +=C2=A0=C2=A0=C2=A0 u64 nested_ctl;
>> +=C2=A0=C2=A0=C2=A0 u64 avic_vapic_bar;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_4[8];
>> +=C2=A0=C2=A0=C2=A0 u32 event_inj;
>> +=C2=A0=C2=A0=C2=A0 u32 event_inj_err;
>> +=C2=A0=C2=A0=C2=A0 u64 nested_cr3;
>> +=C2=A0=C2=A0=C2=A0 u64 virt_ext;
>> +=C2=A0=C2=A0=C2=A0 u32 clean;
>> +=C2=A0=C2=A0=C2=A0 u32 reserved_5;
>> +=C2=A0=C2=A0=C2=A0 u64 next_rip;
>> +=C2=A0=C2=A0=C2=A0 u8 insn_len;
>> +=C2=A0=C2=A0=C2=A0 u8 insn_bytes[15];
>> +=C2=A0=C2=A0=C2=A0 u64 avic_backing_page;=C2=A0=C2=A0=C2=A0 /* Offset=
 0xe0 */
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_6[8];=C2=A0=C2=A0=C2=A0 /* Offset 0xe8=
 */
>> +=C2=A0=C2=A0=C2=A0 u64 avic_logical_id;=C2=A0=C2=A0=C2=A0 /* Offset 0=
xf0 */
>> +=C2=A0=C2=A0=C2=A0 u64 avic_physical_id;=C2=A0=C2=A0=C2=A0 /* Offset =
0xf8 */
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_7[768];
>> +};
>> +
>> +
>> +#define TLB_CONTROL_DO_NOTHING 0
>> +#define TLB_CONTROL_FLUSH_ALL_ASID 1
>> +#define TLB_CONTROL_FLUSH_ASID 3
>> +#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
>> +
>> +#define V_TPR_MASK 0x0f
>> +
>> +#define V_IRQ_SHIFT 8
>> +#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
>> +
>> +#define V_GIF_SHIFT 9
>> +#define V_GIF_MASK (1 << V_GIF_SHIFT)
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
>> +#define V_GIF_ENABLE_SHIFT 25
>> +#define V_GIF_ENABLE_MASK (1 << V_GIF_ENABLE_SHIFT)
>> +
>> +#define AVIC_ENABLE_SHIFT 31
>> +#define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
>> +
>> +#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>> +#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
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
>> +#define SVM_VM_CR_VALID_MASK=C2=A0=C2=A0=C2=A0 0x001fULL
>> +#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
>> +#define SVM_VM_CR_SVM_DIS_MASK=C2=A0 0x0010ULL
>> +
>> +#define SVM_NESTED_CTL_NP_ENABLE=C2=A0=C2=A0=C2=A0 BIT(0)
>> +#define SVM_NESTED_CTL_SEV_ENABLE=C2=A0=C2=A0=C2=A0 BIT(1)
>> +
>> +struct __attribute__ ((__packed__)) vmcb_seg {
>> +=C2=A0=C2=A0=C2=A0 u16 selector;
>> +=C2=A0=C2=A0=C2=A0 u16 attrib;
>> +=C2=A0=C2=A0=C2=A0 u32 limit;
>> +=C2=A0=C2=A0=C2=A0 u64 base;
>> +};
>> +
>> +struct __attribute__ ((__packed__)) vmcb_save_area {
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg es;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg cs;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg ss;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg ds;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg fs;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg gs;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg gdtr;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg ldtr;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg idtr;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_seg tr;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_1[43];
>> +=C2=A0=C2=A0=C2=A0 u8 cpl;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_2[4];
>> +=C2=A0=C2=A0=C2=A0 u64 efer;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_3[112];
>> +=C2=A0=C2=A0=C2=A0 u64 cr4;
>> +=C2=A0=C2=A0=C2=A0 u64 cr3;
>> +=C2=A0=C2=A0=C2=A0 u64 cr0;
>> +=C2=A0=C2=A0=C2=A0 u64 dr7;
>> +=C2=A0=C2=A0=C2=A0 u64 dr6;
>> +=C2=A0=C2=A0=C2=A0 u64 rflags;
>> +=C2=A0=C2=A0=C2=A0 u64 rip;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_4[88];
>> +=C2=A0=C2=A0=C2=A0 u64 rsp;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_5[24];
>> +=C2=A0=C2=A0=C2=A0 u64 rax;
>> +=C2=A0=C2=A0=C2=A0 u64 star;
>> +=C2=A0=C2=A0=C2=A0 u64 lstar;
>> +=C2=A0=C2=A0=C2=A0 u64 cstar;
>> +=C2=A0=C2=A0=C2=A0 u64 sfmask;
>> +=C2=A0=C2=A0=C2=A0 u64 kernel_gs_base;
>> +=C2=A0=C2=A0=C2=A0 u64 sysenter_cs;
>> +=C2=A0=C2=A0=C2=A0 u64 sysenter_esp;
>> +=C2=A0=C2=A0=C2=A0 u64 sysenter_eip;
>> +=C2=A0=C2=A0=C2=A0 u64 cr2;
>> +=C2=A0=C2=A0=C2=A0 u8 reserved_6[32];
>> +=C2=A0=C2=A0=C2=A0 u64 g_pat;
>> +=C2=A0=C2=A0=C2=A0 u64 dbgctl;
>> +=C2=A0=C2=A0=C2=A0 u64 br_from;
>> +=C2=A0=C2=A0=C2=A0 u64 br_to;
>> +=C2=A0=C2=A0=C2=A0 u64 last_excp_from;
>> +=C2=A0=C2=A0=C2=A0 u64 last_excp_to;
>> +};
>> +
>> +struct __attribute__ ((__packed__)) vmcb {
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_control_area control;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_save_area save;
>> +};
>> +
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
>> +#define INTERCEPT_CR0_READ=C2=A0=C2=A0=C2=A0 0
>> +#define INTERCEPT_CR3_READ=C2=A0=C2=A0=C2=A0 3
>> +#define INTERCEPT_CR4_READ=C2=A0=C2=A0=C2=A0 4
>> +#define INTERCEPT_CR8_READ=C2=A0=C2=A0=C2=A0 8
>> +#define INTERCEPT_CR0_WRITE=C2=A0=C2=A0=C2=A0 (16 + 0)
>> +#define INTERCEPT_CR3_WRITE=C2=A0=C2=A0=C2=A0 (16 + 3)
>> +#define INTERCEPT_CR4_WRITE=C2=A0=C2=A0=C2=A0 (16 + 4)
>> +#define INTERCEPT_CR8_WRITE=C2=A0=C2=A0=C2=A0 (16 + 8)
>> +
>> +#define INTERCEPT_DR0_READ=C2=A0=C2=A0=C2=A0 0
>> +#define INTERCEPT_DR1_READ=C2=A0=C2=A0=C2=A0 1
>> +#define INTERCEPT_DR2_READ=C2=A0=C2=A0=C2=A0 2
>> +#define INTERCEPT_DR3_READ=C2=A0=C2=A0=C2=A0 3
>> +#define INTERCEPT_DR4_READ=C2=A0=C2=A0=C2=A0 4
>> +#define INTERCEPT_DR5_READ=C2=A0=C2=A0=C2=A0 5
>> +#define INTERCEPT_DR6_READ=C2=A0=C2=A0=C2=A0 6
>> +#define INTERCEPT_DR7_READ=C2=A0=C2=A0=C2=A0 7
>> +#define INTERCEPT_DR0_WRITE=C2=A0=C2=A0=C2=A0 (16 + 0)
>> +#define INTERCEPT_DR1_WRITE=C2=A0=C2=A0=C2=A0 (16 + 1)
>> +#define INTERCEPT_DR2_WRITE=C2=A0=C2=A0=C2=A0 (16 + 2)
>> +#define INTERCEPT_DR3_WRITE=C2=A0=C2=A0=C2=A0 (16 + 3)
>> +#define INTERCEPT_DR4_WRITE=C2=A0=C2=A0=C2=A0 (16 + 4)
>> +#define INTERCEPT_DR5_WRITE=C2=A0=C2=A0=C2=A0 (16 + 5)
>> +#define INTERCEPT_DR6_WRITE=C2=A0=C2=A0=C2=A0 (16 + 6)
>> +#define INTERCEPT_DR7_WRITE=C2=A0=C2=A0=C2=A0 (16 + 7)
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
>> +#define=C2=A0=C2=A0=C2=A0 SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_I=
NTR
>> +#define=C2=A0=C2=A0=C2=A0 SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NM=
I
>> +#define=C2=A0=C2=A0=C2=A0 SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_=
EXEPT
>> +#define=C2=A0=C2=A0=C2=A0 SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_S=
OFT
>> +
>> +#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
>> +#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
>> +
>> +#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
>> +#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
>> +#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
>> +
>> +#define SVM_EXITINFO_REG_MASK 0x0F
>> +
>> +#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>> +
>> +#endif /* SELFTEST_KVM_SVM_H */
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> new file mode 100644
>> index 000000000000..cd037917fece
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> @@ -0,0 +1,38 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * tools/testing/selftests/kvm/include/x86_64/svm_utils.h
>> + * Header for nested SVM testing
>> + *
>> + * Copyright (C) 2020, Red Hat, Inc.
>> + */
>> +
>> +#ifndef SELFTEST_KVM_SVM_UTILS_H
>> +#define SELFTEST_KVM_SVM_UTILS_H
>> +
>> +#include <stdint.h>
>> +#include "svm.h"
>> +#include "processor.h"
>> +
>> +#define CPUID_SVM_BIT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2
>> +#define CPUID_SVM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT_ULL(C=
PUID_SVM_BIT)
>> +
>> +#define SVM_EXIT_VMMCALL=C2=A0=C2=A0=C2=A0 0x081
>> +
>> +struct svm_test_data {
>> +=C2=A0=C2=A0=C2=A0 /* VMCB */
>> +=C2=A0=C2=A0=C2=A0 struct vmcb *vmcb; /* gva */
>> +=C2=A0=C2=A0=C2=A0 void *vmcb_hva;
>> +=C2=A0=C2=A0=C2=A0 uint64_t vmcb_gpa;
>> +
>> +=C2=A0=C2=A0=C2=A0 /* host state-save area */
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_save_area *save_area; /* gva */
>> +=C2=A0=C2=A0=C2=A0 void *save_area_hva;
>> +=C2=A0=C2=A0=C2=A0 uint64_t save_area_gpa;
>> +};
> Looks like vmcb_hva and save_area_hva haven't been used anywhere. Do we
> need them ?
Yes I can remove them for now.
>> +
>> +struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t
>> *p_svm_gva);
>> +void generic_svm_setup(struct svm_test_data *svm, void *guest_rip,
>> void *guest_rsp);
>> +void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
>> +void nested_svm_check_supported(void);
>> +
>> +#endif /* SELFTEST_KVM_SVM_UTILS_H */
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c
>> b/tools/testing/selftests/kvm/lib/x86_64/svm.c
>> new file mode 100644
>> index 000000000000..6e05a8fc3fe0
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
>> @@ -0,0 +1,161 @@
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
>> +#include "svm_util.h"
>> +
>> +struct gpr64_regs guest_regs;
>> +u64 rflags;
>> +
>> +/* Allocate memory regions for nested SVM tests.
>> + *
>> + * Input Args:
>> + *=C2=A0=C2=A0 vm - The VM to allocate guest-virtual addresses in.
>> + *
>> + * Output Args:
>> + *=C2=A0=C2=A0 p_svm_gva - The guest virtual address for the struct s=
vm_test_data.
>> + *
>> + * Return:
>> + *=C2=A0=C2=A0 Pointer to structure with the addresses of the SVM are=
as.
>> + */
>> +struct svm_test_data *
>> +vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
>> +{
>> +=C2=A0=C2=A0=C2=A0 vm_vaddr_t svm_gva =3D vm_vaddr_alloc(vm, getpages=
ize(),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1=
0000, 0, 0);
>> +=C2=A0=C2=A0=C2=A0 struct svm_test_data *svm =3D addr_gva2hva(vm, svm=
_gva);
>> +
>> +=C2=A0=C2=A0=C2=A0 svm->vmcb =3D (void *)vm_vaddr_alloc(vm, getpagesi=
ze(),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x10000, =
0, 0);
>> +=C2=A0=C2=A0=C2=A0 svm->vmcb_hva =3D addr_gva2hva(vm, (uintptr_t)svm-=
>vmcb);
>> +=C2=A0=C2=A0=C2=A0 svm->vmcb_gpa =3D addr_gva2gpa(vm, (uintptr_t)svm-=
>vmcb);
>> +
>> +=C2=A0=C2=A0=C2=A0 svm->save_area =3D (void *)vm_vaddr_alloc(vm, getp=
agesize(),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1=
0000, 0, 0);
>> +=C2=A0=C2=A0=C2=A0 svm->save_area_hva =3D addr_gva2hva(vm, (uintptr_t=
)svm->save_area);
>> +=C2=A0=C2=A0=C2=A0 svm->save_area_gpa =3D addr_gva2gpa(vm, (uintptr_t=
)svm->save_area);
>> +
>> +=C2=A0=C2=A0=C2=A0 *p_svm_gva =3D svm_gva;
>> +=C2=A0=C2=A0=C2=A0 return svm;
>> +}
>> +
>> +static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 u64 base, u32 limit, u32 attr)
>> +{
>> +=C2=A0=C2=A0=C2=A0 seg->selector =3D selector;
>> +=C2=A0=C2=A0=C2=A0 seg->attrib =3D attr;
>> +=C2=A0=C2=A0=C2=A0 seg->limit =3D limit;
>> +=C2=A0=C2=A0=C2=A0 seg->base =3D base;
>> +}
>> +
>> +void generic_svm_setup(struct svm_test_data *svm, void *guest_rip,
>> void *guest_rsp)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct vmcb *vmcb =3D svm->vmcb;
>> +=C2=A0=C2=A0=C2=A0 uint64_t vmcb_gpa =3D svm->vmcb_gpa;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_save_area *save =3D &vmcb->save;
>> +=C2=A0=C2=A0=C2=A0 struct vmcb_control_area *ctrl =3D &vmcb->control;
>> +=C2=A0=C2=A0=C2=A0 u32 data_seg_attr =3D 3 | SVM_SELECTOR_S_MASK | SV=
M_SELECTOR_P_MASK
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | SVM_SELECTOR=
_DB_MASK | SVM_SELECTOR_G_MASK;
>> +=C2=A0=C2=A0=C2=A0 u32 code_seg_attr =3D 9 | SVM_SELECTOR_S_MASK | SV=
M_SELECTOR_P_MASK
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | SVM_SELECTOR_L_MASK | SV=
M_SELECTOR_G_MASK;
>> +=C2=A0=C2=A0=C2=A0 uint64_t efer;
>> +
>> +=C2=A0=C2=A0=C2=A0 efer =3D rdmsr(MSR_EFER);
>> +=C2=A0=C2=A0=C2=A0 wrmsr(MSR_EFER, efer | EFER_SVME);
>> +=C2=A0=C2=A0=C2=A0 wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
>> +
>> +=C2=A0=C2=A0=C2=A0 memset(vmcb, 0, sizeof(*vmcb));
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "m=
emory");
>> +=C2=A0=C2=A0=C2=A0 vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg=
_attr);
>> +=C2=A0=C2=A0=C2=A0 vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg=
_attr);
>> +=C2=A0=C2=A0=C2=A0 vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg=
_attr);
>> +=C2=A0=C2=A0=C2=A0 vmcb_set_seg(&save->ds, get_ds(), 0, -1U, data_seg=
_attr);
>> +=C2=A0=C2=A0=C2=A0 vmcb_set_seg(&save->gdtr, 0, get_gdt().address, ge=
t_gdt().size, 0);
>> +=C2=A0=C2=A0=C2=A0 vmcb_set_seg(&save->idtr, 0, get_idt().address, ge=
t_idt().size, 0);
>> +
>> +=C2=A0=C2=A0=C2=A0 ctrl->asid =3D 1;
>> +=C2=A0=C2=A0=C2=A0 save->cpl =3D 0;
>> +=C2=A0=C2=A0=C2=A0 save->efer =3D rdmsr(MSR_EFER);
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("mov %%cr4, %0" : "=3Dr"(save->cr4) =
: : "memory");
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("mov %%cr3, %0" : "=3Dr"(save->cr3) =
: : "memory");
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("mov %%cr0, %0" : "=3Dr"(save->cr0) =
: : "memory");
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("mov %%dr7, %0" : "=3Dr"(save->dr7) =
: : "memory");
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("mov %%dr6, %0" : "=3Dr"(save->dr6) =
: : "memory");
>> +=C2=A0=C2=A0=C2=A0 asm volatile ("mov %%cr2, %0" : "=3Dr"(save->cr2) =
: : "memory");
>> +=C2=A0=C2=A0=C2=A0 save->g_pat =3D rdmsr(MSR_IA32_CR_PAT);
>> +=C2=A0=C2=A0=C2=A0 save->dbgctl =3D rdmsr(MSR_IA32_DEBUGCTLMSR);
>> +=C2=A0=C2=A0=C2=A0 ctrl->intercept =3D (1ULL << INTERCEPT_VMRUN) |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 (1ULL << INTERCEPT_VMMCALL);
>> +
>> +=C2=A0=C2=A0=C2=A0 vmcb->save.rip =3D (u64)guest_rip;
>> +=C2=A0=C2=A0=C2=A0 vmcb->save.rsp =3D (u64)guest_rsp;
>> +=C2=A0=C2=A0=C2=A0 guest_regs.rdi =3D (u64)svm;
>> +}
>> +
>> +/*
>> + * save/restore 64-bit general registers except rax, rip, rsp
>> + * which are directly handed through the VMCB guest processor state
>> + */
>> +#define SAVE_GPR_C=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%rbx, guest_regs+0x20\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%rcx, guest_regs+0x10\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%rdx, guest_regs+0x18\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%rbp, guest_regs+0x30\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%rsi, guest_regs+0x38\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%rdi, guest_regs+0x40\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r8,=C2=A0 guest_regs+0x48\n\t"=C2=A0=C2=A0=
=C2=A0 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r9,=C2=A0 guest_regs+0x50\n\t"=C2=A0=C2=A0=
=C2=A0 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r10, guest_regs+0x58\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r11, guest_regs+0x60\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r12, guest_regs+0x68\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r13, guest_regs+0x70\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r14, guest_regs+0x78\n\t"=C2=A0=C2=A0=C2=A0=
 \
>> +=C2=A0=C2=A0=C2=A0 "xchg %%r15, guest_regs+0x80\n\t"
>> +
>> +#define LOAD_GPR_C=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SAVE_GPR_C
>> +
>> +/*
>> + * selftests do not use interrupts so we dropped clgi/sti/cli/stgi
>> + * for now. registers involved in LOAD/SAVE_GPR_C are eventually
>> + * unmodified so they do not need to be in the clobber list.
>> + */
>> +void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
>> +{
>> +=C2=A0=C2=A0=C2=A0 asm volatile (
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "vmload\n\t"
> Don't we need to set %rax before calling vmload ?
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov=
 %[vmcb_gpa], %%rax \n\t"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "vml=
oad %%rax\n\t"
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov rflags, %%r15\n\t"=C2=
=A0=C2=A0=C2=A0 // rflags
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov %%r15, 0x170(%[vmcb])=
\n\t"
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov guest_regs, %%r15\n\t=
"=C2=A0=C2=A0=C2=A0 // rax
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov %%r15, 0x1f8(%[vmcb])=
\n\t"
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 LOAD_GPR_C
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "vmrun\n\t"
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SAVE_GPR_C
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov 0x170(%[vmcb]), %%r15=
\n\t"=C2=A0=C2=A0=C2=A0 // rflags
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov %%r15, rflags\n\t"
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov 0x1f8(%[vmcb]), %%r15=
\n\t"=C2=A0=C2=A0=C2=A0 // rax
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mov %%r15, guest_regs\n\t=
"
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "vmsave\n\t"
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : : [vmcb] "r" (vmcb), [vm=
cb_gpa] "a" (vmcb_gpa)
as explained by Vitaly "a" (vmcb_gpa) does the job
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : "r15", "memory");
>> +}
>> +
>> +void nested_svm_check_supported(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct kvm_cpuid_entry2 *entry =3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_get_supported_cpuid_en=
try(0x80000001);
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!(entry->ecx & CPUID_SVM)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "nested SV=
M not enabled, skipping test\n");
> I think a better message would be:
>=20
> =C2=A0=C2=A0=C2=A0 "nested SVM not supported on this CPU, skipping test=
\n"
>=20
> Also, the function should ideally return a boolean and let the callers
> print whatever they want.
This is inspired from nested_vmx_check_supported(). I think this can be
done later on and if we do we can change both messages/proto at the same
time.

Thank you for the review!

Best Regards

Eric
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exit(KSFT_SKIP);
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>> +
>=20

