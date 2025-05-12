Return-Path: <kvm+bounces-46180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD54AB3AF6
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 359D419E237D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B8D22A7F1;
	Mon, 12 May 2025 14:45:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49F51AA791;
	Mon, 12 May 2025 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747061140; cv=none; b=qJk3TXnbSVeR6JJljqFsl/trWT3FVBXRnKNa+QulHK60AlpUr45cVM/Ce9Ibk1FI3nIS6j+6Fvqy5gwyl3Gm/1L8x2jvrYpsYJXOBTX1cldzmUHl285i/SGjq9zIZ9gDK8GB/on0bVCWCRRxqsGcVM2qOFBUlgcR45utipm/6yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747061140; c=relaxed/simple;
	bh=u5dr95GixDsIATIzfH8+P0BjJQyZkXENkW98trzSn/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jc7iuwknuwPKJhJcwisjk0K6ONFndnUSiwBG7cJjLMi4AQpOMFLX44NzCr+W7E/l7umyJXGLMoJQlGMehFjFES5YrD5fbPLtoGOI2t4FokAX5ptps2+NYasejQ9whDBa1GYnfPAbJGEn8kdqchdMmD4DL4CDo/h0Vd9GuWDdcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CD6014BF;
	Mon, 12 May 2025 07:45:27 -0700 (PDT)
Received: from [10.57.21.218] (unknown [10.57.21.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D8883F673;
	Mon, 12 May 2025 07:45:33 -0700 (PDT)
Message-ID: <805af62d-1d3a-4084-8f71-17b58ff0089f@arm.com>
Date: Mon, 12 May 2025 15:45:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-17-steven.price@arm.com>
 <82c0ee14-65fb-4f34-892a-a3820d8d0f97@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <82c0ee14-65fb-4f34-892a-a3820d8d0f97@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 07/05/2025 11:26, Suzuki K Poulose wrote:
> On 16/04/2025 14:41, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>>     been read (although that can never happen in the current code). Tidy
>>     up the condition to handle any future refactoring.
>> Changes since v6:
>>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>     vcpu to the error.
>>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>     this exit type.
>>   * Split code handling a RIPAS change triggered by the guest to the
>>     following patch.
>> Changes since v5:
>>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>     change on next entry rather than immediately on the exit. This allows
>>     the VMM to 'reject' a RIPAS change by refusing to continue
>>     scheduling.
>> Changes since v4:
>>   * Rename handle_rme_exit() to handle_rec_exit()
>>   * Move the loop to copy registers into the REC enter structure from the
>>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>     where the handler exits to user space and user space wants to modify
>>     the GPRS.
>>   * Some code rearrangement in rec_exit_ripas_change().
>> Changes since v2:
>>   * realm_set_ipa_state() now provides an output parameter for the
>>     top_iap that was changed. Use this to signal the VMM with the correct
>>     range that has been transitioned.
>>   * Adapt to previous patch changes.
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |   3 +
>>   arch/arm64/kvm/Makefile          |   2 +-
>>   arch/arm64/kvm/arm.c             |  19 +++-
>>   arch/arm64/kvm/rme-exit.c        | 170 +++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/rme.c             |  19 ++++
>>   5 files changed, 207 insertions(+), 6 deletions(-)
>>   create mode 100644 arch/arm64/kvm/rme-exit.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index b916db8565a2..d86051ef0c5c 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -101,6 +101,9 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>> ia_bits);
>>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>   +int kvm_rec_enter(struct kvm_vcpu *vcpu);
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>> +
>>   void kvm_realm_unmap_range(struct kvm *kvm,
>>                  unsigned long ipa,
>>                  unsigned long size,
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 2ebc66812d49..c4b10012faa3 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -24,7 +24,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o
>> pvtime.o \
>>        vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>>        vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>>        vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
>> -     rme.o
>> +     rme.o rme-exit.o
>>     kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>>   kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 7c0bb1b05f4c..cf707130ef66 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1263,7 +1263,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>           trace_kvm_entry(*vcpu_pc(vcpu));
>>           guest_timing_enter_irqoff();
>>   -        ret = kvm_arm_vcpu_enter_exit(vcpu);
>> +        if (vcpu_is_rec(vcpu))
>> +            ret = kvm_rec_enter(vcpu);
>> +        else
>> +            ret = kvm_arm_vcpu_enter_exit(vcpu);
>>             vcpu->mode = OUTSIDE_GUEST_MODE;
>>           vcpu->stat.exits++;
>> @@ -1319,10 +1322,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
>> *vcpu)
>>             local_irq_enable();
>>   -        trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
>> *vcpu_pc(vcpu));
>> -
>>           /* Exit types that need handling before we can be preempted */
>> -        handle_exit_early(vcpu, ret);
>> +        if (!vcpu_is_rec(vcpu)) {
>> +            trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
>> +                       *vcpu_pc(vcpu));
>> +
>> +            handle_exit_early(vcpu, ret);
>> +        }
> 
> minor nit: Looks like we loose the kvm_exit trace. Could we add
> something in handle_rec_exit ?

I dropped the trace because we can't provide the PC value. I'm not sure
what's best here:

 (1). Provide kvm_exit trace but with a bogus PC.
 (2). Introduce a new 'kvm_rec_exit'.
 (3). Wait until someone comes along with a use-case and hope they
      implement what they need.

Obviously my preference is 3 ;)

In practice I haven't actually dropped kvm_entry (so that has a bogus
PC), so for now I guess I'll go with (1).

>>             preempt_enable();
>>   @@ -1345,7 +1351,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
>> *vcpu)
>>               ret = ARM_EXCEPTION_IL;
>>           }
>>   -        ret = handle_exit(vcpu, ret);
>> +        if (vcpu_is_rec(vcpu))
>> +            ret = handle_rec_exit(vcpu, ret);
>> +        else
>> +            ret = handle_exit(vcpu, ret);
>>       }
>>         /* Tell userspace about in-kernel device output levels */
>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> new file mode 100644
>> index 000000000000..a1adf5610455
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -0,0 +1,170 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <kvm/arm_hypercalls.h>
>> +#include <kvm/arm_psci.h>
>> +
>> +#include <asm/rmi_smc.h>
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_rme.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>> +
>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>> +{
>> +    return kvm_handle_guest_abort(vcpu);
>> +}
>> +
>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long esr = kvm_vcpu_get_esr(vcpu);
>> +    int rt = kvm_vcpu_sys_get_rt(vcpu);
>> +    bool is_write = !(esr & 1);
>> +    int ret;
>> +
>> +    if (is_write)
>> +        vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
>> +
>> +    ret = kvm_handle_sys_reg(vcpu);
>> +    if (ret > 0 && !is_write)
>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
>> +
>> +    return ret;
>> +}
>> +
>> +static exit_handler_fn rec_exit_handlers[] = {
>> +    [0 ... ESR_ELx_EC_MAX]    = rec_exit_reason_notimpl,
>> +    [ESR_ELx_EC_SYS64]    = rec_exit_sys_reg,
>> +    [ESR_ELx_EC_DABT_LOW]    = rec_exit_sync_dabt,
>> +    [ESR_ELx_EC_IABT_LOW]    = rec_exit_sync_iabt
>> +};
>> +
>> +static int rec_exit_psci(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    int i;
>> +
>> +    for (i = 0; i < REC_RUN_GPRS; i++)
>> +        vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
>> +
>> +    return kvm_smccc_call_handler(vcpu);
>> +}
>> +
>> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long base = rec->run->exit.ripas_base;
>> +    unsigned long top = rec->run->exit.ripas_top;
>> +    unsigned long ripas = rec->run->exit.ripas_value;
>> +
>> +    if (!kvm_realm_is_private_address(realm, base) ||
>> +        !kvm_realm_is_private_address(realm, top - 1)) {
>> +        vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx, ripas:
>> %#lx\n",
>> +             base, top, ripas);
> 
> Do we need to set the RMI_REJECT for run->enter.flags
> REC_ENTER_FLAG_RIPAS_RESPONSE ?

Makes sense, will add.

Thanks,
Steve

> Rest looks fine to me.
> 
> Suzuki


