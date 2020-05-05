Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2FD1C544D
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgEELX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:23:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43938 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728233AbgEELX6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 07:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588677836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=An1TQbkAZLM02pJPe45UyHhgYjOOpMP1wtr1k+j8owo=;
        b=jCMGUbWI2bsHCNKFSggXA1Hw38r5d784Kujrp9r3mtwMyB7ThI0531xo2eygWhEoVaLn5S
        FQkiuzOAOehpCLftprznIh3b+83N3I5wev3VdgJqJ0a6ylarikopAB+/Z11tMO5ZrZpS6D
        s0d6QJyT25W0kIy+MTHzju5CGg2wXvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-wMGo37SfNk66VgI8OzLXRw-1; Tue, 05 May 2020 07:23:54 -0400
X-MC-Unique: wMGo37SfNk66VgI8OzLXRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FC625E4;
        Tue,  5 May 2020 11:23:52 +0000 (UTC)
Received: from localhost (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBCDC600F5;
        Tue,  5 May 2020 11:23:44 +0000 (UTC)
Date:   Tue, 5 May 2020 13:23:42 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <peter.maydell@linaro.org>, <shannon.zhaosl@gmail.com>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
        <pbonzini@redhat.com>, <zhengxiang9@huawei.com>,
        <Jonathan.Cameron@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH v25 09/10] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
Message-ID: <20200505124838.0e7e13b0@redhat.com>
In-Reply-To: <20200410114639.32844-10-gengdongjiu@huawei.com>
References: <20200410114639.32844-1-gengdongjiu@huawei.com>
 <20200410114639.32844-10-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 19:46:38 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> translates the host VA delivered by host to guest PA, then fills this PA
> to guest APEI GHES memory, then notifies guest according to the SIGBUS
> type.
> 
> When guest accesses the poisoned memory, it will generate a Synchronous
> External Abort(SEA). Then host kernel gets an APEI notification and calls
> memory_failure() to unmapped the affected page in stage 2, finally
> returns to guest.
> 
> Guest continues to access the PG_hwpoison page, it will trap to KVM as
> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> Qemu, Qemu records this error address into guest APEI GHES memory and
> notifes guest using Synchronous-External-Abort(SEA).
> 
> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
> in which we can setup the type of exception and the syndrome information.
> When switching to guest, the target vcpu will jump to the synchronous
> external abort vector table entry.
> 
> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
> not valid and hold an UNKNOWN value. These values will be set to KVM
> register structures through KVM_SET_ONE_REG IOCTL.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  include/sysemu/kvm.h    |  3 +-
>  target/arm/cpu.h        |  4 +++
>  target/arm/helper.c     |  2 +-
>  target/arm/internals.h  |  5 ++--
>  target/arm/kvm64.c      | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
>  target/arm/tlb_helper.c |  2 +-
>  target/i386/cpu.h       |  2 ++
>  7 files changed, 89 insertions(+), 6 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 141342d..3b22504 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -379,8 +379,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
>  unsigned long kvm_arch_vcpu_id(CPUState *cpu);
>  
> -#ifdef TARGET_I386
> -#define KVM_HAVE_MCE_INJECTION 1
> +#ifdef KVM_HAVE_MCE_INJECTION
>  void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>  #endif
>  
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 8b9f296..6a9838d 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -28,6 +28,10 @@
>  /* ARM processors have a weak memory model */
>  #define TCG_GUEST_DEFAULT_MO      (0)
>  
> +#ifdef TARGET_AARCH64
> +#define KVM_HAVE_MCE_INJECTION 1
> +#endif
> +
>  #define EXCP_UDEF            1   /* undefined instruction */
>  #define EXCP_SWI             2   /* software interrupt */
>  #define EXCP_PREFETCH_ABORT  3
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 163c91a..b2c30f2 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -3517,7 +3517,7 @@ static uint64_t do_ats_write(CPUARMState *env, uint64_t value,
>               * Report exception with ESR indicating a fault due to a
>               * translation table walk for a cache maintenance instruction.
>               */
> -            syn = syn_data_abort_no_iss(current_el == target_el,
> +            syn = syn_data_abort_no_iss(current_el == target_el, 0,
>                                          fi.ea, 1, fi.s1ptw, 1, fsc);
>              env->exception.vaddress = value;
>              env->exception.fsr = fsr;
> diff --git a/target/arm/internals.h b/target/arm/internals.h
> index e633aff..37c22a9 100644
> --- a/target/arm/internals.h
> +++ b/target/arm/internals.h
> @@ -451,13 +451,14 @@ static inline uint32_t syn_insn_abort(int same_el, int ea, int s1ptw, int fsc)
>          | ARM_EL_IL | (ea << 9) | (s1ptw << 7) | fsc;
>  }
>  
> -static inline uint32_t syn_data_abort_no_iss(int same_el,
> +static inline uint32_t syn_data_abort_no_iss(int same_el, int fnv,
>                                               int ea, int cm, int s1ptw,
>                                               int wnr, int fsc)
>  {
>      return (EC_DATAABORT << ARM_EL_EC_SHIFT) | (same_el << ARM_EL_EC_SHIFT)
>             | ARM_EL_IL
> -           | (ea << 9) | (cm << 8) | (s1ptw << 7) | (wnr << 6) | fsc;
> +           | (fnv << 10) | (ea << 9) | (cm << 8) | (s1ptw << 7)
> +           | (wnr << 6) | fsc;
>  }
>  
>  static inline uint32_t syn_data_abort_with_iss(int same_el,
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index be5b31c..d53f7f2 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -28,6 +28,9 @@
>  #include "sysemu/kvm_int.h"
>  #include "kvm_arm.h"
>  #include "internals.h"
> +#include "hw/acpi/acpi.h"
> +#include "hw/acpi/ghes.h"
> +#include "hw/arm/virt.h"
>  
>  static bool have_guest_debug;
>  
> @@ -893,6 +896,30 @@ int kvm_arm_cpreg_level(uint64_t regidx)
>      return KVM_PUT_RUNTIME_STATE;
>  }
>  
> +/* Callers must hold the iothread mutex lock */
> +static void kvm_inject_arm_sea(CPUState *c)
> +{
> +    ARMCPU *cpu = ARM_CPU(c);
> +    CPUARMState *env = &cpu->env;
> +    CPUClass *cc = CPU_GET_CLASS(c);
> +    uint32_t esr;
> +    bool same_el;
> +
> +    c->exception_index = EXCP_DATA_ABORT;
> +    env->exception.target_el = 1;
> +
> +    /*
> +     * Set the DFSC to synchronous external abort and set FnV to not valid,
> +     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
> +     */
> +    same_el = arm_current_el(env) == env->exception.target_el;
> +    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
> +
> +    env->exception.syndrome = esr;
> +
> +    cc->do_interrupt(c);
> +}
> +
>  #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>                   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
>  
> @@ -1326,6 +1353,56 @@ int kvm_arch_get_registers(CPUState *cs)
>      return ret;
>  }
>  
> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> +{
> +    ram_addr_t ram_addr;
> +    hwaddr paddr;
> +    Object *obj = qdev_get_machine();
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +    bool acpi_enabled = virt_is_acpi_enabled(vms);
> +
> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> +
> +    if (acpi_enabled && addr &&
> +            object_property_get_bool(obj, "ras", NULL)) {
> +        ram_addr = qemu_ram_addr_from_host(addr);
> +        if (ram_addr != RAM_ADDR_INVALID &&
> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> +            kvm_hwpoison_page_add(ram_addr);
> +            /*
> +             * If this is a BUS_MCEERR_AR, we know we have been called
> +             * synchronously from the vCPU thread, so we can easily
> +             * synchronize the state and inject an error.
> +             *
> +             * TODO: we currently don't tell the guest at all about
> +             * BUS_MCEERR_AO. In that case we might either be being
> +             * called synchronously from the vCPU thread, or a bit
> +             * later from the main thread, so doing the injection of
> +             * the error would be more complicated.
> +             */
> +            if (code == BUS_MCEERR_AR) {
> +                kvm_cpu_synchronize_state(c);
> +                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> +                    kvm_inject_arm_sea(c);
> +                } else {
> +                    error_report("failed to record the error");
> +                    abort();
> +                }
> +            }
> +            return;
> +        }
> +        if (code == BUS_MCEERR_AO) {
> +            error_report("Hardware memory error at addr %p for memory used by "
> +                "QEMU itself instead of guest system!", addr);
> +        }
> +    }
> +
> +    if (code == BUS_MCEERR_AR) {
> +        error_report("Hardware memory error!");
> +        exit(1);
> +    }
> +}
> +
>  /* C6.6.29 BRK instruction */
>  static const uint32_t brk_insn = 0xd4200000;
>  
> diff --git a/target/arm/tlb_helper.c b/target/arm/tlb_helper.c
> index e63f8bd..7388494 100644
> --- a/target/arm/tlb_helper.c
> +++ b/target/arm/tlb_helper.c
> @@ -33,7 +33,7 @@ static inline uint32_t merge_syn_data_abort(uint32_t template_syn,
>       * ISV field.
>       */
>      if (!(template_syn & ARM_EL_ISV) || target_el != 2 || s1ptw) {
> -        syn = syn_data_abort_no_iss(same_el,
> +        syn = syn_data_abort_no_iss(same_el, 0,
>                                      ea, 0, s1ptw, is_write, fsc);
>      } else {
>          /*
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index e818fc7..408392d 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -29,6 +29,8 @@
>  /* The x86 has a strong memory model with some store-after-load re-ordering */
>  #define TCG_GUEST_DEFAULT_MO      (TCG_MO_ALL & ~TCG_MO_ST_LD)
>  
> +#define KVM_HAVE_MCE_INJECTION 1
> +
>  /* Maximum instruction code size */
>  #define TARGET_MAX_INSN_SIZE 16
>  

