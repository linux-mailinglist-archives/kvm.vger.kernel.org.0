Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB379CC80
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjILJ4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 05:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbjILJz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 05:55:58 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B2751BE;
        Tue, 12 Sep 2023 02:55:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8AxjuuoNQBlEX0lAA--.4929S3;
        Tue, 12 Sep 2023 17:55:52 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxri+lNQBlBZ0AAA--.508S3;
        Tue, 12 Sep 2023 17:55:50 +0800 (CST)
Subject: Re: [PATCH v20 27/30] LoongArch: KVM: Implement vcpu world switch
To:     WANG Xuerui <kernel@xen0n.name>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-28-zhaotianrui@loongson.cn>
 <eff83dfe-5f89-6b46-2197-2873ede705bd@xen0n.name>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <8e88d249-f1fd-2024-e1f1-c63e84ef33ec@loongson.cn>
Date:   Tue, 12 Sep 2023 17:55:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <eff83dfe-5f89-6b46-2197-2873ede705bd@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Cxri+lNQBlBZ0AAA--.508S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoW3Cw15Gw4DAw1xJr4kJFy5trc_yoW8Jw1rJo
        WjgF1FqryrJrWjgr1DGw4UtrW3X3W8GrnFqryUGryxXr18AF15J3yUJFWUtay7Jr1kGr1U
        Ga43Jry0kFyrAr15l-sFpf9Il3svdjkaLaAFLSUrUUUUeb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUO07kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU28nYUU
        UUU
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/9/8 上午4:04, WANG Xuerui 写道:
>
> On 8/31/23 16:30, Tianrui Zhao wrote:
>> Implement LoongArch vcpu world switch, including vcpu enter guest and
>> vcpu exit from guest, both operations need to save or restore the host
>> and guest registers.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kernel/asm-offsets.c |  32 ++++
>>   arch/loongarch/kvm/switch.S         | 255 ++++++++++++++++++++++++++++
>>   2 files changed, 287 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/switch.S
>>
>> diff --git a/arch/loongarch/kernel/asm-offsets.c 
>> b/arch/loongarch/kernel/asm-offsets.c
>> index 505e4bf596..d4bbaa74c1 100644
>> --- a/arch/loongarch/kernel/asm-offsets.c
>> +++ b/arch/loongarch/kernel/asm-offsets.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/mm.h>
>>   #include <linux/kbuild.h>
>>   #include <linux/suspend.h>
>> +#include <linux/kvm_host.h>
>>   #include <asm/cpu-info.h>
>>   #include <asm/ptrace.h>
>>   #include <asm/processor.h>
>> @@ -285,3 +286,34 @@ void output_fgraph_ret_regs_defines(void)
>>       BLANK();
>>   }
>>   #endif
>> +
>> +static void __used output_kvm_defines(void)
>> +{
>> +    COMMENT(" KVM/LOONGARCH Specific offsets. ");
> "LoongArch"?
Thanks, I will fix it.
>> +
>> +    OFFSET(VCPU_FCSR0, kvm_vcpu_arch, fpu.fcsr);
>> +    OFFSET(VCPU_FCC, kvm_vcpu_arch, fpu.fcc);
>> +    BLANK();
>> +
>> +    OFFSET(KVM_VCPU_ARCH, kvm_vcpu, arch);
>> +    OFFSET(KVM_VCPU_KVM, kvm_vcpu, kvm);
>> +    OFFSET(KVM_VCPU_RUN, kvm_vcpu, run);
>> +    BLANK();
>> +
>> +    OFFSET(KVM_ARCH_HSP, kvm_vcpu_arch, host_sp);
>> +    OFFSET(KVM_ARCH_HTP, kvm_vcpu_arch, host_tp);
>> +    OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
>> +    OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
>> +    OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
>> +    OFFSET(KVM_ARCH_GPC, kvm_vcpu_arch, pc);
>> +    OFFSET(KVM_ARCH_GGPR, kvm_vcpu_arch, gprs);
>> +    OFFSET(KVM_ARCH_HESTAT, kvm_vcpu_arch, host_estat);
>> +    OFFSET(KVM_ARCH_HBADV, kvm_vcpu_arch, badv);
>> +    OFFSET(KVM_ARCH_HBADI, kvm_vcpu_arch, badi);
>> +    OFFSET(KVM_ARCH_HECFG, kvm_vcpu_arch, host_ecfg);
>> +    OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
>> +    OFFSET(KVM_ARCH_HPERCPU, kvm_vcpu_arch, host_percpu);
>> +
>> +    OFFSET(KVM_GPGD, kvm, arch.pgd);
>> +    BLANK();
>> +}
>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>> new file mode 100644
>> index 0000000000..f637fcd56c
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/switch.S
>> @@ -0,0 +1,255 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/linkage.h>
>> +#include <asm/stackframe.h>
>> +#include <asm/asm.h>
>> +#include <asm/asmmacro.h>
>> +#include <asm/regdef.h>
>> +#include <asm/loongarch.h>
>> +
>> +#define PT_GPR_OFFSET(x)    (PT_R0 + 8*x)
>> +#define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
>> +
>> +.macro kvm_save_host_gpr base
>> +    .irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
>> +    st.d    $r\n, \base, PT_GPR_OFFSET(\n)
>> +    .endr
>> +.endm
>> +
>> +.macro kvm_restore_host_gpr base
>> +    .irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
>> +    ld.d    $r\n, \base, PT_GPR_OFFSET(\n)
>> +    .endr
>> +.endm
>> +
>> +/*
>> + * save and restore all gprs except base register,
>> + * and default value of base register is a2.
>> + */
>> +.macro kvm_save_guest_gprs base
>> +    .irp 
>> n,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
>> +    st.d    $r\n, \base, GGPR_OFFSET(\n)
>> +    .endr
>> +.endm
>> +
>> +.macro kvm_restore_guest_gprs base
>> +    .irp 
>> n,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
>> +    ld.d    $r\n, \base, GGPR_OFFSET(\n)
>> +    .endr
>> +.endm
>> +
>> +/*
>> + * prepare switch to guest, save host reg and restore guest reg.
>> + * a2: kvm_vcpu_arch, don't touch it until 'ertn'
>> + * t0, t1: temp register
>> + */
>> +.macro kvm_switch_to_guest
>> +    /* set host excfg.VS=0, all exceptions share one exception entry */
>> +    csrrd        t0, LOONGARCH_CSR_ECFG
>> +    bstrins.w    t0, zero, CSR_ECFG_VS_SHIFT_END, CSR_ECFG_VS_SHIFT
>> +    csrwr        t0, LOONGARCH_CSR_ECFG
>> +
>> +    /* Load up the new EENTRY */
>> +    ld.d    t0, a2, KVM_ARCH_GEENTRY
>> +    csrwr    t0, LOONGARCH_CSR_EENTRY
>> +
>> +    /* Set Guest ERA */
>> +    ld.d    t0, a2, KVM_ARCH_GPC
>> +    csrwr    t0, LOONGARCH_CSR_ERA
>> +
>> +    /* Save host PGDL */
>> +    csrrd    t0, LOONGARCH_CSR_PGDL
>> +    st.d    t0, a2, KVM_ARCH_HPGD
>> +
>> +    /* Switch to kvm */
>> +    ld.d    t1, a2, KVM_VCPU_KVM - KVM_VCPU_ARCH
>> +
>> +    /* Load guest PGDL */
>> +    li.w    t0, KVM_GPGD
>> +    ldx.d   t0, t1, t0
>> +    csrwr    t0, LOONGARCH_CSR_PGDL
>> +
>> +    /* Mix GID and RID */
>> +    csrrd        t1, LOONGARCH_CSR_GSTAT
>> +    bstrpick.w    t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
>> +    csrrd        t0, LOONGARCH_CSR_GTLBC
>> +    bstrins.w    t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
>> +    csrwr        t0, LOONGARCH_CSR_GTLBC
>> +
>> +    /*
>> +     * Switch to guest:
>> +     *  GSTAT.PGM = 1, ERRCTL.ISERR = 0, TLBRPRMD.ISTLBR = 0
>> +     *  ertn
>> +     */
>> +
>> +    /*
>> +     * Enable intr in root mode with future ertn so that host interrupt
>> +     * can be responsed during VM runs
>> +     * guest crmd comes from separate gcsr_CRMD register
>> +     */
>> +    ori    t0, zero, CSR_PRMD_PIE
> Use "li.w" like the place several lines before?
Thanks for the advice, and this issue has been discussed before, and the 
conclusion is that it need not replace "ori" with the pseudo instruction 
like "li.w", as it has the same meaning.
>> +    csrxchg    t0, t0, LOONGARCH_CSR_PRMD
>> +
>> +    /* Set PVM bit to setup ertn to guest context */
>> +    ori    t0, zero, CSR_GSTAT_PVM
> Similarly here...
>> +    csrxchg    t0, t0, LOONGARCH_CSR_GSTAT
>> +
>> +    /* Load Guest gprs */
>> +    kvm_restore_guest_gprs a2
>> +    /* Load KVM_ARCH register */
>> +    ld.d    a2, a2,    (KVM_ARCH_GGPR + 8 * REG_A2)
>> +
>> +    ertn
>> +.endm
>> +
>> +    /*
>> +     * exception entry for general exception from guest mode
>> +     *  - IRQ is disabled
>> +     *  - kernel privilege in root mode
>> +     *  - page mode keep unchanged from previous prmd in root mode
>> +     *  - Fixme: tlb exception cannot happen since registers 
>> relative with TLB
>> +     *  -        is still in guest mode, such as pgd table/vmid 
>> registers etc,
>> +     *  -        will fix with hw page walk enabled in future
>> +     * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to 
>> KVM_TEMP_KS
>> +     */
>> +    .text
>> +    .cfi_sections    .debug_frame
>> +SYM_CODE_START(kvm_vector_entry)
>> +    csrwr    a2,   KVM_TEMP_KS
>> +    csrrd    a2,   KVM_VCPU_KS
>> +    addi.d    a2,   a2, KVM_VCPU_ARCH
>> +
>> +    /* After save gprs, free to use any gpr */
>> +    kvm_save_guest_gprs a2
>> +    /* Save guest a2 */
>> +    csrrd    t0,    KVM_TEMP_KS
>> +    st.d    t0,    a2,    (KVM_ARCH_GGPR + 8 * REG_A2)
>> +
>> +    /* a2: kvm_vcpu_arch, a1 is free to use */
>> +    csrrd    s1,   KVM_VCPU_KS
>> +    ld.d    s0,   s1, KVM_VCPU_RUN
>> +
>> +    csrrd    t0,   LOONGARCH_CSR_ESTAT
>> +    st.d    t0,   a2, KVM_ARCH_HESTAT
>> +    csrrd    t0,   LOONGARCH_CSR_ERA
>> +    st.d    t0,   a2, KVM_ARCH_GPC
>> +    csrrd    t0,   LOONGARCH_CSR_BADV
>> +    st.d    t0,   a2, KVM_ARCH_HBADV
>> +    csrrd    t0,   LOONGARCH_CSR_BADI
>> +    st.d    t0,   a2, KVM_ARCH_HBADI
>> +
>> +    /* Restore host excfg.VS */
>> +    csrrd    t0, LOONGARCH_CSR_ECFG
>> +    ld.d    t1, a2, KVM_ARCH_HECFG
>> +    or    t0, t0, t1
>> +    csrwr    t0, LOONGARCH_CSR_ECFG
>> +
>> +    /* Restore host eentry */
>> +    ld.d    t0, a2, KVM_ARCH_HEENTRY
>> +    csrwr    t0, LOONGARCH_CSR_EENTRY
>> +
>> +    /* restore host pgd table */
>> +    ld.d    t0, a2, KVM_ARCH_HPGD
>> +    csrwr   t0, LOONGARCH_CSR_PGDL
>> +
>> +    /*
>> +     * Disable PGM bit to enter root mode by default with next ertn
>> +     */
>> +    ori    t0, zero, CSR_GSTAT_PVM
> And here.
>> +    csrxchg    zero, t0, LOONGARCH_CSR_GSTAT
>> +    /*
>> +     * Clear GTLBC.TGID field
>> +     *       0: for root  tlb update in future tlb instr
>> +     *  others: for guest tlb update like gpa to hpa in future tlb 
>> instr
>> +     */
>> +    csrrd    t0, LOONGARCH_CSR_GTLBC
>> +    bstrins.w    t0, zero, CSR_GTLBC_TGID_SHIFT_END, 
>> CSR_GTLBC_TGID_SHIFT
>> +    csrwr    t0, LOONGARCH_CSR_GTLBC
>> +    ld.d    tp, a2, KVM_ARCH_HTP
>> +    ld.d    sp, a2, KVM_ARCH_HSP
>> +    /* restore per cpu register */
>> +    ld.d    u0, a2, KVM_ARCH_HPERCPU
>> +    addi.d    sp, sp, -PT_SIZE
>> +
>> +    /* Prepare handle exception */
>> +    or    a0, s0, zero
>> +    or    a1, s1, zero
> Similarly "move X, Y" should be clearer here.
>> +    ld.d    t8, a2, KVM_ARCH_HANDLE_EXIT
>> +    jirl    ra, t8, 0
>> +
>> +    or    a2, s1, zero
>> +    addi.d    a2, a2, KVM_VCPU_ARCH
>> +
>> +    /* resume host when ret <= 0 */
>> +    bge    zero, a0, ret_to_host
> "blez a0, ret_to_host"
>> +
>> +    /*
>> +         * return to guest
>> +         * save per cpu register again, maybe switched to another cpu
>> +         */
>> +    st.d    u0, a2, KVM_ARCH_HPERCPU
>> +
>> +    /* Save kvm_vcpu to kscratch */
>> +    csrwr    s1, KVM_VCPU_KS
>> +    kvm_switch_to_guest
>> +
>> +ret_to_host:
>> +    ld.d    a2, a2, KVM_ARCH_HSP
>> +    addi.d  a2, a2, -PT_SIZE
>> +    kvm_restore_host_gpr    a2
>> +    jr      ra
>> +
>> +SYM_INNER_LABEL(kvm_vector_entry_end, SYM_L_LOCAL)
>> +SYM_CODE_END(kvm_vector_entry)
>> +
>> +/*
>> + * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
>> + *
>> + * @register_param:
>> + *  a0: kvm_run* run
>> + *  a1: kvm_vcpu* vcpu
>> + */
>> +SYM_FUNC_START(kvm_enter_guest)
>> +    /* allocate space in stack bottom */
>> +    addi.d    a2, sp, -PT_SIZE
>> +    /* save host gprs */
>> +    kvm_save_host_gpr a2
>> +
>> +    /* save host crmd,prmd csr to stack */
>> +    csrrd    a3, LOONGARCH_CSR_CRMD
>> +    st.d    a3, a2, PT_CRMD
>> +    csrrd    a3, LOONGARCH_CSR_PRMD
>> +    st.d    a3, a2, PT_PRMD
>> +
>> +    addi.d    a2, a1, KVM_VCPU_ARCH
>> +    st.d    sp, a2, KVM_ARCH_HSP
>> +    st.d    tp, a2, KVM_ARCH_HTP
>> +    /* Save per cpu register */
>> +    st.d    u0, a2, KVM_ARCH_HPERCPU
>> +
>> +    /* Save kvm_vcpu to kscratch */
>> +    csrwr    a1, KVM_VCPU_KS
>> +    kvm_switch_to_guest
>> +SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
>> +SYM_FUNC_END(kvm_enter_guest)
>> +
>> +SYM_FUNC_START(kvm_save_fpu)
>> +    fpu_save_csr    a0 t1
>> +    fpu_save_double a0 t1
>> +    fpu_save_cc    a0 t1 t2
>> +    jr              ra
>> +SYM_FUNC_END(kvm_save_fpu)
>> +
>> +SYM_FUNC_START(kvm_restore_fpu)
>> +    fpu_restore_double a0 t1
>> +    fpu_restore_csr    a0 t1
> This needs to become "fpu_restore_csr a0 t1 t2" after commit 
> bd3c5798484a ("LoongArch: Add Loongson Binary Translation (LBT) 
> extension support") which is slated for Linux 6.6 and already inside 
> linux-next.
I will update it.

Thanks
Tianrui Zhao
>> +    fpu_restore_cc       a0 t1 t2
>> +    jr                 ra
>> +SYM_FUNC_END(kvm_restore_fpu)
>> +
>> +    .section ".rodata"
>> +SYM_DATA(kvm_vector_size, .quad kvm_vector_entry_end - 
>> kvm_vector_entry)
>> +SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - 
>> kvm_enter_guest)
>

